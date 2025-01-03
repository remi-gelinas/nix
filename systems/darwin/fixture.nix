{
  lib,
  withSystem,
  inputs,
  ...
}:
let
  inherit (inputs) self nix-darwin;

  system = "aarch64-darwin";

  sharedDarwinModules = (import ../../modules/top-level/all-modules.nix { inherit lib; }).darwin;
in
{
  flake.darwinConfigurations.fixture = nix-darwin.lib.darwinSystem {
    inherit system;

    pkgs = withSystem system ({ pkgs, ... }: pkgs);

    modules = (builtins.attrValues sharedDarwinModules) ++ [
      inputs.stylix.darwinModules.stylix
      {
        system.configurationRevision = lib.mkDefault (self.shortRev or self.dirtyShortRev);
        nix.registry.nixpkgs.flake = inputs.nixpkgs;
      }
    ];
  };
}
