Code Book
==========

## Before Analysis
download and unzip the file.

## 1. Read data and Merge
* st : subject IDs for test
* str  : subject IDs for train
* xt : values of variables in test
* xtr : values of variables in train
* yt: activity ID in test
* ytr : activity ID in train
* label : Description of activity IDs in y_test and y_train
* feature : description(label) of each variables in X_test and X_train

* merge : bind of X_train and X_test

## 2. Extract only mean() and std()
Create a vector of only mean and std labels, then use the vector to subset dataSet.
* ID : a vector of only mean and std labels extracted from 2nd column of features
* newmerge : newmerge will only contain mean and std variables

## 3. Get a clean data
* subject : bind of subject_train and subject_test
* act : bind of y_train and y_test
* final : a vector of clean data

## 4. Combine the column subject & activity to make it combined factor

* twoinone : combined subject and activity as one factor
* groupmean : get the groupmean
* finalfinal: seperate subject and activity in two columns.


## 5. Output tidy data
In this part, dataSet is melted to create tidy data. It will also add [mean of] to each column labels for better description. Finally output the data as "tidy_data.txt"
* baseData : melted tall and skinny dataSet
* secondDataSet : casete baseData which has means of each variables
