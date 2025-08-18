{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    ./base.nix
    "${modulesPath}/virtualisation/amazon-image.nix"
  ];

  # AWS-specific configuration
  image.baseName = "nixos-cloud-image";
  virtualisation.diskSize = 8192; # 8GB

  # AWS CLI tools
  environment.systemPackages = with pkgs; [
    awscli2
    amazon-ec2-utils
  ];

  # Note: The amazon-image.nix module provides:
  # - Boot configuration with serial console
  # - Kernel modules (ena, nvme, xen-blkfront)
  # - Amazon SSM agent
  # - EC2 metadata service (amazon-init)
  # - Dynamic hostname from DHCP
  # - SSH key management
  # - Root filesystem auto-resize

  # Only add AWS-specific overrides if needed
  # The module handles most AWS requirements automatically
}