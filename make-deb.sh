#!/bin/bash
_dir=$(realpath $(dirname $0));
_package=$(basename ${_dir});

_src="${_dir}/src";
_build="${_dir}/build";

# Package maintainer & description
_maintainer='gkn@typoworx.com';
_description='Tool to sync IMAP-Servers';


if [[ ! -d ${_dir}/src/.git ]];
then
  git clone https://github.com/imapsync/imapsync src || exit 1;
fi

cd ${_src};

# Optional!
# Checkout latest tag
git checkout $(git tag | tail -n 1);

#- Install some required Perl/CPAN Modules
#- ${_dir}/src/INSTALL.d/prerequisites_imapsync || exit 1;

if [[ ! -d ${_dir}/build ]];
then
  echo "Create build dir";
  mkdir ${_dir}/build;
fi

rm -rf ${_build}/*;

# Important always use Prefix'ed paths
# -> /usr/local/{bin,share} etc.
mkdir -p ${_dir}/build/usr/local/bin;

ln ${_src}/imapsync ${_build}/usr/local/bin;

_version=$(${_src}/imapsync --version);
_arch='all';
_size=$(du -sb ${_dir}/build | cut -f1);

if [[ ! -d ${_build}/DEBIAN ]];
then
  mkdir ${_build}/DEBIAN;
fi

echo \
"Package: ${_package}
Version: ${_version}
Section: custom
Priority: optional
Architecture: ${_arch}
Essential: no
Installed-Size: 1024
Maintainer: ${_maintainer}
Description: ${_description}" > ${_build}/DEBIAN/control;

if [[ -f ${_build}/DEBIAN/control ]];
then
  dpkg-deb --build ${_build} ${_dir} && {
    echo "Done";
  } || {
    echo "Error";
    exit 1;
  }
fi
