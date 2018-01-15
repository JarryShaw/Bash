#!/usr/bin/python3
# -*- coding: utf-8 -*-


import os
import shlex
import subprocess


def _append_package(args):
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


def update_pip(args):
    quiet = '--quiet' if args.quiet else ''
    package = _append_package(args)

    if 'all' in package or not all((args.system, args.brew, args.cpython, args.pypy)):
        system, brew, cpython, pypy, version = 'true', 'true', 'true', 'true', '1'
        logging = subprocess.Popen(
            ['bash', './logging_pip.sh', system, brew, cpython, pypy, version],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = logging.communicate()
        log = dict(pip=set(output.decode().split()))
    else:
        system, brew, cpython, pypy, version = \
            str(args.system).lower(), str(args.brew).lower(), \
            str(args.cpython).lower(), str(args.pypy).lower(), str(args.version)
        log = dict(pip=package)

    for temppkg in package:
        process = subprocess.Popen(
            ['bash', './update_pip.sh', system, brew, cpython, pypy, version, temppkg, quiet],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = process.communicate()

    if args.quiet:
        print(output.decode())
    return log


def update_brew(args):
    quiet = '-q' if args.quiet else ''
    package = _append_package(args)

    os.system('( set -x; brew update {}; )'.format(quiet))

    logging = subprocess.Popen(
        shlex.split('brew outdated'),
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    output, error = logging.communicate()
    if 'all' in package:
        log = dict(brew=set(output.decode().split()))
    else:
        log = dict(brew=package)

    for temppkg in package:
        process = subprocess.Popen(
            ['bash', './update_brew.sh', quiet, temppkg] + \
                shlex.split(output.decode()),
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = process.communicate()

    if args.quiet:
        print(output.decode())
    return log


def update_cask(args):
    quiet = '-q' if args.quiet else ''
    package = _append_package(args)

    if 'all' in package:
        logging = subprocess.Popen(
            shlex.split('brew cask outdated'),
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = logging.communicate()
        log = dict(cask=set(output.decode().split()))
    else:
        log = dict(cask=package)

    for temppkg in package:
        process = subprocess.Popen(
            ['bash', './update_cask.sh', quiet, temppkg],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = process.communicate()

    if args.quiet:
        print(output.decode())
    return log


def update_appstore(args):
    quiet = '-q' if args.quiet else ''
    package = _append_package(args)

    logging = subprocess.Popen(
        shlex.split('softwareupdate --list'),
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    output, error = logging.communicate()
    if 'all' not in package:
        log = dict(appstore=package)
    elif 'No new software available.' in output.decode():
        log = dict(appstore=set())
    else:
        log = dict(appstore=set(output.decode().replace(
                'Software Update Tool\n\nFinding available software\n', ''
            ).split()))

    for temppkg in package:
        process = subprocess.Popen(
            ['bash', './update_appstore.sh', quiet, temppkg],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = process.communicate()

    if args.quiet:
        print(output.decode())
    return log


def update_all(args):
    log = update_pip(args)
    os.system('cls' if os.name=='nt' else 'clear')
    log += update_brew(args)
    os.system('cls' if os.name=='nt' else 'clear')
    log += update_cask(args)
    os.system('cls' if os.name=='nt' else 'clear')
    log += update_appstore(args)

    return log
