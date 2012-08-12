%{
	#include <stdio.h>

    extern int yylineno;
    int yylex(void);
    void yyerror(const char *err) { printf("Error in line: %d: %s\n", yylineno, err); }

#define TRACE printf("Reduce at line %d\n", __LINE__);
%}


%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER INLINE RESTRICT
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token BOOL COMPLEX IMAGINARY
%token STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%start translation_unit
%%

primary_expression
	: IDENTIFIER { TRACE }
	| CONSTANT { TRACE }
	| STRING_LITERAL { TRACE }
	| '(' expression ')' { TRACE }
	;

postfix_expression
	: primary_expression { TRACE }
	| postfix_expression '[' expression ']' { TRACE }
	| postfix_expression '(' ')' { TRACE }
	| postfix_expression '(' argument_expression_list ')' { TRACE }
	| postfix_expression '.' IDENTIFIER { TRACE }
	| postfix_expression PTR_OP IDENTIFIER { TRACE }
	| postfix_expression INC_OP { TRACE }
	| postfix_expression DEC_OP { TRACE }
	| '(' type_name ')' '{' initializer_list '}' { TRACE }
	| '(' type_name ')' '{' initializer_list ',' '}' { TRACE }
	;

argument_expression_list
	: assignment_expression { TRACE }
	| argument_expression_list ',' assignment_expression { TRACE }
	;

unary_expression
	: postfix_expression { TRACE }
	| INC_OP unary_expression { TRACE }
	| DEC_OP unary_expression { TRACE }
	| unary_operator cast_expression { TRACE }
	| SIZEOF unary_expression { TRACE }
	| SIZEOF '(' type_name ')' { TRACE }
	;

unary_operator
	: '&' { TRACE }
	| '*' { TRACE }
	| '+' { TRACE }
	| '-' { TRACE }
	| '~' { TRACE }
	| '!' { TRACE }
	;

cast_expression
	: unary_expression { TRACE }
	| '(' type_name ')' cast_expression { TRACE }
	;

multiplicative_expression
	: cast_expression { TRACE }
	| multiplicative_expression '*' cast_expression { TRACE }
	| multiplicative_expression '/' cast_expression { TRACE }
	| multiplicative_expression '%' cast_expression { TRACE }
	;

additive_expression
	: multiplicative_expression { TRACE }
	| additive_expression '+' multiplicative_expression { TRACE }
	| additive_expression '-' multiplicative_expression { TRACE }
	;

shift_expression
	: additive_expression { TRACE }
	| shift_expression LEFT_OP additive_expression { TRACE }
	| shift_expression RIGHT_OP additive_expression { TRACE }
	;

relational_expression
	: shift_expression { TRACE }
	| relational_expression '<' shift_expression { TRACE }
	| relational_expression '>' shift_expression { TRACE }
	| relational_expression LE_OP shift_expression { TRACE }
	| relational_expression GE_OP shift_expression { TRACE }
	;

equality_expression
	: relational_expression { TRACE }
	| equality_expression EQ_OP relational_expression { TRACE }
	| equality_expression NE_OP relational_expression { TRACE }
	; 

and_expression
	: equality_expression { TRACE }
	| and_expression '&' equality_expression { TRACE }
	;

exclusive_or_expression
	: and_expression { TRACE }
	| exclusive_or_expression '^' and_expression { TRACE }
	;

inclusive_or_expression
	: exclusive_or_expression { TRACE }
	| inclusive_or_expression '|' exclusive_or_expression { TRACE }
	;

logical_and_expression
	: inclusive_or_expression { TRACE }
	| logical_and_expression AND_OP inclusive_or_expression { TRACE }
	;

logical_or_expression
	: logical_and_expression { TRACE }
	| logical_or_expression OR_OP logical_and_expression { TRACE }
	;

conditional_expression
	: logical_or_expression { TRACE }
	| logical_or_expression '?' expression ':' conditional_expression { TRACE }
	;

assignment_expression
	: conditional_expression { TRACE }
	| unary_expression assignment_operator assignment_expression { TRACE }
	;

assignment_operator
	: '=' { TRACE }
	| MUL_ASSIGN { TRACE }
	| DIV_ASSIGN { TRACE }
	| MOD_ASSIGN { TRACE }
	| ADD_ASSIGN { TRACE }
	| SUB_ASSIGN { TRACE }
	| LEFT_ASSIGN { TRACE }
	| RIGHT_ASSIGN { TRACE }
	| AND_ASSIGN { TRACE }
	| XOR_ASSIGN { TRACE }
	| OR_ASSIGN { TRACE }
	;

expression
	: assignment_expression { TRACE }
	| expression ',' assignment_expression { TRACE }
	;

constant_expression
	: conditional_expression { TRACE }
	;

declaration
	: declaration_specifiers ';' { TRACE }
	| declaration_specifiers init_declarator_list ';' { TRACE }
	;

declaration_specifiers
	: storage_class_specifier { TRACE }
	| storage_class_specifier declaration_specifiers { TRACE }
	| type_specifier { TRACE }
	| type_specifier declaration_specifiers { TRACE }
	| type_qualifier { TRACE }
	| type_qualifier declaration_specifiers { TRACE }
	| function_specifier { TRACE }
	| function_specifier declaration_specifiers { TRACE }
	;

init_declarator_list
	: init_declarator { TRACE }
	| init_declarator_list ',' init_declarator { TRACE }
	;

init_declarator
	: declarator { TRACE }
	| declarator '=' initializer { TRACE }
	;

storage_class_specifier
	: TYPEDEF { TRACE }
	| EXTERN { TRACE }
	| STATIC { TRACE }
	| AUTO { TRACE }
	| REGISTER { TRACE }
	; 

type_specifier
	: VOID { TRACE }
	| CHAR { TRACE }
	| SHORT { TRACE }
	| INT { TRACE }
	| LONG { TRACE }
	| FLOAT { TRACE }
	| DOUBLE { TRACE }
	| SIGNED { TRACE }
	| UNSIGNED { TRACE } 
	| BOOL { TRACE }
	| COMPLEX { TRACE }
	| IMAGINARY { TRACE }
	| struct_or_union_specifier { TRACE }
	| enum_specifier { TRACE }
	| TYPE_NAME { TRACE }
	;

struct_or_union_specifier
	: struct_or_union IDENTIFIER '{' struct_declaration_list '}' { TRACE }
	| struct_or_union '{' struct_declaration_list '}' { TRACE }
	| struct_or_union IDENTIFIER { TRACE }
	;

struct_or_union
	: STRUCT { TRACE }
	| UNION { TRACE }
	;

struct_declaration_list
	: struct_declaration { TRACE }
	| struct_declaration_list struct_declaration { TRACE }
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list ';' { TRACE }
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list { TRACE }
	| type_specifier { TRACE }
	| type_qualifier specifier_qualifier_list { TRACE }
	| type_qualifier { TRACE }
	;

struct_declarator_list
	: struct_declarator { TRACE }
	| struct_declarator_list ',' struct_declarator { TRACE }
	;

struct_declarator
	: declarator { TRACE }
	| ':' constant_expression { TRACE }
	| declarator ':' constant_expression { TRACE }
	;

enum_specifier
	: ENUM '{' enumerator_list '}' { TRACE }
	| ENUM IDENTIFIER '{' enumerator_list '}' { TRACE }
	| ENUM '{' enumerator_list ',' '}' { TRACE }
	| ENUM IDENTIFIER '{' enumerator_list ',' '}' { TRACE }
	| ENUM IDENTIFIER { TRACE }
	;

enumerator_list
	: enumerator { TRACE }
	| enumerator_list ',' enumerator { TRACE }
	;

enumerator
	: IDENTIFIER { TRACE }
	| IDENTIFIER '=' constant_expression { TRACE }
	;

type_qualifier
	: CONST { TRACE }
	| RESTRICT { TRACE }
	| VOLATILE { TRACE }
	;

function_specifier
	: INLINE { TRACE }
	;

declarator
	: pointer direct_declarator { TRACE }
	| direct_declarator { TRACE }
	;


direct_declarator
	: IDENTIFIER { TRACE }
	| '(' declarator ')' { TRACE }
	| direct_declarator '[' type_qualifier_list assignment_expression ']' { TRACE }
	| direct_declarator '[' type_qualifier_list ']' { TRACE }
	| direct_declarator '[' assignment_expression ']' { TRACE }
	| direct_declarator '[' STATIC type_qualifier_list assignment_expression ']' { TRACE }
	| direct_declarator '[' type_qualifier_list STATIC assignment_expression ']' { TRACE }
	| direct_declarator '[' type_qualifier_list '*' ']' { TRACE }
	| direct_declarator '[' '*' ']' { TRACE }
	| direct_declarator '[' ']' { TRACE }
	| direct_declarator '(' parameter_type_list ')' { TRACE }
	| direct_declarator '(' identifier_list ')' { TRACE }
	| direct_declarator '(' ')' { TRACE }
	;

pointer
	: '*' { TRACE }
	| '*' type_qualifier_list { TRACE }
	| '*' pointer { TRACE }
	| '*' type_qualifier_list pointer { TRACE }
	;

type_qualifier_list
	: type_qualifier { TRACE }
	| type_qualifier_list type_qualifier { TRACE }
	;


parameter_type_list
	: parameter_list { TRACE }
	| parameter_list ',' ELLIPSIS { TRACE }
	;

parameter_list
	: parameter_declaration { TRACE }
	| parameter_list ',' parameter_declaration { TRACE }
	;

parameter_declaration
	: declaration_specifiers declarator { TRACE }
	| declaration_specifiers abstract_declarator { TRACE }
	| declaration_specifiers { TRACE }
	;

identifier_list
	: IDENTIFIER { TRACE }
	| identifier_list ',' IDENTIFIER { TRACE }
	;

type_name
	: specifier_qualifier_list { TRACE }
	| specifier_qualifier_list abstract_declarator { TRACE }
	;

abstract_declarator
	: pointer { TRACE }
	| direct_abstract_declarator { TRACE }
	| pointer direct_abstract_declarator { TRACE }
	;

direct_abstract_declarator
	: '(' abstract_declarator ')' { TRACE }
	| '[' ']' { TRACE }
	| '[' assignment_expression ']' { TRACE }
	| direct_abstract_declarator '[' ']' { TRACE }
	| direct_abstract_declarator '[' assignment_expression ']' { TRACE }
	| '[' '*' ']' { TRACE }
	| direct_abstract_declarator '[' '*' ']' { TRACE }
	| '(' ')' { TRACE }
	| '(' parameter_type_list ')' { TRACE }
	| direct_abstract_declarator '(' ')' { TRACE }
	| direct_abstract_declarator '(' parameter_type_list ')' { TRACE }
	;

initializer
	: assignment_expression { TRACE }
	| '{' initializer_list '}' { TRACE }
	| '{' initializer_list ',' '}' { TRACE }
	;

initializer_list
	: initializer { TRACE }
	| designation initializer { TRACE }
	| initializer_list ',' initializer { TRACE }
	| initializer_list ',' designation initializer { TRACE }
	;

designation
	: designator_list '=' { TRACE }
	;

designator_list
	: designator { TRACE }
	| designator_list designator { TRACE }
	;

designator
	: '[' constant_expression ']' { TRACE }
	| '.' IDENTIFIER { TRACE }
	;

statement
	: labeled_statement { TRACE }
	| compound_statement { TRACE }
	| expression_statement { TRACE }
	| selection_statement { TRACE }
	| iteration_statement { TRACE }
	| jump_statement { TRACE }
	;

labeled_statement
	: IDENTIFIER ':' statement { TRACE }
	| CASE constant_expression ':' statement { TRACE }
	| DEFAULT ':' statement { TRACE }
	;

compound_statement
	: '{' '}' { TRACE }
	| '{' block_item_list '}' { TRACE }
	;

block_item_list
	: block_item { TRACE }
	| block_item_list block_item { TRACE }
	;

block_item
	: declaration { TRACE }
	| statement { TRACE }
	;

expression_statement
	: ';' { TRACE }
	| expression ';' { TRACE }
	;

selection_statement
	: IF '(' expression ')' statement { TRACE }
	| IF '(' expression ')' statement ELSE statement { TRACE }
	| SWITCH '(' expression ')' statement { TRACE }
	;

iteration_statement
	: WHILE '(' expression ')' statement { TRACE }
	| DO statement WHILE '(' expression ')' ';' { TRACE }
	| FOR '(' expression_statement expression_statement ')' statement { TRACE }
	| FOR '(' expression_statement expression_statement expression ')' statement { TRACE }
	| FOR '(' declaration expression_statement ')' statement { TRACE }
	| FOR '(' declaration expression_statement expression ')' statement { TRACE }
	;

jump_statement
	: GOTO IDENTIFIER ';' { TRACE }
	| CONTINUE ';' { TRACE }
	| BREAK ';' { TRACE }
	| RETURN ';' { TRACE }
	| RETURN expression ';' { TRACE }
	;

translation_unit
	: external_declaration { TRACE }
	| translation_unit external_declaration { TRACE }
	;

external_declaration
	: function_definition { TRACE }
	| declaration { TRACE }
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement { TRACE }
	| declaration_specifiers declarator compound_statement { TRACE }
	;

declaration_list
	: declaration { TRACE }
	| declaration_list declaration { TRACE }
	;


