#include <stdlib.h>

#include <lalr/ast.h>

int ast_node_add_child(struct node *parent, struct node *child)
{
    size_t size = (parent->nchild + 1) * sizeof(child);

    parent->children = realloc(parent->children, size);

    if (NULL == parent->children) {
        return -1;
    }

    parent->children[parent->nchild] = child;
    parent->nchild++;
    child->parent = parent;
    child->tree = parent->tree;

    return 0;
}
