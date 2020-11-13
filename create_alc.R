#Author: Juuso Tuure, 12.11.2020
#Data wrnangling script for IODS course, Exercise 3
#The data used is available online: https://archive.ics.uci.edu/ml/machine-learning-databases/00320/

#access the dplyr library
library(dplyr)

#Read downloaded datafiles into R
math <- read.table("student-mat.csv", 
                      sep = ";",
                      header = TRUE
)

por <- read.table("student-por.csv",
                  sep = ";",
                  header = TRUE)

#Explore the dimensions of the datasets "math" and "por" read into R
dim(math)
str(math)

dim(por)
str(por)

#common columns to use as identifiers
join_by <- c("school","sex","age","address",
             "famsize","Pstatus","Medu","Fedu",
             "Mjob","Fjob","reason","nursery","internet")

# joining the two  for students who answered the questionaire in both math and portugese by the selected identifiers
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

#Explore the dimension and the structure of the combined dataset "math_por" 

dim(math_por)
str(math_por)

#Combine the 'duplicated' answers in the joined data

# Start by creating a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]
# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

#create a new column 'alc_use' in "alc" by joining the average of the answers related to weekday and weekend alcohol consumption 

#define the new column alc_use
alc <-mutate(alc,alc_use = (Dalc + Walc))

#Then add a new logical colmn "high_use" to "alc"

#define the new logical column "high_use"
alc <- mutate(alc, high_use = alc_use > 2)

#A glimpse at the joined and modified data to make sure everything is in order. The joined data should now have 382 observations of 35 variables.  
glimpse(alc)

#Save alc dataset to the 'data' folder 
setwd('C:/Users/JT/Documents/IODS/IODS-project/data') #Set the working directory

write.table(alc, file = "alc.txt", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")
readtable <- read.table(file = 'C:/Users/JT/Documents/IODS/IODS-project/data/alc.txt', sep=",")

#Check that the datafile was written correctly
glimpse(readtable)
