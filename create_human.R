#Author: Juuso Tuure, 19.11.2020
#Data wrnangling script for IODS course, Exercise 4
#The data used is available online in the following two sources:
#http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv
#http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv

#access library dplyr
library(dplyr)

#Read the datasets to R

#hd = Human Development 
#fii = Gended Inequality
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Explore the datasets 
str(hd)
dim(hd)
glimpse(hd)

str(gii)
dim(gii)
glimpse(gii)

#Create summaries of the variables
summary(hd)
summary(gii)


#Have a look at the column names
names(hd)
names(gii)


#Re-name columns of hd with shorter variable names
colnames(hd)[1] <- "hdirank"
colnames(hd)[2] <- "country"
colnames(hd)[3] <- "hdi"
colnames(hd)[4] <- "explife"
colnames(hd)[5] <- "expedu"
colnames(hd)[6] <- "meanedu"
colnames(hd)[7] <- "gnipc"
colnames(hd)[8] <- "gniminushdi"



#Re-name columns of gii with shorter variable names
colnames(gii)[1] <- "giirank"
colnames(gii)[2] <- "country"
colnames(gii)[3] <- "gii"
colnames(gii)[4] <- "mortratio"
colnames(gii)[5] <- "brate"
colnames(gii)[6] <- "repr"
colnames(gii)[7] <- "edu2f"
colnames(gii)[8] <- "edu2m"
colnames(gii)[9] <- "labf"
colnames(gii)[10] <- "labm"

#Mutate the "gii" dataset by adding two new columns (variables)
#secondary education ratio = "edu2ratio" and labour ratio = "labratio"

gii <- mutate(gii, edu2ratio = edu2f/edu2m)
gii <- mutate(gii, labratio = labf/labm)

#Join the two datasets

# common columns to use as identifiers
join_by <- c("country")

# join the two datasets by the selected identifiers
human <- inner_join(hd, gii, by = join_by, suffix = c(".hd", ".gii"))

glimpse(human) #The data should have 195 observations and 19 variables (and it has)

#Save human dataset to the 'data' folder 
setwd('C:/Users/JT/Documents/IODS/IODS-project/data') #Set the working directory

write.table(human, file = "human.txt", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")

