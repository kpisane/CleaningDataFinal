################################################################################
#   Setup and Download File                                                    #
################################################################################
#check for the directory, if it does not exist, create it
if (!file.exists("./data")){dir.create("./data")}
#download the file into the new Programming Assignment Directory
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Wearable_Electronics.zip")
library(dplyr)
################################################################################                                                  
#   Step 1: Read in the Raw Data & Merge the Test and Training Sets            #
################################################################################

# Read in the training data and build the dataset
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
training <- cbind(subject_train, y_train, x_train)

# Read in the test data and build the dataset
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
testing <- cbind(subject_test, y_test, x_test)

# Read in the features vector to use as the variable names
features <- read.table("./UCI HAR Dataset/features.txt")
features <- features[,2]

# Merge the datasets (all columns are the same)
CompleteDataset <- rbind(training, testing)

# Remove the unneeded peices from the data set
rm(x_test, x_train, y_test, y_train, subject_test, 
   subject_train, training, testing)

################################################################################
#   Step 2: Extract only measurements on the mean and standard deviation       #
################################################################################

# Search for indices of the features that include mean or std but NOT meanFreq. 
keepers <- c(grep("mean[^F]|std", features))

# shift the indices of the keepers vector up by 2 to accomodate the addition of
# the subject and activity in the dataset
keepers <- c(1, 2, (keepers + 2))

# use the keepers vector to select only the mean and standard deviation values
CompleteDataset <- CompleteDataset[,keepers]

################################################################################
#   Step 3: Make the activity names descriptive                                #
################################################################################

# Assign the activity descriptions to the activity ids in col 2
CompleteDataset[,2] <- gsub(1, "walking", CompleteDataset[,2])
CompleteDataset[,2] <- gsub(2, "walkingupstairs", CompleteDataset[,2])
CompleteDataset[,2] <- gsub(3, "walkingdownstairs", CompleteDataset[,2])
CompleteDataset[,2] <- gsub(4, "sitting", CompleteDataset[,2])
CompleteDataset[,2] <- gsub(5, "standing", CompleteDataset[,2])
CompleteDataset[,2] <- gsub(6, "laying", CompleteDataset[,2])

################################################################################
#   Step 4: Label dataset with descriptive variable names                      #
################################################################################

# use the features vector to get the descriptive variable names. Adding a 
# subject and activity label to the first two rows containing 
# subject and activity
names <- c("subject", "activity", as.character(features))
colnames(CompleteDataset) <- names[keepers]

################################################################################
#   Step 5: Create the tidy dataset                                            #
################################################################################

# In this step, I create a tidy data frame.  First, I setup an empty dataframe
# that I can add my results into
tidyData <- tbl_df(data.frame())
# In the following set of nested loops, the following happens:
# 1. A subject ID (1 through 30) is selected
# 2. An activity is selected (nested loop)
# 3. For each pair of subjects and activities, x is the subset of the dataframe 
#    that falls into both groups
# 4. The mean is taken of all numeric entries in the dataset and basic 
#    transformations are made so that the result can be appended neatly to 
#    tidyData
# 5. The subject ID and activity are column bound to y to complete the row
# 6. The completed row (z) is tacked onto tidyData 
for (i in 1:30){
    for (j in 1:6){
        activities <- c("walking", "walkingupstairs", "walkingdownstairs", 
                        "sitting", "standing", "laying")
        x <- arrangedDataset %>% filter(subject==i, activity==activities[j]) %>%
        select(-(subject:activity)) 
        y <- as.data.frame(t(as.matrix(apply(x, 2, mean))))
        z <- cbind("subject"=as.numeric(i), "activity" = activities[j], y)
        tidyData <<- rbind(tidyData, z) 
    }
}
