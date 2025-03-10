{
  inputs,
  pkgs,
  stable,
  config,
  ...
}:

{
  imports = [ ../../modules/default.nix ];

  modules = {

  };

  networking = {
    interfaces.enp2s0f0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.254";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp2s0f0";
    };
    interfaces.wlp3s0.useDHCP = true;
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
    ];
    # Adding a section for firewall rules as the next step
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
      ];
      allowedUDPPorts = [ 53 ];
    };
  };
}
