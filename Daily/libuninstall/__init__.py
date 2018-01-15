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
                package += list_
    else:
        package = {'null'}
    return package


def uninstall_pip(args):
    quiet = '--quiet' if args.quiet else ''
    package = _append_package(args)

    log = dict(pip=set())
    if 'null' in package:
        return log

    if 'all' in package:
        yes, system, brew, cpython, pypy, version = True, True, True, True, True, 1
    else:
        yes, system, brew, cpython, pypy, version = \
            args.yes, args.system, args.brew, args.cpython, args.pypy, args.version

    for temppkg in package:
        logging = subprocess.Popen(
            ['bash', './logging_pip.sh', system, brew, cpython, pypy, version, temppkg],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = logging.communicate()
        log.get('pip') += set(output.decode().split())

        process = subprocess.Popen(
            ['bash', './uninstall_pip.sh', system, brew,
                cpython, pypy, version, temppkg, quiet, yes],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = process.communicate()

    if args.quiet:
        print(output.decode())
    return log


def uninstall_brew(args):
    quiet = '-q' if args.quiet else ''
    package = _append_package(args)

    log = dict(brew=set())
    if 'null' in package:
        return log

    for temppkg in package:
        logging = subprocess.Popen(
            ['bash', './logging_brew.sh', temppkg],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = logging.communicate()
        log.get('brew') += set(output.decode().split())

        process = subprocess.Popen(
            ['bash', './uninstall_brew.sh', quiet, temppkg, args.yes] \
                + shlex.split(output.decode()),
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = process.communicate()

    if args.quiet:
        print(output.decode())
    return log


def uninstall_cask(args):
    quiet = '-q' if args.quiet else ''
    package = _append_package(args)

    log = dict(cask=set())
    if 'null' in package:
        return log
    elif 'all' in package:
        logging = subprocess.Popen(
            shlex.split('brew cask list'),
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = logging.communicate()
        log.get('cask') += set(output.decode().split())
    else:
        log.get('cask') += package

    for temppkg in package:
        process = subprocess.Popen(
            ['bash', './uninstall_cask.sh', quiet, temppkg],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        output, error = process.communicate()

    if args.quiet:
        print(output.decode())
    return log


def uninstall_all(args):
    log = uninstall_pip(args)
    os.system('cls' if os.name=='nt' else 'clear')
    log += uninstall_brew(args)
    os.system('cls' if os.name=='nt' else 'clear')
    log += uninstall_cask(args)

    return log
