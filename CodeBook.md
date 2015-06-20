---
title: "CodeBook"
author: "RAO"
date: "Saturday, June 20, 2015"
output: html_document
---

Source of the original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Original description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The attached R script (run_analysis.R) performs the following to clean up the data:

Merges the training and test sets to create one data set, for instance:
    Activities with merged y_train.txt and y_test.txt (total 10299 observations of 1 variable)
    Features with merged X_train.txt and X_test.txt (total of 10299 observations of 561 variables)
    Subject with merged subject_train.txt and subject_test.txt (total of 10299 observations of 1 variable)
    
It provides proper column labels with the activities and subjects and then combines the datasets into 1 master dataset of 10299 observations of 561 variables 

We subset this to extrat only the measurements on the mean and standard deviation for each measurement, creating a dataset of 10299 observations with 68 variables (with 2 of the variables being the activity and subject)

All other measurements appear are floating point numbers in the range (-1, 1).

We label the data with the descriptive variable names:

        walking
        walkingupstairs
        walkingdownstairs
        sitting
        standing
        laying
        
We then do a bit of variable name clean up to clarify some of the variables such as 

substitute "time" for "t"
substitute "frequency" for "f"
remove the extra "Body" from "BodyBody"

The script then creates a 2nd independent tidy data set with the average of each measurement for each activity and each subject. The result is saved as tidy_data.txt, a 180x68 data frame, where the first column contains subject IDs, the second column contains activity names and then the averages for each of the 66 attributes are in columns 3...68. There are 30 subjects and 6 activities, thus 180 rows in this data set with averages.
