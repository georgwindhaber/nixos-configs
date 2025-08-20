{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  services.nginx = {
    enable = true;

    appendHttpConfig = ''
      map $http_upgrade $connection_upgrade {
        default upgrade;
        \'\' close;
      }
    '';

    virtualHosts."localhost" = {
      kTLS = true;

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:11000";
          proxyWebsockets = true;
          recommendedProxySettings = false;
          extraConfig = ''
            proxy_ssl_verify off;
            proxy_ssl_name private.schoubl.com;
            proxy_set_header Host private.schoubl.com;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Server $host;
            rewrite ^/\.well-known/carddav https://$server_name/remote.php/dav/ redirect;
            rewrite ^/\.well-known/caldav https://$server_name/remote.php/dav/ redirect;
          '';
        };
        "= /_maintenance" = {
          extraConfig = ''
            default_type text/plain;
          '';
          return = "200 'sorry from metal machine :('";
        };
      };
      extraConfig = ''
        error_page 502 /_maintenance;
        client_max_body_size 4096M;
        add_header X-Robots-Tag "noindex, nofollow" always;
      '';
    };
  };

  security.acme.acceptTerms = true;
  security.acme.certs."private.schoubl.com" = {
    dnsProvider = null;
    webroot = "/var/lib/acme/acme-challenge";
    email = "georg.windhaber@gmail.com";
    group = "nginx";
    reloadServices = [ "nginx.service" ];
  };

}
