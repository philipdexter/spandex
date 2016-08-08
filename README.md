# sPaNdEx

sPaNDexX wraps your lLaTexX in a camel.

Every line of the input file is printed to stdout with one exception:

All OCaml code between `$${` and `}$$` is executed and its result
is printed instead of the code.

NB: `$${` and `}$$` must be on their own lines, sorry
