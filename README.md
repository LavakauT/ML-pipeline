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

Basic ML Pipeline

Code provided to:

Clean your data (ML_preprocess.py)
Define a testing set (test_set.py)
Select the best subset of features to use as predictors (Feature_Selection.py)
Train and apply a classification (ML_classification.py) or regression (ML_regression.py) machine learning model
Assess the results of your model (output from the ML_classification/ML_regression scripts with additional options in scripts_PostAnalysis
