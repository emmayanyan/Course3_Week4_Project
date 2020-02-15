setwd("C:/Users/Emma/Desktop/R/Course3/Week4RedoRedo")
## Data download and unzip 

# string variables for file download
fileName <- "UCIdata.zip"
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir <- "UCI HAR Dataset"

# File download verification. If file does not exist, download to working directory.
if(!file.exists(fileName)){
  download.file(url,fileName, mode = "wb") 
}

# File unzip verification. If the directory does not exist, unzip the downloaded file.
if(!file.exists(dir)){
  unzip("UCIdata.zip", files = NULL, exdir=".")
}

library("reshape2")
library(dplyr)
## read all files into R;Before reading, files are already downloaded and unziped in the local folder C:/Users/Emma/Desktop/R/Course3/Week4/UCI HAR Datase"


st<-read.table("C:/Users/Emma/Desktop/R/Course3/Week4/UCI HAR Dataset/test/subject_test.txt")
xt<-read.table("C:/Users/Emma/Desktop/R/Course3/Week4/UCI HAR Dataset/test/X_test.txt")
yt<-read.table("C:/Users/Emma/Desktop/R/Course3/Week4/UCI HAR Dataset/test/y_test.txt")

str<-read.table("C:/Users/Emma/Desktop/R/Course3/Week4/UCI HAR Dataset/train/subject_train.txt")
xtr<-read.table("C:/Users/Emma/Desktop/R/Course3/Week4/UCI HAR Dataset/train/X_train.txt")
ytr<-read.table("C:/Users/Emma/Desktop/R/Course3/Week4/UCI HAR Dataset/train/y_train.txt")

## Question 1
## merge the training & test file

merge<- rbind(xt,xtr)

## read label & feature file
label <- read.table("C:/Users/Emma/Desktop/R/Course3/Week4/UCI HAR Dataset/activity_labels.txt")
feature <- read.table("C:/Users/Emma/Desktop/R/Course3/Week4/UCI HAR Dataset/features.txt")  

##  select useful information from feature file

SelectFeature <- select(feature,2)

##  Question 2
## find out all mean() & std() names in SelectFeature file
ID <- grep("mean()|std()", SelectFeature$V2) 

## find mean() & std() data from merged file 

newmerge<- merge[,ID]
names(newmerge)<-SelectFeature[ID,]

##  Give subject & activity data labels
subject<- rbind(str,st)
names(subject) <- "subject"

act<- rbind(ytr,yt)
names(act) <-"activity"

## combine subject,act,newmerge files.
final<-cbind(subject,act,newmerge)

## Question 3
## Changed final$activity label to activity[,2] label
from <- factor(final$activity) 
levels(from) <- label[,2] ### linked newmerge & activity file
final$activity<-from

## Question 4
## Combine the column subject & activity to make it combined factor
twoinone<-unite(final,subject_activity,c("subject","activity"))
groupmean<-aggregate(twoinone[, 2:ncol(twoinone)], list(twoinone$subject_activity), mean)

## 
## Get group average grouped by subject_activity column.
groupmean1<-twoinone %>% group_by(subject_activity) %>% summarise_at(.vars = names(.)[2:ncol(twoinone)], funs(mean(., na.rm=TRUE)))


## separate the name
finalfinal<- separate(groupmean1,subject_activity,c("subject","activity"))
View(finalfinal)

# Question 5
## melt data to tall skinny data and cast means. Finally write the tidy data to the working directory as "tidy_data.txt"
baseData <- melt(finalfinal,(id.vars=c("subject","activity")))
secondDataSet <- dcast(baseData, subject + activity ~ variable, mean)
names(secondDataSet)[-c(1:2)] <- paste("[mean of]" , names(secondDataSet)[-c(1:2)] )
write.table(secondDataSet, "tidy_data.txt", sep = ",")

