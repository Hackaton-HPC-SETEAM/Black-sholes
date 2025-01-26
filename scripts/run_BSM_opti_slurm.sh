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
../src/BSM 100000 1000000        
../src/BSM 1000000 1000000
../src/BSM 10000000 1000000
../src/BSM 100000000 1000000

