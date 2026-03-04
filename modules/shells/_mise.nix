{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  name = "mise-install-env";

  nativeBuildInputs = with pkgs; [
    pkg-config
    gnumake
    gcc
    autoconf
    # Ruby 4.0+ requires Rust for the YJIT compiler
    rustc
    cargo
  ];

  buildInputs = with pkgs; [
    openssl
    libyaml
    zlib
    readline
    libffi
    gmp
  ];

  shellHook = ''
    # 1. Fix the "ruby.tmp.pc" error by allowing pkg-config to look in the current build dir
    export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:."

    # 2. Resolve the SSL/TLS handshake error for mise/downloader
    export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt

    # 3. Explicitly point ruby-build to the Nix store for OpenSSL
    # This prevents it from looking in /usr/include (which doesn't exist on NixOS)
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${pkgs.openssl.dev} --with-readline-dir=${pkgs.readline}"
    exec fish
  '';
}
