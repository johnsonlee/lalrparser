#include <lalr/language-manager.h>

extern parser_t json_parser;

struct language languages[] = {
    { "json", &json_parser },
    NULL
};
