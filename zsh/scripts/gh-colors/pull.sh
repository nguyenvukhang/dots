#!/bin/sh

# github repo: https://github.com/github/linguist
# relative path: /lib/linguist/languages.yml

url="https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml"
curl -fLo languages.yml $url
