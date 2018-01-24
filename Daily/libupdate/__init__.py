#!/usr/bin/python3
# -*- coding: utf-8 -*-


import os
import shlex
import subprocess


def _merge_packages(args):
    if 'package' in args and args.package:
        allflag = False
        package = set()
        for pkg in args.package:
            if allflag: break
            mapping = map(shlex.split, pkg.split(','))
            for list_ in mapping:
                if 'all' in list_:
                    package = {'all'}
                    allflag = True; break
                package = package.union(set(list_))
    else:
        package = {'all'}
    return package


def update_apm(args, *, file, date, retset=False):
    quiet = str(args.quiet).lower()
    verbose = str(args.verbose).lower()
    package = _merge_packages(args)

    open(file.name, 'a').write('\n\n{mode}\n\n'.format(mode='-*- Atom -*-'.center(80, ' ')))
    if not args.quiet:
        os.system('echo "-*- $({color})Atom$({reset}) -*-"; echo ;'.format(
            color='tput setaf 14', reset='tput sgr0'
        ))

    if 'all' in package:
        logging = subprocess.run(
            ['bash', 'libupdate/logging_apm.sh', date],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8'
        )
        log = set(logging.stdout.split())
        outdated = 'true' if logging.stdout else 'false'
    else:
        log = package
        outdated = 'true'

    for name in package:
        subprocess.run(
            ['bash', 'libupdate/update_apm.sh', name, quiet, verbose, date, outdated] + shlex.split(logging.stdout)
        )

    os.system('cls' if os.name == 'nt' else 'clear')
    return log if retset else dict(appstore=log)


def update_pip(args, *, file, date, retset=False):
    quiet = str(args.quiet).lower()
    verbose = str(args.verbose).lower()
    package = _merge_packages(args)

    open(file.name, 'a').write('\n\n{mode}\n\n'.format(mode='-*- Python -*-'.center(80, ' ')))
    if not args.quiet:
        os.system('echo "-*- $({color})Python$({reset}) -*-"; echo ;'.format(
            color='tput setaf 14', reset='tput sgr0'
        ))

    if 'all' in package and not any((args.system, args.brew, args.cpython, args.pypy)):
        system, brew, cpython, pypy, version = 'true', 'true', 'true', 'true', '1'
    else:
        system, brew, cpython, pypy, version = \
            str(args.system).lower(), str(args.brew).lower(), \
            str(args.cpython).lower(), str(args.pypy).lower(), str(args.version or 1)

    logging = subprocess.run(
        ['bash', 'libupdate/logging_pip.sh', system, brew, cpython, pypy, version, date],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8'
    )
    log = set(logging.stdout.split())
    print(logging.stdout)

    # for name in package:
    #     subprocess.run(
    #         ['bash', 'libupdate/update_pip.sh', name, system, brew, cpython, pypy, version, quiet, verbose, date]
    #     )

    os.system('cls' if os.name == 'nt' else 'clear')
    return log if retset else dict(pip=log)


def update_brew(args, *, file, date, cleanup=True, retset=False):
    quiet = str(args.quiet).lower()
    verbose = str(args.verbose).lower()
    package = _merge_packages(args)

    open(file.name, 'a').write('\n\n{mode}\n\n'.format(mode='-*- Homebrew -*-'.center(80, ' ')))
    if not args.quiet:
        os.system('echo "-*- $({color})Homebrew$({reset}) -*-"; echo ;'.format(
            color='tput setaf 14', reset='tput sgr0'
        ))

    subprocess.run(
        ['bash', 'libupdate/renew_brew.sh', quiet, verbose, date]
    )

    if 'all' in package:
        logging = subprocess.run(
            ['bash', 'libupdate/logging_brew.sh', date],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8'
        )
        log = set(logging.stdout.split())
        outdated = 'true' if logging.stdout else 'false'
    else:
        log = package
        outdated = 'true'

    for name in package:
        subprocess.run(
            ['bash', 'libupdate/update_brew.sh', name, quiet, verbose, date, outdated] + shlex.split(logging.stdout)
        )

    if cleanup:
        subprocess.run(
            ['bash', 'libupdate/cleanup.sh', 'true', 'false', quiet, verbose, date]
        )

    os.system('cls' if os.name == 'nt' else 'clear')
    return log if retset else dict(brew=log)


def update_cask(args, *, file, date, cleanup=True, retset=False):
    quiet = str(args.quiet).lower()
    verbose = str(args.verbose).lower()
    package = _merge_packages(args)

    open(file.name, 'a').write('\n\n{mode}\n\n'.format(mode='-*- Caskroom -*-'.center(80, ' ')))
    if not args.quiet:
        os.system('echo "-*- $({color})Caskroom$({reset}) -*-"; echo ;'.format(
            color='tput setaf 14', reset='tput sgr0'
        ))

    if 'all' in package:
        logging = subprocess.run(
            ['bash', 'libupdate/logging_cask.sh', date],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8'
        )
        log = set(logging.stdout.split())
        outdated = 'true' if logging.stdout else 'false'
    else:
        log = package
        outdated = 'true'

    for name in package:
        subprocess.run(
            ['bash', 'libupdate/update_cask.sh', name, quiet, verbose, date, outdated]
        )

    if cleanup:
        subprocess.run(
            ['bash', 'libupdate/cleanup.sh', 'false', 'true', quiet, verbose, date]
        )

    os.system('cls' if os.name == 'nt' else 'clear')
    return log if retset else dict(cask=log)


def update_appstore(args, *, file, date, retset=False):
    quiet = str(args.quiet).lower()
    verbose = str(args.verbose).lower()
    package = _merge_packages(args)

    open(file.name, 'a').write('\n\n{mode}\n\n'.format(mode='-*- App Store -*-'.center(80, ' ')))
    if not args.quiet:
        os.system('echo "-*- $({color})App Store$({reset}) -*-"; echo ;'.format(
            color='tput setaf 14', reset='tput sgr0'
        ))

    logging = subprocess.run(
        ['bash', 'libupdate/logging_appstore.sh', date],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8'
    )
    if 'all' in package:
        log = set(logging.stdout.split('\n'))
        outdated = 'true' if logging.stdout else 'false'
    else:
        log = package
        outdated = 'true'

    for name in package:
        subprocess.run(
            ['bash', 'libupdate/update_appstore.sh', name, quiet, verbose, date, outdated]
        )

    os.system('cls' if os.name == 'nt' else 'clear')
    return log if retset else dict(appstore=log)


def update_all(args, *, file, date):
    quiet = str(args.quiet).lower()
    verbose = str(args.verbose).lower()
    os.system('sudo -H echo ;')

    log = dict(
        apm = update_apm(args, retset=True, file=file, date=date),
        pip = update_pip(args, retset=True, file=file, date=date),
        brew = update_brew(args, cleanup=False, retset=True, file=file, date=date),
        cask = update_cask(args, cleanup=False, retset=True, file=file, date=date),
        appstore = update_appstore(args, retset=True, file=file, date=date),
    )

    subprocess.run(
        ['bash', 'libupdate/cleanup.sh', 'true', 'true', quiet, verbose, date]
    )

    os.system('cls' if os.name == 'nt' else 'clear')
    return log
