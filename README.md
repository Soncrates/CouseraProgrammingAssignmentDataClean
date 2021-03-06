# CouseraProgrammingAssignmentDataClean

This project is for the Coursera Data Cleaning Class.

##Purpose
The purpose of  this project is to execute five (5) tasks
 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive variable names. 
 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

There is one r script,run_analysis.R , which when sourced into r command line, it will execute it's main function.  To disable this, you must edit the rscript and comment out the last command (line 125).

The r script can also execute verification to double check the calculations are accurate.  This can be enabled by uncommenting the for loop at the end  of main function (line 120:122)

##Summary

run_analysis.R completes two separate calculations; once for the training set and once for the test set.
Each calculation reads in 4 files:
 1. features.txt that provides the names of columns or variables
 2. a data set that contains values for each variable
 3. These two are used to construct a data frame with descriptive variable names,
 4. All variables that do not contain "std" or "mean" (case insensitive) are dropped from the data frame
 5. This data frame is enriched with two more vectors read in from the other two files
 6. These two other vectors must be assigned descriptive variable names
 7. These two other vectors are added to the data frame through cbind command
 8. These two other vectors correspond to Subject and Activity

These two calculations, result in two data frames

The training and test data frames are combined into a single data frame using rbind.

The vector for Activity is represented by an integer.  To give it meaning, one more  file is used, the activites labels file.  The labels file contains a string values for each activity. The merge command is used to combine the data frames on "activity_index".  Now the "activity_index" and has been replaced with string values in the "Activity" variable.
The final calculation requires the melt and dcast commands to perform the grouping and calculation of the mean values for each variable

##Expected Inputs

run_analysis.R expects to be in the r working directory and that the followning files are available and in aascii format

- 'activity_labels.txt': 
 1. Links the class labels with their activity name.  
 2. The expected format is two columns with a white space seperator.  The first column is vector of unique numbers while the second is a vector of unique strings 
- 'feature.txt':  
 1. Links column names to their measurements.  
 2. The expected format is two columns with a white space seperator.  The first column is vector of unique numbers while the second is a vector of unique strings
 3. The number of rows must corespond with the number of columns found in the training set and the test set.
- 'train/X_train.txt': Training set.
  1. Contains rows of floating point numbers separated by white space
  2. The number of columns must corespond with the number of row found in the feature.txt.
- 'train/y_train.txt': Training labels.  
 1. Contains a single column of  integers.
 2. Number or rows must correspond to number of row in Training Set
 3. Must coorespond to integers found in activity_lables.txt  
- 'test/X_test.txt': Test set.
  1. Contains rows of floating point numbers separated by white space
  2. The number of columns must corespond with the number of row found in the feature.txt.
- 'test/y_test.txt': Test labels.  
 1. Contains a single column of  integers.
 2. Number or rows must correspond to number of row in Test Set
 3. Must coorespond to integers found in activity_lables.txt  
- 'train/subject_train.txt' : Subject labels
 1. Contains a single column of integers.
 2. Number or rows must correspond to number of row in Training Set
- 'test/subject_test.txt' : Subject labels
 1. Contains a single column of integers.
 2. Number or rows must correspond to number of row in Test Set

##Expected Outputs

 - 'tidied_data.csv' : Merged data sets
  1. Contains rows separated by white space
  2. "Activity" column name should contain strings that only occur in the 'activity_labels.txt'
  3. First row contains header metadata, column names include, "Activity", "Subject" and every column from the original data set that includes the string "std" or "mean", both of which are case insensitive
 - 'step5_data.txt'
  1. Contains rows separated by white space
  2. "Activity" column name should contain strings that only occur in the 'activity_labels.txt'
  3. First row contains header metadata, column names include, "Activity", "Subject" and every column from the original data set that includes the string "std" or "mean", both of which are case insensitive
  4. Rows contain contain unique pairs of Activity and Subject and the columns, though they have  the same name as the tidied.csv, the value in each column contains the mean value found in all corresponding Activity and Subject rows from tidied.csv file. 

  The purpose of writing tidied_data.csv is to cache the calculation for generating step5_data.txt
