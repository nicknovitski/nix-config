{ inputs, ... }: {
  flake.modules.nixos.default = { pkgs, ... }: {
    imports = [
      inputs.self.modules.nixos.home-manager
      inputs.self.modules.generic.nix
    ];
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    boot.kernelPackages = pkgs.linuxPackages_latest;
    hardware.facter.reportPath = ./facter.json;
    networking.networkmanager.enable = true;
    time.timeZone = "America/Los_Angeles";

    i18n =
      let
        defaultLocale = "en_US.UTF-8";
      in
      {
        inherit defaultLocale;
        extraLocaleSettings = {
          LC_ADDRESS = defaultLocale;
          LC_IDENTIFICATION = defaultLocale;
          LC_MEASUREMENT = defaultLocale;
          LC_MONETARY = defaultLocale;
          LC_NAME = defaultLocale;
          LC_NUMERIC = defaultLocale;
          LC_PAPER = defaultLocale;
          LC_TELEPHONE = defaultLocale;
          LC_TIME = defaultLocale;
        };
      };

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      # Configure keymap
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    users.users.nick = {
      isNormalUser = true;
      description = "Nick";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = builtins.attrValues { inherit (pkgs) wl-clipboard; };
    };
    home-manager.users.nick.imports = [ inputs.self.homeModules.default ];

    environment.systemPackages = builtins.attrValues { inherit (pkgs) git; };
  };
  flake.nixosConfigurations.strix = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.self.modules.nixos.default
      {
        system.stateVersion = "25.11";
        networking.hostName = "strix";
        home-manager.users.nick.home.stateVersion = "26.05";
      }
      # hardware-configuration.nix
      (
        {
          config,
          lib,
          modulesPath,
          ...
        }:

        {
          imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

          boot.initrd.availableKernelModules = [
            "xhci_pci"
            "ahci"
            "nvme"
            "usb_storage"
            "sd_mod"
            "rtsx_pci_sdmmc"
          ];
          boot.initrd.kernelModules = [ ];
          boot.kernelModules = [ "kvm-intel" ];
          boot.extraModulePackages = [ ];

          fileSystems."/" = {
            device = "/dev/disk/by-uuid/9f96771e-8754-4018-af43-5ef3b94ff2b6";
            fsType = "ext4";
          };

          fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/8B44-1D09";
            fsType = "vfat";
            options = [
              "fmask=0077"
              "dmask=0077"
            ];
          };

          swapDevices = [ { device = "/dev/disk/by-uuid/c59adc5d-705d-421d-bcbc-445730b527c5"; } ];
          nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
          hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        }
      )
    ];
  };
}
