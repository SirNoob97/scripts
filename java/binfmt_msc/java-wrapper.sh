#!/bin/env bash
# /usr/local/bin/javawrapper - the wrapper for binfmt_misc/java

# Kernel docs
# https://docs.kernel.org/admin-guide/java.html

if [ -z "$1" ]; then
      exec 1>&2
      echo Usage: $0 class-file
      exit 1
fi

CLASS=$1
FQCLASS=`/usr/local/bin/javaclassname $1`
FQCLASSN=`echo $FQCLASS | sed -e 's/^.*\.\([^.]*\)$/\1/'`
FQCLASSP=`echo $FQCLASS | sed -e 's-\.-/-g' -e 's-^[^/]*$--' -e 's-/[^/]*$--'`

# for example:
# CLASS=Test.class
# FQCLASS=foo.bar.Test
# FQCLASSN=Test
# FQCLASSP=foo/bar

unset CLASSBASE

declare -i LINKLEVEL=0

while :; do
      if [ "`basename $CLASS .class`" == "$FQCLASSN" ]; then
              # See if this directory works straight off
              cd -L `dirname $CLASS`
              CLASSDIR=$PWD
              cd $OLDPWD
              if echo $CLASSDIR | grep -q "$FQCLASSP$"; then
                      CLASSBASE=`echo $CLASSDIR | sed -e "s.$FQCLASSP$.."`
                      break;
              fi
              # Try dereferencing the directory name
              cd -P `dirname $CLASS`
              CLASSDIR=$PWD
              cd $OLDPWD
              if echo $CLASSDIR | grep -q "$FQCLASSP$"; then
                      CLASSBASE=`echo $CLASSDIR | sed -e "s.$FQCLASSP$.."`
                      break;
              fi
              # If no other possible filename exists
              if [ ! -L $CLASS ]; then
                      exec 1>&2
                      echo $0:
                      echo "  $CLASS should be in a" \
                           "directory tree called $FQCLASSP"
                      exit 1
              fi
      fi
      if [ ! -L $CLASS ]; then break; fi
      # Go down one more level of symbolic links
      let LINKLEVEL+=1
      if [ $LINKLEVEL -gt 5 ]; then
              exec 1>&2
              echo $0:
              echo "  Too many symbolic links encountered"
              exit 1
      fi
      CLASS=`ls --color=no -l $CLASS | sed -e 's/^.* \([^ ]*\)$/\1/'`
done

if [ -z "$CLASSBASE" ]; then
      if [ -z "$FQCLASSP" ]; then
              GOODNAME=$FQCLASSN.class
      else
              GOODNAME=$FQCLASSP/$FQCLASSN.class
      fi
      exec 1>&2
      echo $0:
      echo "  $FQCLASS should be in a file called $GOODNAME"
      exit 1
fi

if ! echo $CLASSPATH | grep -q "^\(.*:\)*$CLASSBASE\(:.*\)*"; then
      # class is not in CLASSPATH, so prepend dir of class to CLASSPATH
      if [ -z "${CLASSPATH}" ] ; then
              export CLASSPATH=$CLASSBASE
      else
              export CLASSPATH=$CLASSBASE:$CLASSPATH
      fi
fi

shift
java $FQCLASS "$@"
