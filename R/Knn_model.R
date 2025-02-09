#selecting feature important for the model.
knn_trainset_malaria <- trainset_malaria %>% select(-c("prop_Number_of_children_3plus",
                                                       "prop_with_3Plus_mosquito_nets",
                                                       "prop_some_or_all_children_slept_under_net_last_night"
                                                       ,"prop_floor_Material_natural
                                                       ","prop_Has_Electricity",
                                                       "prop_Time_get_Water60_plus_min"))
districts <- unique(trainset_malaria$district)

## KNN model
district_predictions <- c()
rmse_list_knn <- c()
r2_list_knn <- c()

for (dist in districts) {
  district_data <- knn_trainset_malaria %>% filter(district == dist)
  
  # select train and validation 
  train_data <- district_data %>% filter(year < 2018 | (year == 2018 & month <= 2))
  val_data <- district_data %>%  filter(year > 2018 | (year == 2018 & month >= 7))
 
  X_train <- train_data %>% select(-malaria_cases_u5,-diarr_cases_u5, -district)  
  y_train <- train_data$malaria_cases_u5
  X_val <- val_data %>% select(-malaria_cases_u5,-diarr_cases_u5, -district)
  y_val <- val_data$malaria_cases_u5

  y_pred <- knn.reg(train = X_train, test = X_val, y = y_train, k = 5)$pred

  #metrics evaluation.
  rmse <- sqrt(mean((y_pred - y_val)^2))
  rss <- sum((y_pred - y_val)^2)
  tss <- sum((y_val - mean(y_val))^2)
  r_2 <- 1 - (rss / tss)
  r2_list_knn <- c(r2_list_knn,r_2)
  rmse_list_knn <- c(rmse_list_knn,rmse)
  district_predictions <- c(district_predictions,y_pred)
}


