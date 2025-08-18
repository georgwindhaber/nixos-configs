{ config, lib, pkgs, modulesPath, ... }:

{
  services.nginx = {
    enable = true;
    virtualHosts."private.schoubl.com" = {
      # enableACME = true;
      # forceSSL = true;
      root = "/var/www/test";
      # default = true;
    };
  };
}