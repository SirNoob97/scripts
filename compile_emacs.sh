#!/bin/env bash

set -e

# run this script inside inside emacs directory, this script does not run tests.
# these options are for compiling emacs with XIMP and no DBUS sessions, POP support, image support, and some graphical features disabled.
./configure --without-dbus \
            --without-gconf \
            --without-gsettings \
            --without-pop \
            --without-toolkit-scroll-bars \
            --with-x-toolkit=no \
            --with-native-compilation \
            --with-json \
            --enable-gcc-warnings=warn-only
            # --without-xpm \
            # --without-jpeg \
            # --without-tiff \
            # --without-gif \
            # --without-png \
            # --without-rsvg \

make -j 4
sudo make -j 4 install
