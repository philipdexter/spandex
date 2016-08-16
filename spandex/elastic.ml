let spf = Printf.sprintf

let enumerate ls =
  ["\\begin{enumerate}\n"] @
  List.map (fun s -> "\\item " ^ s ^ "\n") ls @
  ["\\end{enumerate}"]

let itemize ls =
  ["\\begin{itemize}\n"] @
  List.map (fun s -> "\\item " ^ s ^ "\n") ls @
  ["\\end{enumerate}"]

let math = spf "\\( %s \\)"

let out = print_endline
let outf f s = Printf.printf "%s\n" (Printf.sprintf f s)
let out_all =
  List.iter print_endline
