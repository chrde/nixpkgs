{ lib, stdenv
, gettext
, fetchurl
, evolution-data-server
, pkg-config
, libxslt
, docbook_xsl
, docbook_xml_dtd_42
, python3
, gtk3
, glib
, cheese
, libchamplain
, clutter-gtk
, geocode-glib
, gnome-desktop
, gnome-online-accounts
, wrapGAppsHook
, folks
, libgdata
, libxml2
, gnome3
, vala
, meson
, ninja
, libhandy
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-contacts";
  version = "40.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "0mqij248lxrkzcs0j66yl85y10fcd9vv992fggxixgh6bsaciwl5";
  };

  propagatedUserEnvPkgs = [
    evolution-data-server
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    libxslt
    docbook_xsl
    docbook_xml_dtd_42
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    glib
    evolution-data-server
    gsettings-desktop-schemas
    folks
    libgdata # required by some dependency transitively
    gnome-desktop
    libhandy
    libxml2
    gnome-online-accounts
    cheese
    gnome3.adwaita-icon-theme
    libchamplain
    clutter-gtk
    geocode-glib
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-contacts";
      attrPath = "gnome3.gnome-contacts";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Contacts";
    description = "GNOME’s integrated address book";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
