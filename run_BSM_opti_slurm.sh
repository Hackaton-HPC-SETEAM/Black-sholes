#!/bin/bash
#SBATCH --job-name=BSM_opti
#SBATCH --output=BSM_output_%j.log
#SBATCH --error=BSM_error_%j.log
#SBATCH --time=01:00:0
#SBATCH --exclusive
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=96

module purge
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/arm/armpl_24.10_gcc/lib
module load armpl/24.10.0_gcc

# Exécutez votre programme BSM compilé avec les paramètres
strace ./BSM 1000000 10000
