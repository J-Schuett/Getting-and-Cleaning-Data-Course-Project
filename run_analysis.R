# This script creates a tidy dataframe df and a summarized tibble df_summarized of df.
# For details check README.md and CodeBook.md.

# The function run_analysis uses the dplyr package
library(dplyr)

# Check whether the files have been unzipped to "UCI HAR Dataset", 
# otherwise use the working directory
if(file.exists("UCI HAR Dataset") &
   file.exists("UCI HAR Dataset/test") &
   file.exists("UCI HAR Dataset/train")){
    file_path <- "UCI HAR Dataset"
} else{
    file_path <- "."
}

# This function takes the path to the files and returns a transformed dataframe.
merge_select_and_rename <- function(path = file_path){
    # load and merge "X_test" and "X_train"
    X <- load_and_merge("X", "numeric", path = path)
    # load and merge "y_test" and "y_train"
    y <- load_and_merge("y", "integer", path = path)
    # load and merge "subject_test" and "subject_train"
    subject <- load_and_merge("subject", "integer", path = path)
    
    # select the columns for X and rename them
    X <- select_and_rename_X_cols(X, path)
    # rename the entries and the column of y
    y <- rename_activities(y, path)
    # rename the column of the "subject" dataframe
    names(subject) <- "SubjectID"
    
    # combine all the columns
    df <- cbind(subject,y,X)
}

# This function loads the files from the the test and train directory and merges them.
# file_prefix should be "X", "y" or "subject".
load_and_merge <- function(file_prefix = "X", type = "numeric",
                           path = file_path){
    test_file_name <- paste(file_prefix, "_test.txt", sep = "")
    test_data <- read.table(file.path(path, "test", test_file_name), 
                            colClasses = type, header = FALSE)
    train_file_name <- paste(file_prefix, "_train.txt", sep = "")
    train_data <- read.table(file.path(path, "train", train_file_name), 
                             colClasses = type, header = FALSE)
    merged_data <- rbind(test_data, train_data)
}

# Renames all columns of X according to features.txt.
# Only those columns containing "mean()" or "std()" are returned.
select_and_rename_X_cols <- function(data_X, path = file_path){
    # get the feature names.
    feature_names <- read.table(file.path(path,"features.txt"), 
                                header = FALSE, colClasses = c("integer","character"))
    # assign the feature names to the columns of X.
    names(data_X) <- feature_names[[2]]
    # select only those columns that contain "mean()" or "std()"
    mean_or_str_features <- grep("mean\\(\\)|std\\(\\)", feature_names[[2]])
    data_X <- data_X[,mean_or_str_features]
}

# Renames the entries of y according to activity_labels.txt (but set to lowercase).
# The column of y is renamed to "Activity" and the transformed vector is returned.
rename_activities <- function(data_y, path = file_path){
    # get the activity names
    activity_labels <- read.table(file.path(path,"activity_labels.txt"), header = FALSE, 
                                  colClasses = c("integer","character"))
    activity_labels[[2]] <- tolower(activity_labels[[2]])
    # assign the activity names to the columns of y.
    data_y <- sapply(data_y, function(x) activity_labels[[2]][x])
    data.frame("Activity" = as.vector(data_y))
}

# The input is a dataframe produced by merge_select_and_rename,
# the output is tibble where the average of the other attributes is calculated by
# "SubjectID" and "Activity". Uses the dplyr package.
run_analysis <- function(df){
    dfg <- group_by(df,SubjectID, Activity) 
    summarize_all(dfg, funs(mean = mean))
}

# Run these functions to obtain the needed data sets:
df <- merge_select_and_rename()
df_summarized <- run_analysis(df)
# write.table(df_summarized, "summarized_data.txt", row.name=FALSE) 