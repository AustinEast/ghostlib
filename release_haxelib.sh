#!/bin/sh
rm -f ghostlib.zip
zip -r ghostlib.zip ghost *.md *.json *.hxml run.n
haxelib submit ghostlib.zip $HAXELIB_PWD --always