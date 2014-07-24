Human Activity Recognition Using Smartphones : Reshaped dataset
==================================================================
This file belongs to a set documents describing the data analysis of a set of smartphone movement data. The analysis is based upon the data described in: 

*Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*

The current file describes the measured variables. Other documents are the guide to the analysis itself, a separate R script and the output table. 

## Data collection ##
(section copied from the original Readme.txt, supplied with the data): 
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

### For each record have been provided: ###

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

More information about the original dataset can be found in the paper mentioned above. 

##Reshaping the dataset
The exact procedure is outlined in a separate Markdown document, distributed with the reshaped dataset and with this file on
https://github.com/geertpotters/getdata 

##The reshaped dataset

###Unit
All values were normalised and bounded within [-1,1]. They are therefore unitless. 

###Explaining the column header

The measured variables in the reshaped are named using a combination of terms. First, the column label starts with

**Time Domain OR Fourier Transf**:

The time domain signals were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. However, the signals were also treated with a Fast Fourier Transform (FFT). This element in the column label discriminates between both.  

**Linear acceleration or Angular Moves**:

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.  **(jerking) **indicates that the body linear acceleration and angular velocity were derived in time. 

**Body or Gravity**:

The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

**Magnitude**:

This indicates that the column contains the magnitude of the three-dimensional signals, calculated using the Euclidean norm. 

**Mean or std; -XYZ**:

Each type of data was summarized in the mean and the standard deviation (std). Finally,  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.







