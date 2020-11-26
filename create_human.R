#Author: Juuso Tuure, 19.11.2020 & Continued on 26.11.2020
#Data wrnangling script for IODS course, Exercise 4 and Exercise 5
#The data used is available online in the following two sources:
#http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv
#http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv


#access library dplyr
library(dplyr)

#access library stringr
library(stringr)

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
colnames(hd)[1] <- "HDI.Rank"
colnames(hd)[2] <- "Country"
colnames(hd)[3] <- "HDI"
colnames(hd)[4] <- "Life.Exp"
colnames(hd)[5] <- "Edu.Exp"
colnames(hd)[6] <- "Edu.Mean"
colnames(hd)[7] <- "GNI"
colnames(hd)[8] <- "GNI.Minus.Rank"



#Re-name columns of gii with shorter variable names
colnames(gii)[1] <- "GII.Rank"
colnames(gii)[2] <- "Country"
colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "Mat.Mor"
colnames(gii)[5] <- "Ado.Birth"
colnames(gii)[6] <- "Parli.F"
colnames(gii)[7] <- "Edu2.F"
colnames(gii)[8] <- "Edu2.M"
colnames(gii)[9] <- "Labo.F"
colnames(gii)[10] <- "Labo.M"

#Mutate the "gii" dataset by adding two new columns (variables)
#secondary education ratio = "edu2ratio" and labour ratio = "labratio"

gii <- mutate(gii, Edu2.FM = Edu2.F/Edu2.M)
gii <- mutate(gii, Labo.FM = Labo.F/Labo.M)

#Join the two datasets

# common columns to use as identifiers
join_by <- c("Country")

# join the two datasets by the selected identifiers
human <- inner_join(hd, gii, by = join_by, suffix = c(".hd", ".gii"))

glimpse(human) #The data should have 195 observations and 19 variables (and it has)

#Save human dataset to the 'data' folder 
setwd('C:/Users/JT/Documents/IODS/IODS-project/data') #Set the working directory

write.table(human, file = "human.txt", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")

#Mutate the data: transform the Gross National Income (GNI) variable to numeric 
GNI_replace <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric
human <- mutate(human, GNI = GNI_replace)


#Exclude unneeded variables: keep only the columns:
#"Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", 
#"Mat.Mor", "Ado.Birth", "Parli.F"

#Columns to keep
keep <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
# select the 'keep' columns
human <- select(human, one_of(keep))


# Filter out all rows with missing (NA) values
human <- filter(human, complete.cases(human))

# Remove the observations which relate to regions instead of countries
# Check the last values (tail)
tail(human,10)

# define the last indice we want to keep
last <- nrow(human) - 7
# choose everything until the last 7 observations (Exclude the regions)
human <- human[1:last,]

# Define the row names of the data by the country names 
rownames(human) <- human$Country
#and remove the country name column from the data. 
human <- select(human, -Country)

# Check the data. It should have 155 observations and 8 variables
str(human)


#Save human dataset to the 'data' folder 

setwd('C:/Users/JT/Documents/IODS/IODS-project/data') #Set the working directory

write.table(human, file = "human.txt", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")