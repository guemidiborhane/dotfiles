$env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/gcr/ssh"

$env.EDITOR = 'nvim'
$env.VISUAL = 'nvim'
$env.PAGER  = 'less'
$env.MANPAGER  = 'nvim +Man!'

$env.PROMPT_INDICATOR_VI_INSERT = {|| "" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| ": " }

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
$env.ASDF_DIR = '/opt/asdf-vm/'
$env.ASDF_GOLANG_MOD_VERSION_ENABLED = 'true'

# mkdir ~/.cache/nushell
let cache_path = "~/.cache/nushell"

if not ($cache_path | path exists) {
  mkdir $cache_path
}

zoxide init --cmd cd nushell | save --force $"($cache_path)/zoxide.nu"
starship init nu | save --force $"($cache_path)/starship.nu"
carapace _carapace nushell | save --force $"($cache_path)/carapace.nu"

