{ lib, stdenv, fetchFromGitHub
, cmake
}:
stdenv.mkDerivation rec {
  pname = "bento4";
  version = "1.6.0-638";

  src = fetchFromGitHub {
    owner = "axiomatic-systems";
    repo = "Bento4";
    rev = "v${version}";
    sha256 = "1hxr4lds4dl46advshk7azg28fcpcjaa5pzk2zzpsc9l69s0bnxk";
  };

  patches = [
    ./libap4.patch # include all libraries as shared, not static
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{lib,bin}
    find -iname '*.so' -exec mv --target-directory="$out/lib" {} \;
    find -maxdepth 1 -executable -type f -exec mv --target-directory="$out/bin" {} \;
    runHook postInstall
  '';

  meta = with lib; {
    description = "Full-featured MP4 format and MPEG DASH library and tools";
    homepage = "http://bento4.com";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ makefu ];
    broken = stdenv.isAarch64;
    platforms = platforms.unix;
  };
}
