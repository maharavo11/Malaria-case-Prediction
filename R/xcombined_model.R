
#Taking best model for each district.
best_models_diarrhea <- ifelse(rmse_list_knn > rmse_list_xgb, "xgb", "knn")
best_models_malaria <- ifelse(rmse_list_knn > rmse_list_xgb, "xgb", "knn")

## Function predicting based on the best models.
infer <- function(trainset,testset,best_models,disease,excluded,params){
  
  predictions <- c()
  districts <- 1:159
  for (dist in districts){
    district_data <- trainset %>% filter(district == dist)
    district_test <- testset %>% filter(district == dist)
    X_train <- district_data %>% select(-malaria_cases_u5,-diarr_cases_u5, -district)
    X_test <- district_test %>% select(-malaria_cases_u5,-diarr_cases_u5, -district)  
    
    if (disease=="diarrhea"){
      y_train <- district_data$diarr_cases_u5
    }else {
      y_train <- district_data$malaria_cases_u5
    }
    
    if (best_models[dist]=="knn"){
       
       X_train <- X_train %>% select(-all_of(excluded))
       X_test <- X_test %>% select(-all_of(excluded))
       y_pred <- knn.reg(train = X_train, test = X_test, y = y_train, k = 5)$pred
       predictions <- append(predictions,list(y_pred))
       
      
    } else {
   
      train_matrix <- xgb.DMatrix(data = as.matrix(X_train), label = y_train)
      test_matrix <- xgb.DMatrix(data = as.matrix(X_test))
   
      xgb_model <- xgb.train(params, train_matrix, nrounds = 100)

      y_pred <- predict(xgb_model, test_matrix)
  
      predictions <- append(predictions,list(y_pred))
   
    }
  }
  
  return(predictions)
  
}
