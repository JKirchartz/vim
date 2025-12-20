" autoload/pk.vim

" Add a plugin as a submodule
function! pk#Add(repo, ...) abort
  let vim_dir = split(&runtimepath, ',')[0];
  let pack_dir = empty(a:000) ? 'start' : a:000
  let plugin_name = substitute(a:repo, '.*/', '', '')
  let plugin_path = resolve(expand(vim_dir . '/pack/plugins/')) . '/' . pack_dir . '/' . plugin_name

  if isdirectory(plugin_path)
      echo plugin_name . " already installed."
      return
  endif

  call pk#RunGitCommand('submodule add --depth=1 ' . shellescape(a:repo) . ' ' . shellescape(plugin_path))
  call pk#Update()
  echo "Added plugin: " . plugin_name
endfunction

" Remove a plugin
function! pk#Remove(plugin_name_or_path) abort
  " Determine if it's a full path or plugin name
  if isdirectory(a:plugin_name_or_path)
    let plugin_path = a:plugin_name_or_path
  else
    let vim_dir = split(&runtimepath, ',')[0];
    let plugin_path = glob(resolve(expand(vim_dir . '/pack/plugins/**/')) . '/' . a:plugin_name_or_path)
    if empty(plugin_path)
      echoerr "Plugin not found: " . a:plugin_name_or_path
      return
    endif
  endif

  call pk#RunGitCommand('submodule deinit --force ' . shellescape(plugin_path))
  call pk#RunGitCommand('rm --force ' . shellescape(plugin_path))
  call pk#Update()
  echo "Removed plugin: " . plugin_path
endfunction

" Update all plugins
function! pk#Update() abort
  call pk#RunGitCommand('submodule update --init --recursive --remote --depth=1')
  echo "Updated all plugins."
endfunction

" Run a Git command in the ~/.vim directory
function! pk#RunGitCommand(cmd) abort
  let current_dir = getcwd()
  let vim_dir = split(&runtimepath, ',')[0];
  execute 'cd ' . fnameescape(resolve(expand(vim_dir)))
  let result = system('git ' . a:cmd)
  if v:shell_error
    echoerr "Error running git command: " . a:cmd
    echoerr result
  endif
  execute 'cd ' . fnameescape(current_dir)
endfunction

" Tab-completion for plugin paths
function! pk#CompletePaths(A, L, P) abort
  let vim_dir = split(&runtimepath, ',')[0];
  let plugin_dir = globpath(resolve(expand(vim_dir . '/pack/plugins/')), '**/*', 1, 1)
  let plugin_dirs = filter(plugin_dir, 'isdirectory(v:val)')

  if !empty(a:A)
    let plugin_dirs = filter(plugin_dirs, 'v:val =~ escape(a:A, "\\")')
  endif

  return plugin_dirs
endfunction
