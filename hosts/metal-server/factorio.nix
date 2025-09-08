{
  pkgs,
  ...
}:
{
  services.factorio = {
    enable = true;
    openFirewall = true;
    package = pkgs.factorio-headless.override {
      versionsJson =
        let
          nixpkgsCommit = "master";
          versions = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/${nixpkgsCommit}/pkgs/by-name/fa/factorio/versions.json";
            sha256 = "sha256-6EBb4JfcCQ/iE+PVRKxAbPkqMDvBM12rK8sHgg6zSQ4=";
          };
        in
        "${versions}";
    };
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
