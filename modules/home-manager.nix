{ inputs, ... }: {
  imports = [ inputs.home-manager.flakeModules.home-manager ];
  flake.modules.generic.home-manager = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
    nixpkgs.config.allowUnfreePackages = [
      "slack"
      "discord"
    ];
  };
  flake.modules.nixos.home-manager.imports = [
    inputs.self.modules.generic.home-manager
    inputs.home-manager.nixosModules.home-manager
  ];
  flake.modules.darwin.home-manager.imports = [
    inputs.self.modules.generic.home-manager
    inputs.home-manager.darwinModules.home-manager
  ];
  flake.modules.darwin.me = {
    system.primaryUser = "nick";
    users.users.nick.home = "/Users/nick";
    home-manager.users.nick.imports = [ inputs.self.homeModules.default ];
  };
  flake.homeModules.zed = { pkgs, ... }: {
    programs.zed-editor = {
      enable = true;
      defaultEditor = true;
      extensions = [ "nix" ];
      extraPackages = builtins.attrValues { inherit (pkgs) nil nixd; };
      userSettings = {
        disable_ai = true;
        vim_mode = true;
      };
    };
  };
  flake.homeModules.git = { pkgs, ... }: {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Nick Novitski";
          email = "git@nicknovitski.com";
        };
        alias = {
          ap = "add --patch";
          b = "branch";
          bc = "!git branch | ${pkgs.fzf}/bin/fzf | xargs git checkout";
          ci = "commit";
          cia = "commit --amend";
          co = "checkout";
          d = "diff --color-words";
          dc = "diff --cached --color-words";
          f = "fetch --prune";
          force-push = "push --force-with-lease";
          out = "!cd $(git top)/..";
          rb = "rebase";
          rba = "rebase --abort";
          rbc = "rebase --continue";
          rbi = "rebase --interactive";
          rs = "restore --staged";
          top = "git rev-parse --show-toplevel";
          undo = "revert --no-commit";
        };
        pull.rebase = true;
        merge = {
          conflictstyle = "diff3";
          renameLimit = 999999;
        };
        commit.verbose = true;
        credential.helper = if pkgs.stdenv.hostPlatform.isDarwin then "osxkeychain" else "libsecret";
        color.ui = "auto";
        fetch.pruneTags = true;
        diff.renameLimit = 999999;
      };
    };
    programs.zsh = {
      siteFunctions.g = ''
        if [ $# -eq 0 ]; then
          git status
        else
          git "$@"
        fi
      '';
      # make tab-completions recognize "g" as "git"
      initContent = "compdef g='git'";
    };
  };
  flake.homeModules.default = { pkgs, ... }: {
    imports = [
      inputs.self.homeModules.git
      inputs.self.homeModules.news
      inputs.self.homeModules.zed
    ];
    programs.firefox.enable = true;
    programs.nh.enable = true;
    programs.discord.enable = true;
    programs.wezterm.enable = true;
    programs.zsh = {
      enable = true;
    };
    home.packages = builtins.attrValues {
      inherit (pkgs)
        devenv
        fd
        github-cli
        gnugrep # cross-platform consistency
        ripgrep
        slack
        ;
    };
  };
}
