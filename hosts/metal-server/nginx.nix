{ config, lib, pkgs, modulesPath, ... }:

{
  services.nginx = {
    enable = true;

    appendConfig = ''
      map $http_upgrade $connection_upgrade {
        default upgrade;
        \'\' close;
      }
    '';

    virtualHosts."private.schoubl.com" = {
      forceSSL = true;
      enableACME = true;
      http2 = true;

      extraConfig = ''
        proxy_buffering off;
        proxy_request_buffering off;

        client_max_body_size 0;
        client_body_buffer_size 512k;
        proxy_read_timeout 86400s;

        ssl_dhparam /etc/dhparam;
        ssl_early_data on;
        ssl_session_timeout 1d;
        ssl_session_cache shared:SSL:10m;

        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ecdh_curve x25519:x448:secp521r1:secp384r1:secp256r1;

        ssl_prefer_server_ciphers on;
        ssl_conf_command Options PrioritizeChaCha;
        ssl_ciphers TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES128-GCM-SHA256;
      '';

      locations."/" = {
        proxyPass = "http://127.0.0.1:11000";
        extraConfig = ''
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Port $server_port;
          proxy_set_header X-Forwarded-Scheme $scheme;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header Host $host;
          proxy_set_header Early-Data $ssl_early_data;

          # Websocket
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;
        '';
      };
    };

  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "georg.windhaber@gmail.com";
  };
}