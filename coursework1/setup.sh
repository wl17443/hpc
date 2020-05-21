#!/usr/bin/env bash

# Quartus Prime Lite Edition
# -- Installs the software and/or devices to the Quartus Prime Lite Edition

# Copyright (C) 2019 Intel Corporation. All rights reserved.

# Your use of Intel Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any output files
# any of the foregoing (including device programming or simulation files), and
# any associated documentation or information are expressly subject to the terms
# and conditions of the Intel Program License Subscription Agreement, Intel
# MegaCore Function License Agreement, or other applicable license agreement,
# including, without limitation, that your use is for the sole purpose of
# programming logic devices manufactured by Intel and sold by Intel or its
# authorized distributors.  Please refer to the applicable agreement for
# further details.

# Check if we are running on a supported version of Linux distribution with pre-requisite packages installed.
# Both RedHat and CentOS have the /etc/redhat-release file.
unsupported_os=0

if [ -f /etc/redhat-release ] ;then
    minimum_redhat_major_version="6"

	os_version=`cat /etc/redhat-release | grep release | sed -e 's/ (.*//g'`
	os_platform=`echo ${os_version} | grep "Red Hat Enterprise" || echo ${os_version} | grep "CentOS"`

	if [ "$os_platform" != "" ] ;then

        os_rev=`echo ${os_version} | awk -F "release " '{print $2}' | awk -F . '{print $1}'`
        if [ ${os_rev} -lt ${minimum_redhat_major_version} ]; then
            unsupported_os=1
        fi
	fi
elif [ -f /etc/SuSE-release ] ;then
	os_version=`cat /etc/SuSE-release`
	os_platform=`echo ${os_version} | grep SUSE`
	if [ "$os_platform" != "" ] ;then
		os_rev=`echo ${os_version} | grep "VERSION = 10"`
		if [ "$os_rev" != "" ] ;then
			os_version=`cat /etc/SuSE-release | tr "\n" ' '| sed -e 's/ VERSION.*//g'`
			unsupported_os=1
		fi
	fi
fi

if [ $unsupported_os -eq 1 ] ;then
	echo ""
	echo "Intel FPGA software is not supported on the $os_version operating system. Refer to the Operating System Support page of the Intel FPGA website for complete operating system support information."
	echo ""

	answer="n"
	while [ "$answer" != "y" ]
	do
		echo -n "Do you want to continue to install the software? (y/n): "
		read answer

		if [ "$answer" = "n" ] ;then
			exit
		fi
	done
fi

if [ `uname -m` != "x86_64" ] ;then
	echo ""
	echo "The Intel software you are installing is 64-bit software and will not work on the 32-bit platform on which it is being installed."
	echo ""

	answer="n"
	while [ "$answer" != "y" ]
	do
		echo -n "Do you want to continue to install the software? (y/n): "
		read answer

		if [ "$answer" = "n" ] ;then
			exit
		fi
	done
fi

export SCRIPT_PATH=`dirname "$0"`
export CMD_NAME="$SCRIPT_PATH/components/QuartusLiteSetup-19.1.0.670-linux.run"
eval exec "\"$CMD_NAME\"" $@
