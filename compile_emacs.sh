#!/bin/env bash

# run this script inside inside emacs directory, this script does not run tests.
# these options are for compiling emacs with XIMP and no DBUS sessions, POP support, image support, and some graphical features disabled.
./configure --without-dbus \
            --without-gconf \
            --without-gsettings \
            # email support
            --without-pop \
            # images support
            --without-xpm \
            --without-jpeg \
            --without-tiff \
            --without-gif \
            --without-png \
            --without-rsvg \
            # graphical features
            --without-toolkit-scroll-bars \
            --with-x-toolkit=no \
            # gcc options
            --enable-gcc-warnings=warn-only

make -j 4
sudo make -j 4 install
