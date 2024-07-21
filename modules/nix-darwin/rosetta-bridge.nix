rosetta:
{ lib, pkgs, ... }:
let
  inherit (rosetta.config.rosetta) nixpkgsConfig homeManagerModules;

  inherit (rosetta.inputs)
    fenix
    nixpkgs-firefox-darwin
    nixpkgs-master
    nixd
    neovim
    firefox-addons
    self
    ;
in
{
  _file = ./rosetta-bridge.nix;

  imports = [ ../common/colours.nix ];

  nixpkgs = {
    config = nixpkgsConfig;

    overlays = [
      fenix.overlays.default
      nixpkgs-firefox-darwin.overlay
      (_: _: {
        inherit (neovim.packages.${pkgs.system}) neovim;
        inherit (nixd.packages.${pkgs.system}) nixd;
        inherit (rosetta.config.flake.packages.${pkgs.system}) aerospace gh-poi;
        inherit (nixpkgs-master.legacyPackages.${pkgs.system}) atuin;

        firefox-addons = firefox-addons.packages.${pkgs.system};
      })
    ];
  };

  home-manager = {
    sharedModules = lib.attrValues homeManagerModules;
  };

  nix.registry = lib.pipe rosetta.inputs [
    (v: removeAttrs v [ "self" ])
    (lib.mapAttrs (_: flake: { inherit flake; }))
  ];

  system.configurationRevision = lib.mkDefault (self.shortRev or self.dirtyShortRev);
}
