{ lib, self, ... }:
{
  # The `flake.dex.rules` option is declared in modules/dex/dex.nix. This module
  # provides the aggregator that runs every registered rule over a host's
  # cascaded context and throws a single aggregated message on any violation.
  config.flake.dex.validate =
    ctx:
    let
      errors = lib.concatMap (rule: rule ctx) self.dex.rules;
    in
    if errors == [ ] then
      ctx
    else
      throw ("dex: invalid config for host '${ctx.name}':\n  - " + lib.concatStringsSep "\n  - " errors);
}
