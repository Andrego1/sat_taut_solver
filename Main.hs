module Main where

import Parser -- comment if my own parser is used
import Lexer -- comment if my own tokens is used
import Data.Map as Map
import Data.List
import System.Exit (exitSuccess)
--import MyTokens -- uncommet for my own tokens
--import MyParser -- uncommet for my own parser

-- Env type is a map that stores the value of every variable
type Env = Map String Bool

-- gets all of the literals from the expression
vars :: Exp -> [String]
vars (Var x)         = [x]
vars (Neg exp)       = nub (vars exp) -- Note: nub eliminates repetitions
vars (And exp1 exp2) = nub (vars exp1 ++ vars exp2)
vars (Or exp1 exp2)  = nub (vars exp1 ++ vars exp2)
vars (Imp exp1 exp2) = nub (vars exp1 ++ vars exp2)
vars (Bic exp1 exp2) = nub (vars exp1 ++ vars exp2)

-- gives back the current value of a literal
checkLiteral :: Env -> String -> Bool
checkLiteral env x = case Map.lookup x env of
    Nothing -> error "Error: undeclered literal (Internal Error)"
    Just val -> val

-- evaluates the expression with a given value for the literals
eval :: Env -> Exp -> Bool
eval env (Var x) = checkLiteral env x
eval env (Neg exp) = not (eval env exp)
eval env (Or exp1 exp2) = eval env exp1 || eval env exp2
eval env (And exp1 exp2) = eval env exp1 && eval env exp2
eval env (Imp exp1 exp2) = not (eval env exp1) || eval env exp2
eval env (Bic exp1 exp2) = (eval env exp1 && eval env exp2) || (not (eval env exp1) && not (eval env exp2))

-- uses backtrack to see if it is sat with a given value for the literals
backtrack :: Exp -> [String] -> Env -> Maybe Env
backtrack expr [] env = if eval env expr then Just env else Nothing
backtrack expr (v:vs) env =
    let try val = backtrack expr vs (Map.insert v val env)
    in orElse (try True) (try False)

-- it tryes the true valye first then gives whatever it is with false
orElse :: Maybe a -> Maybe a -> Maybe a
orElse (Just x) _ = Just x
orElse Nothing y  = y

-- sat function for simpler use
sat :: Exp -> [String] -> Maybe Env
sat exp vals = backtrack exp vals Map.empty

-- taut function, tests it it is a tautology, that is, if for all the values of the variables it is allways true
taut :: Exp -> [String] -> Env -> Bool
taut exp [] env =  eval env exp
taut exp (x:xs) env = taut exp xs (Map.insert x True env) && taut exp xs (Map.insert x False env)

-- gets the values attributed to the literals
getVals :: Env -> [String] -> String -> String
getVals env [] str = str
getVals env (x:xs) str = getVals env xs (str ++ x ++ ": " ++ show (checkLiteral env x) ++ "\n" )

-- it tries all of the expressions it receives and prints the result in the terminal
readExpressionsLoop :: String -> IO ()
readExpressionsLoop flag = do
    line <- getLine
    if line == "return"
    then main
    else do
        let tokens = alexScanTokens line -- comment if my own tokens
        --let tokens = mytokenizer line -- if my own tokens
        --print tokens
        let ast = parse tokens -- comment if my own parser
        --let ast = myParser tokens -- if my own pareser
        --print ast
        let vals = vars ast

        case flag of
            "1" -> do
                let res = sat ast vals
                case res of
                    Nothing   -> putStrLn $ line ++ " ----- Not SAT\n"
                    Just env  -> do
                        putStrLn $ line ++ " ----- SAT\n"
                        putStrLn $ getVals env vals ""
            "2" -> do
                let res = taut ast vals Map.empty
                if res
                    then putStrLn $ line ++ " ----- TAUT\n"
                    else putStrLn $ line ++ " ----- Not TAUT\n"
        readExpressionsLoop flag

-- main function
main :: IO ()
main = do
    putStrLn "Test if SAT (1) or TAUT (2)? (type \"1\" or \"2\" or \"exit\")"
    answer <- getLine
    if answer == "1" || answer == "2"
    then do
        putStrLn "Type expressions one per line. Type \"return\" to go back to main menu."
        readExpressionsLoop answer
    else if answer == "exit" then do exitSuccess
    else do
        putStrLn "Invalid option. Please type \"1\" or \"2\" or \"exit\"."
        main


