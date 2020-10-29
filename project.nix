let
  packageName = "handles";

  compiler = "ghc884";
  src = import ./nix/sources.nix;
  pkgs = import src.nixpkgs {};

  source = pkgs.lib.sourceByRegex ./. [
    "^.*\\.md$"
    "^app.*$"
    "^data.*$"
    "^.*\\.cabal$"
    "^src.*$"
    "^tests.*$"
    "LICENSE"
    ];

  overlay = self: super: {
    "${packageName}" = super.callCabal2nix "${packageName}" source { };
  };

  haskellPackages = pkgs.haskell.packages.${compiler}.override {
    overrides = overlay;
  };

in {
  dev = haskellPackages."${packageName}";
  build = haskellPackages."${packageName}";

  shell = haskellPackages.shellFor {
    packages = ps: [ ps."${packageName}" ];
    buildInputs = [
      haskellPackages.cabal-install
      haskellPackages.ghcid
    ];
  };
}
