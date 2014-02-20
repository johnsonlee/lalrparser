#include <lalr/language-manager.h>

extern parser_t javascript_parser;
extern parser_t json_parser;

struct language languages[] = {
    { "javascript", &javascript_parser },
    { "json", &json_parser },
    NULL
};
