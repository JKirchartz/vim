"-----------------------------------------------------
" Various helper functions formerly in my vimrc, firstly:
"
" Toggle between number settings
"-------------------------------------------------------{{{
function! fun#NumberToggle()
  if &relativenumber == 1 && &number == 1
    set norelativenumber
    set nonumber
  elseif &relativenumber == 0 && &number == 1
    set relativenumber
  else
    set number
  endif
endfunc

"}}}-----------------------------------------------------
" Step through a list of colorschemes
"-------------------------------------------------------{{{

let g:colorNumber = 0
function! fun#ColorSchemeToggle()
  if exists("g:colorNumber")
    if !exists("g:colorSchemes")
      " default to schemes that ship with vim
      let g:colorSchemes = ["darkblue", "delek", "elflord", "industry", "morning", "pablo", "ron", "slate", "zellner", "blue", "default", "desert", "evening", "koehler", "murphy", "peachpuff", "shine", "torte"]
    else
      execute 'colorscheme ' . g:colorSchemes[g:colorNumber]
      let g:colorNumber = (g:colorNumber + 1) % len(g:colorSchemes)
    endif
  endif
endfunction


"}}}-----------------------------------------------------
" Create an empty buffer for temporary data, etc
"-------------------------------------------------------{{{
function! fun#ScratchBuffer()
  exe ':new'
  exe ':setlocal buftype=nofile'
  exe ':setlocal bufhidden=hide'
  exe ':setlocal noswapfile'
endfunc


"}}}-----------------------------------------------------
" Delete Duplicate Lines
"-------------------------------------------------------{{{
function! fun#DeleteDuplicateLines()
        %!awk 'seen[$0]++ == 0'
endfunction

"}}}-----------------------------------------------------
" Delete HTML/XML tags
"-------------------------------------------------------{{{
function! fun#DeleteHTMLTags()
        :%s/<\_.\{-1,\}>//g
endfunction

"}}}-----------------------------------------------------
" Hexmode, via http://vim.wikia.com/wiki/Improved_Hex_editing
"-------------------------------------------------------{{{

function fun#ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    silent :e " this will reload the file without trickeries
              "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction


"}}}--------------------------------------------------
" Append height/width of image in current line
"-------------------------------------------------------{{{
function! fun#ImageSize()
  let imgcmd = 'identify -format "width:%[w]px;\nheight:%[h]px;" '
  " let line = split(getline('.'), "'")
  " let filename = line[1]
  let filename = expand('<cfile>')
  " this may work better than split, with some jiggering: echo matchstr(getline('.'),"'\\zs\\f\\+\\ze'")
  let imgsize = system(imgcmd . filename)
  call append(line('.'), split(imgsize, '\v\n'))
  norm j2==
endfunction

"}}}--------------------------------------------------
" get most prominent color if image in current line
"-------------------------------------------------------{{{

" convert fed_8282_clover_160x600_frame2-overlay.png -format %c -depth 8 histogram:info: | sort -n | tail -1 | cut -d' ' -f10,11
function! fun#ImageColor()
  let imgcmd = 'convert'
  let imgcmd2 = '-format %c -depth 8 histogram:info: | sort -n | tail -1 | cut -d\' \' -f10,11'
  let line = split(getline('.'), "'")
  let filename = line[1]
  let imgsize = system(imgcmd . filename)
  call append(line('.'), split(imgsize, '\v\n'))
  norm j==
endfunction


" }}}---------------------------------------------------
" Reset Highlights (ala https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f )
" ----------------------------------------------------{{{

function! fun#FixHighlights() abort
  highlight Normal ctermbg=None
  highlight NonText ctermbg=None
endfunction

" }}}----------------------------------------------------
" Concealer (conceal characters with utf-8 equivalents ala Fira Code)
" ----------------------------------------------------{{{

function! fun#Concealer()
  syntax match Equals "===" conceal cchar=≡
  syntax match NotEquals "!==" conceal cchar=≠
  syntax match FatDoubleArrow "<=>" conceal cchar=⇔
  syntax match GreaterThan ">=" conceal cchar=≥
  syntax match LessThan "<=" conceal cchar=≤
  syntax match FatArrow "=>" conceal cchar=➾
  hi! link Conceal Equals
  hi! link Conceal NotEquals
  hi! link Conceal FatDoubleArrow
  hi! link Conceal GreaterThan
  hi! link Conceal LessThan
  hi! link Conceal FatArrow
  setlocal conceallevel=1
endfunction

" }}}----------------------------------------------------
" Redirect the output of a Vim or external command into a scratch buffer
" from https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
" ----------------------------------------------------{{{

function! fun#Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		let cmd = a:cmd =~' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			let output = systemlist(cmd)
		else
			let joined_lines = join(getline(a:start, a:end), '\n')
			let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
			let output = systemlist(cmd . " <<< $" . cleaned_lines)
		endif
	else
		redir => output
		execute a:cmd
		redir END
		let output = split(output, "\n")
	endif
	vnew
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, output)
endfunction

" }}}----------------------------------------------------
" Add Git Diff Hunk counter to statusbar from `:help signify`
" ----------------------------------------------------{{{

 function! fun#show_current_hunk() abort
			 let h = sy#util#get_hunk_stats()
			 if !empty(h)
						 echo printf('[Hunk %d/%d]', h.current_hunk, h.total_hunks)
			 endif
 endfunction

" }}} fold up this file
" vim:foldmethod=marker
