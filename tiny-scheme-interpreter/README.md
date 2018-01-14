# Part I

### Sketch

- Tiny-scheme is an interpreter of the Scheme programming language.
- The features which have been implemented are just a subset of a real Scheme.

 
### Features

- simplest operations:

```
"+, - * / = > < >= <=". (true divison but floor divison).
```

- Python3.4+ built-in math operations: 

```
"acos", "acosh", "asin", "asinh", "atan", "atan2", "atanh",
"ceil", "copysign", "cos", "cosh", "degrees", "floor", "log",
"log10", "log1p", "log2", "radians", "sin", "sinh", "sqrt",
"tan", "tanh", "trunc"
```
- specail forms supported:

```
"lambda", "define", "if", "cond", "or", "and"
```

# Part II

### Usage

- Run this program and you will get a Read-Eval-Print-Loop(REPL).

```
python3 scheme.py
```

- Use command ```load filename``` to load a *.scm file.

```
>>> load test.scm
```

### Example

- Simplest operations

```
(+ (* 3 (+ (* 2 4) (+ 3 5))) (+ (- 10 7) 6))
Expect: 57
```

- Definations of value

```
(define pi 3.14159)
(define radius 10)
(* pi (* radius radius))
Expect: 314.159
```

- Lambda procedure

```
((lambda (x) (+ x 2)) 3)
Expect: 5
```

- User defined procedure and high order function

```
(define adder 
    (lambda (x) (lambda (y) (+ x y))))
((adder 2) 3)
Expect: 5
```

- Condtion expressions

```
(define (abs x)
  (cond ((> x 0) x)
        ((= x 0) 0)
        ((< x 0) (- x))))
(abs -3)
Expect: 3
```

- And & Or expressions

```
(and #t #f)
(or 1 2)
(and 0 1)
Except: False, 1, 1. (Only #f is False)
```

- Load files (Sqrt using Newton iterative method)

```
(define (abs x)
  (cond ((> x 0) x)
        ((= x 0) 0)
        ((< x 0) (- x))))
(define (square x) (* x x))
(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))
(define (improve guess x)
  (average guess (/ x guess)))
(define (average x y)
  (/ (+ x y) 2))
(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))
(define (sqrt x)
  (sqrt-iter 1.0 x))
(sqrt 9)
Expect: 3.00009155413138
```

### Run
![pic](TinyScheme-Python/RUN.PNG)

# Part III

TODO: Add More features.
