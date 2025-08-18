{ config, pkgs, lib, ... }:

{
  # Base configuration for all cloud images
  system.stateVersion = "25.05";

  # Basic packages
  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    tmux
    curl
    wget
    jq
  ];

  # Network configuration
  networking = {
    useDHCP = lib.mkDefault true;
    # Firewall is configured differently per cloud provider:
    # - AWS: Uses Security Groups
    # - Azure: Uses Network Security Groups
    # - GCP: Uses VPC firewall rules
  };

  # Time zone
  time.timeZone = "UTC";

  # Locale settings
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable nix flakes
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
      build-use-sandbox = true
    '';
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # ===== Security Hardening =====
  
  # Kernel hardening
  boot.kernel.sysctl = {
    # Network security
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    
    # Kernel security
    "kernel.randomize_va_space" = 2;
    "kernel.sysrq" = 0;
    "kernel.core_uses_pid" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.yama.ptrace_scope" = 1;
    "kernel.dmesg_restrict" = 1;
    
    # File system hardening
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "fs.suid_dumpable" = 0;
  };
  
  # SSH hardening - only apply basic security settings
  # Cloud providers have their own SSH configurations
  services.openssh = {
    enable = true;
    # Only set the most critical security options
    settings = {
      PasswordAuthentication = lib.mkDefault false;
      PermitRootLogin = lib.mkDefault "prohibit-password";
    };
  };
  
  # Enable automatic security updates
  system.autoUpgrade = {
    enable = lib.mkDefault true;
    allowReboot = false;  # Cloud provider should handle reboots
    dates = "04:00";
    randomizedDelaySec = "45min";
  };
}