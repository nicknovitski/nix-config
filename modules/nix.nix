{
  flake.modules.generic.nix =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
    in
    {
      nix = {
        settings = {
          always-allow-substitutes = true;
          auto-allocate-uids = isLinux;
          experimental-features = [
            "auto-allocate-uids"
            "nix-command"
            "flakes"
          ]
          ++ pkgs.lib.optionals isLinux [ "cgroups" ];
          extra-system-features = pkgs.lib.optionals isLinux [ "uid-range" ];
          sandbox = if isDarwin then "relaxed" else true;
          substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
        };
        # The nix-installer adds this line, and also writes the referenced file.  It seems fine to support it.
        extraOptions = "!include nix.custom.conf";
      };
    };
}
