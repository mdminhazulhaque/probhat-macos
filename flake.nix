{
  description = "Probhat Bengali keyboard layout for macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          probhat = pkgs.stdenvNoCC.mkDerivation {
            pname = "probhat-keylayout";
            version = "1.0.0";
            src = ./.;

            dontBuild = true;

            installPhase = ''
              mkdir -p "$out/Library/Keyboard Layouts"
              cp Probhat.keylayout Probhat.icns "$out/Library/Keyboard Layouts/"
            '';

            meta = {
              description = "Probhat fixed-layout Bengali keyboard for macOS";
              homepage = "https://github.com/audacioustux/probhat-macos";
              license = nixpkgs.lib.licenses.mit;
              platforms = nixpkgs.lib.platforms.darwin;
            };
          };
          default = self.packages.${system}.probhat;
        });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      darwinModules.default = { config, lib, pkgs, ... }:
        let
          cfg = config.programs.probhat;
          dst = "/Library/Keyboard Layouts";
          pkg = self.packages.${pkgs.system}.default;
          src = "${pkg}/Library/Keyboard Layouts";
        in
        {
          options.programs.probhat.enable =
            lib.mkEnableOption "Probhat Bengali keyboard layout";

          config = lib.mkIf (pkgs.stdenv.isDarwin) {
            system.activationScripts.postActivation.text =
              if cfg.enable then ''
                echo "Installing Probhat keyboard layout..." >&2
                mkdir -p "${dst}"
                install -m 644 "${src}/Probhat.keylayout" "${dst}/Probhat.keylayout"
                install -m 644 "${src}/Probhat.icns" "${dst}/Probhat.icns"
              '' else ''
                echo "Removing Probhat keyboard layout..." >&2
                rm -f "${dst}/Probhat.keylayout"
                rm -f "${dst}/Probhat.icns"
              '';
          };
        };
    };
}