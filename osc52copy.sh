#!/bin/bash

# パイプで受け取った文字列を base64 にして OSC 52 でクリップボードにコピーする。
printf "\e]52;c;%s\a" "$(printf "%s" "$*" | base64 -w 0)"
