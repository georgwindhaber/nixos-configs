{
  pkgs,
  ...
}:
{

  services.factorio = {
    enable = true;
    openFirewall = true;
    loadLatestSave = true;
    lan = true;
    saveName = "testserver";
    description = "The Stammtisch Must Grow";
    extraSettings = {
      max_players = 16;
    };
    extraSettingsFile = ./server-settings.json;
  };
}
