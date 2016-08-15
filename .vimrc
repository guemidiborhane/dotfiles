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

" Enable mouse support
set ttyfast
set mouse=a
set ttymouse=xterm2

try 
  colorscheme Kafka
catch
endtry

set cf  " Enable error files & error jumping.
set clipboard+=unnamed  " Yanks go on clipboard instead.
set history=256  " Number of things to remember in history.
set autowrite  " Writes on make/shell commands
set nowrap  " Line wrapping off
set timeoutlen=250  " Time to wait after ESC (default causes an annoying delay)

" Formatting (some of these are for coding in C and C++)
set ts=2  " Tabs are 2 spaces
set bs=2  " Backspace over everything in insert mode
set shiftwidth=2  " Tabs under smart indent
set nocp incsearch
set cinoptions=:0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr
set cindent
set autoindent
set smarttab
set expandtab

" Visual
set showmatch  " Show matching brackets.
set mat=5  " Bracket blinking.
set novisualbell  " No blinking .
set noerrorbells  " No noise.
set laststatus=2  " Always show status line.

" gvim specific
set mousehide  " Hide mouse after chars typed
set mouse=a  " Mouse in all modes
