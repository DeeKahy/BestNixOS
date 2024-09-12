{ lib
, stdenv
, fetchurl
, makeWrapper
, electron
, appimageTools
}:

let
  pname = "zen-browser";
  version = "1.0.0-a.39";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-specific.AppImage";
    sha256 = "sha256-tFci3PttYYhkSPrABW8LHSm95h5v7t1GIZWzdtsOF9Q=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in stdenv.mkDerivation {
  pname = "zen-browser";
  version = "1.0.0-a.39";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-specific.AppImage";
    sha256 = "sha256-tFci3PttYYhkSPrABW8LHSm95h5v7t1GIZWzdtsOF9Q=";
  };

  buildInputs = [
    makeWrapper
    electron
    # Removed appimageTools as it's a function, not a derivation
  ];

  installPhase = ''
    ${appimageTools.extractType2} --appimage ${src}

    mv $out/bin/${pname} $out/bin/${pname}-unwrapped
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags "$out/bin/${pname}-unwrapped"

    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Zen Browser - Experience tranquillity while browsing the web without people tracking you";
    homepage = "https://zen-browser.app";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ]; # Add maintainers if applicable
  };
}
