{
module Parser where
import Lexer
}

%name parse
%tokentype {Token}
%error {parseError}

%token

var     {VAR $$}
"("     {LPAR}
")"     {RPAR}
"&&"    {AND}
"||"    {OR}
"!"     {NEG}
"->"    {IMP}
"<->"   {BIC}

%left "<->" -- not certain about this
%right "->"  -- not certain about this
%left "||"
%left "&&"
%right "!"

%%

-- NOTE: i used precedence to solve shift/reduce conflit, BUT i would like to solve this without it
{-
Exp     : Term              { $1 }
        | Exp "||" Term     { Or $1 $3 }

Term    : Factor            { $1 }
        | Term "&&" Factor  { And $1 $3}

Factor  : var               { Var $1 }
        | "!" Exp           { Neg $2 }
        | "(" Exp ")"       { $2 }
-}

Exp     : Exp "<->" Exp     { Bic $1 $3}
        | Exp "->" Exp      { Imp $1 $3}
        | Exp "||" Exp      { Or $1 $3 }
        | Exp "&&" Exp      { And $1 $3}
        | "(" Exp ")"       { $2 }
        | "!" Exp           { Neg $2 }
        | var               { Var $1 }
{
    
{-
data Exp 
        = Term Term
        | Or Exp Term
        deriving (Show)
data Term 
        = Factor Factor
        | And Term Factor
        deriving (Show)
data Factor
        = Var String
        | Neg Exp
        -- | Paren Exp -- i dont think is necessary....
        deriving (Show)
-}

data Exp 
        = Bic Exp Exp
        | Imp Exp Exp
        | Or Exp Exp
        | And Exp Exp
        | Neg Exp
        | Var String
        deriving (Show)

parseError :: [Token] -> a
parseError toks = error $ "Erro de parsing: " ++ show toks
}