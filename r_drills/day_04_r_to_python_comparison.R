# Day 4: R-to-Python Comparison
# Goal: Repeat familiar tidyverse operations before translating them into pandas.

library(tidyverse)

# ------------------------------------------------------------
# 1. Create small example tables
# ------------------------------------------------------------

customers <- tribble(
  ~customer_id, ~customer_name, ~country,   ~segment,
  "C001",       "Anna",         "Germany",  "Consumer",
  "C002",       "Ben",          "Germany",  "Business",
  "C003",       "Clara",        "France",   "Consumer",
  "C004",       "David",        "Spain",    "Business",
  "C005",       "Eva",          "Germany",  "Consumer"
)

orders <- tribble(
  ~order_id, ~customer_id, ~order_date,   ~sales_channel, ~order_value, ~status,
  "O001",    "C001",       "2026-01-05",  "Online",       120,          "Delivered",
  "O002",    "C001",       "2026-01-20",  "Store",        80,           "Returned",
  "O003",    "C002",       "2026-02-03",  "Online",       250,          "Delivered",
  "O004",    "C003",       "2026-02-15",  "Partner",      300,          "Delivered",
  "O005",    "C999",       "2026-03-01",  "Online",       90,           "Delivered",
  "O006",    "C005",       "2026-03-12",  "Store",        150,          "Cancelled"
)

monthly_sales <- tribble(
  ~month,     ~Online, ~Store, ~Partner,
  "2026-01", 120,     80,     0,
  "2026-02", 250,     0,      300,
  "2026-03", 90,      150,    0
)

# ------------------------------------------------------------
# 2. mutate() example
# ------------------------------------------------------------

orders_with_revenue <- orders %>%
  mutate(
    is_completed = status == "Delivered",
    revenue = if_else(status == "Delivered", order_value, 0)
  )

print(orders_with_revenue)

# ------------------------------------------------------------
# 3. filter() and arrange() example
# ------------------------------------------------------------

high_value_delivered_orders <- orders_with_revenue %>%
  filter(status == "Delivered", order_value >= 100) %>%
  arrange(desc(order_value))

print(high_value_delivered_orders)

# ------------------------------------------------------------
# 4. group_by() + summarise() example
# ------------------------------------------------------------

channel_summary <- orders_with_revenue %>%
  group_by(sales_channel) %>%
  summarise(
    total_orders = n(),
    delivered_orders = sum(status == "Delivered"),
    total_revenue = sum(revenue),
    avg_order_value = mean(order_value),
    .groups = "drop"
  ) %>%
  arrange(desc(total_revenue))

print(channel_summary)

# ------------------------------------------------------------
# 5. left_join() example
# ------------------------------------------------------------

orders_joined <- orders_with_revenue %>%
  left_join(customers, by = "customer_id")

print(orders_joined)

# Important data quality check:
# Which orders did not match a customer?

unmatched_orders <- orders_joined %>%
  filter(is.na(customer_name))

print(unmatched_orders)

# ------------------------------------------------------------
# 6. pivot_longer() example
# ------------------------------------------------------------

monthly_sales_long <- monthly_sales %>%
  pivot_longer(
    cols = c(Online, Store, Partner),
    names_to = "sales_channel",
    values_to = "monthly_revenue"
  )

print(monthly_sales_long)

# ------------------------------------------------------------
# 7. pivot_wider() example
# ------------------------------------------------------------

monthly_sales_wide_again <- monthly_sales_long %>%
  pivot_wider(
    names_from = sales_channel,
    values_from = monthly_revenue
  )

print(monthly_sales_wide_again)

# ------------------------------------------------------------
# 8. End-of-day reflection
# ------------------------------------------------------------

# Main idea:
# The business logic is the same in R and Python.
# We are not learning a totally new way to think.
# We are translating familiar data analysis actions into pandas syntax.