#!/usr/bin/env bash

# Various python locations
installprefix="/usr/local"
installdir="$installprefix/src/python2.7.11"
tarfile="https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz"
tardest="$installprefix/src/python2.7.11.tar.gz"

# Download python source
mkdir -p $installdir/src
curl -L -o $tardest $tarfile
tar -xzf $tardest $installdir

# Install dependencies

# Actually compile and install python
./$installdir/configure --prefix=/usr/local
make -C $installdir
make -C $installdir install ensurepip=INSTALL

# Exit
echo "Python 2.7.11 installed in /usr/local/bin"
exit 0
