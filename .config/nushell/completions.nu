let carapace_completer = {|spans: list<string>|
  carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
}

let fish_completer = {|spans: list<string>|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --noheaders --no-infer
    | rename value description
}

let zoxide_completer = {|spans: list<string>|
    do $fish_completer $spans | get value | append ($spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD})
}

# This completer will use carapace by default
$env.config.completions.external = {
    enable: true
    max_results: 100
}

$env.config.completions.external.completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        __zoxide_z | __zoxide_zi => $zoxide_completer
        _ => $carapace_completer
    } | do $in $spans
}

