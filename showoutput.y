%{
#include <stdio.h>
#include <uchar.h>
#include <locale.h>
#include <stdlib.h>
#include <execinfo.h>
#include <string.h>
#include <stdbool.h>
#include "showoutput.h"

void yyerror(const char *c);
int  yylex(void);
int  yywrap(void);

const char32_t OT1_ENC[] =
U"ΓΔΘΛΞΠΣΥΦΨΩﬀﬁﬂﬃﬄıȷ`´ˇ˘¯˚¸ßæœøÆŒØ⸍!”#$%&’()*+,-./0123456789:;¡=¿?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[“]ˆ˙‘abcdefghijklmnopqrstuvwxyz–—˝~¨";

const char32_t T1_ENC[] =
U"`´ˆ˜¨˝˚ˇ˘¯˙¸˛,‹›“”„«»–—​₀ıȷﬀﬁﬂﬃﬄ␣!\"#$%&’()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_‘abcdefghijklmnopqrstuvwxyz{|}~-ĂĄĆČĎĚĘĞĹĽŁŃŇŊŐŔŘŚŠȘŤȚŰŮŸŹŽŻĲİđ§ăąćčďěęğĺľłńňŋőŕřśšșťțűůÿźžżĳ¡¿£ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖŒØÙÚÛÜÝÞẞàáâãäåæçèéêëìíîïðñòóôõöœøùúûüýþß";

const char32_t TS1_ENC[] =
U"`´ˆ˜¨˝˚ˇ˘¯˙¸˛,    „  –— ←→︵︵ˆˆ  ƀ   $  '  * ,=./0123456789  〈-〉              ℧ O       Ω   ⟦ ⟧↑↓` *%†       🙗𝆘♪               ~=˘ˇ˝˵†‡‖‰•℃$¢ƒ₡₩₦₲₱£℞‽⸘₫™‱¶฿№%e∘℠⁅⁆¢£¤¥|§¨©ª🄯¬℗®¯°±²³´μ¶·※¹⁰√¼½¾€      ×              ÷         ";

const char32_t OML_ENC[] =
U"ΓΔΘΛΞΠΣΥΦΨΩαβγδεζηθικλμνξπρστυφχψωεθπρσφ↼↽⇀⇁⇠⇢▷◁0123456789.,</>*∂ABCDEFGHIJKLMNOPQRSTUVWXYZ♭♮♯◡◠ℓabcdefghijklmnopqrstuvwxyzıȷ℘→⁀";

const char32_t OMS_ENC[] =
U"−⋅×∗÷⋄±∓⊕⊖⊗⊘⊙○∘∙≍≡⊆⊇≤≥≼≽∼≈⊂⊃≪≫≺≻←→↑↓↔↗↘≃⇐⇒⇑⇓⇔↖↙∝′∞∈∋△▽/'∀∃¬∅ℜℑ⊤⊥ℵ𝒜ℬ𝒞𝒟ℰℱ𝒢ℋℐ𝒥𝒦ℒℳ𝒩𝒪𝒫𝒬ℛ𝒮𝒯𝒰𝒱𝒲𝒳𝒴𝒵∪∩⊎∧∨⊢⊣⌊⌋⌈⌉{}⟨⟩∣∥↕⇕∖≀√∐∇∫⊔⊓⊑⊒§†‡¶♣♢♡♠";

const char32_t OMX_ENC[] =
U"()[]⌊⌋⌈⌉{}〈〉|‖/\\()()[]⌊⌋⌈⌉{}〈〉/\\()[]⌊⌋⌈⌉{}〈〉/\\/\\╭╮⌈⌉⌊⌋||╭╮╰╯┤├||()||〈〉∐∐∮∮⊙⊙⊕⊕⊗⊗ΣΠ∫∪∩⊎∧∨ΣΠ∫∪∩⊎∧∨∐∐ˆˆˆ˜˜˜[]⌊⌋⌈⌉{}√√√√√┌║↑↓╭╮╰╯⇑⇓";

const char32_t LY1_ENC[] =
U"    /˙˝˛ ﬂ  ﬁ   ı `´ˇ˘ˉ˚¸ßæœøÆŒØ !\"#$%&’()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]ˆ_‘abcdefghijklmnopqrstuvwxyz{|}~¨Ł'‚ƒ„…†‡ˆ‰Š‹ŒŽ^‒ł‘’“”•–—˜™š›œž~Ÿ ¡¢£¤¥¦§¨©ª«¬-®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ";

const char32_t U_ENC[] = {
};

/* not a real enc, but used for tt fonts */
const char32_t OT1_TT_ENC[] = 
U"ΓΔΘΛΞΠΣΥΦΨΩ↑↓'¡¿ıȷ`´ˇ˘¯˚¸ßæœøÆŒØ␣!”#$%&’()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]ˆ_‘abcdefghijklmnopqrstuvwxyz{|}~¨";

struct yyt_gcr {
	char **d;
	size_t i;
	size_t N;
} yyt_gcr;

struct last_style {
	char *family;
	char *shape;
	char *series;
	float size;
} last_style;

struct text_data {
	char *enc;
	char *family;
	char *series; 
	char *shape;
	float size; 
	char *text;
	bool  lig;
};

struct discretionary_data {
	size_t type;
};

struct glue_data {
	float target;
	char *skip;
};

struct kern_data {
	float target;
};

struct mathmode_data {
	bool mode;
};

enum node_tag {
	  top
	, vbox
	, hbox
	, leaders
	, discretionary
	, glue
	, text
	, kern
	, math
	, rule
	, ignored
};

typedef struct node_struct node_t;
struct node_struct { 
	enum node_tag type;
	void *node_data;
	struct node_struct *children;
	size_t N;
	size_t depth;
	struct node_struct *parent;
};

node_t top_level;
node_t *cur_node;

static void yytext_gc_init(void);
static void yytext_gc_cleanup(void);
static void yytext_gc_run(void);
static void add_child(void);
static  int print_discretionary( int i, const node_t *node );
static void print_glue( const node_t *node );
static void print_kern( const node_t *node );
static void print_char( const struct text_data *t, size_t enc_pos );
static void print_text( const node_t *node );
static void print_tree( const node_t *node);
static void mk_char( char *enc, char *family, char *series, char *shape, char *asize, char *text_data, bool lig );
static void mk_glue( char *target, char* skip );
static void mk_kern( char *target );
static void mk_discretionary( char *atype );
static void mk_box( char *boxtype );
static void mk_mathmode( char *mode );
static void mk_leader( void ); 
static void mk_rule( void ); 
static void indentation( size_t dotnum );

%}

%token DOTS

%token DISCRETIONARY
%token REPLACING

%token LIGATURE
%token FONT_ENC
%token FONT_SHAPE
%token FONT_SERIES

%token INT
%token FLOAT
%token CHAR

%token CMD

%token FLOAT_FIL
%token MULTIPLIER

%token GLUE
%token GLUE_PLUS 
%token GLUE_MINUS 
%token SKIP

%token BOX
%token GLUE_SET
%token GLUE_SHIFT
%token BOX_DISPLAY

%token LEADERS

%token UNKNOWN
%token KERN
%token PENALTY
%token PDF
%token IO
%token RULE
%token MATH
%token SETLANG

%start program

%%

program : program statement_list '\n'
        | statement_list '\n'
        ;

statement_list : statement_list statement
               | statement
               ;

statement : '\\' { indentation(0);  } boxes
          | DOTS { indentation($1); } statement_arg
          | n_dots anything
          | anything
          | n_dots
          | '\n'
          ;

n_dots : n_dots '.' 
       | '.'
       ;
 
statement_arg : glue
              | hyphen
              | char
              | kerning
              | boxes
              | rule
              | leader
              | mathmode
              | not_impl
              ;

not_impl : PENALTY anything
         | SETLANG anything
         | PDF anything
         | IO
         ;

char : FONT_ENC '/' font_family '/' FONT_SERIES '/' FONT_SHAPE '/' font_size ' ' printable
     { mk_char(strdup($1), strdup($3), strdup($5), strdup($7), strdup($9), strdup($11), false); }
     | FONT_ENC '/' font_family '/' FONT_SERIES '/' FONT_SHAPE '/' font_size ' ' '(' INT ')' ' ' printable
     { mk_char(strdup($1), strdup($3), strdup($5), strdup($7), strdup($9), strdup($15), false); }
     | FONT_ENC '/' font_family '/' FONT_SERIES '/' FONT_SHAPE '/' font_size ' ' printable ' ' '(' LIGATURE ' ' string ')'
     { mk_char(strdup($1), strdup($3), strdup($5), strdup($7), strdup($9), strdup($16), false); }
     | FONT_ENC '/' font_family '/' FONT_SERIES '/' FONT_SHAPE '/' font_size ' ' '(' INT ')' ' ' printable ' ' '(' LIGATURE ' ' string ')'
     { mk_char(strdup($1), strdup($3), strdup($5), strdup($7), strdup($9), strdup($20), false); }
     ;

font_size : INT
          | FLOAT
          ;
          
font_family : font_family font_family_aux
            | font_family_aux
            ;
    
font_family_aux : CMD
                | '-'
                | CHAR
                | FONT_SHAPE
                | FONT_SERIES
                | FONT_ENC
                ;

printable : font_family
          | INT
          | punct
          ;

punct : '!' | '"'  | '#' | '$' | '%' | '&' | '\'' | '(' | ')' | '*' | '.'
      | '+' | ','  | '/' | ':' | ';' | '<' | '='  | '>' | '?' | ']' | ' '
      | '@' | '^'  | '`' | '{' | '|' | '}' | '\\' | '~' | '-' | '[' | '_'
      ;


string : string printable
       | printable 
       ;

rule : RULE '(' FLOAT FLOAT ')' MULTIPLIER 
     { mk_rule(); }
     | RULE '(' FLOAT '+' '*' ')' MULTIPLIER
     { mk_rule(); }
     | RULE '(' '*' FLOAT ')' MULTIPLIER
     { mk_rule(); }
     | RULE '(' '*' '+' '*' ')' MULTIPLIER
     { mk_rule(); }
     ; 
     
leader : LEADERS ' ' glue_val ' ' glue_pm
       { mk_leader(); }
       ;

glue : GLUE ' ' glue_val
     { mk_glue(strdup($3), NULL); }
     | GLUE ' ' glue_val ' ' glue_pm
     { mk_glue(strdup($3), NULL); }
     | GLUE '(' '\\' CMD ')' ' ' glue_val
     { mk_glue(strdup($7), strdup($4)); }
     | GLUE '(' '\\' CMD ')' ' ' glue_val ' ' glue_pm
     { mk_glue(strdup($7), strdup($4)); }
     ;

glue_val : FLOAT 
         | FLOAT_FIL
         ;

glue_pm : GLUE_PLUS  ' ' glue_val
        | GLUE_MINUS ' ' glue_val
        | GLUE_PLUS  ' ' glue_val ' ' GLUE_MINUS ' ' glue_val
        ;
		 
hyphen : DISCRETIONARY 
	     { mk_discretionary(strdup("0")); }
       | DISCRETIONARY ' ' REPLACING ' ' INT
	     { mk_discretionary(strdup($5)); }
       ;

kerning : KERN ' ' FLOAT
        { mk_kern(strdup($3)); }
        | KERN ' ' FLOAT ' ' '(' string ')'
        { mk_kern(strdup($3)); }
        | KERN FLOAT 
        { mk_kern(strdup($2)); }
        | KERN FLOAT ' ' '(' string ')'
        { mk_kern(strdup($2)); }
        ;

mathmode : MATH { mk_mathmode(strdup($1)); } ;

boxes : box_base
      | box_base ',' 
      | box_base ',' ' ' BOX_DISPLAY
      | box_base ',' ' ' box_glue
      | box_base ',' ' ' box_glue ',' ' ' BOX_DISPLAY
      | box_base ',' ' ' GLUE_SHIFT ' ' glue_val
      | box_base ',' ' ' GLUE_SHIFT ' ' glue_val ',' ' ' BOX_DISPLAY
      | box_base ',' ' ' box_glue   ',' ' ' GLUE_SHIFT ' ' glue_val
      | box_base ',' ' ' box_glue   ',' ' ' GLUE_SHIFT ' ' glue_val ',' ' ' BOX_DISPLAY
      ;

box_base : BOX '(' FLOAT FLOAT ')' MULTIPLIER 
         { mk_box(strdup($1));  yytext_gc_run(); }
         ;

box_glue : GLUE ' ' GLUE_SET ' ' glue_val
         | GLUE ' ' GLUE_SET ' ' '-' ' ' glue_val
         | GLUE ' ' GLUE_SET ' ' '>' glue_val
         ;

anything : anything everything 
         | everything
         ;

everything : %empty
           | DISCRETIONARY
           | REPLACING
           | LIGATURE
           | FONT_ENC
           | FONT_SHAPE
           | FONT_SERIES
           | INT
           | FLOAT
           | CHAR
           | CMD
           | FLOAT_FIL
           | MULTIPLIER
           | GLUE
           | GLUE_PLUS 
           | GLUE_MINUS 
           | GLUE_SET
           | GLUE_SHIFT
           | SKIP
           | BOX
           | KERN
           | PENALTY
           | PDF
           | IO
           | RULE
           | MATH
           | SETLANG
           | UNKNOWN
           | punct
           ;

%%

int main(int argc, char **argv) { 
// 	yydebug = 1;
	setlocale(LC_ALL, "en_GB.UTF-8");
	extern FILE *yyin;
	
	cur_node = &top_level;
	cur_node->type = top;
	cur_node->depth = 0;
	cur_node->N = 0;
	cur_node->node_data = NULL;
	cur_node->children = NULL;
	cur_node->parent = NULL;
	
	last_style.family = "cmr";
	last_style.shape = "n";
	last_style.series = "m";
	last_style.size = 10.;
	
	yyin = fopen( argv[argc-1], "r+" );
	if ( yyin == NULL ) {
		fprintf(stderr, "unable to open file %s\n", argv[argc-1]);
		return 1;
	}
	
	yytext_gc_init();
	yyparse();
	yytext_gc_cleanup();
	
	fclose(yyin);
	
	print_tree( &top_level );
	return 0;
}


static void yytext_gc_init(void) {
	yyt_gcr.i = 0;
	yyt_gcr.N = 64;
	yyt_gcr.d = (char **)malloc( 64 * sizeof(char**));
	return;
}

static void yytext_gc_cleanup(void) {
	yytext_gc_run();
	free(	yyt_gcr.d );
}

void yytext_dup( const char *c ) {
	yylval = strdup(c);
	if ( yyt_gcr.i >= yyt_gcr.N ) {
		yyt_gcr.d = (char **)realloc( yyt_gcr.d, ( yyt_gcr.N + 64 ) * sizeof(char **) );
		yyt_gcr.N += 64;
	}
	yyt_gcr.d[yyt_gcr.i] = yylval;
	yyt_gcr.i++;
	return;
}

static void yytext_gc_run(void) {
	for(int i=0; i<yyt_gcr.i; i++) {
		free(yyt_gcr.d[i]);
	}
	yyt_gcr.i = 0;
	return;
}

static void add_child(void) {
	
	node_t *old_ptr = cur_node->children;
	
	if ( cur_node->N == 0 ) { 
		cur_node->children = (node_t *)malloc(sizeof(node_t));
	} else {
		cur_node->children = (node_t *)realloc(cur_node->children, (cur_node->N+1) * sizeof(node_t) );
	}

	cur_node->children[cur_node->N].parent = cur_node;
	cur_node->children[cur_node->N].N = 0;
	cur_node->children[cur_node->N].depth = cur_node->depth + 1;
	cur_node->children[cur_node->N].children = NULL;
	cur_node->children[cur_node->N].node_data = NULL;
	
	/* we realloc'd so we need to update some old pointers */
	if ( old_ptr != cur_node->children ) { 
		for (int i=0; i<cur_node->N+1; i++) {
			for (int j=0; j<cur_node->children[i].N; j++) {
				cur_node->children[i].children[j].parent = &(cur_node->children[i]);
			}
		}
	}
	
	cur_node->N++;
	return;
}

static int print_discretionary( int i, const node_t *node ) {
	struct discretionary_data *d = (struct discretionary_data *)(node->node_data);
	if (d->type == 0) {
		if ( node->N == 0 ) {
			if ( node->parent->N <= i+1 ) {
				return 0;
			}
			if ( node->parent->children[i+1].type != 6 ) {
				return 0;
			}
			struct text_data *t = (node->parent->children[i+1].node_data);
			if ( t->text[0] == '-' ) {
				printf(" ");
				return 1;
			}
			return 0;
		}
		
		if ( node->children[0].type == 6 ) {
			struct text_data *t = (node->children[0].node_data);
			if ( t->text[0] == '-' ) {
					return 2;
			}
		}
	}
	return 0;
}

static void print_glue( const node_t *node ) {
	struct glue_data *g = (struct glue_data *)(node->node_data);
	if ( g->skip == NULL ) { 
		/* if NULL, then it is pure glue */
		if ( g->target > 0.1 ) {
			if (node->parent->type == 1) {
				printf("\n");
			}	else {
				printf(" ");
			} 
		}
	} else {
		if ( strcmp(g->skip, "parfillskip") == 0 ) {
			printf("\n");
		} else if ( strcmp(g->skip, "baselineskip") == 0 ) {
			printf(" ");
		} else if ( strcmp(g->skip, "spaceskip") == 0 ) {
			printf(" ");
		} else if ( strcmp(g->skip, "tabskip") == 0 ) {
			printf("\t");
		}
	}
}

static void print_kern( const node_t *node ) {
	struct kern_data *k = (struct kern_data *)(node->node_data);
	if ( k->target > 7.0 ) {
		printf(" ");
	}
}

static void print_char( const struct text_data *t, size_t enc_pos ) {
	char32_t c;

	if ( strcmp(t->enc, "OT1") == 0 ) { 
		if ( strcmp(t->family, "cmtt") == 0 ) { 
			c = OT1_TT_ENC[enc_pos];
		} else {
			c = OT1_ENC[enc_pos];
		}
	} else if ( strcmp(t->enc, "T1") == 0 ) {
		c = T1_ENC[enc_pos];
	} else if ( strcmp(t->enc, "TS1") == 0 ) {
		c = TS1_ENC[enc_pos];
	} else if ( strcmp(t->enc, "OML") == 0 ) {
		c = OML_ENC[enc_pos];
	} else if ( strcmp(t->enc, "OMS") == 0 ) {
		c = OMS_ENC[enc_pos];
	} else if ( strcmp(t->enc, "OMX") == 0 ) {
		c = OMX_ENC[enc_pos];
	} else if ( strcmp(t->enc, "LY1") == 0 ) {
		c = LY1_ENC[enc_pos];
	} else {
		fprintf("Encoding %s not currently handled, defaulting to T1\n", t->enc);
		c = T1_ENC[enc_pos];
	}
	printf("%lc", c);
}

static void print_text( const node_t *node ) {
	struct text_data *t = (struct text_data *)(node->node_data);
	
	size_t enc_pos;
	
	if ( t->text[0] == '^' && strlen(t->text) == 3 ) {
		enc_pos = t->text[2] - 64;
		print_char(t, enc_pos);
	} else {
		for ( int i=0; i<strlen(t->text); i++ ) {
			enc_pos = t->text[i];
			print_char(t, enc_pos);
		}
	}
}

static void print_leaders( const node_t *node ) {
	if ( node->N == 0 ) {
		fprintf(stderr, "leader with no children??");
	}
	for (int i=0; i<7; i++) {
		print_tree(node);
	}
	return;
}

static void print_tree( const node_t *node) {
	node_t *n;
	int discretionary_skip_next = 0;
	bool mathmode = false;
	
	for (int i=0; i<node->N; i++) {
		n = &(node->children[i]);
		
		if ( discretionary_skip_next == 1 ) {
			continue;
			discretionary_skip_next = 0;
		}
		
		switch ( n->type ) {
			case (0): // top
				break;
			case (1): // vbox
				print_tree(n);
				break;
			case (2): // hbox
				print_tree(n);
				break;
			case (3): // leaders
				print_leaders(n);
				break;
			case (4): // discretionary
				discretionary_skip_next = print_discretionary(i, n);
				break;
			case (5): // glue 
				print_glue(n);
				break;
			case (6): // text
				print_text(n);
				break;
			case (7): // kern
				print_kern(n);
				break;
			case (8): // math
				struct mathmode_data *d = (struct mathmode_data *)n->node_data;
				mathmode = d->mode;
				break;
			case (9): // rule
// 				if ( mathmode ) {
// 					printf("/");
// 				}
				break;
			case (10): // ignored
				break;
		}
	}
}

static void mk_char( char *enc,   char *family, char *series
                   , char *shape, char *asize,  char *text_data, bool lig ) {
	struct text_data *d = (struct text_data *)malloc(sizeof(struct text_data));
	d->enc = enc;
	d->family = family;
	d->series = series;
	d->shape = shape;
	d->size = atof(asize);
	d->text = text_data;
	d->lig = lig;
  
  free(asize);
  
	add_child();
	
	node_t *this_node = &cur_node->children[ cur_node->N-1 ];
	this_node->node_data = (void *)d;
	this_node->type = text;
	return;
}

static void mk_glue( char *target, char* skip ) { 
	struct glue_data *d = (struct glue_data *)malloc(sizeof(struct glue_data));
	d->target = (size_t)atoi(target);
	d->skip = skip;
	
	add_child();
	node_t *this_node = &cur_node->children[ cur_node->N-1 ];
	this_node->node_data = (void *)d;
	this_node->type = glue;
	
	free(target);
	return;
}

static void mk_discretionary( char *atype ) {
	struct discretionary_data *d = (struct discretionary_data *)malloc(sizeof(struct discretionary_data));
	d->type = (size_t)( atoi(atype) );
	
	add_child();
	cur_node = &(cur_node->children[ cur_node->N-1 ]);
	cur_node->node_data = (void *)d;
	cur_node->type = discretionary;
	
	free(atype);
	return;
}

static void mk_box( char *boxtype ) {
	add_child();
	cur_node = &(cur_node->children[ cur_node->N-1 ]);
	cur_node->node_data = NULL;
	
	if ( strcmp(boxtype, "vbox") == 0 ) {
		cur_node->type = vbox;
	} else {
		cur_node->type = hbox;
	}
	
	free(boxtype);
	return;
}

static void mk_leader(void) {
	add_child();
	cur_node = &(cur_node->children[ cur_node->N-1 ]);
	cur_node->node_data = NULL;
	cur_node->type = leaders;
	return;
}

static void mk_kern( char *target ) {
	struct kern_data *d = (struct kern_data *)malloc(sizeof(struct kern_data));
	d->target = atof(target);
	
	add_child();
	node_t *this_node = &cur_node->children[ cur_node->N-1 ];
	this_node->node_data = (void *)d;
	this_node->type = kern;
	
	free(target);
}

static void mk_rule(void) {
	add_child();
	cur_node = &(cur_node->children[ cur_node->N-1 ]);
	cur_node->node_data = NULL;
	cur_node->type = rule;
	return;
}

static void mk_mathmode( char *mode ) {
	struct mathmode_data *d = (struct mathmode_data *)malloc(sizeof(struct mathmode_data));
	
	if ( strcmp(mode, "mathon") == 0 ) {
		d->mode = true;
	} else { 
		d->mode = false;
	} 
	
	add_child();
	node_t *this_node = &cur_node->children[ cur_node->N-1 ];
	this_node->node_data = (void *)d;
	this_node->type = math;
	
	free(mode);
}

static void indentation( size_t dotnum ) {
	if ( dotnum == cur_node->depth ) {
		return;
	} else if ( dotnum > cur_node->depth ) {
		fprintf(stderr, "\t Unexpected indent, expected %d, got %d\n", cur_node->depth, dotnum );
	} else {
		for( int i=0; i< cur_node->depth - dotnum; i++ ) {
			if ( cur_node->type == 0 ) {
				fprintf(stderr, "\t Trying to get parent of top level node!!!");
				exit(1);
			}
			cur_node = cur_node->parent;
		}
	}
}

void yyerror(const char *c) {
	extern char *yytext;
	fprintf(stderr, "yerror %s | %s |", c, yytext);
	for (int i=0; i<strlen(yytext); i++) {
		fprintf(stderr, " 0x%02x ", yytext[i]);
	}
	fprintf(stderr, "\n");
	return;
}
