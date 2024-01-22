# µLar

Spelled `ular` for accessibility.
This is a pure Bash utility to perform a countdown, writing the state to a temporary file, and play an alarm sound upon completion.
The main focus is simplicity and usage with desktop applications which can poll the temporary file to display the status in the task bar.
If you would like to have the status in the terminal, consider [delay](https://onegeek.org/~tom/software/delay/).

## Usage

The script can be used as `ular` if installed system-wide, or as `./ular.sh` from a clone of this repository (in which case the Dependencies section below should be consulted to make sure required packages are present).

The below may not correspond exactly to the version you have downloaded, for the most accurate usage guide, check `ular -h` on your command line.

```
Usage:
        ular [-a <alert>] [-l <length>] [-s <step>] [-f <countdown-file>] <duration>
        Arguments:
        duration: Duration until the alarm is played (format <days>d<hours>h<minutes>m<seconds>s), e.g.:
                * 5m30s
                * 7d30m
        Options:
                -a: Alert sound (default being `alarm-clock-elapsed.oga`), provide either:
                        * an absolute path (starting with `/` or `~`),
                        * the basename of a sound file, from `ls /usr/share/sounds/freedesktop/stereo/`.
                -f: File to which to write countdown (default is `/tmp/ular`).
                -l: Length (same format as <duration>, default 1s) for which to play the alert sound.
                        N.B. The alert is re-started until the length is exceeded), e.g. if the alert takes 19s and `-l 20` is specified, it will play for 38s.
                -s: Step size (in seconds) to use for writing the countdown file (default, `2`).
                -h: displays help message.
```

## Dependencies

The most precise specification of the dependency graph (including conditionality) can be extracted from the [utimer ebuild](.gentoo/app-misc/ualarmer/ualarmer-99999.ebuild), following the `99999` convention, which is distributed via this repository.
For manual dependency management and overview you may use the following list:

* [mpv](https://mpv.io/)
* [sound-theme-freedesktop](https://www.freedesktop.org/wiki/Specifications/sound-theme-spec), which will need to be installed under `/usr/share/sounds/freedesktop/`.
