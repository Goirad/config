#!/bin/bash
# Lock screen displaying this image.
i3lock -e -t -i /usr/share/backgrounds/hardy_wallpaper_uhd.png &
# Turn the screen off after a delay.
echo "$(date) locked" >> ~/locklog
sleep 20
while pgrep i3lock >/dev/null; do
    while [ $(xprintidle) -lt 20000 ]; do
        sleep 1
    done # idle for at least 20 seconds
    if pgrep i3lock >/dev/null; then
        xset dpms force off && sleep 5 # Avoid spinning after 20s
    fi
done
echo "$(date) exited" >> ~/locklog
