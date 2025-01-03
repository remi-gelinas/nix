{ lib, inputs, ... }:
let
  inherit (inputs)
    lix-module
    nixpkgs-master
    fenix
    fonts
    ghostty
    nixd
    zls
    zed
    ;
in
{
  flake.overlays.default = lib.composeManyExtensions [
    (
      _: prev:
      let
        inherit (prev) system;
      in
      {
        inherit (ghostty.packages.${system}) ghostty;
        inherit (nixd.packages.${system}) nixd;
        inherit (zls.packages.${system}) zls;
        inherit (nixpkgs-master.legacyPackages.${system}) zig lix neovim-unwrapped;
      }
    )
    (_: prev: import ../pkgs/top-level/all-packages.nix { pkgs = prev; })
    fenix.overlays.default
    fonts.overlays.default
    lix-module.overlays.lixFromNixpkgs
    zed.overlays.zed-editor
  ];
}
