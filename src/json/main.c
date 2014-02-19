#include <stdio.h>

#include <lalr/language-manager.h>

int main(int argc, char *argv[])
{
    parser_t *parser;
    struct ast *ast;
    struct language *lang;
    
    lang = language_manager_get_language("json");

    if (NULL == lang) {
        perror("JSON parser not found!");
        return -1;
    }

    parser = lang->parser;
    ast = parser->parse();

    if (NULL != ast) {
        parser->print(ast->root);
        parser->release(&ast);
    }

    return 0;
}
