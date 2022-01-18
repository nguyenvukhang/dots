running=$(pidof spotify)
if [ "$running" != "" ]; then
    artist=$(playerctl -p "spotify" metadata artist)
    song=$(playerctl -p "spotify" metadata title | cut -c 1-60)
    if [ "$song" != "" ]; then
        echo -n "$artist <fc=#888888>・</fc> $song <fc=#666666> |  </fc>"
    fi
fi
