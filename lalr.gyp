{
    'targets' : [{
        'target_name'  : 'json',
        'type'         : 'none',
        'actions'      : [{
            'variables' : {
                'lfile' : 'src/json/json.l',
                'lexer' : 'src/json/lexer.c',
            },
            'action_name' : 'lexer',
            'inputs'   : [
                '<@(lfile)',
            ],
            'outputs'  : [
                '<@(lexer)',
            ],
            'action'   : [
                'lex',
                '--outfile=<@(lexer)',
                '<@(lfile)',
            ],
        },{
            'variables' : {
                'yfile'  : 'src/json/json.y',
                'parser' : 'src/json/parser.c',
            },
            'action_name' : 'parser',
            'inputs'   : [
                '<@(yfile)',
            ],
            'outputs'  : [
                '<@(parser)',
            ],
            'action'   : [
                'yacc',
                '--output=<@(parser)',
                '-d',
                '<@(yfile)',
            ],
        }],
    },{
        'target_name'  : 'languages',
        'type'         : 'none',
        'actions'      : [{
            'variables' : {
                'outfile' : 'src/languages.c',
            },
            'action_name' : 'registry',
            'inputs'   : [
            ],
            'outputs'  : [
                '<@(outfile)',
            ],
            'action'   : [
                'bin/langs',
                'src',
                '<@(outfile)',
            ],
        }],
    },{
        'target_name'  : 'liblalr',
        'type'         : 'static_library',
        'include_dirs' : [
            'include',
        ],
        'sources'      : [
            'src/ast.c',
            'src/languages.c',
            'src/language-manager.c',
            'src/json/lexer.c',
            'src/json/parser.c',
        ],
        'dependencies' : [
            'json',
            'languages',
        ],
    },{
        'target_name'  : 'jsonc',
        'type'         : 'executable',
        'include_dirs' : [
            'include',
        ],
        'sources'      : [
            'src/json/main.c',
        ],
        'dependencies' : [
            'liblalr',
        ],
        'libraries'    : [
            '-ly',
            '-lfl',
        ],
    }],
}
