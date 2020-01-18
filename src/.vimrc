"" should see :h options


"" system

" base
scriptencoding utf-8
set nocompatible
set nomodeline
set autoread
set history=1200
set tabpagemax=120
set hidden " NOTE
set display=lastline " NOTE
filetype plugin indent on
syntax on
set tags=${MY_VIM_TAGS_GIT}
if has('clipboard')
  set clipboard=unnamed,autoselect,html
endif

" backup
set nobackup
"set nowritebackup
set writebackup
set noswapfile
"set noundofile
set undofile
set undodir=${MY_VIM_UNDO}
set undolevels=2000


"" input

" encoding
set encoding=utf-8
set fileencodings=utf-8,euc-jp,iso-2022-jp,cp932
set ambiwidth=double

" enable keys
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~
"set virtualedit=onemore
"set nrformats=alpha,bin,hex
set nrformats=bin,hex

" indent
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent

" search
set hlsearch
set ignorecase
set smartcase
set incsearch
set wrapscan
set nofoldenable " NOTE


"" display

" editor
set title
set number
set ruler
set showtabline=2
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set wildmenu
set wildmode=list:longest
set shellslash
set cmdheight=1
set showcmd
set showmode
set showmatch
set cursorline
"set cursorcolumn
set nocursorcolumn
set list
set listchars=tab:^=
set helplang=ja

" sound
set noerrorbells
"set errorbells
set visualbell t_vb=
"set visualbell


"" key bind

" tab
nnoremap <C-n> gt
nnoremap <C-p> gT
nnoremap <C-j> :tab sp<CR><C-]>
nnoremap <C-k> :pop<CR>

" move
nnoremap j gj
nnoremap k gk

" session
nnoremap qq :qa<CR>
nnoremap <C-m><C-m> :mksession! ${MY_VIM_SESSION}<CR>
nnoremap <C-m><C-s> :source ${MY_VIM_SESSION}<CR>

" set middle after search
nnoremap n nzz
nnoremap N Nzz

" visual * search
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>

" disable highlight search
nnoremap <Esc><Esc> :nohlsearch<CR>

" write current path next line
nnoremap <C-l> o<C-R>=expand('%:p')<CR><ESC>


"" additional

augroup enableAutoReloadVimrc
  autocmd!
  autocmd BufWritePost *vimrc source ${MY_VIMRC} | set foldmethod=marker
  autocmd BufWritePost *gvimrc if has('gui_running') source source ${MY_GVIMRC}
augroup END

augroup enableAutoSaveSession
  autocmd!
  autocmd VimLeave * mksession! ${MY_VIM_SESSION}
  "autocmd VimEnter * source ${MY_VIM_SESSION}
augroup END

augroup enableJumpToTheLastCursorPosition
  autocmd!
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
augroup END

augroup disableAutoFormat
  autocmd!
  autocmd BufEnter * setlocal textwidth=0
  autocmd BufEnter * setlocal formatoptions=
augroup END

" https://vim-jp.org/vim-users-jp/2009/07/12/Hack-40.html
augroup enableHighlightIdegraphicSpace
  autocmd!
  autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
  autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END

" colorscheme msut set after enableHighlightIdegraphicSpace
"colorscheme peachpuff
"colorscheme evening
colorscheme koehler
"set background=dark


"" env

" macvim
if has('mvim')

" neovim
elseif has('nvim')

endif

" gvim
if has('gui_running')
  set sessionoptions+=resize,winpos

  " maximizing window
  "autocmd GUIEnter * simalt ~x

  " menu encoding
  source ${VIMRUNTIME}/delmenu.vim
  set langmenu=ja_jp.utf-8
  source ${VIMRUNTIME}/menu.vim

  " enable clipboard
  set guioptions+=a

  " disable tool bar
  set guioptions-=T

  " disable menu bar
  set guioptions-=m

  " disable horizontal scroll bar
  set guioptions+=R
endif
