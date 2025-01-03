{ pkgs, lib, ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };

    global = {
      brewfile = true;
      autoUpdate = true;
    };

    casks = [
      "1password"
      "visual-studio-code"
      "discord"
      "orbstack"
      "vmware-fusion"
      "floorp"
    ];

    masApps = {
      XCode = 497799835;
    };
  };

  # Ensure the `brew` binary is on $PATH for aarch64-darwin machines.
  programs.fish.interactiveShellInit = lib.mkIf (pkgs.system == "aarch64-darwin") ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
  '';
}
