#Loading the data.
data <- readRDS(here("Mozambique data_tutorial_STUDENTS_revised.rds"))

# Convert SpatialPolygonsDataFrame to sf.
moz_shapefile_sf <- st_as_sf(data$moz_shapefile)

# Ungroup the grouped data.
analysis_data <- data$analysis_data %>%
  ungroup()

#taking off unimportant feature.
analysis_data <- analysis_data %>% select(-c("district_SPH","Name_of_healthcare_facility1"
                                             ,"ADM1_PT", "ADM2_PT", "ADM2_PCODE", "ID"))

#split the train and the test to predict.
trainset_malaria <- analysis_data %>% filter(!is.na(malaria_cases_u5)) 
trainset_diarrhea <- analysis_data %>% filter(!is.na(diarr_cases_u5))
test_set_malaria <- analysis_data %>% filter(is.na(malaria_cases_u5))
test_set_diarrhea <- analysis_data %>% filter(is.na(diarr_cases_u5))
