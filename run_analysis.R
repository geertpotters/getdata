# Reading the data from the files in the zip
unzip("dataset.zip")
activity <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)
features <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)

Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
Ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
subtrain<-read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)

Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
Ytest<-read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
subtest<-read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)

# Clean the training data
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
Ytrain2<-merge(Ytrain, activity, by.x="V1", by.y="V1", all=FALSE)
colnames(Xtrain)<-features$V2
colnames(Ytrain2)<-c("Actnr", "Activity")
colnames(subtrain)<-as.vector("Subject")
Train<-cbind(subtrain, Ytrain2[,2], Xtrain)
colnames(Train)[2]<-"Activity"

# Clean the test data
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
Ytest2<-merge(Ytest, activity, by.x="V1", by.y="V1", all=FALSE)
colnames(Xtest)<-features$V2
colnames(Ytest2)<-c("Actnr", "Activity")
colnames(subtest)<-as.vector("Subject")
Test<-cbind(subtest, Ytest2[,2], Xtest)
colnames(Test)[2]<-"Activity"

# Merges the training and the test sets to create one data set.
dataset<-rbind(Train, Test)
dataset<-dataset[order(dataset$Subject),]

# Extracts only the measurements on the mean and standard deviation for each measurement. 
dataset2<-dataset[,grepl("mean", names(dataset))|grepl("std", names(dataset))]
dataset3<-dataset2[,!grepl("meanFreq", names(dataset2))]
dataset4<-cbind(dataset[,1:2], dataset3)

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
lev<-length(levels(as.factor(dataset4$Subject)))
col<-ncol(dataset4)
solution<-c(1:ncol(dataset4))

for(i in 1:lev){
     datacells<-dataset4[dataset4$Subject==i,2:col]
     solut<-aggregate(dataset4,by=list(dataset4$Activity), FUN=mean, 
                      subset=dataset4[,3:col], na.action = na.omit)
     solution<-rbind(solution, solut)
}

solution$Activity<-as.character(solution$Group.1)
solution<-solution[2:nrow(solution),2:ncol(solution)]
solution$Subject<-rep(1:30, each=6)

colnames(solution)<-sub("^t","Time domain: ",colnames(solution))
colnames(solution)<-sub("^f","Fourier Transf: ",colnames(solution))
colnames(solution)<-sub("BodyAccJerk","Body Linear Acceleration (jerking) ",colnames(solution))
colnames(solution)<-sub("BodyAcc","Body Linear Acceleration ",colnames(solution))
colnames(solution)<-sub("GravityAcc","Gravity Acceleration ",colnames(solution))
colnames(solution)<-sub("BodyGyroJerk","Body Angular moves (jerking) ",colnames(solution))
colnames(solution)<-sub("BodyGyro","Body Angular moves ",colnames(solution))
colnames(solution)<-sub("Mag","Magnitude  ",colnames(solution))
colnames(solution)<-sub("BodyBody","Body",colnames(solution))

write.table(solution, "smartphonedata.txt")