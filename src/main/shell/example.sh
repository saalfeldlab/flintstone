N=${N:-20}
ARGV=$N

ROOT_DIR=${ROOT_DIR:-$PWD}

QSUB_WRAPPER=$ROOT_DIR/qsub-wrapper.sh
SCRIPT=$ROOT_DIR/get-sum-of-integers.sh

N_NODES=${N_NODES:-5} $QSUB_WRAPPER $SCRIPT $ARGV
