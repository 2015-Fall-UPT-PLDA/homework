Homework 01 - Functional Expression Language Interpreter
===============================================================================

Don't forget to check everything else within this repository as a reference. The [cheat-sheet](https://github.com/2015-Fall-UPT-PLDA/labs/blob/master/haskell-cheat-sheet.md) is always a good thing to use.  

For ease of reference we'll call the language we're developing here FELI.

Homework submission guidelines, and due date
-------------------------------------------------------------
You should show either the TA, or the Instructor a working implementation of the interpreter by **__23:59 October 31th 2015__**. This can be done either in person or via e-mail. Although, preferably, it should be done by email.

The submission is deemed correct *_iff_* the unmodified tests, plus your implementation of the interpreter compiles, and all test cases pass.

*_If you think that you found an error in the test cases, or in the definitions of the data-types please don't hesitate to notify us, so that we can correct them asap! Thank you._*  

*_Late submissions_:* if, for any reason, you cannot make the deadline then you have two more weeks to submit your homework (until Nov 14th, 23:59). For each week you are late you will be deducted 1.5 points, so you can lose up to three points. Also, coding standards will be higher when you submit late, i.e. if you submit on time I won't take into acount code readability, but it becomes an issue if you submit late.

The task at hand
-------------------------------------------------------------

Your task is to implement an interpreter for the programming language who's structure is dictated by the abstract-syntax-tree listed bellow; and who's semantics are described by the test cases found at the bottom of this file.

```Haskell
data Val = IntVal Integer
         | StringVal String
         | BooleanVal Bool
         -- since we are implementing a Functional language, functions are
         -- first class citizens.
         | FunVal [String] Expr Env
     deriving (Show, Eq)

data Expr = Const Val
          -- represents a variable
          | Var String
          -- integer multiplication
          | Expr :*: Expr 
          -- integer addition and string concatenation
          | Expr :+: Expr 
          -- equality test. Defined for all Val except FunVal
          | Expr :==: Expr 
          -- semantically equivalent to a Haskell `if`
          | If Expr Expr Expr
          -- binds a Var (the first `Expr`) to a value (the second `Expr`), 
          -- and makes that binding available in the third expression
          | Let Expr Expr Expr
          -- creates an anonymous function with an arbitrary number of parameters
          | Lambda [Expr] Expr 
          -- calls a function with an arbitrary number values for parameters
          | Apply Expr [Expr]
     deriving (Show, Eq)

data Env = EmptyEnv
         | ExtendEnv String Val
     deriving (Show, Eq)
```


As you can see we define three data-types:
  * `Expr` - during the lab we called it `AST`. But `Expr`(Expression) is a bit more appropriate given the semantics of the language
  * `Val` - the values that can be expressed in our language
  * `Env` (environment) - this is a glorified key-value pair list, that, when used properly takes care of the scoping properties of our language.  



More on the `Env` data-type
-------------------------------------------------------------

To learn more about environments consult [Essentials of Programming Languages, Friedman et. al](http://truly-free.org/ebook.php?book=Friedman%2C%20Wand%2C%20Haynes%20-%20Essentials%20of%20Programming%20Languages&list=a&nr=449&cat=n) downloadable from the provided link. Specifically look at section `3.2.3`, which in turns points to section `2.2`. Also, chapter 3 discusses the implementation of an extremely similar interpreter, but it's written in Scheme :). It shouldn't be too hard to figure out. All the source code from the book can also be found in this [github repo](https://github.com/mwand/eopl3).  



General Tips
-------------------------------------------------------------

You will need to evaluate expressions in the appropriate environment (that's why the `evaluate` function takes an `Env` as a parameter). When evaluating a function in environment `env` you must evaluate its argument(s) in `env` but evaluate the function body (specifically, its free variables) in the environment of the function definition (this is why `FunVal` contains an `Env` value). Essentially, you are implementing the concept of `closures`.


Testing
-------------------------------------------------------------

You just need to evaluate the `testAll` expression in `ghci`, and it will run all test cases. Alternatively you can run each individual test case.

The tests aren't written with any of the standard Haskell unit testing libraries because that would have required explicit installation of these modules in the lab, which, at this point is a total pain.  

The test cases aren't exaustive. You should write some of your own.


Other references
-------------------------------------------------------------

Taken straight from [previous years' description](http://bigfoot.cs.upt.ro/~marius/curs/plda/2013/hw1.html):

The [PLAI book](http://cs.brown.edu/~sk/Publications/Books/ProgLangs/) has an in-depth discussion (sec. II-IV) of building an interpreter.Here's an example of [an SML interpreter](http://www.cs.cornell.edu/courses/cs312/2005sp/lectures/lec17.asp) (with more features) from a course at Cornell.