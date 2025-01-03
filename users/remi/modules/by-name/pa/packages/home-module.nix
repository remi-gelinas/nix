{ pkgs, lib, ... }:
let
  fenixRust = pkgs.fenix.complete.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
  ];
in
{
  home.packages =
    with pkgs;
    [
      asciinema
      bun
      coreutils
      dive
      doggo
      fastfetch
      fd
      fenixRust
      go
      jq
      kubectl
      kubernetes-helm
      luajitPackages.luarocks
      magic-wormhole-rs
      nix-inspect
      nixfmt-rfc-style
      nixd
      php83
      php83Packages.composer
      ripgrep
      wget
      zig
      zls
    ]
    ++ (lib.optionals pkgs.stdenv.isLinux [
      ghostty
      zed-editor
    ]);
}
