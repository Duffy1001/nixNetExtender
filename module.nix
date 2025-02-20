{ config, lib, pkgs, ... }:
{
  # (1) Provide pkgs to the module if it references pkgs anywhere
  _module.args.pkgs = pkgs;

  # (2) Define your option at the top-level
  options.netextender.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the SonicWall NetExtender VPN service.";
  };

  # (3) Use lib.mkIf to conditionally define your service
  config = lib.mkIf config.netextender.enable {
    systemd.services.neservice = {
      description = "SonicWall NetExtender Service";
      after       = [ "network.target" ];
      wantedBy    = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart       = "${pkgs.netextender}/usr/local/netextender/NEService";
        WorkingDirectory = "/var/sonicwall/NetExtender";
        Environment     = "NETEXTENDER_PROFILE_DIR=/var/sonicwall/NetExtender";
      };

      preStart = ''
        mkdir -p /var/sonicwall/NetExtender
      '';
    };
  };
}

