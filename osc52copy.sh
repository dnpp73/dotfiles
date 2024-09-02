#!/bin/bash

# パイプで受け取った文字列を base64 にして OSC 52 でクリップボードにコピーする。
content="$(cat /dev/stdin)"
if [ -z "${content}" ]; then
    exit
fi
b64content="$(echo "${content}" | base64 -w 0)"
printf "\e]52;c;%s\a" "${b64content}"
