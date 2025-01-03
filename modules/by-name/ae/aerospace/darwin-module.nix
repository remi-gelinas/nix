{ lib, ... }:
{
  # Rosetta config for AeroSpace
  programs.aerospace =
    let
      workspaces = {
        "Code" = {
          key = "c";
          apps = [ "com.microsoft.VSCode" ];
        };
        "Terminal" = {
          key = "t";
          apps = [ "com.mitchellh.ghostty" ];
        };
        "Web" = {
          key = "w";
          apps = [
            "org.mozilla.firefoxdeveloperedition"
            "org.mozilla.floorp"
          ];
        };
        "Social" = {
          key = "s";
          apps = [ "com.hnc.Discord" ];
        };
      };
    in
    {
      enable = true;

      config = {
        mode.main.binding =
          {
            # General movement

            # See: https://nikitabobko.github.io/AeroSpace/commands#layout
            alt-slash = "layout tiles horizontal vertical";
            alt-comma = "layout accordion horizontal vertical";

            # See: https://nikitabobko.github.io/AeroSpace/commands#focus;
            alt-h = "focus left";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";

            # See: https://nikitabobko.github.io/AeroSpace/commands#move;
            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";

            # See: https://nikitabobko.github.io/AeroSpace/commands#resize
            alt-shift-minus = "resize smart -50";
            alt-shift-equal = "resize smart +50";

            # Workspaces
            alt-s = "workspace Social";
            alt-w = "workspace Web";
            alt-t = "workspace Terminal";
            alt-c = "workspace Code";

            alt-shift-s = "move-node-to-workspace Social";
            alt-shift-w = "move-node-to-workspace Web";
            alt-shift-t = "move-node-to-workspace Terminal";
            alt-shift-c = "move-node-to-workspace Code";
          }
          # Generate shortcuts for each workspace
          // (lib.mapAttrs' (
            workspace: { key, ... }: lib.nameValuePair "alt-${key}" "workspace ${workspace}"
          ) workspaces)
          # Generate shortcuts to move nodes to each workspace
          // (lib.mapAttrs' (
            workspace: { key, ... }: lib.nameValuePair "alt-shift-${key}" "move-node-to-workspace ${workspace}"
          ) workspaces);

        "on-window-detected" =
          with lib;
          pipe workspaces [
            (mapAttrsToList (
              workspace:
              { apps, ... }:
              map (app: {
                "if".app-id = app;
                run = "move-node-to-workspace ${workspace}";
              }) apps
            ))
            flatten
          ];
      };
    };

  # Generic AeroSpace module
  imports = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      with lib;
      let
        cfg = config.programs.aerospace;
        configFormat = pkgs.formats.toml { };
      in
      {
        options.programs.aerospace = with types; {
          enable = mkEnableOption "aerospace";

          package = mkPackageOption pkgs "aerospace" { };

          runOnLogin = mkOption {
            type = bool;
            default = false;
          };

          config = mkOption {
            type = submodule {
              freeformType = attrsOf unspecified;

              options.on-window-detected = mkOption {
                type = listOf (submodule {
                  freeformType = attrsOf unspecified;

                  options = {
                    "if".app-id = mkOption { type = str; };
                    run = mkOption { type = str; };
                  };
                });
              };
            };

            default = { };
          };
        };

        config =
          let
            finalConfig = configFormat.generate "aerospace-config" cfg.config;
          in
          mkIf cfg.enable {
            environment.systemPackages = [ cfg.package ];

            launchd.user.agents.aerospace.serviceConfig = {
              ProgramArguments = [
                "${cfg.package}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"
                "--config-path"
                "${finalConfig}"
              ];

              KeepAlive = true;
              RunAtLoad = true;
              StandardOutPath = "/tmp/aerospace.log";
              StandardErrorPath = "/tmp/aerospace.err";
            };
          };
      }
    )
  ];
}
