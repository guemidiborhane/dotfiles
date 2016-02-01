#!/bin/bash
echo [$@]
echo "command=xdg-open \"https://rubygems.org/search?utf8=✓&query=$@\""
echo "icon="
echo "subtext=Search on RubyGems for $@"
