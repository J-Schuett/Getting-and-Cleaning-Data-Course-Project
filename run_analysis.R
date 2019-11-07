if(file.exists("UCI HAR Dataset")){
    file_path <- "UCI HAR Dataset"
} else{
    file_path <- "."
}
run_analysis(file_path)

run_analysis <- function(file_path){
    X <- load_and_merge("X", "numeric", file_path = file_path)
    y <- load_and_merge("y", "integer", file_path = file_path)
    subject <- load_and_merge("subject", "integer", file_path = file_path)
    
    X <- select_and_rename_X_cols(X, file_path)
    y <- rename_activities(y, file_path)
    names(subject) <- "SubjectID"
    
    cbind(subject,y,X)
}

load_and_merge <- function(file_prefix = "X", type = "numeric",
                           file_path = file_path){
    test_file_name <- paste(file_prefix, "_test.txt", sep = "")
    test_data <- read.table(file.path(file_path, "test", test_file_name), 
                            colClasses = type, header = FALSE)
    train_file_name <- paste(file_prefix, "_train.txt", sep = "")
    train_data <- read.table(file.path(file_path, "train", train_file_name), 
                             colClasses = type, header = FALSE)
    merged_data <- rbind(test_data, train_data)
    merged_data
}

select_and_rename_X_cols <- function(data_X, file_path = file_path){
    feature_names <- read.table(file.path(file_path,"features.txt"), 
                                header = FALSE, colClasses = c("integer","character"))
    names(data_X) <- feature_names[[2]]
    mean_or_str_features <- grep("mean\\(\\)|std\\(\\)", feature_names[[2]])
    data_X <- data_X[,mean_or_str_features]
    data_X
}

rename_activities <- function(data_y, file_path = file_path){
    activity_labels <- read.table(file.path(file_path,"activity_labels.txt"), header = FALSE, 
                                  colClasses = c("integer","character"))
    activity_labels[[2]] <- tolower(activity_labels[[2]])
    data_y <- sapply(data_y, function(x) activity_labels[[2]][x])
    data.frame("Activity" = as.vector(data_y))
}