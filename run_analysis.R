# The purpose of this script is tidy two data sets recorded from 
# sensors in a mobile phone during  differing levels of strenuous activities 

# step 1 merge data sets from several data sets
# step 2 Extract only measures of mean and std
# step 3 give descriptive values in the 'Activities' column
# step 4 give descriptive names to all columns
# step 5 create data file that contains the average values for std and mean
#    for each activity, for each subject

# This function loads the mobile phone sensor data
# it accomplishes step 2, and step 4
baseGetSet <- function(filename) {
    labels <- read.table("features.txt")$V2

    # finding columns desired for step 2
    desired <- labels[grepl("std|mean", labels,ignore.case=TRUE)]  
    ret <- read.table(filename)

    # accomplishing step 4, applying  meaningful names
    colnames(ret) <- labels

    # accomplishing step 2, restricting columns to only those that 
    #  contain mean and std deviation measurements
    ret[,(names(ret) %in% desired)]
}

baseGetActivity <- function(filename){
    ret <- read.table(filename)
    colnames(ret)[1] <- "activity_index"
    ret  
}

baseGetSubject <- function(filename){
    ret <- read.table(filename)
    colnames(ret)[1] <- "Subject"
    ret  
}

getTrainingData <- function() {
    subjects <- baseGetSubject("train/subject_train.txt")
    labels   <- baseGetActivity("train/y_train.txt")
    set      <- baseGetSet("train/X_train.txt")
    ret <- cbind(subjects,labels,set)  
}

getTestingData <- function() {
    subjects <- baseGetSubject("test/subject_test.txt")
    labels   <- baseGetActivity("test/y_test.txt")
    set      <- baseGetSet("test/X_test.txt")
    ret <- cbind(subjects,labels,set)  
}

main_1 <- function() {
  # step 1 merge data sets
  
    testing<-getTestingData()
    training<-getTrainingData()  
    ret <- rbind(training,testing)
  
  # at this point, step 1,2,and 4 have been completed
  # now use the merge command, merge reodrers the data
  # other wise it would have been used earlier
    
    map <- read.table("activity_labels.txt")
    colnames(map)[2] <- "Activity"
    colnames(map)[1] <- "activity_index"

  # step 3 give descriptive value in Activity column
  
    ret <- merge(ret,map,by.x="activity_index",by.y="activity_index")
    ret <- ret[,!(names(ret) %in% c("activity_index"))]      
}

main_2 <- function (df) {
  # step 5
  library(reshape2)
  names <- names(df)
  desired <- names[grepl("std|mean", names,ignore.case=TRUE)]
  groups <- names[!(names %in% desired)]
  
  # group by Activity and Subject
  temp <- melt(df,id = groups, measure.vars = desired) 
  # average all variables for each subject for each activity
  dcast(temp, Activity + Subject ~ variable,mean) 
}

main <- function() {
    temp1 <- "tidied_data.csv"
    temp2 <- "step5_data.txt"
    if (!file.exists(temp1)) {
      data <- main_1()
      write.table(data,temp1)
    }
    if (!file.exists(temp2)) {
      data <- read.table(temp1)
      ret <- main_2(data)
      write.table(ret,temp2,row.name=FALSE)
    }
    data <- read.table(temp1)
    ret <- read.table(temp2,header = TRUE)
    
    verify <- function(Activity="LAYING",Subject=1) {
      
      test1 <- ret[ret$Activity==Activity,]
      test1 <- test1[test1$Subject==Subject,]
      test1 <- test1$tBodyAcc.mean...X
      
      compare1 <- data[data$Activity==Activity,]
      compare1 <- compare1[compare1$Subject==Subject,]
      compare1 <- mean(compare1$tBodyAcc.mean...X)
      if (test1 - compare1 < 0.01) {
        msg <- paste(c("Success", Subject, Activity),collapse = " ")
        print (msg)
      } else {
        msg <- paste(c("Failed", Subject, Activity , "Expected : ", compare1, ", received :", test1),collapse = " ")
        print (msg)
      }
    }
    #for ( i in 1:20 ) {
    #  verify(Subject=i)      
    #}
   ret
}
main()
