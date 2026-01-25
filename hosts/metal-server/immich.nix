{ config, pkgs, ... }:

{
	services.immich = {
		enable = true;
		port = 2283;
		host = "0.0.0.0";
		openFirewall = true;
		mediaLocation = "/mnt/raid5/immich";
		accelerationDevices = [ "/dev/dri/renderD128" ];
	};
}
