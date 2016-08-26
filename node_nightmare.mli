type t = Node.node_module

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

val back : t -> t [@@js.call "back"]

val forward : t -> t [@@js.call "forward"]

val refresh : t -> t [@@js.call "refresh"]

val click : t -> string -> t [@@js.call "click"]

val mousedown : t -> string -> t [@@js.call "mousedown"]

val type_ : t -> string -> ?text:string -> unit -> t [@@js.call "type"]

val insert : t -> string -> ?text:string -> unit -> t [@@js.call "insert"]

val check : t -> string -> t [@@js.call "check"]

val uncheck : t -> string -> t [@@js.call "uncheck"]

val select : t -> string -> t [@@js.call "select"]

val scroll_to : t -> int -> int -> t [@@js.call "scrollTo"]

val viewport : t -> int -> int -> t [@@js.call "viewport"]

val inject : t -> string -> string -> t [@@js.call "inject"]

val then_ : t -> (Ojs.t -> unit) -> t [@@js.call "then"]

val end_ : t -> unit -> t [@@js.call "end"]

val goto : t -> string -> t [@@js.call]

val wait : t -> int -> t [@@js.call]

val wait_selector : t -> string -> t [@@js.call "wait"]

val wait_function : t -> (Ojs.t -> bool) -> t [@@js.call "wait"]

(*val header : t -> *)

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

(** Extract from the page **)

val exists  : t -> string -> bool [@@js.call]

val visible : t -> string -> bool [@@js.call]

(** Missing on, once, removeListenenr **)
module Bounds: sig
  type t
  val create:
    x:int ->
    y:int ->
    width:int ->
    height: int ->
    t [@@js.builder]
end

val screenshot : t -> path:string -> ?clip:Bounds.t -> unit -> t [@@js.call]

type save_type =
  | HTMLOnly [@js "HTMLOnly"]
  | HTMLComplete [@js "HTMLComplete"]
  | HTML [@js "HTML"]
[@@js.enum]

val html  : t -> string -> save_type -> t [@@js.call]

val pdf   : t -> string -> Ojs.t -> t [@@js.call]

val title : t -> string [@@js.call]

val url   : t -> string [@@js.call]
