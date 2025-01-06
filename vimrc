"}}}
" Settings
"{{{

set encoding=utf-8
scriptencoding utf-8

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
colorscheme molokai
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

" clear highlights with the rest of the screen
nnoremap <C-L> :nohlsearch<CR><C-L>

"}}}
" Plugins
"{{{

if &compatible
      set nocompatible
endif

packadd! matchit

" keep man in vim, replicate built-in functionality of the K command
runtime ftplugin/man.vim
set keywordprg=:Man

" TODO: Demo Tagbar Toggle plugin - decide to keep or delete
map <leader>t :TagbarToggle<CR>

" Make NetRW work more like NerdTree
map <leader>f <ESC>:Lexplore<CR>
" open file in previous window
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize=25
let g:netrw_liststyle=3
" let g:netrw_fastbrowse=2 " only obtain directory listings when new, ctrl+l to refresh
let g:netrw_silent=1 " be quiet
let g:netrw_special_syntax = 1
" sort is affecting only: directories on the top, files below
let g:netrw_sort_sequence = '[\/]$,*' " use the previous window to open file

" ALE settings - install linters as needed
let g:ale_completion_enabled = 1 " try ALE's built-in completion functionality
set omnifunc=ale#completion#OmniFunc

let g:ale_sign_error='✗'
let g:ale_sign_warning='❗'
let g:ale_statusline_format = ['✗ %d', '❗ %d', '✔ ok']
let g:ale_sign_column_always = 1

 let g:ale_linter_aliases = {'html': ['html', 'javascript', 'css']}
 let g:ale_linters={
       \ 'html': ['alex', 'htmlhint', 'proselint', 'stylelint', 'tidy', 'writegood', 'eslint', 'standard', 'xo', 'csslint', 'stylelint'],
       \ 'php': ['phpcs'],
       \ 'javascript': ['eslint'],
       \ 'typescript': ['tsserver', 'eslint'],
       \ 'typescriptreact': ['tsserver', 'eslint'],
       \ 'python': ['flake8', 'pylint'],
       \ 'perl': ['perl', 'syntax-check', 'perlcritic'],
       \ 'scss': ['stylelint'],
       \ 'sass': ['stylelint']
       \}
 let g:ale_fixers = {
       \ 'html': ['tidy', 'prettier'],
       \ 'javascript': ['eslint'],
       \ 'typescript': ['eslint'],
       \ 'typescriptreact': ['eslint'],
       \ 'markdown': ['prettier'],
       \ 'json': ['prettier', 'fixjson'],
       \ 'python': ['autopep8'],
       \ 'perl': ['perltidy'],
       \ 'scss': ['stylelint'],
       \ 'sass': ['stylelint']
       \}
 let g:ale_type_map = {'perlcritic': {'ES': 'WS', 'E': 'W'}}
 let g:ale_completion_tsserver_autoimport = 1 " automatic imports from external modules for typescript
 let g:ale_php_phpcs_standard = 'Wordpress'
 let g:ale_php_phpcs_use_global = 1
 let g:ale_completion_enabled = 1
 let g:ale_echo_msg_format = '[%linter%] %s [%severity%:%code%]' " show linter in messages/loclist

 " Ack settings
 let g:ackhighlight = 1 " highlight text in window (?)

 " Signify settings (a 'git gutter' and other git workflow bindings)
 set updatetime=100 " Faster sign updates on CursorHold/CursorHoldI

 nnoremap <leader>gd :SignifyDiff<cr>
 nnoremap <leader>gp :SignifyHunkDiff<cr>
 nnoremap <leader>gu :SignifyHunkUndo<cr>

 " hunk jumping
 nmap <leader>gj <plug>(signify-next-hunk)
 nmap <leader>gk <plug>(signify-prev-hunk)

 " hunk text object
 omap ic <plug>(signify-motion-inner-pending)
 xmap ic <plug>(signify-motion-inner-visual)
 omap ac <plug>(signify-motion-outer-pending)
 xmap ac <plug>(signify-motion-outer-visual)


"}}}
" custom commands
"{{{

" forgot to sudo vi? w!!
cmap w!! %!sudo tee > /dev/null %

" Send the selected text to pastebin.
" TODO - automate putting the resulting uri on the clipboard, or
" opening it in a browser.
vnoremap cb <esc>:'<,'>:w !curl -F 'clbin=<-' https://clbin.com<CR>

" Calls to fun#... have functions in ~/.vim/autoload/fun.vim
command -bar Bs call fun#ScratchBuffer()
command -bar Sb call fun#ScratchBuffer()
command -bar Scratch call fun#ScratchBuffer()

" romainl's Redir
command! -nargs=1 -complete=command -bar -range Redir silent call fun#Redir(<q-args>, <range>, <line1>, <line2>)

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

map <leader>r :registers<cr>


" fix windows ^M characters when encodings mess up
" ( ala http://amix.dk/vim/vimrc.html )
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

"}}}
" Autocmds
"{{{

if has("autocmd")
  " Use correct indenting for python
  autocmd FileType python setlocal shiftwidth=2 softtabstop=2 expandtab
  " perl template syntax
  autocmd BufRead */template/* set syntax=mason
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
  " autocmd BufWritePre * silent! %s:\(\S*\) \+$:\1:
  " a safer alternative to `set autochdir`
  " autocmd BufEnter * silent! lcd %:p:h
  " skeleton/template files
  au BufNewFile *.sh 0r ~/.vim/skeletons/sh
  au BufNewFile *.htm 0r ~/.vim/skeletons/htm
  au BufNewFile *.html 0r ~/.vim/skeletons/html
  au BufNewFile {_draft,_post}/*.md 0r ~/.vim/skeleton/blog.md
  " if a file starts with a shebang, automatically make it executable
  au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent !chmod +x <afile> | endif | endif
  " open git diff in a vertical split and move it to the right, keeping the
  " cursor on the left in the commit message
  autocmd FileType gitcommit silent execute "vert Git diff --cached | wincmd x"
  " if you remove vim-signify, remove this and the function from ~/.vim/autoload/fun.vim too
  autocmd User SignifyHunk call fun#show_current_hunk()

endif

" }}}
" Load Plugins & Helptags
" {{{

packloadall " load plugins
silent! helptags ALL " import helptags for plugins

" Automatically fold perl subs
set foldmethod=syntax
set foldlevelstart=1
let perl_fold=1

"vim:foldmethod=marker
