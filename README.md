######### Getting and Cleaning Data Course Project

The R script run_analysis.R, as the comments explicitly indicate, does the following:

1. Load the data.table package which enables an efficient (and relatively easy ) manipulation of large datasets.
2. Set the working directory and load the data into R
3. Check the structure of a sample of the loaded dataset to have an idea about how to manipulate them
4. Merge the training and test sets. The binding is done vertically in the first step as the row numbers differ. In the second step the dimensions match, so the matching is done horizontally, assuming there is an observation for each row.
5. Extract only measurements on the mean and sd. The code displays the variable names and then extracts only those with mean() or std() in the name.
6. Import activity labels and associates them with the activity codes.
7. Remplace short forms with descriptive full words.
8. Save the tidy dataset as tidydataset.txt.
