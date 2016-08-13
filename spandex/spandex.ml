(**
   Every line of the input file is printed to stdout with one exception:

   All OCaml code between '$${' and '}$$' is executed and its result
   is printed instead of the code.

   NB: '$${' and '}$$' must be on their own lines
*)

(* TODO make $!$ into a string thing *)

type state =
  | Latex
  | Elastic of out_channel * string

let spandex file show_spandex =
  try Unix.mkdir "_spandex" 0o755
  with Unix.Unix_error (Unix.EEXIST, _, _) -> () ;

  let fin = open_in file in
  let st = ref Latex in
  (try
     while true do
       let line = input_line fin in
       match !st with
       | Latex -> if line = "$${" then begin
           let fname = Filename.temp_file ~temp_dir:"./_spandex" "spandex" ".ml" in
           st := Elastic (open_out fname, fname)
         end else
           print_endline line
       | Elastic (fout, fname) -> if line = "}$$" then begin
           st := Latex ;
           close_out fout ;
           let fname = fname in
           if show_spandex then begin
             Printf.printf "%%%% spandex <%s>\n" fname ;
             let fin = open_in fname in
             (try while true do
                  Printf.printf "%%%% %s\n" (input_line fin)
                done
              with End_of_file -> ()) ;
             close_in fin ;
             print_endline "%% end spandex"
           end ;
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
         end else
           Printf.fprintf fout "%s\n" line
     done
   with End_of_file -> ()) ;
  close_in fin


open Cmdliner

let spandex =
  let version = "0.1" in

  let flag_show_spandex =
    let doc = "Annotate each use of OCaml with comments" in
    Arg.(value & flag & info ["y" ; "your-spandex-is-showing"] ~doc) in

  let file =
    let doc = "sPaNdEx input file" in
    let docv = "FILE" in
    Arg.(required & pos 0 (some string) None & info [] ~doc ~docv) in
  let term = Term.(const spandex $ file $ flag_show_spandex) in

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
