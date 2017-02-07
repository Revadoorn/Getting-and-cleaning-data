## Peer Assignment week 4

# Set working directory and install/load required packages
setwd("C:/REMCO/Coursera/CourseR/Course-3/wk4/Peer/")
install.packages("data.table")
install.packages("reshape2")
library("data.table")
library("reshape2")

# Load metadata into data frame
activity_labels <- read.table("activity_labels.txt")[,2]
features <- read.table("features.txt")[,2]

# Extracts only the measurements on the mean and standard deviation for each measurement.  
extract_features <- grepl("mean|std", features)

# Load test data
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
# change names of x_test
names(x_test) = features

# only the measurements on the mean and standard deviation
x_test = x_test[,extract_features]

y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Merge test y and x data
test_dataset <- cbind(as.data.table(subject_test), y_test, x_test)

# Load train data 
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

# change names of x_train
names(x_train) = features

# only the measurements on the mean and standard deviation. 
x_train = x_train[,extract_features]

y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Merge test and train data
train_dataset <- cbind(as.data.table(subject_train), y_train, x_train)
dataset <- rbind(test_dataset, train_dataset)

# Create variable and value column
id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(dataset), id_labels) #data.table package function
melt_dataset = melt(dataset, id = id_labels, measure.vars = data_labels) #data.table package function

# Apply mean function to dataset using dcast function
tidy_dataset   = dcast(melt_dataset, subject + Activity_Label ~ variable, mean)
write.table(tidy_dataset, file = "./tidy_dataset.txt")
