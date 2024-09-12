{ lib
, stdenv
, fetchurl
, makeWrapper
, electron
, appimageTools
}:

stdenv.mkDerivation rec {
  pname = "zen-browser";
  version = "1.0.0-a.39";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-specific.AppImage";
    sha256 = "sha256-tFci3PttYYhkSPrABW8LHSm95h5v7t1GIZWzdtsOF9Q=";
  };

  nativeBuildInputs = [ makeWrapper appimageTools ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications $out/share/${pname}
    cp $src $out/share/${pname}/${pname}.AppImage
    chmod +x $out/share/${pname}/${pname}.AppImage

    # Extract AppImage contents
    cd $out/share/${pname}
    ${appimageTools.extractType2 { name = pname; src = src; }}

    # Create wrapper
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags "$out/share/${pname}/${pname}.AppImage"

    # Create desktop entry
    cp $out/share/${pname}/zen-browser.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  meta = with lib; {
    description = "Zen Browser - Experience tranquillity while browsing the web without people tracking you";
    homepage = "https://zen-browser.app";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ]; # Add maintainers if applicable
  };
}
