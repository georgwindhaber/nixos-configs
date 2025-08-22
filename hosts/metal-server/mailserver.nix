{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (builtins.fetchTarball {
      # Mailserver from gitlab
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-25.05/nixos-mailserver-nixos-25.05.tar.gz";
      sha256 = "1 qn5fg0h62r82q7xw54ib9wcpflakix2db2mahbicx540562la1y";
    })
  ];

  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = "mail.schoubl.com";
    domains = [ "schoubl.com" ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "me@schoubl.com" = {
        hashedPasswordFile = "/etc/mailserver/me.key";
        aliases = [ "postmaster@schoubl.com" ];
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@schoubl.com";
}
