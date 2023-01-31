filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()


" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-dotenv'
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'posva/vim-vue'
Plugin 'mattn/emmet-vim'
Plugin 'wavded/vim-stylus'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'airblade/vim-gitgutter'
Plugin 'kchmck/vim-coffee-script'
Plugin 'matze/vim-move'
Plugin 'jwalton512/vim-blade'
Plugin 'dracula/vim', { 'name': 'dracula' }
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
