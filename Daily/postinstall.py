#!/usr/bin/python3
# -*- coding: utf-8 -*-


import argparse
import libprinstall
import os


# version string
__version__ = '0.3.0'


def get_parser():
    parser = argparse.ArgumentParser(prog='postinstall', description=(
        'Automatic Homebrew Package Postinstall Manager'
    ))
    parser.add_argument('-v', '--version', action='version',
                        version='{}'.format(__version__))
    parser.add_argument('-a', '--all', action='store_true', default=False,
                        dest='all', help=(
                            'Postinstall all packages installed through Homebrew.'
                        ))
    parser.add_argument('-p', '--package', metavar='PKG', action='append',
                        dest='package', help=(
                            'Name of packages to be postinstalld, default is null.'
                        ))
    parser.add_argument('-s', '--startwith', metavar='START', action='store',
                        dest='start', help=(
                            'Postinstall procedure starts from which package.'
                        ))
    parser.add_argument('-q', '--quiet', action='store_true', default=False,
                        help=(
                            'Run in quiet mode, with no output information.'
                        ))

    return parser


def main():
    parser = get_parser()
    args = parser.parse_args()

    log = libprinstall.postinstall(args)
    os.system('cls' if os.name == 'nt' else 'clear')

    if log:
        print('Postinstalled packages: {}'.format(', '.join(log)))
    else:
        print('No postinstallation.')


if __name__ == '__main__':
    main()
