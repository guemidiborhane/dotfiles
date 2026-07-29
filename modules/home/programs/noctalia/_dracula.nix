{ _, ... }:
{
  programs.noctalia = {
    settings.theme = {
      custom_palette = "dracula";
      source = "custom";
    };

    customPalettes.dracula.dark = {
      mPrimary = "#f1fa8c";
      mOnPrimary = "#282a36";
      mSecondary = "#bd93f9";
      mOnSecondary = "#1e1f29";
      mTertiary = "#8be9fd";
      mOnTertiary = "#282a36";
      mError = "#ff5555";
      mOnError = "#282a36";
      mSurface = "#282a36";
      mOnSurface = "#f8f8f2";
      mSurfaceVariant = "#44475a";
      mOnSurfaceVariant = "#caccda";
      mOutline = "#6272a4";
      mShadow = "#1e1f29";
      mHover = "#bd93f9";
      mOnHover = "#1e1f29";
      terminal = {
        normal = {
          black = "#21222c";
          red = "#ff5555";
          green = "#50fa7b";
          yellow = "#f1fa8c";
          blue = "#bd93f9";
          magenta = "#ff79c6";
          cyan = "#8be9fd";
          white = "#f8f8f2";
        };
        bright = {
          black = "#6272a4";
          red = "#ff6e6e";
          green = "#69ff94";
          yellow = "#ffffa5";
          blue = "#d6acff";
          magenta = "#ff92df";
          cyan = "#a4ffff";
          white = "#ffffff";
        };
        foreground = "#f8f8f2";
        background = "#282a36";
        selectionFg = "#f8f8f2";
        selectionBg = "#44475a";
        cursorText = "#282a36";
        cursor = "#f8f8f2";
      };
    };
  };
}
