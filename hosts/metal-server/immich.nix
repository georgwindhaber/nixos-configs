{ config, pkgs, ... }:

{
	services.immich = {
		enable = true;
		port = 2283;
		openFirewall = true;
		mediaLocation = "/mnt/raid5/immich";
	}
}
