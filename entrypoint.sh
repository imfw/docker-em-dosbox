#!/usr/bin/env bash

build_games(){
  cd /em-dosbox/src/ 
  ./packager.py lines /games/lines LINES.EXE
  ./packager.py majon /games/majon DE.EXE
  ./packager.py goblins1 /games/goblins1 GO.BAT
  ./packager.py goblins2 /games/goblins2 GO.BAT
  ./packager.py goblins3 /games/goblins3 GOB3.EXE
  ./packager.py heroes2 /games/HEROES2 HEROES2.EXE
}

copy_files(){
  cp /em-dosbox/src/dosbox.js /html
  cp /em-dosbox/src/dosbox.html.mem /html
  cp /em-dosbox/src/*lines* /html
  cp /em-dosbox/src/*majon* /html
  cp /em-dosbox/src/*goblins1* /html
  cp /em-dosbox/src/*goblins2* /html
  cp /em-dosbox/src/*goblins3* /html
  cp /em-dosbox/src/*heroes2* /html
}

case "$1" in
"copy")
  build_games
  copy_files
  exit 1
  ;;
"serve")
  build_games
  copy_files
  cd /html
  python -m SimpleHTTPServer
  ;;
*)
  exec "$@"
  ;;
esac
