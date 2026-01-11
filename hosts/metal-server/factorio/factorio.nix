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
    saveName = "maennerhoehle";
    description = "The Männerhöhle Must Grow";
    extraSettings = {
      max_players = 16;
    };
    extraSettingsFile = ./server-settings.json;
  };
}
