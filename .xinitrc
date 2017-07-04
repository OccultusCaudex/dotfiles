#!/bin/sh
exec i3
exec xrandr --output LVDS-1 --mode 1440x900
exec --no-startup-id feh --bg-max /home/maps/weebPaper.jpg
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

twm &
xclock -geometry 50x50-1+1 &
xterm -geometry 80x50+494+51 &
xterm -geometry 80x20+494-0 &
exec xterm -geometry 80x66+0+0 -name login
exec xrandr --output LVDS-1 --mode 1440x900
exec i3
sh ~/.fehbg &
exec feh --bg-scale /home/maps/weebPaper.jpg
[[ -f ~/.Xdefaults ]] && xrdb -merge ~/.Xdefaults

# Meta Keys:
# The ECMA-35 standard prefixes control sequences containing a high
# eighth-bit with <Esc> to disambiguate from unicode input, which also
# utilizes a high eigth-bit (overlapping ranges). This necessitates
# the use of timings to differentiate and <Esc>-prefixes control
# sequence and <Esc> preceding unrelated keys. Unfortunately the
# timing mechanism is unable to differentiate between macros and
# bindings from actual control sequences as in all cases timing is
# near-zero. Furthermore programs without accurate timers break
# unexpectedly and often randomly, such as vim. Neovim can be
# configured without any breakage, as can tmux. However it is simpler
# - if willing to forego working unicode input - to simply disble
# ECMA-35 and send meta-sequences as eight-bit high.
# Unfortunately URxvt simply passes eight-bit high control-sequences
# untouched, letting higher layers assume they are the beginning of
# unicode byte-sequences. This breaks these sequences. XTerm avoids
# this ambiguity by automatically converting the eight-bit high
# control sequence to appropriate byte sequences using the current
# locale. URxvt can be harcoded to mimic this behaviour, but not in a
# locale-independent fashion. If locales change, the following
# bindings will be broken.
# Summary:
#   * Specific to the current locale
#   * Breaks UTF-8 input

read -r -d '' PyURxvtMeta8 <<-'EOF'
	#!/usr/bin/env python3
	
	import locale
	
	locale.setlocale(locale.LC_ALL, "")
	encoding = locale.getlocale()[1]
	
	# ASCII range
	for i in range(32, 128):
	    seq = "".join("\{:o}".format(j) for j in chr(i + (1<<7)).encode(encoding))
	    key = "{:#06X}".format(i)
	    print("urxvt*keysym.Meta-{}: {}".format(key, seq))

#xrdb -merge <(python3 <<<"$PyURxvtMeta8")

# Settings for Japanese input
#export GTK_IM_MODULE='ibus'
#export QT_IM_MODULE='ibus'
#export XMODIFIERS=@im='ibus'

export EDITOR="$(if [[ -n $DISPLAY ]]; then echo 'subl3'; else echo 'vim'; fi)"
if [ -n "$DISPLAY" ]; then
    export BROWSER=firefox
else 
    export BROWSER=w3m
fi
export GDK_CORE_DEVICE_EVENTS=1





EOF
