module MyParser where
import MyTokens (Token (LPAR, VAR, RPAR, NEG, AND, OR, IMP, BIC))

data Exp = Bic Exp Exp
        | Imp Exp Exp
        | Or Exp Exp
        | And Exp Exp
        | Neg Exp
        | Var String
        deriving (Show)

-- its easyer to write
type Parser a = [Token] -> (a, [Token])

parseError :: [Token] -> a
parseError toks = error ("parse error at " ++ show toks)

parseAtom :: Parser Exp
parseAtom (VAR x : rest) = (Var x, rest)
parseAtom (LPAR : tokens) =
  let (e, tokens') = parseExp tokens
  in case tokens' of
    (RPAR : rest) -> (e, rest)
    _ -> parseError tokens'
parseAtom tokens = parseError tokens

parseNot :: Parser Exp
parseNot (NEG : rest) = (Neg e, tokens)
    where 
        (e, tokens) = parseNot rest
parseNot tokens = parseAtom tokens

parseAnd :: Parser Exp
parseAnd tokens = parseAnd' left right
    where (left, right) = parseNot tokens

parseAnd' :: Exp -> Parser Exp
parseAnd' left (AND : tokens) = parseAnd' combined rest
    where 
        (right, rest) = parseNot tokens
        combined = And left right
parseAnd' left rest = (left, rest)

parseOr :: Parser Exp
parseOr tokens = parseOr' left right
    where (left, right) = parseAnd tokens

parseOr' :: Exp -> Parser Exp
parseOr' left (OR : tokens) = parseOr' combined rest
    where 
        (right, rest) = parseAnd tokens
        combined = Or left right
parseOr' left rest = (left, rest)

parseImplies :: Parser Exp
parseImplies tokens = parseImplies' left rest
    where (left, rest) = parseOr tokens

parseImplies' :: Exp -> [Token] -> (Exp, [Token])
parseImplies' left (IMP : tokens) =
    let (right, rest) = parseImplies tokens
        combined = Imp left right
    in (combined, rest)
parseImplies' left tokens = (left, tokens)

parseExp :: Parser Exp
parseExp tokens = parseExp' left right
    where (left, right) = parseImplies tokens

parseExp' :: Exp -> Parser Exp
parseExp' left (BIC : tokens) = parseExp' combined rest
    where 
        (right, rest) = parseImplies tokens
        combined = Bic left right
parseExp' left rest = (left, rest)

myParser :: [Token] -> Exp
myParser tokens = exp
    where (exp, rest) = parseExp tokens