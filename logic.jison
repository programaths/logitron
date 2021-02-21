
/* description: Parses end executes logical expressions. */

/* '⇒'/'∧'/'∨'/'⇔' */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
[a-z]\b  return 'VAR'
"|"                   return 'NAND'
"∧"                   return 'AND'
"∨"                   return 'OR'
"⇒"                   return 'IMP'
"⇔"                   return 'EQU'
"¬"                   return 'NEG'
"("                   return 'LP'
")"                   return 'RP'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%right 'EQU'
%right 'IMP'
%left 'OR'
%left 'AND'
%left 'NAND'
%left 'LP'
%left NEG

%start expressions

%% /* language grammar */

expressions
    : e EOF
        { typeof console !== 'undefined' ? console.log($1) : print($1);
          return $1; }
    ;

e
    :
     e 'NAND' e
            {$$ = {op:'nand',left:$1,right:$3};}
    | e 'AND' e
        {$$ = {op:'and',left:$1,right:$3};}
    | e 'OR' e
        {$$ = {op:'or',left:$1,right:$3};}
    | e 'IMP' e
        {$$ = {op:'imp',left:$1,right:$3};}
    | e 'EQU' e
        {$$ = {op:'equ',left:$1,right:$3};}
    | 'NEG' e
        {$$ = {op:'neg',left:$2};}
    | 'LP' e 'RP'
        {$$ = {op:'par',left:$2};}
    | VAR
    ;

