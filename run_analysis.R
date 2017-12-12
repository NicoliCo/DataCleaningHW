
# load activity names
activities=read.table("UCI HAR Dataset/activity_labels.txt",
                           col.names = c("id","activity"),header = FALSE)
activities$activity=tolower(activities$activity)
activities$activity=gsub("_up","Up",activities$activity)
activities$activity=gsub("_do","Do",activities$activity)

# load feature names
features=read.table("UCI HAR Dataset/features.txt",
                    col.names = c("id","feature"),header = FALSE,
                    colClasses = c("numeric","character"))
features = features$feature
# save columns that are mean() or std()
maskMeanStd = (grepl("mean()", features, fixed = TRUE) |
                   grepl("std()", features, fixed = TRUE))

# make feature names easier to read
features = gsub("[()]","",features)
features = gsub("Acc","Accelerometer",features)
features = gsub("Gyro","Gyroscope",features)
features = gsub("mean-([XYZ])","\\1-mean",features)
features = gsub("mean","Mean",features)
features = gsub("std-([XYZ])","\\1-std",features)
features = gsub("std","Std",features)
features = gsub("^t","time",features)
features = gsub("^f","frequency",features)
features = gsub("-","",features)
features = gsub("Mag","Magnitude",features)



#### load training set
train=read.table("UCI HAR Dataset/train/X_train.txt",
                    colClasses=rep("numeric",561),header = FALSE,
                    col.names = features, row.names = NULL)
trainSubjectIDs = read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
trainActivityLabels = read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)

#### load test set
test=read.table("UCI HAR Dataset/test/X_test.txt",
                colClasses=rep("numeric",561),header = FALSE,
                col.names = features, row.names = NULL)
testSubjectIDs = read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE,
                            colClasses = "character")
testActivityLabels = read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)


## merge activity labels
tmp = merge(testActivityLabels,activities,by.y="id",by.x="V1")
test$activity = as.factor(tmp$activity)
tmp = merge(trainActivityLabels,activities,by.y="id",by.x="V1")
train$activity = as.factor(tmp$activity)

## integrate subject IDs
test$subjectID = as.factor(testSubjectIDs$V1)
train$subjectID = as.factor(trainSubjectIDs$V1)

## combine training and test
alldata = rbind(train,test)

# keep only mean and std cols
alldata=alldata[,maskMeanStd]
alldata = alldata[,c(ncol-1,ncol,1:ncol-2)]

# make tidy data

tidydata=aggregate(alldata[,3:ncol],by=list(activity=alldata$activity,subject=alldata$subjectID),mean)

tidydata
