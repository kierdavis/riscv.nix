{ stdenv, gmp, mpfr, libmpc, wget, curl, texinfo, bison, flex }:

let
  nixpkgs = import <nixpkgs> {};

  newlib = rec {
    version = "2.2.0";
    src = nixpkgs.fetchurl {
      url = "ftp://sourceware.org/pub/newlib/newlib-${version}.tar.gz";
      sha256 = "1gimncxzq663l4gp8zd89ynfzhk2q802mcaiyjpr2xbkn1ix5bgq";
    };
  };

  distdir = nixpkgs.runCommand "riscv-gnu-toolchain-distdir" {} ''
    mkdir -p $out
    ln -s ${newlib.src} $out/newlib-${newlib.version}.tar.gz
  '';

in
  stdenv.mkDerivation rec {
    name = "riscv-gnu-toolchain";
    buildInputs = [ gmp mpfr libmpc wget curl texinfo bison flex ];
    hardeningDisable = [ "format" ];
    src = nixpkgs.fetchgit {
      rev = "910ea19c5173755f74924d3fc94e168e17693d97";
      url = "git://github.com/riscv/riscv-gnu-toolchain.git";
      sha256 = "16w4nn6gni5n5i2dbb31w4fw2mbahmg4j199drpvpl6mzwydws7j";
    };
    buildFlags = ["DISTDIR=${distdir}"];
  }
