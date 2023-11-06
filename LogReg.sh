#!/bin/sh

date
echo "job submitted"
echo "requiring 20 tasks under this lovely user"

#SBATCH -A acl81744
#SBATCH -n 20
#SBATCH --mem 20G
#SBATCH --t 00-12:00

echo "Environment loading....."

cd /RAID1/working/R425/lavakau/ML_master
echo "python 3.7.0 envs activate: ml"
source /RAID1/working/R425/lavakau/miniconda3/etc/profile.d/conda.sh
conda activate ml



for dir in net/*/;do for inp in $dir*df_p0.01_mod.txt; do echo "python ML_classification_modified.py -df $inp  -test $inp.test -cl_train pos,neg -alg LogReg -apply all -plots T"; done; done

for dir in net/*/;do for inp in $dir*df_p0.01_mod.txt; do python ML_classification_modified.py -df $inp  -test $inp.test -cl_train pos,neg -alg LogReg -apply all -plots T; done; done

echo "job finished"
