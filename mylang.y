%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int yyerror(char *s);
    int yylex();
    
    // #define MAX_STRING_SIZE 1024
    // char string_value[MAX_STRING_SIZE];
    //int string_len = 0;
    //int in_string_quotes = 0;//1 if in string quotes, 0 if not

    struct Node {
        struct Node* child;
        struct Node* sibling;
        char str[150];
    };
    struct Node* makeNode(char* s);
    void printTree(struct Node* root, int level);
%}
//Above part will participate in y.tab.h as predfined macros

//User defined type, all members share the same memory, 
//always use only enough memory to store the largest member
%union {
    struct Node* node;
    char* str;
}


//Note that we should write different makeNode function for different type of node
//For example, makeIdNode, makeValueNode, makeFromToNode

%start program
%token <node> CREATE
%token <node> SELECT
%token <node> KEYS

//String
%token <node> GET
%token <node> FROM
%token <node> TO
%token <node> GETCS
%token <node> AND
%token <node> EXISTS

%token <node> SET
%token <node> APPEND
//List
%token <node> GETL
%token <node> GETLEN
%token <node> PUSH
%token <node> SETL
%token <node> INSERT
//Set
%token <node> GETS
%token <node> ADD
//Delete
%token <node> DELETE
%token <node> RENAME
%token <node> COPY
%token <node> LS
%token <node> POP
%token <node> REMOVE
%token <node> FLUSH
%token <node> MOVE
%token <node> '(' ')'
%token <node> '[' ']'
%token <node> COMMA

%token <node> IDENTIFIER
%token <node> STRING
%token <node> NUMBER
/* %token <node> SELECTALL */
//Provide values for lexical header files
%type <node> program database_stmt table_stmt create_db select_db ls_keys string_stm list_stm set_stm delete_stm  
%type <node> id_stm id_list value value_list key_value_list
%%

// program structure
program     : database_stmt ';' {
                $$ = makeNode("program");
                $$->child = $1;
                printTree($$,0);
                printf("ACCEPTED\n");
                exit(0);
            }           
            | table_stmt ';'    {
                $$ = makeNode("program");
                $$->child = $1;
                printTree($$,0);
                printf("ACCEPTED\n");
                exit(0);
            }
//database_stmt ';'
database_stmt   : create_db {
                    $$ = makeNode("database_stmt");
                    $$->child = $1;
                }
                | select_db {
                    $$ = makeNode("database_stmt");
                    $$->child = $1;
                }
                | ls_keys{
                    $$ = makeNode("database_stmt");
                    $$->child = $1;
                }

create_db   : CREATE IDENTIFIER {
                    $$ = makeNode("create_db");
                    $1 = makeNode("CREATE");
                    $2 = makeNode("IDENTIFIER");
                    $$->child = $1;
                    $1->sibling = $2;
                }
select_db   : SELECT IDENTIFIER {
                    $$ = makeNode("select_db");
                    $1 = makeNode("SELECT");
                    $2 = makeNode("IDENTIFIER");
                    $$->child = $1;
                    $1->sibling = $2;
                }
ls_keys     : KEYS {
                    $$ = makeNode("ls_keys");
                    $1 = makeNode("KEYS");
                    $$->child = $1;
                }
// table_stmt ';'
table_stmt  : string_stm {
                    $$ = makeNode("table_stmt");
                    $$->child = $1;
                }
            | list_stm {
                    $$ = makeNode("table_stmt");
                    $$->child = $1;
                }
            | set_stm {
                    $$ = makeNode("table_stmt");
                    $$->child = $1;
                }
            | delete_stm {
                    $$ = makeNode("table_stmt");
                    $$->child = $1;
                }
//ID to represent ID or ID from index to index
id_stm      : IDENTIFIER {
                    $$ = makeNode("IDENTIFIER");
                    $$->child = $1;
                }
            | STRING{
                    $$ = makeNode(yylval.str);
                    $$->child = $1;
                    printf("string: %s",yylval.str);
            }
            // From To is going to be one node with 2 field
            | id_stm FROM NUMBER TO NUMBER {
                    $$ = makeNode("id_stm");
                    $1 = makeNode("id_stm");
                    $2 = makeNode("FROM");
                    $3 = makeNode("NUMBER");
                    $4 = makeNode("TO");
                    $5 = makeNode("NUMBER");
                    $$->child = $1;
                    $1->sibling = $2;
                    $2->sibling = $3;
                    $3->sibling = $4;
                    $4->sibling = $5;
                }
id_list :   id_stm {
                    $$ = makeNode("id_list");
                    $$->child = $1;
                }
            | id_stm AND id_list {
                    $$ = makeNode("id_list");
                    $$->child = $1;
                    $1->sibling = $2;
                    $2->sibling = $3;
                }

value       : NUMBER{$$=makeNode("NUMBER");}
            | STRING{$$=makeNode(yylval.str);}
value_list : value {
                    $$ = makeNode("value_list");
                    $$->child = $1;
                }
            | value COMMA value_list {
                    $$ = makeNode("value_list");
                }
key_value_list: id_stm '['value_list']' {
                    $$ = makeNode("key_value_list");
                    $$->child = $1;
                    $3->sibling = $1;
                    $4->sibling = $3;}
            | id_stm '[' value_list ']' AND key_value_list 
            {
                    $$ = makeNode("key_value_list");
                    $1 = makeNode("id_stm");
                    $2 = makeNode("[");
                    $4 = makeNode("]");
                    $5 = makeNode("AND");
                    $$->child = $1;
                    $1->sibling = $2;
                    $2->sibling = $3;
                    $3->sibling = $4;
                    $4->sibling = $5;
                    $5->sibling = $6;
                }
//string_stm ';'
string_stm  : GET id_list {
                    $$ = makeNode("string_stm");
                    $1 = makeNode("GET");
                    $$->child = $1;
                    $1->sibling = $2;
                }
            | GET '(' string_stm ')' {
                    $$ = makeNode("string_stm");
                    $1 = makeNode("GET");
                    $2 = makeNode("(");
                    $4 = makeNode(")");
                    $$->child = $1;
                    $1->sibling = $2;
                    $2->sibling = $3;
                    $3->sibling = $4;
                }
            | GETCS id_list {
                    $$ = makeNode("string_stm");
                    $1 = makeNode("GETC");
                    $2 = makeNode("IDENTIFIER_LIST");
                    $$->child = $1;
                    $1->sibling = $2;
                }
            | EXISTS id_list {
                    $$ = makeNode("string_stm");
                    $1 = makeNode("EXISTS");
                    $2 = makeNode("IDENTIFIER");
                    $$->child = $1;
                    $1->sibling = $2;
                }
            | SET key_value_list {
                    $$ = makeNode("string_stm");
                    $1 = makeNode("SET");
                    $$->child = $1;
                    $1->sibling = $2;
                }
            | APPEND id_stm value_list {
                    $$ = makeNode("string_stm");
                    $1 = makeNode("APPEND");
                    $2 = makeNode("IDENTIFIER");
                    $3 = makeNode("VALUE");
                    $$->child = $1;
                    $1->sibling = $2;
                    $2->sibling = $3;
                }
list_stm    :  GETL id_stm {
            $$ = makeNode("list_stm");
            $1 = makeNode("GETL");
            $2 = makeNode("IDENTIFIER");
            $$->child = $1;
            $1->sibling = $2;
}           | GETLEN id_stm{
            $$ = makeNode("list_stm");
            $1 = makeNode("GETLEN");
            $2 = makeNode("IDENTIFIER");
            $$->child = $1;
            $1->sibling = $2;
}
            | PUSH id_stm value_list {
            // $$ = makeNode("list_stm");
            // $1 = makeNode("PUSH");
            // $2 = makeNode("IDENTIFIER");
            // $3 = makeNode("VALUE");
            // $$->child = $1;
            // $1->sibling = $2;
            // $2->sibling = $3;
            }
            SETL id_stm IDENTIFIER value_list {
            // $$ = makeNode("list_stm");
            // $1 = makeNode("SETL");
            // $2 = makeNode("IDENTIFIER");
            // $3 = makeNode("INDEX");
            }
            INSERT id_stm IDENTIFIER value_list {
            $$ = makeNode("list_stm");
            $1 = makeNode("INSERT");
            $2 = makeNode("IDENTIFIER");
            $3 = makeNode("INDEX");
            $$->child = $1;
            $1->sibling = $2;
            $2->sibling = $3;
            }
set_stm :   GETS id_stm {
            $$ = makeNode("list_stm");
            $1 = makeNode("GETS");
            $2 = makeNode("IDENTIFIER");
            $$->child = $1;
            $1->sibling = $2;
            }
            | ADD id_stm value_list {
            $$ = makeNode("list_stm");
            $1 = makeNode("ADD");
            $2 = makeNode("IDENTIFIER");
            $3 = makeNode("VALUE");
            $$->child = $1;
            $1->sibling = $2;
            $2->sibling = $3;
            }
delete_stm  :   LS id_stm{
            $$ = makeNode("delete_stm");
            $1 = makeNode("LS");
            $2 = makeNode("IDENTIFIER");
            $$->child = $1;
            $1->sibling = $2;
            }
            | RENAME id_stm id_stm{
            $$ = makeNode("delete_stm");
            $1 = makeNode("RENAME");
            $2 = makeNode("IDENTIFIER");
            $3 = makeNode("IDENTIFIER");
            $$->child = $1;
            $1->sibling = $2;
            $2->sibling = $3;
            }
            | COPY id_stm id_stm{
            $$ = makeNode("delete_stm");
            $1 = makeNode("COPY");
            $2 = makeNode("IDENTIFIER");
            $3 = makeNode("IDENTIFIER");
            $$->child = $1;
            $1->sibling = $2;
            $2->sibling = $3;
            }
            | DELETE id_stm{
            $$ = makeNode("delete_stm");
            $1 = makeNode("DELETE");
            $2 = makeNode("IDENTIFIER");
            $$->child = $1;
            $1->sibling = $2;
            }
            | POP id_stm{
            $$ = makeNode("delete_stm");
            $1 = makeNode("POP");
            $2 = makeNode("IDENTIFIER");
            $$->child = $1;
            $1->sibling = $2;
            }
            |REMOVE id_stm value_list{
            $$ = makeNode("delete_stm");
            $1 = makeNode("REMOVE");
            $2 = makeNode("IDENTIFIER");
            $3 = makeNode("VALUE");
            $$->child = $1;
            $1->sibling = $2;
            }
            |FLUSH{
            $$ = makeNode("delete_stm");
            $1 = makeNode("FLUSH");
            $$->child = $1;
            }
            |MOVE id_stm IDENTIFIER{
            $$ = makeNode("delete_stm");
            $1 = makeNode("MOVE");
            $2 = makeNode("IDENTIFIER");
            $3 = makeNode("IDENTIFIER_DATABASE");
            $$->child = $1;
            $1->sibling = $2;
            $2->sibling = $3;
            }



%%

struct Node* makeNode(char* s) {
    struct Node *node = malloc(sizeof(struct Node));
    node->child = NULL;
    node->sibling = NULL;
    strcpy(node->str,s);
    return node;
}
void printTree(struct Node* root,int level)
{
	if(root==NULL)
		return;
	if(root->child==NULL && root->str[0] >= 97 && root->str[0]<=122)
		return;
	for(int i=0;i<level;i++)
		printf("	");
	if( root->str[0] >= 65 && root->str[0]<=90)
	{
		printf("\033[01;33m");
		printf("-%s\n",root->str);
		printf("\033[0m");
	}
	else
	{
		printf("\033[0;32m");
		printf("-%s\n",root->str);
		printf("\033[0m");
	}
	if(root->child!=NULL)
	{
		root = root->child;
		while(root!=NULL)
		{
			printTree(root,level+1);
			root = root->sibling;
		}
	}
}

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 1;
}
int main(void){
    printf("ENTER AN SQL QUERY\n");
    //apply grammer rules to input 
    yyparse();
    
}
