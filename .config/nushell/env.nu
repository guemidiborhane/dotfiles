$env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/gcr/ssh"

$env.EDITOR = 'nvim'
$env.VISUAL = 'nvim'
$env.PAGER  = 'less'
$env.MANPAGER  = 'nvim +Man!'

$env.PROMPT_INDICATOR_VI_INSERT = {|| "" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| ": " }

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
$env.ASDF_DATA_DIR = $"($env.HOME)/.asdf"
$env.ASDF_GOLANG_MOD_VERSION_ENABLED = 'true'

$env.INITIAL_COMMIT_MSG = "The same thing we do every night, Pinky - try to take over the world!"
$env.BATMAN_INITIAL_COMMIT_MSG = "Batman! (this commit has no parents)"

# mkdir ~/.cache/nushell
let cache_path = "~/.cache/nushell"

if not ($cache_path | path exists) {
  mkdir $cache_path
}

zoxide init --cmd cd nushell | save --force $"($cache_path)/zoxide.nu"
starship init nu | save --force $"($cache_path)/starship.nu"
carapace _carapace nushell | save --force $"($cache_path)/carapace.nu"

let shims_dir = (
  if ( $env | get --ignore-errors ASDF_DATA_DIR | is-empty ) {
    $env.HOME | path join '.asdf'
  } else {
    $env.ASDF_DATA_DIR
  } | path join 'shims'
)
$env.PATH = ( $env.PATH | split row (char esep) | where { |p| $p != $shims_dir } | prepend $shims_dir )
