# speedrun
Run games extra fast using speedrun, a configurable tool for using custom launch options. By default, detects and uses MangoHUD, prime-run, and gamemoderun if they are available.

### installation
* [AUR Package](https://aur.archlinux.org/packages/speedrun)
* `sudo ./install.sh`

### configuration
Configured in the following locations, in increasing order of priority -
* `/etc/speedrun.conf` for systemwide
* `$XDG_CONFIG_HOME/speedrun/speedrun.conf` for user
* `$XDG_CONFIG_HOME/speedrun/xyz.conf` for an application titled xyz
* `./.speedrun.conf` for local directory

`$XDG_CONFIG_HOME` defaults to `~/.config` if not set
