# Loading library plyr
library(plyr)

filename <- "getdata_dataset.zip"
# Download and unzip
if(!file.exists(filename)){
        fileURL <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method="curl")
}
        
if (!file.exists("UCI HAR Dataset")){
        unzip(filename)
}

# 1. Merges the training and the test sets to create one data set.

# Reading train and test txt files to respective table

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Merging train and test data sets

x_data <-rbind(x_train, x_test)
y_data <-rbind(y_train, y_test)
subject_data <-rbind(subject_train, subject_test)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# Reading features txt files 
features <- read.table("UCI HAR Dataset/features.txt")

# getting columns with mean() or std() and subset this in  x_data
mean_and_std_features <- grep("-(mean|std)\\(\\)",features[, 2])
x_data <- x_data[, mean_and_std_features]

# correct column name
names(x_data) <- features[mean_and_std_features, 2]


# 3. Uses descriptive activity names to name the activities in the data set

# Reading activities txt files 
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# updating activities value and correcting column name "activity"
y_data[, 1] <- activities[y_data[,1],2]
names(y_data) <- "activity"


# 4. Appropriately labels the data set with descriptive variable names. 

# correcting column name "subject"
names(subject_data) <- "subject"

# Binding all data set
all_data <- cbind(x_data, y_data, subject_data)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 66<- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject,activity),function(x) colMeans(x[,1:66]))
# write average date to text file
write.table(averages_data,"tidy_average_data.txt", row.name = FALSE)

