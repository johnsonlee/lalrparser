#ifndef __LALR_JSON_PARSER_H__
#define __LALR_JSON_PARSER_H__

#include <lalr/parser.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

enum {
    JSON_NODE_TYPE_ARRAY   = 1,
    JSON_NODE_TYPE_BOOLEAN,
    JSON_NODE_TYPE_DECIMAL,
    JSON_NODE_TYPE_INTEGER,
    JSON_NODE_TYPE_NULL,
    JSON_NODE_TYPE_OBJECT,
    JSON_NODE_TYPE_STRING,
    JSON_NODE_TYPE_MEMBER,
};

struct json_array_node {
    struct node super;
};

struct json_boolean_node {
    struct node super;
    uint8_t value : 1;
};

struct json_null_node {
    struct node super;
};

struct json_number_node {
    struct node super;
    union {
        int64_t integer;
        double  decimal;
    } value;
};

struct json_member_node {
    struct node super;
    char *name;
    struct node *value;
};

struct json_object_node {
    struct node super;
};

struct json_string_node {
    struct node super;
    char *value;
    uint32_t length;
};

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LALR_JSON_PARSER_H__ */
