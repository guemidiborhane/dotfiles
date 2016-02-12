set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

let NERDTreeWinPos = "left" 
set shiftwidth=2 
set tabstop=2 

let g:ctrlp_custom_ignore = 'tmp\|log\|node_modules\|^\.DS_Store\|^\.git\|^\.coffee|' 
let g:airline_theme="simple"
