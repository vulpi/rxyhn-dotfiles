{
  lib,
  stdenv,
  fetchzip,
  pkgs,
  ...
}:
stdenv.mkDerivation rec {
  pname = "cattpuccin-gtk";
  version = "0.2.7";

  src = fetchzip {
    url = "https://github.com/catppuccin/gtk/releases/download/v-0.2.7/Catppuccin-Macchiato-Mauve.zip";
    sha256 = "3VQhJPKm9Sn62Ek/iiJoxqA9mDphCiCTgyBtt31b8Jw=";
    stripRoot = false;
  };

  propagatedUserEnvPkgs = with pkgs; [
    gnome.gnome-themes-extra
    gtk-engine-murrine
  ];

  installPhase = ''
    mkdir -p $out/share/themes/
    cp -r Catppuccin-Macchiato-Mauve $out/share/themes
  '';

  meta = {
    description = "Soothing pastel theme for GTK3";
    homepage = "https://github.com/catppuccin/gtk";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [lib.maintainers.sioodmy];
  };
}
