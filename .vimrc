" Vundle Setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle Plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'bling/vim-airline'
Plugin 'majutsushi/tagbar'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/vim-easymotion'

call vundle#end()
filetype plugin indent on

" Appearance
set t_Co=256
set expandtab
set shiftwidth=4
set tabstop=4
syntax on
set number
color jellybeans
set guifont=Monaco:h9

" Layout
autocmd VimEnter * TagbarOpen
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd l

" GVIM GUI Options
set go-=m
set go-=T
set go-=r
set go-=L

" Keybinds
nmap <F8> :TagbarToggle<CR>
map <C-j> :NERDTreeToggle<CR>
