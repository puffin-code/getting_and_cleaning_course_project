# Course project submission for Coursera Getting and Cleaning data - Week 4
#
# Instructions:
# You should create one R script called run_analysis.R that does the following.
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set 
#        with the average of each variable for each activity and each subject.

library(tidyr)
library(dplyr)

#download and unzip the file
zip_file = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
dest_file = 'downloaded.zip'
if (!dir.exists('UCI HAR Dataset')) {
    download.file(zip_file, dest_file, method = "curl");
    unzip(dest_file)
}

#Load the labels
measure_names = read.table('UCI HAR Dataset/features.txt', sep = " ", 
                           col.names = c("index", "label"))
activity_names = read.table('UCI HAR Dataset/activity_labels.txt', sep = ' ',
                            col.names = c("id", "activity"))
#tidy the label names
measure_names$label = gsub('[()]', '', measure_names$label)

#Omitting the meanFreq() measure as they are weighted, not raw averages.
mean_std_indices = grep('mean$|mean-|std', measure_names$label)


#Load, select, and tidy the training datasets
train_activities = read.csv('UCI HAR Dataset/train/y_train.txt', header = FALSE)
train_subjects = read.csv('UCI HAR Dataset/train/subject_train.txt', 
                          header = FALSE)
train_measures = read.table('UCI HAR Dataset/train/X_train.txt')
train_measures = train_measures[,mean_std_indices]
train_final = cbind(train_activities, train_subjects, train_measures) 
names(train_final) = c("activity_id", "subject", 
                       as.character(measure_names$label[mean_std_indices]))
train_final = mutate(train_final, study = "training")

#load, select, and tidy the test data
test_activities = read.csv('UCI HAR Dataset/test/y_test.txt', header = FALSE)
test_subjects = read.csv('UCI HAR Dataset/test/subject_test.txt', 
                          header = FALSE)
test_measures = read.table('UCI HAR Dataset/test/X_test.txt')
test_measures = test_measures[,mean_std_indices]
test_final = cbind(test_activities, test_subjects, test_measures) 
names(test_final) = c("activity_id", "subject", 
                       as.character(measure_names$label[mean_std_indices]))
test_final = mutate(test_final, study = "test")

#Concatenate the training and test data.frames
all_data = rbind(test_final, train_final)

#use descriptive activity names
all_data = merge(activity_names, all_data, by.x = "id", by.y = "activity_id" )
all_data = select(all_data, -id) #don't 'need 'id' this anymore

#split the column names so that each column contains only 1 variable
tidied = all_data %>%
    gather( key = signal, value = value, `tBodyAcc-mean-X`:`fBodyBodyGyroJerkMag-std` ) %>%
    separate(signal, sep = "-", c("signal", "statistic", "dimension")) 
    separate()
tidied$statistic = as.factor(tidied$statistic)

#Get the avaerage of each variable for each activity and subject combination
averages = tidied %>%
    group_by(activity, subject, signal, statistic, dimension) %>%
    summarize(avg = mean(value))

write.table(averages, "tidy_averages.txt", row.names=FALSE, quote=FALSE)



