{ config, pkgs, ... }:

{
  # Install required packages
  environment.systemPackages = with pkgs; [
    lm_sensors
    smartmontools
  ];

  # Enable cron service
  services.cron = {
    enable = true;
    systemCronJobs = [
      ''* * * * * root /run/current-system/sw/bin/bash /root/temp-logger.sh''
    ];
  };

  # Create the temperature logging script
  environment.etc."temp-logger.sh" = {
    text = ''
      #!/usr/bin/env bash

      LOG_FILE="/var/log/hardware-temps.log"
      TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

      # CPU Temperature (Intel)
      CPU_TEMP="N/A"
      if [ -d /sys/class/thermal/thermal_zone0 ]; then
        temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
        CPU_TEMP=$((temp / 1000))
      fi

      # GPU Temperature (NVIDIA)
      GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo "N/A")

      # HDD Temperatures (3 drives)
      HDD1_TEMP=$(smartctl -A /dev/sda 2>/dev/null | grep "Temperature_Celsius" | awk '{print $10}' || echo "N/A")
      HDD2_TEMP=$(smartctl -A /dev/sdb 2>/dev/null | grep "Temperature_Celsius" | awk '{print $10}' || echo "N/A")
      HDD3_TEMP=$(smartctl -A /dev/sdc 2>/dev/null | grep "Temperature_Celsius" | awk '{print $10}' || echo "N/A")

      # Log the temperatures
      echo "$TIMESTAMP | CPU: $CPU_TEMP°C | GPU: $GPU_TEMP°C | HDD1: $HDD1_TEMP°C | HDD2: $HDD2_TEMP°C | HDD3: $HDD3_TEMP°C" >> "$LOG_FILE"
    '';
    mode = "0755";
    target = "../root/temp-logger.sh";
  };

  # Ensure log file exists with proper permissions
  systemd.tmpfiles.rules = [
    "f /var/log/hardware-temps.log 0644 root root -"
  ];
}
