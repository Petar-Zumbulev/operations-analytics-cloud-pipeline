# ============================================================
# Day 3 - Joins, Pivoting, ggplot2, and Join Quality Thinking
#
# Project: Operations Analytics & Cloud Data Pipeline Prep
# File: r_drills/day_03_joins_ggplot.R
# ============================================================

library(tidyverse)
library(lubridate)

# ------------------------------------------------------------
# 0. Create output folders
# ------------------------------------------------------------

dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

# ------------------------------------------------------------
# 1. Create small synthetic marketplace tables
# ------------------------------------------------------------
# Important idea:
# Each table has a "grain".
#
# this is the idea of granularity
#
# customers_raw: one row should be one customer
# orders: one row should be one order
# order_items: one row should be the products/items inside one order
# products_raw: one row should be one product
#
# We intentionally include a few messy problems:
# - duplicate customer C003
# - duplicate product P004
# - order with unknown customer C999
# - order item with unknown product P999

customers_raw <- tibble(
  customer_id = c("C001", "C002", "C003", "C003", "C004", "C005"),
  country = c("Germany", "Germany", "France", "France", "Spain", "Germany"),
  segment = c("New", "Returning", "VIP", "VIP", "New", "Returning"),
  signup_date = as.Date(c(
    "2026-01-05",
    "2026-01-10",
    "2026-01-12",
    "2026-01-12",
    "2026-02-01",
    "2026-02-07"
  ))
)

# granularity: every row here represents a single order. Keep this granularity 
# later with joins
orders <- tibble(
  order_id = c("O001", "O002", "O003", "O004", "O005", "O006", "O007", "O008"),
  customer_id = c("C001", "C002", "C003", "C004", "C005", "C999", "C002", "C003"),
  order_date = as.Date(c(
    "2026-03-01",
    "2026-03-01",
    "2026-03-02",
    "2026-03-03",
    "2026-03-04",
    "2026-03-04",
    "2026-03-05",
    "2026-03-06"
  )),
  sales_channel = c(
    "Paid Search",
    "Organic",
    "Email",
    "Paid Search",
    "Social",
    "Organic",
    "Email",
    "Social"
  )
)

# one row here is the products/items within a certain order, so one row shows
# the amount of products/items within a given order. Thats why we have the 
# column quantity
order_items <- tibble(
  order_id = c("O001", "O001", "O002", "O003", "O004", "O005", "O006", "O007", "O008", "O008"),
  product_id = c("P001", "P002", "P001", "P003", "P004", "P002", "P001", "P999", "P003", "P004"),
  quantity = c(1, 2, 1, 3, 1, 2, 1, 1, 1, 2),
  unit_price = c(49.99, 19.99, 49.99, 12.50, 89.99, 19.99, 49.99, 39.99, 12.50, 89.99)
)

products_raw <- tibble(
  product_id = c("P001", "P002", "P003", "P004", "P004"),
  category = c("Electronics", "Home", "Beauty", "Sports", "Sports"),
  brand = c("BrandA", "BrandB", "BrandC", "BrandD", "BrandD")
)

# one row represents the marketing budget for a given month
marketing_wide <- tibble(
  month = c("2026-01", "2026-02", "2026-03"),
  paid_search_spend = c(2000, 2400, 2600),
  social_spend = c(1200, 1300, 1500),
  email_spend = c(300, 350, 400)
)

# ------------------------------------------------------------
# 2. Inspect tables
# ------------------------------------------------------------

glimpse(customers_raw)
glimpse(orders)
glimpse(order_items)
glimpse(products_raw)
glimpse(marketing_wide)

# ------------------------------------------------------------
# 3. Join quality check 1: duplicate keys
# ------------------------------------------------------------
# Before joining, check whether the right-side table has duplicate keys.
#
# Why?
# If the right table has duplicate keys, a left_join can multiply rows.
# Example: if customer C003 appears twice in customers, then every order
# from C003 can appear twice after the join.

duplicate_customers <- customers_raw %>%
  count(customer_id) %>%
  filter(n > 1)

duplicate_products <- products_raw %>%
  count(product_id) %>%
  filter(n > 1)

duplicate_customers
duplicate_products

# Save duplicate reports
write_csv(duplicate_customers, "outputs/tables/day_03_duplicate_customers.csv")
write_csv(duplicate_products, "outputs/tables/day_03_duplicate_products.csv")

# ------------------------------------------------------------
# 4. Join quality check 2: unmatched IDs
# ------------------------------------------------------------
# anti_join() returns rows from the left table that DO NOT have a match
# in the right table.
#
# This is extremely useful for data quality checks.

orders_with_unknown_customers <- orders %>%
  anti_join(customers_raw %>% distinct(customer_id), by = "customer_id")

items_with_unknown_products <- order_items %>%
  anti_join(products_raw %>% distinct(product_id), by = "product_id")

orders_with_unknown_customers
items_with_unknown_products

# Save unmatched reports
write_csv(orders_with_unknown_customers, "outputs/tables/day_03_orders_unknown_customers.csv")
write_csv(items_with_unknown_products, "outputs/tables/day_03_items_unknown_products.csv")

# ------------------------------------------------------------
# 5. Create clean dimension tables before joining
# ------------------------------------------------------------
# For today, we fix duplicate dimension rows by keeping the first row.
#
# Later in the project, we will be stricter:
# - identical duplicates can be removed
# - conflicting duplicates should be quarantined
# - duplicate logic should be logged

customers_dim <- customers_raw %>%
  distinct(customer_id, .keep_all = TRUE)

products_dim <- products_raw %>%
  distinct(product_id, .keep_all = TRUE)

customers_dim
products_dim

# ------------------------------------------------------------
# 6. Safe left_join: orders + customers
# ------------------------------------------------------------
# left_join keeps all rows from the left table.
# Here, the left table is orders.
#
# Meaning:
# Keep every order, and add customer columns when the customer_id matches.

orders_before_join_rows <- nrow(orders)

orders_enriched <- orders %>%
  left_join(customers_dim, by = "customer_id")

orders_after_join_rows <- nrow(orders_enriched)

orders_before_join_rows
orders_after_join_rows

# Row count should stay the same here because:
# - orders is one row per order
# - customers_dim is one row per customer
#
# If rows increase, the join probably multiplied rows because the right table
# had duplicate keys.

orders_enriched

# ------------------------------------------------------------
# 7. Add revenue at order-item level
# ------------------------------------------------------------
# order_items is more detailed than orders.
#
# order_items grain:
# one row = one product inside one order
#
# We calculate line_revenue at the order-item level.

order_items_revenue <- order_items %>%
  mutate(line_revenue = quantity * unit_price)

order_items_revenue

# ------------------------------------------------------------
# 8. Join order items to products and orders
# ------------------------------------------------------------
# This creates an enriched order-item table.
#
# Grain after this join:
# still one row per order item.
#
# Important:
# Joining product/category/customer data does not change the grain if the
# dimension tables have one row per key.

order_items_enriched <- order_items_revenue %>%
  left_join(products_dim, by = "product_id") %>%
  left_join(orders_enriched, by = "order_id")

order_items_enriched

# Check row count
nrow(order_items_revenue)
nrow(order_items_enriched)

# ------------------------------------------------------------
# 9. Create KPI table by customer segment
# ------------------------------------------------------------
# We calculate GMV/revenue by segment.
#
# GMV here means:
# total transaction value = sum(quantity * unit_price)
#
# We remove missing segment from the group summary only for the report,
# but we do NOT delete those rows from the raw/enriched table.

segment_kpis <- order_items_enriched %>%
  filter(!is.na(segment)) %>%
  group_by(segment) %>%
  summarise(
    gmv = sum(line_revenue),
    orders = n_distinct(order_id),
    customers = n_distinct(customer_id),
    aov = gmv / orders,
    .groups = "drop"
  ) %>%
  arrange(desc(gmv))

segment_kpis

write_csv(segment_kpis, "outputs/tables/day_03_segment_kpis.csv")

# ------------------------------------------------------------
# 10. Create KPI table by sales channel
# ------------------------------------------------------------

channel_kpis <- order_items_enriched %>%
  filter(!is.na(sales_channel)) %>%
  group_by(sales_channel) %>%
  summarise(
    gmv = sum(line_revenue),
    orders = n_distinct(order_id),
    customers = n_distinct(customer_id),
    aov = gmv / orders,
    .groups = "drop"
  ) %>%
  arrange(desc(gmv))

channel_kpis

write_csv(channel_kpis, "outputs/tables/day_03_channel_kpis.csv")

# ------------------------------------------------------------
# 11. pivot_longer(): wide KPI table -> long KPI table
# ------------------------------------------------------------
# pivot_longer() makes several metric columns into two columns:
# - metric
# - value
#
# This is useful for flexible plotting, dashboards, and reports.

segment_kpis_long <- segment_kpis %>%
  pivot_longer(
    cols = c(gmv, orders, customers, aov),
    names_to = "metric",
    values_to = "value"
  )

segment_kpis_long

write_csv(segment_kpis_long, "outputs/tables/day_03_segment_kpis_long.csv")

# ------------------------------------------------------------
# 12. pivot_wider(): long KPI table -> wide KPI table
# ------------------------------------------------------------
# pivot_wider() does the opposite.
# It spreads metric names back into separate columns.

segment_kpis_wide_again <- segment_kpis_long %>%
  pivot_wider(
    names_from = metric,
    values_from = value
  )

segment_kpis_wide_again

write_csv(segment_kpis_wide_again, "outputs/tables/day_03_segment_kpis_wide_again.csv")

# ------------------------------------------------------------
# 13. pivot_longer() for marketing spend
# ------------------------------------------------------------
# marketing_wide is common in Excel-style data:
# one column per channel.
#
# For analysis and plotting, long format is usually better:
# one row per month-channel combination.

marketing_long <- marketing_wide %>%
  pivot_longer(
    cols = c(paid_search_spend, social_spend, email_spend),
    names_to = "channel",
    values_to = "spend"
  ) %>%
  mutate(
    channel = str_remove(channel, "_spend"),
    channel = str_replace_all(channel, "_", " "),
    channel = str_to_title(channel)
  )

marketing_long

write_csv(marketing_long, "outputs/tables/day_03_marketing_long.csv")

# ------------------------------------------------------------
# 14. ggplot2 plot 1: GMV by customer segment
# ------------------------------------------------------------

gmv_by_segment_plot <- ggplot(segment_kpis, aes(x = reorder(segment, gmv), y = gmv)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "GMV by Customer Segment",
    subtitle = "Day 3 R drill: joined orders, order items, and customer segments",
    x = "Customer segment",
    y = "GMV"
  ) +
  theme_minimal()

gmv_by_segment_plot

ggsave(
  filename = "outputs/figures/day_03_gmv_by_segment.png",
  plot = gmv_by_segment_plot,
  width = 8,
  height = 5,
  dpi = 300
)

# ------------------------------------------------------------
# 15. ggplot2 plot 2: Marketing spend by channel
# ------------------------------------------------------------

marketing_spend_plot <- ggplot(marketing_long, aes(x = month, y = spend, fill = channel)) +
  geom_col(position = "dodge") +
  labs(
    title = "Marketing Spend by Channel",
    subtitle = "Example of pivot_longer() for reporting-friendly plots",
    x = "Month",
    y = "Marketing spend",
    fill = "Channel"
  ) +
  theme_minimal()

marketing_spend_plot

ggsave(
  filename = "outputs/figures/day_03_marketing_spend_by_channel.png",
  plot = marketing_spend_plot,
  width = 8,
  height = 5,
  dpi = 300
)

# ------------------------------------------------------------
# 16. Mini join-quality summary
# ------------------------------------------------------------

join_quality_summary <- tibble(
  check_name = c(
    "orders_before_customer_join",
    "orders_after_customer_join",
    "duplicate_customer_ids",
    "duplicate_product_ids",
    "orders_with_unknown_customers",
    "items_with_unknown_products",
    "order_items_before_enrichment",
    "order_items_after_enrichment"
  ),
  value = c(
    orders_before_join_rows,
    orders_after_join_rows,
    nrow(duplicate_customers),
    nrow(duplicate_products),
    nrow(orders_with_unknown_customers),
    nrow(items_with_unknown_products),
    nrow(order_items_revenue),
    nrow(order_items_enriched)
  )
)

join_quality_summary

write_csv(join_quality_summary, "outputs/tables/day_03_join_quality_summary.csv")

# ------------------------------------------------------------
# 17. End message
# ------------------------------------------------------------

cat("\nDay 3 complete!\n")
cat("Created KPI tables in outputs/tables/\n")
cat("Created plots in outputs/figures/\n")
cat("Most important lesson: always check duplicate keys and row counts before/after joins.\n")