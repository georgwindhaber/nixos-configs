{ config, pkgs, ... }:

{
	networking.firewall = {
    allowedTCPPorts = [
      3003
    ];
	};
	systemd.services.wiki-js = {
		requires = [ "postgresql.service" ];
		after    = [ "postgresql.service" ];
	};
	services.wiki-js = {
		enable = true;
		settings = {
			port = 3003;
			db = {
				db  = "wiki-js";
				host = "/run/postgresql";
				type = "postgres";
				user = "wiki-js";
			};
		};
	};
}
