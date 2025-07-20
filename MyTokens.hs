module MyTokens where
import Data.Char (isAlpha, isAlphaNum)

data Token = VAR String
        | LPAR
        | RPAR
        | AND
        | OR
        | NEG
        | IMP
        | BIC
        deriving (Show, Eq)

mytokenizer :: String -> [Token]
mytokenizer ""                  = []
mytokenizer (' ':rest)          = mytokenizer rest
mytokenizer ('&':'&':rest)      = AND  : mytokenizer rest
mytokenizer ('|':'|':rest)      = OR   : mytokenizer rest
mytokenizer ('!':rest)          = NEG  : mytokenizer rest
mytokenizer ('-':'>':rest)      = IMP  : mytokenizer rest
mytokenizer ('<':'-':'>':rest)  = BIC  : mytokenizer rest
mytokenizer ('(':rest)          = LPAR : mytokenizer rest
mytokenizer (')':rest)          = RPAR : mytokenizer rest
mytokenizer (c:cs)
    | isAlpha c = VAR var : mytokenizer rest
    where 
        (var,rest) = span isAlphaNum (c:cs)