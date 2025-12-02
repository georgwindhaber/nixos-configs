{ config, pkgs, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [
      3000
      3001
      9000
    ];
  };

  systemd.services.webhook-runner = {
    enable = true;
    description = "Webhook runner";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs_24}/bin/node /home/georg/source/webhook-runner/dist/index.js";
      Type = "simple";
      Restart = "always";
      RestartSec = "10";
      WorkingDirectory = "/home/georg/source/webhook-runner";
      StandardOutput = "journal";
      StandardError = "journal";
      User = "georg";
      Group = "users";
    };
  };

  systemd.services.repinn-backend = {
    enable = true;
    description = "Repinn backend";
    unitConfig = {
    };
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs_24}/bin/node /home/georg/source/repinn/backend/dist/src/index.js";
      Type = "simple";
      Restart = "always";
      RestartSec = "10";
      StandardOutput = "journal";
      StandardError = "journal";
      User = "georg";
      Group = "users";
      WorkingDirectory = "/home/georg/source/repinn/backend";
      Environment = [
        "PORT=3001"
      ];
    };
  };

}
