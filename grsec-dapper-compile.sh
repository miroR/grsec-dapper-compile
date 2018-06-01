#!/bin/bash
#
# grsec-dapper-compile.sh -- script-guide for beginners who want to compile
#
#                             dapper-secure-kernel (fork of grsecurity) in
#                             Debian/Devuan
#
# copyright 2018 Miroslav Rovis, https://www.CroatiaFidelis.hr
# 
# licenced under GNU GPL v3.0 or later, at your choice
#
# How to use this script?
# =======================
# In case of issues, the user needs to consult official Debian/Devuan documentation,
# such as Debian/Devuan Kernel Handbook, as well as Grsecurity documentation, and
# other documentation and manuals, wikis and forums.
# 'chmod 755 grsec-dapper-compile.sh' once you downloaded this script, place
# it, best, in your /usr/local/bin/, and follow instructions as you run it. If
# you encounter problems, modify for your needs. Also, pls. report errors on
# Debian/Devuan Forums where I made the Tips page:
# "Grsecurity/Pax installation on Debian/Devuan GNU/Linux" (on Debian Forums,
# and same/similar title I gave it on dev1galaxy.org Devuan Forums, pls. see
# README.md) but pls. if you will be waiting for my replies, it could take days
# and longer sometimes. Thank you!
#
# Save this file to /usr/local/bin and do "chmod 755 grsec-dapper-compile.sh" on it.
#
function ask() # from Mendel Cooper's Advanced Bash Scripting Guide, a free book
{
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}
echo
echo "  Caveat emptor! " 
echo
echo "  Do not use this script if you do not understand  " 
echo " what you are doing. You are responsible, not me, if anything "
echo "                 breaks in your system!"
echo "     (Possible, but actually not very likely, unless this is your "
echo " absolutely first encounter with Bash scripting or generally GNU/Linux) "
echo
echo " OTOH, maybe you could open it in another terminal for "
echo " perusing each next step before hitting Enter to run "
echo " that next step, one by one in this terminal."
echo " Of course you should be checking yourself how the script is"
echo " faring, are the commands doing the intended and all."
echo " This is GNU/Linux after all."
echo
echo "The script contains some code which is clumsy, but does the work; the"
echo "following: it is populated with 'read FAKE ;' lines. That is just my way"
echo "(I know no better yet) to tell you that you need to decide whether"
echo "to continue running the script hitting Enter or issue Ctrl-C to kill it."
echo
                read FAKE ;
echo
echo "Tell this script what your username is, so we can create the workspace."
read user ;
echo "If you are user $user and your homedir is /home/$user/ then this"
echo "script should work for you. If not, modify the script to suit your needs."
                read FAKE ;
echo "We create next two directories in your homedir, 'dLo' for the downloads,"
echo "and 'src' for the compilation. Will not create them if they exist,"
echo "but pls. you make sure that nothing in them obstructs this script,"
echo "meaning, we'll run command:" 
echo "'mkdir -pv /home/$user/dLo/ /home/$user/src/'"
echo ""
echo "WARNING: If you don't have at least around 18GB free in your"
echo "homedir, you need to modify the script or arrange in some other way such"
echo "as to make the /home/$user/src a symlink to somewhere with enough room"
echo "for the compilation"
echo ""
                read FAKE ;
mkdir -pv /home/$user/dLo/ /home/$user/src/
echo ; echo ls -l /home/$user/dLo/ /home/$user/src/ ;
ls -l /home/$user/dLo/ /home/$user/src/
echo ; echo cd /home/$user/dLo/ ;
                read FAKE ;
cd /home/$user/dLo/ ; pwd ;
echo "Next the script will ask you to input the no-extension names of"
echo "dapper-secure-kernel patch, linux kernel, and config file."
echo ""
echo "For those familiar with the script, there is now the option to give the"
echo "script three arguments, the first, second, and third corresponding to"
echo "the explanations below. See the echo'd line after the explanations"
echo "below."
echo ""
echo "Give the name of the dapper-secure-kernel patch (that we need to get),"
echo "without extension, such as dapper-secure-kernel-patchset-4.9.92-2018-05-27.patch"
echo "as is found by subscribing to user minipli on github or checking"
echo "https://github.com/dapperlinux/dapper-secure-kernel-patchset-stable/releases where"
echo "after perusing you reach to a patch such as:"
echo "https://github.com/dapperlinux/dapper-secure-kernel-patchset-stable/releases/download/4.9.92/dapper-secure-kernel-patchset-4.9.92-2018-05-27.patch"
echo "We need just the \"dapper-secure-kernel-patchset-4.9.92-2018-05-27\" as the first argument"
echo "(or for pasting in just below) :"
if [ -n "$1" ]
        then
                grsec="$1"
        else
                read grsec ;
fi
echo "Give the name of the kernel (that we need to get) such as linux-4.9.50"
echo "as is found for download (it must correspond to grsecurity patch's"
echo "name: it is the part of the name after"
echo "\"dapper-secure-kernel-patchset-\" and before \"-2018-05-27.patch\""
echo "in the sample name in this script."
echo "just with linux- added in front,"
echo "so in this sample case it is \"linux-4.9.92\". You can confirm the"
echo "name by looking up the relevant section on the www.kernel.org) :"
if [ -n "$2" ]
        then
                kernel="$2"
        else
                read kernel ;
fi
echo "Give the name of the (old) config file (that we need to get) usually from"
echo "the last compile, from www.croatiafidelis.hr/gnu/deb/, no extension,"
echo "such as: config-4.9.92-dappersec180601-06 (if no other talk on my"
echo "Debian/Devuan Grsec tips page on this, then just try and choose the"
echo "latest available)"
if [ -n "$3" ]
        then
                config="$3"
        else
                read config ;
fi
echo ""
echo "You may have arrived to the same result here by either following the"
echo "above slow websites' addresses and file availability checking, or, if"
echo "you checked those previously, by giving the corresponding three arguments"
echo "on the command line to this script, i.e.:"
echo ""
echo "The command line you would type to do this first stretch faster would be"
echo "similar to this one:"
echo ""
echo "grsec-dapper-compile.sh dapper-secure-kernel-patchset-4.9.92-2018-05-27 linux-4.9.92 \\"
echo "    config-4.9.92-dappersec180601-06"
echo ""
echo "grsec-dapper-compile.sh $grsec $kernel $config"
echo ""
echo ; echo "We download next the patch, the kernel, the config to use."
echo "NOTE: In case you already did, you can use those previous downloads"
                read FAKE ;
grsec_dir=$(echo $grsec|sed 's/dapper-secure-kernel-patchset-\(.*\)-2018-[0-9][0-9]-[0-9][0-9].*/\1/');
echo \$grsec_dir: $grsec_dir
                read FAKE ;
if [ -e "$grsec.patch" ]; then 
	echo "$grsec.patch there, but if you want to redownload it for"
	echo "some reason, type y/Y (will redownload the sig too), anything else"
	echo "moves you on"
	ask;
	if [ "$?" == 0 ]; then
		wget -nc \
			https://github.com/dapperlinux/dapper-secure-kernel-patchset-stable/releases/download/$grsec-dir/$grsec.patch
		wget -nc \
			https://github.com/dapperlinux/dapper-secure-kernel-patchset-stable/releases/download/$grsec-dir/$grsec.patch.sig
	else
		echo # do nothing
	fi
else
	wget -nc \
		https://github.com/dapperlinux/dapper-secure-kernel-patchset-stable/releases/download/$grsec-dir/$grsec.patch
	wget -nc \
		https://github.com/dapperlinux/dapper-secure-kernel-patchset-stable/releases/download/$grsec-dir/$grsec.patch.sig
fi
if [ -e "$kernel.tar.xz" ]; then 
	echo "$kernel.tar.xz there, but if you want to redownload it for"
	echo "some reason, type y/Y (will redownload the sig too), anything else"
	echo "moves you on"
	ask;
	if [ "$?" == 0 ]; then
		wget -nc https://www.kernel.org/pub/linux/kernel/v4.x/$kernel.tar.xz
		wget -nc https://www.kernel.org/pub/linux/kernel/v4.x/$kernel.tar.sign
	else
		echo # do nothing
	fi
else
	wget -nc https://www.kernel.org/pub/linux/kernel/v4.x/$kernel.tar.xz
	wget -nc https://www.kernel.org/pub/linux/kernel/v4.x/$kernel.tar.sign
fi
if [ -e "$config.gz" ]; then 
	echo "$config.gz there, but if you want to redownload it for"
	echo "some reason, type y/Y (will redownload the sig too), anything else"
	echo "moves you on"
	ask;
	if [ "$?" == 0 ]; then
		wget -nc https://www.croatiafidelis.hr/gnu/deb/$config.sig
		wget -nc https://www.croatiafidelis.hr/gnu/deb/$config.gz
	else
		echo # do nothing
	fi
else
	wget -nc https://www.croatiafidelis.hr/gnu/deb/$config.sig
	wget -nc https://www.croatiafidelis.hr/gnu/deb/$config.gz
fi

echo ; echo "Import the necessary keys:"
echo "Matthew Ruffell signs the dapper-secure-kernel patch."
echo "The integrity is verified by checking the git archive where he signs tags."
# But we only need to get the key if we don't already have it, right?
gpg --quiet --list-key 0xB3FE58828237090D
if (gpg --quiet --list-key 0xB3FE58828237090D | grep 9FEDF94E211CA29BFFCFDFAAB3FE58828237090D); then
	echo "Matthew Ruffell's key (xB3FE58828237090D) in your keyring, no need"
	echo "to receive it"
else
	echo  "gpg --recv-key 0xB3FE58828237090D"
                read FAKE ;
	gpg --recv-key 0xB3FE58828237090D
fi

echo "Greg Kroah-Hartman signs Linux stable kernels:"
if (gpg --quiet --list-key 0x38DBBDC86092693E | grep 647F28654894E3BD457199BE38DBBDC86092693E); then
	echo "Greg Kroah-Hartman's key (x38DBBDC86092693E) in your keyring, no need"
	echo "to receive it"
else
	echo  "gpg --recv-key 0x38DBBDC86092693E"
                read FAKE ;
	gpg --recv-key 0x38DBBDC86092693E
fi

echo "Import my key, to get the config that I offer you:"
if (gpg --quiet --list-key 0xEA9884884FBAF0AE | grep FCF13245ED247DCE443855B7EA9884884FBAF0AE); then
	echo "Miroslav Rovis' key (xEA9884884FBAF0AE) in your keyring, no need"
	echo "to receive it"
else
	echo  "gpg --recv-key 0xEA9884884FBAF0AE"
                read FAKE ;
	gpg --recv-key 0xEA9884884FBAF0AE
fi

echo "You can go offline now (if you're not already), internet not needed"
echo "while compiling."
#echo "I, myself, unplug the connection physically."

echo ; echo "Next, copy all downloads to /home/$user/src/"
                read FAKE ;
cp -iav $kernel.tar.* /home/$user/src/
cp -iav $grsec.patch* /home/$user/src/
cp -iav $config* /home/$user/src/
cd /home/$user/src/ ; pwd
ls -l $kernel*
                read FAKE ;
echo ; echo unxz $kernel.tar.xz ;
                read FAKE ; 
        unxz $kernel.tar.xz ;
echo ; echo gpg --verify $kernel.tar.sign $kernel.tar ;
                read FAKE ; 
        gpg --verify $kernel.tar.sign $kernel.tar ;
echo ; echo gpg --verify $grsec.patch.sig;
                read FAKE ; 
        gpg --verify $grsec.patch.sig $grsec.patch ;
echo ; echo gunzip $config.gz;
                read FAKE ; 
        gunzip $config.gz;
echo ; echo gpg --verify $config.sig $config ;
                read FAKE ; 
        gpg --verify $config.sig $config ;
echo ; echo tar xvf $kernel.tar ;
                read FAKE ; 
        tar xvf $kernel.tar ;
echo ; echo cd $kernel;
                read FAKE ; 
        cd $kernel; pwd
echo ; echo "patch -p1 < ../$grsec.patch";
                read FAKE ; 
        patch -p1 < ../$grsec.patch
echo ; echo "At this point, if you need to, you can possibly apply"
echo "other patches to this kernel, as well.";
echo ; echo cd ../;
        cd ../ ; pwd
                read FAKE ; 
echo ; echo cp -iav $config $kernel/.config;
                read FAKE ; 
        cp -iav $config $kernel/.config
echo ; echo cd $kernel;
                read FAKE ; 
        cd $kernel
pwd
echo ; echo "Here we modify the LOCALVERSION variable to be -YYMMDD-HH"
locver=`date +%y%m%d-%H`
echo $locver
read FAKE ;
oldloc=`grep CONFIG_LOCALVERSION= .config|cut -d'"' -f2`
echo sed -i.bak "s/$oldloc/$locver/" .config
read FAKE ;
sed -i.bak "s/$oldloc/$locver/" .config
echo ; echo "And we need to check that we did what we meant:"
echo ; 
grep LOCALVERSION .config
echo ; echo "And we can also move the backup out of way if it went well."
mv -vi .config.bak ../ ;
echo ; echo make menuconfig;
                read FAKE ; 
echo "If here you will see the script complaining, such as:"
echo "./grsec-dapper-compile.sh: line 125: make: command not found"
echo "then you need to install the development tools. Don't worry,"
echo "nothing much. Pls. find instructions in some of my previous/later posts"
echo "in the Tip on Debian/Devuan Forums, or read the script itself at this point."
echo "(... no time to fix this with better explanations, sorry... )"
#
# Huh? You found it? Probably these commands would get you all you're missing
# at this point (the first # is comment, the second # signifies you are root):
# # apt-get install build-essential fakeroot 
# # apt-get build-dep linux
# # apt-get install libncurses5-dev 
# # apt-get install libgmp-dev gcc-6-plugin-dev
# and some more, pls. see "Howto upgrade Devuan (stable) to the latest Linux
# kernel" on dev1galaxy.org or other places.
# Again, that's not an error '# #'. Run as root. If run as user I would write
# '# $' instead, where the first # is necessary to make those lines comments
# in both cases.

        make menuconfig
echo ; echo "The diff .config below will only show differences if you edited"
echo "the config through the ncurses menuconfig interface. You may and you may"
echo "not need to. You may in case, say, you have some exotic hardware and"
echo "functionality is later found missing for you. However, only in rare"
echo "cases, only those that also in non-Grsec kernel you would need to, and"
echo "those are rare, only where regular Debian/Devuan kernel which config I base"
echo "this compile on, would have issues"
echo diff .config*;
        diff .config*
                echo
                echo ; echo "Now this, the next one, can be a longer one step \
                      in the process..."
                echo
echo ; echo fakeroot make deb-pkg;
                read FAKE ; 
        fakeroot make deb-pkg


                echo ; echo "Here, the deb packages ought to be there..."
                read FAKE ; 
echo ; echo cd ../ ;
cd ../ ; pwd ;
                read FAKE ; 
ls -l *.deb
                echo ; echo "If above here you see listed the packages named"
                echo "linux-XXXXXX-grsec-XXX.deb, you're at your last step."
                echo ; echo "But, that step you need to execute as root, so it"
                echo "is not part of this script executed entire as user."
                read FAKE ; 
pwd
msgbeforeroot1="As root in directory /home/$user/src/ issue this command"
msgbeforeroot2="dpkg -i *.deb"
echo ; echo $msgbeforeroot1
echo ; echo "$msgbeforeroot2"

echo "And then, if no errors there, you can reboot."
echo "Upon rebooting, you too should get something like I got below:"
echo
echo "$ uname -a"
echo "4.9.92-dappersec180601-06"
echo "$"
