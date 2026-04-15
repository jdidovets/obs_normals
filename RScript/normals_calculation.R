# Script analyses observed river discharge and calculates "normals" for a given year

### input data
workdir <- getwd()  # Use current working directory, or set explicitly

start_ref <-1991       # first reference year
end_ref <-2020         # last reference year
eval_year <-2025       # evaluation year

sel_percentile<-c(0.1,0.25, 0.75, 0.9)  # percentiles

### end input data

# Ensure necessary packages are installed and loaded
required_packages <- c("dplyr", "lubridate", "rlang", "scales")

# Install and load the required packages
sapply(required_packages, function(pkg) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg)
  }
  library(pkg, character.only = TRUE)
})



setwd(workdir)
input_files<- list.files("input")
tab_all_stations<-data.frame()


# read the data

for (input_file in input_files){

  # Wrap entire file processing in tryCatch for error handling
  tryCatch({
    print(paste("Process file: ", input_file))

    input_data<-read.table(file.path("input", input_file), sep = ",", header = T)  # read data
    colnames(input_data)<-c("date", "discharge") # rename columns
    input_data$date <- parse_date_time(input_data$date, orders = c("ymd", "dmy", "mdy"),
                                      truncated = 3,
                                      tz = "UTC")   #convert column to date format

    # create year and month columns and check the discharge data for NA
    data<-input_data %>% mutate(year= year(date),
                                 month = month(date)) %>%
      mutate(discharge = as.numeric(as.character(discharge)),
             discharge = ifelse(is.na(discharge) & !is.na(as.character(discharge)), NA, discharge))

    # subtract periods
    reference_sel<-data %>% dplyr::filter(year >= start_ref & year <= end_ref)   # select the reference period

    # check the number of years
    check_years <- function(data, year_col) {
       num_years <- data %>%
        filter(!is.na(discharge)) %>%
        summarise(n_years = n_distinct(!!sym(year_col))) %>%
        pull(n_years)
       if (num_years < 20) {
        stop("Warning: The number of unique years in the reference period is ", num_years," (<20).")
      } else {
        message("The number of unique years is ", num_years, " (>20). Good!")
      }
        return(num_years)
    }
    num_years <- check_years(reference_sel, "year")


    # check number of observations in evaluation year
    target_year_sel<-data %>% dplyr::filter(year == eval_year)         # select evaluation year

    check_eval_year <- function(df) {
      num_observations <- df %>%
        filter(!is.na(discharge)) %>%
        summarise(n_obs = n()) %>%
        pull(n_obs)

      # Check if the number of observations is less than 345
      if (num_observations < 345) {
        stop("Error: The number of observations in ", eval_year, " is ", num_observations, " (<345).")
      } else {
        message("The number of observations in ", eval_year, " is ", num_observations, " (>345). Good!")
      }
      return(invisible(num_observations))
    }

    check_eval_year(target_year_sel)


    # Helper function to calculate percentiles and classify a value
    classify_value <- function(target_val, reference_vals) {
      case_when(
        target_val >= reference_vals[2] & target_val <= reference_vals[3] ~ 'normal',
        target_val <= reference_vals[1] ~ 'much below',
        target_val > reference_vals[1] & target_val < reference_vals[2] ~ 'below',
        target_val > reference_vals[3] & target_val < reference_vals[4] ~ 'above',
        target_val >= reference_vals[4] ~ 'much above'
      )
    }

    # ===== ANNUAL CALCULATION =====
    # calculate percentile for the reference period (annual)
    reference_annual <- reference_sel %>%
      group_by(year) %>%
      dplyr::summarize(mean = mean(discharge, na.rm = T)) %>%
      ungroup() %>%
      summarise(across(mean, list(
        p10 = ~round(quantile(., 0.1, na.rm = T), 2),
        p25 = ~round(quantile(., 0.25, na.rm = T), 2),
        p75 = ~round(quantile(., 0.75, na.rm = T), 2),
        p90 = ~round(quantile(., 0.9, na.rm = T), 2)
      )))

    ref_vals_annual <- c(reference_annual$mean_p10, reference_annual$mean_p25,
                          reference_annual$mean_p75, reference_annual$mean_p90)

    # calculate the annual mean for target year
    target_annual <- target_year_sel %>%
      summarise(value = round(mean(discharge, na.rm = T), 2)) %>%
      mutate(state = classify_value(value, ref_vals_annual),
             period = "Annual")

    # ===== MONTHLY CALCULATION =====
    # calculate percentiles for each month in reference period
    reference_monthly <- reference_sel %>%
      group_by(month, year) %>%
      dplyr::summarize(mean = mean(discharge, na.rm = T), .groups = 'drop') %>%
      group_by(month) %>%
      summarise(across(mean, list(
        p10 = ~round(quantile(., 0.1, na.rm = T), 2),
        p25 = ~round(quantile(., 0.25, na.rm = T), 2),
        p75 = ~round(quantile(., 0.75, na.rm = T), 2),
        p90 = ~round(quantile(., 0.9, na.rm = T), 2)
      ), .names = "{.fn}"), .groups = 'drop')

    # calculate monthly means for target year
    target_monthly <- target_year_sel %>%
      group_by(month) %>%
      summarise(value = round(mean(discharge, na.rm = T), 2), .groups = 'drop') %>%
      left_join(reference_monthly, by = "month") %>%
      rowwise() %>%
      mutate(
        state = classify_value(value, c(p10, p25, p75, p90)),
        period = month.abb[month]
      ) %>%
      ungroup() %>%
      select(month, period, value, state, p10, p25, p75, p90)

    # Combine annual and monthly results
    results_out <- bind_rows(
      target_annual %>%
        mutate(p10 = ref_vals_annual[1], p25 = ref_vals_annual[2],
               p75 = ref_vals_annual[3], p90 = ref_vals_annual[4]) %>%
        select(period, value, state, p10, p25, p75, p90),
      target_monthly %>%
        select(period, value, state, p10, p25, p75, p90)
    ) %>%
      mutate(filename = input_file) %>%
      select(filename, period, value, state, p10, p25, p75, p90)

    tab_all_stations<-rbind(tab_all_stations, results_out)

  },
  error = function(e) {
    # This runs if any error occurs in the block above
    print(paste("ERROR processing file", input_file, ":", e$message))
    print("Skipping this file and continuing with the next one...")
  })

}

# Write output once after processing all files
write.csv(tab_all_stations, file.path("output", "normals.csv"), row.names = FALSE, quote = FALSE)

print(tab_all_stations)

