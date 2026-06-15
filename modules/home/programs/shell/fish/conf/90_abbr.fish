# vi: set ft=fish :

abbr prod 'kubectl --context elhakim'
abbr stage 'kubectl --context benboulaid'

abbr k kubectl
abbr ke kubectl edit
abbr kg kubectl get

set mk make
abbr mk $mk
abbr mkc "$mk console"
abbr mkf "$mk fish"
abbr mkd "$mk dev"
abbr mkdd "$mk down"
abbr mkr "$mk restart"
abbr mktt "$mk test"

set j just
abbr j $j
abbr jc "$j console"
abbr jff "$j fish"
abbr jd "$j dev"
abbr jdd "$j down"
abbr jr "$j restart"
abbr jtt "$j test"

abbr sc "sudo systemctl"
abbr scu "systemctl --user"
abbr jf "journalctl -fu"
abbr jfu "journalctl --user -fu"
