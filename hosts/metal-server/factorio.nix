{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
 services.factorio = {
  enable = true;
  loadLatestSave = true;
  lan = true;
  saveName = "testserver";
  description = "Local testserver";
  extraSettingsFile = "/home/georg/factorio/server-settings.json";
 } 
}