# Readme for the run_analysis.R script
## Usage
This script combines data obtained from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to a tidy new dataframe df and a summary of this dataset called df_summarized. The original data must be contained in a folder called "UCI HAR Dataset" or directly in the working directory. The function run_analysis uses the dplyr package.

## The function merge_select_and_rename
This function first merges the data from "test/X_test.txt" and "train/X_train.txt" via rbind in that order (as well as y_test.txt, y_train.txt and subject_test.txt, subject_train.txt respectively). 
Next, the columns of the merged X dataframe are renamed using features.txt. Then, we select only the columns whose name contains "mean()" or "std()". The values of the merged y dataframe are renamed using activity_labels.txt and its column is named "Activity". The column of the merged subject data is renamed to "SubjectID". Finally these transformed subject, y and X data sets are merged via cbind and returned.

## The function run_analysis
Takes a dataframe resulting from merge_select_and_rename. Uses the dplyr package to group this dataframe by "SubjectID" and "Activity". Then the mean for this grouping is calculated, automatically adding "_mean" to the names of the respective columns. Returns a tibble object.
