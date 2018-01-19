#!/usr/bin/python3
# -*- coding: utf-8 -*-


import argparse
import libupdate
import os


# version string
__version__ = '0.3.0'


NAME = dict(
    pip = 'Python',
    brew = 'Homebrew',
    cask = 'Caskroom',
    appstore = 'App Store',
)


def get_parser():
    parser = argparse.ArgumentParser(prog='update', description=(
        'Automatic Package Update Manager'
    ))
    parser.add_argument('-v', '--version', action='version',
                        version='{}'.format(__version__))
    parser.add_argument('-a', '--all', action='store_true', default=True,
                        dest='all', help=(
                            'Update all packages installed through pip, '
                            'Homebrew, and App Store.'
                        ))
    subparser = parser.add_subparsers(title='mode selection', metavar='MODE',
                        dest='mode', help=(
                            'Update outdated packages installed through '
                            'a specified method, e.g.: pip, brew, cask, '
                            'or appstore.'
                        ))

    parser_pip = subparser.add_parser('pip', description=(
                            'Update pip installed packages.'
                        ))
    parser_pip.add_argument('-a', '--all', action='store_true', default=True,
                        dest='all', help=(
                            'Update all packages installed through pip.'
                        ))
    parser_pip.add_argument('-v', '--version', action='store', metavar='VER',
                        dest='version', type=int, help=(
                            'Indicate which version of pip will be updated.'
                        ))
    parser_pip.add_argument('-s', '--system', action='store_true', default=False,
                        dest='system', help=(
                            'Update pip packages on system level, i.e. python '
                            'installed through official installer.'
                        ))
    parser_pip.add_argument('-b', '--brew', action='store_true', default=False,
                        dest='brew', help=(
                            'Update pip packages on Cellar level, i.e. python '
                            'installed through Homebrew.'
                        ))
    parser_pip.add_argument('-c', '--cpython', action='store_true', default=False,
                        dest='cpython', help=(
                            'Update pip packages on CPython environment.'
                        ))
    parser_pip.add_argument('-y', '--pypy', action='store_true', default=False,
                        dest='pypy', help=(
                            'Update pip packages on Pypy environment.'
                        ))
    parser_pip.add_argument('-p', '--package', metavar='PKG', action='append',
                        dest='package', help=(
                            'Name of packages to be updated, default is all.'
                        ))
    parser_pip.add_argument('-q', '--quiet', action='store_true', default=False,
                        help=(
                            'Run in quiet mode, with no output information.'
                        ))
    # parser_pip.add_argument('extra', metavar='MODE', nargs='*', help='Other commands.')

    parser_brew = subparser.add_parser('brew', description=(
                            'Update Homebrew installed packages.'
                        ))
    parser_brew.add_argument('-a', '--all', action='store_true', default=True,
                        dest='all', help=(
                            'Update all packages installed through Homebrew.'
                        ))
    parser_brew.add_argument('-p', '--package', metavar='PKG', action='append',
                        dest='package', help=(
                            'Name of packages to be updated, default is all.'
                        ))
    parser_brew.add_argument('-q', '--quiet', action='store_true', default=False,
                        help=(
                            'Run in quiet mode, with no output information.'
                        ))
    # parser_brew.add_argument('extra', metavar='MODE', nargs='*', help='Other commands.')

    parser_cask = subparser.add_parser('cask', description=(
                            'Update installed Caskroom packages.'
                        ))
    parser_cask.add_argument('-a', '--all', action='store_true', default=True,
                        dest='all', help=(
                            'Update all packages installed through Caskroom.'
                        ))
    parser_cask.add_argument('-p', '--package', metavar='PKG', action='append',
                        dest='package', help=(
                            'Name of packages to be updated, default is all.'
                        ))
    parser_cask.add_argument('-q', '--quiet', action='store_true', default=False,
                        help=(
                            'Run in quiet mode, with no output information.'
                        ))
    # parser_cask.add_argument('extra', metavar='MODE', nargs='*', help='Other commands.')

    parser_appstore = subparser.add_parser('appstore', description=(
                            'Update App Store installed packages.'
                        ))
    parser_appstore.add_argument('-a', '--all', action='store_true', default=True,
                        dest='all', help=(
                            'Update all packages installed through App Store.'
                        ))
    parser_appstore.add_argument('-p', '--package', metavar='PKG', action='append',
                        dest='package', help=(
                            'Name of packages to be updated, default is all.'
                        ))
    parser_appstore.add_argument('-q', '--quiet', action='store_true', default=False,
                        help=(
                            'Run in quiet mode, with no output information.'
                        ))
    # parser_appstore.add_argument('extra', metavar='MODE', nargs='*', help='Other commands.')

    parser.add_argument('-q', '--quiet', action='store_true', default=False,
                        help=(
                            'Run in quiet mode, with no output information.'
                        ))
    # parser.add_argument('extra', metavar='MODE', nargs='*', help='Other commands.')

    return parser


def main():
    # sys.argv.insert(1, '--all')
    parser = get_parser()
    args = parser.parse_args()

    if args.mode == 'pip':
        log = libupdate.update_pip(args)
    elif args.mode == 'brew':
        log = libupdate.update_brew(args)
    elif args.mode == 'cask':
        log = libupdate.update_cask(args)
    elif args.mode == 'appstore':
        log = libupdate.update_appstore(args)
    else:
        log = libupdate.update_all(args)

    os.system('cls' if os.name == 'nt' else 'clear')

    for mode in log:
        if log[mode]:
            print('Updated packages in {}\n\t{}'.format(
                NAME.get(mode, mode), ', '.join(log[mode])
            ))
        else:
            print('No updates in {}'.format(NAME.get(mode, mode)))


if __name__ == '__main__':
    main()
