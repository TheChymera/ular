#!/usr/bin/env bash

USAGE="Usage:\n\
        $(basename "$0") [-b -l -q -t] [-a <alert>] <duration>\n\
        Arguments:
        duration: Duration until the alarm is played (format <days>d<hours>h<minutes>m<seconds>s), e.g.:\n\
                * 5m30s\n\
                * 7d30m\n\
        Options:
                -b: Activates background mode (no output, and forks process to background).\n\
                        THIS IS NOT YET IMPLEMENTED.\n\
                -l: Length (same format as <duration>, default 1s) for which to play the alert sound.\n\
                        N.B. the alert is re-started until the length is exceeded), e.g. if the alert takes 19s and \`-l 20\` is specified, it will play for 38s.\n\
                -q: Activates quiet mode (no output).\n\
                -t: Count up to <duration> (default is to count down).\n\
                -a: Alert sound (default being \`alarm-clock-elapsed.oga\`), provide either:\n\
                        * an absolute path (starting with \`/\` or \`~\`),\n\
                        * the basename of a sound file, from \`ls /usr/share/sounds/freedesktop/stereo/\`.\n\
                -h: displays help message."

# Read Options:
while getopts ":a:l:bqth" flag
do
        case "$flag" in
                b)
                        BACKGROUND=1
                        ;;
                l)
                        LENGTH="$OPTARG"
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
if [ -z "$LENGTH" ]; then
        LENGTH="1s"
fi

# Logic based on options
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

if ((QUIET)); then
        UTIMER_OPTIONS+=( "-q" )
fi


# Run command
if ((TIMER)); then
        utimer -t "${DURATION}" ${UTIMER_OPTIONS[@]};
        utimer -c "${LENGTH}" ${UTIMER_OPTIONS[@]}&
        pid=$!
        while ps -p $pid &>/dev/null; do
            mpv ${ALERTPATH} &>/dev/null
        done
else
        utimer -c "${DURATION}" ${UTIMER_OPTIONS[@]};
        utimer -c "${LENGTH}" ${UTIMER_OPTIONS[@]}&
        # Prompt gets shifted by 1 char width, the following will prevent that and keep output quited,
        # but it would make the logic more repetitive :/
        #utimer -c "${DURATION}" &>/dev/null;
        #utimer -c "${LENGTH}" &>/dev/null &
        pid=$!
        while ps -p $pid &>/dev/null; do
            mpv ${ALERTPATH} &>/dev/null
        done
fi
