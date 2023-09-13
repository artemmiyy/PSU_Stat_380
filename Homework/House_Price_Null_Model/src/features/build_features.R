library(dplyr)

house_data <- read.csv("/Users/artemmiyy/Desktop/Stat380/Homework/House_Price_Null_Model/volume/data/raw/Stat_380_housedata.csv")

QC_data <- read.csv("/Users/artemmiyy/Desktop/Stat380/Homework/House_Price_Null_Model/volume/data/raw/Stat_380_QC_table.csv")

complete_house_data <- left_join(house_data, QC_data, by = join_by(qc_code == qc_code))

# replacing categorical values by numbers for multiple regression
complete_house_data[complete_house_data == '1Fam'] <- 1
complete_house_data[complete_house_data == 'TwnhsE'] <- 2
complete_house_data[complete_house_data == 'Duplex'] <- 3
complete_house_data[complete_house_data == 'Twnhs'] <- 4
complete_house_data[complete_house_data == '2fmCon'] <- 5

# separating the data frames into training data and testing data
# testing data doesn't have sale price
training_house_data <- complete_house_data[!grepl("test", complete_house_data$Id),]
testing_house_data <- complete_house_data[!grepl("train", complete_house_data$Id),]


write.csv(complete_house_data, "/Users/artemmiyy/Desktop/Stat380/Homework/House_Price_Null_Model/volume/data/interim/complete_house_data.csv", row.names=FALSE)
write.csv(training_house_data, "/Users/artemmiyy/Desktop/Stat380/Homework/House_Price_Null_Model/volume/data/processed/training_house_data.csv", row.names=FALSE)
write.csv(testing_house_data, "/Users/artemmiyy/Desktop/Stat380/Homework/House_Price_Null_Model/volume/data/processed/testing_house_data.csv", row.names=FALSE)