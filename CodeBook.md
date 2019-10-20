# getting_and_cleaning_course_project
## coursera getting and cleaning data course project.

The script included in this repository (run_analysis.R) performs the following steps:
1. Reads the raw data that are included in https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.  Specifically, the following files are used:
1.1 UCI HAR Dataset/features.txt - which contains the list of metrics that are collected in the UCI HAR Dataset/train/X_train.txt files
1.2 UCI HAR Dataset/activity_labels.txt - which contins the activity names to match the IDs in UCI HAR Dataset/train/X_train.txt files
1.3 UCI HAR Dataset/*/y_train.txt - lists the activities for each observation
1.4 UCI HAR Dataset/*/subject_*.txt - list the subject IDs for each observation (these are never de-anonymized)
1.5 UCI HAR Dataset/*/X_*.txt - the 561 measurables that are report for each observation.  
 - Asterisks listed above indicate either "test" or "train".   
2. Selects only the measurables that are means or standard deviations from the 561 total.   This results in keeping 66 measurables.
3. The activity names and subject ids are collected into a data frame with the other observations
4. Data from the train and test data sets are concatenated into 1 variable.
5. Finally, the tidy data set that is reported in 'tidy_averages.txt' has the following columns:
5.1 Activity - one of the 6 activites for which we have measurements
5.2 subject - an integer between 1 and 30
5.3 signal - the type of signal that is measured.  Details on these are included in the 'features_info.txt' files included in the zip listed above.
5.4 statistic - either 'mean', or 'std'
5.5 dimension - either X, Y, or Z or NA when a measurment is dimensionless
5.6 avg - the average over any observations that have the same activity, subject, activity, signal, and dimension



