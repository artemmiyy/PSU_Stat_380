library(dplyr)

house_data <- read.csv("./Stat380/Homework/House_Price_Null_Model/volume/data/raw/Stat_380_housedata.csv")

QC_data <- read.csv("./Stat380/Homework/House_Price_Null_Model/volume/data/raw/Stat_380_QC_table.csv")

complete_house_data <- left_join(house_data, QC_data, by = join_by(qc_code == qc_code))

write.csv(complete_house_data, "./Stat380/Homework/House_Price_Null_Model/volume/data/interim/complete_house_data.csv", row.names=FALSE)

training_house_data <- complete_house_data[!grepl("test", complete_house_data$Id),]
testing_house_data <- complete_house_data[!grepl("train", complete_house_data$Id),]

write.csv(training_house_data, "./Stat380/Homework/House_Price_Null_Model/volume/data/processed/training_house_data.csv", row.names=FALSE)

write.csv(testing_house_data, "./Stat380/Homework/House_Price_Null_Model/volume/data/processed/testing_house_data.csv", row.names=FALSE)