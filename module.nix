
       { config, lib, pkgs, ... }:
        let
          # Reference the installed service wrapper.
	netextenderPath = "${pkgs.netextender}/usr/local/netextender";
        in {
          options.netextender = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable the SonicWall NetExtender VPN service.";
            };
          };

          config = lib.mkIf config.netextender.enable {
            systemd.services.neservice = {
              description = "SonicWall NetExtender Service";
              after = [ "network.target" ];
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                ExecStart = "${netextenderPath}/NEService";
               WorkingDirectory = "/var/sonicwall/NetExtender";
                Environment = "NETEXTENDER_PROFILE_DIR=/var/sonicwall/NetExtender";
              };
              preStart = ''
                mkdir -p /var/sonicwall/NetExtender
		
              '';
            };
          };
        }
      
