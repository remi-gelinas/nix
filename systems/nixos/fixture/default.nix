{
  lib,
  withSystem,
  inputs,
  ...
}:
let
  system = "aarch64-linux";

  sharedNixOSModules = (import ../../../modules/top-level/all-modules.nix { inherit lib; }).nixos;
in
{
  flake.nixosConfigurations.fixture = inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    pkgs = withSystem system ({ pkgs, ... }: pkgs);

    modules = (builtins.attrValues sharedNixOSModules) ++ [
      inputs.disko.nixosModules.default
      inputs.stylix.nixosModules.stylix
      ./modules/hardware.nix
      (
        { modulesPath, ... }:
        {
          imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];

          system = {
            stateVersion = "24.05";
            configurationRevision = lib.mkDefault (inputs.self.shortRev or inputs.self.dirtyShortRev);
          };

          time.timeZone = "America/Toronto";

          # This is a VM, it doesn't need to require password
          security.sudo.wheelNeedsPassword = false;
        }
      )
    ];
  };
}
