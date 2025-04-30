#!/bin/bash
source /apps/profiles/modules_asax.sh.dyn
module load openmpi

export PATH=$PATH:/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export OMPI_MCA_plm_rsh_agent=ssh
export OMP_NUM_THREADS=1
export TMPDIR=/tmp

if ! [ -f miniamr_latest.sif ]; then
  singularity pull library://mhchowdhury/collection/miniamr 
fi


if ! [ -f minivite_1.1.sif ]; then
  singularity pull library://mhchowdhury/collection/minivite:1.1
fi

if ! [ -f result/input/neuron1024.bin ]; then
  chmod +x create_minivite_input_jobs.sh
  ./create_minivite_input_jobs.sh
fi


if ! [ -f lulesh_latest.sif ]; then
  singularity pull library://mhchowdhury/collection/lulesh
fi
# singularity pull library://mhchowdhury/collection/lulesh


#Success

mkdir -p result result/input result/output


##submit with large queue and 120gb memory
mpirun  -np 16 apptainer run  --bind result:/opt/result miniamr_latest.sif  /opt/miniAMR/openmp/miniAMR.x --max_blocks 6000 --num_refine 4 --init_x 1 --init_y 1 --init_z 1 --npx 4 --npy 2 --npz 2 --nx 8 --ny 8 --nz 8 --num_objects 1 --object 2 0 -0.01 -0.01 -0.01 0.0 0.0 0.0 0.0 0.0 0.0 0.0009 0.0009 0.0009 --num_tsteps 200 --comm_vars 2 > result/output/miniamr_result16.txt
mpirun  -np 32 apptainer run  --bind result:/opt/result miniamr_latest.sif  /opt/miniAMR/openmp/miniAMR.x --max_blocks 4000 --num_refine 4 --init_x 1 --init_y 1 --init_z 1 --npx 4 --npy 4 --npz 2 --nx 8 --ny 8 --nz 8 --num_objects 1 --object 2 0 -0.01 -0.01 -0.01 0.0 0.0 0.0 0.0 0.0 0.0 0.0009 0.0009 0.0009 --num_tsteps 200 --comm_vars 2 > result/output/miniamr_result32.txt
mpirun -np 64 apptainer run --bind result:/opt/result miniamr_latest.sif  /opt/miniAMR/openmp/miniAMR.x --num_refine 4 --max_blocks 4000 --init_x 1 --init_y 1 --init_z 1 --npx 4 --npy 4 --npz 4 --nx 8 --ny 8 --nz 8 --num_objects 1 --object 2 0 -0.01 -0.01 -0.01 0.0 0.0 0.0 0.0 0.0 0.0 0.0009 0.0009 0.0009 --num_tsteps 200 --comm_vars 2 > result/output/miniamr_result64.txt



mpirun -n 8 apptainer run --bind result:/opt/result  minivite_1.1.sif  /opt/miniVite/./miniVite -f /opt/result/input/neuron1024.bin > result/output/minivite_result8.txt
mpirun -n 32 apptainer run --bind result:/opt/result  minivite_1.1.sif  /opt/miniVite/./miniVite -f /opt/result/input/neuron1024.bin > result/output/minivite_result32.txt
mpirun -n 64 apptainer run --bind result:/opt/result  minivite_1.1.sif  /opt/miniVite/./miniVite -f /opt/result/input/neuron1024.bin > result/output/minivite_result64.txt



mpirun -n 8 apptainer run lulesh_latest.sif /opt/LULESH/./lulesh2.0 -s 2 > result/output/lulesh_result2_8.txt
mpirun -n 27 apptainer run lulesh_latest.sif /opt/LULESH/./lulesh2.0 -s 3 > result/output/lulesh_result3_27.txt
mpirun -n 64 apptainer run lulesh_latest.sif /opt/LULESH/./lulesh2.0 -s 4 > result/output/lulesh_result4_64.txt
