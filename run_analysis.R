#### R script for Getting & Cleaning Data Course Project


## Load required packages
library(data.table)

## Set working directory (parameters modified a bit to remove personal info)
setwd(file.path('./', 'UCI HAR Dataset'))

## Load the data into R
# Load data about Activities
activity.test <- fread('./test/y_test.txt', header = F)
activity.train <- fread('./train/y_train.txt', header = F)
# Load data about Subjects
subject.test <- fread('./test/subject_test.txt', header = F) 
subject.train <- fread('./train/subject_train.txt', header = F) 
# Load data about Features
feature.test <- fread('./test/X_test.txt', header = F)
feature.train <- fread('./train/X_train.txt', header = F)

## Check the structure of a sample of the loaded datasets
str(activity.test)
str(subject.train)
str(feature.test)

## 1. Merging the training and test datasets
# Check for dimension compatibility
dim(activity.test)
dim(activity.train)
# The number of rows in the 2 datasets do not correspond, which 
# supposes we have to bind them vertically, assuming the 'V1' in 
# each dataset refers to the same thing. Same goes for Subjects
# and Features
# Binding by rows
activity <- rbind(activity.test, activity.train)
subject <- rbind(subject.test, subject.train)
feature <- rbind(feature.test, feature.train)
# Retreive and define feature dataset's variable names
feature.names <- fread('features.txt', header = F)
names(feature) <- feature.names$V2
# Recheck dimensions before merging by column
dim(activity)
dim(subject)
dim(feature)
# The row numbers correspond so we can bind by column now, 
# assuming we have one observation per row
# First step merging
merged.data0 <- cbind(activity, subject)
names(merged.data0) <- c('Activity', 'Subject')
# Second step merging
merged.data <- cbind(merged.data0, feature)

## 2. Extracting only measurements on the mean and sd
# View the features' names to see what to look for
View(feature.names)
# Identify all measurements on the mean and sd in 
# features name list
mean.sd.vars <- feature.names$V2[grep('[Mm]ean\\(\\)|std\\(\\)', 
                                      feature.names$V2)]
mean.sd.vars <- as.character(mean.sd.vars)
# Subset the data, excluding measurements not on the mean
# or sd
merged.data <- merged.data[, c('Activity', 'Subject', 
                               mean.sd.vars), with = F]

## 3. Using descriptive activity names to name the 
## activities in the data set
# Import the activity labels
activity.labels <- fread('activity_labels.txt', header = F)
# Convert the Activity variable into a fator
merged.data$Activity <- as.factor(merged.data$Activity)
# Use activity labels as levels of the activity factor variable
# in the merged dataset
levels(merged.data$Activity) <- activity.labels$V2

## 4. Labelling the dataset with descriptive variable names
# Check again the variable names
names(merged.data)
# Replace the prefix 't' with 'time'
names(merged.data)<-gsub("^t", "time", names(merged.data))
# Replace the prefix 'f' with 'frequency'
names(merged.data)<-gsub("^f", "frequency", names(merged.data))
# Replace short forms with complete words
names(merged.data)<-gsub("Acc", "Accelerometer", 
                         names(merged.data))
names(merged.data)<-gsub("Gyro", "Gyroscope", 
                         names(merged.data))
names(merged.data)<-gsub("Mag", "Magnitude", 
                         names(merged.data))
# Erase repetitive words
names(merged.data)<-gsub("BodyBody", "Body", 
                         names(merged.data))

## 5. Creating a second independant tidy dataset
# Aggregate the data by subject and activity
tidy.dataset <- aggregate(. ~Subject + Activity, merged.data,
                          mean)
# Save the tidy dataset on hard memory
write.table(tidy.dataset, file = "tidydataset.txt",
            row.name = F, col.names = T)

###### End of file














