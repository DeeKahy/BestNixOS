{ lib

, stdenv

, fetchFromGitHub

, makeWrapper

, firefox-unwrapped

, glib

, gtk3

, libXtst

, libnotify

, libGLU

, nss

, nspr

}:

stdenv.mkDerivation rec {

  pname = "zen-browser";

  version = "1.0.0-a.39";

  src = fetchFromGitHub {

    owner = "zen-browser";

    repo = "desktop";

    rev = version;

    hash = "sha256-f1pYDzsGKagBmmEoF3YXcWLiApzyRwFbLSo3VyUvvjc="; # Replace with actual hash after first build attempt

  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [

    firefox-unwrapped

    glib

    gtk3

    libXtst

    libnotify

    libGLU

    nss

    nspr

  ];

  installPhase = ''

    mkdir -p $out/bin

    cp -r * $out/

    chmod +x $out/zen

    makeWrapper $out/zen $out/bin/zen-browser \

      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}

  '';

  meta = with lib; {

    description = "Firefox-based browser with a focus on privacy and customization";

    homepage = "https://get-zen.vercel.app/";

    license = licenses.mpl20;

    maintainers = [ ]; # Add maintainers if known

    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

    mainProgram = "zen-browser";

  };

}
