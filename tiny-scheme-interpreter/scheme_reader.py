

from scheme_tokens import *
from buffer import *

# Pairs and Scheme lists

class Pair:

    def __init__(self, first, second):
        self.first = first
        self.second = second

    def __repr__(self):
        return "Pair({0}, {1})".format(repr(self.first), repr(self.second))

    def __str__(self):
        s = "(" + str(self.first)
        second = self.second
        while isinstance(second, Pair):
            s += " " + str(second.first)
            second = second.second
        if second is not nil:
            raise TypeError("PAIR_STR_: the last element of the pair must be NULL")
        return s + ")"

    def __len__(self):
        n, second = 1, self.second
        while isinstance(second, Pair):
            n += 1
            second = second.second
        if second is not nil:
            raise TypeError("PAIR_LEN_: the last element of the pair must be NULL")
        return n

    def __eq__(self, p):
        if not isinstance(p, Pair):
            return False
        return self.first == p.first and self.second == p.second

    def map(self, fn):
        """Return a Scheme list after mapping Python function FN to SELF."""
        mapped = fn(self.first)
        if self.second is nil or isinstance(self.second, Pair):
            return Pair(mapped, self.second.map(fn))
        else:
            raise TypeError("PAIR_MAP_: invalid pair list")

class nil:
    """The empty list"""

    def __repr__(self):
        return "nil"

    def __str__(self):
        return "()"

    def __len__(self):
        return 0

    def map(self, fn):
        return self

nil = nil()
# Assignment hides the nil class; there is only one instance



# 建立语法树
def scheme_read(src):
    """Read the next expression from SRC, a Buffer of tokens.
    >>> lines = ["(+ 1 ", "(+ 23 4)) ("]
    >>> src = Buffer(tokenize_lines(lines))
    >>> print(scheme_read(src))
    (+ 1 (+ 23 4))
    """
    if src.current() is None:
        raise EOFError('unexpected EOF')
    val = src.pop()
    if val not in DELIMITERS:
        return val
    elif val == "(":
        return read_tail(src)
    else:
        raise SyntaxError("READ: invalid token: {0}".format(val))

def read_tail(src):
    """Return the remainder of a list in SRC, starting before an element or ).
    >>> read_tail(Buffer(tokenize_lines([")"])))
    nil
    >>> read_tail(Buffer(tokenize_lines(["2 (3 4))"])))
    Pair(2, Pair(Pair(3, Pair(4, nil)), nil))
    """

    if src.current() is None:
        raise EOFError('unexpected EOF')
    elif src.current() == ")":
        src.pop()
        return nil
    else:
        first = scheme_read(src)
        rest = read_tail(src)
        return Pair(first, rest)


