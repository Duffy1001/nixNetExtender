{ config, lib, pkgs, ... }:
{
  # (1) `_module` is allowed, but must not conflict with how Nix interprets the rest
  _module.args.pkgs = pkgs;

  # (2) `options` is also at the top level—this is fine
  options.netextender.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the SonicWall NetExtender VPN service.";
  };

  # (3) `config` is a top-level attribute, but the contents go inside `lib.mkIf …`
  config = lib.mkIf config.netextender.enable {
    systemd.services.neservice = {
      description = "SonicWall NetExtender Service";
      after       = [ "network.target" ];
      wantedBy    = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart        = "${pkgs.netextender}/usr/local/netextender/NEService";
        WorkingDirectory = "/var/sonicwall/NetExtender";
        Environment      = "NETEXTENDER_PROFILE_DIR=/var/sonicwall/NetExtender";
      };

      preStart = ''
        mkdir -p /var/sonicwall/NetExtender
      '';
    };
  };
}

