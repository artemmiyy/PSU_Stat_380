library(dplyr)
library(stringr)
library(tidyr)
library(fastDummies)

house_data <- read.csv("/Users/artemmiyy/Desktop/Stat380/Homework/House_Price_Null_Model/volume/data/raw/Stat_380_housedata.csv")

QC_data <- read.csv("/Users/artemmiyy/Desktop/Stat380/Homework/House_Price_Null_Model/volume/data/raw/Stat_380_QC_table.csv")

complete_house_data <- left_join(house_data, QC_data, by = join_by(qc_code == qc_code))

# separate quality and condition
qual_string <- c("10B" = "10_B", "4B" = "4_B",
                 "5B" = "5_B", "6B" = "6_B",
                 "7B" = "7_B", "8B" = "8_B",
                 "9B" = "9_B", "3A" = "3_A",
                 "1A" = "1_A", "2A" = "2_A")

cond_string <- c("6B" = "6_B", "5B" = "5_B",
                 "3A" = "3_A", "8B" = "8_B",
                 "4B" = "4_B", "7B" = "7_B",
                 "9B" = "9_B", "1A" = "1_A",
                 "2A" = "2_A")

# replacing qual and cond for separation into categories
complete_house_data$Qual <- str_replace_all(complete_house_data$Qual, qual_string)
complete_house_data$Cond <- str_replace_all(complete_house_data$Qual, cond_string)

complete_house_data[c('qual_num', 'qual_letter')] <- str_split_fixed(complete_house_data$Qual, '_', 2)
complete_house_data[c('cond_num', 'cond_letter')] <- str_split_fixed(complete_house_data$Cond, '_', 2)
  

# dummy cols for BldgType, Heating, PoolArea
complete_house_data <- dummy_cols(complete_house_data, select_columns = c('BldgType',
                                                                 'qual_num', 'qual_letter',
                                                                 'cond_num', 'cond_letter'))

# Make CentralAir a binary
complete_house_data <-
  complete_house_data %>%
  mutate(CentralAir = ifelse(CentralAir == 'Y', 1, 0))

complete_house_data

# separating the data frames into training data and testing data
# testing data doesn't have sale price
training_house_data <- complete_house_data[!grepl("test", complete_house_data$Id),]
testing_house_data <- complete_house_data[!grepl("train", complete_house_data$Id),]

training_house_data <-
  subset(training_house_data, select = c('BldgType_1Fam', 'BldgType_2fmCon',
                                         'BldgType_Duplex', 'BldgType_Twnhs',
                                         'BldgType_TwnhsE',
                                         'SalePrice', 'GrLivArea',
                                         'CentralAir', 'TotRmsAbvGrd',
                                         'YearBuilt', 'TotalBsmtSF',
                                         "qual_num_1", "qual_num_2",
                                         "qual_num_3", "qual_num_4",
                                         "qual_num_5", "qual_num_6",
                                         "qual_num_7", "qual_num_8",
                                         "qual_num_9", "qual_num_10",
                                         "qual_letter_A", "qual_letter_B",
                                         "cond_num_1", "cond_num_2",
                                         "cond_num_3", "cond_num_4",
                                         "cond_num_5", "cond_num_6",
                                         "cond_num_7", "cond_num_8",
                                         "cond_num_9", "cond_num_10",
                                         "cond_letter_A", "cond_letter_B"
                                         ))
testing_house_data <- 
  subset(testing_house_data, select = c('BldgType_1Fam', 'BldgType_2fmCon',
                                         'BldgType_Duplex', 'BldgType_Twnhs',
                                         'BldgType_TwnhsE',
                                         'GrLivArea',
                                         'CentralAir', 'TotRmsAbvGrd',
                                         'YearBuilt', 'TotalBsmtSF', 
                                         "qual_num_1", "qual_num_2",
                                         "qual_num_3", "qual_num_4",
                                         "qual_num_5", "qual_num_6",
                                         "qual_num_7", "qual_num_8",
                                         "qual_num_9", "qual_num_10",
                                         "qual_letter_A", "qual_letter_B",
                                         "cond_num_1", "cond_num_2",
                                         "cond_num_3", "cond_num_4",
                                         "cond_num_5", "cond_num_6",
                                         "cond_num_7", "cond_num_8",
                                         "cond_num_9", "cond_num_10",
                                         "cond_letter_A", "cond_letter_B",
                                         'Id'))


write.csv(complete_house_data, "/Users/artemmiyy/Desktop/Stat380/Homework/House_Price_Null_Model/volume/data/interim/complete_house_data.csv", row.names=FALSE)
write.csv(training_house_data, "/Users/artemmiyy/Desktop/Stat380/Homework/House_Price_Null_Model/volume/data/processed/training_house_data.csv", row.names=FALSE)
write.csv(testing_house_data, "/Users/artemmiyy/Desktop/Stat380/Homework/House_Price_Null_Model/volume/data/processed/testing_house_data.csv", row.names=FALSE)