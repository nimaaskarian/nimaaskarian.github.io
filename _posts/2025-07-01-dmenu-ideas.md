# dmenu ideas
this is some dmenu scripts and ideas to use dmenu with everything.

# what is dmenu?
[dmenu](https://tools.suckless.org/dmenu/) is a minimal X launcher, that lets
you select files from stdin. the modularity of it allows you to be able to use
it with almost anything.

## aliases for bookmarks
in order to have aliases for your browser bookmarks, you can have the script
below in your `PATH`, as `tabsh` for example. you can change the `BROWSER`
variable as you wish.

```bash
#!/bin/bash
BROWSER=${BROWSER:-thorium-browser}

trans() {
  [ "$1" ] && echo "https://translate.google.com/?sl=en&tl=de&text=$1" ||  echo "http://translate.google.com"
}

goje() {
  echo "http://localhost:7900"
}

aw() {
  echo "http://localhost:5600"
}

syncthing() {
  echo "http://localhost:8384"
}

pe() {
  re='^[0-9]+$'
  if [[ $1 =~ $re ]] ; then
     echo "https://projecteuler.net/problem=$1"
   else
     echo "https://projecteuler.net/$1"
  fi
}

col() {
  echo "https://colemak.academy"
}

sch() {
  echo "https://scholar.google.com/scholar?hl=en&as_sdt=0%2C5&q=$1&btnG="
}

gh() {
  echo "https://github.com/$1"
}

lib() {
  if [ "$1" ]; then
    echo "https://libgen.is/search.php?req=$1"
  else
    echo https://libgen.li/
  fi
}

lh() {
  if [ "$1" ]; then
    echo "http://localhost:$1"
  else
    echo "http://localhost:8000"
  fi
}

gm() {
  echo "https://meet.google.com/$1"
}

ddg() {
  echo "https://duckduckgo.com/?q=$1"
}

yt() {
  if [ "$1" ]; then
    echo "https://youtube.com/results?search_query=$1"
  else
    echo "https://youtube.com"
  fi
}

url_or_search() {
  if echo "$1" | grep -E ".*\..*" &> /dev/null; then
    echo "$1"
  else
    ddg "$1"
  fi
}

cmd="$1"
args="${*:2}"

commands=$(declare -F | cut -f 3 -d ' ')
if [ "$cmd" = "ls-commands" ]; then
  for cmd in $commands; do
    echo $cmd
  done
else
  [[ $commands =~ ${cmd}  ]] || {
    cmd="url_or_search"
    args="$*"
  }
  exec $BROWSER "$($cmd "$args")"&> /dev/null & disown 
fi
```

in the script above you can define bash functions for each of the websites you
may wanna alias. if the first argument is `ls-commands`, it lists all the
functions available using `declare`. 

you can use the script below along with the script above to have `tabsh` in
dmenu.

```bash
#!/bin/sh

sel=$(tabsh ls-commands | dmenu -p tabsh "$@") || exit 1
tabsh $sel
```

## password manager
you can use `passmenu`, for `pass`. set PINENTRY_USER_DATA=gtk with a custom
script.

## movie manager
```bash
#!/usr/bin/env bash

cd ~/Movies || exit 1
{
  fd -tf -e mp4 -e mkv
  cat links2movies
} | dmenu "$@" | xargs mpv
```

## br [^2] manager
it exists as `brmenu` in [br's repository](https://github.com/nimaaskarian/br)

[^2]: the very script i am using to write this

## password and text-to-copy manager
note that pinentry-program is set to be a script that reads the
`$PINENTRY_USER_DATA` variable, inside `~/.gnupg/gpg-agent.conf`.
```bash
#!/usr/bin/env bash

cd ~/Texts || exit 1
sel=$(fd . -tf | dmenu "$@") || exit 1
if [[ "$sel" == *.gpg ]]; then
  PINENTRY_USER_DATA=gtk gpg -d "$sel" | xclip -selection c
else
  xclip -selection c < "$sel"
fi

```

## series manager using [bw](https://github.com/nimaaskarian/bw)
```bash
#!/usr/bin/env bash

name=$(bw --print-mode name | dmenu -i -p series "$@") || exit 1
path=~/.cache/bingewatcher/"$name.bw"
next_episode=$(bw "$path" --print-mode next-episode)

readarray -t arr  < <(grep "$name.*$next_episode" links2series)
if [ "${#arr[@]}" == 1 ]; then
  sel=${arr[0]}
else
  sel=$(printf "%s\n" "${arr[@]}" | dmenu -i -p qualities) || exit 1
fi
mpv "$sel" && bw "$path" -a 1
```


# inspirations
[sgauthier.fr/blog/minimalism_1_dmenu](https://sgauthier.fr/blog/minimalism_1_dmenu.html)
