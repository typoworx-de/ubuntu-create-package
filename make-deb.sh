#!/bin/bash
_dir=$(dirname $0);
_maintainer='gkn@typoworx.com';
_description='Tool to sync IMAP-Servers';

if [[ ! -d ${_dir}/dist2 ]];
then
  mkdir ${_dir}/dist2;
fi

ln ${_dir}/imapsync ${_dir}/dist2/;

_package=$(cd ${_dir}; basename $(realpath $(dirname $0)));
_version=$(${_dir}/imapsync --version);
_arch='all';
_size=$(du -sb ${_dir}/dist2 | cut -f1);

echo \
"Package: ${_package}
Version: ${_version}
Section: custom
Priority: optional
Architecture: ${_arch}
Essential: no
Installed-Size: 1024
Maintainer: ${_maintainer}
Description: ${_description}" > DEBIAN/control

dpkg-deb --build . .
