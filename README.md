# Scripts

Just some useful bash scripts.

- [Daily](#daily)
    * [`update`](#update)
    * [`uninstall`](#uninstall)
    * [`reinstall`](#reinstall)
    * [`postinstall`](#postinstall)
    * [`dependency`](#dependency)

- [Kali](#kali)
    * [`acccheck`](#acccheck)
    * [`firewalk`](#firewalk)
    * [`ident-user-enum`](#ident-user-enum)
    * [`nutscan-unixwiz`](#nutscan-unixwiz)
    * [`nmap`](#nmap)
    * [`zenmap`](#zenmap)

- [Others](#others)
    * [`colour`](#colour)
    * [`pypi`](#pypi)
    * [`startup`](#startup)


---------------------------------------------------------------------------------------------------


## Daily

##### `update`

&emsp; `update` is a package manager written in Python 3.6 and Bash 3.2, which automatically update all packages installed through ——

  - `apm` -- Atom packages
  - `pip` -- Python packages, in both version of 2.7 and 3.6, running under [CPython](https://www.python.org) or [PyPy](pypy.org) compiler, and installed through `brew` or official disk images
  - `brew` -- [Homebrew](https://brew.sh) packages
  - `cask` -- [Caskroom](https://caskroom.github.io) applications
  - `appstore` -- Mac App Store or `softwareupdate` installed applications

&emsp; You may install `update` through `pip` of Python (versions 3.\*). And log files can be found in directory `/Library/Logs/Scripts/update/`. The global man page for `update` shows as below.

```
$ update --help
usage: update [-h] [-V] [-a] [-f] [-m] [-g] [-q] [-v] MODE ...

Automatic Package Update Manager

optional arguments:
  -h, --help     show this help message and exit
  -V, --version  show program's version number and exit
  -a, --all      Update all packages installed through pip, Homebrew, and App
                 Store.
  -f, --force    Run in force mode, only for Homebrew or Caskroom.
  -m, --merge    Run in merge mode, only for Homebrew.
  -g, --greedy   Run in greedy mode, only for Caskroom.
  -q, --quiet    Run in quiet mode, with no output information.
  -v, --verbose  Run in verbose mode, with more information.

mode selection:
  MODE           Update outdated packages installed through a specified
                 method, e.g.: apm, pip, brew, cask, or appstore.
```

&emsp; As it shows, there are five modes in total (if these commands exists). To update all packages, you may use one of commands below.

```
$ update
$ update -a
$ update --all
```

1. `apm` -- Atom packages

&emsp; [Atom](https://atom.io) provides a package manager called `apm`, i.e. "Atom Package Manager". The man page for `update apm` shows as below.

```
$ update apm --help
usage: update apm [-h] [-a] [-p PKG] [-q] [-v]

Update installed Atom packages.

optional arguments:
  -h, --help            show this help message and exit
  -a, --all             Update all packages installed through apm.
  -p PKG, --package PKG
                        Name of packages to be updated, default is all.
  -q, --quiet           Run in quiet mode, with no output information.
  -v, --verbose         Run in verbose mode, with more information.
```

&emsp; If arguments omit, `update apm` will update all outdated packages of Atom. And when using `-p` or `--package`, if given wrong package name, `update apm` might give a trivial "did-you-mean" correction.

2. `pip` -- Python packages

&emsp; As there\'re all kinds and versions of Python complier, along with its `pip` package manager. Here, we support update of following ——

 - Python 2.7/3.6 installed through Python official disk images
 - Python 2.7/3.6 installed through `brew install python/python3`
 - PyPy 2.7/3.5 installed through `brew install pypy/pypy3`

And the man page shows as below.

```
$ update pip --help
usage: update pip [-h] [-a] [-V VER] [-s] [-b] [-c] [-y] [-p PKG] [-q] [-v]

Update installed Python packages.

optional arguments:
  -h, --help            show this help message and exit
  -a, --all             Update all packages installed through pip.
  -V VER, --version VER
                        Indicate which version of pip will be updated.
  -s, --system          Update pip packages on system level, i.e. python
                        installed through official installer.
  -b, --brew            Update pip packages on Cellar level, i.e. python
                        installed through Homebrew.
  -c, --cpython         Update pip packages on CPython environment.
  -y, --pypy            Update pip packages on Pypy environment.
  -p PKG, --package PKG
                        Name of packages to be updated, default is all.
  -q, --quiet           Run in quiet mode, with no output information.
  -v, --verbose         Run in verbose mode, with more information.
```

&emsp; If arguments omit, `update pip` will update all outdated packages in all copies of Python. And when using `-p` or `--package`, if given wrong package name, `update pip` might give a trivial "did-you-mean" correction.

3. `brew` -- Homebrew packages

&emsp; The man page for `update brew` shows as below.

```
$ update brew --help
usage: update brew [-h] [-a] [-p PKG] [-f] [-m] [-q] [-v]

Update installed Homebrew packages.

optional arguments:
  -h, --help            show this help message and exit
  -a, --all             Update all packages installed through Homebrew.
  -p PKG, --package PKG
                        Name of packages to be updated, default is all.
  -f, --force           Use "--force" when running `brew update`.
  -m, --merge           Use "--merge" when running `brew update`.
  -q, --quiet           Run in quiet mode, with no output information.
  -v, --verbose         Run in verbose mode, with more information.
```

&emsp; Note that, arguments `-f` and `--force`, `-m` and `--merge` are using only for `brew update` command.

&emsp; If arguments omit, `update brew` will update all outdated packages of Homebrew. And when using `-p` or `--package`, if given wrong package name, `update brew` might give a trivial "did-you-mean" correction.

4. `cask` -- Caskrooom packages

&emsp; The man page for `update cask` shows as below.

```
$ update cask  --help
usage: update cask [-h] [-a] [-p PKG] [-f] [-g] [-q] [-v]

Update installed Caskroom packages.

optional arguments:
  -h, --help            show this help message and exit
  -a, --all             Update all packages installed through Caskroom.
  -p PKG, --package PKG
                        Name of packages to be updated, default is all.
  -f, --force           Use "--force" when running `brew cask upgrade`.
  -g, --greedy          Use "--greedy" when running `brew cask outdated`, and
                        directly run `brew cask upgrade --greedy`.
  -q, --quiet           Run in quiet mode, with no output information.
  -v, --verbose         Run in verbose mode, with more information.
```

&emsp; Note that, arguments `-f` and `--force`, `-g` and `--greedy` are using only for `brew cask upgrade` command. And when latter given, `update` will directly run `brew cask upgrade --greedy`.

&emsp; If arguments omit, `update cask` will update all outdated packages of Caskroom. And when using `-p` or `--package`, if given wrong package name, `update cask` might give a trivial "did-you-mean" correction.

5. `appstore` -- Mac App Store packages

&emsp; The man page for `update appstore` shows as below.

```
$ update appstore --help
usage: update appstore [-h] [-a] [-p PKG] [-q]

Update installed App Store packages.

optional arguments:
  -h, --help            show this help message and exit
  -a, --all             Update all packages installed through App Store.
  -p PKG, --package PKG
                        Name of packages to be updated, default is all.
  -q, --quiet           Run in quiet mode, with no output information.
```

&emsp; If arguments omit, `update appstore` will update all outdated packages in Mac App Store or `softwareupdate`. And when using `-p` or `--package`, if given wrong package name, `update appstore` might give a trivial "did-you-mean" correction.


&nbsp;


##### `uninstall`

&emsp; `uninstall` is a package manager written in Python 3.6 and Bash 3.2, which recursively and interactively uninstall packages installed through ——

  - `pip` -- Python packages, in both version of 2.7 and 3.6, running under [CPython](https://www.python.org) or [PyPy](pypy.org) compiler, and installed through `brew` or official disk images
  - `brew` -- [Homebrew](https://brew.sh) packages
  - `cask` -- [Caskroom](https://caskroom.github.io) applications

&emsp; You may install `uninstall` through `pip` of Python (versions 3.\*). And log files can be found in directory `/Library/Logs/Scripts/uninstall/`. The global man page for `uninstall` shows as below.

```
$ uninstall --help
usage: uninstall [-h] [-V] [-a] [-f] [-i] [-q] [-v] [-Y] MODE ...

Package Recursive Uninstall Manager

optional arguments:
  -h, --help            show this help message and exit
  -V, --version         show program's version number and exit
  -a, --all             Uninstall all packages installed through pip,
                        Homebrew, and App Store.
  -f, --force           Run in force mode, only for Homebrew and Caskroom.
  -i, --ignore-dependencies
                        Run in irrecursive mode, only for Python and Homebrew.
  -q, --quiet           Run in quiet mode, with no output information.
  -v, --verbose         Run in verbose mode, with more information.
  -Y, --yes             Yes for all selections.

mode selection:
  MODE                  Uninstall given packages installed through a specified
                        method, e.g.: pip, brew or cask.
```

&emsp; As it shows, there are three modes in total (if these commands exists). The default procedure when arguments omit is to stand alone. To uninstall all packages, you may use one of commands below.

```
$ update -a
$ update --all
```

1. `pip` -- Python packages

&emsp; As there're several kinds and versions of Python complier, along wiht its `pip` package manager. Here, we support uninstall procedure in following ——

 * Python 2.7/3.6 installed through Python official disk images
 * Python 2.7/3.6 installed through `brew install python/python3`
 * PyPy 2.7/3.5 installed through `brew install pypy/pypy3`

&emsp; And the man page shows as below.

```
$ uninstall pip --help
usage: uninstall pip [-h] [-a] [-V VER] [-s] [-b] [-c] [-y] [-p PKG] [-i] [-q]
                     [-v] [-Y]

Uninstall pip installed packages.

optional arguments:
  -h, --help            show this help message and exit
  -a, --all             Uninstall all packages installed through pip.
  -V VER, --version VER
                        Indicate packages in which version of pip will be
                        uninstalled.
  -s, --system          Uninstall pip packages on system level, i.e. python
                        installed through official installer.
  -b, --brew            Uninstall pip packages on Cellar level, i.e. python
                        installed through Homebrew.
  -c, --cpython         Uninstall pip packages on CPython environment.
  -y, --pypy            Uninstall pip packages on Pypy environment.
  -p PKG, --package PKG
                        Name of packages to be uninstalled, default is null.
  -i, --ignore-dependencies
                        Run in irrecursive mode, i.e. ignore dependencies of
                        installing packages.
  -q, --quiet           Run in quiet mode, with no output information.
  -v, --verbose         Run in verbose mode, with more information.
  -Y, --yes             Yes for all selections.
```

&emsp; If arguments omit, `uninstall pip` will stand alone, and do nothing. To uninstall all packages, use `-a` or `--all` option. And when using `-p` or `--package`, if given wrong package name, `uninstall pip` might give a trivial “did-you-mean” correction.

3. `brew` - Homebrew packages

&emsp; The man page for `uninstall brew` shows as below.

```
$ uninstall brew --help
usage: uninstall brew [-h] [-a] [-p PKG] [-f] [-i] [-q] [-v] [-Y]

Uninstall Homebrew installed packages.

optional arguments:
  -h, --help            show this help message and exit
  -a, --all             Uninstall all packages installed through Homebrew.
  -p PKG, --package PKG
                        Name of packages to be uninstalled, default is null.
  -f, --force           Use "--force" when running `brew uninstall`.
  -i, --ignore-dependencies
                        Run in irrecursive mode, i.e. ignore dependencies of
                        installing packages.
  -q, --quiet           Run in quiet mode, with no output information.
  -v, --verbose         Run in verbose mode, with more information.
  -Y, --yes             Yes for all selections.
```

&emsp; If arguments omit, `uninstall brew` will stand alone, and do nothing. To uninstall all packages, use `-a` or `--all` option. And when using `-p` or `--package`, if given wrong package name, `uninstall brew` might give a trivial “did-you-mean” correction.

4. `cask` – Caskrooom packages

&emsp; The man page for `uninstall cask` shows as below.

```
$ uninstall cask --help
usage: uninstall cask [-h] [-a] [-p PKG] [-f] [-q] [-v] [-Y]

Uninstall installed Caskroom packages.

optional arguments:
  -h, --help            show this help message and exit
  -a, --all             Uninstall all packages installed through Caskroom.
  -p PKG, --package PKG
                        Name of packages to be uninstalled, default is null.
  -f, --force           Use "--force" when running `brew cask uninstall`.
  -q, --quiet           Run in quiet mode, with no output information.
  -v, --verbose         Run in verbose mode, with more information.
  -Y, --yes             Yes for all selections.
```

&emsp; If arguments omit, `uninstall cask` will stand alone, and do nothing. To uninstall all packages, use `-a` or `--all` option. And when using `-p` or `--package`, if given wrong package name, `uninstall cask` might give a trivial “did-you-mean” correction.
