{ config, pkgs, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [
      3000
      3001
      9000
    ];
  };

  systemd.services.pm2 = {
    enable = true;
    description = "pm2";
    unitConfig = {
      Type = "simple";
    };
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodePackages_latest.pm2}/bin/pm2 resurrect";
      ExecReload = "${pkgs.nodePackages_latest.pm2}/bin/pm2 reload all";
      ExecStop = "${pkgs.nodePackages_latest.pm2}/bin/pm2 kill";
    };
  };
}
