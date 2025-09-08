{ config, pkgs, ... }:

{
  boot.swraid = {
    enable = true;
    mdadmConf = ''
      ARRAY /dev/md0 metadata=1.2 spares=1 UUID=3fe3f0a5:a97cac5b:f3ddce55:0f56c628
      MAILADDR georg.windhaber@gmail.com
    '';
  };

  fileSystems."/mnt/raid5" = {
    device = "/dev/md0";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  systemd.tmpfiles.rules = [
    # Create samba directories
    "d /srv/samba 0755 root root -"
    "d /srv/samba/georg 0700 georg georg -"

    # Create log directory
    "d /var/log/samba 0755 root root -"
  ];

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP"; # for Windows...
        "server string" = "RAID5 NAS Samba";
        "netbios name" = "nixos-nas";
        "security" = "user";
        "map to guest" = "bad user";
        "guest account" = "nobody";
        "log file" = "/var/log/samba/log.%m";
        "max log size" = "1000";
        "logging" = "file";
      };

      raidshare = {
        path = "/mnt/raid5";
        "browseable" = "yes";
        "writable" = "yes";
        "guest ok" = "no";
        "valid users" = "georg";
        "create mask" = "0600";
        "directory mask" = "0700";
        "comment" = "The full raid5 mount";
      };
    };
  };
}
