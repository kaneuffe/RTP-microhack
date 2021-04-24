#!/bin/bash
#SBATCH --job-name=namd
#SBATCH --error=%x_%j.err
#SBATCH --output=%x_%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=120
#SBATCH --partition=hpc

#
# Load modules
#
module load mpi/hpcx

#
# Switch to workdir
#
WORKDIR=/shared/home/team06/namd/namd-benchmarks/1400k-atoms/
cd $WORKDIR
#
# Set INPUT variables
#
INPUT=benchmark.in

#
# Define variables
#
CHARMRUN="/sw/namd/charmrun +n ${SLURM_NTASKS} ++mpiexec ++remote-shell srun"
SINGULARITY="`which singularity` exec --bind /opt,/etc/libibverbs.d,/usr/bin/srun,/var/run/munge,/usr/lib64/libmunge.so.2,/usr/lib64/libmunge.so.2.0.0,/run/munge,/etc/slurm,/sched,/usr/lib64/slurm /shared/home/team06/namd/namd-2.14.sif"
NAMD2="/sw/namd/namd2"

export SINGULARITYENV_PATH=${PATH}
export SINGULARITYENV_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}

${SINGULARITY} ${CHARMRUN} ${SINGULARITY} ${NAMD2} ${INPUT}