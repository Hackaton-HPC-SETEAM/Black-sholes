#!/bin/bash
#SBATCH --job-name=BSM_full
#SBATCH --output=BSM_full_output_%j.log
#SBATCH --error=BSM_full_error_%j.log
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
../src/BSM_original 100000 1000000        
../src/BSM_original 1000000 1000000
../src/BSM_original 10000000 1000000
../src/BSM_original 100000000 1000000

