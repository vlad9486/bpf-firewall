#!/usr/bin/env bash

set -e

export K=${1%-*-*}
wget -cq https://cdn.kernel.org/pub/linux/kernel/v${K%.*.*}.x/linux-$K.tar.xz
tar -xf linux-$K.tar.xz
pushd linux-$K
make defconfig
make modules_prepare
popd
export KERNEL_VERSION=$K
export KERNEL_SOURCE=$(pwd)/linux-$K
cargo build -p tezedge-firewall --bin firewall && cargo build -p tezedge-firewall --bin fw
rm -R linux-$K{,.tar.xz}
mkdir -p bin
mv target/debug/firewall ./bin/firewall-$K
mv target/debug/fw ./bin/fw
cargo clean
