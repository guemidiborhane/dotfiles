$env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/gcr/ssh"

$env.EDITOR = 'nvim'
$env.VISUAL = 'nvim'
$env.PAGER  = 'less'
$env.MANPAGER  = 'nvim +Man!'

$env.PROMPT_INDICATOR_VI_INSERT = {|| "" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| ": " }

$env.TRANSIENT_PROMPT_COMMAND = {|| ^starship module character }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| $"(^starship module directory)(^starship module time)" }

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
$env.INITIAL_COMMIT_MSG = "The same thing we do every night, Pinky - try to take over the world!"
$env.BATMAN_INITIAL_COMMIT_MSG = "Batman! (this commit has no parents)"

if not ($nu.cache-dir | path exists) {
  mkdir $nu.cache-dir
}

zoxide init --cmd cd nushell | save --force $"($nu.cache-dir)/zoxide.nu"
starship init nu | save --force $"($nu.cache-dir)/starship.nu"
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
mise activate nu | save --force $"($nu.cache-dir)/mise.nu"
atuin init nu --disable-up-arrow | save --force $"($nu.cache-dir)/atuin.nu"
