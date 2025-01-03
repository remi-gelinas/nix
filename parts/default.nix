{
  packages = ./packages.nix;
  gitHooks = ./git-hooks.nix;
  formatter = ./formatter.nix;
  overlays = ./overlays.nix;
  devShells = ./devshells.nix;
  darwinConfigurations = ./darwin-configurations.nix;
  nixosConfigurations = ./nixos-configurations.nix;
  homeConfigurations = ./home-configurations.nix;
  githubActions = ./github-actions.nix;
}
