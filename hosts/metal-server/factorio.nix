{
  pkgs,
  ...
}:
{

  factorio.override = {
    versionsJson = ./factorio-versions.json;
  };

  services.factorio = {
    enable = true;
    openFirewall = true;
    loadLatestSave = true;
    lan = true;
    saveName = "testserver";
    description = "Local testserver";
    extraSettingsFile = "/home/georg/factorio/server-settings.json";
  };
}
