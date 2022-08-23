#!/bin/env bash

# Java(tm) Binary Kernel Support for Linux v1.03¶
# https://docs.kernel.org/admin-guide/java.html

# Guide to configuring binfmt_misc to run Java class files as binaries. e.g $ ./Main.class
# There are also steps to configure execution of jar files

set -eu -o pipefail

register=/proc/sys/fs/binfmt_misc/register

[ ! -w $register ] && echo "${register} file does not have writte permision!!!" && exit 1 

echo ':Java:M::\xca\xfe\xba\xbe::/usr/local/bin/javawrapper:' > $register 

cscript=java-classname.c
binfile=./javaclassname
wrapper=./java-wrapper.sh

gcc -O2 -o $binfile $cscript

mv $binfile /usr/local/bin/

[ ! -x $wrapper ] && chmod +x $wrapper

cp $wrapper /usr/local/bin/javawrapper
