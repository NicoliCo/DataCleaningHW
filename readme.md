Readme for run_analysis.R

The script run_analysis.R reads training and test data from the "UCI HAR Dataset" folder in your working directory. It then processes the data:

1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement.
3) Creates a column with a plain text name for each activity
4) Edits the variable names to be readable

This data set is called "alldata"

A tidy data set is then created for the mean of each variable for each activity and each subject. The rows are the variable names, the columns are the activity and subject.
