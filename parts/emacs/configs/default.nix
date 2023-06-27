args: [
  (import ./utils.nix args)
  (import ./default-el.nix args)
  (import ./early-init.nix args)

  (import ./frame.nix args)
  (import ./font.nix args)
  (import ./general.nix args)

  (import ./nord-theme.nix args)
  (import ./nix.nix args)
  (import ./lua.nix args)
  (import ./org.nix args)
  (import ./magit.nix args)
  (import ./envrc.nix args)
  (import ./aggressive-indent.nix args)
  (import ./corfu.nix args)
  (import ./vertico.nix args)
  (import ./embark.nix args)
  (import ./marginalia.nix args)
  (import ./orderless.nix args)
  (import ./consult.nix args)
  (import ./projectile.nix args)
]
