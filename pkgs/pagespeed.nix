{
  lib,
  writeShellApplication,
  curl,
  coreutils,
  gawk,
}:

writeShellApplication {
  name = "pagespeed";

  # Everything the script calls is put on its PATH from pkgs:
  #   curl      -> HTTP request + timings + TLS cert chain (%{certs})
  #   coreutils -> date
  #   gawk      -> float math and formatting
  runtimeInputs = [
    curl
    coreutils
    gawk
  ];

  # writeShellApplication adds its own shebang and strict-mode header,
  # so drop the script's shebang (ShellCheck rejects a second one).
  text = lib.removePrefix "#!/usr/bin/env bash\n" (builtins.readFile ./pagespeed.sh);

  meta = {
    description = "Measure website response time and TLS certificate validity";
    mainProgram = "pagespeed";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
