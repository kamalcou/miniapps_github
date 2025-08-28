<<<<<<< HEAD
# miniapps_github
Here are three files for running the miniapps. The run_jobs.sh script submits the jobs to your HPC system. You'll need to modify the job submission script according to your specific HPC environment. Verify whether your system uses Apptainer or Singularity containers and update the script accordingly if necessary.
```
sbatch run_jobs.sh

```
=======
miniapps_github
This guide provides instructions for running the miniapps. You must first ensure that your system is correctly configured.

Prerequisites
Before submitting jobs, confirm that your High-Performance Computing (HPC) system has the following software installed:

Apptainer/Singularity: A container platform.

Open MPI: The Message Passing Interface for parallel computing. Version 4.1.6 or later is expected.

Environment Setup
You must load the necessary modules to prepare your environment. The specific versions may vary by system.

Bash

# Load containerization module
module load apptainer  # Or singularity if Apptainer is not available

# Load MPI module
module load openmpi/gcc/64/4.1.5

# Load the Slurm module if your system uses it for job submission
module load slurm
Verification
Verify the versions of the loaded software and check your environment variables.

Check Open MPI version:

Bash

mpirun --version
Check Apptainer/Singularity version:

Bash

apptainer --version
singularity --version
Verify Environment Variables: Ensure that your $PATH variable includes the correct paths to the MPI and Apptainer/Singularity binaries. You may need to run the following commands to configure your environment.

Bash
```
export PATH=$PATH:/usr/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export OMPI_MCA_plm_rsh_agent=ssh
export OMP_NUM_THREADS=1
export TMPDIR=/tmp
Job Submission
Once the environment is configured, you can submit the jobs using the provided script.
```
Bash

sbatch run_jobs.sh
>>>>>>> e563f3c (Untracked file.ext and added to .gitignore)
