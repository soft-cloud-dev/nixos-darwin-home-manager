{ config, lib, pkgs, ... }:

let
  cfg = config.services.adguardhome;
in
{
  options.services.adguardhome = {
    enable = lib.mkEnableOption "AdGuard Home";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.adguardhome ];
  };
}
