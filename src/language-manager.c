#include <lalr/language-manager.h>

extern struct language languages[];

struct language* language_manager_get_language(const char *name)
{
    struct language *lang;

    for (lang = languages; lang; lang++) {
        if (0 == strcmp(name, lang->name)) {
            return lang;
        }
    }

    return NULL;
}

parser_t* language_manager_get_parser(const char *name)
{
    struct language *lang = language_manager_get_language(name);

    if (NULL != lang) {
        return lang->parser;
    }

    return NULL;
}
