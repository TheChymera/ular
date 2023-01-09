# µAlarmer

Spelled `ualarmer` for accessibility, this is a simple script which leverages [utimer](http://utimer.codealpha.net/utimer) to play an alarm sound after a countdown.
The main focus is simplicity and quick access via the CLI.

## Dependencies

The most precise specification of the dependency graph (including conditionality) can be extracted from the [utimer ebuild](.gentoo/app-misc/ualarmer/ualarmer-99999.ebuild), following the `99999` convention, which is distributed via this repository.
For manual dependency management and overview you may use the following list:

* [mpv](https://mpv.io/)
* [utimer](http://utimer.codealpha.net/utimer)
* [sound-theme-freedesktop](https://www.freedesktop.org/wiki/Specifications/sound-theme-spec), which will need to be installed under `/usr/share/sounds/freedesktop/`.
