(**
   Every line of the input file is printed to stdout with one exception:

   All OCaml code between '$${' and '}$$' is executed and its result
   is printed instead of the code.

   NB: '$${' and '}$$' must be on their own lines
*)
let spandex file =
  let some_or_fail sx =
  match sx with
  | Some x -> x
  | None -> failwith "some_or_fail got None" in

  try Unix.mkdir "_spandex" 0o755
  with Unix.Unix_error (Unix.EEXIST, _, _) -> () ;

  let fin = open_in file in
  let reading = ref false in
  let fout = ref None in
  let fname = ref None in
  try
    while true do
      let line = input_line fin in
      if not !reading && line = "$${" then begin
        reading := true ;
        fname := Some (Filename.temp_file ~temp_dir:"./_spandex" "spandex" ".ml") ;
        fout := Some (open_out (some_or_fail !fname)) ;
      end
      else if !reading && line = "}$$" then begin
        reading := false ;
        close_out (some_or_fail !fout) ;
        let fname = (some_or_fail !fname) in
        let pipe = Unix.open_process_in (Printf.sprintf "ocamlfind ocamlc -linkpkg -package spandex -o ./_spandex/tmp.byte %s" fname) in
        (match Unix.close_process_in pipe with
         | Unix.WEXITED 1 | Unix.WSIGNALED _ | Unix.WSTOPPED _ -> failwith (Printf.sprintf "failed to build %s" fname)
         | Unix.WEXITED _ -> ()) ;
        let pipe = Unix.open_process_in "./_spandex/tmp.byte" in
        (try
           while true do
             print_endline (input_line pipe)
           done
         with End_of_file -> ()) ;
        ignore (Unix.close_process_in pipe)
      end
      else if !reading then begin
        Printf.fprintf (some_or_fail !fout) "%s\n" line
      end
      else
        print_endline line
    done
  with End_of_file -> ()

open Cmdliner

let spandex =
  let version = "0.1" in


  let file =
    let doc = "sPaNdEx input file" in
    let docv = "FILE" in
    Arg.(required & pos 0 (some string) None & info [] ~doc ~docv) in
  let term = Term.(const spandex $ file) in

  let doc = "Wrap a camel in latex. Wait... wrap a latex in a camel?" in
  let man =
    [ `S "DESCRIPTION" ;
      `P "$(b,$(mname)) does some stuff" ;
      `S "AUTHOR" ;
      `P "Philip Dexter, $(i,http://phfilip.com)" ;
      `S "REPORTING BUGS" ;
      `P "Report bugs on the GitHub project page http://github.com/philipdexter/spandex/issues" ;
    ] in
  let info = Term.info "spandex" ~version ~man ~doc in

  (term, info)

let () = match Term.eval spandex with
  | `Error _ -> exit 1
  | _ -> exit 0
