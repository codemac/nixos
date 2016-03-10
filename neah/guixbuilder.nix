{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.services.guixdaemon;
  coreutils = pkgs.coreutils;
  stdenv = pkgs.stdenv;
  nix = pkgs.nix;
in {
  options = {
    services.guixdaemon = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "
          Enable the guix daemon.
        ";
      };

      storeDir = mkOption {
        default = "/gnu/store";
        description = "
          Store for guix to use.
        ";
      };

      stateDir = mkOption {
        default = "/var/guix";
	description = "
          Directory holding some state for guix
        ";
      };

      builderUserPrefix = mkOption {
        type = types.str;
	default = "guixbuilder";
	description = "Prefix of builder user name";
      };
      
      builderGroup = mkOption {
        type = types.str;
        default = "guixbuild";
        description = "Group account under which guix daemon runs.";
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.guixdaemon = {
      description = "Build daemon for GNU Guix";
      wantedBy = [ "multi-user.target" ];
      preStart =
        ''
          ${coreutils}/bin/mkdir -p ${cfg.storeDir}
          ${coreutils}/bin/chmod 775 ${cfg.storeDir}
          ${coreutils}/bin/chmod +t ${cfg.storeDir}
          chown root:${cfg.builderGroup} ${cfg.storeDir}
	  
          ${coreutils}/bin/mkdir -p ${cfg.stateDir}
	  ${coreutils}/bin/chmod 775 ${cfg.stateDir}
          test -d /etc/guix || ${coreutils}/bin/ln -s /etc/nix /etc/guix
        '';
      serviceConfig = {
        ExecStart = "/root/.guix-profile/bin/guix-daemon --build-users-group=${cfg.builderGroup}";
	RemainAfterExit = "yes";
	StandardOutput = "syslog";
	StandardError = "syslog";
      };
    };

    users.extraUsers = {
      "${cfg.builderUserPrefix}1" = {
        uid = 20001;
        group = cfg.builderGroup;
      };
      "${cfg.builderUserPrefix}2" = {
        uid = 20002;
        group = cfg.builderGroup;
      };
      "${cfg.builderUserPrefix}3" = {
        uid = 20003;
        group = cfg.builderGroup;
      };
      "${cfg.builderUserPrefix}4" = {
        uid = 20004;
        group = cfg.builderGroup;
      };
      "${cfg.builderUserPrefix}5" = {
        uid = 20005;
        group = cfg.builderGroup;
      };
      "${cfg.builderUserPrefix}6" = {
        uid = 20006;
        group = cfg.builderGroup;
      };
      "${cfg.builderUserPrefix}7" = {
        uid = 20007;
        group = cfg.builderGroup;
      };
      "${cfg.builderUserPrefix}8" = {
        uid = 20008;
        group = cfg.builderGroup;
      };
      "${cfg.builderUserPrefix}9" = {
        uid = 20009;
        group = cfg.builderGroup;
      };
      "${cfg.builderUserPrefix}10" = {
        uid = 20010;
        group = cfg.builderGroup;
      };

      };

    users.extraGroups = {
      "${cfg.builderGroup}" = {
        members = [
          "${cfg.builderUserPrefix}1"
          "${cfg.builderUserPrefix}2"
          "${cfg.builderUserPrefix}3"
          "${cfg.builderUserPrefix}4"
          "${cfg.builderUserPrefix}5"
          "${cfg.builderUserPrefix}6"
          "${cfg.builderUserPrefix}7"
          "${cfg.builderUserPrefix}8"
          "${cfg.builderUserPrefix}9"
          "${cfg.builderUserPrefix}10"
	];
      };
    };
  };
}
