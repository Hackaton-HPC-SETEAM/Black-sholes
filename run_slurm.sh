#!/bin/bash
#SBATCH --job-name=BSM_job
#SBATCH --output=BSM_output_%j.log
#SBATCH --error=BSM_error_%j.log
#SBATCH --ntasks=1
#SBATCH --mem=2G
#SBATCH --time=01:00:00

# Exécutez votre programme BSM compilé avec les paramètres
./BSM 10000000 100000