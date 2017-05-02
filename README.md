R Script: run_analysis.R
Author: Kelly Pisane
Project: Coursera, Getting and Cleaning Data, Week 4 Programming Assignment
Last Modified: 1 May 2017

# Overview of analysis performed by run_analysis.R

1. reads in the raw data from the test and training sets
2. combines the test and training sets to make one dataset
3. extracts only the measurements of means and standard deviations from the full
    dataset
4. replaces activity ids (1-6) with descriptive activity names
5. names the variables (colunms) based on the information in the features.txt file
--at this point, we have a complete dataset to work with that is tidy (CompleteDataset)
6. creates a second tidy dataset (tidyData) that contains the average of each
   measurement in the CompleteDataset for each subject and activity
   
Step by step details are given below.


################################################################################
#  Step 1: Read in the Raw Data & Merge the Test and Training Sets             

## Step 1, part 1
This step reads in the X_train.txt, y_train.txt, and subject_train.txt
files and binds them together into a single data frame called 'training'.
Then, it repeats this process for the test data to get a second dataset
called 'testing'.
## Step 1, part 2
Read in the features.txt file since this contains the variable names.  
Because I only need the names and not the numbers, I keep only the second
column of the features dataframe.
## Step 1, part 3
Because the two datasets contain all the same variables (colunms) and no 
duplicate subjects, I can merge the datasets using the following
    CompleteDataset <- rbind(training, testing)
## Step 1, part 4
For convenience, I remove the unnecessary objects from my environment.
Because I have moved all the information from these objects into the
CompleteDataset dataframe, I will not need them again:
    rm(x_test, x_train, y_test, y_train, subject_test, 
        subject_train, training, testing)

################################################################################
#   Step 2: Extract only measurements on the mean and standard deviation       

## Step 2, part 1
First, I search for the indices of each element in the features vector that 
includes either the word 'mean' or 'std' excluding all elements containing 
'meanFreq' (by adding a [^F] in the regular expression):
    keepers <- c(grep("mean[^F]|std", features))
Because I added two columns to the left of the dataframe for the subject and 
activity ids, I need to add 2 to the indicees in 'keepers' to account for this:
    (keepers +2).
Additionally, since I will want to keep the subject and activity columns, I must
add their indicesd (1 and 2) back into the keepers vector: 
    keepers <- c(1, 2, (keepers + 2))

## Step 2, part 2
I use the keepers vector to select only the mean and standard deviation 
variables (colunms) from the dataset:
    CompleteDataset <- CompleteDataset[,keepers]

At this point, I have a subset of the dataset that includes only measurements of
means and standard deviations
################################################################################
#   Step 3: Make the activity names descriptive                                #

In the README file in the raw data folder, the activities are listed as:
1. walking, 2. walking upstairs, 3. walking downstairs, 4. sitting, 5. standing
and 6. laying.  Using this, I change the values 1-6 in the second column:
    CompleteDataset[,2] <- gsub(1, "walking", CompleteDataset[,2]), etc.

################################################################################
#   Step 4: Label dataset with descriptive variable names                      #

## Step 4, part 1
The features vector already contains the information needed to name most
of the variables. Because I added the subject and activity information to the 
left of the data frame, I create a names vector that includes "subject" and
"activity" as the first two elements followed by each of the elements in the 
features vector
    names <- c("subject", "activity", as.character(features))
## Step 4, part 2
Because I am only keeping a subset of the total list of features, I need to 
subset my names vector before using it to name the colunms:
    colnames(CompleteDataset) <- names[keepers]

## First Data Frame Completed
################################################################################
#   Step 5: Create the tidy dataset                                            

In this step, I create a tidy data frame.  

## Step 5, part 1
First, I setup an empty dataframe that I can add my results into
    tidyData <- tbl_df(data.frame())
## Step 5, part 2
This step uses nested for loops to get the average of each of the measurements in
my curret dataframe for every activity and everey subject.  A step by step description
of the activity in the nested for loops is as follows:
    1. A subject ID (1 through 30) is selected
    2. An activity is selected (nested loop)
    3. For each pair of subjects and activities, x is the subset of the dataframe that          falls into both groups
    4. The mean is taken of all numeric entries in the dataset and basic 
        transformations are made so that the result can be appended neatly to 
        tidyData
    5. The subject ID and activity are column bound to y to complete the row
    6. The completed row (z) is tacked onto tidyData 

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
# At the end of the script:
At the end of the script, you are left with two dataframes.  The first, CompleteDataset,
contains the mean and standard deviation measurements for every observation in the
raw dataset.  The second, tidyData, contains the average of the observations for each
of the 6 activities for each of the 30 subjects