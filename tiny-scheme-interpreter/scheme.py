
from scheme_primitives import *
from scheme_reader import *
import re
######################
# some help function #
######################


class SchemeError(Exception):
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return repr(self.value)

def check_form(expr, min, max=float('inf')):
    """check the number of the args in range or not"""
    length = len(expr)
    if length < min:
        raise SchemeError("too few args")
    elif length > max:
        raise SchemeError("too many args")

def check_formals(formals):
    """the args must be symbol(identifier), and the args should be unique"""
    paras = formals
    scanned_paras = []
    while paras is not nil:
        if (not isinstance(paras.first, str)) or paras.first in scanned_paras:
            raise SchemeError('the args must be symbol(identifier), and the args should be unique')
        else:
            scanned_paras += [paras.first]
            paras = paras.second
    return

def can_self_evaluating(x):
    if x is True or x is False:
        return True
    elif isinstance(x, (int, float)):
        return True
    elif x is nil or x is None:
        return True
    else:
        return False

def scheme_eval(expr, env):
    # Atoms
    if isinstance(expr, str):
        return env.lookup(expr)
    elif can_self_evaluating(expr):
        return expr
    # Combinations
    first, rest = expr.first, expr.second
    if isinstance(first, str) and first in SPECIAL_FORMS:
        result = SPECIAL_FORMS[first](rest, env)
    else:
        procedure = scheme_eval(first, env)
        if not isinstance(procedure, Procedure):
            raise SchemeError('First arg:{0} not callable'.format(repr(procedure)))
        result = procedure.eval_call(rest, env)
    return result


def eval_all(expressions, env):
    if expressions is nil:
        return
    expr = expressions
    while expr is not nil:
        value = scheme_eval(expr.first, env)
        expr = expr.second
    return value


class Frame:
    def __init__(self, parent):
        self.bindings = {}
        self.parent = parent

    def __repr__(self):
        if self.parent is None:
            return "<Global Frame>"
        else:
            s = sorted(('{0}: {1}'.format(k, v) for k, v in self.bindings.items()))
            return "<{{{0}}} -> {1}>".format(', '.join(s), repr(self.parent))

    def lookup(self, symbol):
        if symbol in self.bindings:
            return self.bindings[symbol]
        elif self.parent is not None:
            return self.parent.lookup(symbol)
        else:
            raise SchemeError('Undefined symbol :{}'.format(repr(symbol)))

    def define(self, symbol, value):
        self.bindings[symbol] = value


class Procedure:
    def eval_call(self, arg_exprs, env):
        args = arg_exprs.map(lambda operand: scheme_eval(operand, env))
        return self.apply(args, env)


class PrimitiveProcedure(Procedure):
    def __init__(self, fn):
        self.fn = fn

    def __repr__(self):
        return '#[{}]'.format('primitive')

    def apply(self, args, env):
        python_args = []
        while args is not nil:
            python_args.append(args.first)
            args = args.second
        return self.fn(*python_args)


class LambdaProcedure(Procedure):
    def __init__(self, formals, body, env):

        self.formals = formals
        self.body = body
        self.env = env

    def make_call_frame(self, args):
        child = Frame(self.env)
        if self.formals is nil:
            return child
        expr = self.formals
        values = args
        if len(expr) != len(values):
            raise SchemeError('Lambda: number of parameters argument should be equal.')
        while expr is not nil:
            child.define(expr.first, values.first)
            expr = expr.second
            values = values.second
        return child

    def __repr__(self):
        return "LambdaProcedure({!r}, {!r}, {!r})".format(
            self.formals, self.body, self.env)

    def apply(self, args, env):
        new_env = self.make_call_frame(args)
        return eval_all(self.body, new_env)

# ###########################-SPECIAL_FORMS-############################


def do_define_form(expressions, env):
    target = expressions.first
    if isinstance(target, str):
        check_form(expressions, 2, 2)
        env.define(expressions.first, scheme_eval(expressions.second.first, env))
        return expressions.first
    elif isinstance(target, Pair) and scheme_symbolp(target.first):
        # isinstance(target, Pair) and isinstance(target.first, str):
        lambda_name = LambdaProcedure(target.second, expressions.second, env)
        env.define(target.first, lambda_name)
        return target.first
    else:
        bad = target.first if isinstance(target, Pair) else target
        raise SchemeError("Not a symbol(identifier): {}".format(bad))


def do_lambda_form(expressions, env):
    check_form(expressions, 2)
    check_formals(expressions.first)
    lambda_name = LambdaProcedure(expressions.first, expressions.second, env)
    return lambda_name


def do_if_form(expressions, env):
    check_form(expressions, 2, 3)
    # All values in Scheme are true except False.
    if scheme_eval(expressions.first, env) is not False:
        return scheme_eval(expressions.second.first, env)
    else:
        if expressions.second.second is nil:
            return 
        else:
            return scheme_eval(expressions.second.second.first, env)


def do_and_form(expressions, env):

    if expressions is nil:
        return True
    expr = expressions
    while expr is not nil:
        value = scheme_eval(expr.first, env)
        # Only False is false in Scheme.
        if value is False:
            return False
        expr = expr.second
    return value


def do_or_form(expressions, env):

    expr = expressions
    while expr is not nil:
        value = scheme_eval(expr.first, env)
        if value is not False:

            return value
        expr = expr.second
    return False


def do_cond_form(expressions, env):
    """Evaluate a cond form."""

    i = 0
    test = False
    while expressions is not nil:
        clause = expressions.first
        check_form(clause, 1)
        if clause.first == "else":
            return True if clause.second is nil else eval_all(clause.second, env)

        clause_cond = scheme_eval(clause.first, env)
        if clause_cond is not False:
            if clause.second is nil:
                return clause_cond
            else:
                return eval_all(clause.second, env)
        expressions = expressions.second
        i += 1
    if not test:
        return
    else:
        return True

SPECIAL_FORMS = {
    "and": do_and_form,
    "define": do_define_form,
    "if": do_if_form,
    "lambda": do_lambda_form,
    "or": do_or_form,
    "cond": do_cond_form,
}

# ###########################-create_global_frame-############################


def add_primitives(frame, funcs_and_names):
    for name, fn in funcs_and_names:
        frame.define(name, PrimitiveProcedure(fn))


def create_global_frame():
    env = Frame(None)
    add_primitives(env, PRIMITIVES)
    return env


# ###########################-MAIN-cases############################

def load_file(command):
    filename = re.split(r'\s+', command)[1]
    f = open(filename, 'r', encoding='utf-8')
    lines = [line[:-1] for line in f]
    lines = ['('] + lines + [')']
    src = Buffer(tokenize_lines(lines))
    expr = scheme_read(src)
    return eval_all(expr, env)

global_cache = []

def is_done():
    global global_cache
    counter = 0
    for string in global_cache:
        for char in string:
            if char == '(' or char == '[':
                counter += 1
            elif char == ')' or char == ']':
                counter -= 1
            else:
                pass
    if counter == 0:
        return True
    else:
        return False

if __name__ == '__main__':
    print('Tiny Scheme interpreter _Author ZhangLanqing')
    print("Use Command 'load filename' to load a *.scm file")
    env = create_global_frame()

    while True:
        global_cache = []
        line_number = 0
        file_flag = False

        while True:
            if line_number == 0:
                s = input('>>> ')
                if s.strip(' ') == '': continue
                if s.strip(' ').startswith('load'):
                    print(load_file(s.strip()))
                    file_flag = True
                    break
            else:
                s = input('    ')
            line_number += 1

            global_cache.append(s)
            if is_done():
                break

        if file_flag == False:
            src = Buffer(tokenize_lines(global_cache))
            expr = scheme_read(src)
            print(scheme_eval(expr, env))



