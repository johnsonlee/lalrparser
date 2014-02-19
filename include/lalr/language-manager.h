#ifndef __LALR_LANGUAGE_MANAGER_H__
#define __LALR_LANGUAGE_MANAGER_H__

#include <lalr/parser.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/**
 * Programming language
 */
struct language {
    /**
     * Language name
     */
    char *name;

    /**
     * Parser for this language
     */
    parser_t *parser;
};

extern struct language* language_manager_get_language(const char *name);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LALR_LANGUAGE_MANAGER_H__ */
