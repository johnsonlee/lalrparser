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
