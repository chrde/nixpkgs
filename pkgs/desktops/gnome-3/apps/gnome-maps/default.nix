{ lib, stdenv
, fetchurl
, meson
, ninja
, gettext
, python3
, pkg-config
, gnome3
, gtk3
, gobject-introspection
, gdk-pixbuf
, librsvg
, libgweather
, geoclue2
, wrapGAppsHook
, folks
, libchamplain
, gfbgraph
, libsoup
, gsettings-desktop-schemas
, webkitgtk
, gjs
, libgee
, libhandy
, geocode-glib
, evolution-data-server
, gnome-online-accounts
}:

stdenv.mkDerivation rec {
  pname = "gnome-maps";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-7BHcbJ7qJphZJQDa861nPB5PZOvrDT0oI/uGVbtdSkk=";
  };

  doCheck = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    evolution-data-server
    folks
    gdk-pixbuf
    geoclue2
    geocode-glib
    gfbgraph
    gjs
    gnome-online-accounts
    gnome3.adwaita-icon-theme
    gobject-introspection
    gsettings-desktop-schemas
    gtk3
    libchamplain
    libgee
    libgweather
    libhandy
    librsvg
    libsoup
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py

    # The .service file isn't wrapped with the correct environment
    # so misses GIR files when started. By re-pointing from the gjs
    # entry point to the wrapped binary we get back to a wrapped
    # binary.
    substituteInPlace "data/org.gnome.Maps.service.in" \
        --replace "Exec=@pkgdatadir@/org.gnome.Maps" \
                  "Exec=$out/bin/gnome-maps"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Maps";
    description = "A map application for GNOME 3";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
