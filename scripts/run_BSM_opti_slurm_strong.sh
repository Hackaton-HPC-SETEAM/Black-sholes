#!/bin/bash
#SBATCH --job-name=BSM_full_c8g
#SBATCH --output=BSM_full_c8g_output_%j.log
#SBATCH --error=BSM_full_c8g_error_%j.log
#SBATCH --time=10:00:0
#SBATCH --nodes=1
#SBATCH --cpus-per-task=96
#SBATCH --partition=c8g
#SBATCH --exclusive
module purge
module use /tools/acfl/24.04/modulefiles
module load gnu
module load armpl


# Exécutez votre programme BSM compilé avec les paramètres
# ./BSM 10000000 1000000
OMP_NUM_THREADS=1
echo "num_core = 1"
../src/BSM 100000 1000000        
OMP_NUM_THREADS=2
echo "num_core = 2"
../src/BSM 100000 1000000   
OMP_NUM_THREADS=4
echo "num_core = 4"
../src/BSM 100000 1000000   
OMP_NUM_THREADS=8
echo "num_core = 8"
../src/BSM 100000 1000000   
OMP_NUM_THREADS=16
echo "num_core = 16"
../src/BSM 100000 1000000   
OMP_NUM_THREADS=32
echo "num_core = 32"
../src/BSM 100000 1000000 
OMP_NUM_THREADS=64
echo "num_core = 64"
../src/BSM 100000 1000000 
OMP_NUM_THREADS=96
echo "num_core = 96"
../src/BSM 100000 1000000   
