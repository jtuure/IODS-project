#Author: Juuso Tuure, date: 5.11.2020

# Access the dplyr library
library(dplyr)

#Download data, with a tabulator separator between columns:
lrn2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", 
                 sep = "\t",
                 header = TRUE
                 )
#Inspect the whole data by printing it  
lrn2014

#Inspect the dimensions of the data
dim(lrn2014) #Output = data matrix size 183 rows x 60 columns 

#Inspect the structure of the data
str(lrn2014) #Output = data.frame:	183 obs. of  60 variables. 
        #All other variables are integers/numbers, except "gender", which is a character array 

#Acquire the variables from data 
gender <- lrn2014$gender
age <- lrn2014$Age
attitude <- lrn2014$Attitude
points <- lrn2014$Points

#Questions related to deep, surface and strategic learning, in lrn2014 dataset
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

#Select columns related to deep, surface and strategic learning
deep_columns <- select(lrn2014, one_of(deep_questions))
surface_columns <- select(lrn2014, one_of(surface_questions))
strategic_columns <- select(lrn2014, one_of(strategic_questions))

#Create the variables deep, surface and strategic by averaging the related columns
deep <-rowMeans(deep_columns)
surface <- rowMeans(surface_columns)
strategic <- rowMeans(strategic_columns)

#Create a new dataset of the variables defined above
learning2014 <- data.frame(gender = gender, age = age, attitude = attitude, 
                     deep = deep, strategic = strategic, surface = surface,
                     points = points)

#Select the rows where points are greater than zero,
learning2014 <- filter(learning2014, points > 0)

str(learning2014) #Verifying that the dataset has 166 observations and 7 variables


#Write data as table
write.table(learning2014, file = "learning2014.txt", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")

# Read the saved data into R again
df <- read.table("learning2014.txt", header = TRUE, sep = ",", dec = ".")

#Verify the dataset read from the .txt file 
str(df) #Check the structure of the read dataset.
head(df)
