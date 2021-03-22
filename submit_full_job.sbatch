#!/bin/bash
#SBATCH -t 16:00:00                  # Job run time (hh:mm:ss)
#SBATCH -N 1                        # Number of nodes
#SBATCH -J MUSIC            # Name of batch job
#SBATCH -A qgp
#SBATCH -p qgp
#SBATCH -o serial.o%j              # Name of batch job output file
#SBATCH -e serial.e%j

results_folder=results

export OMP_NUM_THREADS=1
# hydro evolution
./MUSIChydro music_input 1>mode_2.log 2>mode_2.err
#grep 'Shear regulation' mode_2.log | \
      awk '{$1="";$2="";$4=0.5; print}' | \
      column -t > $results_folder/piViolation.dat
grep 'Bulk regulation' mode_2.log | \
      awk '{$1="";$2="";print}' | \
      column -t > $results_folder/BulkpiViolation.dat
sweeper.sh $results_folder
# multiple Cooper-Frye in sequence ... 
