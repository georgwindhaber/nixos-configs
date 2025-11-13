{ config, pkgs, ... }:

let
  tempLoggerScript = pkgs.writeShellScript "temp-logger" ''
    #!/usr/bin/env bash

    LOG_FILE="/var/log/hardware-temps.log"
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    # CPU Temperature
    CPU_TEMP=$(${pkgs.lm_sensors}/bin/sensors | grep -E "Core 0|Tctl|Package id 0" | head -n1 | awk '{print $3}' | tr -d '+°C')

    # GPU Temperature (NVIDIA)
    if command -v nvidia-smi &> /dev/null; then
      GPU_TEMP=$(${pkgs.linuxPackages.nvidia_x11}/bin/nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo "N/A")
    # GPU Temperature (AMD)
    elif ${pkgs.lm_sensors}/bin/sensors | grep -q "amdgpu"; then
      GPU_TEMP=$(${pkgs.lm_sensors}/bin/sensors | grep "edge" | awk '{print $2}' | tr -d '+°C' || echo "N/A")
    else
      GPU_TEMP="N/A"
    fi

    # HDD Temperature
    HDD_TEMP=$(${pkgs.smartmontools}/bin/smartctl -A /dev/sda 2>/dev/null | grep Temperature_Celsius | awk '{print $10}' || echo "N/A")

    # Log the temperatures
    echo "$TIMESTAMP | CPU: $CPU_TEMP°C | GPU: $GPU_TEMP°C | HDD: $HDD_TEMP°C" >> "$LOG_FILE"
  '';
in
{
  # Install required packages
  environment.systemPackages = with pkgs; [
    lm_sensors
    smartmontools
  ];

  # Create the systemd service
  systemd.services.temp-logger = {
    description = "Hardware Temperature Logger";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${tempLoggerScript}";
      User = "root";
    };
  };

  # Create the systemd timer (runs every minute)
  systemd.timers.temp-logger = {
    description = "Run temperature logger every minute";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "1min";
      Unit = "temp-logger.service";
    };
  };

  # Ensure log directory exists with proper permissions
  systemd.tmpfiles.rules = [
    "f /var/log/hardware-temps.log 0644 root root -"
  ];
}
