#!/bin/bash
echo [$@]
echo "command=xdg-open \"http://devdocs.io/#q=$@\""
echo "icon="
echo "subtext=Search on DevDocs for $@"
