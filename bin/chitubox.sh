#!/bin/bash

ulimit -s unlimited

SYMLINK=/usr/local/bin/CHITUBOX
CHITDIR=$(dirname $(readlink ${SYMLINK}))

echo "Chitubox resides at ${CHITDIR}"

cd "${CHITDIR}"

export DE=lxde
export LD_LIBRARY_PATH="${CHITDIR}/lib:${LD_LIBRARY_PATH}"
export QT_QPA_PLATFORM="xcb"
export QT_QPA_PLATFORM_PLUGIN_PATH="${CHITDIR}/plugins/platforms"
export QT_PLUGIN_PATH="${QT_QPA_PLATFORM_PLUGIN_PATH}:/usr/lib/x86_64-linux-gnu/qt5/plugins/platforms"
export XDG_RUNTIME_DIR="/tmp/runtime-${USER}"
export XDG_DATA_DIRS="${CHITDIR}/share:/usr/local/share:/usr/share"

# ldd ${SYMLINK}

${SYMLINK}
