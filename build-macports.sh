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
  CFG="-DENABLE_NLS=OFF -DOPENSSL_ROOT_DIR=/opt/local -DCMAKE_INSTALL_PREFIX=/opt/local $CFG"
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