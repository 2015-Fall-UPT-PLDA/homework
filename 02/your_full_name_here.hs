module Interpreter (Val(..), Expr(..), interpret) where

import Debug.Trace

data Val = IntVal Integer
         | StringVal String
         | BooleanVal Bool
         -- since we are implementing a Functional language, functions are
         -- first class citizens.
         | FunVal [String] Expr Env
     deriving (Show, Eq)

-----------------------------------------------------------

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

-----------------------------------------------------------

data Env = EmptyEnv
         | ExtendEnv String Val Env
     deriving (Show, Eq)

-----------------------------------------------------------

-- the evaluate function takes an environment, which holds variable
-- bindings; i.e. it stores information like `x = 42`
-- the trace there will print out the values with which the function was called,
-- you can easily uncomment it if you don't need it for debugging anymore.
evaluate:: Expr -> Env -> Val
evaluate expr env = 
  trace("expr= " ++ (show expr) ++ "\n env= " ++ (show env)) $
  case expr of
  Const v -> v
  lhs :+: rhs -> 
    let valLhs = evaluate lhs env
        valRhs = evaluate rhs env
    in (IntVal $ (valToInteger valRhs) + (valToInteger valLhs))
  _ -> error $ "unimplemented expression: " ++ (show expr)

-----------------------------------------------------------
valError s v = error $ "expected: " ++ s ++ "; got: " ++ (show v)

-- helper function to remove some of the clutter in the evaluate function
valToInteger:: Val -> Integer
valToInteger (IntVal n) = n
valToInteger v = valError "IntVal" v

-----------------------------------------------------------
-- the function that we test. since we always start out with an EmptyEnv.
interpret :: Expr -> Val
interpret expr = evaluate expr EmptyEnv














---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------- Tests ----------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
testConstant = 
  assert result (IntVal 2) "testConstant"
  where result = interpret expr
        expr = Const (IntVal 2)

---------------------------------------------------------------------

testAddition = 
  assert result (IntVal 2) "testAddition"
  where result = interpret expr
        expr = (Const (IntVal 1)) :+: (Const (IntVal 1))

---------------------------------------------------------------------

testComplexAddition = 
  assert result (IntVal 9) "testComplexAddition"
  where result = interpret expr
        expr = (lhs :+: rhs)
        lhs = (Const (IntVal 1)) :+: (Const (IntVal 1))
        rhs = (Const (IntVal 3)) :+: (Const (IntVal 4))

---------------------------------------------------------------------

testEvenMoreComplexAddition = 
  assert result (IntVal 18) "testEvenMoreComplexAddition"
  where result = interpret expr
        expr = (l :+: r)
        l = lhs :+: rhs
        r = rhs :+: lhs
        lhs = (Const (IntVal 1)) :+: (Const (IntVal 1))
        rhs = (Const (IntVal 3)) :+: (Const (IntVal 4))

---------------------------------------------------------------------

testMultiplication = 
  assert result (IntVal 42) "testMultiplication"
  where result = interpret expr
        expr = (Const (IntVal 7)) :*: (Const (IntVal 6))

---------------------------------------------------------------------

testConcatenation = 
  assert result (StringVal "12") "testConcatenation"
  where result = interpret expr
        expr = (Const (StringVal "1")) :+: (Const (StringVal "2"))

---------------------------------------------------------------------

testEqualString = 
  assert resultPositive (BooleanVal True) "testEqualStringPos" &&
  assert resultNegative (BooleanVal False) "testEqualStringNeg"
  where resultPositive = interpret exprPositive
        exprPositive = (Const (StringVal "1")) :==: (Const (StringVal "1"))
        resultNegative = interpret exprNegative
        exprNegative = (Const (StringVal "1")) :==: (Const (StringVal "2"))

---------------------------------------------------------------------

testEqualInt = 
  assert resultPositive (BooleanVal True) "testEqualIntPos" &&
  assert resultNegative (BooleanVal False) "testEqualIntNeg"
  where resultPositive = interpret exprPositive
        exprPositive = (Const (IntVal 1)) :==: (Const (IntVal 1))
        resultNegative = interpret exprNegative
        exprNegative = (Const (IntVal 1)) :==: (Const (IntVal 2))

---------------------------------------------------------------------

testEqualBool = 
  assert resultPositive (BooleanVal True) "testEqualBoolPos" &&
  assert resultNegative (BooleanVal False) "testEqualBoolNeg"
  where resultPositive = interpret exprPositive
        exprPositive = (Const (BooleanVal True)) :==: (Const (BooleanVal True))
        resultNegative = interpret exprNegative
        exprNegative = (Const (BooleanVal True)) :==: (Const (BooleanVal False))

---------------------------------------------------------------------

testIf = 
  assert resultThen (IntVal 42) "testIfThen" &&
  assert resultElse (StringVal "42") "testIfElse"
  where resultThen = interpret exprThen
        exprThen = (If (Const (IntVal 1) :==: Const (IntVal 1))
                       (Const (IntVal 42))
                       (Const (StringVal "42"))
                   )
        resultElse = interpret exprElse
        exprElse = (If (Const (IntVal 1) :==: Const (IntVal 2))
                       (Const (IntVal 42))
                       (Const (StringVal "42")))

---------------------------------------------------------------------

testLet = 
  assert result (IntVal 42) "testLet" &&
  assert resultShadow (IntVal 84) "testLetShadow"
  where result = interpret expr
        -- ~(let x=42 in x)
        expr = Let (Var "x") (Const (IntVal 42)) (Var "x")
        -- ~ (let x=42 in (let x=84 in x)) 
        -- the second redefinition of x shadows the first one
        exprShadow = (Let (Var "x") (Const (IntVal 42)) 
                        (Let (Var "x") (Const (IntVal 84)) (Var "x"))
                     )
        resultShadow = interpret exprShadow

---------------------------------------------------------------------

testLambdaAndApply = 
  assert result (IntVal 42) "testLambdaAndApply"
  where result = interpret expr
        -- equivalent to: (\x y -> x * y) 6 7
        expr = (Apply 
                  (Lambda [Var "x", Var "y"]
                     ((Var "x") :*: (Var "y"))
                  )
                  [Const (IntVal 6), Const (IntVal 7)]
               )

---------------------------------------------------------------------

testCurrying =
  assert result (IntVal 42) "testCurrying"
  where result = interpret expr
        --equivalent to: ((\x -> \y -> x * y) 6) 7
        expr = (Apply
                 (Apply
                    (Lambda [Var "x"]
                      (Lambda [Var "y"]
                        ((Var "x") :*: (Var "y"))
                      )
                    )
                    ([Const (IntVal 6)])
                  )
                 ([Const (IntVal 7)])
               )

---------------------------------------------------------------------

testAll = 
  if (allPassed) 
    then "All tests passed."
    else error "Failed tests."
  where allPassed = testConstant &&
                    testAddition &&
                    testComplexAddition &&
                    testEvenMoreComplexAddition &&
                    testMultiplication &&
                    testConcatenation &&
                    testEqualString &&
                    testEqualInt &&
                    testEqualBool &&
                    testIf &&
                    testLet &&
                    testLambdaAndApply &&
                    testCurrying

---------------------------------------------------------------------
assert :: Val -> Val -> String -> Bool
assert expected received message = 
  if (expected == received) 
    then True
    else error $ message ++ " -> expected: `" ++ (show expected) ++ "`; received: `" ++ (show received) ++ "`"

