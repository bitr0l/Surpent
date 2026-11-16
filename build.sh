#
# Central build driver.
# Copyright (c) 2026, Apollo Telephone Laboratories, et al.
# Provided under the BSD-3 clause
#

MAKE=make

#
# Check if a list of deps are installed on the host system
#
# $@:  Dep list to check
#
check_deps() {
    for dep in $@
    do
        printf "Checking if %s is installed... " $dep
        which $dep &>/dev/null
        if [ $? -ne 0 ]
        then
            echo "no"
            echo "fatal: Please install '$dep'!"
            exit 1
        fi

        echo "yes"
    done
}

#
# Prepare the build environment
#
build_prep() {
    mkdir -p out
    check_deps     \
        git        \
        make
}

#
# Pull the kernel sources
#
pull_kernel() {
    if [ ! -d sys ]
    then
        git clone https://github.com/bitr0l/DM1 sys --depth=1
    fi
}

#
# Pull the bootloader sources
#
pull_loader() {
    if [ ! -d boot ]
    then
        git clone https://github.com/bitr0l/Ignis boot --depth=1
    fi
}

#
# Pull all sources
#
pull_all() {
    pull_kernel
    pull_loader
}

#
# Build the disk image
#
make_disk() {
    mkdir -p disk/EFI/BOOT

    # Prepare the disk
    cp out/*.EFI disk/EFI/BOOT
    cp out/dm1.sys disk/dm1.sys
    cp base/boot/ignis.cfg disk/ignis.cfg
    rm -f surpent.img

    # Generate the USB stick image
    truncate -s 4M out/surpent.img
    mkfs.fat -F 12 out/surpent.img 4096
    mcopy -s -i out/surpent.img disk/* ::/
}

build() {
    pushd sys;
        ./build.sh
    popd

    pushd boot;
        ./build.sh
    popd

    cp sys/out/dm1.sys out/
    cp boot/out/* out/
    make_disk
}

build_prep
pull_all
build
