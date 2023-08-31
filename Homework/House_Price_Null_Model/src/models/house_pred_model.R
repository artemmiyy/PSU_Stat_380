library(dplyr)

train <- read.csv("/Users/artemmiyy/Documents/GitHub/Stat380_Kaggle/House_Price_Null_Model/volume/data/processed/training_house_data.csv")

test <- read.csv("/Users/artemmiyy/Documents/GitHub/Stat380_Kaggle/House_Price_Null_Model/volume/data/processed/testing_house_data.csv")

test$num_id <- NA

for(i in 1:nrow(test)) {
  # select rows from training data set with matching values
  similar_properties <- train[train$qc_code == test[i, ]$qc_code & train$BldgType == test[i, ]$BldgType
                              & train$TotRmsAbvGrd == test[i, ]$TotRmsAbvGrd 
                              & (train$GrLivArea >= (test[i, ]$GrLivArea - 200) & train$GrLivArea <= (test[i, ]$GrLivArea + 200))
                              & train$Qual == test[i, ]$Qual & train$Cond == test[i, ]$Cond, ]
  avg_price <- mean(similar_properties$SalePrice)
  
  test[i, ]$SalePrice <- avg_price
  test[i, ]$num_id <- as.numeric(gsub("test_", '', test[i, ]$Id))
}

# sorting and tweaking the submission file to fit
kaggle_submission <- select(test, Id, SalePrice, num_id)
kaggle_submission <- kaggle_submission[order(kaggle_submission$num_id),]
kaggle_submission <- select(kaggle_submission, Id, SalePrice)
kaggle_submission[is.na(kaggle_submission)] <- mean(train$SalePrice)

write.csv(kaggle_submission, "/Users/artemmiyy/Documents/GitHub/Stat380_Kaggle/House_Price_Null_Model/volume/data/interim/artemm1yy_submission.csv", row.names=FALSE)