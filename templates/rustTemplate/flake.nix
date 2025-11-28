{
  description = "Rust project template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      # Use Rust toolchain from nixpkgs
      rustToolchain = with pkgs; [
        rustc
        cargo
        rust-analyzer
        rustfmt
        clippy
      ];

      # Development tools
      devTools =
        rustToolchain
        ++ (with pkgs; [
          cargo-watch
          cargo-edit
          # For running AI and MCP
          uv
          nodejs-slim
          pnpm
          # Git tooling for semver workflow
          git-cliff
          commitlint
        ]);

      # Native build inputs
      nativeBuildInputs = with pkgs; [
        pkg-config
      ];

      # Build inputs for linking
      buildInputs = with pkgs;
        [
          openssl
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          pkgs.darwin.apple_sdk.frameworks.Security
          pkgs.darwin.apple_sdk.frameworks.SystemConfiguration
        ];
    in {
      devShells.default = pkgs.mkShell {
        inherit buildInputs nativeBuildInputs;
        packages = devTools;

        shellHook = "";

        # Environment variables
        RUST_BACKTRACE = "1";
      };

      # Default package is the Rust project
      packages.default = pkgs.rustPlatform.buildRustPackage {
        pname = "rust-template";
        version = "0.1.0";
        src = ./.;
        cargoLock.lockFile = ./Cargo.lock;
        inherit nativeBuildInputs buildInputs;
      };

      # Development apps
      apps = {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/rust-template";
        };

        dev = {
          type = "app";
          program = "${pkgs.writeShellScript "dev" ''
            cargo watch -x "run"
          ''}";
        };

        test = {
          type = "app";
          program = "${pkgs.writeShellScript "test" ''
            cargo test
          ''}";
        };

        check = {
          type = "app";
          program = "${pkgs.writeShellScript "check" ''
            cargo check
          ''}";
        };
      };

      # Formatting
      formatter = pkgs.alejandra;
    });
}

