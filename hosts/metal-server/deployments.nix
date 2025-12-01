{ config, pkgs, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [
      3000
      3001
      9000
    ];
  };

  systemd.user.services.webhook-runner = {
    enable = true;
    description = "Webhook runner";
    unitConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "10";
    };
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs_24}/bin/node /home/georg/source/webhook-runner/dist/index.js";
      WorkingDirectory = "/home/georg/source/webhook-runner";
    };
  };

  systemd.user.services.repinn-backend = {
    enable = true;
    description = "Repinn backend";
    unitConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "10";
    };
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs_24}/bin/node /home/georg/source/repinn/backend/dist/src/index.js";
      WorkingDirectory = "/home/georg/source/repinn/backend";
      Environment = [
        "PORT=3001"
      ];
    };
  };


}
