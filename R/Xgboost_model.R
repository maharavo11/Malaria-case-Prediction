## Xgboost model by district.

#Parameter of the model
params <- params <- list(
  objective = "reg:squarederror",  # Regression task
  max_depth = 6, # Maximum depth of trees
  eta = 0.2, # Learning rate
  eval_metric = "rmse"
)

#Running loop by district.
districts <- unique(trainset_malaria$district)
district_predictions <- c() #stock the rmse in the validation for each district.
rmse_list_xgb <- c()
r2_list_xgb <- c()

for (dist in districts) {

  district_data <- trainset_malaria %>% filter(district == dist)
 
  # Split the data into training and validation sets based on the date (before March 2018 for training, after June 2018 for validation)
  train_data <- district_data %>% filter(year < 2018 | (year == 2018 & month <= 2))
  val_data <- district_data %>%  filter(year > 2018 | (year == 2018 & month >= 7))
 
  X_train <- train_data %>% select(-malaria_cases_u5, -diarr_cases_u5, -district)  
  y_train <- train_data$malaria_cases_u5
 
  X_val <- val_data %>% select(-malaria_cases_u5,-diarr_cases_u5, -district)
  y_val <- val_data$malaria_cases_u5

  train_matrix<- xgb.DMatrix(data = as.matrix(X_train), label = y_train)
  val_matrix <- xgb.DMatrix(data = as.matrix(X_val), label = y_val)
  
  xgb_model <- xgb.train(params, train_matrix, nrounds = 100)
 
  y_pred <- predict(xgb_model, val_matrix)

  # metrics computation
  rmse <- sqrt(mean((y_pred - y_val)^2))
  rss <- sum((y_pred - y_val)^2)
  tss <- sum((y_val - mean(y_val))^2)
  r_2 <- 1 - (rss / tss)
  r2_list_xgb <- c(r2_list_xgb,r_2)
  rmse_list_xgb <- c(rmse_list_xgb,rmse)
  district_predictions <- c(district_predictions,y_pred)
}
