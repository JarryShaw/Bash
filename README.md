# Scripts


Just some useful bash scripts.


&nbsp;


## Daily


##### `update`

&emsp; `update` is a package manager written in Python 3.6 and Bash 3.2, which automatically update all packages installed through ——

  - `apm` -- Atom packages
  - `pip` -- Python packages, in both version of 2.7 and 3.6, running under [CPython](https://www.python.org) or [PyPy](pypy.org) compiler, and installed through `brew` or official disk images
  - `brew` -- [Homebrew](https://brew.sh) packages
  - `cask` -- [Caskroom](https://caskroom.github.io) applications
  - `appstore` -- Mac App Store or `softwareupdate` installed applications

&emsp; You may install `update` through `pip` of Python (versions 3.\*). And log files can be found in directory `/Library/Logs/Scripts/update/` The global man page for `update` shows as below.

```shell
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

```shell
$ update
$ update -a
$ update --all
```

1. `apm` -- Atom packages

&emsp; [Atom](https://atom.io) provides a package manager called `apm`, i.e. "Atom Package Manager". The man page for `update apm` shows as below.

```shell
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

&emsp; If arguments omits, `update apm` will update all outdated packages of Atom. And when using `-p` or `--package`, if given wrong package name, `update apm` might give a trivial "did-you-mean" correction.

2. `pip` -- Python packages

&emsp; As there\'re all kinds and versions of Python complier, along with its `pip` package manager. Here, we support update of following ——

 - Python 2.7/3.6 installed through Python official disk images
 - Python 2.7/3.6 installed through `brew install python[3]`
 - PyPy 2.7/3.5 installed through `brew install pypy[3]`

And the man page shows as below.

```shell
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

&emsp; If arguments omits, `update pip` will update all outdated packages in all copies of Python. And when using `-p` or `--package`, if given wrong package name, `update pip` might give a trivial "did-you-mean" correction.

3. `brew` -- Homebrew packages

&emsp; The man page for update `update brew` shows as below.

```shell
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

&emsp; If arguments omits, `update brew` will update all outdated packages of Homebrew. And when using `-p` or `--package`, if given wrong package name, `update brew` might give a trivial "did-you-mean" correction.

4. `cask` -- Caskrooom packages

&emsp; The man page for update `update cask` shows as below.

```shell
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

&emsp; If arguments omits, `update cask` will update all outdated packages of Caskroom. And when using `-p` or `--package`, if given wrong package name, `update cask` might give a trivial "did-you-mean" correction.

5. `appstore` -- Mac App Store packages

&emsp; The man page for update `update appstore` shows as below.

```shell
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

&emsp; If arguments omits, `update appstore` will update all outdated packages in Mac App Store or `softwareupdate`. And when using `-p` or `--package`, if given wrong package name, `update appstore` might give a trivial "did-you-mean" correction.


&nbsp;

* `uninstall.sh`

  Uninstall dependencies of certain pakages.

  - For `Homebrew`

    ```shell
    # uninstall all packages
    $ bash uninstall.sh brew -a

    # uninstall dependencies of `package`
    $ bash uninstall.sh brew -p package
    ```

  - For `pip`

    ```shell
    # uninstall all packages
    $ bash uninstall.sh pip -a

    # uninstall dependencies of `package`
    $ bash uninstall.sh pip -p package
    ```

  - For `pip3`

    ```shell
    # uninstall all packages
    $ bash uninstall.sh pip3 -a

    # uninstall dependencies of `package`
    $ bash uninstall.sh pip3 -p package
    ```

  - For `pip_pypy`

    ```shell
    # uninstall all packages
    $ bash uninstall.sh pip_pypy -a

    # uninstall dependencies of `package`
    $ bash uninstall.sh pip_pypy -p package
    ```

  - For `pip_pypy3`

    ```shell
    # uninstall all packages
    $ bash uninstall.sh pip_pypy3 -a

    # uninstall dependencies of `package`
    $ bash uninstall.sh pip_pypy3 -p package
    ```

    ​

* `reinstall.sh`

  Reinstall certain pakages.

  ```shell
  # reinstall all
  $ bash reinstall.sh
  $ bash reinstall.sh -a

  # reinstall `package`
  $ bash reinstall.sh -p package

  # reinstall all starting from `package`
  $ bash reinstall.sh -s package
  ```

  ​

* `postinstall.sh`

  Postinstall certain pakages.

  ```shell
  # postinstall all
  $ bash postinstall.sh
  $ bash postinstall.sh -a

  # postinstall `package`
  $ bash postinstall.sh -p package

  # postinstall all starting from `package`
  $ bash postinstall.sh -s package
  ```

  ​


* `dependency.sh`

  Check dependencies of certain pakages.

  - For homebrew

    ```shell
    # show all dependencies
    $ bash dependency.sh brew
    $ bash dependency.sh brew -a

    # show dependency of `package`
    $ bash dependency.sh brew -p package
    ```

  - For pip

    ```Shell
    # show all dependencies
    $ bash dependency.sh pip                  
    $ bash dependency.sh pip -a

    # show dependency of `package`
    $ bash dependency.sh pip -p package
    ```

    ​

* `pypi.sh`

  Upload and register your `python` library into `pypi` and `pypitest`.
