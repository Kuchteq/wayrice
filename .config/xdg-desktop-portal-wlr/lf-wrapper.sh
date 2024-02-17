#!/bin/sh
# IMPORTANT INFO
# THE SCRIPT REQUIRES LF config integration. Add "inportal" file to you lf config folder and include this line anywhere inside your main config (lfrc):
# cmd inportal source "~/.config/lf/inportal"
# The script also assumes you are using the foot terminal. -o gives a small padding around the terminal and -a sets the appid for the window which is helpfull for WM config files since you can more easily make the newly selected window floatable. If you are using something else, just adjust cmd variable
#
# More technical info
# This wrapper script is invoked by xdg-desktop-portal-termfilechooser.
#
# Inputs:
# 1. "1" if multiple files can be chosen, "0" otherwise.
# 2. "1" if a directory should be chosen, "0" otherwise.
# 3. "0" if selecting files was requested, "1" if writing to a file was
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

multiple="$1"
directory="$2"
save="$3"
path="$4"
cmd="/usr/bin/lf"
termcmd="/usr/bin/foot"
lfxdgbasedir=~/.config/lf/xdg-filepicker
termsize='-W 120x36'
paddingsize='-o main.pad=10x10 center'
[ -f ~/.config/fzf/fzfrc ] && source ~/.config/fzf/fzfrc

if [ "$save" = "1" ]; then
	#make the saving appear in the last path
	set -- "$(dirname "$path")"
        FILENAME="$(basename "$path")"
        $termcmd "$paddingsize" -a "floatermid" "$termsize" $cmd \
        -command "set user_filename '$FILENAME'" \
        -command "source $lfxdgbasedir/save" "$@"
elif [ "$directory" = "1" ] && [ "$multiple" = "1" ] ; then
            $termcmd "$paddingsize" -a "floatermid" "$termsize" $cmd \
            -command "source $lfxdgbasedir/selectanything" 
elif [ "$directory" = "1" ]; then
            $termcmd "$paddingsize" -a "floatermid" "$termsize" $cmd \
            -command "source $lfxdgbasedir/selectdir" 
elif [ "$multiple" = "1" ]; then
            $termcmd "$paddingsize" -a "floatermid" "$termsize" $cmd \
            -command "source $lfxdgbasedir/selectfiles"
else
            $termcmd "$paddingsize" -a "floatermid" "$termsize" $cmd \
            -command "source $lfxdgbasedir/selectfile"
fi
