#############
# Setup
#############
setwd("C:/Users/Kelly/Desktop/DataScience/Getting and Cleaning Data/Programming Assignment")
#check for the directory, if it does not exist, create it
if (!file.exists("./data")){dir.create("./data")}
#download the file into the new Programming Assignment Directory
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Wearable_Electronics.zip")
#########################                                                       
#   Read in the Data    #
#########################

# read in the features
features <- read.table("./UCI HAR Dataset/features.txt")
features <- as.character(features[,2])
indices <- grep("mean[^F]|std", features)
features <- features[indices]

# read in the training data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x_train <- x_train[,indices]
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# read in the test data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x_test <- x_test[,indices]
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# y_test <- as.factor(y_test[,1]); subject_test <- as.factor(subject_test[,1])

#########################
# Combining Data Sets
##########################

# bind the information about the subject & label to datasets 
training <- cbind(subject_train, y_train, x_train)
testing <- cbind(subject_test, y_test, x_test)


# merge the datasets
fullDataset <- rbind(training, test)
colnames(testing) <- c("subject", "labels", features)
groupedData <- group_by(fullDataset, subject, labels)
apply(groupedData)


