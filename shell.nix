{ pkgs ? import <nixpkgs> {}}:

let
  pkg = import ./default.nix {};
in
  pkgs.mkShell {
    packages = [pkgs.ghcid pkgs.cabal-install];
    inputsFrom = [ pkg ];
  }
