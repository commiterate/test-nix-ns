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
  # - `(require ["test-nix-ns.ns-c" :as ns-c])`
  # - `import "test-nix-ns.ns-c" as ns-c`
  ns-c = U."test-nix-ns.ns-c";
};

# ----------------------------------------------------------------------------------------------------
# Private bindings.
#
# `let...in` behaves like `let` in many Lisp dialects and `let...in` in Haskell.
# ----------------------------------------------------------------------------------------------------

let
  test-apple-cake =
    assert ns-c.apple-cake == 12;
    null;
  test-strawberry-pie =
    assert ns-c.strawberry-pie == 21;
    null;
in

# ----------------------------------------------------------------------------------------------------
# Public bindings.
# ----------------------------------------------------------------------------------------------------

{
  inherit test-apple-cake test-strawberry-pie;
}
