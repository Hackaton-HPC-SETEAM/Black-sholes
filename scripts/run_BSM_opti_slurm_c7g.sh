#!/bin/bash
#SBATCH --job-name=BSM_full_c7g
#SBATCH --output=BSM_full_c7g_output_%j.log
#SBATCH --error=BSM_full_c7g_error_%j.log
#SBATCH --time=10:00:0
#SBATCH --nodes=1
#SBATCH --cpus-per-task=64
#SBATCH --partition=c7g
#SBATCH --exclusive
module purge
module use /tools/acfl/24.04/modulefiles
module load gnu
module load armpl


# Exécutez votre programme BSM compilé avec les paramètres
# ./BSM 10000000 1000000
./BSM_c7g 100000 1000000        
./BSM_c7g 1000000 1000000
./BSM_c7g 10000000 1000000
./BSM_c7g 100000000 1000000

