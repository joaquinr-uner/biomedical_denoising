#!/bin/sh
#SBATCH --mail-user=jruiz@ingenieria.uner.edu.ar
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --tasks-per-node=24
#SBATCH --error=./job.%J.err
#SBATCH --output=./job.%J.out
#SBATCH --job-name=ElsqMN
matlab -nodesktop -nodisplay -nosplash < E_lsq_Meei_Norm.m >out_EMN.txt 2>err_EMN.txt

