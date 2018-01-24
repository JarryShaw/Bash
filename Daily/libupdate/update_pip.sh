#!/bin/bash


# clear potential ternminal buffer
sript -q /dev/null clear > /dev/null 2>&1 | tee /dev/null


# preset terminal output colours
blush=`tput setaf 1`    # blush / red
green=`tput setaf 2`    # green
reset=`tput sgr0`       # reset


################################################################################
# Check Python site packages updates.
#
# Parameter list:
#   1. Package
#   2. System Flag
#   3. Cellar Flag
#   4. CPython Flag
#   5. Pypy Flag
#   6. Version
#       |-> 1 : Both
#       |-> 2 : Python 2.*
#       |-> 3 : Python 3.*
#   7. Quiet Flag
#   8. Verbose Flag
#   9. Log Date
################################################################################


# parameter assignment
arg_pkg=$1
arg_s=$2
arg_b=$3
arg_c=$4
arg_y=$5
arg_V=$6
arg_q=$7
arg_v=$8
logdate=$9


# log file prepare
logfile="log/update/$logdate.log"
tmpfile="/tmp/update.log"


# remove /temp/update.log
rm -f $tmpfile


# create /temp/update.log & log/update/logdate.log
touch $logfile
touch $tmpfile


# log current status
echo "" >> $tmpfile
echo "- /bin/bash $0 $@" >> $tmpfile


# log commands
logprefix="script -q /dev/null"
if ( $arg_q ) ; then
    logsuffix=">> $tmpfile"
    seperator=""
else
    logsuffix="tee -a \"$tmpfile\""
    seperator="|"
fi


# pip update function usage:
#   pipupdate mode
function pipupdate {
    # parameter assignment
    mode=$1

    # log function call
    echo "+ pipupdate $@" >> $logfile

    # make prefix & suffix of pip
    case $mode in
        1)  # pip_sys
            prefix="/Library/Frameworks/Python.framework/Versions/2.7/bin"
            suffix=""
            pprint="_sys" ;;
        2)  # pip_sys3
            prefix="/Library/Frameworks/Python.framework/Versions/3.6/bin"
            suffix="3"
            pprint="_sys3" ;;
        3)  # pip
            prefix="/usr/local/opt/python/bin"
            suffix=""
            pprint="" ;;
        4)  # pip
            prefix="/usr/local/opt/python3/bin"
            suffix="3"
            pprint="3" ;;
        5)  # pip_pypy
            prefix="/usr/local/opt/pypy/bin"
            suffix="_pypy"
            pprint="_pypy" ;;
        6)  # pip_pypy
            prefix="/usr/local/opt/pypy3/bin"
            suffix="_pypy3"
            pprint="_pypy3" ;;
    esac

    # All or Specified Packages
    case $arg_pkg in
        "all")
            # list=`pipdeptree$pprint | grep -e "==" | grep -v "required"`
            list=`$prefix/pip$suffix list --format legacy --not-required --outdate | sed "s/\(.*\)* (.*).*/\1/"`
            if [[ -nz $list ]] ; then
                for name in $list ; do
                    eval $logprefix echo -e "++ pip$pprint install --upgrade --no-cache-dir $name $verbose $quiet" $seperator $logsuffix
                    eval $logprefix $prefix/pip$suffix install --upgrade --no-cache-dir $name $verbose $quiet $seperator $logsuffix
                    eval $logprefix echo $seperator $logsuffix
                done
            else
                eval $logprefix echo "${green}All pip$pprint packages have been up-to-date.${reset}" $seperator $logsuffix
                eval $logprefix echo $seperator $logsuffix
            fi ;;
        *)
            flag=`$prefix/pip$suffix list --format legacy | awk "/^$arg_pkg$/"`
            if [[ -nz $flag ]]; then
                eval $logprefix echo -e "++ pip$pprint install --upgrade --no-cache-dir $arg_pkg $verbose $quiet" $seperator $logsuffix
                eval $logprefix $prefix/pip$suffix install --upgrade --no-cache-dir $arg_pkg $verbose $quiet $seperator $logsuffix
                eval $logprefix echo $seperator $logsuffix
            else
                eval $logprefix echo "${blush}No pip$pprint package names $arg_pkg installed.${reset}" $seperator $logsuffix

                # did you mean
                dym=`pip list --format legacy | grep $arg_pkg | xargs | sed "s/ /, /g"`
                if [[ -nz $dym ]] ; then
                    eval $logprefix echo "Did you mean any of the following packages: $dym?" $seperator $logsuffix
                fi
            fi ;;
    esac
}


# if quiet flag set
if ( $arg_q ) ; then
    quiet="--quiet"
else
    quiet=""
fi


# if verbose flag set
if ( $arg_v ) ; then
    verbose="--verbose"
else
    verbose=""
fi


# preset all mode bools
mode_pip_sys=false      # 2.* / system / cpython
mode_pip_sys3=false     # 3.* / system / cpython
mode_pip=false          # 2.* / cellar / cpython
mode_pip3=false         # 3.* / cellar / cpython
mode_pip_pypy=false     # 2.* / cellar / pypy
mode_pip_pypy3=false    # 3.* / cellar / pypy


# if system flag set
if ( $arg_s ) ; then
    case $arg_V in
        1)  mode_pip_sys=true
            mode_pip_sys3=true ;;
        2)  mode_pip_sys=true ;;
        3)  mode_pip_sys3=true ;;
    esac
fi


# if cellar flag set
if ( $arg_b ) ; then
    case $arg_V in
        1)  mode_pip=true
            mode_pip3=true
            mode_pip_pypy=true
            mode_pip_pypy3=true ;;
        2)  mode_pip=true
            mode_pip_pypy=true ;;
        3)  mode_pip3=true
            mode_pip_pypy3=true ;;
    esac
fi


# if cpython flag set
if ( $arg_c ) ; then
    case $arg_V in
        1)  mode_pip_sys=true
            mode_pip_sys3=true
            mode_pip=true
            mode_pip3=true ;;
        2)  mode_pip_sys=true
            mode_pip=true ;;
        3)  mode_pip_sys3=true
            mode_pip3=true ;;
    esac
fi


# if pypy flag set
if ( $arg_y ) ; then
    case $arg_V in
        1)  mode_pip_pypy=true
            mode_pip_pypy3=true ;;
        2)  mode_pip_pypy=true ;;
        3)  mode_pip_pypy3=true ;;
    esac
fi


# call piplogging function according to modes
list=( [1]=$mode_pip_sys $mode_pip_sys3 $mode_pip $mode_pip3 $mode_pip_pypy $mode_pip_pypy3 )
for index in ${!list[*]} ; do
    if ( ${list[$index]} ) ; then
        pipupdate $index
    fi
done


# read /temp/update.log line by line then migrate to log file
while read -r line ; do
    # plus `+` proceeds in line
    if [[ $line =~ ^(\+\+*\ )(.*)$ ]] ; then
        echo "+$line" >> $logfile
    # minus `-` proceeds in line
    elif [[ $line =~ ^(-\ )(.*)$ ]] ; then
        echo "$line" | sed "y/-/+/" >> $logfile
    # colon `:` in line
    elif [[ $line =~ ^([:alnum:][:alnum:]*)(:)(.*)$ ]] ; then
        # log tag
        prefix=`echo $line | sed "s/\[[0-9][0-9]*m//g" | sed "s/\(.*\)*:\ .*/\1/" | cut -c 1-3 | tr "[a-z]" "[A-Z]"`
        # log content
        suffix=`echo $line | sed "s/\[[0-9][0-9]*m//g" | sed "s/.*:\ \(.*\)*.*/\1/"`
        # write to log/update/logdate.log
        echo "$prefix: $suffix" >> $logfile
    # colourised `[??m` line
    elif [[ $line =~ ^(.*)(\[[0-9][0-9]*m)(.*)$ ]] ; then
        # add `ERR` tag and remove special characters then write to log/update/logdate.log
        echo "ERR: $line" | sed "s/\[[0-9][0-9]*m//g" >> $logfile
    # non-empty line
    elif [[ -nz $line ]] ; then
        # add `INF` tag, remove special characters and discard flushed lines then write to log/update/logdate.log
        echo $line | sed "s/^/INF: /" | sed "s/\[\?[0-9][0-9]*[a-zA-Z]//g" | sed "/\[[A-Z]/d" >> $logfile
    # empty line
    else
        # directly write to log/update/logdate.log
        echo $line >> $logfile
    fi
done < $tmpfile


# remove /temp/update.log
rm -f $tmpfile


# clear potential ternminal buffer
sript -q /dev/null clear > /dev/null 2>&1 | tee /dev/null
