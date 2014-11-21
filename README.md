---
output: html_document
---
GCD-Project
===========

Getting and Cleaning Data Project

When sourced, the script run_analysis.R will produce the tidy data set finaldata. In order to run properly you must have the libraries plyr and dplyr. If they are not currently attached, run_analysis.R will attach them. You will need to have the following files in your working directory: activity_labels, features, subject_test, subject_train, X_test, X_train, y_test, and y_train.

Process

run_analysis.R cleans the data as follows:<UL>
  <LI>attach plyr and dplyr
  <LI>load all relevant data files from the working directory
  <LI>rbind the X_test and X_train data sets
  <LI>apply the column names to the new data set to make extraction easier
  <LI>extract only the values with mean or std in their name and cbind them into one data set
  <LI>create one combined activity file from y_test and y_train and replace the numbers with the appropriate descriptors from activity_labels
  <LI>create one combined subject list from subject_test and subject_train
  <LI>cbind the subject, activity and mean/std data sets together
  <LI>clean up the variable names of the new data set to make them easier to read
  <LI>create a data frame (finaldata) to hold the mean values of each variable taken by subject and activity
  <LI>create a vector (finalnames) to hold the corresponding label for each mean
  <LI>loop through each subject, taking the column means for each variable and updating finaldata and finalnames
  <LI>loop through each activity, taking the column means for each variable and updating finaldata and finalnames
  <LI>cbind finalnames to finaldata and label the columns with the appropriate variable names
  <LI>write finaldata to the working directory</UL>