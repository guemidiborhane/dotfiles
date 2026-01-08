{
    pkgs,
    ...
}: {
  environment.systemPackages = with pkgs; [
    autoconf
    automake
    file
    findutils
    flex
    gawk
    gcc
    gettext
    groff
    gzip
    libtool
    gnumake
    patch
    pkgconf
    gnused
    texinfo
    which
    pkg-config
    stdenv.cc
    gnumake
    pkg-config
    openssl
    zlib
    libffi
    bison
  ];

  programs.nix-ld.enable = true;

  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "hourly";
  };
}
