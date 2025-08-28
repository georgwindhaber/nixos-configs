{ config, pkgs, ... }:

{

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
    ROC_ENABLE_PRE_VEGA = "1";
  };

  environment.systemPackages = with pkgs; [
    davinci-resolve
    amdvlk
    clinfo
    mesa-demos
    kitty
    libva
    libvdpau-va-gl
    mesa
    mesa.opencl
    vulkan-loader
    vulkan-tools
    vulkan-validation-layers
  ];

  services.dbus.enable = true;
  programs.hyprland.enable = true;
}
