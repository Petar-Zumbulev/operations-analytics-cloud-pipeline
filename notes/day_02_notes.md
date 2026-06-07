## Day 02 Notes - dplyr Core Drills

Core verbs you’ll constantly use in analytics jobs:

filter() → keep relevant rows mutate() → create business variables group_by() + summarise() → calculate KPIs arrange() → rank results case_when() → clean messy categories


1. you get messy data

2. the first thing is to clean it, use mutate() to create your clean columns

  - this is the first layer of analysis, cleaning using mutate()

3. then you use group_by() and summarise() to group by customer type, or country
  and then summarize the most important kpis for each group
  
  - so group_by() and summarise() are the second layer of analysis



## Goal

Today I practiced the most important core `dplyr` verbs for business analytics:

-   `filter()`
-   `mutate()`
-   `group_by()`
-   `summarise()`
-   `arrange()`
-   `case_when()`

The business context was a small operations/e-commerce order dataset.

------------------------------------------------------------------------

## Key R verbs

### `filter()`

`filter()` is used to keep only rows that match a condition.

Example:

``` r
completed_orders <- orders_clean %>%
  filter(is_completed == TRUE)
```

Business meaning:

This lets me analyze only completed orders instead of mixing completed, returned, and cancelled orders.

------------------------------------------------------------------------

### `mutate()`

`mutate()` is used to create new columns or transform existing columns.

Example:

``` r
orders_clean <- orders_raw %>%
  mutate(
    net_revenue = gross_sales - discount,
    is_completed = order_status == "completed"
  )
```

Business meaning:

This creates useful analytical variables like net revenue and completion flags.

------------------------------------------------------------------------

### `group_by()` and `summarise()`

`group_by()` and `summarise()` are used together to calculate KPIs by group.

Example:

``` r
country_kpis <- orders_clean %>%
  group_by(country_clean) %>%
  summarise(
    orders = n(),
    total_net_revenue = sum(net_revenue),
    average_order_value = mean(net_revenue),
    .groups = "drop"
  )
```

Business meaning:

This allows me to compare performance across countries, channels, product categories, or customer segments.

------------------------------------------------------------------------

### `arrange()`

`arrange()` is used to sort results.

Example:

``` r
country_kpis <- country_kpis %>%
  arrange(desc(total_net_revenue))
```

Business meaning:

This helps identify the best-performing countries, channels, or categories.

------------------------------------------------------------------------

### `case_when()`

`case_when()` is used for rule-based cleaning and classification.

Example:

``` r
country_clean = case_when(
  str_to_lower(country) %in% c("germany", "de") ~ "Germany",
  str_to_lower(country) %in% c("france", "fr") ~ "France",
  str_to_lower(country) %in% c("spain", "es") ~ "Spain",
  TRUE ~ "Other"
)
```

Business meaning:

This fixes inconsistent categories so KPI results are not split across messy labels.

For example, without cleaning:

-   `"Germany"`
-   `"germany"`
-   `"DE"`

would be treated as three different countries.

------------------------------------------------------------------------

## Important data types from `glimpse()`

Today I also used:

``` r
glimpse(orders_raw)
```

`glimpse()` gives a quick overview of:

-   number of rows
-   number of columns
-   column names
-   column data types
-   example values

Common data types:

| Type     | Meaning           | Example               |
|----------|-------------------|-----------------------|
| `<chr>`  | character / text  | `"Germany"`, `"O001"` |
| `<dbl>`  | numeric / double  | `120`, `4.99`, `4500` |
| `<int>`  | integer           | `1L`, `20L`           |
| `<lgl>`  | logical / boolean | `TRUE`, `FALSE`       |
| `<date>` | date              | `2026-01-03`          |
| `<dttm>` | date-time         | `2026-01-03 14:30:00` |

Important note:

`<dbl>` means the column is numeric. It can contain whole numbers or decimal numbers.

Example:

``` r
gross_sales = c(120, 85, 240)
shipping_fee = c(4.99, 6.99, 3.99)
```

Both can be stored as `<dbl>`.

------------------------------------------------------------------------

## KPI answers

### 1. Which country generated the highest total net revenue?

Answer:

``` text
Write answer here after running the script.
```

------------------------------------------------------------------------

### 2. Which sales channel had the highest total net revenue?

Answer:

``` text
Write answer here after running the script.
```

------------------------------------------------------------------------

### 3. Which product category had the highest return rate?

Answer:

``` text
Write answer here after running the script.
```

------------------------------------------------------------------------

### 4. What does average_order_value mean in this dataset?

Answer:

Average order value means the average net revenue per order.

Formula:

``` text
average_order_value = mean(net_revenue)
```

Example interpretation:

If average order value is 150, then the average order generated 150 EUR in net revenue before considering more advanced adjustments such as returns, refunds, or costs.

------------------------------------------------------------------------

### 5. Why is the 4500 gross_sales order suspicious?

Answer:

The 4500 order is suspicious because it is much larger than the other orders.

It could be:

-   a real high-value order
-   a data entry error
-   a duplicate issue
-   a currency issue
-   a business-to-business bulk order
-   an outlier that needs investigation

In real data work, I should not delete it immediately. I should first flag it, investigate it, and decide how to treat it depending on the business context.

------------------------------------------------------------------------

### 6. What is the difference between gross_sales and net_revenue?

Answer:

Gross sales is the original order value before discounts.

Net revenue subtracts discounts.

Formula:

``` text
net_revenue = gross_sales - discount
```

Example:

``` text
gross_sales = 120
discount = 10
net_revenue = 110
```

------------------------------------------------------------------------

### 7. Why do we clean "DE", "Germany", and "germany" into one value?

Answer:

Because they all represent the same country.

If we do not standardize them, Germany would be split into multiple categories and the KPI results would be wrong.

Bad version:

| country | revenue |
|---------|--------:|
| Germany |     500 |
| germany |     200 |
| DE      |     300 |

Better version:

| country_clean | revenue |
|---------------|--------:|
| Germany       |    1000 |

------------------------------------------------------------------------

### 8. Why should cancelled and returned orders be treated carefully in KPI reporting?

Answer:

Cancelled and returned orders can make KPIs misleading if they are treated like successful completed orders.

For example:

-   completed orders may count toward real revenue
-   returned orders may need to reduce revenue
-   cancelled orders may need to be excluded from revenue
-   return rate is an important business KPI by itself

In real reporting, I need to clearly define whether my KPI uses:

-   all orders
-   only completed orders
-   completed orders minus returns
-   gross revenue
-   net revenue
-   refunded-adjusted revenue

------------------------------------------------------------------------

## Optional challenge answer

Create a summary table grouped by both country and sales channel:

``` r
country_channel_kpis <- orders_clean %>%
  group_by(country_clean, sales_channel_clean) %>%
  summarise(
    orders = n(),
    completed_orders = sum(is_completed),
    total_net_revenue = sum(net_revenue),
    average_order_value = mean(net_revenue),
    .groups = "drop"
  ) %>%
  arrange(desc(total_net_revenue))

print(country_channel_kpis)
```

Business meaning:

This shows which country-channel combinations perform best.

For example, instead of only asking:

``` text
Which country performs best?
```

or:

``` text
Which sales channel performs best?
```

I can ask a more specific question:

``` text
Which sales channel performs best inside each country?
```

------------------------------------------------------------------------

## Main workflow pattern

The main analytics pattern from today was:

``` r
raw_data %>%
  mutate(cleaned_columns_and_business_metrics) %>%
  filter(relevant_rows) %>%
  group_by(business_dimension) %>%
  summarise(kpis) %>%
  arrange(desc(kpi))
```

This pattern is central in analyst work.

It is used for:

-   country performance
-   channel performance
-   product category performance
-   customer segment analysis
-   revenue reporting
-   conversion reporting
-   operational KPI reporting

------------------------------------------------------------------------

## What I learned today

-   I refreshed the core `dplyr` workflow.
-   I practiced turning raw order data into KPI-ready data.
-   I cleaned messy categories using `case_when()`.
-   I calculated business KPIs by country, channel, and product category.
-   I created basic data quality checks.
-   I exported KPI tables as CSV files.
-   I practiced reading column types with `glimpse()`.

------------------------------------------------------------------------

## End-of-day deliverables

-   `r_drills/day_02_dplyr_core.R`
-   `notes/notes_day_02.md`
-   `outputs/tables/day_02_total_kpi_summary_r.csv`
-   `outputs/tables/day_02_country_kpis_r.csv`
-   `outputs/tables/day_02_channel_kpis_r.csv`
-   `outputs/tables/day_02_category_kpis_r.csv`
-   `outputs/tables/day_02_data_quality_summary_r.csv`

------------------------------------------------------------------------

## Next day preview

Day 03 will continue R repetition with:

-   `left_join()`
-   `pivot_longer()`
-   `pivot_wider()`
-   `ggplot2`
-   reporting plots
