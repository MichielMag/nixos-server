{
  inputs,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./home-automation/hass
  ];
}
