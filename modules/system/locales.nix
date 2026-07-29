{ _, ... }:
{
  flake.modules.nixos.locales =
    { _, ... }:
    {
      time.timeZone = "Africa/Algiers";
      i18n.defaultLocale = "en_GB.UTF-8";
    };
}
