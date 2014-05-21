
install.packages("plyr")
library(plyr)

setwd("C:\\Users\\Max\\Desktop\\Coursera\\Getting and Cleaning Data\\Project")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data.zip")

unzip("data.zip")

# Import train and test data sets
X_train <- read.table("UCI HAR Dataset\\train\\X_train.txt", quote="\"")
X_test <- read.table("UCI HAR Dataset\\test\\X_test.txt", quote="\"")

# Merge two data sets
merged_data <- rbind(X_train, X_test)

# Import and set collumn names for merged data set
colnames <- read.table("UCI HAR Dataset\\features.txt", quote="\"")
colnames(merged_data) <- colnames[, 2]

# Search for collumns that contain "mean" or "std" as part of it's name
mean_pos <- grep("-mean()", colnames[, 2], fixed = T)
std_pos <- grep("-std()", colnames[, 2], fixed = T)

# Subset the relevant collumns
data_set <- merged_data[, c(mean_pos, std_pos)]
colnames(data_set)

# Import activity labels and subjects
activity_labels <- read.table("UCI HAR Dataset\\activity_labels.txt", quote="\"")
y_train <- read.table("UCI HAR Dataset\\train\\y_train.txt", quote="\"")
y_test <- read.table("UCI HAR Dataset\\test\\y_test.txt", quote="\"")
y_data <- c(y_train[, 1], y_test[, 1])

subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt", quote="\"")
subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt", quote="\"")
subject_data <- c(subject_train[, 1], subject_test[, 1])

# Add variables "Subject" and "activity"
data_set <- cbind(subject_data, activity_labels[y_data, 2], data_set)
colnames(data_set)[1] <- "subject"
colnames(data_set)[2] <- "activity"

# second data of grouped averages
data_of_averages = ddply(data_set, c("subject", "activity"), numcolwise(mean))

# export data sets
write.table(data_set, "data_set.txt", sep="\t")
write.table(data_of_averages, "data_of_averages.txt", sep="\t")

