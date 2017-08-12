#!/bin/bash -ex

rm -rf build
mkdir -p build
cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/opt/local && time make -j 4 all && make test && cd .. && exit 0
exit 1
