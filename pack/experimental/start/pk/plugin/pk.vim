" plugin/pk.vim
if exists("g:loaded_pk")
  finish
endif
let g:loaded_pk = 1

if !exists("g:pk_plugin_base_dir")
    let g:pk_plugin_base_dir = expand("~/.vim/pack/plugins")
endif

" Add a plugin
command! -nargs=+ PkAdd call pk#Add(<f-args>)

" Remove a plugin
command! -nargs=? -complete=customlist,pk#CompletePaths PkRemove call pk#Remove(<f-args>)

" Update all plugins
command! PkUpdate call pk#Update()
