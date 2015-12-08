import Data.Map

-- we define an identifier as tuple. The `Int` will give us an easy way
-- to generate fresh variable names during unification later on.
type Identifier = (Int, String)

data Term = Var Identifier
          | Fun String [Term]
      deriving (Show, Eq)

data Clause = Term :- [Term] -- this is a rule
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

prolog :: PrologProgram -> Term -> Answer
prolog program goal = undefined
