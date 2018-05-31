## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Read Data
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")  

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

##1. Merges the training and the test sets to create one data set.
dataX <- rbind(X_train,X_test)
datay<-rbind(y_train,y_test)
subject_data<-rbind(subject_test,subject_train)

##2. Extracts only the measurements on the mean and standard deviation for each measurement.
selected_fea <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
dataX <-dataX[,selected_fea[,1]]

##3. Uses descriptive activity names to name the activities in the data set
colnames(datay) <- "activity"
datay$activitylabel <- factor(datay$activity, labels = as.character(activity_labels[,2]))
activitylabel <- datay[,-1]

##4. Appropriately labels the data set with descriptive variable names.
colnames(dataX) <- features[selected_fea[,1],2]

##5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
colnames(subject_data) <- "subject"
data <- cbind(dataX, activitylabel, subject_data)
data_mean <- data %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(data_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
