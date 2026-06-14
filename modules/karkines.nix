{ inputs, ... }: {
  systems = [ "aarch64-darwin" ];
  flake.modules.darwin.keys.system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
  flake.modules.darwin.default.imports = builtins.attrValues {
    inherit (inputs.self.modules.darwin)
      home-manager
      keys
      linux-builder
      me
      ;
    inherit (inputs.self.modules.generic) nix;
  };
  flake.darwinConfigurations.karkines = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      inputs.self.modules.darwin.default
      {
        system.stateVersion = 6;
        home-manager.users.nick.home.stateVersion = "26.05";
      }
    ];
  };
}
