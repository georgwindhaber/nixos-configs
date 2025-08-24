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

  services.samba = {
    enable = true;
    openFirewall = true;
    shares = {
      raidshare = {
        path = "/mnt/raid5";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
      };
    };
  };
}
