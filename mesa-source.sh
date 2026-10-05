#!/bin/sh
MESA=$HOME/build/mesa

export MESA_LOCAL_PATH=$MESA
export LD_LIBRARY_PATH=$MESA/lib64:$LD_LIBRARY_PATH
export LIBGL_DRIVERS_PATH=$MESA/lib64/dri
export VK_ICD_FILENAMES=$MESA/share/vulkan/icd.d/radeon_icd.x86_64.json
export LIBVA_DRIVERS_PATH=$MESA/lib64/dri
export PKG_CONFIG_PATH=$MESA/lib64/pkgconfig:$PKG_CONFIG_PATH
