#!/bin/sh
#SBATCH --mail-user=jruiz@ingenieria.uner.edu.ar
#SBATCH --partition=internos
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --tasks-per-node=24
#SBATCH --error=./job.%J.err
#SBATCH --output=./job.%J.out
#SBATCH --job-name=Pulsew
matlab -nodesktop -nodisplay -nosplash < ExpPulsewave.m >out_PW.txt 2>err_PW.txt

