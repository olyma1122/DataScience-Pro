# Data Science Project

## WSDM - KKBox's Churn Prediction Challenge

Can you predict when subscribers will churn?

[KKBox's Churn Prediction Challenge](https://www.kaggle.com/c/kkbox-churn-prediction-challenge)

perform n-fold cross-validation on Titanic train data

```R
Rscript hw5_studentID.R -fold n -out performance.csv
```

## Shinyappsio: Interactive Data Dimensions

[My Shinyapps](https://olyma1122.shinyapps.io/proj/)


## Modeling

Model : Naive Bayes 

Cross-Validated : 5 folds 

Accuracy : 0.9557434


## Using Packages

please install those packages : caret, doMC, dplyr, readr, tibble

*caret : Perform n-fold cross-validation & Train the model

*doMC : Parallel Processing

*dplyr : data manipulation

*readr : input/output

*tibble : data manipulation

## Output

Precision : 0.9578  
Recall : 0.9999
F1 : 0.9784 
Accuracy : 0.9578
95% CI : (0.9554, 0.9601)
P-Value : 0.5077 
Sensitivity : 0.999927 
Specificity : 0.001667 
