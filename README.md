# flintstone
Ingition for your spark jobs

If you would like to use the public Janelia Spark deploy command, clone this repository like this:
```bash
git clone --recursive https://github.com/saalfeldlab/flintstone
```
Starting from version 1.9, `git-clone` you can specify a parameter `-j <n>` to fetch `n` submodules in parallel.

If your git version is older than `1.6.5`, or you already cloned the repository, run this after cloning:
```bash
git clone --recursive https://github.com/saalfeldlab/flintstone
```

Starting your Spark jobs on the Janelia cluster is really simple. Simply run
```bash
[TERMINATE=1] [RUNTIME=<hh:mm:ss>] [TMPDIR=<tmp>] <flintstone-root>/flintstone.sh <MASTER_JOB_ID|N_NODES> <JAR> <CLASS> <ARGV>
```
from a QLOGIN environment, where
 - `<MASTER_JOB_ID|N_NODES>` - job id of master (if already started) or number of worker nodes (otherwise)
 - `<JAR>` - path to jar containing your class and all dependencies
 - `<CLASS>` - class that holds spark main function
 - `<ARGV>` - any arguments passed to your class
 - `<TERMINATE>` - Shutdown master and worker nodes upon completion.
 - `<RUNTIME>` - Specify wall time of master node (will default to "default"). Will be ignored if connecting to existing master.
 - `<TMPDIR>` - Use `$TMPDIR` for tmp file that is used to start job. Defaults to `/tmp`
 - `<SPARK_DEPLOY_CMD>` - command used to deploy spark jobs to janelia lsf, defaults to `<flintstone-root>/spark-janelia/spark-janelia-lsf`

