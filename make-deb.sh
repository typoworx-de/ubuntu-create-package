#!/bin/bash
_dir=$(dirname $0);
_maintainer='gkn@typoworx.com';
_description='Tool to sync IMAP-Servers';

if [[ ! -d src/.git ]];
then
  cd ${_dir}; git clone https://github.com/imapsync/imapsync src || exit 1;
fi

# Optional!
# Checkout latest tag
cd ${_dir}/src; git checkout $(cd ${_dir}/src; git tag | tail -n 1);

#- Install some required Perl/CPAN Modules
#- ${_dir}/src/INSTALL.d/prerequisites_imapsync || exit 1;

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
