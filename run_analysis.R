setwd("C:/Users/Kelly/Desktop/DataScience/Getting and Cleaning Data/Programming Assignment")
#check for the directory, if it does not exist, create it
if (!file.exists("./data")){dir.create("./data")}
#download the file into the new Programming Assignment Directory
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Wearable_Electronics.zip")
