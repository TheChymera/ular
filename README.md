# µAlarmer

Spelled `ualarmer` for accessibility, this is a simple script which leverages [utimer](http://utimer.codealpha.net/utimer) to play an alarm sound after a countdown.
The main focus is simplicity and quick access via the CLI.

## Usage

The script can generally be used as `ualarmer` if installed system-wide, or as `./ualarmer.sh` from a clone of this repository (in which case the Dependencies section below should be consulted to make sure required packages are present).

The below may not correspond exactly to the version you have downloaded, for the most accurate usage guide, check `ualarmer -h` on your command line.
```
Usage:
        ualarmer.sh [-b -l -q -t] [-a <alert>] <duration>
        Arguments:
        duration: Duration until the alarm is played (format <days>d<hours>h<minutes>m<seconds>s), e.g.:
                * 5m30s
                * 7d30m
        Options:
                -b: Activates background mode (no output, and forks process to background).
                        THIS IS NOT YET IMPLEMENTED.
                -l: Length (same format as <duration>, default 1s) for which to play the alert sound.
                        N.B. the alert is re-started until the length is exceeded), e.g. if the alert takes 19s and `-l 20` is specified, it will play for 38s.
                -q: Activates quiet mode (no output).
                -t: Count up to <duration> (default is to count down).
                -a: Alert sound (default being `alarm-clock-elapsed.oga`), provide either:
                        * an absolute path (starting with `/` or `~`),
                        * the basename of a sound file, from `ls /usr/share/sounds/freedesktop/stereo/`.
                -h: displays help message.
```

## Dependencies

The most precise specification of the dependency graph (including conditionality) can be extracted from the [utimer ebuild](.gentoo/app-misc/ualarmer/ualarmer-99999.ebuild), following the `99999` convention, which is distributed via this repository.
For manual dependency management and overview you may use the following list:

* [mpv](https://mpv.io/)
* [utimer](http://utimer.codealpha.net/utimer)
* [sound-theme-freedesktop](https://www.freedesktop.org/wiki/Specifications/sound-theme-spec), which will need to be installed under `/usr/share/sounds/freedesktop/`.
