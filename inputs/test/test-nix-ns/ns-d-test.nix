# ----------------------------------------------------------------------------------------------------
# Function that takes all namespaces and returns namespace bindings.
# ----------------------------------------------------------------------------------------------------

U:

# ----------------------------------------------------------------------------------------------------
# Requires/imports.
#
# `with` behaves like `require`/`import` in many programming languages.
# Its usage tends to be scoped since inheriting bindings from attribute sets
# declared elsewhere makes it difficult to know what bindings are present, especially
# in the absence of a good LSP.
#
# For example, Nixpkgs derivations sometimes use it for `meta` (e.g. `meta = with lib; { ... };`).
# Even this is undesirable as many usages are switched to `meta = { license = lib.licenses.mit; maintainers = with lib.maintainers [ ... ]; };`.
# ----------------------------------------------------------------------------------------------------

# Equivalent to:
# - `(require [builtins :refer :all])`
# - `from builtins import *`
with builtins
// {
  # Equivalent to:
  # - `(require ["test-nix-ns.ns-d" :as ns-d])`
  # - `import "test-nix-ns.ns-d" as ns-d`
  ns-d = U."test-nix-ns.ns-d";
};

# ----------------------------------------------------------------------------------------------------
# Private bindings.
#
# `let...in` behaves like `let` in many Lisp dialects and `let...in` in Haskell.
# ----------------------------------------------------------------------------------------------------

let
  test-apple =
    assert ns-d.apple == 10;
    null;
  test-pie =
    assert ns-d.pie == 1;
    null;
  test-apple-pie =
    assert ns-d.apple-pie == 99;
    null;
in

# ----------------------------------------------------------------------------------------------------
# Public bindings.
# ----------------------------------------------------------------------------------------------------

{
  inherit test-apple test-pie test-apple-pie;
}
