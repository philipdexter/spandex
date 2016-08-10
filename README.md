# sPaNdEx

sPaNDexX wraps your lLaTexX in a camel.

The first rule of spandex is to not let anybody else know you're using it.
See the motivation section for more information.

Spandex prints every line of the input file to stdout with one exception:

execute all OCaml code between `$${` and `}$$` and print its
output instead.

NB: `$${` and `}$$` must be on their own lines, sorry

# Motivation

Other compile-to-latex solutions exist and are nice.
_E.g._, [HaTeX](https://hackage.haskell.org/package/HaTeX) is great.
I always enjoy using HaTeX.
However I cannot, with a straight face, hand my Haskell project
to a colleague and expect them to download GHC, get cabal or stack
working, and edit a higher order function
to get just the right layout for a figure
while getting 20-line monad error messages from GHC
everytime they have a typo.
And all this is happening thirty minutes before the
deadline.
Yikes.

What academics know is TeX. So, let them write TeX.

Spandex's dogma is to allow users to write in OCaml
and then disappear
when it's time to commit to version control
or
ask a colleague for writing help.
