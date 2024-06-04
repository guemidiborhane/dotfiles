#!/bin/sh
# vim: set ft=sh sw=4 et :

input-remapper-control --command stop-all && input-remapper-control --command autoload
solaar config 1 dpi 800
