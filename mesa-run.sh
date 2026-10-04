#!/bin/sh
MESA=$HOME/build/mesa \
LD_LIBRARY_PATH=$MESA/lib64:$LD_LIBRARY_PATH \
LIBGL_DRIVERS_PATH=$MESA/lib64/dri \
VK_ICD_FILENAMES=$MESA/share/vulkan/icd.d/radeon_icd.x86_64.json \
LIBVA_DRIVERS_PATH=$MESA/lib64/dri \
    exec "$@"
