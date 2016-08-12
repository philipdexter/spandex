#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe "spandex" @@ fun c ->
  Ok [ Pkg.bin "spandex/spandex"
     ; Pkg.lib "pkg/META"
     ; Pkg.mllib ~api:["Elastic"] "spandex/elastic.mllib" ]
