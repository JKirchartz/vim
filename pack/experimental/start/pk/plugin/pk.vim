" plugin/pk.vim
if exists("g:loaded_pk")
  finish
endif
let g:loaded_pk = 1

" Define commands
command! -nargs=+ PkAdd call pk#add(<f-args>)
command! -nargs=1 PkRemove call pk#remove(<f-args>)
command! PkUpdate call pk#update()
