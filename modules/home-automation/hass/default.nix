{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.hass;

in
{
  options.modules.hass = {
    enable = mkEnableOption "hass";
  };
  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /opt/hass 0770 michiel michiel"
    ];
    virtualisation.oci-containers.containers.hass = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      volumes = [ "home-assistant:/opt/hass" ];
      environment = {
        TZ = "Europe/Amsterdam";
      };
      autoStart = true;
      ports = [ "127.0.0.1:8001:8123" ];
      extraOptions = [
        "--network=host"
        "--restart=unless-stopped"
      ];
    };
  };
}
