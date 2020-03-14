set nocompatible                                                  " be iMproved, required
source ~/.vim/plugins.vim                                         " load Plugins using Vundle.



"------------------ Basics ------------------"
set history=500                                                   " Sets how many lines of history VIM has to remember.
set clipboard=unnamedplus                                         " Use the system clipboard.
set backspace=eol,start,indent                                    " Configure backspace so it acts as it should act.
set whichwrap+=<,>,h,l
set noerrorbells visualbell t_vb=                                 " No damn bells!
set background=dark
set encoding=utf8                                                 " Set utf8 as standard encoding and en_US as the standard language.
set ffs=unix,dos,mac                                              " Use Unix as the standard file type.
set shiftwidth=2                                                  " 1 tab == 2 spaces
set tabstop=2
set switchbuf=useopen,usetab,newtab                               " Specify the behavior when switching between buffers.
set stal=1                                                        " Show tabline only when there is more then two tabs.
set foldcolumn=1
set pastetoggle=<F2>                                              " When in INSERT mode just press <F2> to switch to paste mode.

set autoread                                                      " Reload files when edited outside of vim.
set number                                                        " Show line number.
set cursorline                                                    " Highlight current line.
set autowriteall                                                  " Automatically write the file when switching buffers.
set ignorecase                                                    " Ignore case when searching.
set smartcase                                                     " When searching try to be smart about cases.
set hlsearch                                                      " Highlight search results.
set incsearch                                                     " Makes search act like search in modern browsers.
set expandtab                                                     " Use spaces instead of tabs.
set smarttab                                                      " Be smart when using tabs ;)
set ai                                                            " Auto indent.
set si                                                            " Smart indent.
set splitbelow                                                    " Make splits default to below...
set splitright                                                    " And to the right. This feels more natural.
set nowrap                                                        " Disable line wrapping.
set textwidth=0 wrapmargin=0                                      " Turn off physical line wrapping.

set nobackup
set noswapfile                                                    " Don't make *.swp files. Just use GIT.

let mapleader = ","                                               " Set leader to comma, which is more convenient.
let g:mapleader = ","


"------------------ Mappings ------------------"
" Fast saving.
nmap <leader>w :w!<cr>

" Disable search highlight.
nmap <silent> <leader><cr> :noh<cr>

" Close the current buffer.
nmap <leader>bd :bd<cr>
" Close all the buffers.
nmap <leader>ba :bufdo bd<cr>

" Select All.
nmap <C-S-a> ggVG

" We'll set simpler mappings to switch between splits.
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>

let g:lasttab = 1
au TabLeave * let g:lasttab = tabpagenr()

" Toggle between current and last tab.
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
" Opens a new tab with the current buffer's path.
nmap <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Useful mappings for managing tabs.
nmap <C-n> :tabnew<cr>:CtrlP<cr>
nmap <C-w> :tabclose<cr>
nmap <leader>to :tabonly<cr>
nmap <leader>tm :tabmove
nmap <leader>t<leader> :tabnext<cr>

" Make it easy to edit the Vimrc file.
nmap <Leader>ev :tabedit $MYVIMRC<cr>
" Make it easy to manage plugins file.
nmap <Leader>ep :tabedit ~/.vim/plugins.vim<cr>

" Quickly open a Project.
nmap <Leader>co :cd ~/Code/
" Make it easy to manage snippets.
nmap <Leader>es :e ~/.vim/snippets/

" Toggle comment.
nmap <leader>: :Commentary<cr>
" Switch CWD to the directory of the open buffer.
nmap <leader>cd :cd %:p:h<cr>:pwd<cr>

" Save with <C-s> in INSERT mode.
" imap <C-s> <C-o>:w<cr>
" Close tab in INSERT mode like in sublime.
imap <C-w> <C-o>:tabclose!<cr>

" Switch between current & latest opened file.
nnoremap <Leader><Leader> :e#<CR>

" Plugins mappings.
" CtrlP
nmap <C-p> :CtrlP<cr>
nmap <C-r> :CtrlPBufTag<cr>
nmap <C-e> :CtrlPMRUFiles<cr>

" CtrlPCmdPaltette
nmap <A-p> :CtrlPCmdPalette<cr>

" NERDTree
imap <C-S-k> <C-o>:NERDTreeToggle %<cr>
nmap <Leader>nn :NERDTreeToggle<cr>
nmap <Leader>nf :NERDTreeFocus<cr>

" Emmet
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>



"------------------ Color/Fonts ------------------"
syntax enable                                                     " Enable syntax highlighting.
colorscheme nord
" colorscheme hybrid
" colorscheme Tomorrow-Night
set t_Co=256                                                      " Enable 256 colors palette.



"------------------ Visual ------------------"
if has("gui_running")
  if has("vim_starting")
    set guioptions-=L                                             " Remove gVim scrollbars.
    set guioptions-=l
    set guioptions-=R
    set guioptions-=r

    set guioptions-=e                                             " We don't want Gui tabs.
    set guioptions-=m                                             " Neither Gui menus and toolbar.
    set guioptions-=T

    set linespace=14
    set t_Co=256
    set guifont=FuraMonoForPowerline\ NF\ 14
  endif
endif

highlight FoldColumn guifg=bg guibg=bg                            " Set foldcolumn background.
highlight VertSplit guifg=bg guibg=bg                             " Get rid of ugly split borders.



"------------------ Plugins ------------------"
" Airline
set laststatus=2
let g:airline_powerline_fonts=1                                   " Enable powerline symbols.
let g:airline_theme='luna'

" CtrlP
let g:ctrlp_custom_ignore = 'tmp\|log\|node_modules\|vendor\|^\.DS_Store\|^\.git\'
let g:ctrlp_working_path_mode = 'ra'

" NERDTree
let NERDTreeHijackNetrw = 0



"------------------ Commands ------------------"
" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Autosource .vimrc when saved.
augroup autosourcing
  autocmd!
  autocmd BufWritePost $MYVIMRC source % | AirlineRefresh
augroup END

" Source .vimrc and install plugins whenever plugins.vim gets updated.
augroup plugins
  autocmd!
  autocmd BufWritePost ~/.vim/plugins.vim source $MYVIMRC | PluginInstall
augroup END

autocmd BufNewFile,BufRead *.slim setlocal filetype=slim

" For saving using sudo.
command! W w !sudo tee % > /dev/null
