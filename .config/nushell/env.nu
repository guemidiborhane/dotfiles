mkdir ~/.cache/nushell

$env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/gcr/ssh"

$env.EDITOR = 'nvim'
$env.VISUAL = 'nvim'
$env.PAGER  = 'less'

$env.PROMPT_INDICATOR_VI_INSERT = {|| "" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| ": " }

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
$env.ASDF_DIR = '/opt/asdf-vm/'
$env.ASDF_GOLANG_MOD_VERSION_ENABLED = 'true'

zoxide init --cmd cd nushell | save -f ~/.cache/nushell/zoxide.nu
starship init nu | save -f ~/.cache/nushell/starship.nu
carapace _carapace nushell | save --force ~/.cache/nushell/carapace.nu

