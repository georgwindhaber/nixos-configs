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
    wantedBy = [ "multi-user.target" ];
    serviceconfig = {
      ExecStart = "${pkgs.nodejs}/bin/node /home/georg/source/webhook-runner/dist/index.js";
      Restart = "always";
      WorkingDirectory = "/home/georg/source/webhook-runner";
      Environment = "NODE_ENV=production";
    };
  };
  systemd.services.repinn-backend = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    serviceconfig = {
      ExecStart = "${pkgs.nodejs}/bin/node /home/georg/source/repinn/dist/src/index.js";
      Restart = "always";
      WorkingDirectory = "/home/georg/source/repinn/backend";
      Environment = "NODE_ENV=production";
    };
  };
}
