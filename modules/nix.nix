{
  # usable either in nixos or nix-darwin
  flake.modules.generic.nix = { pkgs, ... }: {
    nix = {
      settings = {
        always-allow-substitutes = true;
        auto-allocate-uids = pkgs.stdenv.hostPlatform.isLinux;
        extra-experimental-features = [
          "auto-allocate-uids"
          "nix-command"
          "flakes"
        ];
        sandbox = if pkgs.stdenv.hostPlatform.isDarwin then "relaxed" else "strict";
      };
      # The nix-installer adds this line, and also writes the referenced file.  It seems fine to support it.
      extraOptions = "!include nix.custom.conf";
    };
  };
}
