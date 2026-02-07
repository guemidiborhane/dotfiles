{
  enable = true;
  setupOpts.options.theme = "dracula-nvim";

  componentSeparator = {
    left = "";
    right = "";
  };

  sectionSeparator = {
    left = "";
    right = "";
  };

  activeSection.a = [
    ''{ "mode" }''
  ];

  activeSection.b = [
    ''{
        "branch",
        icon = "",
        color = { gui = "bold" },
    }''
  ];


  activeSection.c = [
    ''{
      "diagnostics",
      symbols = {
        Error = " ",
        Warn  = " ",
        Hint  = " ",
        Info  = " ",
      },
    }''
    ''{ "filetype", icon_only = false, separator = "", padding = { left = 1, right = 0 } }''
  ];

  activeSection.x = [];

  activeSection.y = [
    ''{
      "diff",
      symbols = {
        added    = " ",
        modified = " ",
        removed  = " ",
      }
    }''
  ];

  activeSection.z = [
    ''{ "location", padding = { left = 0, right = 1 } }''
    ''{ "progress", padding = { left = 1, right = 1 } }''
  ];
}
