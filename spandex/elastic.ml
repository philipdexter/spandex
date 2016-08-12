let spf = Printf.sprintf

let print_all =
  List.iter print_endline

let enumerate ls =
  ["\\begin{enumerate}"] @
  List.map (fun s -> "\\item " ^ s ^ "\n") ls @
  ["\\end{enumerate}"]

let math = spf "\( %s \)"
