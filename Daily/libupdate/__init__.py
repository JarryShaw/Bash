#!/usr/bin/python3
# -*- coding: utf-8 -*-


import os
import shlex
import subprocess


def update_pip(args):
    quiet = '--quiet' if args.quiet else ''
    if 'package' in args and args.package:
        package, system, brew, cpython, pypy, version = \
            args.package, args.system, args.brew, args.cpython, args.pypy, args.version
    else:
        package = 'all'
        system, brew, cpython, pypy = True, True, True, True
        version = 1

    if package == 'all':
        logging = subprocess.Popen(
            ['bash', './logging_pip.sh', system, brew, cpython, pypy, version],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = logging.communicate()
        log = dict(brew=output.decode().split())
    else:
        log = dict(brew=package)

    process = subprocess.Popen(
        ['bash', './update_pip.sh', system, brew, cpython, pypy, version, package, quiet],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    output, error = process.communicate()

    return log


def update_brew(args):
    quiet = '-q' if args.quiet else ''
    package = args.package or 'all'

    os.system('( set -x; brew update {}; )'.format(quiet))

    logging = subprocess.Popen(
        shlex.split('brew outdated'),
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    output, error = logging.communicate()
    if args.package:
        log = dict(brew=package)
    else:
        log = dict(brew=output.decode().split())

    process = subprocess.Popen(
        ['bash', './update_brew.sh', quiet, package, output],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    output, error = process.communicate()

    return log


def update_cask(args):
    quiet = '-q' if args.quiet else ''
    package = args.package or 'all'

    if args.package:
        logging = subprocess.Popen(
            shlex.split('brew cask outdated'),
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = logging.communicate()
        log = dict(cask=package)
    else:
        log = dict(cask=output.decode().split())

    process = subprocess.Popen(
        ['bash', './update_cask.sh', quiet, package],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    output, error = process.communicate()

    return log


def update_appstore(args):
    quiet = '-q' if args.quiet else ''
    package = args.package or 'all'

    logging = subprocess.Popen(
        shlex.split('softwareupdate --list'),
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    output, error = logging.communicate()
    if args.package:
        log = dict(appstore=package)
    elif 'No new software available.' in output.decode():
        log = dict(appstore=list())
    else:
        log = dict(appstore=output.decode().replace(
                'Software Update Tool\n\nFinding available software\n', ''
            ).split())

    process = subprocess.Popen(
        ['bash', './update_appstore.sh', quiet, package],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    output, error = process.communicate()

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
