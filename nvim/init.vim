set number
set relativenumber

set autoindent
set smartindent

set splitright
set splitbelow

set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set mouse=

set completeopt=menu,noselect

call plug#begin()

Plug 'https://github.com/vim-airline/vim-airline.git'
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/s1n7ax/nvim-terminal'
Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'https://github.com/preservim/tagbar'
Plug 'https://github.com/ethanholz/nvim-lastplace'
Plug 'https://github.com/glepnir/dashboard-nvim'
Plug 'https://github.com/junegunn/fzf.vim'
Plug 'https://github.com/neoclide/coc.nvim'
Plug 'https://github.com/ms-jpq/coq_nvim'
Plug 'https://github.com/nvim-lua/completion-nvim'
Plug 'https://github.com/dkarter/bullets.vim'
Plug 'https://github.com/cdelledonne/vim-cmake'
Plug 'https://github.com/nvim-telescope/telescope.nvim'
Plug 'https://github.com/neovim/nvim-lspconfig'
Plug 'https://github.com/shime/vim-livedown'
Plug 'https://github.com/szw/vim-maximizer'
Plug 'https://github.com/csexton/trailertrash.vim'
Plug 'https://github.com/farmergreg/vim-lastplace'
"Plug 'https://github.com/puremourning/vimspector'
Plug 'https://github.com/sakhnik/nvim-gdb'

call plug#end()

" nerdtree
nnoremap <C-n> :NERDTreeToggle<CR>

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="-"

" tagbar
nnoremap <C-t> :Tagbar fjc<CR>

" nvim-lastplace
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
let g:lastplace_ignore_buftype = "quickfix,nofile,help"
let g:lastplace_ignore_filetype = "gitcommit,gitrebase,svn,hgcommit"
let g:lastplace_open_folds = 1

" vim-livedown
nmap <leader>gm :LivedownToggle<CR>
let g:livedown_autorun = 0
let g:livedown_open = 1
let g:livedown_port = 1337
let g:livedown_browser = "firefox"

" vim-maximizer
noremap <C-w>m :MaximizerToggle<CR>

" trailertrash
nmap <leader>gt :TrailerTrim<CR>

" awesome-vim-colorschemes
" Brian's favorite color schemes:
"   koehler      (high performance)
"   molokai      (visually appealing)
"   sonokai      (sublime theme)
"   jellybeans   (easy for eyes less colors)
"   wombat256mod (easy for eyes more colors)
colorscheme jellybeans

set cursorline

let g:clang_user_options='|| exit 0'
let g:clang_use_library=1
set completeopt-=preview

" register w
" yss<summary>ySS<details>jjOOOji> ```"spa > ``````jjO> Origins:jO> - :1ypkJxxA - ?## Chapter [0-9]wy2wpjOjO> References:jO---:noh0zzkkkkkkk

" register x
" yss<summary>ySS<details>jjOOOji> ```"spa > ``````jjO> Origins:jO> - "apjOjO> References:jO---:noh0zzkkkkkkk

" register y
" 0yyp0
