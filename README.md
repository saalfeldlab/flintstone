# flintstone
Ingition for your spark jobs

Starting your Spark jobs on the Janelia cluster is really simple. Simply run
```bash
[TERMINATE=1] [RUNTIME=<hh:mm:ss>] [TMPDIR=<tmp>] <flintstone-root>/.sh <MASTER_JOB_ID|N_NODES> <JAR> <CLASS> <ARGV>
```
from a QLOGIN environment, where
 - `<MASTER_JOB_ID|N_NODES>` - job id of master (if already started) or number of worker nodes (otherwise)
 - `<JAR>` - path to jar containing your class and all dependencies
 - `<CLASS>` - class that holds spark main function
 - `<ARGV>` - any arguments passed to your class
 - `<TERMINATE>` - Shutdown master and worker nodes upon completion.
 - `<RUNTIME>` - Specify wall time of master node (will default to "default"). Will be ignored if connecting to existing master.
 - `<TMPDIR>` - Use `$TMPDIR` for tmp file that is used to start job. Defaults to `/tmp`

