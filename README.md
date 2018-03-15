# Scripts

Just some useful bash scripts.

- [Daily](https://github.com/JarryShaw/jsdaily)
    * [`update`](https://github.com/JarryShaw/jsdaily#update)
        - [Atom](https://github.com/JarryShaw/jsdaily#update_apm)
        - [Python](https://github.com/JarryShaw/jsdaily#update_pip)
        - [Homebrew](https://github.com/JarryShaw/jsdaily#update_brew)
        - [Caskroom](https://github.com/JarryShaw/jsdaily#update_cask)
        - [App Store](https://github.com/JarryShaw/jsdaily#update_apptore)
    * [`uninstall`](https://github.com/JarryShaw/jsdaily#uninstall)
        - [Python](https://github.com/JarryShaw/jsdaily#uninstall_pip)
        - [Homebrew](https://github.com/JarryShaw/jsdaily#uninstall_brew)
        - [Caskroom](https://github.com/JarryShaw/jsdaily#uninstall_cask)
    * [`reinstall`](https://github.com/JarryShaw/jsdaily#reinstall)
        - [Homebrew](https://github.com/JarryShaw/jsdaily#reinstall_brew)
        - [Caskroom](https://github.com/JarryShaw/jsdaily#reinstall_cask)
    * [`postinstall`](https://github.com/JarryShaw/jsdaily#postinstall)
        - [Homebrew](https://github.com/JarryShaw/jsdaily#postinstall_brew)
    * [`dependency`](https://github.com/JarryShaw/jsdaily#dependency)
        - [Python](https://github.com/JarryShaw/jsdaily#dependency_pip)
        - [Homebrew](https://github.com/JarryShaw/jsdaily#dependency_brew)

- [Kali Scripts](#kali)
    * [`acccheck`](#acccheck)
    * [`firewalk`](#firewalk)
    * [`ident-user-enum`](#ident-user-enum)
    * [`nutscan-unixwiz`](#nutscan-unixwiz)
    * [`nmap`](#nmap)
    * [`zenmap`](#zenmap)
        - [Intense Scan](#intense)
        - [Quick Scan](#quick)
        - [Slow Scan](#slow)

- [Others](#others)
    * [`startup`](#startup)
    * [`colour`](#colour)
    * [`pypi`](#pypi)
    * [`pypitest`](#pypitest)
    * [`piptest`](#piptest)


---------------------------------------------------------------------------------------------------


&nbsp;

<a name="kali"> </a>

## Kali

 > Following descriptions comes from [Kali Linux Penetration Testing Tools](https://tools.kali.org/)

<a name="acccheck"> </a>

##### [`acccheck`](https://labs.portcullis.co.uk/tools/acccheck/)

```
acccheck -t -v ${dst}
```

&emsp; The tool is designed as a password dictionary attack tool that targets windows authentication via the SMB protocol. It is really a wrapper script around the ‘smbclient’ binary, and as a result is dependent on it for its execution.

<a name="firewalk"> </a>

##### [`firewalk`](http://packetfactory.openwall.net/projects/firewalk/)

```
firewalk -S0-65535 -i eth0 -n -pTCP ${src} ${dst}
```

&emsp; Firewalk is an active reconnaissance network security tool that attempts to determine what layer 4 protocols a given IP forwarding device will pass. Firewalk works by sending out TCP or UDP packets with a TTL one greater than the targeted gateway. If the gateway allows the traffic, it will forward the packets to the next hop where they will expire and elicit an ICMP_TIME_EXCEEDED message. If the gateway hostdoes not allow the traffic, it will likely drop the packets on the floor and we will see no response.

&emsp; To get the correct IP TTL that will result in expired packets one beyond the gateway we need to ramp up hop-counts. We do this in the same manner that traceroute works. Once we have the gateway hopcount (at that point the scan is said to be `bound`) we can begin our scan.

&emsp; It is significant to note the fact that the ultimate destination host does not have to be reached. It just needs to be somewhere downstream, on the other side of the gateway, from the scanning host.

<a name="ident-user-enum"> </a>

##### [`ident-user-enum`](http://pentestmonkey.net/tools/user-enumeration/ident-user-enum)

```
ident-user-enum ${dst} ${dstport}
```

&emsp; ident-user-enum is a simple PERL script to query the ident service (113/TCP) in order to determine the owner of the process listening on each TCP port of a target system.
This can help to prioritise target service during a pentest (you might want to attack services running as root first). Alternatively, the list of usernames gathered can be used for password guessing attacks on other network services.

<a name="nbtscan-unixwiz"> </a>

##### [`nbtscan-unixwiz`](http://unixwiz.net/tools/nbtscan.html)

```
nbtscan -r ${dst}
```

&emsp; This is a command-line tool that scans for open NETBIOS nameservers on a local or remote TCP/IP network, and this is a first step in finding of open shares. It is based on the functionality of the standard Windows tool nbtstat, but it operates on a range of addresses instead of just one.

<a name="nmap"> </a>

##### [`nmap`](http://insecure.org/)

```
nmap -v -A ${dst}
```

&emsp; Nmap (“Network Mapper”) is a free and open source (license) utility for network discovery and security auditing. Many systems and network administrators also find it useful for tasks such as network inventory, managing service upgrade schedules, and monitoring host or service uptime. Nmap uses raw IP packets in novel ways to determine what hosts are available on the network, what services (application name and version) those hosts are offering, what operating systems (and OS versions) they are running, what type of packet filters/firewalls are in use, and dozens of other characteristics. It was designed to rapidly scan large networks, but works fine against single hosts. Nmap runs on all major computer operating systems, and official binary packages are available for Linux, Windows, and Mac OS X. In addition to the classic command-line Nmap executable, the Nmap suite includes an advanced GUI and results viewer (Zenmap), a flexible data transfer, redirection, and debugging tool (Ncat), a utility for comparing scan results (Ndiff), and a packet generation and response analysis tool (Nping).

<a name="zenmap"> </a>

##### [`zenmap`](https://nmap.org/zenmap/)

&emsp; Zenmap is the official Nmap Security Scanner GUI. It is a multi-platform (Linux, Windows, Mac OS X, BSD, etc.) free and open source application which aims to make Nmap easy for beginners to use while providing advanced features for experienced Nmap users. Frequently used scans can be saved as profiles to make them easy to run repeatedly. A command creator allows interactive creation of Nmap command lines. Scan results can be saved and viewed later. Saved scan results can be compared with one another to see how they differ. The results of recent scans are stored in a searchable database.

 > Following scan modes were defined in [this page](https://svn.nmap.org/nmap/zenmap/share/zenmap/config/scan_profile.usp).

<a name="intense"> </a>

1. Intense scan, all TCP ports

```
nmap -p 1-65535 -T4 -A -v ${dst}
```

&emsp; Scans all TCP ports, then does OS detection (-O), version detection (-sV), script scanning (-sC), and traceroute (--traceroute).

<a name="quick"> </a>

2. Quick scan plus

```
nmap -sV -T4 -O -F --version-light ${dst}
```

&emsp; A quick scan plus OS and version detection.

<a name="slow"> </a>

3. Slow comprehensive scan

```
nmap -sS -sU -T4 -A -v -PE -PS80,443 -PA3389 -PP -PU40125 -PY --source-port 53 --script "default or (discovery and safe)" ${dst}
```

&emsp; This is a comprehensive, slow scan. Every TCP and UDP port is scanned. OS detection (-O), version detection (-sV), script scanning (-sC), and traceroute (--traceroute) are all enabled. Many probes are sent for host discovery. This is a highly intrusive scan.

&nbsp;

<a name="others"> </a>

## Others

<a name="startup"> </a>

##### `startup` - Startup script for Raspberry Pi

&emsp; When screen sharing with [Raspberry Pi](https://raspberrypi.org/) over [`tightvncserver`](http://tightvnc.com), some startup commands are needed to proceed.

<a name="colour"> </a>

##### `colour` - A lovely colourful script

&emsp; This script uses `tput setaf` to display contents with colours in terminal. Note that, it only works ideal on macOS.

<a name="pypi"> </a>

##### `pypi` - Upload your package to PyPI & TestPyPI

&emsp; This script helps to upload your Python packages to [PyPI](http://pypi.org) and [TestPyPI](http://test.pypi.org), which makes it downloadable through `pip`.

&emsp; To setup this script on your Mac, use commands below:

```
cp pypi.sh /usr/local/bin/pypi
chmod 777 /usr/local/bin/pypi
```

&emsp; And to use this script, change your working directory to where you would like to run `pypi`, which should contains a `setup.py` file, then simply type `pypi` and enter, all will be done.

```
cd your-working-directory
pypi
```

<a name="pypitest"> </a>

##### `pypitest` - Register your package in PyPI & TestPyPI

&emsp; This script helps to upload your Python packages to [TestPyPI](http://test.pypi.org) only.

&emsp; To setup this script on your Mac, use commands below:

```
cp pypi.sh /usr/local/bin/pypitest
chmod 777 /usr/local/bin/pypitest
```

&emsp; And to use this script, change your working directory to where you would like to run `pypitest`, which should contains a `setup.py` file, then simply type `pypitest` and enter, all will be done.

```
cd your-working-directory
pypitest
```

<a name="piptest"> </a>

##### `piptest` - Download packages from TestPyPI

__DEPRECATED__
