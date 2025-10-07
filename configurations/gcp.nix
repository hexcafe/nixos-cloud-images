{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    ./base.nix
    "${modulesPath}/virtualisation/google-compute-image.nix"
  ];

  # GCP-specific configuration
  virtualisation.diskSize = 8192; # 8GB
  virtualisation.googleComputeImage.compressionLevel = 9;

  # GCP CLI tools
  environment.systemPackages = with pkgs; [
    google-cloud-sdk
  ];

  # Note: The google-compute-image.nix module provides:
  # - Google Guest Agent (replaces cloud-init)
  # - OS Login integration
  # - Serial console configuration
  # - Network MTU 1460 and metadata hostname
  # - SSH key management via metadata
  # - Startup/shutdown script support
  # - Root filesystem auto-resize

  # Only add GCP-specific overrides if needed
  # The module handles most GCP requirements automatically
}
