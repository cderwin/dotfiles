filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-vinegar'
Plugin 'elixir-lang/vim-elixir'
Plugin 'rust-lang/rust.vim'
Plugin 'fatih/vim-go'
Plugin 'othree/yajs.vim'
Plugin 'othree/es.next.syntax.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'hdima/python-syntax'
call vundle#end()            " required
filetype plugin indent on " Fix this shit

" Activate vim powerline
" python from powerline.vim import setup as powerline_setup
" python powerline_setup()
" python del powerline_setup

" Turn on syntax highlghting
syntax on

" Allow buffers to be open but hidden (in the background)
set hidden

" Show partial commands in the last line of the screen
set showcmd

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

"------------------------------------------------------------
" Begin Custom Commands
"
"------------------------------------------------------------

let mapleader=","
let maplocalleader="\\"

" Indentation
set shiftwidth=4
set softtabstop=4
set tabstop=4
set shiftround
set expandtab
set autoindent
set smarttab

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
nnoremap Y y$

" Map <subtopic-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <subtopic-L> :nohl<CR><subtopic-L>

" Swapping text shortcuts
nnoremap gc xp
nnoremap gC xP
nnoremap g$ ddp
nnoremap g^ ddkP

" capitalize a word with Ctrl-u
inoremap <c-u> <esc>viwUi
nnoremap <c-u> viwU

" Insert blank lines
nnoremap <Leader>o o<esc>k
nnoremap <Leader>O O<esc>j
nnoremap <cr> i

" Make it easier to (Make it easier to (edit my ~/.vimrc))
noremap <Leader>v :vsplit $MYVIMRC<cr><C-L>
noremap <Leader>V :source $MYVIMRC<cr>

" Moving around
nnoremap <s-l> gt
nnoremap <s-h> gT

" Save/quitting files
nnoremap <Leader>q :q<cr>
nnoremap <Leader>s :w<cr>
nnoremap <Leader>sq :wq<cr>
nnoremap <Leader><Leader> :w<cr>
inoremap <Leader>s <esc>:w<cr>i
inoremap <Leader>S <esc>:w<cr>
inoremap <Leader><Leader> <esc>:w<cr>

" Shortcuts for macros
nnoremap Q @q

" Set wildignore for ctrlp
set wildignore+=*/.git/*,*.pyc,*.pyo,.*.sw*

" Open the file manager in a new tab
nnoremap <Leader>t :Tex<cr>
nnoremap <Leader>b :tabe term://.//bash<cr>

if has('nvim')
    tnoremap <Esc> <C-\><C-n>
endif
