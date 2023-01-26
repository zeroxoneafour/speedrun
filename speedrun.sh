#!/bin/sh
# Run games extra fast

version=0.1.0

if [ -z "$XDG_CONFIG_HOME" ]; then
	XDG_CONFIG_HOME=$HOME/.config
fi

if [ -z "$1" ]; then
	echo "$(cat << EOF
Syntax - $0 <app to run>

Configured in
* /etc/speedrun.conf
* $XDG_CONFIG_HOME/speedrun/speedrun.conf
* $XDG_CONFIG_HOME/speedrun/<app to run>.conf
* $(pwd)/.speedrun.conf

Latest log output to /tmp/speedrun.log
EOF
	)" >&2
	exit 1
fi

if ! command -v $1 > /dev/null; then
	echo "Command not found!"
	exit 1
fi

log=/tmp/speedrun.log

mangohud=true
prime=true
gamemode=true
debug=false
pre_run=""
wrapper=""
post_run=""

files_checked=""
files_unchecked=""
for file in "/etc/speedrun.conf" "$XDG_CONFIG_HOME/speedrun/speedrun.conf" "$XDG_CONFIG_HOME/speedrun/$1.conf" "$(pwd)/.speedrun.conf"; do
	if [ -f $file ]; then
		. $file
		files_checked="$files_checked $file"
	else
		files_unchecked="$files_unchecked $file"
	fi
done

if ! command -v mangohud > /dev/null; then
	mangohud=false
fi
if ! command -v prime-run > /dev/null; then
	prime=false
fi
if ! command -v gamemoderun > /dev/null; then
	gamemode=false
fi

if [ $mangohud = true ]; then
	mangohud_path=$(command -v mangohud);
else
	mangohud_path=""
fi
if [ $prime = true ]; then
	prime_path=$(command -v prime-run);
else
	prime_path=""
fi
if [ $gamemode = true ]; then
	gamemode_path=$(command -v gamemoderun);
else
	gamemode_path=""
fi

full_cmd="$wrapper $gamemode_path $prime_path $mangohud_path $@"

if [ $debug = true ]; then
	rm $log
	touch $log
	echo "Running speedrun $version at $(date)" >> $log
	echo "Command: $@" >> $log
	echo "Loaded configs at$files_checked" >> $log
	echo "Could not find configs at$files_unchecked" >> $log
	if [ $mangohud = true ]; then
		echo "Loading mangohud at $mangohud_path" >> $log
	else
		echo "Not loading mangohud" >> $log
	fi
	if [ $prime = true ]; then
		echo "Loading prime at $(command -v prime-run)" >> $log
	else
		echo "Not loading prime" >> $log
	fi
	if [ $gamemode = true ]; then
		echo "Loading gamemode at $(command -v gamemoderun)" >> $log
	else
		echo "Not loading gamemode" >> $log
	fi
	echo "Pre-run commands: $pre_run" >> $log
	echo "Wrapper commands: $wrapper" >> $log
	echo "Post-run commands: $post_run" >> $log
	echo "Full command: $full_cmd" >> $log
	echo "" >> $log
	echo "----- Command output -----" >> $log
	echo "" >> $log
fi

$pre_run
if [ $debug = true ]; then
	$full_cmd >> $log 2>&1
else
	$full_cmd
fi
$post_run

exit 0
