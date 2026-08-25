# test-nix-ns

Making Nix namespacing look more like typical programming language namespacing compared to the Nixpkgs overlay + `callPackage` abstractions.

Main ideas:

1. Namespaces are flat (e.g. `"test-nix-ns"` is __not__ the parent of `"test-nix-ns.ns-a"`).
2. Namespace layout mirrors the source layout.
3. Universes are collections of namespaces.
4. Open universes map a namespace to its source.
5. Closed universes map a namespace to its bindings.

## Layout

Notable landmarks:

```text
Key:
🤖 = Generated

.
│   # Nix sources.
├── inputs
│   └── {universe}
│       ├── {namespace fragment}
│       │   └── {namespace fragment}.nix
│       └── {namespace}.nix
│
│   # Nix configuration.
├── flake.nix
└── flake.lock 🤖
```

## Notes

### Inspecting Flakes Interactively

Sometimes you might want to inspect flakes interactively for things like finding what attributes exist on an attribute set.

You can use the Nix REPL to load a flake and inspect it.

```shell
# Start the Nix REPL.
nix repl

# Load the flake.
nix-repl> :load-flake .

# Inspect the flake.
#
# Tab completion lists available attributes.
nix-repl> outputs.
nix-repl> outputs.closed_universes.main.
nix-repl> outputs.closed_universes.main."test-nix-ns.ns-a".
nix-repl> :print outputs
{
  closed-universes = {
    main = {
      "test-nix-ns.ns-a" = {
        apple = 10;
        apple-pie = 11;
        pie = 1;
      };
      "test-nix-ns.ns-b" = {
        cake = 2;
        strawberry = 20;
        strawberry-cake = 22;
      };
      "test-nix-ns.ns-c" = {
        apple-cake = 12;
        strawberry-pie = 21;
      };
      "test-nix-ns.ns-d" = {
        apple = 10;
        apple-pie = 99;
        pie = 1;
      };
    };
    test = {
      "test-nix-ns.ns-a" = {
        apple = 10;
        apple-pie = 11;
        pie = 1;
      };
      "test-nix-ns.ns-a-test" = {
        test-apple = null;
        test-apple-pie = null;
        test-pie = null;
      };
      "test-nix-ns.ns-b" = {
        cake = 2;
        strawberry = 20;
        strawberry-cake = 22;
      };
      "test-nix-ns.ns-b-test" = {
        test-cake = null;
        test-strawberry = null;
        test-strawberry-cake = null;
      };
      "test-nix-ns.ns-c" = {
        apple-cake = 12;
        strawberry-pie = 21;
      };
      "test-nix-ns.ns-c-test" = {
        test-apple-cake = null;
        test-strawberry-pie = null;
      };
      "test-nix-ns.ns-d" = {
        apple = 10;
        apple-pie = 99;
        pie = 1;
      };
      "test-nix-ns.ns-d-test" = {
        test-apple = null;
        test-apple-pie = null;
        test-pie = null;
      };
    };
  };
  open-universes = {
    main = {
      "test-nix-ns.ns-a" = /nix/store/nrcyl34cd2dhxcjpclypdimxdlyv75d4-source/inputs/main/test-nix-ns/ns-a.nix;
      "test-nix-ns.ns-b" = /nix/store/nrcyl34cd2dhxcjpclypdimxdlyv75d4-source/inputs/main/test-nix-ns/ns-b.nix;
      "test-nix-ns.ns-c" = /nix/store/nrcyl34cd2dhxcjpclypdimxdlyv75d4-source/inputs/main/test-nix-ns/ns-c.nix;
      "test-nix-ns.ns-d" = /nix/store/nrcyl34cd2dhxcjpclypdimxdlyv75d4-source/inputs/main/test-nix-ns/ns-d.nix;
    };
    test = {
      "test-nix-ns.ns-a" = /nix/store/nrcyl34cd2dhxcjpclypdimxdlyv75d4-source/inputs/main/test-nix-ns/ns-a.nix;
      "test-nix-ns.ns-a-test" = /nix/store/nrcyl34cd2dhxcjpclypdimxdlyv75d4-source/inputs/test/test-nix-ns/ns-a-test.nix;
      "test-nix-ns.ns-b" = /nix/store/nrcyl34cd2dhxcjpclypdimxdlyv75d4-source/inputs/main/test-nix-ns/ns-b.nix;
      "test-nix-ns.ns-b-test" = /nix/store/nrcyl34cd2dhxcjpclypdimxdlyv75d4-source/inputs/test/test-nix-ns/ns-b-test.nix;
      "test-nix-ns.ns-c" = /nix/store/nrcyl34cd2dhxcjpclypdimxdlyv75d4-source/inputs/main/test-nix-ns/ns-c.nix;
      "test-nix-ns.ns-c-test" = /nix/store/nrcyl34cd2dhxcjpclypdimxdlyv75d4-source/inputs/test/test-nix-ns/ns-c-test.nix;
      "test-nix-ns.ns-d" = /nix/store/nrcyl34cd2dhxcjpclypdimxdlyv75d4-source/inputs/main/test-nix-ns/ns-d.nix;
      "test-nix-ns.ns-d-test" = /nix/store/nrcyl34cd2dhxcjpclypdimxdlyv75d4-source/inputs/test/test-nix-ns/ns-d-test.nix;
    };
  };
}
```
