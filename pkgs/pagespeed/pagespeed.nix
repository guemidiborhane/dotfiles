{
  lib,
  writeShellApplication,
  curl,
  openssl,
  coreutils,
  gawk,
}:

writeShellApplication {
  name = "pagespeed";

  # Everything the script calls is put on its PATH from pkgs:
  #   curl      -> HTTP request + timings
  #   openssl   -> s_client / x509 for the certificate expiry
  #   coreutils -> date, cut, timeout
  #   gawk      -> float math and formatting
  runtimeInputs = [
    curl
    openssl
    coreutils
    gawk
  ];

  # writeShellApplication adds its own shebang and strict-mode header,
  # so drop the script's shebang (ShellCheck rejects a second one).
  text = lib.removePrefix "#!/usr/bin/env bash\n" (builtins.readFile ./pagespeed.sh);

  meta = {
    description = "Measure website response time and TLS certificate validity";
    mainProgram = "pagespeed";
    platforms = lib.platforms.unix;
  };
}
