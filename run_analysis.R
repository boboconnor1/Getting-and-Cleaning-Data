#run_analysis.R

require(dplyr)

#establish directory path and file paths

dirPath <-"./project/UCI HAR Dataset"

#read raw files
activityLabels <- read.table(file.path(dirPath,"activity_labels.txt"),header = FALSE)
features <- read.table(file.path(dirPath,"features.txt"),header = FALSE)      
activityTest  <- read.table(file.path(dirPath, "test", "y_test.txt" ), header = FALSE)
activityTrain <- read.table(file.path(dirPath, "train", "y_train.txt"), header = FALSE)
featuresTest <- read.table(file.path(dirPath, "test", "X_test.txt"), header = FALSE)
featuresTrain <- read.table(file.path(dirPath, "train", "X_train.txt"), header = FALSE)
subjectTest <- read.table(file.path(dirPath, "test", "subject_test.txt"), header = FALSE)
subjectTrain <- read.table(file.path(dirPath, "train", "subject_train.txt"), header = FALSE)

#Merges the training and the test sets to create one data set

#Row Bind the like Test and Train tables
activityCombined <- rbind(activityTest, activityTrain)
featuresCombined <- rbind(featuresTest, featuresTrain)
subjectCombined <- rbind(subjectTest, subjectTrain)

#Labelling the columns
names(activityCombined)<- c("Activity")
names(subjectCombined)<-c("Subject")
getFeaturesNames <- read.table(file.path(dirPath, "features.txt"),head=FALSE)
names(featuresCombined)<- getFeaturesNames$V2

#Column Bind to get one comprehensive dataset
tempCombine <- cbind(activityCombined, subjectCombined)
masterData <- cbind(tempCombine,featuresCombined)

#Extracts only the measurements on the mean and standard deviation for each measurement

#Subset the getFeatureNames with 'mean' or 'std' in name

subOfFeaturesNames<-getFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", getFeaturesNames$V2)]

#Now subset the data frame with the subset names of Features Names

subsettedNames <- c(as.character(subOfFeaturesNames), "Subject", "Activity" )
masterData <- subset(masterData,select=subsettedNames)

#Uses descriptive activity names to name the activities in the data set
#(we have already read in the activity names into activityLabels)

activityLabels[, 2] = gsub("_", "", tolower(as.character(activityLabels[, 2])))

x = 1
for (xLabel in activityLabels$V2) {
        masterData$Activity <- gsub(x, xLabel, masterData$Activity)
        x <- x + 1
}

masterData$Activity <- as.factor(masterData$Activity)
masterData$Subject <- as.factor(masterData$Subject)

#Appropriately labels the data set with descriptive variable names

#Replaces some variable names with names that more clearly describe the activity
#and cleans up an error in variable name 'body'

names(masterData)<-gsub("^t", "time", names(masterData))
names(masterData)<-gsub("^f", "frequency", names(masterData))
names(masterData)<-gsub("BodyBody", "Body", names(masterData))

#Creates a second,independent tidy data set and ouput it
#This data set with the average of each variable for each activity and each subject

masterData2 <- aggregate(. ~Subject + Activity, masterData, mean)
masterData2 <- masterData2[order(masterData2$Subject,masterData2$Activity),]
write.table(masterData2, file = "tidydata.txt",row.name=FALSE)
