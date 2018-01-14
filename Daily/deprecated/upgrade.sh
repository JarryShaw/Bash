#!/bin/bash

################################################################################
# Clean up caches.
################################################################################

function cleanup {
    flag_brew=$1
    flag_cask=$2

    clear
    printf "\n-*- Cleanup -*-\n"

    printf "\nbrew prune\n"
    brew prune

    if [ -e "/Volumes/Jarry\ Shaw/" ] ; then
        printf "\narchiving caches\n"
        cp -rf $(brew --cache) /Volumes/Jarry\ Shaw/Developers/

        if ( $flag_brew ) ; then
            printf "\nbrew cleanup\n"
            brew cleanup
        fi

        if ( $flag_cask ) ; then
            printf "\nbrew cask cleanup\n"
            brew cask cleanup
        fi
    fi
}

################################################################################
# Help contents.
################################################################################

function help_src {
    HELP="                              \
    usage: upgrade <cmd> [<args> ...)   \

    -a | --all      upgrade all modes   \
    -m | 
    -h | --help     print this help     \
    "
}

################################################################################
# Upgrade certain packages or applications.
#
# $ bash upgrade.sh                         # upgrade all
# $ bash upgrade.sh -a                      # upgrade all
# $ bash upgrade.sh -m mode                 # upgrade all of `mode`
# $ bash upgrade.sh -m mode -a              # upgrade all of `mode`
# 
# $ bash upgrade.sh -m mode -p package      # upgrade `package` of `mode`
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
bclf=false
cclf=false
gclf=false

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
                "") echo "upgrade: invalid usage -- m"
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
                            *)  echo "upgrade: invalid option -- $2"
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
        *)  echo "upgrade: invalid option -- $1"
            help_src "all" ; exit 1 ;;
    esac
done

case $mode in
    "all")
        bash ./src.upgrade/upgrade_software.sh $pkgf; sleep 1
        bash ./src.upgrade/upgrade_pip.sh $sysf $hmbf $cpyf $ppyf $verf $pkgf ; sleep 1
        bash ./src.upgrade/upgrade_brew.sh $pkgf ; sleep 1
        bash ./src.upgrade/upgrade_cask.sh $pkgf ; sleep 1
        bclf=true ; cclf=true ; gclf=true ;;
    "software")
        bash ./src.upgrade/upgrade_software.sh $pkgf ; sleep 1 ;;
    "pip")
        bash ./src.upgrade/upgrade_pip.sh $sysf $hmbf $cpyf $ppyf $verf $pkgf ; sleep 1 ;;
    "brew")
        bash ./src.upgrade/upgrade_brew.sh $pkgf ; sleep 1
        bclf=true ; gclf=true ;;
    "cask")
        bash ./src.upgrade/upgrade_cask.sh $pkgf ; sleep 1 
        cclf=true ; gclf=true ;;
    "none")
        help_src "all" ; exit 0 ;;
    *)  echo "upgrade: invalid usage -- m"
        help_src "mode" ; exit 1 ;;
esac

if ( $gclf ) ; then
    cleanup $bclf $cclf
fi
