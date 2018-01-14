#!/bin/bash

################################################################################
# Uninstall dependencies of certain pakages.
#
# - For homebrew
# $ bash uninstall.sh -m brew -a                # uninstall all packages
# $ bash uninstall.sh -m brew -p package        # uninstall dependencies of `package`
# 
# - For pip
# $ bash uninstall.sh -m pip -a                 # uninstall all packages
# $ bash uninstall.sh -m pip -p package         # uninstall dependencies of `package`
# 
# - For pip3
# $ bash uninstall.sh -m pip3 -a                # uninstall all packages
# $ bash uninstall.sh -m pip3 -p package        # uninstall dependencies of `package`
# 
# - For pip_pypy
# $ bash uninstall.sh -m pip_pypy -a            # uninstall all packages
# $ bash uninstall.sh -m pip_pypy -p package    # uninstall dependencies of `package`
# 
# - For pip_pypy3
# $ bash uninstall.sh -m pip_pypy3 -a           # uninstall all packages
# $ bash uninstall.sh -m pip_pypy3 -p package   # uninstall dependencies of `package`
################################################################################

# set default values
srcf="none"
mode="none"
verf="none"
pkgf="none"
sysf=false
hmbf=false
cpyf=false
ppyf=false

# extract options and their arguments into variables
while true ; do
    case "$1" in
        -a|--all)
            sysf=true ; hmbf=true
            cpyf=true ; ppyf=true
            verf="1" ; pkgf="all"
            mode="all" ; shift ; break ;;
        -h|--help)
            case "$2" in
                "") srcf="all" ; shift 2 ;;
                *)  srcf=$2 ; shift 2 ;;
            esac
            help_src srcf ; exit 0 ;;
        -m|--mode)
            case "$2" in
                "") echo "uninstall: invalid usage -- m"
                    help_src "mode" ; shift 2 ; exit 1 ;;
                *)  mode=$2 ; shift 2 ;;
            esac
            while true ; do
                case "$1" in 
                    -h|--help)
                        help_src "mode" ; shift ; exit 0 ;;
                    -v|--version)
                        case "$2" in
                            1|23|32)
                                verf="1" ; shift 2 ;;
                            2)  verf="2" ; shift 2 ;;
                            3)  verf="3" ; shift 2 ;;
                            *)  echo "uninstall: invalid option -- $2"
                                help_src "version" ; shift 2 ; exit 1 ;;
                        esac ;;
                    -p|--package)
                        case "$2" in
                            "") pkgf="all" ; shift 2 ;;
                            *)  pkgf=$2 ; shift 2 ;;
                        esac ;;
                    -s|--system)
                        sysf=true ; shift ;;
                    -b|--brew)
                        hmbf=true ; shift ;;
                    -c|--cpython)
                        cpyf=true ; shift ;;
                    -y|--pypy)
                        ppyf=true ; shift ;;
                    -va)
                        verf="1" ; shift ;;
                    -pa)
                        pkgf="all" ; shift ;;
                    -ma)
                        sysf=true ; hmbf=true
                        cpyf=true ; ppyf=true
                        verf="1" ; pkgf="all"
                        shift ; break ;;
                    -sa)
                        sysf=true ; verf="1"
                        cpyf=true ; ppyf=true
                        pkgf="all" ; shift ; break ;;
                    -ba)
                        hmbf=true ; verf="1"
                        cpyf=true ; ppyf=true
                        pkgf="all" ; shift ; break ;;
                    -ca)
                        cpyf=true ; verf="1"
                        sysf=true ; hmbf=true
                        pkgf="all" ; shift ; break ;;
                    -ya)
                        ppyf=true ; verf="1"
                        sysf=true ; hmbf=true
                        pkgf="all" ; shift ; break ;;
                    *)  break ;;
                esac
            done 
            break ;;
        --) shift ; break ;;
        *)  echo "uninstall: invalid option -- $1"
            help_src "all" ; exit 1 ;;
    esac
done

case $mode in
    "all")
        bash ./src.uninstall/uninstall_pip.sh $sysf $hmbf $cpyf $ppyf $verf $pkgf ; sleep 1
        bash ./src.uninstall/uninstall_brew.sh $pkgf ; sleep 1
        bash ./src.uninstall/uninstall_cask.sh $pkgf ; sleep 1 ;;
    "pip")
        bash ./src.uninstall/uninstall_pip.sh $sysf $hmbf $cpyf $ppyf $verf $pkgf ; sleep 1 ;;
    "brew")
        bash ./src.uninstall/uninstall_brew.sh $pkgf ; sleep 1 ;;
    "cask")
        bash ./src.uninstall/uninstall_cask.sh $pkgf ; sleep 1  ;;
    "none")
        help_src "all" ; exit 0 ;;
    *)  echo "uninstall: invalid usage -- m"
        help_src "mode" ; exit 1 ;;
esac
