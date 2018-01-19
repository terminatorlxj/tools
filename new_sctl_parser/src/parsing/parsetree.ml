open Pterm
open Pformula

(* Syntactic definitions in a file *)
type pmodule =
    {
        mutable name: string;
        mutable filename: string;
        mutable pimported: string list;
        mutable pdefinitions: pdefinition list;
        mutable pspecs: (string * pfml_fair) list;
    }
and pdefinition = 
    | Pdef_type of string * Ptype.ptype_decl
    | Pdef_value of ppat * (Ptype.ptype option) * pexpr
    | Pdef_function of string * (Ptype.ptype option) * pfunction_decl
(* and ptype_decl = 
    {
        ptype_params: string list;
        ptype_kind: ptype_kind;
        ptype_loc: Location.t;
    }
and ptype_kind = 
    | PTvariant of (string * (Types.t list)) list
    | PTrecord of (string * Types.t) list *)
and pfunction_decl = 
    {
        pfunction_params: ppat list;
        pfunction_body: pexpr;
        pfunction_loc: Location.t
    }

(* type model = 
    {
        transitions: ppat * ptrans_def;
        fairness: pfml list;
        atomics: (string, (string list)*pexpr) Hashtbl.t;
        specs: (string * pfml) list;
    }
and ptrans_def = 
    | Ptrans_case of (pexpr * pexpr) list
    | Ptrans_plain of pexpr

type parse_unit = pmodule * (pkripke option) *)