localFlake: let
  inherit (import ./lib.nix) generatePackageSourceWithNixpkgs mkEmacsPackage;
in {
  imports = import ./configs {
    inherit localFlake mkEmacsPackage;
  };

  perSystem = {
    system,
    config,
    ...
  }: let
    localNixpkgs = import localFlake.inputs.nixpkgs-master {
      inherit system;
      config = localFlake.config.nixpkgsConfig;
      overlays = [localFlake.inputs.emacs-unstable.overlays.default];
    };

    generatePackageSource = generatePackageSourceWithNixpkgs localNixpkgs;

    inherit (localNixpkgs.lib) mkOption types optional;

    cfg = config.emacs;

    configPackageType = types.submodule ({config, ...}: {
      options = {
        name = mkOption {
          type = types.str;
        };

        tag = mkOption {
          type = types.str;
          default = "";
        };

        comment = mkOption {
          type = types.str;
          default = "";
        };

        code = mkOption {
          type = types.str;
        };

        requiresPackages = mkOption {
          type =
            types.either
            (types.functionTo (types.listOf types.package))
            (types.listOf types.package);
          default = [];
        };

        requiresUsePackage = mkOption {
          type = types.bool;
          default = true;
        };

        requiresBinariesFrom = mkOption {
          type =
            types.either
            (types.functionTo (types.listOf types.package))
            (types.listOf types.package);
          default = [];
        };

        finalBinaryPackages = mkOption {
          type = types.listOf types.package;
          readOnly = true;
        };

        finalPackage = mkOption {
          type = types.package;
          readOnly = true;
        };
      };

      config.finalBinaryPackages = let
        type = builtins.typeOf config.requiresBinariesFrom;
      in
        if type == "lambda"
        then config.requiresBinariesFrom localNixpkgs
        # then type is list - maybe explicitly throw here? Should be handled by the option type check
        else config.requiresBinariesFrom;

      config.finalPackage = let
        epkgs = localNixpkgs.emacsPackages;
      in
        epkgs.trivialBuild {
          pname = config.name;
          src = generatePackageSource {inherit (config) name tag comment code requiresUsePackage;};
          packageRequires = let
            type = builtins.typeOf config.requiresPackages;
          in
            (
              if type == "lambda"
              then config.requiresPackages epkgs
              # then type is list - maybe explicitly throw here? Should be handled by the option type check
              else config.requiresPackages
            )
            ++ optional config.requiresUsePackage epkgs.use-package;
        };
    });
  in {
    options.emacs = {
      configPackages = mkOption {
        type = types.attrsOf configPackageType;
      };

      extraInit = mkOption {
        type = types.str;
        default = "";
      };

      extraConfigPackages = mkOption {
        type = types.attrsOf configPackageType;
        default = {};
      };

      finalPackage = mkOption {
        type = types.package;
        readOnly = true;
      };
    };

    config.emacs = {
      finalPackage = with localNixpkgs; let
        inherit (lib.attrsets) mapAttrsToList;

        emacsPackage = callPackage (import config.legacyPackages.editors.emacs {
          inherit (localFlake.inputs) emacs-unstable;
        }) {};
      in
        (emacsPackagesFor emacsPackage).emacsWithPackages (
          _:
            []
            ++ (mapAttrsToList (_: pkg: pkg.finalPackage) config.emacs.configPackages)
            ++ (mapAttrsToList (_: pkg: pkg.finalPackage) config.emacs.extraConfigPackages)
        );
    };

    config.checks.emacs = cfg.finalPackage;
  };
}
