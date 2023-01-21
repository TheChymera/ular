#!/usr/bin/env bash

USAGE="Usage:\n\
        $(basename "$0") [-w] [-a <alert>] [-l <length>] [-s <step>] [-f <countdown-file>] <duration>\n\
        Arguments:
        duration: Duration until the alarm is played (format <days>d<hours>h<minutes>m<seconds>s), e.g.:\n\
                * 5m30s\n\
                * 7d30m\n\
        Options:
                -w: Write countdown to a file (customize via \`-f\`) instead of displaying it in the terminal.\n\
                        N.B. This will activate an entirely different timer mechanism with lower precision.
                -a: Alert sound (default being \`alarm-clock-elapsed.oga\`), provide either:\n\
                        * an absolute path (starting with \`/\` or \`~\`),\n\
                        * the basename of a sound file, from \`ls /usr/share/sounds/freedesktop/stereo/\`.\n\
                -f: File to which to write countdown (default is \`/tmp/ualarmer\`, this only takes effect if \`-w\` is used).\n\
                -l: Length (same format as <duration>, default 1s) for which to play the alert sound.\n\
                        N.B. The alert is re-started until the length is exceeded), e.g. if the alert takes 19s and \`-l 20\` is specified, it will play for 38s.\n\
                -s: Step size (in seconds) to use for writing the countdown file (default, \`2\`, only takes effect if \`-w\` is used).
                -h: displays help message."

# Read Options:
while getopts ":a:f:l:s:wh" flag
do
        case "$flag" in
                w)
                        COUNTDOWN_WRITE=1
                        ;;
                a)
                        ALERT="$OPTARG"
                        ;;
                l)
                        LENGTH="$OPTARG"
                        ;;
                f)
                        COUNTDOWN_FILE="$OPTARG"
                        ;;
                s)
                        STEP="$OPTARG"
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
if ((COUNTDOWN_WRITE)); then
        if [ -z "$COUNTDOWN_FILE" ]; then
                COUNTDOWN_FILE="/tmp/ualarmer"
        fi
        if [ -e "$COUNTDOWN_FILE" ]; then
                echo -e "Selected countdown file \`$COUNTDOWN_FILE\` exists, refusing to over-write.\n\
                Please manually delete it or specify a different file to use for recording the countdown."
                exit 1
        fi
        if [ -z "$STEP" ]; then
                STEP=2
        fi
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

# Parse duration string and check consistency.
[[ "${DURATION}" =~ (|([0-9]*?)d)(|([0-9]*?)h)(|([0-9]*?)m)(|([0-9]*?)s) ]]
match=("${BASH_REMATCH[@]}")
DURATION_MATCH=${match[0]}

if [ "${DURATION}" != "${DURATION_MATCH}" ]; then
        echo -e "The interpreted date does not match you input:\n\
                * $(basename "$0") interpretation: \`${DURATION_MATCH}\`\n\
                * Your input: \`${DURATION}\`"
        exit 1
fi

# Debugging:
#echo ${DAYS}
#echo ${HOURS}
#echo ${MINUTES}
#echo ${SECONDS}
#TOTAL_SECONDS=$(( SECONDS + MINUTES*60 + HOURS*60*60 + DAYS*60*60*24 ))
#echo ${TOTAL_SECONDS}

# Run timer depending on desired output.
if ((COUNTDOWN_WRITE)); then
        DAYCOUNT=${match[2]}
        HOURCOUNT=${match[4]}
        MINUTECOUNT=${match[6]}
        SECONDCOUNT=${match[8]}
        if [ -z $DAYCOUNT ]; then
                DAYCOUNT=0
        fi

        if [ -z $HOURCOUNT ]; then
                HOURCOUNT=0
        fi

        if [ -z $MINUTECOUNT ]; then
                MINUTECOUNT=0
        fi

        if [ -z $SECONDCOUNT ]; then
                SECONDCOUNT=0
        fi

        while [ $HOURCOUNT -gt -1 ]; do
                if [ $HOURCOUNT == 0 ]; then
                        H_PRINT=""
                else
                        H_PRINT="$(printf "%0*d\n" 2 ${HOURCOUNT}):"
                fi
                while [ $MINUTECOUNT -gt -1 ]; do
                        if [ $MINUTECOUNT == 0 ]; then
                                M_PRINT=""
                        else
                                M_PRINT="$(printf "%0*d\n" 2 ${MINUTECOUNT}):"
                        fi
                        while [ $SECONDCOUNT -gt 0 ]; do
                                if (( $SECONDCOUNT % ${STEP} == 0 )); then
                                        S_PRINT=$(printf "%0*d\n" 2 ${SECONDCOUNT})
                                        echo "${H_PRINT}${M_PRINT}${S_PRINT}" > "${COUNTDOWN_FILE}"
                                fi
                                sleep 1
                                ((SECONDCOUNT--))
                        done
                        ((MINUTECOUNT--))
                        SECONDCOUNT=59
                done
                ((HOURCOUNT--))
                MINUTECOUNT=59
        done
        echo "⏰" > "${COUNTDOWN_FILE}"
else
        utimer -c "${DURATION}";
fi

# Play alarm.
utimer -c "${LENGTH}" &
pid=$!
while ps -p $pid &>/dev/null; do
    mpv ${ALERTPATH} &>/dev/null
done

# Remove countdown file, if countdown writing was used.
if ((COUNTDOWN_WRITE)); then
        rm ${COUNTDOWN_FILE}
fi
