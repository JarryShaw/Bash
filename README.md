# Scripts


Just some useful bash scripts.


&nbsp;


- `update.py`

&emsp; &emsp; Automatically update / update all applications installed (on `macOS`), packages installed by `pip` (of Python 2.7 and Python 3.6 in `CPython` and `Pypy` compiler), and softwares installed through `Homebrew`.

```shell
# update all
$ python3 update.py
$ python3 update.py -a

# update all of `mode` -- pip / brew / cask / appstore
$ python3 update.py mode
$ python3 update.py mode -a

# update `package` of `mode`
$ python update.py mode -p package
```


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
