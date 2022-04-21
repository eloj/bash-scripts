#!/bin/bash
XXDOPT="-g 1"
diff <(xxd $XXDOPT "$1") <(xxd $XXDOPT "$2")
