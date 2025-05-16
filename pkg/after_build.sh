#!/bin/env sh

$VERSION="" # change this to version number
old_dir=$(pwd)
this_dir="$(cd "$(dirname "$0")" && pwd)"
root_dir=$(realpath "$this_dir/..")

debian() {

    cp $root_dir/build/qkw $this_dir/qkw/usr/bin/qkw
    # add things to change the dependencies and their versions

    dpkg-deb --build $this_dir/qkw
    mv qkw.deb "qkw$VERSION.deb"

}

arch() {
  # complete this
}

fedora() {
  # complete this
}

alpine() {
  #complete this
}

cd $this_dir



cd $old_dir
