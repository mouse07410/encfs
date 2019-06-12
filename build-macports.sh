#!/bin/bash -eu

: ${CMAKE:=cmake}
: ${CHECK:=false}
: ${INTEGRATION:=true}

${CMAKE} --version

CFG=$*
if [[ "$CHECK" == "true" ]]; then
  CFG="-DLINT=ON $CFG"
fi

if uname -s | grep -q Darwin; then
  CXXFLAGS="${CXXFLAGS} -D_FILE_OFFSET_BITS=64 -D_DARWIN_USE_64_BIT_INODE -I/usr/local/include/osxfuse/fuse "
  CFG="-DENABLE_NLS=OFF -DOPENSSL_ROOT_DIR=/opt/local -DCMAKE_INSTALL_PREFIX=/opt/local -DFUSE_INCLUDE_DIR=/usr/local/include/osxfuse/fuse -DFUSE_LIBRARIES=/usr/local/lib/libosxfuse.dylib $CFG"
fi

rm -rf build

if [[ ! -d build ]]
then
  mkdir build
fi

cd build
${CMAKE} .. ${CFG}
make -j2
make unittests
make test
if [[ "$INTEGRATION" == "true" ]]; then
  make integration
fi

cd ..

echo
echo 'Everything looks good, you can install via "make install -C build".'
