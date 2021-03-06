%{
#include 	<string.h>
#include	<stdio.h>
#include	<stdlib.h>
void comentario (void);
#define LT 			1
#define LE 			2
#define	GT			3
#define	GE			4
#define	EQ			5
#define	NE			6
#define PL			1
#define MI			2
#define MU			1
#define DI			2
#define RE			3

/* Definicao dos tipos de identificadores */
#define IDVOID		0
#define IDPROG		1
#define IDVAR		2
#define	IDFUNC		3
#define	IDPROC		4

/* Definicao dos tipos de passagem de parametros*/
#define PARAMVAL	1
#define PARAMREF	2

/* Definicao dos tipos de variaveis */
#define	NAOVAR		0
#define	INTEIRO		1
#define	LOGICO		2
#define	REAL		3
#define	CARACTERE	4
#define VOID		5

/* Definicao dos operadores de quadruplas */
#define	OPOR		1
#define	OPAND		2
#define OPLT 		3
#define OPLE 		4
#define	OPGT	   	5
#define	OPGE		6
#define	OPEQ		7
#define	OPNE		8
#define	OPMAIS		9
#define	OPMENOS		10
#define	OPMULTIP	11
#define	OPDIV		12
#define	OPRESTO		13
#define	OPMENUN		14
#define	OPNOT		15
#define	OPATRIB		16
#define	OPENMOD		17
#define	NOP			18
#define	OPJUMP		19
#define	OPJF		20
#define	PARAM		21
#define	OPREAD		22
#define	OPWRITE		23
#define	IND			24
#define	INDEX		25
#define	CONTAPONT	26
#define	ATRIBPONT	27
#define CALLOP		28
#define OPEXIT		29
#define RETURNOP	30

/* Definicoes de constantes para os tipos dos operandos */
#define	IDLEOPND	0
#define	VAROPND		1
#define	INTOPND		2
#define	REALOPND	3
#define	CHAROPND	4
#define	LOGICOPND	5
#define	CADOPND		6
#define	ROTOPND		7
#define	MODOPND		8
#define	FUNCOPND	9

/* Definicao de outras constantes */
#define	NCLASSHASH	23
#define	VERDADE		1
#define	FALSO		0
#define MAXDIMS		10

/* Strings para nomes dos tipos de identificadores*/
char *nometipid[5] = {" ", "IDPROG", "IDVAR", "IDFUNC", "IDPROC"};

/* Strings para nomes dos tipos de variaveis */
char *nometipvar[6]={"NAOVAR", "INTEIRO", "LOGICO", "REAL", "CARACTERE", "VOID"};

/* Strings para operadores de quadruplas */

char *nomeoperquad[31] = {"",
	"OR", "AND", "LT", "LE", "GT", "GE", "EQ", "NE", "MAIS",
	"MENOS", "MULT", "DIV", "RESTO", "MENUN", "NOT", "ATRIB",
	"OPENMOD", "NOP", "JUMP", "JF", "PARAM", "READ", "WRITE",
	"IND", "INDEX", "CONTAPONT", "ATRIBPONT", "CALLOP", "OPEXIT",
	"RETURNOP"
};

/*
	Strings para tipos de operandos de quadruplas
 */

char *nometipoopndquad[10] = {"IDLE",
	"VAR", "INT", "REAL", "CARAC", "LOGIC", "CADEIA", "ROTULO", "MODULO", "FUNCAO"
};

/* Quadruplas */

typedef struct celquad celquad; 
typedef celquad *quadrupla; 

typedef struct celmodhead celmodhead;
typedef celmodhead *modhead; 

/* Declaracoes para a tabela de simbolos */
typedef struct celsimb celsimb;
typedef celsimb *simbolo;
typedef struct elemlistsimb elemlistsimb;
typedef elemlistsimb *listsimb;
struct celsimb {
	char *cadeia;
	int tid, tvar, tparam, ndims, dims[MAXDIMS+1], nparams;
	char inic, ref, array, param;
	simbolo escopo, prox;
	listsimb listvar, listparam, listfunc;
	modhead fhead;
	int *valint;
	float *valfloat;
	char *valchar, *vallogic;

};
struct elemlistsimb {
	simbolo simb;
	listsimb prox;
};

/* Lista de tipos */
typedef struct celtiponoh celtiponoh;
typedef celtiponoh *tiponoh;
struct celtiponoh{
	int tipo;
	tiponoh prox;
};
tiponoh listatipos;

/* Union para atributo de um operando */
typedef union atribopnd atribopnd; 
union atribopnd {
	simbolo simb; 
	int valint; 
	float valfloat;
	char valchar;
	char vallogic;
	char *valcad;
	quadrupla rotulo; 
	modhead modulo;
};

/* Struct de um operando */
typedef struct operando operando; 
struct operando{
	int tipo;
	atribopnd atr;
};

/* Struct de uma quadrupla */
struct celquad{
	int num;
	int oper;
	operando opnd1, opnd2, result;
	quadrupla prox;
};


/* Struct de um cabecalho de modulo */
struct celmodhead {
	simbolo modname; modhead prox;
	int modtip;
	quadrupla listquad;
};

/* Declaracoes para atributos de expressoes e variaveis */
typedef struct infoexpressao infoexpressao;
struct infoexpressao { 
	int tipo;
	operando opnd; 
};

typedef struct infovariavel infovariavel;
struct infovariavel {
	simbolo simb;
	operando opnd; 
};

/* Variaveis globais para a tabela de simbolos e analise semantica */
simbolo tabsimb[NCLASSHASH];
simbolo simb;
simbolo escopo, escglobal;
int tipocorrente;
int declparam;

/* Variaveis globais para o manuseio das quadruplas */
quadrupla quadcorrente, quadaux, quadaux2;
modhead codintermed, modcorrente;
int oper, numquadcorrente;
operando opnd1, opnd2, result, opndaux;
int numtemp;
const operando opndidle = {IDLEOPND, 0};


/* Prototipos das funcoes para a tabela de simbolos e analise semantica */
void InicTabSimb(void);
void ImprimeTabSimb(void);
simbolo InsereSimb(char *,int,int,simbolo);
int hash(char *);
simbolo ProcuraSimb(char *,simbolo);
void DeclaracaoRepetida(char *);
void TipoInadequado(char *);
void NaoDeclarado(char *);
void VerificaInicRef(void);
void Incompatibilidade(char *);
void Esperado(char *);
void NaoEsperado(char *);
void ErroLinguagem(char *);
void ErroInterno(char *);
void AdicionarListaTipo(int);
void LimparListaTipos(void);
void VerificarParams(listsimb);
void VerificarCompatibilidade(const char *, int, int);
void VerificarFuncao(char *, int);

/* Prototipos das funcoes para o codigo intermediario */
void InicCodIntermed (void);
void InicCodIntermMod (simbolo);
quadrupla GeraQuadrupla (int, operando, operando, 	operando);
simbolo NovaTemp (int);
void ImprimeQuadruplas (void);
void RenumQuadruplas (quadrupla, quadrupla);

/* Variaveis globais para o interpretador */
FILE *finput;


/* Prototipos das funcoes para o interpretador */

void InterpCodIntermed (void);
void AlocaVariaveis (void);
void ExecQuadWrite (quadrupla);
void ExecQuadMais (quadrupla);
void ExecQuadMenos (quadrupla);
void ExecQuadMultip (quadrupla);
void ExecQuadDiv (quadrupla);
void ExecQuadResto (quadrupla);
void ExecQuadMenum (quadrupla);
void ExecQuadLT (quadrupla);
void ExecQuadLE (quadrupla);
void ExecQuadGT (quadrupla);
void ExecQuadGE (quadrupla);
void ExecQuadEQ (quadrupla);
void ExecQuadNE (quadrupla);
void ExecQuadOR	(quadrupla);
void ExecQuadAND(quadrupla);
void ExecQuadNOT(quadrupla);
void ExecQuadAtrib (quadrupla);
void ExecQuadRead (quadrupla);
void ExecQuadIndex(quadrupla);
void ExecQuadContapont(quadrupla);
void ExecQuadAtribpont(quadrupla);

/*	Declaracoes para pilhas de operandos  */

typedef struct nohopnd nohopnd;
struct nohopnd {
	operando opnd;
	nohopnd *prox;
};
typedef nohopnd *pilhaoperando;
pilhaoperando pilhaopnd;
pilhaoperando pilhaindex;

/*  Prototipos das funcoes para pilhas de operandos  */

void EmpilharOpnd (operando, pilhaoperando *);
void DesempilharOpnd (pilhaoperando *);
operando TopoOpnd (pilhaoperando);
void InicPilhaOpnd (pilhaoperando *);
char VaziaOpnd (pilhaoperando);



int tab = 0;
void tabular (void);
%}
%union {
	char string[50];
	int atr, valint;
	float valreal;
	char carac;
	infoexpressao infoexpr;
	infovariavel infovar;
	simbolo simb;
	int tipoexpr;
	int nsubscr;
	int nparams;
	quadrupla quad;
	int nargs;
}
%type	<infovar>	Variable FuncCall
%type	<infoexpr>	Expression  AuxExpr1  AuxExpr2  AuxExpr3  AuxExpr4  Term  Factor  WriteElem
%type	<nsubscr>	SubscrList
%type	<nparams>	ExprList
%type	<nargs>		ReadList  WriteList
%token 				CALL
%token 				CHAR
%Token 				ELSE
%token				FALSE
%token 				FLOAT
%token 				FOR
%token 				FUNCTION
%token 				IF
%token 				INT
%token 				LOGIC
%token 				PROCEDURE
%token 				PROGRAM
%token 				READ
%token 				REPEAT
%token 				RETURN
%token 				TRUE
%token 				VAR
%token 				WHILE
%token 				WRITE
%token	<string>	ID
%token	<valint>	INTCT
%token	<string>	CHARCT
%token	<valreal>	FLOATCT
%token	<string>	STRING
%token				OR
%token				AND
%token				NOT
%token	<atr>		RELOP
%token	<atr>		ADOP
%token	<atr>		MULTOP
%token				NEG
%token				OPPAR
%token				CLPAR
%token				OPBRAK
%token				CLBRAK
%token				OPBRACE
%token				CLBRACE
%token				SCOLON 
%token				COMMA
%token				ASSIGN
%token	<carac>		INVAL
%nonassoc 			LOWER_THAN_ELSE
%nonassoc 			ELSE
%%
Prog			:  {
					InicTabSimb (); InicCodIntermed (); numtemp = 0;
				}
					PROGRAM ID SCOLON
				{
					InicTabSimb();
					listatipos = NULL;
					declparam = FALSO;
					printf("program %s;\n\n", $3);
					simb = escglobal = escopo = InsereSimb($3, IDPROG, NAOVAR, NULL);
					InicCodIntermMod (simb);
					simb->fhead = modcorrente;
					opnd1.tipo = MODOPND;
					opnd1.atr.modulo = modcorrente;
					GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
				}
				   Decls  SubProgs
				{
					modcorrente = codintermed->prox;
					quadcorrente = modcorrente->listquad->prox;
					numquadcorrente = 1;
				}
				   CompStat
				{
					GeraQuadrupla(OPEXIT, opndidle, opndidle, opndidle);
					VerificaInicRef();
					ImprimeTabSimb();
					ImprimeQuadruplas();
					InterpCodIntermed ();
				}
				;
Decls 			:	
				|  VAR {printf("var\n"); tab++; } DeclList {tab--;}
				;
DeclList		:  Declaration
				|  DeclList  Declaration
				;
Declaration 	:  Type ElemList SCOLON {printf(";\n");} 
				;
Type			:  INT {tabular(); printf("int "); tipocorrente = INTEIRO;}
				|  FLOAT {tabular(); printf("float "); tipocorrente = REAL;}
				|  CHAR {tabular(); printf("char "); tipocorrente = CARACTERE;}
				|  LOGIC {tabular(); printf("logic ");  tipocorrente = LOGICO;}
				;
ElemList    	:  Elem
				|  ElemList COMMA {printf(", ");} Elem
				;
Elem        	:  ID 
				{
					printf("%s", $1);
					if(ProcuraSimb($1, escopo) != NULL)
						DeclaracaoRepetida($1);
					else{
						simb = InsereSimb($1, IDVAR, tipocorrente, escopo);
						simb->array=FALSO;
						simb->ndims=0;
					}
				}  DimList
				;
DimList	    	: 
				|  DimList  Dim  {simb->array=VERDADE;}
				;
Dim				:  OPBRAK INTCT CLBRAK 
				{
					printf("[%d]", $2);
					if($2<=0)
						Esperado("Valor inteiro positivo");
					simb->ndims++;
					simb->dims[simb->ndims]=$2;
				}
				;
SubProgs	    :
				|  SubProgs  SubProgDecl
				;
SubProgDecl   	:  Header  Decls  CompStat
				{
					escopo = escopo->escopo;
					GeraQuadrupla(OPEXIT, opndidle, opndidle, opndidle);
					if (escopo == NULL) printf("Erro, escopo voltou demais\n");
				}
				;
Header   		:  FuncHeader
				|  ProcHeader
				;
FuncHeader		:  FUNCTION {tabular(); printf("function ");} Type ID OPPAR
				{
					printf("%s(", $4);
					if (ProcuraSimb($4, escopo) != NULL)
						DeclaracaoRepetida("Funcao com o mesmo nome que uma variavel global");
					escopo = simb = InsereSimb($4, IDFUNC, tipocorrente, escopo);
					InicCodIntermMod (simb);
					simb->fhead = modcorrente;
					opnd1.tipo = MODOPND;
					opnd1.atr.modulo = modcorrente;
					GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
				}
				   FuncHeaderAux
				;
FuncHeaderAux	:  CLPAR  SCOLON {printf(");\n");}
				|  ParamList  CLPAR  SCOLON {printf(");\n");}
				;
ProcHeader  	:  PROCEDURE ID OPPAR 
				{
					tabular();
					printf("procedure %s(", $2);
					if (ProcuraSimb($2, escopo) != NULL)
						DeclaracaoRepetida("Funcao com o mesmo nome que uma variavel global");
					escopo = simb = InsereSimb($2, IDPROC, NAOVAR, escopo);
					InicCodIntermMod (simb);
					simb->fhead = modcorrente;
					opnd1.tipo = MODOPND;
					opnd1.atr.modulo = modcorrente;
					GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
				}
				   CLPAR SCOLON {printf(");\n");}
				|  PROCEDURE ID OPPAR
				{
					tabular();
					printf("procedure %s(", $2);
					escopo = simb = InsereSimb($2, IDPROC, NAOVAR, escopo);
					InicCodIntermMod (simb);
					simb->fhead = modcorrente;
					opnd1.tipo = MODOPND;
					opnd1.atr.modulo = modcorrente;
					GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
				}
				   ParamList CLPAR SCOLON {printf(");\n");}
				;
ParamList   	:  Parameter
				|  ParamList  COMMA {printf(", ");} Parameter
				;
Parameter   	:  Type ID
				{
					printf("%s", $2);
					declparam = VERDADE;
					simbolo s = ProcuraSimb($2, escglobal);
					if (s != NULL && (s->tid == IDFUNC || s->tid == IDFUNC)){
						ErroLinguagem("Subprograma nao pode ser usado como parametro.");
					}
					InsereSimb($2, IDVAR, tipocorrente, escopo);
					declparam = FALSO;
				}
				;
CompStat		:  OPBRACE
				{
					tabular();
					printf("\{\n");
					tab++;
				}
				   StatList  CLBRACE
				{
					tab--;
					tabular();
					printf("}\n");
				}
				;
StatList		:
				|  StatList  Statement
				;
Statement   	:  CompStat  |  IfStat  |  WhileStat  |  RepeatStat
            	|  ForStat  |  ReadStat  |  WriteStat  |  AssignStat
            	|  CallStat  |  ReturnStat  |  SCOLON {printf(";\n");}
				;
IfStat			:  IF OPPAR {tabular(); printf("if("); tab++;} Expression  CLPAR
				{
					printf(")\n");
					if($4.tipo!=LOGICO)
						Incompatibilidade("Expressao do comando 'if' deve ser logica");
					opndaux.tipo = ROTOPND;
					$<quad>$ = GeraQuadrupla(OPJF, $4.opnd, opndidle, opndaux);
				}
					Statement 
				{
					tab--;
					$<quad>$ = quadcorrente;
					$<quad>6->result.atr.rotulo = GeraQuadrupla(NOP, opndidle, opndidle, opndidle);
				} 
					ElseStat
				{
					if ($<quad>8->prox != quadcorrente) {
						quadaux = $<quad>8->prox;
						$<quad>8->prox = quadaux->prox;
						quadaux->prox = $<quad>8->prox->prox;
						$<quad>8->prox->prox = quadaux;
						RenumQuadruplas ($<quad>8, quadcorrente);
					}
				}
				;
ElseStat		:  
				|  	ELSE 
				{	
					tabular();
					printf("else\n");
					tab++;
					opndaux.tipo = ROTOPND;
					$<quad>$ = GeraQuadrupla (OPJUMP, opndidle, opndidle, opndaux);

				} 
					Statement 
				{
					tab--;
					$<quad>2->result.atr.rotulo = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
				}
				;
WhileStat   	:  WHILE OPPAR 
				{
					tabular(); 
					printf("while(");
					$<quad>$ = GeraQuadrupla(NOP, opndidle,opndidle,opndidle);
				} 
					Expression CLPAR {printf(")\n");} 
				{
					if($4.tipo!=LOGICO)
						Incompatibilidade("Expressao do comando 'while' deve ser logica");
					opndaux.tipo = ROTOPND;
					$<quad>$ = GeraQuadrupla(OPJF, $4.opnd, opndidle, opndaux);
				}
					Statement
				{
					opndaux.tipo = ROTOPND;
					$<quad>$ = GeraQuadrupla(OPJUMP, opndidle,opndidle,opndaux);
					$<quad>$->result.atr.rotulo = $<quad>3;
					$<quad>7->result.atr.rotulo = GeraQuadrupla(NOP, opndidle, opndidle, opndidle);
				}
				;
RepeatStat  	:  REPEAT 
				{
					tabular();
					printf("repeat\n");
					$<quad>$ = GeraQuadrupla(NOP, opndidle, opndidle, opndidle);
				} 
					Statement  WHILE OPPAR 
				{
					tabular();
					printf("while(");
				} 
					Expression CLPAR SCOLON {printf(");\n");}
				{
					if($7.tipo!=LOGICO)
						Incompatibilidade("Expressao do comando 'do repeat' deve ser logica");
					opndaux.tipo = ROTOPND;
					quadaux = GeraQuadrupla(OPJF, $7.opnd, opndidle, opndaux);
					opndaux.atr.rotulo = $<quad>2;
					GeraQuadrupla(OPJUMP, opndidle, opndidle, opndaux);
					quadaux->result.atr.rotulo = GeraQuadrupla(NOP, opndidle, opndidle, opndidle);
				}
				;
ForStat	    	:  FOR OPPAR {tabular(); printf("for(");} Variable ASSIGN {printf(" = ");} Expression SCOLON 
				{
					/* $$$$$$ 9 $$$$$$ */
					printf("; ");
					if ($4.simb == NULL) {
						ErroInterno("Variable null.");
					}
					else {
						$4.simb->inic = VERDADE;
						if($4.simb->tid!=IDVAR || ($4.simb->tvar!=INTEIRO && $4.simb->tvar!=CARACTERE) || $4.simb->array!=FALSO)
							Incompatibilidade("Variavel de inicializacao incompativel para o operador 'for'");
						VerificarCompatibilidade("assign", $4.simb->tvar, $7.tipo);
						GeraQuadrupla(OPATRIB,$7.opnd,opndidle,$4.opnd);
						
						/* quadrupla para verificacao da condicao */
						$<quad>$ = GeraQuadrupla(NOP, opndidle, opndidle, opndidle);
					}
				}
					Expression SCOLON {printf("; ");} Variable ASSIGN 
				{
					/* $$$$$$ 15 $$$$$$ */
					printf(" = ");
					opndaux.tipo = ROTOPND;
					$<quad>$ = GeraQuadrupla(OPJF, $10.opnd, opndidle, opndaux);
				} 
					Expression  CLPAR
				{
					/* $$$$$$ 18 $$$$$$ */
					printf(")\n");
					if ($4.simb == NULL || $13.simb == NULL) {
						ErroInterno("Variable null.");
					}
					else {
						$13.simb->inic = VERDADE;
						if(strcmp($4.simb->cadeia, $13.simb->cadeia))
							Incompatibilidade("Variavel de atualizacao deve ser a mesma de inicializacao");
						if(($7.tipo != INTEIRO && $7.tipo != CARACTERE) || ($16.tipo != INTEIRO && $16.tipo != CARACTERE) || $10.tipo!=LOGICO)
							Incompatibilidade("Expressoes de tipo inadequado");
						VerificarCompatibilidade("assign", $13.simb->tvar, $16.tipo);
						$<quad>$ = GeraQuadrupla(OPATRIB,$16.opnd,opndidle,$13.opnd);
					}
				} 
					Statement 
				{
					/* $$$$$$ 20 $$$$$$ */
					opndaux.tipo = ROTOPND;
					opndaux.atr.rotulo = $<quad>9;
					$<quad>$ = quadcorrente;
					GeraQuadrupla(OPJUMP, opndidle, opndidle,opndaux);
					
					quadaux = $<quad>15->prox;
					$<quad>15->prox = $<quad>18->prox;
					$<quad>$->prox = quadaux;
					$<quad>18->prox = quadcorrente;
					
					$<quad>$ = GeraQuadrupla(NOP, opndidle, opndidle, opndidle);
					opndaux.atr.rotulo = $<quad>$;
					$<quad>15->result = opndaux;
					
					RenumQuadruplas($<quad>9, quadcorrente);
					
					/* colocando expressao de atualizacao ao fim */
					
				}
				;
ReadStat   		:  READ OPPAR {tabular(); printf("read(");} ReadList 
					{	
						if($4 != 0){
							opnd1.tipo = INTOPND;
							opnd1.atr.valint = $4;
							GeraQuadrupla(OPREAD, opnd1, opndidle, opndidle);
						}
					}
					CLPAR SCOLON {printf(");\n");}
				;
ReadList		:  Variable
					{
						if($1.simb->ndims == 0){
							$$ = 1;
							GeraQuadrupla(PARAM, $1.opnd, opndidle,opndidle);
						}
						else{
							opnd2.tipo = VAROPND;
							opnd2.atr.simb = NovaTemp ($1.opnd.atr.simb->tvar);
							GeraQuadrupla(PARAM, opnd2, opndidle, opndidle);
							opnd1.tipo = INTOPND;
							opnd1.atr.valint = 1;
							GeraQuadrupla(OPREAD, opnd1, opndidle, opndidle);
							GeraQuadrupla(ATRIBPONT, opnd2, opndidle, $1.opnd);
							$$ = 0;
						}
					}
				|  ReadList COMMA {printf(", ");} Variable
					{
						if($4.simb->ndims == 0){
							$$ = $1 + 1;
							/* Guarda para quando aparecer um vetor */
							quadaux = GeraQuadrupla(PARAM, $4.opnd, opndidle, opndidle);
						}
						else{
							opnd2.tipo = VAROPND;
							opnd2.atr.simb = NovaTemp ($4.opnd.tipo);
							quadaux2 = GeraQuadrupla(PARAM, opnd2, opndidle, opndidle);
							opnd1.tipo = INTOPND;
							opnd1.atr.valint = $1;
							$<quad>$ = GeraQuadrupla(OPREAD, opnd1, opndidle, opndidle);
							
							/* Read do vetor */
							opnd1.atr.valint = 1;
							GeraQuadrupla(OPREAD, opnd1, opndidle, opndidle);
							GeraQuadrupla(ATRIBPONT, opnd2, opndidle, $4.opnd);
							
							/* Troca de referencias */
							quadaux2->prox = $<quad>$->prox;
							$<quad>$->prox = quadaux->prox;
							quadaux->prox = $<quad>$;
							RenumQuadruplas(quadaux, quadaux2->prox);
							
							/* atualizacao */
							$$ = 0;
						}
						
					}
				;
WriteStat   	:  WRITE OPPAR {tabular(); printf("write(");} WriteList 
					{
						opnd1.tipo = INTOPND;
						opnd1.atr.valint = $4;
						GeraQuadrupla (OPWRITE, opnd1, opndidle, opndidle);
					} 
					CLPAR SCOLON {printf(");\n");}
				;
WriteList		:  WriteElem
					{
						$$ = 1;
						GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
					}
				|  WriteList COMMA {printf(", ");} WriteElem
					{
						$$ = $1 + 1;
						GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
					}
				;
WriteElem		:  STRING 
					{
						printf("\"%s\"", $1);
						$$.opnd.tipo = CADOPND;
						$$.opnd.atr.valcad = malloc(strlen($1) + 1);
						strcpy($$.opnd.atr.valcad, $1);
					}
				|  Expression  /*  default:   $$ = $1   */
				;
CallStat    	:  CALL ID OPPAR
				{
					tabular();
					printf("call %s();\n", $2);
					VerificarFuncao($2, 0);
					simbolo simb = ProcuraSimb($2, escglobal);
					opnd1.tipo = FUNCOPND; opnd1.atr.modulo = simb->fhead;
					GeraQuadrupla(CALLOP, opnd1, opndidle, opndidle);
				}
				   CLPAR SCOLON
				|  CALL ID OPPAR
				{
					tabular();
					printf("call %s(", $2);
				}
				   ExprList CLPAR SCOLON
				{
					printf(");\n");
					VerificarFuncao($2, $5);
					simbolo simb = ProcuraSimb($2, escglobal);
					opnd1.tipo = FUNCOPND; opnd1.atr.modulo = simb->fhead;
					opnd2.tipo = INTOPND; opnd2.atr.valint = $5;
					GeraQuadrupla(CALLOP, opnd1, opnd2, opndidle);
				}
				;
ReturnStat  	:  RETURN {tabular(); printf("return");} SCOLON
				{
					printf(";\n");
					if (escopo->tid != IDPROG && escopo->tid != IDPROC)
						Incompatibilidade("Tipo de retorno nao deveria ser void");
					GeraQuadrupla(RETURNOP, opndidle, opndidle, opndidle);
				}
				|  RETURN {tabular(); printf("return ");} Expression SCOLON
				{
					printf(";\n");
					if (escopo->tid != IDFUNC)
						Incompatibilidade("Retorno de nao funcao nao deve ter tipo");
					VerificarCompatibilidade("return", escopo->tvar, $3.tipo);
					GeraQuadrupla(RETURNOP, $3.opnd, opndidle, opndidle);
				}
				;
AssignStat  	: {tabular();} Variable ASSIGN {printf(" = ");} Expression SCOLON {printf(";\n");}
				{
					if ($2.simb == NULL) {
						ErroInterno("Variable null.");
					}
					else {
						$2.simb->inic = VERDADE;
						if($2.simb->tvar == NAOVAR || $2.simb->tid != IDVAR)
							Esperado("Esperada uma variavel inteira, caractere, real ou logica para atribuicao.");
						VerificarCompatibilidade("assign", $2.simb->tvar, $5.tipo);
						if($2.simb->ndims == 0)
							GeraQuadrupla(OPATRIB,$5.opnd,opndidle,$2.opnd);
						else
							GeraQuadrupla(ATRIBPONT, $5.opnd, opndidle, $2.opnd);
					}
				}
				;
ExprList		:  Expression
				{
					$$=1;
					AdicionarListaTipo($1.tipo);
					GeraQuadrupla(PARAM, $1.opnd, opndidle, opndidle);
				}
				|  ExprList COMMA {printf(", ");} Expression
				{
					$$=$1+1; 
					AdicionarListaTipo($4.tipo);
					GeraQuadrupla(PARAM, $4.opnd, opndidle, opndidle);
				}
				;
Expression  	:  AuxExpr1
				|  Expression OR {printf(" || ");} AuxExpr1
				{
					if($1.tipo!=LOGICO || $4.tipo!=LOGICO)
						Incompatibilidade("Operando improprio para operador logico");
					$$.tipo=LOGICO;
					$$.opnd.tipo = VAROPND;  
					$$.opnd.atr.simb = NovaTemp ($$.tipo);
					GeraQuadrupla (OPOR, $1.opnd, $4.opnd, $$.opnd);
				}
				;
AuxExpr1    	:  AuxExpr2
				|  AuxExpr1 AND {printf(" && ");} AuxExpr2
				{
					if($1.tipo!=LOGICO || $4.tipo!=LOGICO)
						Incompatibilidade("Operando improprio para operador logico");
					$$.tipo=LOGICO;
					$$.opnd.tipo = VAROPND;  
					$$.opnd.atr.simb = NovaTemp ($$.tipo);
					GeraQuadrupla (OPAND, $1.opnd, $4.opnd, $$.opnd);
				}
				;
AuxExpr2    	:  AuxExpr3
				|  NOT {printf("!");} AuxExpr3
				{
					if($3.tipo!=LOGICO)
						Incompatibilidade("Operando improprio para operador logico");
					$$.tipo=LOGICO;
					$$.opnd.tipo = VAROPND;  
					$$.opnd.atr.simb = NovaTemp ($$.tipo);
					GeraQuadrupla (OPNOT, $3.opnd, opndidle, $$.opnd);

				}
				;
AuxExpr3    	:  AuxExpr4	
				|  AuxExpr4  RELOP
				{
					switch($2){
						case LT: printf(" < "); break;
						case LE: printf(" <= "); break;
						case GT: printf(" > "); break;
						case GE: printf(" >= "); break;
						case EQ: printf(" == "); break;
						case NE: printf(" != "); break;
					}
				}
				AuxExpr4
				{
					switch($2){
						case LT:
						case LE:
						case GT:
						case GE:
							if(($1.tipo!=INTEIRO && $1.tipo!=REAL && $1.tipo!=CARACTERE)
								|| ($4.tipo!=INTEIRO && $4.tipo!=REAL && $4.tipo!=CARACTERE))
								Incompatibilidade("Operando improprio para operador relacional");
							break;
						case EQ:
						case NE:
							//Se for logico, o outro operando também deve ser
							if($1.tipo == LOGICO && $4.tipo != LOGICO || $1.tipo != LOGICO && $4.tipo == LOGICO)
								Incompatibilidade("Operador improprio para operador relacional");
							break;
						default:
							break;
					}
					$$.tipo=LOGICO;
					/* criando quadrupla */
					$$.opnd.tipo = VAROPND;  
					$$.opnd.atr.simb = NovaTemp ($$.tipo);
					switch($2){
						case LT: GeraQuadrupla(OPLT, $1.opnd, $4.opnd, $$.opnd); break;
						case LE: GeraQuadrupla(OPLE, $1.opnd, $4.opnd, $$.opnd); break;
						case GT: GeraQuadrupla(OPGT, $1.opnd, $4.opnd, $$.opnd); break;
						case GE: GeraQuadrupla(OPGE, $1.opnd, $4.opnd, $$.opnd); break;
						case EQ: GeraQuadrupla(OPEQ, $1.opnd, $4.opnd, $$.opnd); break;
						case NE: GeraQuadrupla(OPNE, $1.opnd, $4.opnd, $$.opnd); break;
					}

				}
				;
AuxExpr4    	:  Term
				|  AuxExpr4  ADOP
				{
					switch($2){
						case PL: printf(" + "); break;
						case MI: printf(" - "); break;
					}
				}
				Term
				{
					if(($1.tipo!=INTEIRO && $1.tipo!=REAL && $1.tipo!=CARACTERE)
						|| ($4.tipo!=INTEIRO && $4.tipo!=REAL && $4.tipo!=CARACTERE))
						Incompatibilidade("Operando improprio para operador aritmetico");
					if($1.tipo==REAL || $4.tipo==REAL)
						$$.tipo=REAL;
					else
						$$.tipo=INTEIRO;
					$$.opnd.tipo = VAROPND;
					$$.opnd.atr.simb = NovaTemp($$.tipo);
					switch($2){
						case PL: GeraQuadrupla(OPMAIS, $1.opnd, $4.opnd, $$.opnd); break;
						case MI: GeraQuadrupla(OPMENOS, $1.opnd, $4.opnd, $$.opnd); break;
					}
				}
				;
Term  	    	:  Factor
				|  Term  MULTOP 
				{
					switch($2){
						case MU: printf(" * "); break;
						case DI: printf(" / "); break;
						case RE: printf(" %% "); break;
					}
				}
				Factor
				{
					switch($2){
						case MU:
						case DI:
							if(($1.tipo!=INTEIRO && $1.tipo!=REAL && $1.tipo!=CARACTERE)
								|| ($4.tipo!=INTEIRO && $4.tipo!=REAL && $4.tipo!=CARACTERE))
								Incompatibilidade("Operando improprio para operador aritmetico");
							if($1.tipo==REAL || $4.tipo==REAL) $$.tipo=REAL;
							else $$.tipo=INTEIRO;
							$$.opnd.tipo = VAROPND;
							$$.opnd.atr.simb = NovaTemp($$.tipo);
							if($2 == MU)
								GeraQuadrupla(OPMULTIP, $1.opnd, $4.opnd, $$.opnd);
							else
								GeraQuadrupla(OPDIV, $1.opnd, $4.opnd, $$.opnd);
							break;
						case RE:
							if(($1.tipo!=INTEIRO && $1.tipo!=CARACTERE) || ($4.tipo!=INTEIRO && $4.tipo!=CARACTERE))
								Incompatibilidade("Operando improprio para operador resto");
							$$.tipo=INTEIRO;
							$$.opnd.tipo = VAROPND;
							$$.opnd.atr.simb = NovaTemp($$.tipo);
							GeraQuadrupla(OPRESTO, $1.opnd, $4.opnd, $$.opnd);
							break;
						default:
							break;
					}
				}
				;
Factor			:  Variable
				{
					if($1.simb != NULL) {
						$1.simb->ref = VERDADE;
						$$.tipo = $1.simb->tvar;
						$$.opnd = $1.opnd;
						if($1.simb->ndims != 0){
							result.atr.simb = NovaTemp($1.simb->tvar);
							result.tipo = VAROPND;
							GeraQuadrupla(CONTAPONT, $1.opnd, opndidle, result);
							$$.opnd = result;
						}
					}
				}
				|  INTCT 
					{
						printf("%d", $1); $$.tipo = INTEIRO;
						$$.opnd.tipo = INTOPND;
						$$.opnd.atr.valint = $1;
					}
				|  FLOATCT 
					{
						printf("%g", $1); $$.tipo = REAL;
						$$.opnd.tipo = REALOPND;
						$$.opnd.atr.valfloat = $1;
					}
				|  CHARCT 
					{
						printf("\'%s\'", $1);
						$$.tipo = CARACTERE;
						$$.opnd.tipo = CHAROPND;
						$$.opnd.atr.valchar = $1;
					}
            	|  TRUE 
					{
						printf("true");
						$$.tipo = LOGICO;
						$$.opnd.tipo = LOGICOPND;
						$$.opnd.atr.vallogic = 1;
					}
				|  FALSE 
					{
						printf("false"); 
						$$.tipo = LOGICO;
						$$.opnd.tipo = LOGICOPND;
						$$.opnd.atr.vallogic = 0;
					}
				|  NEG {printf("~");} Factor 
				{
					if($3.tipo != INTEIRO && $3.tipo!= REAL && $3.tipo!=CARACTERE)
						Incompatibilidade("Operando improprio para menos unario");
					if($3.tipo == REAL)
						$$.tipo = REAL;
					else
						$$.tipo = INTEIRO;
					$$.opnd.tipo = VAROPND;
					$$.opnd.atr.simb = NovaTemp($$.tipo);
					GeraQuadrupla  (OPMENUN, $3.opnd, opndidle, $$.opnd);
					

				}
            	|  OPPAR {printf("(");} Expression  CLPAR
					{
						printf(")");
						$$.tipo=$3.tipo;
						$$.opnd = $3.opnd;
					}
				|  FuncCall
				{
					if ($1.simb != NULL) {
						$$.tipo = $1.simb->tvar;
					}
					$$.opnd = $1.opnd;
				}
				;
Variable		:  ID
				{
					printf("%s", $1);
					simbolo escaux = escopo;
					simb = ProcuraSimb($1, escaux);
					while(escaux != NULL && simb == NULL) {
						escaux = escaux->escopo;
						if (escaux != NULL)
							simb = ProcuraSimb($1, escaux);
					}
					if(simb == NULL) 
						NaoDeclarado($1); 
					else if(simb->tid != IDVAR)
						TipoInadequado($1);
					$<simb>$ = simb;
				} 
				   SubscrList 
				{
					$$.simb = $<simb>2;
					if($$.simb != NULL) {
						if($$.simb->array == FALSO && $3>0)
							NaoEsperado("Subscrito\(s)");
						else if($$.simb->array==VERDADE && $3==0)
							Esperado("subscrito\(s)");
						else if($3!=$$.simb->ndims)
							Incompatibilidade("Numero de subscritos incompativel com o declarado");
						$$.opnd.tipo = VAROPND;
						if($3 == 0)
							$$.opnd.atr.simb = $$.simb;
						else{
							/* Caso seja um vetor */
							$$.opnd.tipo = VAROPND;
							$$.opnd.atr.simb = NovaTemp($$.simb->tvar);
							opnd1.tipo = VAROPND;
							opnd1.atr.simb = $$.simb;
							opnd2.tipo = INTOPND;
							opnd2.atr.valint = $3;
							GeraQuadrupla(INDEX, opnd1, opnd2, $$.opnd);
						}
					}
				}  
				;
SubscrList  	:  {$$=0;}
				|  SubscrList  Subscript  {$$=$1+1;}
				;
Subscript		:  OPBRAK {printf("[");} AuxExpr4  CLBRAK {printf("]");}
				{
					if($3.tipo!=INTEIRO && $3.tipo!=CARACTERE)
						Incompatibilidade("Tipo inadequado para subscrito");
					/* Empilhando índices do vetor */
					if($3.opnd.tipo == VAROPND)
						GeraQuadrupla(IND, $3.opnd, opndidle, opndidle);
					else{
						GeraQuadrupla(IND, $3.opnd, opndidle, opndidle);
					}
					
				}
				;
FuncCall    	:  ID OPPAR {printf("%s()", $1);} CLPAR
				{
					VerificarFuncao($1, 0);
					$$.simb = ProcuraSimb($1, escglobal);
					opnd1.tipo = FUNCOPND; opnd1.atr.modulo = $$.simb->fhead;
					result = opndidle;
					if ($$.simb != NULL) {
						if($$.simb->tvar == NAOVAR) result = opndidle;
						else {
							result.tipo = VAROPND;
							result.atr.simb = NovaTemp($$.simb->tvar);
						}
					}
					GeraQuadrupla(CALLOP, opnd1, opndidle, result);
					$$.opnd = result;
				}
				|  ID OPPAR {printf("%s(", $1);} ExprList CLPAR
				{
					printf(")");
					VerificarFuncao($1, $4);
					$$.simb = ProcuraSimb($1, escglobal);
					opnd1.tipo = FUNCOPND; opnd1.atr.modulo = $$.simb->fhead;
					opnd2.tipo = INTOPND; opnd2.atr.valint = $4;
					result = opndidle;
					if ($$.simb != NULL) {
						if($$.simb->tvar == NAOVAR) result = opndidle;
						else {
							result.tipo = VAROPND;
							result.atr.simb = NovaTemp($$.simb->tvar);
						}
					}
					GeraQuadrupla(CALLOP, opnd1, opnd2, result);
					$$.opnd = result;
				}
				;
%%
#include "lex.yy.c"

/* Inicializa a tabela de simbolos */
void InicTabSimb(){
	int i;
	for(i=0;i<NCLASSHASH;i++)
		tabsimb[i] = NULL;
}

/*
	ProcuraSimb(cadeia, escopo): Procura cadeia e escopo na tabela de simbolos;
	Caso ela ali esteja, retorna um ponteiro para a sua celula;
	Caso contrário, retorna NULL.

*/
simbolo ProcuraSimb (char *cadeia, simbolo escopo) {
	simbolo s; int i;
	i = hash (cadeia);
	for (s = tabsimb[i]; (s != NULL) && (strcmp(cadeia, s->cadeia) != 0 || (escopo != s->escopo)); s = s->prox);
	return s;
}

/*
	InsereListSimb(simbolo, listsimb*): Insere
	simbolo numa lista de simbolos
 */
 
void InsereListSimb(simbolo simb, listsimb *lista) {
	listsimb l = (listsimb) malloc (sizeof (elemlistsimb));
	l->simb = simb;
	l->prox = *lista;
	*lista = l;
}

/*
	InsereSimb (cadeia, tid, tvar, escopo): Insere cadeia na tabela de
	simbolos, com tid como tipo de identificador, com tvar como
	tipo de variavel e com escopo como escopo; Retorna um ponteiro para a celula inserida
 */

simbolo InsereSimb (char *cadeia, int tid, int tvar, simbolo escopo) {
	int i; simbolo aux, s;
	i = hash (cadeia); aux = tabsimb[i];
	s = tabsimb[i] = (simbolo) malloc (sizeof (celsimb));
	s->cadeia = (char*) malloc ((strlen(cadeia)+1) * sizeof(char));
	strcpy (s->cadeia, cadeia);
	s->tid = tid;		s->tvar = tvar;
	s->nparams = s->ndims = 0;
	s->listfunc = s->listparam = s->listvar = NULL;
	s->escopo = escopo;
	s->prox = aux;
	s->fhead = modcorrente;
	if (declparam) {
		s->inic = s->ref = s->param = VERDADE;
		if (s->tid == IDVAR)
			InsereListSimb(s, &escopo->listparam);
		s->escopo->nparams++;
	}
	else {
		s->inic = s->ref = s->param = FALSO;
		if (s->tid == IDVAR)
			InsereListSimb(s, &escopo->listvar);
	}
	if (tid == IDFUNC || tid == IDPROC) {
		InsereListSimb(s, &escopo->listfunc);
	}
	return s;
}

/*
	hash (cadeia): funcao que determina e retorna a classe
	de cadeia na tabela de simbolos implementada por hashing
 */

int hash (char *cadeia) {
	int i, h;
	for (h = i = 0; cadeia[i]; i++) {h += cadeia[i];}
	h = h % NCLASSHASH;
	return h;
}

/* ImprimeTabSimb: Imprime todo o conteudo da tabela de simbolos  */

void ImprimeTabSimb () {
	int i, j; simbolo s;
	printf ("\n\n   TABELA  DE  SIMBOLOS:\n\n");
	for (i = 0; i < NCLASSHASH; i++)
		if (tabsimb[i]) {
			printf ("Classe %d:\n", i);
			for (s = tabsimb[i]; s!=NULL; s = s->prox){
				printf ("  %s(%s %s), escopo: ", s->cadeia,  nometipid[s->tid],  nometipvar[s->tvar]);
				if (s->escopo == NULL) printf("null\n");
				else printf("%s\n", s->escopo->cadeia);
				if (s->listparam != NULL) {
					printf("\tParametros (%d): ", s->nparams);
					listsimb l = s->listparam;
					while(l != NULL) {
						printf(" %s(%s)", l->simb->cadeia, nometipvar[l->simb->tvar]);
						l = l->prox;
					}
					printf("\n");
				}
				if (s->listfunc != NULL) {
					printf("\tFuncoes: ");
					listsimb l = s->listfunc;
					while(l != NULL) {
						printf(" %s(%s)", l->simb->cadeia, nometipvar[l->simb->tvar]);
						l = l->prox;
					}
					printf("\n");
				}
				if (s->listvar != NULL) {
					printf("\tVariaveis: ");
					listsimb l = s->listvar;
					while(l != NULL) {
						printf(" %s(%s)", l->simb->cadeia, nometipvar[l->simb->tvar]);
						l = l->prox;
					}
					printf("\n");
				}
				if (s->tid == IDVAR){
					printf ("\tInicializado: %d, Referenciado: %d\n", s->inic, s->ref);
					if(s->array == VERDADE){
						printf("\tArray: (%d dimensoes):", s->ndims);
						for(j=1; j <= s->ndims; j++)
							printf(" %d", s->dims[j]);
						printf("\n");
					}
				}
				printf("\n");
			}
		}
}

void VerificaInicRef(){
	int i;
	simbolo s;
	for (i = 0; i < NCLASSHASH; i++) {
		if (tabsimb[i]) {
			for (s = tabsimb[i]; s!=NULL; s = s->prox){
				if(s->tid == IDVAR){
					if(s->ref == FALSO)
						printf("%s do escopo %s nao referenciado\n", s->cadeia, s->escopo->cadeia);
					if(s->inic == FALSO)
						printf("%s do escopo %s nao inicializado\n", s->cadeia, s->escopo->cadeia);
				}
			}
		}
	}
	
}

void AdicionarListaTipo(int tipo) {
	tiponoh n = (tiponoh) malloc (sizeof (celtiponoh));
	n->tipo = tipo;
	n->prox = listatipos;
	listatipos = n;
}

void LimparListaTipos(){
	tiponoh n;
	while(listatipos != NULL) {
		n = listatipos;
		listatipos = listatipos->prox;
		free(n);
	}
}

void VerificarCompatibilidade(const char *mensagem, int tipo1, int tipo2) {
	char buffer[200];
	buffer[0] = 0;
	if(tipo1==INTEIRO && (tipo2!=INTEIRO && tipo2!= CARACTERE))
		sprintf(buffer, "[%s] Compatibilidade de inteiro: esperado inteiro ou caractere.", mensagem);
	else if(tipo1==REAL && (tipo2!=INTEIRO && tipo2!=REAL && tipo2!= CARACTERE))
		sprintf(buffer, "[%s] Compatibilidade de real: esperado real, inteiro ou caractere.", mensagem);
	else if(tipo1==CARACTERE && (tipo2!=INTEIRO && tipo2!= CARACTERE))
		sprintf(buffer, "[%s] Compatibilidade de caractere: esperado inteiro ou caractere.", mensagem);
	else if(tipo1==LOGICO && tipo2!=LOGICO)
		sprintf(buffer, "[%s] Compatibilidade de logico: esperado logico.", mensagem);
	if (buffer[0] != 0)
		Incompatibilidade(buffer);
}

void VerificarParams(listsimb p) {
	tiponoh q = listatipos;
	while(q != NULL && p != NULL){
		VerificarCompatibilidade("param", p->simb->tvar, q->tipo);
		q = q->prox;
		p = p->prox;
	}
	if (p != NULL || q != NULL)
		ErroInterno("Erro interno de logica do compilador.");
}

void VerificarFuncao(char * id, int nparams) {
	simbolo s = ProcuraSimb(id, escglobal);
	if (s == NULL) {
		NaoDeclarado("Funcao ou procedimento nao declarado.");
		return;
	}
	simbolo escaux = escopo;
	while(escaux != NULL) {
		if (strcmp(escaux->cadeia, id) == 0)
			ErroLinguagem("Proibida recursividade.");
		escaux = escaux->escopo;
	}
	if(s->tid != IDFUNC && s->tid != IDPROC){
		NaoEsperado("Esperava identificador de funcao.");
	}
	else if(s->nparams != nparams) {
		Incompatibilidade("Quantidade de parametros nao compativel.");
	}
	else {
		VerificarParams(s->listparam);
	}
	LimparListaTipos();
}

/* Funcoes do codigo intermediario */

/* Inicia o modulo lider de todo o programa */
void InicCodIntermed () {
	codintermed = malloc (sizeof (celmodhead));
	modcorrente = codintermed;
   	modcorrente->listquad = NULL;
	modcorrente->prox = NULL;
}

/* Cria um modulo de codigo intermediario (processo, funcao ou programa) */
void InicCodIntermMod (simbolo simb) {
	modcorrente->prox = malloc (sizeof (celmodhead));
	modcorrente = modcorrente->prox;
	modcorrente->prox = NULL;
	modcorrente->modname = simb;
	modcorrente->modtip = simb->tid;
	modcorrente->listquad = malloc (sizeof (celquad));
	quadcorrente = modcorrente->listquad;
	quadcorrente->prox = NULL;
	numquadcorrente = 0;
	quadcorrente->num = numquadcorrente;
}

quadrupla GeraQuadrupla (int oper, operando opnd1, operando opnd2, operando result) {
	quadcorrente->prox = malloc (sizeof (celquad));
	quadcorrente = quadcorrente->prox;
	quadcorrente->oper = oper;
	quadcorrente->opnd1 = opnd1;
	quadcorrente->opnd2 = opnd2;
	quadcorrente->result = result;
	quadcorrente->prox = NULL;
	numquadcorrente ++;
   	quadcorrente->num = numquadcorrente;
   	return quadcorrente;
}

/* ###### Verificar insercao de simbolo temporario ###### */
/* Gera um nome para uma nova variavel temporaria ##XX */
simbolo NovaTemp (int tip) {
	simbolo simb; int temp, i, j;
	char nometemp[10] = "##", s[10] = {0};
	numtemp ++; temp = numtemp;
	for (i = 0; temp > 0; temp /= 10, i++)
		s[i] = temp % 10 + '0';
	i --;
	for (j = 0; j <= i; j++)
		nometemp[2+i-j] = s[j];
	simb = InsereSimb (nometemp, IDVAR, tip, escopo);
	simb->inic = simb->ref = VERDADE;
	simb->array = FALSO; return simb;
}

void ImprimeQuadruplas () {
	modhead p;
	quadrupla q;
	for (p = codintermed->prox; p != NULL; p = p->prox) {
		printf ("\n\nQuadruplas do modulo %s:\n", p->modname->cadeia);
		for (q = p->listquad->prox; q != NULL; q = q->prox) {
			printf ("\n\t%4d) %s", q->num, nomeoperquad[q->oper]);
			printf (", (%s", nometipoopndquad[q->opnd1.tipo]);
			switch (q->opnd1.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->opnd1.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->opnd1.atr.valint); break;
				case REALOPND: printf (", %g", q->opnd1.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->opnd1.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->opnd1.atr.vallogic); break;
				case CADOPND: printf (", %s", q->opnd1.atr.valcad); break;
				case ROTOPND: printf (", %d", q->opnd1.atr.rotulo->num); break;
				case FUNCOPND:
				case MODOPND: printf(", %s", q->opnd1.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
			printf (", (%s", nometipoopndquad[q->opnd2.tipo]);
			switch (q->opnd2.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->opnd2.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->opnd2.atr.valint); break;
				case REALOPND: printf (", %g", q->opnd2.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->opnd2.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->opnd2.atr.vallogic); break;
				case CADOPND: printf (", %s", q->opnd2.atr.valcad); break;
				case ROTOPND: printf (", %d", q->opnd2.atr.rotulo->num); break;
				case FUNCOPND:
				case MODOPND: printf(", %s", q->opnd2.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
			printf (", (%s", nometipoopndquad[q->result.tipo]);
			switch (q->result.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->result.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->result.atr.valint); break;
				case REALOPND: printf (", %g", q->result.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->result.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->result.atr.vallogic); break;
				case CADOPND: printf (", %s", q->result.atr.valcad); break;
				case ROTOPND: printf (", %d", q->result.atr.rotulo->num); break;
				case FUNCOPND:
				case MODOPND: printf(", %s", q->result.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
		}
	}
   printf ("\n");
}

void RenumQuadruplas (quadrupla quad1, quadrupla quad2) {
	quadrupla q; int nquad;
	for (q = quad1->prox, nquad = quad1->num; q != quad2; q = q->prox) {
      nquad++;
		q->num = nquad;
	}
}

void InterpCodIntermed () {
	quadrupla quad, quadprox;  char encerra, condicao;
	printf ("\n\nINTERPRETADOR:\n");
	InicPilhaOpnd (&pilhaopnd);
	InicPilhaOpnd(&pilhaindex);
	encerra = FALSO;
	finput = fopen ("entrada2017", "r");
	quad = codintermed->prox->listquad->prox;
	while (! encerra) {
		//printf ("\n%4d) %s", quad->num,	nomeoperquad[quad->oper]);
		quadprox = quad->prox;
		switch (quad->oper) {
			case OPENMOD:  AlocaVariaveis (); break;
			case PARAM: 
				EmpilharOpnd (quad->opnd1, &pilhaopnd); 
				break;
			case IND:
				EmpilharOpnd (quad->opnd1, &pilhaindex);
				break;
			case OPWRITE:   ExecQuadWrite (quad);  break;
			case OPMAIS:  ExecQuadMais (quad);  break;
			case OPMENOS:  ExecQuadMenos (quad);  break;
			case OPMULTIP:	ExecQuadMultip(quad);  break;
			case OPDIV:	ExecQuadDiv(quad);  break;
			case OPRESTO: ExecQuadResto(quad); break;
			case OPMENUN: ExecQuadMenum(quad); break;
			case OPLT: ExecQuadLT(quad); break;
			case OPLE: ExecQuadLE(quad); break;
			case OPGT: ExecQuadGT(quad); break;
			case OPGE: ExecQuadGE(quad); break;
			case OPEQ: ExecQuadEQ(quad); break;
			case OPNE: ExecQuadNE(quad); break;
			case OPOR: ExecQuadOR(quad); break;
			case OPAND: ExecQuadAND(quad); break;
			case OPNOT: ExecQuadNOT(quad); break;
			case OPATRIB: ExecQuadAtrib(quad); break;
			case OPJUMP: quadprox = quad->result.atr.rotulo;  break;
			case OPJF:
				if (quad->opnd1.tipo == LOGICOPND)
					condicao = quad->opnd1.atr.vallogic;
				if (quad->opnd1.tipo == VAROPND)
					condicao = *(quad->opnd1.atr.simb->vallogic);
				if (! condicao)
					quadprox = quad->result.atr.rotulo;
				break;
			case  OPREAD:   ExecQuadRead (quad);  break;
			case INDEX:	ExecQuadIndex(quad); break;
			case CONTAPONT: ExecQuadContapont(quad); break;
			case ATRIBPONT:	ExecQuadAtribpont(quad); break;
			case OPEXIT: encerra = VERDADE; break;
		}
		if (! encerra) quad = quadprox;
	}
	printf ("\n");                 
}

void AlocaVariaveis () {
	simbolo s; int nelemaloc, i, j;
	printf ("\n\t\tAlocando as variaveis:");
	for (i = 0; i < NCLASSHASH; i++)
	       if (tabsimb[i]) {
	              for (s = tabsimb[i]; s != NULL; s = s->prox){
	                     if (s->tid == IDVAR) {
	                            nelemaloc = 1;
	                            if (s->array)
	                                   for (j = 1; j <= s->ndims; j++)  nelemaloc *= s->dims[j];
	                            switch (s->tvar) {
	                                   case INTEIRO:
	                                          s->valint = malloc (nelemaloc * sizeof (int)); break;
	                                   case REAL:
	                                          s->valfloat = malloc (nelemaloc * sizeof (float)); break;
	                                   case CARACTERE:
	                                          s->valchar = malloc (nelemaloc * sizeof (char)); break;
	                                   case LOGICO:
	                                          s->vallogic = malloc (nelemaloc * sizeof (char)); break;
	                           }
	                           printf ("\n\t\t\t%s: %d elemento(s) alocado(s) ", s->cadeia, nelemaloc);
	                   }
	      	 }
	      }
}

void ExecQuadWrite (quadrupla quad) {
	int i;  operando opndaux;  pilhaoperando pilhaopndaux;

	printf ("\n\t\tEscrevendo: \n\n");
	InicPilhaOpnd (&pilhaopndaux);
	for (i = 1; i <= quad->opnd1.atr.valint; i++) {
		EmpilharOpnd (TopoOpnd (pilhaopnd), &pilhaopndaux);
		DesempilharOpnd (&pilhaopnd);
	}
	for (i = 1; i <= quad->opnd1.atr.valint; i++) {
		opndaux = TopoOpnd (pilhaopndaux);
		DesempilharOpnd (&pilhaopndaux);
		switch (opndaux.tipo) {
			case INTOPND:
				printf ("%d", opndaux.atr.valint); break;
			case REALOPND:
				printf ("%g", opndaux.atr.valfloat); break;
			case CHAROPND:
				printf ("%c", opndaux.atr.valchar); break;
			case LOGICOPND:
				if (opndaux.atr.vallogic == 1) printf ("TRUE");
				else printf ("FALSE");
				break;
			case CADOPND:
				printf ("%s", opndaux.atr.valcad); 
				break ;
				case VAROPND:
				switch (opndaux.atr.simb->tvar) {
					case INTEIRO:
						printf ("%d", *(opndaux.atr.simb->valint)); break;
					case REAL:
						printf ("%g", 
						     *(opndaux.atr.simb->valfloat));break;
					case LOGICO:
						if (*(opndaux.atr.simb->vallogic) == 1)
							printf ("TRUE"); 
							else printf ("FALSE"); break;
					case CARACTERE:
						printf ("%c", 
						    *(opndaux.atr.simb->valchar)); break;
				}
				break;
		}
	}
	printf ("\n");
}

void ExecQuadMais (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2=*(quad->opnd2.atr.simb->valfloat);break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2=*(quad->opnd2.atr.simb->valchar);break;
			}
			break;
	}
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO:
			*(quad->result.atr.simb->valint) = valint1 + valint2;
			break;
		case REAL:
			if (tipo1 == INTOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valint1 + valint2;
			if (tipo1 == INTOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valint1 + valfloat2;
			if (tipo1 == REALOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 + valint2;
			if (tipo1 == REALOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 + valfloat2;
			break;
	}
}

void ExecQuadMenos (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2=*(quad->opnd2.atr.simb->valfloat);break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2=*(quad->opnd2.atr.simb->valchar);break;
			}
			break;
	}
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO:
			*(quad->result.atr.simb->valint) = valint1 - valint2;
			break;
		case REAL:
			if (tipo1 == INTOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valint1 - valint2;
			if (tipo1 == INTOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valint1 - valfloat2;
			if (tipo1 == REALOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 - valint2;
			if (tipo1 == REALOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 - valfloat2;
			break;
	}
}

void ExecQuadMultip (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2=*(quad->opnd2.atr.simb->valfloat);break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2=*(quad->opnd2.atr.simb->valchar);break;
			}
			break;
	}
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO:
			*(quad->result.atr.simb->valint) = valint1 * valint2;
			break;
		case REAL:
			if (tipo1 == INTOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valint1 * valint2;
			if (tipo1 == INTOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valint1 * valfloat2;
			if (tipo1 == REALOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 * valint2;
			if (tipo1 == REALOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 * valfloat2;
			break;
	}
}

void ExecQuadDiv (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2=*(quad->opnd2.atr.simb->valfloat);break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2=*(quad->opnd2.atr.simb->valchar);break;
			}
			break;
	}
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO:
			*(quad->result.atr.simb->valint) = valint1 / valint2;
			break;
		case REAL:
			if (tipo1 == INTOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valint1 / valint2;
			if (tipo1 == INTOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valint1 / valfloat2;
			if (tipo1 == REALOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 / valint2;
			if (tipo1 == REALOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 / valfloat2;
			break;
	}
}

void ExecQuadResto (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2=*(quad->opnd2.atr.simb->valchar);break;
			}
			break;
	}
	*(quad->result.atr.simb->valint) = valint1 % valint2;
}

void ExecQuadMenum (quadrupla quad) {
	int tipo1, valint1;
	float valfloat1;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO:
			*(quad->result.atr.simb->valint) = -valint1;
			break;
		case REAL:
			*(quad->result.atr.simb->valfloat) = -valfloat1;
			break;
	}
}

void ExecQuadLT (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2=*(quad->opnd2.atr.simb->valfloat);break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2=*(quad->opnd2.atr.simb->valchar);break;
			}
			break;
	}
	if (tipo1 == INTOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valint1 < valint2;
	if (tipo1 == INTOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valint1 < valfloat2;
	if (tipo1 == REALOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 < valint2;
	if (tipo1 == REALOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 < valfloat2;
}

void ExecQuadLE (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2=*(quad->opnd2.atr.simb->valfloat);break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2=*(quad->opnd2.atr.simb->valchar);break;
			}
			break;
	}
	if (tipo1 == INTOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valint1 <= valint2;
	if (tipo1 == INTOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valint1 <= valfloat2;
	if (tipo1 == REALOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 <= valint2;
	if (tipo1 == REALOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 <= valfloat2;
}

void ExecQuadGT (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2=*(quad->opnd2.atr.simb->valfloat);break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2=*(quad->opnd2.atr.simb->valchar);break;
			}
			break;
	}
	if (tipo1 == INTOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valint1 > valint2;
	if (tipo1 == INTOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valint1 > valfloat2;
	if (tipo1 == REALOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 > valint2;
	if (tipo1 == REALOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 > valfloat2;
}

void ExecQuadGE (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2=*(quad->opnd2.atr.simb->valfloat);break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2=*(quad->opnd2.atr.simb->valchar);break;
			}
			break;
	}
	if (tipo1 == INTOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valint1 >= valint2;
	if (tipo1 == INTOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valint1 >= valfloat2;
	if (tipo1 == REALOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 >= valint2;
	if (tipo1 == REALOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 >= valfloat2;
}

void ExecQuadEQ (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	char vallogic1, vallogic2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case LOGICOPND:
			tipo1 = LOGICOPND;  vallogic1 = quad->opnd1.atr.vallogic;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
				case LOGICO:
					tipo1 = LOGICOPND;
					vallogic1 = *(quad->opnd1.atr.simb->vallogic);  break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case LOGICOPND:
			tipo2 = LOGICOPND;  vallogic2 = quad->opnd2.atr.vallogic;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2=*(quad->opnd2.atr.simb->valfloat);break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2=*(quad->opnd2.atr.simb->valchar);break;
				case LOGICO:
					tipo2 = LOGICOPND;
					vallogic2 = *(quad->opnd2.atr.simb->vallogic);  break;
			}
			break;
	}
	
	if (tipo1 == LOGICOPND && tipo2 == LOGICOPND)
		*(quad->result.atr.simb->vallogic) = vallogic1 == vallogic2;
	if (tipo1 == INTOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valint1 == valint2;
	if (tipo1 == INTOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valint1 == valfloat2;
	if (tipo1 == REALOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 == valint2;
	if (tipo1 == REALOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 == valfloat2;
}

void ExecQuadNE (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	char vallogic1, vallogic2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case LOGICOPND:
			tipo1 = LOGICOPND;  vallogic1 = quad->opnd1.atr.vallogic;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
				case LOGICO:
					tipo1 = LOGICOPND;
					vallogic1 = *(quad->opnd1.atr.simb->vallogic);  break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case LOGICOPND:
			tipo2 = LOGICOPND;  vallogic2 = quad->opnd2.atr.vallogic;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2=*(quad->opnd2.atr.simb->valfloat);break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2=*(quad->opnd2.atr.simb->valchar);break;
				case LOGICO:
					tipo2 = LOGICOPND;
					vallogic2 = *(quad->opnd2.atr.simb->vallogic);  break;
			}
			break;
	}
	
	if (tipo1 == LOGICOPND && tipo2 == LOGICOPND)
		*(quad->result.atr.simb->vallogic) = vallogic1 != vallogic2;
	if (tipo1 == INTOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valint1 != valint2;
	if (tipo1 == INTOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valint1 != valfloat2;
	if (tipo1 == REALOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 != valint2;
	if (tipo1 == REALOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 != valfloat2;
}

void ExecQuadOR (quadrupla quad) {
	int tipo1, tipo2;
	char vallogic1, vallogic2;
	switch (quad->opnd1.tipo) {
		case LOGICOPND:
			tipo1 = LOGICOPND;  vallogic1 = quad->opnd1.atr.vallogic;
			break;
		case VAROPND:
			tipo1 = LOGICOPND;
			vallogic1 = *(quad->opnd1.atr.simb->vallogic);
			break;
	}
	switch (quad->opnd2.tipo) {
		case LOGICOPND:
			tipo2 = LOGICOPND;  vallogic2 = quad->opnd2.atr.vallogic;  
			break;
		case VAROPND:
			tipo2 = LOGICOPND;
			vallogic2 = *(quad->opnd2.atr.simb->vallogic);  
			break;
	}
	
	/* Escrita do resultado */
	*(quad->result.atr.simb->vallogic) = vallogic1 || vallogic2;
}

void ExecQuadAND (quadrupla quad) {
	int tipo1, tipo2;
	char vallogic1, vallogic2;
	switch (quad->opnd1.tipo) {
		case LOGICOPND:
			tipo1 = LOGICOPND;  vallogic1 = quad->opnd1.atr.vallogic;
			break;
		case VAROPND:
			tipo1 = LOGICOPND;
			vallogic1 = *(quad->opnd1.atr.simb->vallogic);
			break;
	}
	switch (quad->opnd2.tipo) {
		case LOGICOPND:
			tipo2 = LOGICOPND;  vallogic2 = quad->opnd2.atr.vallogic;  
			break;
		case VAROPND:
			tipo2 = LOGICOPND;
			vallogic2 = *(quad->opnd2.atr.simb->vallogic);  
			break;
	}
	
	/* Escrita do resultado */
	*(quad->result.atr.simb->vallogic) = vallogic1 && vallogic2;
}

void ExecQuadNOT (quadrupla quad) {
	int tipo1;
	char vallogic1;
	switch (quad->opnd1.tipo) {
		case LOGICOPND:
			tipo1 = LOGICOPND;  vallogic1 = quad->opnd1.atr.vallogic;
			break;
		case VAROPND:
			tipo1 = LOGICOPND;
			vallogic1 = *(quad->opnd1.atr.simb->vallogic);
			break;
	}
	
	/* Escrita do resultado */
	*(quad->result.atr.simb->vallogic) = !vallogic1;
}

void ExecQuadAtrib (quadrupla quad) {
	int tipo1, valint1;
	float valfloat1;
	char valchar1, vallogic1;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;
			valint1 = quad->opnd1.atr.valint; break;
		case REALOPND:
			tipo1 = REALOPND;
			valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = CHAROPND;
			valchar1 = quad->opnd1.atr.valchar; break;
		case LOGICOPND:
			tipo1 = LOGICOPND;
			vallogic1 = quad->opnd1.atr.vallogic; break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint); break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = CHAROPND;
					valchar1=*(quad->opnd1.atr.simb->valchar);break;
				case LOGICO:
					tipo1 = LOGICOPND;
					vallogic1 = *(quad->opnd1.atr.simb->vallogic);
					break;
			}
			break;
	}
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO:
			if (tipo1 == INTOPND)  *(quad->result.atr.simb->valint) = valint1;
			if (tipo1 == CHAROPND)*(quad->result.atr.simb->valint)=valchar1;
			break;
		case CARACTERE:
			if (tipo1 == INTOPND) *(quad->result.atr.simb->valchar) = valint1;
			if (tipo1==CHAROPND)*(quad->result.atr.simb->valchar)=valchar1;
			break;
		case LOGICO:  *(quad->result.atr.simb->vallogic) = vallogic1; break;
		case REAL:
			if (tipo1 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valint1;
			if (tipo1 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1;
			if (tipo1 == CHAROPND)
				*(quad->result.atr.simb->valfloat) = valchar1;
			break;
	}
}

void ExecQuadRead (quadrupla quad) {
	int i;  operando opndaux;  pilhaoperando pilhaopndaux;

	printf ("\n\t\tLendo: \n");
	InicPilhaOpnd (&pilhaopndaux);
	for (i = 1; i <= quad->opnd1.atr.valint; i++) {
		EmpilharOpnd (TopoOpnd (pilhaopnd), &pilhaopndaux);
		DesempilharOpnd (&pilhaopnd);
	}
	for (i = 1; i <= quad->opnd1.atr.valint; i++) {
		opndaux = TopoOpnd (pilhaopndaux);
		DesempilharOpnd (&pilhaopndaux);
      	switch (opndaux.atr.simb->tvar) {
      		case INTEIRO:
         			fscanf (finput, "%d", opndaux.atr.simb->valint); break;
        		case REAL:
         			fscanf (finput, "%g", opndaux.atr.simb->valfloat);break;
         		case LOGICO:
         			fscanf (finput, "%d", opndaux.atr.simb->vallogic); break;
        		case CARACTERE:
         			fscanf (finput, "%c", opndaux.atr.simb->valchar); break;
     		}
	}
}

void ExecQuadIndex(quadrupla quad){
	int i,j;  operando opndaux;  pilhaoperando pilhaopndaux;
	int endrel=0;
	int aux = 1;
	int valor;
	for (i = 1, j = quad->opnd1.atr.simb->ndims+1; i <= quad->opnd2.atr.valint; i++,j--) {
		opndaux = TopoOpnd (pilhaindex);
		DesempilharOpnd (&pilhaindex);
		if(opndaux.tipo == VAROPND)
			valor = *(opndaux.atr.simb->valint);
		else
			valor = opndaux.atr.valint;
		if(i == 1){
			endrel = endrel + valor;
		}
		else{
			aux = aux*quad->opnd1.atr.simb->dims[j];
			endrel = endrel + valor*aux;
		}
	}
	
	switch (quad->opnd1.atr.simb->tvar) {
		case INTEIRO:
			quad->result.atr.simb->valint = endrel + quad->opnd1.atr.simb->valint;
			break;
		case REAL:
			quad->result.atr.simb->valfloat = endrel + quad->opnd1.atr.simb->valfloat;
			break;
		case CARACTERE:
			quad->result.atr.simb->valchar = endrel + quad->opnd1.atr.simb->valchar;
			break;
		case LOGICO:
			quad->result.atr.simb->vallogic = endrel + quad->opnd1.atr.simb->vallogic;
			break;
	}
}

void ExecQuadContapont(quadrupla quad){
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO:
			*quad->result.atr.simb->valint = *quad->opnd1.atr.simb->valint;
			break;
		case REAL:
			*quad->result.atr.simb->valfloat = *quad->opnd1.atr.simb->valfloat;
			break;
		case CARACTERE:
			*quad->result.atr.simb->valchar = *quad->opnd1.atr.simb->valchar;
			break;
		case LOGICO:
			*quad->result.atr.simb->vallogic = *quad->opnd1.atr.simb->vallogic;
			break;
	}
}

void ExecQuadAtribpont(quadrupla quad){
	int tipo1, valint1;
	float valfloat1;
	char valchar1, vallogic1;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;
			valint1 = quad->opnd1.atr.valint; break;
		case REALOPND:
			tipo1 = REALOPND;
			valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = CHAROPND;
			valchar1 = quad->opnd1.atr.valchar; break;
		case LOGICOPND:
			tipo1 = LOGICOPND;
			vallogic1 = quad->opnd1.atr.vallogic; break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *quad->opnd1.atr.simb->valint;
					break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1 = *quad->opnd1.atr.simb->valfloat;
					break;
				case CARACTERE:
					tipo1 = CHAROPND;
					valchar1 = *quad->opnd1.atr.simb->valchar;
					break;
				case LOGICO:
					tipo1 = LOGICOPND;
					vallogic1 = *quad->opnd1.atr.simb->vallogic;
					break;
			}
		break;
	}
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO:
			if (tipo1 == INTOPND)  *(quad->result.atr.simb->valint) = valint1;
			if (tipo1 == CHAROPND) *(quad->result.atr.simb->valint) = valchar1;
			break;
		case CARACTERE:
			if (tipo1 == INTOPND) *(quad->result.atr.simb->valchar) = valint1;
			if (tipo1 == CHAROPND)*(quad->result.atr.simb->valchar) = valchar1;
			break;
		case LOGICO:  *(quad->result.atr.simb->vallogic) = vallogic1; break;
		case REAL:
			if (tipo1 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valint1;
			if (tipo1 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1;
			if (tipo1 == CHAROPND)
				*(quad->result.atr.simb->valfloat) = valchar1;
			break;
	}
}

void EmpilharOpnd (operando x, pilhaoperando *P) {
	nohopnd *temp;
	temp = *P;   
	*P = (nohopnd *) malloc (sizeof (nohopnd));
	(*P)->opnd = x; (*P)->prox = temp;
}

void DesempilharOpnd (pilhaoperando *P) {
	nohopnd *temp;
	if (! VaziaOpnd (*P)) {
		temp = *P;  *P = (*P)->prox; free (temp);
	}
	else  printf ("\n\tDelecao em pilha vazia\n");
}

operando TopoOpnd (pilhaoperando P) {
	if (! VaziaOpnd (P))  return P->opnd;
	else  printf ("\n\tTopo de pilha vazia\n");
}

void InicPilhaOpnd (pilhaoperando *P) { 
	*P = NULL;
}

char VaziaOpnd (pilhaoperando P) {
	if  (P == NULL)  return 1;  
	else return 0; 
}


/*  Mensagens de erros semanticos  */

void DeclaracaoRepetida (char *s) {
	printf ("\n\n***** Declaracao Repetida: %s *****\n\n", s);
}

void NaoDeclarado (char *s) {
	printf ("\n\n***** Identificador Nao Declarado: %s *****\n\n", s);
}

void TipoInadequado (char *s) {
	printf ("\n\n***** Identificador de Tipo Inadequado: %s *****\n\n", s);
}

void Incompatibilidade(char *s){
	printf ("\n\n***** Incompatibilidade: %s *****\n\n", s);
}

void Esperado (char *s) {
	printf ("\n\n***** Esperado: %s *****\n\n", s);
}

void NaoEsperado (char *s) {
	printf ("\n\n***** Nao Esperado: %s *****\n\n", s);
}

void ErroLinguagem(char *s) {
	printf ("\n\n***** Erro de linguagem: %s *****\n\n", s);
}

void ErroInterno(char *s) {
	printf ("\n\n***** Erro interno: %s *****\n\n", s);
}
