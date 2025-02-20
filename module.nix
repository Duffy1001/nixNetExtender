{ config, lib, pkgs, ... }:
{
  # Provide pkgs so this module can reference them
  _module.args.pkgs = pkgs;

  # Define your options on the top level
  options.netextender.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the SonicWall NetExtender VPN service.";
  };

  # Put local variables in a let, inside `config`
  config = let
    netextenderPath = "${pkgs.netextender}/usr/local/netextender";
  in
  lib.mkIf config.netextender.enable {
    systemd.services.neservice = {
      description  = "SonicWall NetExtender Service";
      after        = [ "network.target" ];
      wantedBy     = [ "multi-user.target" ];
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

