{ config, pkgs, lib, ... }:

let
  squidCacheDir = "${config.home.homeDirectory}/.squid/cache";
  squidLogDir = "${config.home.homeDirectory}/.squid/logs";
  isSquidSupported = !(pkgs.stdenv.isDarwin && pkgs.stdenv.isAarch64);
in
{
  config = lib.mkIf isSquidSupported {
    home.packages = [ pkgs.squid ];

    home.file.".squid/squid.conf".text = ''
      visible_hostname ${config.networking.hostName}

      http_port 3128
      cache_dir ufs ${squidCacheDir} 100 16 256
      coredump_dir ${squidCacheDir}
      cache_access_log ${squidLogDir}/access.log
      cache_log ${squidLogDir}/cache.log
      cache_store_log ${squidLogDir}/store.log

      acl localnet src 0.0.0.1-0.255.255.255
      acl localnet src 10.0.0.0/8
      acl localnet src 100.64.0.0/10
      acl localnet src 169.254.0.0/16
      acl localnet src 172.16.0.0/12
      acl localnet src 192.168.0.0/16
      acl localnet src fc00::/7
      acl localnet src fe80::/10

      acl SSL_ports port 443
      acl Safe_ports port 80 21 443 70 210 1025-65535 280 488 591 777

      http_access deny !Safe_ports
      http_access deny CONNECT !SSL_ports
      http_access allow localhost manager
      http_access deny manager
      http_access allow localnet
      http_access allow localhost
      http_access deny all

      cache_mem 256 MB

      refresh_pattern ^ftp:		1440	20%	10080
      refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
      refresh_pattern .		0	20%	4320
    '';

    home.activation = {
      createSquidDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p ${squidCacheDir}
        mkdir -p ${squidLogDir}
      '';
    };

    systemd.user.services.squid = lib.mkIf pkgs.stdenv.isLinux {
      Unit = {
        Description = "Squid caching proxy";
        After = [ "network.target" ];
      };
      Service = {
        ExecStart = "${pkgs.squid}/bin/squid -N -d 1 -f ${config.home.homeDirectory}/.squid/squid.conf";
        Restart = "always";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    programs.zsh.shellAliases = {
      start-squid = "squid -f ~/.squid/squid.conf";
    };
  };
}
