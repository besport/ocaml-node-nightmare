type t = Node.t

val create_obj : show:bool -> Node.require_option [@@js.builder]

val create : bool -> t

[@@js.custom
  let create s =
    let n = Node.require_fn "nightmare" in
    n (create_obj ~show:s)
]

val inject_js : t -> string -> unit

[@@js.custom
  val inject : t -> string -> string -> unit [@@js.call]
  let inject_js t s = inject t "js" s
]

val then_ : t -> (Ojs.t -> unit) -> t [@@js.call "then"]

val end_ : t -> unit -> t [@@js.call "end"]

val goto : t -> string -> t [@@js.call]

val wait : t -> int -> t [@@js.call]

val evaluate : t -> Ojs.t -> t [@@js.call]

val evaluate_implicit : t -> t
[@@js.custom
  let evaluate_implicit n =
    let fn = (Js.Unsafe.js_expr
                "function eval(){
                   return ocaml_nightmare_evaluation();
                 }") in
    evaluate n fn
]

(** FIXME: seems to crash sometimes *)
val catch : t -> (Ojs.t -> unit) -> t [@@js.call]

(** FIXME: What about functions which require arguments ? *)
val set_evaluation_fn : (unit -> Ojs.t) -> unit

[@@js.custom
  let set_evaluation_fn fn =
    (Js.Unsafe.set
       Js.Unsafe.global
       "ocaml_nightmare_evaluation"
       (Js.Unsafe.callback fn)
    )
]
