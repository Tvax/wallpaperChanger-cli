#!/bin/bash

spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

if [ -z "$1" ]; then
    RANGE=3
    number=$RANDOM
    let "number %= $RANGE"

    case $number in
        "0") query='nature';;
        "1") query='sunset';;
    	  "2") query='mountain';;
        *) query='nature';;
    esac
else
    query=${1}
fi

printf 'Hitting the API '
spinner &
spinner_pid=$!

url=$(curl -H "Authorization: Bearer d1d21525dd7d52dc4f608a06c458031ac4a427cc06de40b347eb90802a1d1fa7" https://api.unsplash.com/photos/random?query=${query} 2>/dev/null | grep -Po '"raw":.*?[^\\]",' | cut -d'"' -f4);
wget ${url} -O $HOME/Pictures/wallpaper.jpg 2>/dev/null
if [[ $? -ne 0 ]]
then
    kill $spinner_pid &>/dev/null
    echo
    echo "Error fetching your image, try again or change your query !"
    exit 1
fi

gsettings set org.gnome.desktop.background picture-uri file:${HOME}/Pictures/wallpaper.jpg;
kill $spinner_pid &>/dev/null
echo
echo "Today's theme : ${query}";
exit 0
