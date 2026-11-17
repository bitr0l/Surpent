#!/bin/bash
#
# Injects kernel directory for testing.
# Copyright (c) 2026, Apollo Telephone Laboratories, et al.
# Provided under the BSD-3 clause.
#

if [ $# -lt 1 ]
then
    echo "fatal: too few arguments"
    exit 1
fi

if [ ! -d $1 ]
then
    echo "fatal: no such file or directory"
    exit 1
fi

rm -rf sys
cp -r $1 sys
