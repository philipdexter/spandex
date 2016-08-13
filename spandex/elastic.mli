val enumerate : string list -> string list

val math : string -> string

(** print string to stdout followed by a newline *)
val out : string -> unit
(** print formatted string to stdout followed by a newline *)
val outf : ('a -> string, unit, string) format -> 'a -> unit
(** print list of strings, each followed by a newline, to stdout *)
val out_all : string list -> unit
