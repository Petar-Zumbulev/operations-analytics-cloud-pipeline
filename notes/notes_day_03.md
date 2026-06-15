# Day 3 Notes - Joins, Pivoting, ggplot2, and Join Quality

## Goal

Today I practiced the second R repetition block:

-   `left_join()`
-   `anti_join()`
-   duplicate key checks
-   row-count checks before and after joins
-   grain / granularity
-   `pivot_longer()`
-   `pivot_wider()`
-   `ggplot2` reporting plots

This matters because real business KPIs are often wrong not because the formula is hard, but because the data was joined at the wrong grain or duplicate keys silently multiplied rows.

------------------------------------------------------------------------

## Key idea: grain / granularity

Grain means:

> What does one row represent?

Examples:

| Table                | Grain                                |
|----------------------|--------------------------------------|
| customers            | one row per customer                 |
| orders               | one row per order                    |
| order_items          | one row per product inside one order |
| marketing_spend_long | one row per month/channel            |

Before joining tables, I should always ask:

1.  What is the grain of the left table?
2.  What is the grain of the right table?
3.  What should the grain be after the join?
4.  Could this join multiply rows?
5.  Are there unmatched IDs?

------------------------------------------------------------------------

## `left_join()`

A `left_join()` keeps all rows from the left table and adds matching columns from the right table.

Example:

``` r
orders_enriched <- orders %>%
  left_join(customers_dim, by = "customer_id")
```

Meaning:

> Keep all orders and add customer information where the customer ID matches.

If the left table has 8 orders, I usually expect the joined table to still have 8 rows.

If the row count increases, the right table may have duplicate keys.

------------------------------------------------------------------------

## Duplicate key check

Before joining, check whether the right table has duplicate keys.

``` r
customers_raw %>%
  count(customer_id) %>%
  filter(n > 1)
```

Why this matters:

If the right table has duplicate customer IDs, then a join can multiply rows and inflate revenue, order counts, or other KPIs.

------------------------------------------------------------------------

## `anti_join()`

`anti_join()` finds rows in the left table that do not have a match in the right table.

Example:

``` r
orders %>%
  anti_join(customers_raw %>% distinct(customer_id), by = "customer_id")
```

Meaning:

> Show me orders with customer IDs that do not exist in the customer table.

This is useful for data quality checks.

Possible real-world causes:

-   typo in the key
-   delayed data load
-   deleted record
-   wrong ID format
-   wrong join column
-   source system problem

------------------------------------------------------------------------

## Row-count check

Before and after joins, I should check row counts.

``` r
orders_before_join_rows <- nrow(orders)

orders_enriched <- orders %>%
  left_join(customers_dim, by = "customer_id")

orders_after_join_rows <- nrow(orders_enriched)
```

If I expected one row per order and the row count changed, I need to investigate.

------------------------------------------------------------------------

## `pivot_longer()`

`pivot_longer()` converts wide data into long data.

Example:

``` r
marketing_long <- marketing_wide %>%
  pivot_longer(
    cols = c(paid_search_spend, social_spend, email_spend),
    names_to = "channel",
    values_to = "spend"
  )
```

Wide format:

| month | paid_search_spend | social_spend | email_spend |
|-------|------------------:|-------------:|------------:|

Long format:

| month | channel | spend |
|-------|---------|------:|

Long format is usually better for:

-   plotting
-   grouped analysis
-   dashboards
-   SQL-style thinking

------------------------------------------------------------------------

## `pivot_wider()`

`pivot_wider()` converts long data back to wide data.

Example:

``` r
segment_kpis_wide_again <- segment_kpis_long %>%
  pivot_wider(
    names_from = metric,
    values_from = value
  )
```

Wide format is often better for final stakeholder reports.

------------------------------------------------------------------------

## `ggplot2`

Today I created two plots:

``` text
outputs/figures/day_03_gmv_by_segment.png
outputs/figures/day_03_marketing_spend_by_channel.png
```

The main structure of a ggplot is:

``` r
ggplot(data, aes(x = ..., y = ...)) +
  geom_col() +
  labs(
    title = "...",
    x = "...",
    y = "..."
  ) +
  theme_minimal()
```

The idea:

-   `ggplot()` starts the plot
-   `aes()` defines the mapping between columns and visual elements
-   `geom_col()` creates bars where bar height is already calculated
-   `labs()` adds labels
-   `theme_minimal()` makes the plot cleaner

------------------------------------------------------------------------

## Professional lesson

The most important professional lesson from today:

> A correct KPI depends on a correct join.

Before trusting a joined dataset, I should check:

-   duplicate keys in dimension tables
-   unmatched IDs
-   row counts before and after joins
-   whether the result is at the expected grain
-   whether missing values after the join are expected or suspicious

This connects directly to future pipeline work:

``` text
raw data
→ join checks
→ unmatched key reports
→ row-count checks
→ clean analytical tables
→ reliable KPIs
```

------------------------------------------------------------------------

## Files created

``` text
r_drills/day_03_joins_ggplot.R

outputs/tables/day_03_duplicate_customers.csv
outputs/tables/day_03_duplicate_products.csv
outputs/tables/day_03_orders_unknown_customers.csv
outputs/tables/day_03_items_unknown_products.csv
outputs/tables/day_03_segment_kpis.csv
outputs/tables/day_03_channel_kpis.csv
outputs/tables/day_03_segment_kpis_long.csv
outputs/tables/day_03_segment_kpis_wide_again.csv
outputs/tables/day_03_marketing_long.csv
outputs/tables/day_03_join_quality_summary.csv

outputs/figures/day_03_gmv_by_segment.png
outputs/figures/day_03_marketing_spend_by_channel.png
```

------------------------------------------------------------------------

## End-of-day summary

Today I practiced R joins, pivoting, and reporting plots.

The most important concept was not just how to join, but how to check whether the join is safe.

I learned that bad joins can silently change row counts and inflate KPIs. I also practiced using `anti_join()` to find unmatched records and using `pivot_longer()` / `pivot_wider()` to reshape data for analysis and reporting.

------------------------------------------------------------------------

## Next-day focus

Day 4 will transfer these R skills into Python/pandas.

I will compare:

| R                | Python/pandas                 |
|------------------|-------------------------------|
| `mutate()`       | create/assign columns         |
| `summarise()`    | `.agg()`                      |
| `group_by()`     | `.groupby()`                  |
| `left_join()`    | `.merge(..., how = "left")`   |
| `pivot_longer()` | `.melt()`                     |
| `pivot_wider()`  | `.pivot()` / `.pivot_table()` |
