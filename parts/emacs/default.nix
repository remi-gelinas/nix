localFlake: {
  perSystem = {
    pkgs,
    lib,
    system,
    config,
    ...
  }: let
    inherit (lib) mkOption types;

    cfg = config.emacs;
  in {
    options.emacs = {
      extraInit = mkOption {
        type = types.str;
        default = "";
      };

      package = mkOption {
        type = types.package;
        readOnly = true;
      };

      binaries = mkOption {
        type = types.listOf types.package;
        default = [];
      };

      extraBinaries = mkOption {
        type = types.listOf types.package;
        default = [];
      };
    };

    config.emacs = let
      emacs-config-org = localFlake.withSystem system ({config, ...}:
        config.legacyPackages.builders.tangleOrgDocument {
          name = "emacs-config-org";
          src = ./config.org;

          templateVars = {
            VARIABLE_FONT = "SF Pro";
            FIXED_FONT = "PragmataPro Mono Liga";
          };
        });

      extra-init = pkgs.writeText "extra-init.el" cfg.extraInit;

      init-postlude = let
        directories = cfg.binaries ++ cfg.extraBinaries;
      in
        pkgs.writeText "init-postlude.el" (lib.optionalString ((builtins.length directories) != 0) ''
          (dolist (dir '(${lib.concatMapStringsSep " " (dir: ''"${dir}/bin"'') directories}))
            (add-to-list 'exec-path dir))
          (setenv "PATH" (concat "${lib.concatMapStringsSep ":" (x: "${x}/bin") directories}:" (getenv "PATH")))
        '');

      init = pkgs.concatText "init.el" [
        (emacs-config-org + "/init.el")
        extra-init
        init-postlude
      ];
    in {
      package = pkgs.callPackage (import config.legacyPackages.editors.emacs {
        inherit (localFlake.inputs) emacs-unstable;
        config = init;
      }) {};

      # Packages that are available to the emacs package system-wide.
      binaries = with pkgs; [
        direnv
        python311
        alejandra
        nil
      ];
    };

    config.checks.emacs = cfg.package;
  };
}
