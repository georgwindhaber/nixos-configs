{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # ./sops.nix
    # ./mailserver.nix
    ./nginx.nix
    ./raid5.nix
    ./jellyfin.nix
    ./factorio/factorio.nix
    ./minecraft/minecraft.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true; # Enable networking
  networking.hostName = "metal-server"; # Define your hostname.
  networking.firewall = {
    allowedTCPPorts = [
      80
      443
      3000
    ];
    allowedUDPPorts = [
      34197
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "us";
  };

  # Configure console keymap
  console.keyMap = "de";

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.georg = {
    isNormalUser = true;
    description = "georg";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "samba"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Install Docker
  virtualisation.docker.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  ### PACKAGES ###
  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    pnpm
    git
    vscode
    nodejs_24
    mdadm
    wireguard-tools
    nixfmt-rfc-style
    factorio-headless
    vlc
    transmission_4-gtk
    mullvad-vpn
    pm2

    # Sensors for temp loggin
    lm-sensors
    hddtemp
    nvme-cli
  ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "georg" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "shisharia" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser                  auth-method
      local all       all                     trust

      # Over IP
      host  all       all     all             trust
      host  all       all     ::1/128         trust
    '';
    enableTCPIP = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # Tunnel to the stammtisch.wien domain / christophs' server
  systemd.network.enable = true;
  systemd.network = {
    networks."40-wg-stammtisch" = {
      matchConfig.Name = "wg-stammtisch";
      address = [
        "192.168.100.1/31"
        "fd00:f00d::1/127"
      ];
    };
    netdevs."40-wg-stammtisch" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-stammtisch";
        MTUBytes = "1420";
      };
      wireguardConfig = {
        PrivateKeyFile = "/etc/wireguard/priv.key";
      };
      wireguardPeers = [
        {
          PublicKey = "morTd9Yblt6BO1nn9cefvGYbFW6f3kbZhBNV78WhpEA=";
          PresharedKeyFile = "/etc/wireguard/preshared.key";
          Endpoint = "frog.stammtisch.wien:51830";
          AllowedIPs = [
            "192.168.100.0/31"
            "fd00:f00d::/127"
          ];
          PersistentKeepalive = 10;
        }
      ];
    };
  };
}
