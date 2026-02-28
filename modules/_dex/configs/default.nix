let
  readToml = file: builtins.fromTOML (builtins.readFile file);
in
{
  defaults = readToml ./defaults.toml;
  users = readToml ./users.toml;

  hosts = readToml ./hosts.toml;
}
