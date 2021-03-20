{ lib, stdenv, fetchurl, pkg-config, meson, ninja, python3, pango, glibmm, cairomm, gnome3
, ApplicationServices }:

stdenv.mkDerivation rec {
  pname = "pangomm";
  version= "2.46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-03h9BNYZi2BvPvo1eztFKnFA4qfe5W+fnOUW19X87Bs=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config meson ninja python3 ] ++ lib.optional stdenv.isDarwin [
    ApplicationServices
  ];
  propagatedBuildInputs = [ pango glibmm cairomm ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "C++ interface to the Pango text rendering library";
    homepage    = "https://www.pango.org/";
    license     = with licenses; [ lgpl2 lgpl21 ];
    maintainers = with maintainers; [ lovek323 raskin ];
    platforms   = platforms.unix;

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK widget toolkit.
      Pango forms the core of text and font handling for GTK.
    '';
  };
}
