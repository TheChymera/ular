#!/usr/bin/env bash

USAGE="Usage:\n\
        $(basename "$0") [-b -q -t] [-a <alert>] <duration>\n\
        Arguments:
        duration: Duration until the alarm is played (format <days>d<hours>h<minutes>m<seconds>s), e.g.:\n\
                * 5m30s\n\
                * 7d30m\n\
        Options:
                -b: Activates background mode (no output, and forks process to background).\n\
                -q: Activates quiet mode (no output).\n\
                -t: Count up to <duration> (default is to count down).\n\
                -a: Alert sound (default being \`alarm-clock-elapsed.oga\`), provide either:\n\
                        * an absolute path (starting with \`/\` or \`~\`),\n\
                        * the basename of a sound file, from \`ls /usr/share/sounds/freedesktop/stereo/\`.\n\
                -h: displays help message."

# Read Options:
while getopts ":a:bqth" flag
do
        case "$flag" in
                b)
                        BACKGROUND=1
                        ;;
                q)
                        QUIET=1
                        ;;
                t)
                        TIMER=1
                        ;;
                a)
                        ALERT="$OPTARG"
                        ;;
                h)
                        echo -e "$USAGE"
                        exit 0
                        ;;
                \?)
                        echo "Invalid option: -$OPTARG" >&2
                        exit 1
                        ;;
                :)
                        echo "Option -$OPTARG requires an argument." >&2
                        exit 1
                        ;;
        esac
done

# shifts pointer to read mandatory duration specification
shift $((OPTIND - 1))
DURATION="${1}"

# Check mandatory argument
if [ -z "$DURATION" ]; then
        echo "$(basename "$0"): no duration specified."
        echo -e "$USAGE"
        exit 1
fi

# Set default options
if [ -z "$ALERT" ]; then
        ALERT="alarm-clock-elapsed.oga"
fi


case $ALERT in
~*)
        echo "is home"
        ;;
/*)
        ALERTPATH=${ALERT}
        ;;
*)
	ALERTPATH="/usr/share/sounds/freedesktop/stereo/${ALERT}"
	;;
esac


# Run command
if ((TIMER)); then
        utimer -t "${DURATION}"; mpv ${ALERTPATH}
else
        utimer -c "${DURATION}"; mpv ${ALERTPATH}
fi
