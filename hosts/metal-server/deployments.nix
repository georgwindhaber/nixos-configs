{ config, pkgs, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [
      # schoubl.com
      3000
      3001
      3002
      3005
      9000
      # hypa.digital
      4001
    ];
  };

  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        action.id == "org.freedesktop.systemd1.manage-units" &&
        (action.lookup("unit") == "repinn-backend.service" || action.lookup("unit") == "repinn-backend-dev.service" || action.lookup("unit") == "sound-control-backend.service") &&
        subject.user == "georg"
      ) {
        return polkit.Result.YES;
      }
    });
  '';

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

  systemd.services.repinn-backend-dev = {
    enable = true;
    description = "Repinn Dev backend";
    unitConfig = {
    };
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs_24}/bin/node /home/georg/source/repinn-dev/backend/dist/src/index.js";
      Type = "simple";
      Restart = "always";
      RestartSec = "10";
      StandardOutput = "journal";
      StandardError = "journal";
      User = "georg";
      Group = "users";
      WorkingDirectory = "/home/georg/source/repinn-dev/backend";
      Environment = [
        "PORT=3002"
      ];
    };
  };

  systemd.services.flo-gadse-backend = {
    enable = true;
    description = "Flo birthday gadse backend";
    unitConfig = {
    };
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs_24}/bin/node /home/georg/source/flo-birthday-gadse/backend/dist/index.js";
      Type = "simple";
      Restart = "always";
      RestartSec = "10";
      StandardOutput = "journal";
      StandardError = "journal";
      User = "georg";
      Group = "users";
      WorkingDirectory = "/home/georg/source/flo-birthday-gadse/backend";
      Environment = [
        "PORT=3005"
      ];
    };
  };

  systemd.services.sound-control-backend = {
    enable = true;
    description = "Sound Control by hypa.digital backend";
    unitConfig = {
    };
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs_24}/bin/node /home/georg/source/sound-control/backend/dist/index.js";
      Type = "simple";
      Restart = "always";
      RestartSec = "10";
      StandardOutput = "journal";
      StandardError = "journal";
      User = "georg";
      Group = "users";
      WorkingDirectory = "/home/georg/source/sound-control/backend";
      Environment = [
        "PORT=4001"
      ];
    };
  };

}
