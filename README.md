# ML-pipeline (source from Shiu Lab Machine Learning Pipeline: https://github.com/bmmoore43/ML-Pipeline)

Please go to Shiu Lab github for comprehensive tutorial of ML. This repository follows their scripts but fix the syntax error due to the updating python environments and all dependencies (ML_classification_modified.py).

# Environment Requirements
- biopython 1.78
- matplotlib 3.5.3
- numpy 1.21.5
- pandas 1.3.5
- python 3.7.0
- scikit-learn 1.0.2
- scipy 1.7.3
```
$ wget http://repo.continuum.io/miniconda/Miniconda3-3.7.0-Linux-x86_64.sh -O ~/miniconda.sh
$ bash ~/miniconda.sh -b -p $HOME/miniconda
$ export PATH="$HOME/miniconda/bin:$PATH"
$ source /RAID1/working/R425/lavakau/miniconda3/etc/profile.d/conda.sh
$ conda create -n ml python==3.7.0 
$ conda install biopython
$ conda install matplotlib
$ conda install pandas
$ conda install scikit-learn

```

# Basic ML Pipeline

Code provided to:

1. Clean your data (ML_preprocess.py)
2. Define a testing set (test_set.py)
3. Select the best subset of features to use as predictors (Feature_Selection.py)
4. Train and apply a classification (ML_classification.py) or regression (ML_regression.py) machine learning model
5. Assess the results of your model (output from the ML_classification/ML_regression scripts with additional options in scripts_PostAnalysis)


# loop codes for multiple groups in your dataset
Based on basic ML pipeline, the steps from preprocess to feature selection consum lots of time to finish. We wrote a short bash script can run all the groups in your dataset once you arrange folders and files correctly ([preprocess.sh](https://github.com/LavakauT/ML-pipeline/blob/main/preprocess.sh)).

We also wrote short bash scripts to run traning in all groups of ML data.frames. Please notice that Random Forest consum lots of time to finish compared to other algorithms ([SVM.sh](https://github.com/LavakauT/ML-pipeline/blob/main/SVM.sh), [RF.sh](https://github.com/LavakauT/ML-pipeline/blob/main/RF.sh), [LogReg.sh](https://github.com/LavakauT/ML-pipeline/blob/main/LogReg.sh)). We suggest you to seperatily runing each one folder(group) in RF algorithm.


# Post ML
## Extract Machine learning results
Please follow [summary_ml_results.R](https://github.com/LavakauT/ML-pipeline/blob/main/summary_ml_results.R) to extract F1/AUC_ROC results in each groups and algorithms. Then, you can chose a best algorithm to extract the K-mers.

## PCC filter K-mers in 10 times training results
> suggested Folder arrangement
> Group
> -algorithm
> --imp files
>


First, please follow [get_kmer-imp_overlap.py](https://github.com/LavakauT/ML-pipeline/blob/main/get_kmer-imp_overlap.py)  to extract important K-mers among 10 times training in different algorithms.
Input: all imp files; Output: imp.txt (summary file including K-mers, imp value, and counts)


Then apply [ml_pcc_filte.R](https://github.com/LavakauT/ML-pipeline/blob/main/ml_pcc_filter.R) to pull out distinct and important K-mers in selected algorithm.
Input: imp.txt; Output: imp_distinct_pcc_enriched_kmer.txt
