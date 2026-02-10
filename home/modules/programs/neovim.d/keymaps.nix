[
 {
    key = "jj";
    mode = "i";
    action = "<Esc>";
  }
  {
    key = "<leader>qq";
    mode = "n";
    action = "<cmd>qa<CR>";
  }
  {
    key = "<leader><leader>";
    mode = "n";
    desc = "Find Files (git-files if in Git repo)";
    lua = true;
    action = /* lua */ ''
      function()
        local git_dir = os.getenv("GIT_DIR")
        local in_yadm = git_dir and git_dir:match("yadm/repo%.git$") ~= nil
        local show_untracked = not in_yadm
        local ok = pcall(require("telescope.builtin").git_files, { show_untracked = show_untracked })
        if not ok then
          require("telescope.builtin").find_files()
        end
      end
    '';
  }
  # Visual mode indent and keep selection
  {
    key = "<";
    mode = "x";
    action = "<gv";
  }
  {
    key = ">";
    mode = "x";
    action = ">gv";
  }
  # j/k move by visual lines when no count
  {
    key = "j";
    mode = ["n" "x"];
    action = "v:count == 0 ? 'gj' : 'j'";
    desc = "Down";
    expr = true;
    silent = true;
  }
  {
    key = "<Down>";
    mode = ["n" "x"];
    action = "v:count == 0 ? 'gj' : 'j'";
    desc = "Down";
    expr = true;
    silent = true;
  }
  {
    key = "k";
    mode = ["n" "x"];
    action = "v:count == 0 ? 'gk' : 'k'";
    desc = "Up";
    expr = true;
    silent = true;
  }
  {
    key = "<Up>";
    mode = ["n" "x"];
    action = "v:count == 0 ? 'gk' : 'k'";
    desc = "Up";
    expr = true;
    silent = true;
  }
  # Buffer navigation
  {
    key = "<S-h>";
    mode = "n";
    action = "<cmd>bprevious<CR>";
    desc = "Prev Buffer";
  }
  {
    key = "<S-l>";
    mode = "n";
    action = "<cmd>bnext<CR>";
    desc = "Next Buffer";
  }
  {
    key = "<leader>bb";
    mode = "n";
    action = "<cmd>e #<CR>";
    desc = "Switch to Other Buffer";
  }
  {
    key = "<leader>bd";
    mode = "n";
    lua = true;
    action = /* lua */''
      function()
        Snacks.bufdelete()
      end
    '';
    desc = "Delete Buffer";
  }
  {
    key = "<leader>bo";
    mode = "n";
    lua = true;
    action = /* lua */''
      function()
        Snacks.bufdelete.other()
      end
    '';
    desc = "Delete Buffer";
  }
  {
    key = "<leader>ba";
    mode = "n";
    lua = true;
    action = /* lua */''
      function()
        Snacks.bufdelete.all()
      end
    '';
    desc = "Delete Buffer";
  }
  {
    key = "<C-s>";
    mode = ["i" "x" "n" "s"];
    action = "<cmd>w<CR><esc>";
    desc = "Save File";
  }
  {
    key = "<leader>fn";
    mode = "n";
    action = "<cmd>enew<CR>";
    desc = "New File";
  }
  {
    key = "<leader>cd";
    mode = "n";
    action = "<cmd>lua vim.diagnostic.open_float()<CR>";
    desc = "Line Diagnostics";
  }
  {
    key = "<esc>";
    mode = ["i" "n" "s"];
    action = "<cmd>noh<CR><esc>";
    desc = "Escape and Clear hlsearch";
  }
  {
    key = "<leader>e";
    mode = "n";
    action = "<cmd>Neotree toggle<CR>";
    desc = "Toggle Neotree";
  }
  {
    key = "<leader>uw";
    mode = "n";
    action = "<cmd>set wrap!<CR>";
    desc = "Toggle line wrap";
  }
  {
    key = "<leader>n";
    mode = "n";
    lua = true;
    action = /* lua */''
      function()
        if Snacks.config.picker and Snacks.config.picker.enabled then
          Snacks.picker.notifications()
        else
          Snacks.notifier.show_history()
        end
      end
    '';
    desc = "Notification history";
  }
  {
    key = "<leader>un";
    mode = "n";
    lua = true;
    action = /* lua */''
      function() Snacks.notifier.hide() end
    '';
    desc = "Dismiss all notifications";
  }
]
