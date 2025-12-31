Pk.vim
======

I'm not sure if this plugin actually works yet... it's just an experiment... but I wanted to have ONE commit on the branch I'm making to preserve and highlight this thing...

Pk.vim is a stupid plugin manager that assumes all your plugins are equally stupid git repositories.

Pk.vim is based on this shell script that only manages git submodules; and probably breaks if you try to use a specific git branch or something.

```bash
#! /bin/bash
#
# pk: the stupid package manager
#
# Copyleft (ↄ) 2021 jkirchartz <me@jkirchartz.com>
#
# Distributed under terms of the NPL (Necessary Public License) license.
#

shopt -s extglob

function add {
  git submodule add "$1" "pack/plugins/$2/${1//+(*\/|.*)}" $3
}

function remove {
  git rm $1
}

function update {
  git submodule update --init --recursive --remote
}

case $1 in
  add)
    add "$2" "${3:-start}" "${@:3}";
    update;
    ;;
  remove)
    git submodule deinit "${@:2}" --force
    git rm "${@:2}" --force
    update
    ;;
  update) update;;
  help|*)
    echo 'pk add <git repo for plugin> [pack directory (defaults to start)]';
    echo 'pk remove pack/plugins/<directory>/<plugin>';
    echo 'update';
    ;;
esac
```

for more information see [doc/pk.txt](doc/pk.txt).
