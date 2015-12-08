Homework 04 - Prolog Interpreter
===============================================================================

Hard deadline: January 11th 2015, by 23:59

To be able to complete this homework you will have to familiarize yourself a bit with basics of the programming language [`Prolog`](http://www.swi-prolog.org/). I have also written a [quick guide](./prolog-quick-guide.md) to get programs running, and I outline the basic semantics that have to be supported by the interpreter you have to implement. So make sure you read the guide.  

The task at hand
------------------------------------------------------------------------------
You will be writing a small interpreter that, like in previous homeworks, takes as input some algebraic data-type that represents the abstract syntax-tree of the language.  


First, we define our data types:

```Haskell
import Data.Map

-- we define an identifier as tuple. The `Int` will give us an easy way
-- to generate fresh variable names during unification later on.
type Identifier = (Int, String)

data Term = Var Identifier
          | Fun String [Term]
      deriving (Show, Eq)

data Clause = Term :- [Term] -- this is a rule, `Head :- Body`
            | Fact Term
     deriving (Show, Eq)

-- a Prolog program is nothing but a list of clauses; this is our interpreter's
-- equivalent of the `simple.pl` file.
type PrologProgram = [Clause]

-- we need a substitution, which maps Variables to Terms, denoting that a variable
-- is equal to the term it maps to.
type Substitution = Map Identifier Term

-- your interpreter either returns `No`, meaning that your question could not be answered.
-- or it returns `Yes` with an empty `Substitution` in case your answer is a simple "true",
-- otherwise you get back a substitution mapping Variables to their possible values. 
data Answer = No
            | Yes Substitution
```

You will have to implement a function called `prolog` with the following signature:
```prolog
prolog :: PrologProgram -> Term -> Answer
prolog program goal = undefined
```  
Where the second parameter, called a `goal`, is the question you would normally [ask the Prolog interpreter](./prolog-quick-guide.md#L74).

Essentially, your interpreter has to behave like the Prolog one does. The folowing example distinguishes the two major types of cases (note that we have previously loaded the [`simple.pl`](./simple.pl) file):
```
1 ?- suitAndTieMotherfucker(X).
X = bunk.

2 ?- suitAndTieMotherfucker(bunk).
true.
```

In case `1` we ask to find all `X` for which the clause is true, i.e. it's a search problem. In case `2` we simply ask wether or not the clause is true, i.e. it's a decision problem. Good luck!

Semantics and representation.
------------------------------------------------------------------------------  

*_When you read more about Prolog, you will encounter the term `predicate`, in our data structure, a predicate is represented as a `Fun` data type._*  

To give you a better understanding of the representation, let's take an example from [`simple.pl`](./simple.pl). If you haven't read the [quick guide to Prolog](./prolog-quick-guide) yet, you should probably do so.

The fact `wearsSuits(bunk).` is represented as `Fun "wearsSuits" [Fun "bunk" []]`. We represent the constant term `bunk` as a `Fun` term with no additional terms.

The rule:   
```prolog
suitAndTieMotherfucker(X) :-
  wearsSuits(X),
  wearsTies(X).
```
Is represented as:
```
let firstPredicate  = Fun "wearsSuits" [Var (0,"X")]
    secondPredicate = Fun "wearsTies" [Var (0,"X")]
  in Fun "suitAndTieMotherfucker" [Var (0,"X")] :- [firstPredicate, secondPredicate]
```

Remember, that this rule is true if both the `firstPredicate` and `secondPredicates` are true.


Implementation tips.
------------------------------------------------------------------------------

Straight from [last year's](http://bigfoot.cs.upt.ro/~marius/curs/plda/2013/hw4.html) homework:    


*_Evaluation of a [goal](./homework-04.md#L50) is done by unifying it with the head of a rule, and then evaluating the subgoals in the rule attempting to make them true._*  

*_Before unification, the variables in the rule head and body have to be renamed to fresh variables._*


Important:
------------------------------------------------------------------------------


Write helper functions! Don't try to cram everything into the `prolog` function. You should probably delegate most of the work to a function that doesn't have such an obtuse return type as `Answer`, and then convert whatever that function returns to an `Answer`.  

Write tests! Start out by writing tests from the examples in the `simple.pl` file and then
write more complex ones. e.g. `Fun` terms with more than one parameter, clauses with more than two predicates, etc. 


Submission:
------------------------------------------------------------------------------  


You will have to submit the source code, together with some test cases. A complete test suite consists of both positive and negative tests, and should cover all cases in the `simple.pl` file as well as more complex ones. Use [homework-01](../01/Interpreter-tests.hs) as an example how to write tests.



References:
------------------------------------------------------------------------------  

* [swi-prolog](http://www.swi-prolog.org/)  
* Not required, but really cool: [*_Embedding Prolog in Haskell, page 25_*](http://lambda-the-ultimate.org/node/112). The actual paper if you follow the [links](http://www.cs.uu.nl/research/techreps/repo/CS-1999/1999-28.pdf).  
