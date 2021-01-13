%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define array_cpy(a, b, cnt); for(int i=0; i<cnt; i++){a[i] = (node*) malloc(sizeof(node)); memcpy(a[i], b[i], sizeof(node));}
#define ID -2
#define NUMBER -1
#define BOOL 0
#define STMT 1
#define PRINT_NUM 2
#define PRINT_BOOL 3
#define PLUS 4
#define MINUS 5
#define MUL 6
#define DIV 7
#define MOD 8
#define GREATER 9
#define SMALLER 10
#define EQU 11
#define AND 12
#define OR 13
#define NOT 14
#define DEFINE 15
#define VAR 16
#define FUN_EXP 17
#define FUN_IDs 18
#define ANONY_FUN_CALL 20
#define NAME_FUN_CALL 21
#define PARA 22
#define IF 23
#define THAN_ELSE 24
#define FUN_NAME 25

void yyerror(const char *message);

typedef struct Node{
        int type;
        int val;
        int _bool;
        int para_cnt;
        char* id;
        struct Node* para_id_list[1000];
        struct Node* para_num_list[1000];
        
        struct Node* left, *right;
} node;

node* root;
node* fun_list[1000];
char* fun_id[1000];
node* var_list[1000];
node* para_layer_list[10000];
int var_cnt=0, fun_cnt=0, layer_cnt=0;

void arg_num_check(int a, int b)
{
        if(a != b) 
        {
                printf("function arguments number Error!\n");
                exit(0);
        }
}

void type_check(int type, int target)
{
        if(type != target) 
        {
                if(target==0)
                        printf("Type Error: Expect 'boolean' but got 'number'!\n");
                else
                        printf("Type Error: Expect 'number' but got 'boolean'!\n");
                exit(0);
        }
}

node* addNode(node* l, node* r, int type)
{
    node *n = (node*) malloc(sizeof(node));
    n->left = l;
    n->right = r;
    n->type = type;
    return n;
}
node* traverse(node* n)
{
        if(n==NULL) return NULL;
        // printf("%d\n", n->type);
        if(n->type==NUMBER){
                node* tmp = (node*) malloc(sizeof(node));
                tmp->val = n->val;
                tmp->type= n->type;
                return tmp;
        }
        else if(n->type==BOOL){
                node* tmp = (node*) malloc(sizeof(node));
                tmp->_bool = n->val;
                tmp->type= n->type;
                return tmp;                
        }
        else if(n->type==ID){
                node* tmp = (node*) malloc(sizeof(node));
                tmp->id = n->id;
                tmp->type=n->type;
                return tmp;
        }
        else if(n->type==STMT){
                node* tmp = (node*) malloc(sizeof(node));
                traverse(n->left);
                traverse(n->right);
                return tmp;
        }
        else if(n->type==PRINT_NUM){
                node* tmp = traverse(n->left);
                type_check(tmp->type, NUMBER);
                printf("%d\n", tmp->val);
                tmp->type = PRINT_NUM;
                return tmp;
        }
        else if(n->type==PRINT_BOOL){
                node* tmp = traverse(n->left);
                type_check(tmp->type, BOOL);
                if(tmp->_bool)
                { 
                        printf("#t\n"); 
                }
                else
                { 
                        printf("#f\n"); 
                }
                tmp->type = PRINT_BOOL;
                return tmp;
        }
        else if(n->type==PLUS){
                node* a = traverse(n->left);
                node* b = traverse(n->right);
                type_check(a->type, NUMBER);
                type_check(b->type, NUMBER);
                node* tmp = (node*) malloc(sizeof(node));
                tmp->val = a->val + b->val;
                // free(a);
                // free(b);
                tmp->type = NUMBER;
                return tmp;
        }
        else if(n->type==MINUS){
                node* a = traverse(n->left);
                node* b = traverse(n->right);
                type_check(a->type, NUMBER);
                type_check(b->type, NUMBER);
                node* tmp = (node*) malloc(sizeof(node));
                tmp->val = a->val - b->val;
                // free(a);
                // free(b);               
                tmp->type = NUMBER;
                return tmp;
        }
        else if(n->type==MUL){
                node* a = traverse(n->left);
                node* b = traverse(n->right);
                type_check(a->type, NUMBER);
                type_check(b->type, NUMBER);
                node* tmp = (node*) malloc(sizeof(node));
                tmp->val = a->val * b->val;
                // free(a);
                // free(b);               
                tmp->type = NUMBER;
                return tmp;
        }
        else if(n->type==DIV){
                node* a = traverse(n->left);
                node* b = traverse(n->right);
                type_check(a->type, NUMBER);
                type_check(b->type, NUMBER);
                node* tmp = (node*) malloc(sizeof(node));
                tmp->val = a->val / b->val;
                // free(a);
                // free(b);               
                tmp->type = NUMBER;
                return tmp;
        }
        else if(n->type==MOD){
                node* a = traverse(n->left);
                node* b = traverse(n->right);
                type_check(a->type, NUMBER);
                type_check(b->type, NUMBER);
                node* tmp = (node*) malloc(sizeof(node));
                tmp->val = a->val % b->val;
                // free(a);
                // free(b);                
                tmp->type = NUMBER;
                return tmp;
        }
        else if(n->type==GREATER){
                node* a = traverse(n->left);
                node* b = traverse(n->right);
                type_check(a->type, NUMBER);
                type_check(b->type, NUMBER);
                node* tmp = (node*) malloc(sizeof(node));
                tmp->_bool = (a->val >  b->val);
                // free(a);
                // free(b);                
                tmp->type = BOOL;
                return tmp;
        }
        else if(n->type==SMALLER){
                node* a = traverse(n->left);
                node* b = traverse(n->right);
                type_check(a->type, NUMBER);
                type_check(b->type, NUMBER);
                node* tmp = (node*) malloc(sizeof(node));
                tmp->_bool = (a->val <  b->val);
                // free(a);
                // free(b);                
                tmp->type = BOOL;
                return tmp;
        }
        else if(n->type==EQU){
                node* a = traverse(n->left);
                node* b = traverse(n->right);
                type_check(a->type, NUMBER);
                node* tmp = (node*) malloc(sizeof(node));
                if(b->left == NULL && b->right ==NULL)
                {
                        type_check(b->type, NUMBER);
                        tmp->_bool = (a->val ==  b->val);
                }
                else
                {
                        tmp->_bool = ( b->_bool &&(a->val ==  b->val));
                }   
                tmp->val = a->val;
                // free(a);
                // free(b);      
                tmp->type = BOOL;
                return tmp;
        }
        else if(n->type==AND){
                node* a = traverse(n->left);
                node* b = traverse(n->right);
                type_check(a->type, BOOL);
                type_check(b->type, BOOL);
                node* tmp = (node*) malloc(sizeof(node));
                tmp->_bool = (a->_bool &&  b->_bool);
                // free(a);
                // free(b);               
                tmp->type = BOOL;
                return tmp;
        }
        else if(n->type==OR){
                node* a = traverse(n->left);
                node* b = traverse(n->right);
                type_check(a->type, BOOL);
                type_check(b->type, BOOL);
                node* tmp = (node*) malloc(sizeof(node));
                tmp->_bool = (a->_bool ||  b->_bool);
                // free(a);
                // free(b);               
                tmp->type = BOOL;
                return tmp;
        }
        else if(n->type==NOT){
                node* a = traverse(n->left);
                type_check(a->type, BOOL);
                node* tmp = (node*) malloc(sizeof(node));
                tmp->_bool = (!a->_bool);
                // free(a);            
                tmp->type = BOOL;
                return tmp;
        }
        else if(n->type==DEFINE){
                node* a = traverse(n->left);
                if(n->right->type == FUN_EXP)
                {
                        fun_id[fun_cnt] = strdup(a->id);
                        fun_list[fun_cnt] = n->right;
                        fun_cnt++;
                }
                else
                {
                        node* b = traverse(n->right);
                        var_list[var_cnt]=(node*) malloc(sizeof(node));
                        var_list[var_cnt]->val = b->val;
                        var_list[var_cnt]->type = b->type;
                        var_list[var_cnt]->_bool = b->_bool;
                        var_list[var_cnt]->id = a->id;
                        var_cnt++;
                }
                // free(a);
                // free(b);
        }
        else if(n->type==VAR){
                node* tmp = (node*) malloc(sizeof(node));
                for(int k=layer_cnt-1; k>=0; k--)
                {
                        for(int j=para_layer_list[k]->para_cnt-1; j>=0; j--)
                        {
                                // printf("%s",var_list[i]->id);
                                if(strcmp(para_layer_list[k]->para_id_list[j]->id, n->id)==0)
                                {
                                        tmp->id = n->id;
                                        tmp->type=para_layer_list[k]->para_num_list[j]->type;
                                        tmp->val = para_layer_list[k]->para_num_list[j]->val;
                                        tmp->_bool = para_layer_list[k]->para_num_list[j]->_bool;
                                        return tmp;
                                }
                        }
                }
                for(int i=var_cnt-1; i>=0; i--)
                {
                        // printf("%s",var_list[i]->id);
                        if(strcmp(var_list[i]->id, n->id)==0)
                        {
                                tmp->id = n->id;
                                tmp->type=var_list[i]->type;
                                tmp->val = var_list[i]->val;
                                tmp->_bool = var_list[i]->_bool;
                                return tmp;
                        }
                }
                printf("Symbol not defined: %s\n", n->id);
                exit(0);
        }
        else if(n->type==FUN_EXP){
                //do nothing
        }
        else if(n->type==FUN_IDs){
                node* tmp = (node*) malloc(sizeof(node));
                node* a = traverse(n->left);
                node* b = traverse(n->right);
                tmp->para_id_list[0]=(node*) malloc(sizeof(node));
                tmp->para_id_list[0]->id = a->id;
                tmp->para_cnt=0;
                tmp->para_cnt++;
                if(b!=NULL)
                {
                        for(int i=0; i<(b->para_cnt); i++)
                        {
                                tmp->para_id_list[i+1]=(node*) malloc(sizeof(node));
                                tmp->para_id_list[i+1]->id = b->para_id_list[i]->id;
                                tmp->para_cnt++;
                        }
                }
                // free(a);
                // free(b);
                return tmp;
        }
        else if(n->type==ANONY_FUN_CALL){
                para_layer_list[layer_cnt] = (node*) malloc(sizeof(node));
                node* a = traverse(n->left->left);
                node* p = traverse(n->right);
                node* tmp;
                if(a!=NULL && p!=NULL)
                {
                        arg_num_check(a->para_cnt,p->para_cnt);
                        array_cpy(para_layer_list[layer_cnt]->para_id_list, a->para_id_list, a->para_cnt);
                        array_cpy(para_layer_list[layer_cnt]->para_num_list, p->para_num_list, p->para_cnt);
                        para_layer_list[layer_cnt]->para_cnt=p->para_cnt;
                        layer_cnt++;
                        tmp = traverse(n->left->right);
                        layer_cnt--;
                        // free(para_layer_list[layer_cnt]);
                }
                else if(a==NULL && p==NULL)
                {
                        tmp = traverse(n->left->right);
                }
                else
                {
                        printf("function arguments number Error!\n");
                        exit(0);
                }
                // printf("%d", tmp->val);
                return tmp;
        }
        else if(n->type==NAME_FUN_CALL){
                node* f_exp = traverse(n->left);
                node* a = traverse(f_exp->left);
                node* p = traverse(n->right);
                node* tmp;
                if(a!=NULL && p!=NULL)
                {
                        arg_num_check(a->para_cnt,p->para_cnt);
                        para_layer_list[layer_cnt] = (node*) malloc(sizeof(node));
                        array_cpy(para_layer_list[layer_cnt]->para_id_list, a->para_id_list, a->para_cnt);
                        array_cpy(para_layer_list[layer_cnt]->para_num_list, p->para_num_list, p->para_cnt);
                        para_layer_list[layer_cnt]->para_cnt=p->para_cnt;
                        layer_cnt++;
                        tmp = traverse(f_exp->right);
                        layer_cnt--;
                }
                else if(a==NULL && p==NULL)
                {
                        tmp = traverse(f_exp->right);
                }
                else
                {
                        printf("function arguments number Error!\n");
                        exit(0);
                }
                // free(para_layer_list[layer_cnt]);
                // printf("%d\n", tmp->val);
                return tmp;
        }
        else if(n->type==PARA){
                node* tmp = (node*) malloc(sizeof(node));
                node* a = traverse(n->left);
                node* b = traverse(n->right);
                tmp->para_num_list[0]=(node*) malloc(sizeof(node));
                tmp->para_num_list[0]->type = a->type;
                tmp->para_num_list[0]->val = a->val;
                tmp->para_num_list[0]->_bool = a->_bool;
                tmp->para_cnt=0;
                tmp->para_cnt++;
                if(b!=NULL)
                {
                        for(int i=0; i<b->para_cnt; i++)
                        {
                                tmp->para_num_list[i+1]=(node*) malloc(sizeof(node));
                                tmp->para_num_list[i+1]->type = b->para_num_list[i]->type;
                                tmp->para_num_list[i+1]->val = b->para_num_list[i]->val;
                                tmp->para_num_list[i+1]->_bool = b->para_num_list[i]->_bool;
                                tmp->para_cnt++;
                        }
                }
                // free(a);
                // free(b);
                return tmp;
        }
        else if(n->type==IF){
                node* a = traverse(n->left);
                type_check(a->type, BOOL);
                node* b;
                if(a->_bool)
                {
                        b = traverse(n->right->left);
                }
                else
                {
                        b = traverse(n->right->right);
                }
                node* tmp = (node*) malloc(sizeof(node));
                tmp->_bool = b->_bool;
                tmp->val = b->val;
                tmp->id = b->id;  
                tmp->type = b->type;
                // free(a);  
                // free(b); 
                return tmp;               
        }
        else if(n->type==THAN_ELSE){
                //do nothing
        }
        else if(n->type==FUN_NAME){
                for(int i=fun_cnt-1; i>=0; i--)
                {
                        // printf("%s",var_list[i]->id);
                        if(strcmp(fun_id[i], n->id)==0)
                        {
                                node* tmp=fun_list[i];
                                return tmp;
                        }
                }
                printf("Symbol not defined: %s\n", n->id);
                exit(0);                
        }                  
}
%}

%union {
int ival;
char* id;
int bval;
struct Node* exp;
}
%token <ival> number
%token <bval> bool_val
%token <id> id
%token <exp> define fun _if mod and or not print_num print_bool

%type <exp> program stmt print_stmt  
%type <exp> EXP IDs
%type <exp> pEXPs mEXPs eEXPs aEXPs oEXPs
%type <exp> num_op plus minus multiply divide modulus
%type <exp> greater smaller equal logical_op and_op or_op not_op
%type <exp> def_stmt var fun_exp fun_ids fun_body fun_call params param fun_name if_exp test_exp than_exp else_exp
%%
program_root    : program { root = $1; }
program         : stmt program { $$ = addNode($1, $2, STMT);}
                | {$$ = NULL;}
                ;
stmt            : EXP {$$=$1;}
                | def_stmt {$$=$1;}
                | print_stmt {$$=$1;}
                ;

print_stmt      : '(' print_num EXP ')'  {$$ = addNode( $3,NULL,PRINT_NUM); }
                | '(' print_bool EXP ')' {$$ = addNode( $3,NULL,PRINT_BOOL); }
                ;

EXP             : bool_val {$$ = addNode(NULL,NULL,BOOL); $$->val = $1; }
                | number {$$ = addNode(NULL,NULL,NUMBER); $$->val = $1; }
                | var {$$=$1;}
                | num_op {$$=$1;}
                | logical_op {$$=$1;}
                | fun_exp {$$=$1;}
                | fun_call {$$=$1;}
                | if_exp {$$=$1;}
                ;

num_op          : plus {$$=$1;}
                | minus {$$=$1;}
                | multiply {$$=$1;}
                | divide {$$=$1;}
                | modulus {$$=$1;}
                | greater {$$=$1;}
                | smaller {$$=$1;}
                | equal {$$=$1;}
                ;

plus            : '(' '+' EXP pEXPs ')' {$$ = addNode($3,$4,PLUS); }
                ;
                
pEXPs           : EXP pEXPs {$$ = addNode($1,$2,PLUS); }
                | EXP {$$ = $1; }
                ;

minus            : '(' '-' EXP EXP ')' {$$ = addNode($3,$4,MINUS); }
                ;

multiply        : '(' '*' EXP mEXPs ')' {$$ = addNode($3,$4,MUL); }
                ;
        
mEXPs           : EXP mEXPs {$$ = addNode($1,$2,MUL); }
                | EXP {$$ = $1; }
                ;

divide          : '(' '/' EXP EXP ')' {$$ = addNode($3,$4,DIV); }
                ;

modulus         : '(' mod EXP EXP ')' {$$ = addNode($3,$4,MOD); }
                ;

greater         : '(' '>' EXP EXP ')' {$$ = addNode($3,$4,GREATER); }
                ;

smaller         : '(' '<' EXP EXP ')' {$$ = addNode($3,$4,SMALLER); }
                ;

equal           : '(' '=' EXP eEXPs ')' {$$ = addNode($3,$4,EQU); }
                ;
eEXPs           : EXP eEXPs {$$ = addNode($1,$2,EQU); }
                | EXP {$$ = $1; }
                ;

logical_op      : and_op 
                | or_op
                | not_op
                ;

and_op          : '(' and EXP aEXPs ')' {$$ = addNode($3,$4,AND); }
                ;

aEXPs           : EXP aEXPs {$$ = addNode($1,$2,AND); }
                | EXP {$$ = $1; }
                ;

or_op           : '(' or EXP oEXPs ')' {$$ = addNode($3,$4,OR); }
                ;

oEXPs           : EXP oEXPs {$$ = addNode($1,$2,OR); }
                | EXP {$$ = $1; }
                ;

not_op          : '(' not EXP ')' {$$ = addNode($3,NULL,NOT); }
                ;

def_stmt        : '(' define id EXP ')' { node* tmp=addNode(NULL,NULL,ID); tmp->id = $3; $$ = addNode(tmp,$4,DEFINE); }
                ;

var             : id {$$ = addNode(NULL,NULL,VAR); $$->id = $1;}
                ;

fun_exp         : '(' fun fun_ids fun_body ')' {$$ = addNode($3,$4,FUN_EXP); }
                ;

fun_ids         : '(' IDs ')' {$$ = $2; }
                ;

IDs             : id IDs { node* tmp=addNode(NULL,NULL,ID); tmp->id = $1;$$ = addNode(tmp,$2,FUN_IDs); }
                | {$$ = NULL;}
                ;     

fun_body        : EXP {$$ = $1; }
                ;                        

fun_call        : '(' fun_exp params ')' {$$ = addNode($2,$3,ANONY_FUN_CALL); }
                | '(' fun_name params ')' {$$ = addNode($2,$3,NAME_FUN_CALL); }
                ;

params          : param params {$$ = addNode($1,$2,PARA); }
                | {$$ = NULL;}
                ;

param           : EXP {$$ = $1; }
                ;


fun_name        : id {$$ = addNode(NULL,NULL,FUN_NAME); $$->id = $1;}

if_exp          : '(' _if test_exp than_exp else_exp ')'  {$$ = addNode($3,NULL,IF); $$->right = addNode($4, $5, THAN_ELSE);}
                ;

test_exp        : EXP {$$ = $1; }
                ;

than_exp        : EXP {$$ = $1; }
                ;

else_exp        : EXP {$$ = $1; }
                ;
%%
void yyerror (const char *message)
{
        printf ("syntax error\n");
}

int main(int argc, char *argv[]) {
        yyparse();
        traverse(root);
        return(0);
}