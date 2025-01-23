%{
#include <stdio.h>  /* Include necessary headers */
#include <stdlib.h>
extern int yylex();  /* Declare yylex() */
void yyerror(const char *s);  /* Declare yyerror() */
%}

/* Token definitions */
%token INT FLOAT CHAR
%token IF ELSE DO WHILE
%token ID NUM
%token PLUS MINUS MUL DIV
%token LT GT LE GE EQ NE
%token ASSIGN SEMICOLON LPAREN RPAREN LBRACE RBRACE
%token OR AND

%right ELSE
%left OR AND
%left EQ NE
%left LT GT LE GE
%left PLUS MINUS
%left MUL DIV

%start program

%%

program:
    declarations statements
    ;

declarations:
    /* Empty */
    | declarations declaration
    ;

declaration:
    type_specifier ID ASSIGN expression SEMICOLON
    | type_specifier ID SEMICOLON
    ;

type_specifier:
    INT
    | FLOAT
    | CHAR
    ;

statements:
    /* Empty */
    | statements statement
    ;

statement:
    expression_statement
    | compound_statement
    | selection_statement
    | iteration_statement
    ;

expression_statement:
    expression SEMICOLON
    | SEMICOLON
    ;

compound_statement:
    LBRACE declarations statements RBRACE
    ;

selection_statement:
    IF LPAREN expression RPAREN statement
    | IF LPAREN expression RPAREN statement ELSE statement
    ;

iteration_statement:
    DO statement WHILE LPAREN expression RPAREN SEMICOLON
    ;

expression:
    assignment_expression
    | expression PLUS assignment_expression
    | expression MINUS assignment_expression
    ;

assignment_expression:
    ID ASSIGN expression
    | logical_or_expression
    ;

logical_or_expression:
    logical_and_expression
    | logical_or_expression OR logical_and_expression
    ;

logical_and_expression:
    equality_expression
    | logical_and_expression AND equality_expression
    ;

equality_expression:
    relational_expression
    | equality_expression EQ relational_expression
    | equality_expression NE relational_expression
    ;

relational_expression:
    additive_expression
    | relational_expression LT additive_expression
    | relational_expression GT additive_expression
    | relational_expression LE additive_expression
    | relational_expression GE additive_expression
    ;

additive_expression:
    term
    | additive_expression PLUS term
    | additive_expression MINUS term
    ;

term:
    factor
    | term MUL factor
    | term DIV factor
    ;

factor:
    ID
    | NUM    /* Handles both integers and floating-point numbers */
    | LPAREN expression RPAREN
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);  /* Error messages */
}

int main() {
    printf("Enter a C program:\n");
    if (yyparse() == 0) {
        printf("Syntax is valid.\n");
    } else {
        printf("Syntax error.\n");
    }
    return 0;
}
