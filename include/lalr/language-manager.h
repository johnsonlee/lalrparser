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

/**
 * Returns the language descriptor of the specified language
 * 
 * @param name
 *           Language name
 * @return the language descriptor or NULL if not found
 */
extern struct language* language_manager_get_language(const char *name);

/**
 * Returns the language parser of the specified language
 * 
 * @param name
 *           Language name
 * @return the language parser or NULL if not found
 */
extern parser_t* language_manager_get_parser(const char *name);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LALR_LANGUAGE_MANAGER_H__ */
