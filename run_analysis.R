#   Assignment: create one R script called run_analysis.R that does the following. 
# 1 Merges the training and the test sets to create one data set.
# 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3 Uses descriptive activity names to name the activities in the data set
# 4 Appropriately labels the data set with descriptive variable names. 
# 5 From the data set in step 4, creates a second, independent tidy data set with the average of 
#     each variable for each activity and each subject.

#    This script requires the use of the plyr and dplyr packages.
library("plyr")
library("dplyr")

#    Load all necessary data sets. This script assumes all data sets are in the working directory.
activity_labels <- read.table("activity_labels.txt", quote="\"", stringsAsFactors=FALSE)
features <- read.table("features.txt", quote="\"", stringsAsFactors=FALSE)
subject_test <- read.table("subject_test.txt", quote="\"", stringsAsFactors=FALSE)
subject_train <- read.table("subject_train.txt", quote="\"", stringsAsFactors=FALSE)
X_test <- read.table("X_test.txt", quote="\"", stringsAsFactors=FALSE)
X_train <- read.table("X_train.txt", quote="\"", stringsAsFactors=FALSE)
y_test <- read.table("y_test.txt", quote="\"", stringsAsFactors=FALSE)
y_train <- read.table("y_train.txt", quote="\"", stringsAsFactors=FALSE)

#   Merge the test and training sets to create one data set 
mergeddata  <- rbind(X_test, X_train)

#   Extract the mean and standard deviation measurements 
names(mergeddata) <- tolower(features$V2) #It's easier to extract the appropriate variables 
                                          #by labelling them now rather than waiting.
data_mean <- mergeddata[grep("mean", names(mergeddata), ignore.case = TRUE)]
data_std  <- mergeddata[grep("std", names(mergeddata), ignore.case = TRUE)]
data  <- cbind(data_mean, data_std)

#   Apply descriptive labels for variables and activities 
activity <- rbind(y_test, y_train)
avect    <- activity[,1]
names1   <- as.character(activity_labels[,2])
anamed   <- mapvalues(avect, 1:6, names1)
subject  <- rbind (subject_test, subject_train)
data     <- cbind (subject, "activity" = anamed, data)
names(data)[names(data)=="V1"] <- "subject"
names(data) <- gsub("[()-]", "", names(data))
names(data) <- gsub("BodyBody", "body", names(data))
names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("^f", "fourier", names(data))

#   Compute means of all mean and SD variables grouped by subject and activity
finaldata   <- data.frame()     
finalnames  <- vector()
for (i in 1:30){    #Compute the column mean for each variable grouped by subject
  temp      <- filter(data, Subject == i)
  temp      <- select(temp, 3:88)
  tempmeans <- colMeans(temp)
  finaldata <- rbind (finaldata, tempmeans)
  finalnames[i] <- paste("Subject", i, sep =" ")
}

for (i in 1:6){    #Compute the column mean for each variable grouped by activity
  temp         <- filter(data, activity == names1[i])
  temp         <- select(temp, 3:88)
  tempmeans    <- colMeans(temp)
  finaldata    <- rbind (finaldata, tempmeans)
  finalnames[30+i] <- names1[i]
}
#   Create tidy data set and write it to disk
finaldata <- cbind(finalnames, finaldata)
names(finaldata) <- c("idvariable", names(tempmeans))
write.table(finaldata, "finaldata.txt", row.names=FALSE)
