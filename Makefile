.PHONY: all
all: spandex

spandex: spandex.ml
	ocamlfind ocamlopt -linkpkg -package cmdliner,unix spandex.ml -o ./spandex
