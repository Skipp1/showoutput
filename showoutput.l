%option yylineno
%{
#include "y.tab.h"
#include "showoutput.h"

// #define ECHO printf("%s", yytext);
#define ECHO ;
%}

%%

^\.+\|?\.*\\ {
	yylval = strlen(yytext)-1;
	ECHO;
	return DOTS;
}

^\\ {
	yytext_dup(yytext);
	ECHO;
	return yytext[0];
}

(\n+[ ]*)+ {
	ECHO;
	return yytext[0];
}

"discretionary" { ECHO; return DISCRETIONARY; }
"replacing"     { ECHO; return REPLACING;     }
"ligature"      { ECHO; return LIGATURE;      }
"plus"          { ECHO; return GLUE_PLUS;     }
"glue"          { ECHO; return GLUE;          }
"minus"         { ECHO; return GLUE_MINUS;    }

"kern"                  { ECHO; return KERN;        }
"penalty"               { ECHO; return PENALTY;     }
"display"               { ECHO; return BOX_DISPLAY; }
"set"                   { ECHO; return GLUE_SET;    }
"shifted"               { ECHO; return GLUE_SHIFT;  }
(setlanguage|marks?)    { ECHO; return SETLANG;     }
pdf[a-z]+               { ECHO; return PDF;         }
"rule"                  { ECHO; return RULE;        }
[xc]?leaders            { ECHO; return LEADERS;     }

matho(n|ff) {
	yytext_dup(yytext);
	ECHO;
	return MATH;
}

(read|write)[-0-9]*(.*|.*\n.*)\} {
	ECHO;
	return IO;
}

[vh]box {
	yytext_dup(yytext);
	ECHO;
	return BOX;
}
                  
[ [:punct:]] {
	yytext_dup(yytext);
	ECHO;
	return yytext[0];
}

[+-]?[0-9]+ {
	yytext_dup(yytext);
	ECHO;
	return INT;
}
                  
(O?TS?[1-7]|X2|[OL]M[LSX]|LY1|LV1|LGR|PD1|P?U) {
	yytext_dup(yytext);
	ECHO;
	return FONT_ENC;
}

(ul|el|l|m|sb|b|eb|ub)?(uc|ec|c|sx|x|ex|ux)? { 
	yytext_dup(yytext);
	ECHO;
	return FONT_SERIES;
}
                  
(n|it|sl|sc|ui|ol|scit|scsl|itsc) {
	yytext_dup(yytext);
	ECHO;
	return FONT_SHAPE;
}

[a-z]+ {
	yytext_dup(yytext);
/* 	printf("\033[31m"); */
	ECHO;
/* 	printf("\033[0m"); */
	return CMD;
}

(\^\^)?[\x0b\x20-\xFF] {
	yytext_dup(yytext);
	ECHO;
	return CHAR;
}

[+-]?[0-9]+\.[0-9]+ {
	yytext_dup(yytext);
	ECHO;
  return FLOAT;
}

[+-]?[0-9]+\.[0-9]+fil+ {
	yytext_dup(yytext);
	ECHO;
	return FLOAT_FIL;
}

x([+-]?[0-9]+\.[0-9]+|\*) {
	yytext_dup(yytext);
	ECHO;
	return MULTIPLIER;
}

%%
