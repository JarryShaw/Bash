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


def update_apm(args, *, retset=False):
    quiet = '--quiet' if args.quiet else ''
    verbose = '--verbose' if args.verbose else ''
    package = _merge_packages(args)

    if not quiet:
        os.system('echo "-*- $({color})Atom$({reset}) -*-"; echo ;'.format(
            color='tput setaf 14', reset='tput sgr0'
        ))

    apm = subprocess.Popen(shlex.split('apm update --list --no-color'), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    grep = subprocess.Popen(shlex.split('grep -e "*"'), stdin=apm.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    sed = subprocess.Popen(shlex.split('sed "s/.* \(.*\)* .* -> .*/\1/"'), stdin=grep.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8')
    apm.stdout.close()
    grep.stdout.close()
    output, error = sed.communicate()
    if 'all' in package:
        log = set(output.split())
        outdated = 'true' if output else 'false'
    else:
        log = package
        outdated = 'true'

    for name in package:
        subprocess.run(
            ['bash', 'libupdate/update_apm.sh', name, quiet, verbose, outdated] + shlex.split(output)
        )

    os.system('cls' if os.name == 'nt' else 'clear')
    return log if retset else dict(appstore=log)


def update_pip(args, *, retset=False):
    quiet = '--quiet' if args.quiet else ''
    verbose = '--verbose' if args.verbose else ''
    package = _merge_packages(args)

    if not quiet:
        os.system('echo "-*- $({color})Python$({reset}) -*-"; echo ;'.format(
            color='tput setaf 14', reset='tput sgr0'
        ))

    if 'all' in package or not all((args.system, args.brew, args.cpython, args.pypy)):
        system, brew, cpython, pypy, version = 'true', 'true', 'true', 'true', '1'
        logging = subprocess.run(
            ['bash', 'libupdate/logging_pip.sh', system, brew, cpython, pypy, version],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8'
        )
        log = set(logging.stdout.split())
    else:
        system, brew, cpython, pypy, version = \
            str(args.system).lower(), str(args.brew).lower(), \
            str(args.cpython).lower(), str(args.pypy).lower(), str(args.version)
        log = package

    for name in package:
        subprocess.run(
            ['bash', 'libupdate/update_pip.sh', name, system, brew, cpython, pypy, version, quiet, verbose]
        )

    os.system('cls' if os.name == 'nt' else 'clear')
    return log if retset else dict(pip=log)


def update_brew(args, *, cleanup=True, retset=False):
    quiet = '--quiet' if args.quiet else ''
    verbose = '--verbose' if args.verbose else ''
    package = _merge_packages(args)

    if not quiet:
        os.system('echo "-*- $({color})Homebrew$({reset}) -*-"; echo ;'.format(
            color='tput setaf 14', reset='tput sgr0'
        ))

    subprocess.run(
        ['bash', 'libupdate/logging_brew.sh', quiet, verbose]
    )

    logging = subprocess.run(
        shlex.split('brew outdated --quiet'),
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8'
    )
    if 'all' in package:
        log = set(logging.stdout.split())
        outdated = 'true' if logging.stdout else 'false'
    else:
        log = package
        outdated = 'true'

    for name in package:
        subprocess.run(
            ['bash', 'libupdate/update_brew.sh', name, quiet, verbose, outdated] + shlex.split(logging.stdout)
        )

    if cleanup:
        subprocess.run(
            ['bash', 'libupdate/cleanup.sh', 'true', 'false', quiet, verbose]
        )

    os.system('cls' if os.name == 'nt' else 'clear')
    return log if retset else dict(brew=log)


def update_cask(args, *, cleanup=True, retset=False):
    quiet = '--quiet' if args.quiet else ''
    verbose = '--verbose' if args.verbose else ''
    package = _merge_packages(args)

    if not quiet:
        os.system('echo "-*- $({color})Caskroom$({reset}) -*-"; echo ;'.format(
            color='tput setaf 14', reset='tput sgr0'
        ))

    if 'all' in package:
        logging = subprocess.run(
            shlex.split('brew cask outdated --quiet'),
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8'
        )
        log = set(logging.stdout.split())
        outdated = 'true' if logging.stdout else 'false'
    else:
        log = package
        outdated = 'true'

    for name in package:
        subprocess.run(
            ['bash', 'libupdate/update_cask.sh', name, quiet, verbose, outdated]
        )

    if cleanup:
        subprocess.run(
            ['bash', 'libupdate/cleanup.sh', 'false', 'true', quiet, verbose]
        )

    os.system('cls' if os.name == 'nt' else 'clear')
    return log if retset else dict(cask=log)


def update_appstore(args, *, retset=False):
    quiet = '--quiet' if args.quiet else ''
    verbose = '--verbose' if args.verbose else ''
    package = _merge_packages(args)

    if not quiet:
        os.system('echo "-*- $({color})App Store$({reset}) -*-"; echo ;'.format(
            color='tput setaf 14', reset='tput sgr0'
        ))

    softwareupdate = subprocess.Popen(shlex.split('softwareupdate --list'), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    grep = subprocess.Popen(shlex.split('grep -e "*"'), stdin=softwareupdate.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    sed = subprocess.Popen(shlex.split('sed "s/.*\* \(.*\)*.*/\1/"'), stdin=grep.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8')
    softwareupdate.stdout.close()
    grep.stdout.close()
    output, error = sed.communicate()
    if 'all' in package:
        log = set(output.split('\n'))
        outdated = 'true' if output else 'false'
    else:
        log = package
        outdated = 'true'

    for name in package:
        subprocess.run(
            ['bash', 'libupdate/update_appstore.sh', name, quiet, verbose, outdated]
        )

    os.system('cls' if os.name == 'nt' else 'clear')
    return log if retset else dict(appstore=log)


def update_all(args):
    quiet = '--quiet' if args.quiet else ''
    verbose = '--verbose' if args.verbose else ''
    os.system('sudo -H echo ;')

    log = dict(
        # apm = update_apm(args, retset=True),
        pip = update_pip(args, retset=True),
        # brew = update_brew(args, cleanup=False, retset=True),
        # cask = update_cask(args, cleanup=False, retset=True),
        # appstore = update_appstore(args, retset=True),
    )

    # subprocess.run(
    #     ['bash', 'libupdate/cleanup.sh', 'true', 'true', quiet, verbose]
    # )

    os.system('cls' if os.name == 'nt' else 'clear')
    return log
