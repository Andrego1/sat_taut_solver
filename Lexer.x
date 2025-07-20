{
module Lexer where
}

%wrapper "basic" 

$alpha = [_a-zA-Z] -- char
$digit = 0-9

tokens :-

$white                      ; -- ignores blank char
$alpha($alpha|$digit)*      {\s -> VAR s}
"("                         {\_ -> LPAR}
")"                         {\_ -> RPAR}
"||"                        {\_ -> OR}
"&&"                        {\_ -> AND}
"!"                         {\_ -> NEG}
"->"                        {\_ -> IMP}
"<->"                       {\_ -> BIC}

{
data Token = VAR String
        | LPAR
        | RPAR
        | AND
        | OR
        | NEG
        | IMP
        | BIC
        deriving (Show, Eq)
}