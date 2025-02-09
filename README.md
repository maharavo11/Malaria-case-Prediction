# Predicting Malaria and Diarhea cases in Mozambique leveraging Machine learning.

This repository consist of predicting malaria and diarrhea cases for each district in mozambique using machine learning model.

### The data
The data is a table containing malaria cases and diarrhea cases with different features of many districts in mozambique between 2016 and 2019 but the cases are empty in four months of 2018.

### Uses of Xgboost

This step consist of train xgboost model for each district and evaluate those models in a validation set for each district.

### Uses of KNN
This step consist of train knn model for each district and evaluate those models in a validatin set for each district.

### Combined model
For each district, this step consisit of comparing the best model between KNN and Xgboost and use the best model for each specific district to predict the missing values. 

