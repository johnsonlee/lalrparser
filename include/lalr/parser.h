#ifndef __LALR_PARSER_H__
#define __LALR_PARSER_H__

#include <stdio.h>

#include <lalr/ast.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef struct parser {

    /**
     * Parse from standard input stream
     * 
     * @return an AST instance
     */
    struct ast* (*parse)();

    /**
     * Parse from file input stream
     * 
     * @param fp
     *           File input stream
     * 
     * @return an AST instance
     */
    struct ast* (*fparse)(FILE *fp);

    /**
     * Parse from string buffer
     * 
     * @param buf
     *           A string buffer to be parse
     * @param size
     *           Buffer size
     * 
     * @return an AST instance
     */
    struct ast* (*sparse)(const char *buf, size_t size);

    /**
     * Release AST
     * 
     * @param ast
     *           An AST instance parsed by this parser
     */
    void (*release)(struct ast **ast);

    /**
     * Print AST node
     * 
     * @param node
     *           An AST node
     */
    void (*print)(struct node *node);

    /**
     * Print AST node to specified file stream
     * 
     * @param node
     *           An AST node
     * @param fp
     *           File output stream
     */
    void (*fprint)(struct node *node, FILE *fp);

} parser_t;

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LALR_PARSER_H__ */
