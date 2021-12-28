# Activity Nag

This script will automatically nag you to get away from your computer after a certain period of time each day.

It will: 
1. Check how long you have been active on your machine using ActivityWatch.
2. See if you have been longer than a certain amount of time.
3. If above that time, it will ask you to confirm if you want to continue on you machine.
4. If you say no, your machine will automatically suspend.


# Requirements

* A bash shell
* Ability to run cron or some mechanism to schedule bash scripts
* [Activity Watch](https://activitywatch.net/) installed and running
* [Zenity](https://help.gnome.org/users/zenity/stable/) installed and running

# Installation

1. Download the script and make executable with `chmod +x activitynag.sh`
2. Add to your crontab with whatever interval you desire and make sure to export display correct for zenity to work. So to check/nag every minute add: `* * * * * export DISPLAY=:0 && ~/bin/activitynag.sh`
