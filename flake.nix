#
# Nix flake.
#
# https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-flake#flake-format
# https://wiki.nixos.org/wiki/Flakes#Flake_schema
#
{
  inputs = { };

  outputs =
    inputs:
    let
      open-universes = {
        # TODO: Create a helper function like `nixpkgs.lib.filesystem.packagesFromDirectoryRecursive`
        #       which creates this attribute set from file system paths (e.g. Clojure deps.edn `:paths`).
        main = {
          "test-nix-ns.ns-a" = ./inputs/main/test-nix-ns/ns-a.nix;
          "test-nix-ns.ns-b" = ./inputs/main/test-nix-ns/ns-b.nix;
          "test-nix-ns.ns-c" = ./inputs/main/test-nix-ns/ns-c.nix;
          "test-nix-ns.ns-d" = ./inputs/main/test-nix-ns/ns-d.nix;
        };

        # Universe composition (order matters like library path precedence in most other programming languages).
        #
        # Universes from other flakes can be accessed with `inputs.{input}.open-universes.{universe}`.
        test = open-universes.main // {
          "test-nix-ns.ns-a-test" = ./inputs/test/test-nix-ns/ns-a-test.nix;
          "test-nix-ns.ns-b-test" = ./inputs/test/test-nix-ns/ns-b-test.nix;
          "test-nix-ns.ns-c-test" = ./inputs/test/test-nix-ns/ns-c-test.nix;
          "test-nix-ns.ns-d-test" = ./inputs/test/test-nix-ns/ns-d-test.nix;
        };
      };

      closed-universes = {
        # TODO: Create a helper function which instantiates/closes an open universe.
        main = builtins.mapAttrs (
          namespace: file:
          let
            closed-namespace = (import file) closed-universes.main;
          in
          assert builtins.isAttrs closed-namespace;
          closed-namespace
        ) open-universes.main;

        test = builtins.mapAttrs (
          namespace: file:
          let
            closed-namespace = (import file) closed-universes.test;
          in
          assert builtins.isAttrs closed-namespace;
          closed-namespace
        ) open-universes.test;
      };
    in
    {
      # TODO: Standardize flake outputs then vend a library with universe helper functions (e.g. Clojure tools.deps).
      inherit open-universes closed-universes;
    };
}
