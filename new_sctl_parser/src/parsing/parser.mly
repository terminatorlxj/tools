%{
    open Parsetree
%}

%token <int>Int 
%token <float>Float
%token <string>Iden UIden
%token <string>String
%token Import Datatype Vertical Value Let Match With Underline Model Next If Then Else For In While Do Done
%token LB1 RB1 LB2 RB2 LB3 RB3 Equal Non_Equal LT GT LE GE Comma Semicolon Dot DotDot Arrow EOF Add AddDot Minus MinusDot Mult MultDot
%token Negb Ando Oro And Or Neg LArrow Colon ColonColon Top Bottom AX EX AF EG AR EU True False Function
%token TList TFloat TArray TInt TBool TString TUnt At Init Transition Atomic Spec Fairness Assigno 
%start <Parsetree.pmodule>program
%%

program: 
      imports definitions EOF {({filename=""; pimported=$1; pdefinitions=$2, pspecs=[]})}
    | imports definitions specs EOF {{filename=""; pimported=$1; pdefinitions=$2, pspecs=$3}}
;

imports: {[]}
    | Import UIden imports {$1::$3}
;

definitions: {[]}
    | definition definitions {$1::$2}
;

definition:
      Value p=pattern ot=option(typ) Equal e=expr {Pdef_value (p,opt,e)}
    | Datatype tname=Iden Equal t=typ {Pdef_type (tname, {params=[];arity=0;kind=PTKalias t;ptype_decl_loc=Location.make $startpos(t) $endpos(t)})}
    | Datatype tname=Iden targ=Iden Equal t=typ {Pdef_type (tname, {params=[targ];arity=1;kind=PTKalias t;ptype_decl_loc=Location.make $startpos(t) $endpos(t)})}
    | Datatype tname=Iden LB1 targs=separated_list(Comma, Iden) RB1 Equal t=typ {Pdef_type (tname, {params=targs;arity=List.length targs;kind=PTKalias t;ptype_decl_loc=Location.make $startpos(t) $endpos(t)})}
    | Datatype tname=Iden Equal tk=type_kind {Pdef_value (tname, {params=[];arity=0;kind=tk;ptype_decl_loc=Location.make $startpos(tk) $endpos(tk)})}
;

typ: TInt {PTint}
    | TBool {PTbool}
    | TString {PTstring}
    | TFloat  {PTfloat}
    | TUnt {PTunit}
    | TArray typ  {PTarray $2}
    | TList typ {PTlist $2}
    | typ Arrow typ {PTarrow ($1, $3)}
    | tuple_type {PTtuple $1}
    | path list(typ) {PTapply (Path.make_path $1, $2)}
    | LB1 typ RB1 {$2}
;

tuple_type: typ Comma typ  {[$1;$2]}
    | typ Comma tuple_type {$1::$3}
    ;

path: Iden {$1}
    | UIden {$1}
    | UIden Dot path {$1::$3}
    | Iden Dot path {$1::$3}
    ; 

type_kind: LB3 separated_nonempty_list(Semicolon, separated_pair(Iden, Colon, typ)) RB3 {PTKrecord $2}
    | separated_nonempty_list (Vertical, pair(UIden, typ)) {PTKvariant $1}
;

/* uiden_type_pair: UIden typ {($1,$2)}; */

expr: expr_single Semicolon separated_nonempty_list(Semicolon, expr_single) {Pexpr_sequence ($1::$3)}
    | expr_single {$1}
    | LB1 expr RB1 {$2}
    ;
expr_single: path {Pexpr_path $1}
    | Int {Pexpr_const (Pconst_int $1)}
    | True {Pexpr_const (Pconst_bool true)}
    | False {Pexpr_const (Pconst_bool false)}
    | String {Pexpr_const (Pconst_string $1)}
    | Float {Pexpr_const (Pconst_float $1)}
    | LB1 RB1 {Pexpr_const (Pconst_unit)}
    | Let pattern Equal expr_single {Pexpr_let ($2, $4)}
    |  
%%