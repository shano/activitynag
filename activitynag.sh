#!/usr/bin/env bash

MAX_ALLOWED_SECONDS=3600
ACTIVITY_WATCH_URL="http://localhost:5600/api/0/query/"

today=$(date +'%Y-%m-%d')
tomorrow=$(date -d '+1 day' +'%Y-%m-%d')

json=$(cat <<-HEREDOC
{"query":[
"afk_events = query_bucket(find_bucket(\"aw-watcher-afk_\"));",
"window_events = query_bucket(find_bucket(\"aw-watcher-window_\"));",
"window_events = filter_period_intersect(window_events, filter_keyvals(afk_events, \"status\", [\"not-afk\"]));",
"duration = sum_durations(window_events);",
"RETURN = duration;"
],
"timeperiods":["$today/$tomorrow"]}
HEREDOC
)

duration_seconds_float=$(curl -s $ACTIVITY_WATCH_URL -H 'Content-Type: application/json' -d "$json" | tail -c +2 | head -c -2)
duration_seconds=$(printf %.0f "$duration_seconds_float")

if [ "$duration_seconds" -gt $MAX_ALLOWED_SECONDS ] 
then
        if zenity --question --text="You have been using your machine beyond your configured threshold of $MAX_ALLOWED_SECONDS seconds, do you want to continue?"
        then
                zenity --info --text="Ok, cool. Will nag again soon."
        else
                PATH=/usr/bin
                export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"$(id -u "$LOGNAME")"/bus
                systemd-run --user systemctl suspend
        fi
fi
