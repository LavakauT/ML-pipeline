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

#-----------------------clean data-----------------------
# WARNING: please change the 1,0 to pos,neg after pCRE
# cd ML_master
# python ML_preprocess.py -df [cluster_aba/hsfb_dwn_10.txt] -na_method median -onehot t

for dir in net/*/; do for inp in $dir*df_p0.01.txt; do python ML_preprocess.py -df $inp -na_method median -onehot t; done
#--------------------------------------------------------


#--------------------define test set---------------------
for dir in net/*/;do for inp in $dir*df_p0.01_mod.txt; do python test_set.py -df $inp -use pos,neg -type c -p 0.1 -save $inp.test; done; done
#--------------------------------------------------------


#-------------------select best features-----------------
for dir in net/*/;do for inp in $dir*df_p0.01_mod.txt; do python Feature_Selection.py -df $inp -cl_train pos,neg -type c -alg lasso -p 0.01 -save $inp.top_feat_lasso; done; done
#--------------------------------------------------------


echo"Job finished! Please go to train part."

