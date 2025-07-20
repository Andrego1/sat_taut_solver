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

{-
%left "<->" 
%right "->"  
%left "||"
%left "&&"
%right "!"
-}

%%

-- NOTE: this grammar does not need the rules

Exp     : Exp "<->" Implies     { Bic $1 $3 }
        | Implies               { $1 }

Implies : Or "->" Implies       { Imp $1 $3 }
        | Or                    { $1 }

Or      : Or "||" And           { Or $1 $3 }
        | And                   { $1 }

And     : And "&&" Not          { And $1 $3 }
        | Not                   { $1 }

Not     : "!" Atom              { Neg $2 }
        | Atom                  { $1 }

Atom    : var                   { Var $1 }
        | "(" Exp ")"           { $2 }

{-

-- NOTE: with the grammar bellow i used precedence to solve shift/reduce conflit

Exp     : Exp "<->" Exp     { Bic $1 $3}
        | Exp "->" Exp      { Imp $1 $3}
        | Exp "||" Exp      { Or $1 $3 }
        | Exp "&&" Exp      { And $1 $3}
        | "(" Exp ")"       { $2 }
        | "!" Exp           { Neg $2 }
        | var               { Var $1 }
-}
{

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