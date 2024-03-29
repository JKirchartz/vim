if !exists('s:bigrams')
  let s:bigrams="/tmp/vim-bigrams.list"
endif

function! Bigramcomplete#ClearCorpus()
  silent system("rm -rf " . shellescape(s:bigrams));
endfun

" add corpus to bigram list:
function! Bigramcomplete#AddCorpus(filename)
  " silent redraw
  :silent execute("!awk '{for (i=1; i<NF; i++) print $i, $(i+1)}' " . shellescape(a:filename) . " >> " . shellescape(s:bigrams))
  " silent system("awk '{for (i=1; i<NF; i++) print $i, $(i+1)}' " . shellescape(a:filename) . " \| tr -sc '[A-Z][a-z]' '[\\012*]' \| sed -e 's/^[ \t]*//' -e 's/[ \t]/ /' >> " . shellescape(s:bigrams))
  " Read the file
  let lines = readfile(s:bigrams)

  " Sort the lines alphabetically and remove duplicates
  let sorted_lines = sort(lines, 'strcmp')
  let deduplicated_lines = uniq(sorted_lines)

  " Write the sorted and deduplicated lines back to the file
  call writefile(deduplicated_lines, s:bigrams)
  " silent redraw
endfun

" completion engine:
function! Bigramcomplete#Completer(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && (line[start - 1] =~ '\a' || line[start - 1] =~ '.' || line[start - 1] =~ '-')
      let start -= 1
    endwhile
    return start
  else
    " find bigrams matching "a:base"
    let res = []
    for m in split(readfile(s:bigrams), '\n')
      if m =~ '^' . a:base
        call add(res, m)
      endif
    endfor
    return res
  endif
endfun

command! -nargs=1 -complete=file BigramsAdd call Bigramcomplete#AddCorpus(<q-args>)

command! -nargs=+ BigramClear call Bigramcomplete#ClearCorpus()
command! -nargs=+ BigramComplete call Bigramcomplete#Completer(<q-args>)
