"""This module implements the primitives of the Scheme language."""

import math
import operator

########################
# Primitive Operations #
########################

PRIMITIVES = []


def _arith(fn, init, vals):
    """Perform the fn fneration on the number values of VALS, with INIT as
    the value when VALS is empty. Returns the result as a Scheme value."""

    s = init
    for val in vals:
        s = fn(s, val)
    if round(s) == s:
        s = round(s)
    return s


def scheme_add(*vals):
    return _arith(operator.add, 0, vals)


def scheme_sub(val0, *vals):
    if len(vals) == 0:
        return -val0
    return _arith(operator.sub, val0, vals)


def scheme_mul(*vals):
    return _arith(operator.mul, 1, vals)


def scheme_div(val0, *vals):
    if len(vals) == 0:
        return 1 / val0
    return _arith(operator.truediv, val0, vals)


def _numcomp(op, x, y):
    return op(x, y)


def scheme_eq(x, y):
    return _numcomp(operator.eq, x, y)


def scheme_lt(x, y):
    return _numcomp(operator.lt, x, y)


def scheme_gt(x, y):
    return _numcomp(operator.gt, x, y)


def scheme_le(x, y):
    return _numcomp(operator.le, x, y)


def scheme_ge(x, y):
    return _numcomp(operator.ge, x, y)

PRIMITIVES.append(("+", scheme_add))
PRIMITIVES.append(("-", scheme_sub))
PRIMITIVES.append(("*", scheme_mul))
PRIMITIVES.append(("/", scheme_div))
PRIMITIVES.append(("=", scheme_eq))
PRIMITIVES.append(("<", scheme_lt))
PRIMITIVES.append((">", scheme_gt))
PRIMITIVES.append(("<=", scheme_le))
PRIMITIVES.append((">=", scheme_ge))


def number_fn(module, name):
    """A Scheme primitive for the named fn in module, which takes numbers."""
    py_fn = getattr(module, name)
    def scheme_fn(*vals):

        return py_fn(*vals)
    return scheme_fn

# Add number functions in the math module as Scheme primitives
for _name in ["acos", "acosh", "asin", "asinh", "atan", "atan2", "atanh",
              "ceil", "copysign", "cos", "cosh", "degrees", "floor", "log",
              "log10", "log1p", "log2", "radians", "sin", "sinh", "sqrt",
              "tan", "tanh", "trunc"]:
    PRIMITIVES.append((_name, number_fn(math, _name)))


