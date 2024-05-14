{ withSystem, ... }:
{ pkgs, ... }:
{
  home.packages =
    let
      nixd = withSystem pkgs.system ({ inputs', ... }: inputs'.nixd.packages.nixd);
    in
    with pkgs;
    [
      cachix
      coreutils
      nodejs
      nodePackages.node2nix
      jq
      git-crypt
      ripgrep
      fd
      git-filter-repo
      kubernetes-helm
      kubectl
      expect
      nurl
      nvd
      nix-output-monitor
      warp-terminal
    ]
    ++ [ nixd ];
}
