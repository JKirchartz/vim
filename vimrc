"}}}
" Settings
"{{{

" map leader to space
nnoremap <Space> <Nop>
let mapleader = " "
" (Why doesn't space, the largest key, simply eat the other 108?)

set ffs=unix,mac,dos " Set default filetypes in descending wrongness
set clipboard^=unnamed,unnamedplus
set nobackup noswapfile " live dangerously
set lazyredraw " don't redraw screen while executing macros etc.
set hidden " allow unwritten buffers (unsaved files) to hide in the background
set number " show line number
set shortmess=atI " abbreviate or avoid certain messages
set noerrorbells " hear no evil
set novisualbell " see no evil
set list " show whitespace (using textmate-like symbols in the next line)
set listchars=conceal:×,tab:->,nbsp:∙,trail:•,extends:»,precedes:«,eol:¬
set smartcase " smart case matching
set hlsearch  " highlight search
set ignorecase " make /foo match FOO & FOo but /FOO only match FOO
" set mouse=a " enable mouse. how quaint.
set backspace=indent,eol,start " fix backspace(?)
" allow files to tell vim about themselves:
set modeline
set modelines=2

" better menu like for autocomplete
set wildmenu
set complete+=kspell
set completeopt+=menu,longest
set dictionary+=/usr/share/dict/words

" Tabs & Indents (tabs are 2 spaces... or else)
set shiftround shiftwidth=2 softtabstop=2 expandtab

" 80 columns
set nowrap " don't soft-wrap
set colorcolumn=80 " show me what's TOO far

if has('persistent_undo')
  " save undos, so you can actually close vim without erasing the undo tree!
  silent call system('mkdir -p /tmp/vim_undo')
  set undodir=/tmp/vim_undo
  set undofile
endif

" Setup colors/theme
set laststatus=2 " see the last statusline(stl)
" show modes & commands in stl
set showmode showcmd
" show cursor position (like :set ruler) & git status in statusline
set statusline=\ b%n\ %<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" faster Macro (at the expense of ex mode)
noremap Q @q

" Avoid the esc key
inoremap <silent> <Up> <ESC>k
inoremap <silent> <Down> <ESC>j
inoremap <silent> <Left> <ESC>h
inoremap <silent> <Right> <ESC>l


"}}}
" Plugins
"{{{

set nocompatible
filetype plugin on

packadd! matchit

" keep man in vim, replicate built-in functionality of the K command
runtime ftplugin/man.vim
set keywordprg=:Man

" Make NetRW work more like NerdTree
map <leader>t <ESC>:Lexplore<CR>
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize=25
let g:netrw_liststyle=3
" sort is affecting only: directories on the top, files below
let g:netrw_sort_sequence = '[\/]$,*' " use the previous window to open file
" open file in previous window
let g:netrw_browse_split = 4

"}}}
" custom commands
"{{{

" forgot to sudo vi? w!!
cmap w!! %!sudo tee > /dev/null %

" Send the selected text to pastebin.
" TODO - automate putting the resulting uri on the clipboard, or
" at least opening it in a browser.
vnoremap cb <esc>:'<,'>:w !curl -F 'clbin=<-' https://clbin.com<CR>

" Calls to fun#... have functions in ~/.vim/autoload/fun.vim
command -bar Bs call fun#ScratchBuffer()
command -bar Sb call fun#ScratchBuffer()
command -bar Scratch call fun#ScratchBuffer()

" get image sizes
command -bar ImageSize call fun#ImageSize()


"}}}
" leader shortcuts
"{{{

" stop cycling when you can fly
nmap <leader>b :ls<CR>:b<space>

" toggle through preset list of colorschemes
nnoremap <leader>c :call fun#ColorSchemeToggle()<cr>

" toggle Hexmode
nmap <leader>h :call fun#ToggleHex()<CR>

"toggle number relativity
nmap <leader>n :call fun#NumberToggle()<CR>

" toggle whitespace
nmap <leader>l :set list!<CR>

" write quickly (autocmd deletes trailing spaces (not tabs))
nmap <leader><leader> :w<CR>

" spell checking
map <leader>s :setlocal spell spelllang=en_us<cr>


" fix windows ^M characters when encodings mess up
" ( ala http://amix.dk/vim/vimrc.html )
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

"}}}
" Autocmds
"{{{

if has("autocmd")
  " Use correct indenting for python
  autocmd FileType python setlocal shiftwidth=2 softtabstop=2 expandtab
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix
  " Use correct indenting for YAML
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  " Jump to last position when reopening files
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif
  " Set title to filename (or something IDK, it's been off for a while)
  "au BufEnter * let &titlestring = ' ' . expand("%:t")
  " ensure background is transparent
  autocmd ColorScheme * call fun#FixHighlights()
  " conceal comparators with utf-8 equivalents
  autocmd Syntax * call fun#Concealer()
  autocmd BufNewFile,BufReadPost *.md setlocal filetype=markdown
  " trim trailing spaces (not tabs) before write
  autocmd BufWritePre * silent! %s:\(\S*\) \+$:\1:
  " a safer alternative to `set autochdir`
  " autocmd BufEnter * silent! lcd %:p:h
  " if a file starts with a shebang, automatically make it executable
  au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent !chmod +x <afile> | endif | endif
endif

"vim:foldmethod=marker
