{
  description = "workstations";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs.lib.fileset) toList fileFilter;
      listFiles = filter: dir: toList (fileFilter filter dir);
      isNix = f: f.hasExt "nix";
      imports = [ inputs.flake-parts.flakeModules.modules ] ++ listFiles isNix ./modules;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } { inherit imports; };
}
