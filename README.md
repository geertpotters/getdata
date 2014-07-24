---
title: "Human Activity Recognition Using Smartphones : Dataset analysis"
author: "Geert Potters"
date: "Wednesday, July 23, 2014"
---
This file belongs to a set documents describing the data analysis of a set of smartphone movement data. The analysis is based upon the data described in: 

*Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*

The current file describes the data analysis. Other documents are the codebook, describing the measured variables, a separate R script and the output table. These files can be found on:
https://github.com/geertpotters/getdata.

The data were read from the downloaded file into R and given the following names. 
Headers were not found in the original data files, and were to be obtained in 
some of the extra files (activity_labes.txt and features.txt)


```r
unzip("dataset.zip")
activity <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)
features <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)

Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
Ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
subtrain<-read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)

Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
Ytest<-read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
subtest<-read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
```

# Cleaning of the data
The first set of commands is meant to change the uninformative headers of the columns into variable names. Them, the training data are joined into one data table. 


```r
Ytrain2<-merge(Ytrain, activity, by.x="V1", by.y="V1", all=FALSE)
colnames(Xtrain)<-features$V2
colnames(Ytrain2)<-c("Actnr", "Activity")
colnames(subtrain)<-as.vector("Subject")
Train<-cbind(subtrain, Ytrain2[,2], Xtrain)
colnames(Train)[2]<-"Activity"
```

The same procedure is followed for the test datasets.


```r
Ytest2<-merge(Ytest, activity, by.x="V1", by.y="V1", all=FALSE)
colnames(Xtest)<-features$V2
colnames(Ytest2)<-c("Actnr", "Activity")
colnames(subtest)<-as.vector("Subject")
Test<-cbind(subtest, Ytest2[,2], Xtest)
colnames(Test)[2]<-"Activity"
```

Subsequently, the training and the test sets were joined using rbind, to create one data set.


```r
dataset<-rbind(Train, Test)
dataset<-dataset[order(dataset$Subject),]
```

Several data types can be collected with the smartphones or calculated from those data.
Here we choose to present only means and standard deviations of the data.
Hence, only these columns are selected; the others were removed from the set. 


```r
dataset2<-dataset[,grepl("mean", names(dataset))|grepl("std", names(dataset))]
dataset3<-dataset2[,!grepl("meanFreq", names(dataset2))] #intruder!
dataset4<-cbind(dataset[,1:2], dataset3)
```

# Creation of a tidy data set 
For every person who participated in the study and for every type of activity, a list of averages and standard deviations is given. Here, we take the mean of every column, in function of the participant and the activity. 


```r
lev<-length(levels(as.factor(dataset4$Subject)))
col<-ncol(dataset4)
solution<-c(1:ncol(dataset4))

for(i in 1:lev){
     datacells<-dataset4[dataset4$Subject==i,2:col]
     solut<-aggregate(dataset4,by=list(dataset4$Activity), FUN=mean, 
                      na.action = na.omit)
     solution<-rbind(solution, solut)
}
```

# Using descriptive variable names. 
Finally, we address the data labels. 
The activity labels are restored after the function aggregate() messed them up. The subject numbers are restored. 
To end the labelling, the variable columns are given a more readable description of what they contain. 



```r
solution$Activity<-as.character(solution$Group.1)
solution<-solution[2:nrow(solution),2:ncol(solution)]
solution$Subject<-rep(1:30, each=6)

colnames(solution)<-sub("^t","Time domain: ",colnames(solution))
colnames(solution)<-sub("^f","Fourier Transf: ",colnames(solution))
colnames(solution)<-sub("BodyAccJerk","Body Linear Acceleration (jerking) ",
                        colnames(solution))
colnames(solution)<-sub("BodyAcc","Body Linear Acceleration ",
                        colnames(solution))
colnames(solution)<-sub("GravityAcc","Gravity Acceleration ",
                        colnames(solution))
colnames(solution)<-sub("BodyGyroJerk","Body Angular moves (jerking) ",
                        colnames(solution))
colnames(solution)<-sub("BodyGyro","Body Angular moves ",colnames(solution))
colnames(solution)<-sub("Mag","Magnitude  ",colnames(solution))
colnames(solution)<-sub("BodyBody","Body",colnames(solution))
```

Finally, the processed data were written to a textfile. 


```r
write.table(solution, "smartphonedata.txt")
```

This concludes our analysis. 

##License:

Use of this dataset in publications must be acknowledged by referencing the 
following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.
