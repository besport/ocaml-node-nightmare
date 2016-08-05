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

val catch : t -> (Ojs.t -> unit) -> t [@@js.call]
