{ _, ... }:
{
  flake.modules.nixos.system-sleep =
    { _, ... }:
    {

      systemd.sleep.settings.Sleep = {
        AllowSuspend = "yes";
        AllowHibernation = "yes";
        AllowSuspendThenHibernate = "yes";
        AllowHybridSleep = "no";
        SuspendState = "freeze";
        HibernateMode = "shutdown";
        HibernateState = "disk";
        HybridSleepState = "disk";
        HibernateDelaySec = "30min";
      };
    };
}
