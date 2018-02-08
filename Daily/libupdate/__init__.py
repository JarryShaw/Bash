#!/usr/bin/python3
# -*- coding: utf-8 -*-


import os
import re
import shlex
import shutil
import subprocess
import time


# terminal display
red = 'tput setaf 1'    # blush / red
blue = 'tput setaf 14'  # blue
reset = 'tput sgr0'     # reset
bold = 'tput bold'      # bold
under = 'tput smul'     # underline


def _merge_packages(args):
    if 'package' in args and args.package:
        allflag = False
        packages = set()
        for pkg in args.packages:
            if allflag: break
            mapping = map(shlex.split, pkg.split(','))
            for list_ in mapping:
                if 'all' in list_:
                    packages = {'all'}
                    allflag = True; break
                packages = packages.union(set(list_))
    else:
        packages = {'all'}
    return packages


def update_apm(args, *, file, date, retset=False):
    quiet = str(args.quiet).lower()
    verbose = str(args.verbose).lower()
    packages = _merge_packages(args)

    if shutil.which('apm') is None:
        os.system(f'''
                echo "$({red})apm$({reset}): Command not found.";
                echo "You may download Atom from $({under})https://atom.io$({reset})."
        ''')
        return set() if retset else dict(apm=set())

    mode = '-*- Atom -*-'.center(80, ' ')
    with open(file, 'a') as logfile:
        logfile.write(f'\n\n{mode}\n\n')

    if not args.quiet:
        os.system(f'echo "-*- $({blue})Atom$({reset}) -*-"; echo ;')

    if 'all' in packages:
        logging = subprocess.run(
            ['bash', 'libupdate/logging_apm.sh', date],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        log = set(logging.stdout.split())
        outdated = 'true' if logging.stdout.decode() else 'false'
        outdated_pkgs = shlex.split(logging.stdout.decode())
    else:
        log = packages
        outdated = 'true'
        outdated_pkgs = list()

    for name in packages:
        subprocess.run(
            ['bash', 'libupdate/update_apm.sh', name, quiet, verbose, date, outdated] + outdated_pkgs
        )

    if not args.quiet:
        time.sleep(1)
        os.system('tput clear')
    return log if retset else dict(apm=log)


def update_pip(args, *, file, date, retset=False):
    quiet = str(args.quiet).lower()
    verbose = str(args.verbose).lower()
    packages = _merge_packages(args)

    mode = '-*- Python -*-'.center(80, ' ')
    with open(file, 'a') as logfile:
        logfile.write(f'\n\n{mode}\n\n')

    if not args.quiet:
        os.system(f'echo "-*- $({blue})Python$({reset}) -*-"; echo ;')

    if 'all' in packages and args.mode is None:
        system, brew, cpython, pypy, version = 'true', 'true', 'true', 'true', '1'
    else:
        system, brew, cpython, pypy, version = \
            str(args.system).lower(), str(args.brew).lower(), \
            str(args.cpython).lower(), str(args.pypy).lower(), str(args.version or 1)

    logging = subprocess.run(
        ['bash', 'libupdate/logging_pip.sh', system, brew, cpython, pypy, version, date],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    log = set(logging.stdout.decode().split())

    for name in packages:
        subprocess.run(
            ['bash', 'libupdate/update_pip.sh', name, system, brew, cpython, pypy, version, quiet, verbose, date]
        )

    if not args.quiet:
        os.system('tput clear')
    return log if retset else dict(pip=log)


def update_brew(args, *, file, date, cleanup=True, retset=False):
    quiet = str(args.quiet).lower()
    verbose = str(args.verbose).lower()
    force = str(args.force).lower()
    merge = str(args.merge).lower()
    packages = _merge_packages(args)

    if shutil.which('brew') is None:
        os.system(f'''
                echo "$({red})brew$({reset}): Command not found.";
                echo "You may find Homebrew on $({under})https://brew.sh$({reset}), or install Homebrew through following command:"
                echo $({bold})'/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'$({reset})
        ''')
        return set() if retset else dict(brew=set())

    mode = '-*- Homebrew -*-'.center(80, ' ')
    with open(file, 'a') as logfile:
        logfile.write(f'\n\n{mode}\n\n')

    if not args.quiet:
        os.system(f'echo "-*- $({blue})Homebrew$({reset}) -*-"; echo ;')

    subprocess.run(
        ['bash', 'libupdate/renew_brew.sh', quiet, verbose, force, merge, date]
    )

    if 'all' in packages:
        logging = subprocess.run(
            ['bash', 'libupdate/logging_brew.sh', date],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        log = set(logging.stdout.decode().split())
        outdated = 'true' if logging.stdout.decode() else 'false'
        outdated_pkgs = shlex.split(logging.stdout.decode())
    else:
        log = packages
        outdated = 'true'
        outdated_pkgs = list()

    for name in packages:
        subprocess.run(
            ['bash', 'libupdate/update_brew.sh', name, quiet, verbose, date, outdated] + outdated_pkgs
        )

    if cleanup:
        mode = '-*- Cleanup -*-'.center(80, ' ')
        with open(file, 'a') as logfile:
            logfile.write(f'\n\n{mode}\n\n')

        if not args.quiet:
            time.sleep(1)
            os.system('tput clear')
            os.system(f'echo "-*- $({blue})Cleanup$({reset}) -*-"; echo ;')

        subprocess.run(
            ['bash', 'libupdate/cleanup.sh', 'true', 'false', quiet, verbose, date]
        )

    if not args.quiet:
        time.sleep(1)
        os.system('tput clear')
    return log if retset else dict(brew=log)


def update_cask(args, *, file, date, cleanup=True, retset=False):
    quiet = str(args.quiet).lower()
    verbose = str(args.verbose).lower()
    force = str(args.force).lower()
    greedy = str(args.greedy).lower()
    packages = _merge_packages(args)

    testing = subprocess.run(
        shlex.split('brew cask'),
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    if testing.returncode:
        os.system(f'''
                echo "$({red})cask$({reset}): Command not found.";
                echo "You may find Caskroom on $({under})https://caskroom.github.io$({reset}), or install Caskroom through following command:"
                echo $({bold})'brew tap caskroom/cask'$({reset})
        ''')
        return set() if retset else dict(cask=set())

    mode = '-*- Caskroom -*-'.center(80, ' ')
    with open(file, 'a') as logfile:
        logfile.write(f'\n\n{mode}\n\n')

    if not args.quiet:
        os.system(f'echo "-*- $({blue})Caskroom$({reset}) -*-"; echo ;')

    if 'all' in packages:
        logging = subprocess.run(
            ['bash', 'libupdate/logging_cask.sh', greedy, date],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        log = set(logging.stdout.decode().split())
        outdated = 'true' if logging.stdout.decode() else 'false'
        outdated_pkgs = shlex.split(logging.stdout.decode())
    else:
        log = packages
        outdated = 'true'
        outdated_pkgs = list()

    for name in packages:
        subprocess.run(
            ['bash', 'libupdate/update_cask.sh', name, quiet, verbose, date, force, greedy, outdated] + outdated_pkgs
        )

    if cleanup:
        mode = '-*- Cleanup -*-'.center(80, ' ')
        with open(file, 'a') as logfile:
            logfile.write(f'\n\n{mode}\n\n')

        if not args.quiet:
            time.sleep(1)
            os.system('tput clear')
            os.system(f'echo "-*- $({blue})Cleanup$({reset}) -*-"; echo ;')

        subprocess.run(
            ['bash', 'libupdate/cleanup.sh', 'false', 'true', quiet, verbose, date]
        )

    if not args.quiet:
        time.sleep(1)
        os.system('tput clear')
    return log if retset else dict(cask=log)


def update_appstore(args, *, file, date, retset=False):
    quiet = str(args.quiet).lower()
    verbose = str(args.verbose).lower()
    packages = _merge_packages(args)

    if shutil.which('softwareupdate') is None:
        return set() if retset else dict(appstore=set())

    mode = '-*- App Store -*-'.center(80, ' ')
    with open(file, 'a') as logfile:
        logfile.write(f'\n\n{mode}\n\n')

    if not args.quiet:
        os.system(f'echo "-*- $({blue})App Store$({reset}) -*-"; echo ;')

    logging = subprocess.run(
        ['bash', 'libupdate/logging_appstore.sh', date],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    if 'all' in packages:
        log = set(re.split('[\n\r]', logging.stdout.decode().strip()))
        outdated = 'true' if logging.stdout.decode() else 'false'
    else:
        log = packages
        outdated = 'true'

    for name in packages:
        subprocess.run(
            ['sudo', 'bash', 'libupdate/update_appstore.sh', name, quiet, verbose, date, outdated]
        )

    if not args.quiet:
        time.sleep(1)
        os.system('tput clear')
    return log if retset else dict(appstore=log)


def update_all(args, *, file, date):
    quiet = str(args.quiet).lower()
    verbose = str(args.verbose).lower()

    log = dict(
        apm = update_apm(args, retset=True, file=file, date=date),
        pip = update_pip(args, retset=True, file=file, date=date),
        brew = update_brew(args, cleanup=False, retset=True, file=file, date=date),
        cask = update_cask(args, cleanup=False, retset=True, file=file, date=date),
        appstore = update_appstore(args, retset=True, file=file, date=date),
    )

    mode = '-*- Cleanup -*-'.center(80, ' ')
    with open(file, 'a') as logfile:
        logfile.write(f'\n\n{mode}\n\n')

    if not args.quiet:
        time.sleep(1)
        os.system('tput clear')
        os.system(f'echo "-*- $({blue})Cleanup$({reset}) -*-"; echo ;')

    subprocess.run(
        ['bash', 'libupdate/cleanup.sh', 'true', 'true', quiet, verbose, date]
    )

    if not args.quiet:
        time.sleep(1)
        os.system('tput clear')
    return log
