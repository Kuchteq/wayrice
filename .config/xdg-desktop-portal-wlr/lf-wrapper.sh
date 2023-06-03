#!/bin/sh
# IMPORTANT INFO
# THE SCRIPT REQUIRES LF config integration. Add "inportal" file to you lf config folder and include this line anywhere inside your main config (lfrc):
# cmd inportal source "~/.config/lf/inportal"
# The script also assumes you are using the foot terminal. -o gives a small padding around the terminal and -a sets the appid for the window which is helpfull for WM config files since you can more easily make the newly opened window floatable. If you are using something else, just adjust cmd variable
#
# More technical info
# This wrapper script is invoked by xdg-desktop-portal-termfilechooser.
#
# Inputs:
# 1. "1" if multiple files can be chosen, "0" otherwise.
# 2. "1" if a directory should be chosen, "0" otherwise.
# 3. "0" if opening files was requested, "1" if writing to a file was
#    requested. For example, when uploading files in Firefox, this will be "0".
#    When saving a web page in Firefox, this will be "1".
# 4. If writing to a file, this is recommended path provided by the caller. For
#    example, when saving a web page in Firefox, this will be the recommended
#    path Firefox provided, such as "~/Downloads/webpage_title.html".
#    Note that if the path already exists, we keep appending "_" to it until we
#    get a path that does not exist.
# 5. The output path, to which results should be written.
#
# Output:
# The script should print the selected paths to the output path (argument #5),
# one path per line.
# If nothing is printed, then the operation is assumed to have been canceled.

# Set default folder when download.
if [ -s "/tmp/last_saved_in_portal_folder" ]; then	
	read -r default_dir < "/tmp/last_saved_in_portal_folder"
else
	default_dir= "$HOME"
fi
multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"
cmd="/usr/bin/lf"
termcmd="/usr/bin/foot"

if [ "$save" = "1" ]; then
	set --
LF_PORTAL_ARG="$path" $termcmd -o "main.pad=10x10 center" -a "floatermid" -W "120x40" $cmd -command inportalsave "$@"
elif [ "$directory" = "1" ]; then
	set -- -selection-path "$out" "$default_dir"
$termcmd -o "main.pad=10x10 center" -a "floatermid" -W "120x40" $cmd "$@"
elif [ "$multiple" = "1" ]; then
	set -- -selection-path "$out" "$default_dir"
$termcmd -o "main.pad=10x10 center" -a "floatermid" -W "120x40" $cmd "$@"
else
	set -- -selection-path "$out" "$default_dir"
$termcmd -o "main.pad=10x10 center" -a "floatermid" -W "120x40" $cmd "$@"
	#if something has actually been uploaded 
	if [ -s "$out" ]; then
		read -r lastSaved < "$out"
		echo $(dirname "$lastSaved") > /tmp/last_saved_in_portal_folder
	fi
fi
