rosetta: {
  atuin = ./atuin.nix;
  bat = ./bat.nix;
  direnv = ./direnv.nix;
  firefox = ./firefox.nix;
  fish = ./fish.nix;
  gh = ./gh.nix;
  ghostty = ./ghostty.nix;
  git = ./git.nix;
  packages = ./packages.nix;
  rosetta-bridge = import ./rosetta-bridge.nix rosetta;
  ssh = ./ssh.nix;
  starship = ./starship.nix;
  thefuck = ./thefuck.nix;
  trampolines = ./trampolines.nix;
  zoxide = ./zoxide.nix;
}
