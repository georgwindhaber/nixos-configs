{
  pkgs,
  ...
}:
{
  services.minecaft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
  };
}
