{ inputs, ... }:
{
  flake.modules.darwin.linux-builder = {
    imports = [ inputs.nix-rosetta-builder.darwinModules.default ];
    # see available options in module.nix's `options.nix-rosetta-builder`
    nix-rosetta-builder = {
      onDemand = true;
      onDemandLingerMinutes = 33;
    };
    #nix.linux-builder.enable = true;
  };
}
