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
      ExecStart = "${pkgs.pm2}/bin/pm2 resurrect";
      ExecReload = "${pkgs.pm2}/bin/pm2 reload all";
      ExecStop = "${pkgs.pm2}/bin/pm2 kill";
    };
  };

  systemd.services.repinn-backend = {
    enable = true;
    description = "Repinn backend";
    unitConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "10";
    };
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs_24}/bin/node /home/georg/projects/repinn/backend/dist/src/index.js";
      WorkingDirectory = "/home/georg/projects/repinn/backend";
      User = "georg";
      Group = "users";
      # Uncomment if you need environment variables
      # Environment = [
      #   "NODE_ENV=production"
      #   "PORT=3000"
      # ];
    };
  };
}
