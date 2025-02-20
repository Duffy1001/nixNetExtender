{ config, lib, pkgs, ... }:

let
  # We can define local variables here, referencing pkgs if needed:
  netextenderPath = "${pkgs.netextender}/usr/local/netextender";
in
{
  # (1) Only "options" and "config" at the top level; no `_module`
  options  = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the SonicWall NetExtender VPN service.";
    };
  };

  config = lib.mkIf config.enable {
    systemd.services.neservice = {
      description = "SonicWall NetExtender Service";
      after       = [ "network.target" ];
      wantedBy    = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart       = "${netextenderPath}/NEService";
        WorkingDirectory = "/var/sonicwall/NetExtender";
        Environment     = "NETEXTENDER_PROFILE_DIR=/var/sonicwall/NetExtender";
      };
      preStart = ''
        mkdir -p /var/sonicwall/NetExtender
      '';
    };
  };
}

