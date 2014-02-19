%{

#include <lalr/ast.h>

#include "parser.h"

#define YY_MATCH_TOKEN(type) do {   \
    yylval.litera.image = yytext;   \
    yylval.litera.length = yyleng;  \
    yylval.litera.offset = offset;  \
    yylval.litera.line = line;      \
    yylval.litera.column = column;  \
                                    \
    column += yyleng;               \
    offset += yyleng;               \
                                    \
    return type;                    \
} while (0)

static uint64_t line   = 0;
static uint64_t column = 0;
static uint64_t offset = 0;

void yyerror(const char *message)
{
    fprintf(stderr, "%s\n", message);
}

%}

DIGIT           [0-9]

DIGITS          {DIGIT}+

E               [eE][\+\-]?

EXP             {E}{DIGITS}

FRAC            \.{DIGITS}

INT             [\-]?{DIGIT}|[\-]?[1-9]{DIGITS}

INTEGER         {INT}|{INT}{EXP}

DECIMAL         {INT}{FRAC}|{INT}{FRAC}{EXP}

UNESCAPED_CHAR  [ -!#-\[\]-~]

ESCAPED_CHAR    \\["\\/bfnrt]

UNICODE_CHAR    \\u[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]

CHAR            {UNESCAPED_CHAR}|{ESCAPED_CHAR}|{UNICODE_CHAR}

CHARS           {CHAR}+

STRING          ["]{CHARS}?["]


%%

{STRING} {
    YY_MATCH_TOKEN(TOKEN_STRING);
}

{INTEGER} {
    YY_MATCH_TOKEN(TOKEN_INTEGER);
}

{DECIMAL} {
    YY_MATCH_TOKEN(TOKEN_DECIMAL);
}

true {
    YY_MATCH_TOKEN(TOKEN_TRUE);
}

false {
    YY_MATCH_TOKEN(TOKEN_FALSE);
}

null {
    YY_MATCH_TOKEN(TOKEN_NULL);
}

\{ {
    YY_MATCH_TOKEN(TOKEN_LBRACE);
}

\} {
    YY_MATCH_TOKEN(TOKEN_RBRACE);
}

\[ {
    YY_MATCH_TOKEN(TOKEN_LBRACKET);
}

\] {
    YY_MATCH_TOKEN(TOKEN_RBRACKET);
}

, {
    YY_MATCH_TOKEN(TOKEN_COMMA);
}

: {
    YY_MATCH_TOKEN(TOKEN_COLON);
}

[ \t] {
    column += yyleng;
    offset += yyleng;
}

\n {
    line++;
    offset += yyleng;
}

\r {
    column = 0;
    offset += yyleng;
}

. {
    fprintf(stderr, "Unexpected character '%c' at line %" PRIu64 " column %" PRIu64 "\n", *yytext, line, column + 1);
    exit(-1);
}

%%
