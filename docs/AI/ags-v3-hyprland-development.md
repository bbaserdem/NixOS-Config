# AGS v3 Development with Hyprland on NixOS

## Overview

This document covers the setup and development workflow for AGS v3
(Aylur's GTK Shell) as a visual shell for Hyprland on NixOS.

## Configuration

### Flake Inputs

The flake includes both `astal` and `ags` inputs with proper dependency management:

```nix
astal = {
  url = "github:aylur/astal";
  inputs.nixpkgs.follows = "nixpkgs";
};
ags = {
  url = "github:aylur/ags";
  inputs.nixpkgs.follows = "nixpkgs";
  inputs.astal.follows = "astal";
};
```

### Home Manager Integration

AGS is configured through home-manager with the following features:
- Home manager module for declarative configuration
- Astal libraries for various system integrations
- Development tools and runtime dependencies
- Null configDir for development flexibility

**Location**: `home-manager/batuhan/desktop/hyprland/ags.nix`

## Development Workflow

### 1. Enter Development Environment

```bash
nix develop .#ags
```

This provides:
- AGS v3 with full Astal library support
- TypeScript and Node.js tooling
- GTK4/Libadwaita runtime dependencies
- System utilities (brightnessctl, playerctl, etc.)

### 2. Initialize AGS Project

```bash
# Create config directory
mkdir ~/.config/ags && cd ~/.config/ags

# Initialize with template (if available)
nix flake init --template github:aylur/ags

# Or manually create app.ts
ags init
```

### 3. Development Commands

```bash
# Run AGS with current config
ags run

# Bundle application
ags bundle app.ts output-name

# Show help
ags --help
```

### 4. Available Astal Libraries

The configuration includes these Astal packages:
- `battery` - Battery status monitoring
- `bluetooth` - Bluetooth device management
- `hyprland` - Hyprland window manager integration
- `network` - Network connectivity status
- `notifd` - Notification daemon
- `powerprofiles` - Power profile management
- `wireplumber` - Audio control

### 5. Production Deployment

For production use, you can either:

**Option A**: Use home-manager module (current setup)
- Set `configDir` to your config path in `ags.nix`
- Rebuild home-manager configuration

**Option B**: Build standalone derivation
- Create a flake.nix in your AGS project
- Use `ags bundle` command in a derivation
- Install as a package

## Integration with Hyprland

AGS integrates with Hyprland through:
- The `astal.hyprland` library for window management
- Wayland protocols for shell functionality
- GTK4 layer shell for overlay widgets

## File Structure

```
nixos/features/hyprland.nix          # System-level Hyprland config
home-manager/batuhan/desktop/
├── hyprland/
│   ├── default.nix                  # Hyprland entry point
│   └── ags.nix                      # AGS configuration
shells/ags.nix                       # Development shell
```

## Notes

- `configDir = null` allows manual config management for development
- The home-manager module automatically manages the AGS service
- Use `nix develop .#ags` for active development
- Production configs should set a proper `configDir` path