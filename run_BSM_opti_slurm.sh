#!/bin/bash
#SBATCH --job-name=BSM_opti
#SBATCH --output=BSM_output_%j.log
#SBATCH --error=BSM_error_%j.log
#SBATCH --time=01:00:0
#SBATCH --exclusive
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=96

# Exécutez votre programme BSM compilé avec les paramètres
./BSM 1000000 10000
