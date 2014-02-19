#ifndef __LALR_AST_H__
#define __LALR_AST_H__

#ifndef __STDC_FORMAT_MACROS
#define __STDC_FORMAT_MACROS
#endif /* __STDC_FORMAT_MACROS */

#include <inttypes.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#define AST_NODE(x) ((struct node*)(x))

#define AST_SIZE (sizeof(struct ast))

/**
 * Lexical token
 */
struct token {
    char *image;
    uint64_t length;
    uint64_t offset;
    uint64_t line;
    uint64_t column;
};

/**
 * Abstract syntax tree
 */
struct ast {

    /**
     * The depth of this tree
     */
    int depth;

    /**
     * The root node of AST
     */
    struct node *root;

};

/**
 * Abstract syntax tree node
 */
struct node {
    /**
     * AST node type
     */
    int type;

    /**
     * The level of this node
     */
    int level;

    /**
     * The Owner AST
     */
    struct ast* tree;

    /**
     * The parent AST node
     */
    struct node *parent;

    /**
     * The child AST nodes
     */
    struct node **children;

    /**
     * The number of child AST node
     */
    int nchild;
};

/**
 * Add child node into parent's child list
 * 
 * @param parent
 *           Parent AST node
 * @param child
 *           Child AST node
 * @return 0 on success or -1 on error occurred.
 */
extern int ast_node_add_child(struct node *parent, struct node *child);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LALR_AST_H__ */
