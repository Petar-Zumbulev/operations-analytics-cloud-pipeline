# ============================================================
# Day 02 - dplyr Core Drills
# Project: Operations Analytics & Cloud Data Pipeline Prep
# File: r_drills/day_02_dplyr_core.R
#
# Goal:
# Practice core dplyr verbs using a realistic mini operations dataset:
# - filter()
# - mutate()
# - group_by()
# - summarise()
# - arrange()
# - case_when()
#
# Business context:
# We are analyzing marketplace/e-commerce orders by country,
# channel, customer segment, and product category.
# ============================================================


# ------------------------------------------------------------
# 0. Load packages
# ------------------------------------------------------------

# Run this once if packages are missing:
# install.packages(c("dplyr", "tibble", "lubridate", "readr", "stringr"))

# dplyr is the main package for data manipulation, working with dataframes
# dplyr contains filter() mutate() group_by() summarise()
library(dplyr)
library(tibble)
library(lubridate)
library(readr)
library(stringr)


# ------------------------------------------------------------
# 1. Create folders if needed
# ------------------------------------------------------------

dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)


# ------------------------------------------------------------
# 2. Create a small messy operations dataset
# ------------------------------------------------------------

orders_raw <- tibble(
  order_id = c(
    "O001", "O002", "O003", "O004", "O005",
    "O006", "O007", "O008", "O009", "O010",
    "O011", "O012", "O013", "O014", "O015"
  ),
  customer_id = c(
    "C001", "C002", "C003", "C004", "C002",
    "C005", "C006", "C007", "C008", "C009",
    "C010", "C011", "C012", "C013", "C014"
  ),
  order_date_raw = c(
    "2026-01-03", "03/01/2026", "2026/01/05", "Jan 06 2026", "2026-01-07",
    "08/01/2026", "2026-01-09", "2026/01/10", "Jan 11 2026", "2026-01-12",
    "13/01/2026", "2026-01-14", "2026/01/15", "Jan 16 2026", "2026-01-17"
  ),
  country = c(
    "Germany", "DE", "germany", "France", "FR",
    "Spain", "ES", "Germany", "DE", "France",
    "Germany", "Spain", "DE", "FR", "Germany"
  ),
  customer_segment = c(
    "new", "returning", "new", "new", "returning",
    "new", "returning", "returning", "new", "new",
    "returning", "new", "returning", "new", "returning"
  ),
  sales_channel = c(
    "Paid Search", "paid_search", "Organic", "Email", "Paid Search",
    "Social", "social", "Organic", "Email", "Paid Search",
    "Organic", "Social", "Paid Search", "Email", "Organic"
  ),
  product_category = c(
    "Electronics", "electronics", "Home", "Fashion", "Electronics",
    "Fashion", "Home", "Electronics", "Fashion", "Home",
    "Electronics", "Fashion", "Home", "Electronics", "Fashion"
  ),
  order_status = c(
    "completed", "completed", "returned", "completed", "completed",
    "cancelled", "completed", "completed", "returned", "completed",
    "completed", "completed", "completed", "returned", "completed"
  ),
  gross_sales = c(
    120, 85, 240, 75, 160,
    40, 95, 4500, 60, 130,
    220, 70, 110, 300, 90
  ),
  discount = c(
    10, 0, 20, 5, 15,
    0, 5, 100, 0, 10,
    20, 0, 5, 30, 0
  ),
  shipping_fee = c(
    4.99, 4.99, 6.99, 3.99, 4.99,
    3.99, 4.99, 9.99, 3.99, 6.99,
    4.99, 3.99, 4.99, 6.99, 3.99
  ),
  items_count = c(
    1, 1, 3, 1, 2,
    1, 1, 10, 1, 2,
    2, 1, 1, 4, 1
  ),
  sessions = c(
    20, 15, 30, 12, 18,
    10, 14, 25, 16, 22,
    19, 13, 17, 21, 15
  )
)


# ------------------------------------------------------------
# 3. Inspect raw data
# ------------------------------------------------------------

print("Raw orders data:")
print(orders_raw)

print("Column types:")
glimpse(orders_raw)

# chr for a column data type means character or text
# dbl means double, its a numeric column that can store decimals, its
# like float in python
#
# glimpse() gives an overview of a dataframe/tibble

# checking glimpse() is one of the first things you do in data cleaning
# always do this first when you data cleaning

# glimpse() lets you make sure each column has a data type that you can
# work with later

# ------------------------------------------------------------
# 4. Clean and enrich the data with mutate()
# ------------------------------------------------------------

orders_clean <- orders_raw %>%
  mutate(
    # Parse messy date formats into a proper date column
    # mutate() is for creating business/analysis variables
    order_date = as_date(parse_date_time(
      
      # this tells us to use the column order_date_raw for the parsing
      order_date_raw,
      
      # this is an argument passed into the function parse_date_time()
      # it is an argument structured like a column, and it tells R that 
      # the dates could be in a few different formats
      orders = c("ymd", "dmy", "Y/m/d", "b d Y")
    )),
    
    # Standardize country values
    # thanks to mutate() we add the column country_clean with this command
    # case_when() means if the condition is true, then add/return this given value
    # which is Germany, or France, or Spain, or Other
    # and we do str_to_lower before that for any values in the column country
    # so that its easy for us to go through them and categorize them
    # this works for this simple example with 13 rows, but if I had a big dataset
    # with 2 million rows, I would check all the unique values first in the 
    # column country, and then include them all in my case_when() 
    country_clean = case_when(
      str_to_lower(country) %in% c("germany", "de") ~ "Germany",
      str_to_lower(country) %in% c("france", "fr") ~ "France",
      str_to_lower(country) %in% c("spain", "es") ~ "Spain",
      TRUE ~ "Other"
    ),
    
    # Standardize sales channels
    # same idea, replacing values with case_when()
    sales_channel_clean = case_when(
      str_to_lower(sales_channel) %in% c("paid search", "paid_search") ~ "Paid Search",
      str_to_lower(sales_channel) == "organic" ~ "Organic",
      str_to_lower(sales_channel) == "email" ~ "Email",
      str_to_lower(sales_channel) == "social" ~ "Social",
      TRUE ~ "Other"
    ),
    
    # Standardize product category
    # str_to_title() converts text so that the first letter of each word is uppercase
    product_category_clean = str_to_title(product_category),
    
    # Business metrics
    net_revenue = gross_sales - discount,
    order_value_with_shipping = net_revenue + shipping_fee,
    revenue_per_item = net_revenue / items_count,
    
    # Boolean / flag variables
    # the creation of boolean columns is something I did not think about
    # but it is relavant and useful for further analysis
    is_completed = order_status == "completed",
    is_returned = order_status == "returned",
    is_cancelled = order_status == "cancelled",
    
    # Simple outlier flag
    is_high_value_order = net_revenue > 1000,
    
    # Customer type label
    customer_type = case_when(
      customer_segment == "new" ~ "New customer",
      customer_segment == "returning" ~ "Returning customer",
      TRUE ~ "Unknown"
    )
  )


print("Cleaned and enriched orders data:")
print(orders_clean)


# ------------------------------------------------------------
# 5. filter(): keep only completed orders
# ------------------------------------------------------------

completed_orders <- orders_clean %>%
  filter(is_completed == TRUE)

print("Completed orders only:")
print(completed_orders)


# ------------------------------------------------------------
# 6. arrange(): sort orders by highest net revenue
# ------------------------------------------------------------

top_orders <- completed_orders %>%
  arrange(desc(net_revenue))

print("Completed orders sorted by net revenue:")
print(top_orders)


# ------------------------------------------------------------
# 7. summarise(): total KPI summary
# ------------------------------------------------------------

total_kpi_summary <- orders_clean %>%
  summarise(
    total_orders = n(),
    completed_orders = sum(is_completed),
    returned_orders = sum(is_returned),
    cancelled_orders = sum(is_cancelled),
    total_gross_sales = sum(gross_sales),
    total_discount = sum(discount),
    total_net_revenue = sum(net_revenue),
    average_order_value = mean(net_revenue),
    median_order_value = median(net_revenue),
    return_rate = mean(is_returned),
    cancellation_rate = mean(is_cancelled)
  )

print("Total KPI summary:")
print(total_kpi_summary)


# ------------------------------------------------------------
# 8. group_by() + summarise(): KPIs by country
# ------------------------------------------------------------

country_kpis <- orders_clean %>%
  group_by(country_clean) %>%
  summarise(
    orders = n(),
    completed_orders = sum(is_completed),
    returned_orders = sum(is_returned),
    total_net_revenue = sum(net_revenue),
    average_order_value = mean(net_revenue),
    return_rate = mean(is_returned),
    .groups = "drop"
  ) %>%
  arrange(desc(total_net_revenue))

print("KPIs by country:")
print(country_kpis)


# ------------------------------------------------------------
# 9. group_by() + summarise(): KPIs by sales channel
# ------------------------------------------------------------

channel_kpis <- orders_clean %>%
  group_by(sales_channel_clean) %>%
  summarise(
    orders = n(),
    completed_orders = sum(is_completed),
    total_net_revenue = sum(net_revenue),
    average_order_value = mean(net_revenue),
    total_sessions = sum(sessions),
    conversion_rate = completed_orders / total_sessions,
    .groups = "drop"
  ) %>%
  arrange(desc(total_net_revenue))

print("KPIs by sales channel:")
print(channel_kpis)


# ------------------------------------------------------------
# 10. group_by() + summarise(): KPIs by product category
# ------------------------------------------------------------

category_kpis <- orders_clean %>%
  group_by(product_category_clean) %>%
  summarise(
    orders = n(),
    completed_orders = sum(is_completed),
    returned_orders = sum(is_returned),
    total_net_revenue = sum(net_revenue),
    total_items_sold = sum(items_count),
    average_revenue_per_item = mean(revenue_per_item),
    return_rate = mean(is_returned),
    .groups = "drop"
  ) %>%
  arrange(desc(total_net_revenue))

print("KPIs by product category:")
print(category_kpis)


# ------------------------------------------------------------
# 11. More realistic business filter:
#     completed Germany orders above 100 EUR
# ------------------------------------------------------------

germany_high_value_completed <- orders_clean %>%
  filter(
    country_clean == "Germany",
    is_completed == TRUE,
    net_revenue > 100
  ) %>%
  arrange(desc(net_revenue))

print("Germany completed orders above 100 EUR:")
print(germany_high_value_completed)


# ------------------------------------------------------------
# 12. Basic data quality checks
# ------------------------------------------------------------

data_quality_summary <- orders_clean %>%
  summarise(
    rows = n(),
    unique_orders = n_distinct(order_id),
    missing_order_dates = sum(is.na(order_date)),
    missing_countries = sum(is.na(country_clean)),
    negative_revenue_orders = sum(net_revenue < 0),
    high_value_orders = sum(is_high_value_order)
  )

print("Data quality summary:")
print(data_quality_summary)


# ------------------------------------------------------------
# 13. Write outputs
# ------------------------------------------------------------

write_csv(total_kpi_summary, "outputs/tables/day_02_total_kpi_summary_r.csv")
write_csv(country_kpis, "outputs/tables/day_02_country_kpis_r.csv")
write_csv(channel_kpis, "outputs/tables/day_02_channel_kpis_r.csv")
write_csv(category_kpis, "outputs/tables/day_02_category_kpis_r.csv")
write_csv(data_quality_summary, "outputs/tables/day_02_data_quality_summary_r.csv")


# ------------------------------------------------------------
# 14. Practice questions
# ------------------------------------------------------------

# After running the script, answer these in notes/notes_day_02.md:
#
# 1. Which country generated the highest total net revenue?
# 2. Which sales channel had the highest total net revenue?
# 3. Which product category had the highest return rate?
# 4. What does average_order_value mean in this dataset?
# 5. Why is the 4500 gross_sales order suspicious?
# 6. What is the difference between gross_sales and net_revenue?
# 7. Why do we clean "DE", "Germany", and "germany" into one value?
# 8. Why should cancelled and returned orders be treated carefully in KPI reporting?
#
# Optional challenge:
# Create a new summary table that groups by both:
# - country_clean
# - sales_channel_clean
#
# Then calculate:
# - orders
# - completed_orders
# - total_net_revenue
# - average_order_value


print("Day 02 dplyr core drills complete.")