#!/bin/sh
rm -f ghostlib.zip
zip -r ghostlib.zip src *.md *.json *.hxml run.n
haxelib submit ghostlib.zip $HAXELIB_PWD --always