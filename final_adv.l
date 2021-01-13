%{
#include "y.tab.h"
%}
sep [ \r\t\n]
letter [a-z]
digit [0-9]
%%
{sep} {;}
"("|")"|"+"|"-"|"*"|"/"|">"|"<"|"=" { return(yytext[0]); }
"define" { return(define); }
"fun"  {return(fun);}
"if"  { return(_if); }
"mod" { return(mod); }
"and" { return(and); }
"or" { return(or); }
"not" { return(not); }
"print-num" {   return(print_num); }
"print-bool" { return(print_bool); }
0|[1-9]{digit}*|-[1-9]{digit}* { yylval.ival = atoi(yytext);  return(number); }
{letter}({letter}|{digit}|"-")* {  yylval.id= strdup(yytext);   return(id);}
("#t"|"#f") { if(yytext[1]=='t'){ yylval.bval = 1; }else{ yylval.bval = 0; } return(bool_val);}
.	{ return(yytext[0]); }
%%