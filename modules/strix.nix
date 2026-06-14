{ lib, inputs, ... }: {
  flake.modules.nixos.default = {
    imports = [
      # ./configuration.nix, hardware, etc
      inputs.modules.nixos.home-manager
    ];
  };
  flake.nixosConfigurations.strix = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.flake.modules.nixos.default
      { home-manager.users.nick.home.stateVersion = "26.05"; }
    ];
  };
}
