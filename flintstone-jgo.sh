#!/bin/bash

if [ "$#" -lt "3" ]; then
    echo -e "Not enough arguments!" 1>&2
    exit 1
fi

CONTAINING_DIRECTORY="$( dirname "${BASH_SOURCE[0]}" )"
SPARK_JANELIA="${SPARK_JANELIA:-${CONTAINING_DIRECTORY}/spark-janelia/spark-janelia}"
# MVN="${MVN:-/misc/local/maven-3.2.2/bin/mvn}"

RUNTIME="${RUNTIME:-8:00}"
SPARK_VERSION="${SPARK_VERSION:-2.3.1}"
TERMINATE="${TERMINATE:-1}"
MIN_WORKERS="${MIN_WORKERS:-1}"

N_EXECUTORS_PER_NODE="${N_EXECUTORS_PER_NODE:-6}"
N_CORES_PER_EXECUTOR="${N_CORES_PER_EXECUTOR:-5}"
MEMORY_PER_NODE="${MEMORY_PER_NODE:-300}"
SPARK_OPTIONS="${SPARK_OPTIONS:-}"

N_DRIVER_THREADS="${N_DRIVER_THREADS:-16}"

N_NODES=$1;           shift
COORDINATE="$1";      shift
CLASS=$1;             shift
ARGV="$@"

ARTIFACT="$(echo $COORDINATE | tr ':' '\n' | head -n2 | tail -n1)"
WORKSPACE="$(jgo --repository scijava.public=https://maven.scijava.org/content/groups/public --resolve-only $COORDINATE)"
MAIN_JAR="$(ls ${WORKSPACE}/*jar -1 | grep -E "${ARTIFACT}-[0-9]+")"
ALL_JARS="$(ls ${WORKSPACE}/*jar -1 | tr '\n' ',' | sed 's/,$//')"

# echo "$MEMORY_PER_NODE / $N_EXECUTORS_PER_NODE"
# echo "$N_NODES * $N_EXECUTORS_PER_NODE"
export MEMORY_PER_EXECUTOR="$(($MEMORY_PER_NODE / $N_EXECUTORS_PER_NODE))"
export N_EXECUTORS="$(($N_NODES * $N_EXECUTORS_PER_NODE))"
export PARALLELISM="$(($N_EXECUTORS * $N_CORES_PER_EXECUTOR * 3))"

SUBMIT_ARGS="${SUBMIT_ARGS} --verbose"
SUBMIT_ARGS="${SUBMIT_ARGS} --conf spark.default.parallelism=$PARALLELISM"
SUBMIT_ARGS="${SUBMIT_ARGS} --conf spark.executor.instances=$N_EXECUTORS_PER_NODE"
SUBMIT_ARGS="${SUBMIT_ARGS} --conf spark.executor.cores=$N_CORES_PER_EXECUTOR"
SUBMIT_ARGS="${SUBMIT_ARGS} --conf spark.executor.memory=${MEMORY_PER_EXECUTOR}g"
SUBMIT_ARGS="${SUBMIT_ARGS} ${SPARK_OPTIONS}"
SUBMIT_ARGS="${SUBMIT_ARGS} --jars $ALL_JARS"
SUBMIT_ARGS="${SUBMIT_ARGS} --class $CLASS"
SUBMIT_ARGS="${SUBMIT_ARGS} ${MAIN_JAR}"
SUBMIT_ARGS="${SUBMIT_ARGS} ${ARGV}"

LOG_FILE="${HOME}/.sparklogs/${CLASS}.o%J"

"${SPARK_JANELIA}" \
    --nnodes="${N_NODES}" \
    --no_check \
    --driveronspark \
    --silentlaunch \
    --minworkers="${MIN_WORKERS}" \
    --hard_runtime=${RUNTIME} \
    --submitargs="${SUBMIT_ARGS}" \
    --driveroutfile=${LOG_FILE} \
    lsd
