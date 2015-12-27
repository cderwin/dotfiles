#!/usr/bin/env bash

tar -xzf python2.7.11.tar.gz /usr/local/src/python

cd /usr/local/src/python

./configure --prefix=/usr/local
make distclean
make test
make install
