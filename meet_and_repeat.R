#Author: Juuso Tuure, 2.12.2020
#Data wrangling script for IODS course, Exercise 6
#The data used is available online in the following two sources:
#https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
#https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt

# Access the packages dplyr and tidyr
library(dplyr)
library(tidyr)


#Download data, with a comma separator between columns:
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", 
                    sep = "",
                    header = TRUE
)

RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", 
                   sep = "\t",
                   header = TRUE
)

#check variable names
names(BPRS)
names(RATS)

#view the data contents and structures 
BPRS
RATS

str(BPRS)
str(RATS)


#brief summaries of the variables 
summary(BPRS)
summary(RATS)




#Factor the categorial variables

# Factor the variables ID and Group for RATS
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)


# Factor treatment and subject variables fot BPRS
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)


# Convert the datasets to long form. Add a week variable to BPRS and a Time variable to RATS.
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject) %>%
  mutate(week = as.integer(substr(weeks,5,6)))
 

RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,5))) 


# View the long forms of the data:

#RATS dataset
names(RATSL) # check the variable names
str(RATSL) # view the structure
summary(RATSL) #brief summary of variables
RATSL # view the dat

#BPRS dataset
names(BPRSL) # check the variable names
str(BPRSL) # view the structure
summary(BPRSL) # brief summary of variables
BPRSL #  the data


#Save datasets to the 'data' folder 

setwd('C:/Users/JT/Documents/IODS/IODS-project/data') #Set the working directory

write.table(BPRSL, file = "BPRSL.txt", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")

write.table(RATSL, file = "RATSL.txt", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")


