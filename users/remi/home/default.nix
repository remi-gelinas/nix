{
  lib,
  withSystem,
  inputs,
  ...
}:
let
  userHomeModules = (import ../modules/top-level/all-modules.nix { inherit lib; }).home;
  sharedHomeModules = (import ../../../modules/top-level/all-modules.nix { inherit lib; }).home;

  username = "remi";

  mkHome =
    system:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = withSystem system ({ pkgs, ... }: pkgs);

      modules =
        (builtins.attrValues sharedHomeModules)
        ++ (builtins.attrValues userHomeModules)
        ++ [
          inputs.nixvim.homeManagerModules.default
          inputs.stylix.homeManagerModules.stylix
          (
            { config, ... }:
            {
              home = {
                inherit username;

                homeDirectory = "/home/${config.home.username}";
                stateVersion = "24.05";
              };
            }
          )
        ];
    };
in
{
  flake.homeConfigurations = {
    fixture = mkHome "aarch64-linux";
    fixture-aarch64-darwin = mkHome "aarch64-darwin";
  };
}
