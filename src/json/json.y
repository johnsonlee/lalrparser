%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <lalr/json/parser.h>

#define JSON_ARRAY_NODE(x)   ((struct json_array_node*)(x))
#define JSON_BOOLEAN_NODE(x) ((struct json_boolean_node*)(x))
#define JSON_MEMBER_NODE(x)  ((struct json_member_node*)(x))
#define JSON_NULL_NODE(x)    ((struct json_null_node*)(x))
#define JSON_NUMBER_NODE(x)  ((struct json_number_node*)(x))
#define JSON_OBJECT_NODE(x)  ((struct json_object_node*)(x))
#define JSON_STRING_NODE(x)  ((struct json_string_node*)(x))

%}

%union {
    struct token litera;
    struct node *node;
}

%token <litera> TOKEN_STRING
%token <litera> TOKEN_INTEGER
%token <litera> TOKEN_DECIMAL

%token TOKEN_TRUE
       TOKEN_FALSE
       TOKEN_NULL
       TOKEN_LBRACE
       TOKEN_RBRACE
       TOKEN_LBRACKET
       TOKEN_RBRACKET
       TOKEN_COMMA
       TOKEN_COLON

%type <node> array
%type <node> boolean
%type <node> elements
%type <node> object
%type <node> member
%type <node> members
%type <node> null
%type <node> number
%type <node> string
%type <node> value

%parse-param {struct ast *ast}

%{

extern FILE* yyget_out(void);
extern int yyparse(struct ast*);

static struct ast* json_parser_parse();
static struct ast* json_parser_fparse(FILE *fp);
static struct ast* json_parser_sparse(const char *buf, size_t size);

static void json_parser_release(struct ast **ast);
static void json_parser_release_node(struct node **node);
static void json_parser_release_array_node(struct node **node);
static void json_parser_release_boolean_node(struct node **node);
static void json_parser_release_member_node(struct node **node);
static void json_parser_release_number_node(struct node **node);
static void json_parser_release_null_node(struct node **node);
static void json_parser_release_object_node(struct node **node);
static void json_parser_release_string_node(struct node **node);

static void json_parser_print(struct node *node);
static void json_parser_fprint(struct node *node, FILE *fp);
static void json_parser_fprint_array_node(struct json_array_node *json, FILE *fp);
static void json_parser_fprint_boolean_node(struct json_boolean_node *json, FILE *fp);
static void json_parser_fprint_member_node(struct json_member_node *json, FILE *fp);
static void json_parser_fprint_number_node(struct json_number_node *json, FILE *fp);
static void json_parser_fprint_null_node(struct json_null_node *json, FILE *fp);
static void json_parser_fprint_object_node(struct json_object_node *json, FILE *fp);
static void json_parser_fprint_string_node(struct json_string_node *json, FILE *fp);

parser_t json_parser = {
    .parse   = json_parser_parse,
    .fparse  = json_parser_fparse,
    .sparse  = json_parser_sparse,
    .release = json_parser_release,
    .print   = json_parser_print,
    .fprint  = json_parser_fprint,
};

static void json_parser_release(struct ast **ast)
{
    struct node *root = (*ast)->root;

    if (NULL != root) {
        json_parser_release_node(&root);
    }

    free(*ast);
    *ast = NULL;
}

static void json_parser_release_node(struct node **node)
{
    switch ((*node)->type) {
    case JSON_NODE_TYPE_ARRAY:
        json_parser_release_array_node(node);
        break;
    case JSON_NODE_TYPE_BOOLEAN:
        json_parser_release_boolean_node(node);
        break;
    case JSON_NODE_TYPE_DECIMAL:
    case JSON_NODE_TYPE_INTEGER:
        json_parser_release_number_node(node);
        break;
    case JSON_NODE_TYPE_MEMBER:
        json_parser_release_member_node(node);
        break;
    case JSON_NODE_TYPE_NULL:
        json_parser_release_null_node(node);
        break;
    case JSON_NODE_TYPE_OBJECT:
        json_parser_release_object_node(node);
        break;
    case JSON_NODE_TYPE_STRING:
        json_parser_release_string_node(node);
        break;
    default:
        break;
    }
}

static void json_parser_release_array_node(struct node **node)
{
    int i;

    for (i = 0; i < (*node)->nchild; i++) {
        json_parser_release_node((*node)->children + i);
    }

    free((*node)->children);
    free(*node);
    *node = NULL;
}

static void json_parser_release_boolean_node(struct node **node)
{
    free(*node);
    *node = NULL;
}

static void json_parser_release_member_node(struct node **node)
{
    free(JSON_MEMBER_NODE(*node)->name);
    json_parser_release_node(&JSON_MEMBER_NODE(*node)->value);
}

static void json_parser_release_number_node(struct node **node)
{
    free(*node);
    *node = NULL;
}

static void json_parser_release_null_node(struct node **node)
{
    free(*node);
    *node = NULL;
}

static void json_parser_release_object_node(struct node **node)
{
    int i;

    for (i = 0; i < (*node)->nchild; i++) {
        json_parser_release_member_node((*node)->children + i);
    }

    free((*node)->children);
    free(*node);
    *node = NULL;
}

static void json_parser_release_string_node(struct node **node)
{
    free(JSON_STRING_NODE(*node)->value);
    free(*node);
    *node = NULL;
}

static struct ast* json_parser_parse()
{
    struct ast *ast = calloc(1, AST_SIZE);

    if (0 == yyparse(ast)) {
        return ast;
    }

    json_parser_release(&ast);
    return NULL;
}

static struct ast* json_parser_fparse(FILE *fp)
{
    yyset_in(fp);
    return json_parser_parse();
}

static struct ast* json_parser_sparse(const char *buf, size_t size)
{
    yy_scan_buffer(buf, size);
    return json_parser_parse();
}

static void json_parser_print(struct node *node)
{
    json_parser_fprint(node, yyget_out());
}

static void json_parser_fprint(struct node *node, FILE *fp)
{
    switch (node->type) {
    case JSON_NODE_TYPE_ARRAY:
        json_parser_fprint_array_node(JSON_ARRAY_NODE(node), fp);
        break;
    case JSON_NODE_TYPE_BOOLEAN:
        json_parser_fprint_boolean_node(JSON_BOOLEAN_NODE(node), fp);
        break;
    case JSON_NODE_TYPE_DECIMAL:
    case JSON_NODE_TYPE_INTEGER:
        json_parser_fprint_number_node(JSON_NUMBER_NODE(node), fp);
        break;
    case JSON_NODE_TYPE_MEMBER:
        json_parser_fprint_member_node(JSON_MEMBER_NODE(node), fp);
        break;
    case JSON_NODE_TYPE_NULL:
        json_parser_fprint_null_node(JSON_NULL_NODE(node), fp);
        break;
    case JSON_NODE_TYPE_OBJECT:
        json_parser_fprint_object_node(JSON_OBJECT_NODE(node), fp);
        break;
    case JSON_NODE_TYPE_STRING:
        json_parser_fprint_string_node(JSON_STRING_NODE(node), fp);
        break;
    default:
        break;
    }
}

static void json_parser_fprint_array_node(struct json_array_node *json, FILE *fp)
{
    int i;
    struct node *node = AST_NODE(json);

    for (i = 0; i < node->nchild; i++) {
        if (i > 0) {
            fprintf(fp, ",\n");
        } else {
            fprintf(fp, "[\n");
        }

        json_parser_fprint(node->children[i], fp);
    }

    fprintf(fp, "\n]\n");
}

static void json_parser_fprint_boolean_node(struct json_boolean_node *json, FILE *fp)
{
    fprintf(fp, "%s", json->value ? "true" : "false");
}

static void json_parser_fprint_number_node(struct json_number_node *json, FILE *fp)
{
    switch (json->super.type) {
    case JSON_NODE_TYPE_DECIMAL:
        fprintf(fp, "%lf", json->value.decimal);
        break;
    case JSON_NODE_TYPE_INTEGER:
        fprintf(fp, "%"PRId64, json->value.integer);
        break;
    }
}

static void json_parser_fprint_member_node(struct json_member_node *json, FILE *fp)
{
    fprintf(fp, "\"%s\" : ", json->name);
    json_parser_fprint(json->value, fp);
}

static void json_parser_fprint_null_node(struct json_null_node *json, FILE *fp)
{
    fprintf(fp, "null");
}

static void json_parser_fprint_object_node(struct json_object_node *json, FILE *fp)
{
    int i;
    struct node *node = AST_NODE(json);

    for (i = 0; i < node->nchild; i++) {
        if (i > 0) {
            fprintf(fp, ",\n");
        } else {
            fprintf(fp, "{\n");
        }

        json_parser_fprint_member_node(JSON_MEMBER_NODE(node->children[i]), fp);
    }

    fprintf(fp, "\n}");
}

static void json_parser_fprint_string_node(struct json_string_node *json, FILE *fp)
{
    fprintf(fp, "\"%s\"", json->value);
}

%}

%%

value
    : boolean {
        ast->root = $1;
      }
    | null {
        ast->root = $1;
      }
    | number {
        ast->root = $1;
      }
    | string {
        ast->root = $1;
      }
    | object {
        ast->root = $1;
      }
    | array {
        ast->root = $1;
      }
    ;

boolean
    : TOKEN_TRUE {
        struct json_boolean_node *json = calloc(1, sizeof(struct json_boolean_node));
        json->super.tree = ast;
        json->super.type = JSON_NODE_TYPE_BOOLEAN;
        json->value = 1;
        $$ = AST_NODE(json);
      }
    | TOKEN_FALSE {
        struct json_boolean_node *json = calloc(1, sizeof(struct json_boolean_node));
        json->super.tree = ast;
        json->super.type = JSON_NODE_TYPE_BOOLEAN;
        json->value = 0;
        $$ = AST_NODE(json);
      }
    ;

null
    : TOKEN_NULL {
        struct json_null_node *json = calloc(1, sizeof(struct json_null_node));
        json->super.tree = ast;
        json->super.type = JSON_NODE_TYPE_NULL;
        $$ = AST_NODE(json);
      }
    ;

number
    : TOKEN_INTEGER {
        int64_t value = atoll($1.image);
        struct json_number_node *json = calloc(1, sizeof(struct json_number_node));
        json->super.tree = ast;
        json->super.type = JSON_NODE_TYPE_INTEGER;
        json->value.integer = value;
        $$ = AST_NODE(json);
      }
    | TOKEN_DECIMAL {
        double value = atof($1.image);
        struct json_number_node *json = calloc(1, sizeof(struct json_number_node));
        json->super.tree = ast;
        json->super.type = JSON_NODE_TYPE_DECIMAL;
        json->value.decimal = value;
        $$ = AST_NODE(json);
      }
    ;

string
    : TOKEN_STRING {
        struct json_string_node *json = calloc(1, sizeof(struct json_string_node));
        json->super.tree = ast;
        json->super.type = JSON_NODE_TYPE_STRING;
        json->value = strndup($1.image + 1, $1.length - 2);
        json->length = $1.length;
        $$ = AST_NODE(json);
      }
    ;

object
    : TOKEN_LBRACE TOKEN_RBRACE {
        struct json_object_node *json = calloc(1, sizeof(struct json_object_node));
        json->super.tree = ast;
        json->super.type = JSON_NODE_TYPE_OBJECT;
        $$ = AST_NODE(json);
      }
    | TOKEN_LBRACE members TOKEN_RBRACE {
        $$ = AST_NODE($2);
      }
    ;

members
    : member {
        struct json_object_node *json = calloc(1, sizeof(struct json_object_node));
        json->super.tree = ast;
        json->super.type = JSON_NODE_TYPE_OBJECT;
        ast_node_add_child(AST_NODE(json), AST_NODE($1));
        $$ = AST_NODE(json);
      }
    | member TOKEN_COMMA members {
        ast_node_add_child($3, AST_NODE($1));
        $$ = $3;
      }
    ;

member
    : TOKEN_STRING TOKEN_COLON value {
        struct json_member_node *json = calloc(1, sizeof(struct json_member_node));
        json->super.tree = ast;
        json->super.type = JSON_NODE_TYPE_MEMBER;
        json->name = strndup($1.image + 1, $1.length - 2);
        json->value = AST_NODE($3);
        $$ = AST_NODE(json);
      }
    ;

array
    : TOKEN_LBRACKET TOKEN_RBRACKET {
        struct json_array_node *json = calloc(1, sizeof(struct json_array_node));
        json->super.tree = ast;
        json->super.type = JSON_NODE_TYPE_ARRAY;
        $$ = AST_NODE(json);
      }
    | TOKEN_LBRACKET elements TOKEN_RBRACKET {
        $$ = AST_NODE($2);
      }
    ;

elements
    : value {
        struct json_array_node *json = calloc(1, sizeof(struct json_array_node));
        json->super.tree = ast;
        json->super.type = JSON_NODE_TYPE_ARRAY;
        ast_node_add_child(AST_NODE(json), AST_NODE($1));
        $$ = AST_NODE(json);
      }
    | value TOKEN_COMMA elements {
        ast_node_add_child($3, AST_NODE($1));
        $$ = $3;
      }
    ;

%%
