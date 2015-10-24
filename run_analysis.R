### Jijun Ge
### course: Getting and Cleaning Data
### Fall, 2015

### Course Project
#One of the most exciting areas in all of data science right now is wearable computing. 
#Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
#The data is collected from the accelerometers from the Samsung Galaxy S 
#smartphone. A full description is available at the site where the data was obtained: 
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

#Here are the data for the project: 
    
#    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#You should create one R script called run_analysis.R that does the following. 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each 
#subject.

##################################################
#question 1: Merges the training and the test sets to create one data set which will include following data:
#- Its activity label. 
#- An identifier of the subject who carried out the experiment.
#- A 561-feature vector with time and frequency domain variables. 


getwd()
setwd("C:/Users/jijun/Documents/3.Getting and Cleaning Data")

#download the data file and stored in the local folder.
file<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(file,destfile="./CourseProject/Dataset.zip", mode="wb")

#read train data
Y <- read.table("./CourseProject/train/Y_train.txt") 
names(Y)<-"activity"
subjectTrain<- read.table("./CourseProject/train/subject_train.txt")
names(subjectTrain) <-"person"
trainData <- read.table("./CourseProject/train/X_train.txt")
feathures <-read.table("./CourseProject/features.txt")
names(trainData) <- feathures[,2]
train <- cbind(Y,subjectTrain, trainData)

YTest <- read.table("./CourseProject/test/Y_test.txt") 
subjectTest<- read.table("./CourseProject/test/subject_test.txt")
testData <- read.table("./CourseProject/test/X_test.txt")
names(YTest)<-"activity"
names(subjectTest) <-"person"
names(testData) <- feathures[,2]
test <- cbind(YTest,subjectTest,testData)

#combine train and test data
alldata <-rbind(test, train)


#################################
#Question 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#the measurements includes "Triaxial acceleration from the accelerometer  and Triaxial Angular velocity from the gyroscope."
AccMean <- alldata[,c(3:5)]; AccStdEv <-alldata[,c(6:7)]
GraMean <-alldata[,c(43:45)]; GraStdEv<-alldata[,c(46:48)]

####################################### 
#Question 3. Uses descriptive activity names to name the activities in the data set
# Following is the activities list
# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING

# create a activity table
activitylist <- c("walking","walkingUpstairs","walkingDownstairs","sitting","standing","laying")
m <- rbind(Y,YTest)
Realact <- apply(m,1,function(x) activitylist[x] )
alldata[,1] <-Realact


######################question 4
# Appropriately labels the data set with descriptive variable names. 
##important points about text in datasets
##all lower case

dataName <-tolower(names(alldata))
names(alldata) <- gsub("\\(|-|)","", dataName)
names(alldata) <- gsub("mag","magnitude", names(alldata))
names(alldata) <- gsub("gyro","gyroscope", names(alldata))

#####################
##question 5
##From the data set in step 4, creates a second, independent tidy data set with the 
##average of each variable for each activity and each subject.
newdata <- alldata[,-c(1:2)] # get rid of the first two columns
meanData <- as.data.frame(lapply(newdata, mean))
codebook <- names(meanData)

write.table(codebook, file="codebook.md", col.name=FALSE, sep = " ")
write.table(meanData, file="meanData.txt", col.name=FALSE, sep = " ")
