#!/bin/bash

# Run this script from an interactive (QLOGIN) session
# [N=<N>] [N_NODES=<N_NODES>] ./example.sh

N=${N:-20}
ARGV=$N
N_NODES=${N_NODES:-5}

OWN_DIR="$( readlink -f "$( dirname "${BASH_SOURCE[0]}" )" )"
FLINTSTONE="${OWN_DIR}/../flintstone.sh"
JAR=`readlink -f "$OWN_DIR/target/flintstone-0.0.1-SNAPSHOT.jar"`
CLASS=org.janelia.flintstone.Example

if [ ! -e "$JAR" ]; then
    echo "Run mvn package first!" >&2
    exit 1
fi

TERMINATE=1 $FLINTSTONE $N_NODES $JAR $CLASS $ARGV

