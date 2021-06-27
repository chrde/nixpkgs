{lib, buildDunePackage, fetchurl}:

buildDunePackage rec {
  pname = "pp";
  version = "1.1.2";

  useDune2 = true;
  minimumOCamlVersion = "4.08";

  minimumSupportedOcamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/ocaml-dune/pp/archive/${version}.tar.gz";
    sha256 = "sha256-UgOqaSdcLYrcP/bmwcL2Sr11yZJuqskrzw8TGkQHGa4=";
  };

  meta = with lib; {
    homepage = "https://github.com/ocaml-dune/pp";
    description = "Pretty-printing library";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}

