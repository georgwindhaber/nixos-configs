{
  pkgs,
  ...
}:
{
  servies.minecaft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
  };
}
