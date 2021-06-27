{ buildDunePackage
, stdlib-shims
, ppx_yojson_conv_lib
, pp
, jsonrpc
, omd
, re
, octavius
, dune-build-info
, uutf
, csexp
, cmdliner
}:

buildDunePackage {
  pname = "lsp";
  inherit (jsonrpc) version src;
  useDune2 = true;
  minimumOCamlVersion = "4.06";

  # unvendor some (not all) dependencies.
  # They are vendored by upstream only because it is then easier to install
  # ocaml-lsp without messing with your opam switch, but nix should prevent
  # this type of problems without resorting to vendoring.
  preBuild = ''
    rm -r ocaml-lsp-server/vendor/{octavius,uutf,omd,cmdliner}
  '';

  buildInputs = [
    stdlib-shims
    ppx_yojson_conv_lib
    pp
    octavius
    uutf
    re
    csexp
    dune-build-info
    omd
    cmdliner
    jsonrpc
  ];

  meta = jsonrpc.meta // {
    description = "LSP protocol implementation in OCaml";
  };
}
