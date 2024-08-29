{
  lib,
  config,
  flake-parts-lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    foldAttrs
    mergeAttrs
    mapAttrsToList
    ;

  inherit (flake-parts-lib) mkSubmoduleOptions;

  cfg = config.flake.darwinConfigurations;
in
{
  imports = [ ../systems/darwin ];

  options.flake = mkSubmoduleOptions {
    darwinConfigurations = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
      description = ''
        Instantiated nix-darwin configurations. Used by `darwin-rebuild`.

        `darwinConfigurations` is for specific machines. If you want to expose
        reusable configurations, add them to [`darwinModules`](#opt-flake.darwinModules)
        in the form of modules (no `lib.darwinSystem`), so that you can reference
        them in this or another flake's `darwinConfigurations`.
      '';
    };
  };

  config.flake.checks = foldAttrs mergeAttrs { } (
    mapAttrsToList (name: system: {
      ${system.system.system} = {
        "darwin-system-${name}" = system.system;
      };
    }) cfg
  );
}
