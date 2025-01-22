#!/bin/bash
#SBATCH --job-name=BSM_opti
#SBATCH --output=BSM_output_%j.log
#SBATCH --error=BSM_error_%j.log
#SBATCH --time=01:00:0
#SBATCH --nodes=2


# Exécutez votre programme BSM compilé avec les paramètres
srun ./BSM 10000000 1000