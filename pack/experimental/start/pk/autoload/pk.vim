" autoload/pk.vim
function! pk#add(repo, pack_dir)
  let l:pack_dir = empty(a:pack_dir) ? 'start' : a:pack_dir
  let l:plugin_name = substitute(a:repo, '.*/', '', '')
  let l:plugin_path = expand('~/.vim/pack/plugins/') . l:pack_dir . '/' . l:plugin_name

  call pk#run_git_command('submodule add --depth=1 ' . shellescape(a:repo) . ' ' . shellescape(l:plugin_path))
  call pk#update()
endfunction

function! pk#remove(plugin_path)
  call pk#run_git_command('submodule deinit --force ' . shellescape(a:plugin_path))
  call pk#run_git_command('rm --force ' . shellescape(a:plugin_path))
  call pk#update()
endfunction

function! pk#update()
  call pk#run_git_command('submodule update --init --recursive --remote --depth=1')
endfunction

function! pk#run_git_command(cmd)
  let l:current_dir = getcwd()
  execute 'cd ' . fnameescape(expand('~/.vim/')) " only run commands from vim's root directory
  let l:result = system('git ' . a:cmd)
  if v:shell_error
    echoerr "Error running git command: " . a:cmd
    echoerr l:result
  endif
  execute 'cd ' . fnameescape(l:current_dir) " return to current directory
endfunction

