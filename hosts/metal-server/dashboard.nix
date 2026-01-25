{ config, pkgs, ... }:

{
  # Enable firewall (optional but recommended)
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      4000  # Grafana
    ];
  };

  # 1. Node Exporter Configuration
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    
    # Enable specific collectors (comment out what you don't need)
    enabledCollectors = [
      # System metrics
      "cpu"
      "cpufreq"
      "diskstats"
      "filesystem"
      "loadavg"
      "meminfo"
      "netdev"
      "netstat"
      "stat"
      "time"
      "vmstat"
      
      # Hardware
      "hwmon"  # Hardware monitoring (temperatures, fans)
      
      # Systemd services
      "systemd"
      
      # Additional useful collectors
      "processes"
      "interrupts"
      "nfs"
      "zfs"  # If using ZFS
      "logind"
      "tcpstat"
    ];
    
    # Disable default collectors we don't need
    disabledCollectors = [
      "bonding"
      "infiniband"  # Unless you have InfiniBand
    ];
    
    # Extra settings
    openFirewall = true;
    
    # Include extra metrics
    extraFlags = [
      "--collector.textfile.directory=/var/lib/node-exporter-text-files"
    ];
  };

  # 2. Prometheus Configuration
  services.prometheus = {
    enable = true;
    port = 9090;
    
    # Global scrape interval
    scrapeConfigs = [
      {
        job_name = "node";
        scrape_interval = "15s";  # How often to collect metrics
        static_configs = [{
          targets = [ "localhost:9100" ];
          labels = {
            instance = config.networking.hostName;
            job = "node_exporter";
          };
        }];
      }
      
      # Add more jobs here for other services
      {
        job_name = "prometheus";
        static_configs = [{
          targets = [ "localhost:9090" ];
        }];
      }
    ];
    
    # Retention settings
    retentionTime = "30d";  # Keep data for 30 days
    
    # Alerting rules (optional)
    rules = [];
    
    # Extra settings
    enableReload = true;  # Allow reloading config without restart
    webExternalUrl = "http://localhost:9090";
    
    # Listen on all interfaces (optional)
    listenAddress = "0.0.0.0";
  };

  # 3. Grafana Configuration
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 4000;
        http_addr = "0.0.0.0";  # Listen on all interfaces
        domain = "localhost";
        root_url = "http://localhost:4000";
      };
      
      # Security
      security = {
        admin_password = "initial_password";  # Change this!
        secret_key = "your-secret-key-here";  # Generate with: openssl rand -base64 42
      };
      
      # Database (embedded SQLite by default)
      database = {
        type = "sqlite3";
        path = "/var/lib/grafana/grafana.db";
      };
      
      # Authentication (optional)
      "auth.anonymous" = {
        enabled = true;
        org_name = "Main Org.";
        org_role = "Viewer";
      };
    };
    
    # Provision dashboard automatically
    provision = {
      enable = true;
      datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://localhost:9090";
          isDefault = true;
          access = "proxy";
        }
      ];
      
      # Auto-import dashboards
      dashboards = [
        {
          name = "Node Exporter Full";
          options.path = ./dashboards/node-exporter-full.json;
        }
      ];
    };
    
    # Data persistence
    dataDir = "/var/lib/grafana";
  };

  # 4. Optional: Add monitoring for specific services
  services.prometheus.exporters = {
    # Nginx metrics (if you have nginx)
    nginx = {
      enable = config.services.nginx.enable;
      port = 9113;
    };
    
    # Postgres metrics (if you have postgresql)
    postgres = {
      enable = config.services.postgresql.enable;
      port = 9187;
    };
    
    # Process exporter (monitor specific processes)
    process = {
      enable = true;
      port = 9256;
      settings.process_names = [
        # Customize process names you want to monitor
        "grafana-server"
        "prometheus"
        "nginx"
        "postgres"
      ];
    };
  };

  # 5. Systemd monitoring (shows service states)
  systemd.services.node-exporter.serviceConfig = {
    # Add these if you want to monitor systemd units
    SupplementaryGroups = [ "systemd-journal" ];
  };
  
  # Create directory for custom textfile metrics
  systemd.tmpfiles.rules = [
    "d /var/lib/node-exporter-text-files 0755 prometheus prometheus - -"
  ];
}