{
  localFlake,
  mkEmacsPackage,
  ...
}:
mkEmacsPackage "font-config" ({system, ...}: let
  variableFont = "SF Pro";
  fixedFont = "PragmataPro Mono Liga";

  configPackages = localFlake.withSystem system ({config, ...}: config.emacs.configPackages);
in {
  requiresPackages = epkgs: [
    configPackages.rosetta-utils.finalPackage
    epkgs.use-package
  ];

  code =
    #src: emacs-lisp
    ''
      (eval-when-compile
        (require 'use-package))

      (use-package ${configPackages.rosetta-utils.name}
        :config
        (rosetta/hook-if-daemon
          "general-font-setup"
          (custom-theme-set-faces
            'user
            '(variable-pitch ((t (:family "${variableFont}" :height 200 :weight regular))))
            '(fixed-pitch ((t (:family "${fixedFont}" :height 180)))))))
    '';
})
