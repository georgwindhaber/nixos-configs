{ config, pkgs, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [
      3004
    ];
  };
  systemd.services.wiki-js = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };
  services.wiki-js = {
    enable = true;
    settings = {
      port = 3004;
      db = {
        db = "wiki-js";
        host = "/run/postgresql";
        type = "postgres";
        user = "wiki-js";
      };
    };
  };
}
