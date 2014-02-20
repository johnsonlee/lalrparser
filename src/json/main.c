#include <stdio.h>

#include <lalr/language-manager.h>

int main(int argc, char *argv[])
{
    parser_t *parser = language_manager_get_parser("json");

    if (NULL == parser) {
        perror("JSON parser not found!");
        return -1;
    }

    struct ast *ast = parser->parse();

    if (NULL != ast) {
        parser->print(ast->root);
        parser->release(&ast);
    }

    return 0;
}
