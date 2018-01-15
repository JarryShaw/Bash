#!/usr/bin/python3
# -*- coding: utf-8 -*-


import argparse
import libuninstall


# version string
__version__ = '0.3.0'


NAME = dict(
    pip = 'pip',
    brew = 'Homebrew',
    cask = 'Caskroom',
)


def get_parser():
    parser = argparse.ArgumentParser(prog='uninstall', description=(
        'Automatic Package Recursive Uninstaller'
    ))
    parser.add_argument('-v', '--version', action='version',
                        version='{}'.format(__version__))
    subparser = parser.add_subparsers(title='mode selection', metavar='MODE',
                        dest='mode', help=(
                            'Uninstall given packages installed through '
                            'a specified method, e.g.: pip, brew, cask.'
                        ))

    parser_pip = subparser.add_parser('pip', description=(
                            'Uninstall pip installed packages.'
                        ))
    parser_pip.add_argument('-a', '--all', action='store_true', default=True,
                        dest='all', help=(
                            'Uninstall all packages installed through pip.'
                        ))
    parser_pip.add_argument('-v', '--version', action='store', metavar='VER',
                        dest='version', type=int, help=(
                            'Indicate packages in which version of pip will '
                            'be uninstalld.'
                        ))
    parser_pip.add_argument('-s', '--system', action='store_true', default=False,
                        dest='system', help=(
                            'Uninstall pip packages on system level, i.e. python '
                            'installed through official installer.'
                        ))
    parser_pip.add_argument('-b', '--brew', action='store_true', default=False,
                        dest='cpython', help=(
                            'Uninstall pip packages on Cellar level, i.e. python '
                            'installed through Homebrew.'
                        ))
    parser_pip.add_argument('-c', '--cpython', action='store_true', default=False,
                        dest='cpython', help=(
                            'Uninstall pip packages on CPython environment.'
                        ))
    parser_pip.add_argument('-y', '--pypy', action='store_true', default=False,
                        dest='pypy', help=(
                            'Uninstall pip packages on Pypy environment.'
                        ))
    parser_pip.add_argument('-p', '--package', metavar='PKG', action='append'
                        dest='package', help=(
                            'Name of packages to be uninstalld, default is null.'
                        ))
    parser_pip.add_argument('-Y', '--yes', action='store_true', default=True,
                        dest='yes', help=(
                            'Yes for all selections.'
                        ))

    parser_brew = subparser.add_parser('brew', description=(
                            'Uninstall Homebrew installed packages.'
                        ))
    parser_brew.add_argument('-a', '--all', action='store_true', default=False,
                        dest='all', help=(
                            'Uninstall all packages installed through pip.'
                        ))
    parser_brew.add_argument('-p', '--package', metavar='PKG', action='append'
                        dest='package', help=(
                            'Name of packages to be uninstalld, default is null.'
                        ))
    parser_brew.add_argument('-Y', '--yes', action='store_true', default=True,
                        dest='yes', help=(
                            'Yes for all selections.'
                        ))

    parser_cask = subparser.add_parser('cask', description=(
                            'Uninstall installed Caskroom packages.'
                        ))
    parser_cask.add_argument('-a', '--all', action='store_true', default=False,
                        dest='all', help=(
                            'Uninstall all packages installed through pip.'
                        ))
    parser_cask.add_argument('-p', '--package', metavar='PKG', action='append'
                        dest='package', help=(
                            'Name of packages to be uninstalld, default is null.'
                        ))

    parser.add_argument('-q', '--quiet', action='store_true', default=False,
                        help=(
                            'Run in quiet mode, with no output information.'
                        ))
    parser.add_argument('-y', '--yes', action='store_true', default=True,
                        dest='yes', help=(
                            'Yes for all selections.'
                        ))
    return parser

def main():
    parser = get_parser()
    args = parser.parse_args()

    if args.mode == 'pip':
        log = libuninstall.uninstall_pip(args)
    elif args.mode == 'brew':
        log = libuninstall.uninstall_brew(args)
    elif args.mode == 'cask':
        log = libuninstall.uninstall_cask(args)
    else:
        log = libuninstall.uninstall_all(args)

    os.system('cls' if os.name=='nt' else 'clear')

    for mode in log:
        pprint.pprint('Uninstalld packages in {}\n\t{}'.format(
            NAME.get(mode, mode), ', '.join(log[mode])
        ))

if __name__ == '__main__':
    main()
