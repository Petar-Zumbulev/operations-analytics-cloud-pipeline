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

## Grain change after `pivot_longer()`

Before using `pivot_longer()`, the `marketing_wide` table has one row per month.

Example:

| month   | paid_search_spend | social_spend | email_spend |
|---------|------------------:|-------------:|------------:|
| 2026-01 |              2000 |         1200 |         300 |

In this format, the grain is:

> one row per month

The different marketing channels are stored as separate columns.

After using `pivot_longer()`, the table is reshaped so that each marketing channel gets its own row.

Example:

| month   | channel     | spend |
|---------|-------------|------:|
| 2026-01 | Paid Search |  2000 |
| 2026-01 | Social      |  1200 |
| 2026-01 | Email       |   300 |

Now the grain is:

> one row per month and channel

This means that a single month can appear multiple times, once for each channel.

So the grain is no longer only `month`. The grain is now the combination of `month + channel`.

This is important because when joining or summarising data, I need to know what one row represents. If I forget that the table is now at month-channel level, I could accidentally double-count or incorrectly join the data to another table.

## Joining tables can change the grain

A very important idea in data analysis is that a join can change what one row represents.

Before joining two tables, I should always ask:

1.  What does one row represent in the left table?
2.  What does one row represent in the right table?
3.  What should one row represent after the join?
4.  Should the row count stay the same, increase, or decrease?
5.  Could I accidentally duplicate rows and inflate KPIs?

This matters because wrong joins can make business numbers wrong, especially revenue, order counts, customer counts, marketing spend, return rates, and conversion rates.

------------------------------------------------------------------------

## Example 1: Joining `orders` to `order_items`

Suppose I have an `orders` table:

| order_id | customer_id | order_date |
|----------|-------------|------------|
| O001     | C001        | 2026-03-01 |
| O002     | C002        | 2026-03-01 |
| O003     | C003        | 2026-03-02 |

The grain of this table is:

> one row per order

Now suppose I have an `order_items` table:

| order_id | product_id | quantity |
|----------|------------|---------:|
| O001     | P001       |        1 |
| O001     | P002       |        2 |
| O002     | P001       |        1 |
| O003     | P003       |        3 |

The grain of this table is:

> one row per product inside an order

This means that one order can appear multiple times in `order_items`.

For example, order `O001` appears twice because the customer bought two different products: `P001` and `P002`.

If I join these tables in R:

```         
orders %>%
  left_join(order_items, by = "order_id")
```

the result is:

| order_id | customer_id | order_date | product_id | quantity |
|----------|-------------|------------|------------|---------:|
| O001     | C001        | 2026-03-01 | P001       |        1 |
| O001     | C001        | 2026-03-01 | P002       |        2 |
| O002     | C002        | 2026-03-01 | P001       |        1 |
| O003     | C003        | 2026-03-02 | P003       |        3 |

Before the join, `orders` had 3 rows.

After the join, the result has 4 rows.

This is not automatically wrong. The join changed the grain from:

> one row per order

to:

> one row per order item

That is correct if I want to analyze products, categories, quantities, or product-level revenue.

But it is dangerous if I forget that the grain changed.

For example, if I now count rows and think I am counting orders, I would get 4 instead of 3.

Wrong:

```         
joined_table %>%
  summarise(number_of_orders = n())
```

Better:

```         
joined_table %>%
  summarise(number_of_orders = n_distinct(order_id))
```

The key lesson:

> Joining `orders` to `order_items` usually increases the row count because one order can contain multiple items. The new table is no longer order-level. It is item-level.

------------------------------------------------------------------------

## Example 2: Joining `orders` to `customers`

Suppose I have an `orders` table:

| order_id | customer_id | order_date |
|----------|-------------|------------|
| O001     | C001        | 2026-03-01 |
| O002     | C002        | 2026-03-01 |
| O003     | C001        | 2026-03-02 |
| O004     | C003        | 2026-03-03 |

The grain of this table is:

> one row per order

Now suppose I have a `customers` table:

| customer_id | country | segment   |
|-------------|---------|-----------|
| C001        | Germany | Returning |
| C002        | France  | New       |
| C003        | Spain   | VIP       |

The grain of this table is:

> one row per customer

If I join them:

```         
orders %>%
  left_join(customers, by = "customer_id")
```

the result is:

| order_id | customer_id | order_date | country | segment   |
|----------|-------------|------------|---------|-----------|
| O001     | C001        | 2026-03-01 | Germany | Returning |
| O002     | C002        | 2026-03-01 | France  | New       |
| O003     | C001        | 2026-03-02 | Germany | Returning |
| O004     | C003        | 2026-03-03 | Spain   | VIP       |

Before the join, `orders` had 4 rows.

After the join, the result also has 4 rows.

The grain stayed the same:

> one row per order

This is a normal many-to-one join:

-   many orders can belong to one customer
-   each customer should appear only once in the customer table

This is usually safe if `customers` really has only one row per `customer_id`.

But if the customer table has duplicate customer IDs, the join can accidentally multiply rows.

Example of a problematic customer table:

| customer_id | country | segment   |
|-------------|---------|-----------|
| C001        | Germany | Returning |
| C001        | Germany | VIP       |
| C002        | France  | New       |
| C003        | Spain   | VIP       |

Now customer `C001` appears twice.

If I join this duplicated customer table to orders, every order from `C001` could appear twice.

That means the row count could increase even though I expected one row per order.

The key lesson:

> Joining `orders` to `customers` should usually keep the same grain: one row per order. But this is only safe if the customer table has one row per customer ID.

Before joining, I should check:

```         
customers %>%
  count(customer_id) %>%
  filter(n > 1)
```

This shows duplicate customer IDs.

------------------------------------------------------------------------

## Example 3: Joining monthly marketing spend to orders

Suppose I have an `orders` table:

| order_id | order_date | sales_channel |
|----------|------------|---------------|
| O001     | 2026-03-01 | Paid Search   |
| O002     | 2026-03-02 | Paid Search   |
| O003     | 2026-03-03 | Social        |
| O004     | 2026-03-04 | Paid Search   |

The grain of this table is:

> one row per order

Now suppose I have a `marketing_spend` table:

| month   | channel     | spend |
|---------|-------------|------:|
| 2026-03 | Paid Search |  2600 |
| 2026-03 | Social      |  1500 |

The grain of this table is:

> one row per month and channel

If I join monthly marketing spend directly to orders, I might get this:

| order_id | month   | sales_channel | spend |
|----------|---------|---------------|------:|
| O001     | 2026-03 | Paid Search   |  2600 |
| O002     | 2026-03 | Paid Search   |  2600 |
| O003     | 2026-03 | Social        |  1500 |
| O004     | 2026-03 | Paid Search   |  2600 |

Now the `2600` Paid Search spend appears three times.

This is dangerous.

If I now calculate:

```         
sum(spend)
```

I get:

```         
2600 + 2600 + 1500 + 2600 = 9300
```

But the real marketing spend was:

```         
2600 + 1500 = 4100
```

So I accidentally overcounted marketing spend because I joined a month-channel table to an order-level table.

The problem is not that the join is technically impossible. The problem is that I changed the meaning of the spend column.

The marketing spend belongs to the month-channel level, not to each individual order.

A safer approach is to first aggregate orders to the same grain as marketing spend.

Example:

```         
orders_month_channel <- orders %>%
  mutate(month = format(order_date, "%Y-%m")) %>%
  group_by(month, sales_channel) %>%
  summarise(
    orders = n_distinct(order_id),
    .groups = "drop"
  )
```

Now `orders_month_channel` has this grain:

> one row per month and channel

Then I can join to marketing spend more safely:

```         
orders_month_channel %>%
  left_join(
    marketing_spend,
    by = c("month" = "month", "sales_channel" = "channel")
  )
```

The result could look like this:

| month   | sales_channel | orders | spend |
|---------|---------------|-------:|------:|
| 2026-03 | Paid Search   |      3 |  2600 |
| 2026-03 | Social        |      1 |  1500 |

Now the grain is consistent:

> one row per month and channel

This is much safer for calculating KPIs like CAC or ROAS.

The key lesson:

> Be careful when joining aggregated data, such as monthly marketing spend, to detailed data, such as individual orders. The spend can get repeated across many rows and become overcounted.

------------------------------------------------------------------------

## Summary: How to think about grain before joining

Before every join, I should identify the relationship:

| Join type | Example | Expected row-count behavior |
|------------------------|------------------------|------------------------|
| many-to-one | many orders join to one customer | row count should usually stay the same |
| one-to-many | one order joins to many order items | row count usually increases |
| one-to-one | one product joins to one product detail row | row count should stay the same |
| many-to-many | many rows match many rows | dangerous; can multiply rows unexpectedly |

The most important rule:

> A join is not only about matching columns. A join changes or preserves the grain of the data. If I do not understand the grain, I cannot fully trust the KPI.

Professional checklist before joining:

1.  Check the grain of the left table.
2.  Check the grain of the right table.
3.  Check whether the join key is unique on the right side.
4.  Check for duplicate keys.
5.  Check for unmatched IDs.
6.  Compare row counts before and after the join.
7.  Ask whether the joined table is still at the grain I expected.
8.  Be careful when summing values after a join, because some values may have been repeated.

## More examples: duplicate checks and `anti_join()` checks

In the Day 3 script, I already used two important data quality techniques:

1.  Filtering for duplicate keys
2.  Using `anti_join()` to find rows with no match in another table

These are important because joins can silently create wrong KPIs if the data has duplicate IDs or missing matches.

------------------------------------------------------------------------

# Part 1: Filtering for duplicate rows or duplicate keys

A duplicate check asks:

> Does an ID or combination of IDs appear more times than expected?

This matters because if a table is supposed to have one row per ID, duplicated IDs can multiply rows after a join.

------------------------------------------------------------------------

## Duplicate example 1: duplicate order IDs in `orders`

### Table structure

The `orders` table has this grain:

> one row per order

Example:

| order_id | customer_id | order_date | sales_channel |
|----------|-------------|------------|---------------|
| O001     | C001        | 2026-03-01 | Paid Search   |
| O002     | C002        | 2026-03-01 | Organic       |
| O003     | C003        | 2026-03-02 | Email         |
| O003     | C003        | 2026-03-02 | Email         |

In a clean `orders` table, each `order_id` should appear only once.

Here, `O003` appears twice.

That is suspicious because `orders` is supposed to be order-level data.

### R code

```         
duplicate_orders <- orders %>%
  count(order_id) %>%
  filter(n > 1)

duplicate_orders
```

### What the code does

This part:

```         
count(order_id)
```

counts how often each `order_id` appears.

Example result:

| order_id |   n |
|----------|----:|
| O001     |   1 |
| O002     |   1 |
| O003     |   2 |

This part:

```         
filter(n > 1)
```

keeps only the order IDs that appear more than once.

So the final result would show:

| order_id |   n |
|----------|----:|
| O003     |   2 |

### Why this matters

If I join `orders` to another table and `orders` already has duplicate order IDs, I may count the same order twice.

This could inflate:

-   number of orders
-   revenue
-   average order value
-   customer purchase frequency
-   conversion rate

The key lesson:

> If a table should have one row per order, then duplicate `order_id` values are a data quality problem that must be investigated.

------------------------------------------------------------------------

## Duplicate example 2: duplicate order-product combinations in `order_items`

### Table structure

The `order_items` table has this grain:

> one row per product inside an order

Example:

| order_id | product_id | quantity | unit_price |
|----------|------------|---------:|-----------:|
| O001     | P001       |        1 |      49.99 |
| O001     | P002       |        2 |      19.99 |
| O002     | P001       |        1 |      49.99 |
| O002     | P001       |        1 |      49.99 |

In many e-commerce systems, one order-product combination should appear only once.

That means `O002` and `P001` should usually appear as one row, not two rows.

The expected clean version would often be:

| order_id | product_id | quantity | unit_price |
|----------|------------|---------:|-----------:|
| O002     | P001       |        2 |      49.99 |

Instead of two separate duplicate rows.

### R code

```         
duplicate_order_products <- order_items %>%
  count(order_id, product_id) %>%
  filter(n > 1)

duplicate_order_products
```

### What the code does

This part:

```         
count(order_id, product_id)
```

counts how often each order-product combination appears.

Example result:

| order_id | product_id |   n |
|----------|------------|----:|
| O001     | P001       |   1 |
| O001     | P002       |   1 |
| O002     | P001       |   2 |

This part:

```         
filter(n > 1)
```

keeps only combinations that appear more than once.

So the result would show:

| order_id | product_id |   n |
|----------|------------|----:|
| O002     | P001       |   2 |

### Why this matters

This kind of duplicate is more subtle than just checking one ID.

Here, `order_id` can appear multiple times because one order can contain multiple products.

So this would be wrong:

```         
order_items %>%
  count(order_id) %>%
  filter(n > 1)
```

Why?

Because an order appearing multiple times in `order_items` is normal.

The correct check is usually based on the combination:

```         
order_id + product_id
```

The key lesson:

> In detailed tables, duplicates often need to be checked using a combination of columns, not just one ID.

------------------------------------------------------------------------

# Part 2: `anti_join()` checks for no matches

An `anti_join()` asks:

> Which rows in table A do not have a matching row in table B?

This is useful for finding broken relationships between tables.

The structure is:

```         
table_a %>%
  anti_join(table_b, by = "matching_column")
```

This returns rows from `table_a` where the key does not exist in `table_b`.

------------------------------------------------------------------------

## `anti_join()` example 1: customers with no orders

### Table structure

The `customers_raw` table has this grain:

> one row per customer

Example:

| customer_id | country | segment   |
|-------------|---------|-----------|
| C001        | Germany | New       |
| C002        | Germany | Returning |
| C003        | France  | VIP       |
| C004        | Spain   | New       |

The `orders` table has this grain:

> one row per order

Example:

| order_id | customer_id | order_date |
|----------|-------------|------------|
| O001     | C001        | 2026-03-01 |
| O002     | C002        | 2026-03-01 |
| O003     | C001        | 2026-03-02 |

Notice that customer `C003` and customer `C004` do not appear in the `orders` table.

That means they are customers with no orders.

### R code

```         
customers_without_orders <- customers_raw %>%
  distinct(customer_id, .keep_all = TRUE) %>%
  anti_join(orders %>% distinct(customer_id), by = "customer_id")

customers_without_orders
```

### What the code does

This part:

```         
customers_raw %>%
  distinct(customer_id, .keep_all = TRUE)
```

makes sure each customer appears only once before doing the check.

This part:

```         
orders %>%
  distinct(customer_id)
```

creates a list of customers who have placed at least one order.

This part:

```         
anti_join(..., by = "customer_id")
```

keeps customers from `customers_raw` whose `customer_id` does not appear in `orders`.

Example result:

| customer_id | country | segment |
|-------------|---------|---------|
| C003        | France  | VIP     |
| C004        | Spain   | New     |

### Why this matters

This is not always an error.

Some customers may have signed up but not ordered yet.

That can be useful for business questions like:

-   How many registered customers never purchased?
-   Which countries have many signups but few orders?
-   How can marketing convert inactive customers?
-   Should we build an activation KPI?

The key lesson:

> `anti_join()` is not only for finding errors. It can also find important business cases, such as customers who signed up but never ordered.

------------------------------------------------------------------------

## `anti_join()` example 2: orders with no order items

### Table structure

The `orders` table has this grain:

> one row per order

Example:

| order_id | customer_id | order_date |
|----------|-------------|------------|
| O001     | C001        | 2026-03-01 |
| O002     | C002        | 2026-03-01 |
| O003     | C003        | 2026-03-02 |
| O004     | C004        | 2026-03-03 |

The `order_items` table has this grain:

> one row per product inside an order

Example:

| order_id | product_id | quantity |
|----------|------------|---------:|
| O001     | P001       |        1 |
| O001     | P002       |        2 |
| O002     | P001       |        1 |
| O003     | P003       |        3 |

Notice that order `O004` exists in the `orders` table but does not appear in `order_items`.

That is suspicious.

If an order exists, we usually expect it to contain at least one product.

### R code

```         
orders_without_items <- orders %>%
  anti_join(order_items %>% distinct(order_id), by = "order_id")

orders_without_items
```

### What the code does

This part:

```         
order_items %>%
  distinct(order_id)
```

creates a list of all orders that have at least one item.

This part:

```         
orders %>%
  anti_join(..., by = "order_id")
```

keeps only orders whose `order_id` does not appear in `order_items`.

Example result:

| order_id | customer_id | order_date |
|----------|-------------|------------|
| O004     | C004        | 2026-03-03 |

### Why this matters

An order with no order items could mean:

-   incomplete data load
-   cancelled order
-   deleted order items
-   source-system error
-   wrong join key
-   timing issue between systems
-   data extraction problem

For KPI reporting, this is important because an order without items may have no revenue.

If I count it as a normal order, it could affect:

-   order count
-   average order value
-   conversion rate
-   revenue per order
-   operational reporting

The key lesson:

> `anti_join()` can detect parent records that have no child records, such as orders with no order items.

------------------------------------------------------------------------

# Summary

Duplicate checks and `anti_join()` checks answer different questions.

| Check type | Main question | Example |
|------------------------|------------------------|------------------------|
| duplicate check | Does this ID appear more often than expected? | duplicate `customer_id` in customers |
| duplicate combination check | Does this combination appear more often than expected? | duplicate `order_id + product_id` in order_items |
| `anti_join()` check | Which rows have no match in another table? | orders with unknown customers |
| `anti_join()` business check | Which valid rows have no related activity? | customers with no orders |
| `anti_join()` relationship check | Which parent records have no child records? | orders with no order items |

Professional data quality checklist:

1.  Check whether key columns are unique where they should be unique.
2.  Check duplicate combinations in detailed tables.
3.  Use `anti_join()` to find unmatched foreign keys.
4.  Use `anti_join()` to find business cases like customers with no orders.
5.  Use `anti_join()` to find parent records with missing child records.
6.  Investigate suspicious results before calculating KPIs.
7.  Save important checks as data quality reports later in the pipeline.





# Top 3 pitfalls when using `left_join()`

A `left_join()` is one of the most useful tools in data analysis, but it can also silently create wrong results if I do not check the data carefully.

A `left_join()` keeps all rows from the left table and adds matching columns from the right table.

Example:

    orders %>%
      left_join(customers, by = "customer_id")

This means:

> Keep all rows from `orders`, and add customer information where `customer_id` matches.

The dangerous part is that the code may run without an error, even when the result is logically wrong.

---

## Pitfall 1: Duplicate keys in the right table can multiply rows

### The problem

If the right table has duplicate keys, a `left_join()` can multiply rows.

Example:

`orders` table:

| order_id | customer_id | revenue |
|---|---|---:|
| O001 | C001 | 100 |
| O002 | C002 | 200 |
| O003 | C001 | 150 |

Grain:

> one row per order

`customers` table:

| customer_id | country | segment |
|---|---|---|
| C001 | Germany | Returning |
| C001 | Germany | VIP |
| C002 | France | New |

Grain problem:

> `customer_id` is not unique in the customer table.

If I run:

    orders_joined <- orders %>%
      left_join(customers, by = "customer_id")

Then every order from `C001` matches two customer rows.

The result becomes:

| order_id | customer_id | revenue | country | segment |
|---|---|---:|---|---|
| O001 | C001 | 100 | Germany | Returning |
| O001 | C001 | 100 | Germany | VIP |
| O002 | C002 | 200 | France | New |
| O003 | C001 | 150 | Germany | Returning |
| O003 | C001 | 150 | Germany | VIP |

Now the row count increased from 3 to 5.

This can inflate KPIs.

For example, if I calculate total revenue after the join:

    sum(orders_joined$revenue)

I would get:

    100 + 100 + 200 + 150 + 150 = 700

But the true revenue was:

    100 + 200 + 150 = 450

### How to check before joining

Before joining, check whether the right-side join key is unique:

    customers %>%
      count(customer_id) %>%
      filter(n > 1)

If this returns rows, the right table has duplicate keys.

### Key lesson

> Before a `left_join()`, always check whether the right table has duplicate keys. Duplicate keys can multiply rows and inflate KPIs.

---

## Pitfall 2: Unmatched keys create missing values after the join

### The problem

A `left_join()` keeps all rows from the left table, even if there is no match in the right table.

That means unmatched rows stay in the result, but the columns from the right table become `NA`.

Example:

`orders` table:

| order_id | customer_id | revenue |
|---|---|---:|
| O001 | C001 | 100 |
| O002 | C002 | 200 |
| O003 | C999 | 150 |

`customers` table:

| customer_id | country | segment |
|---|---|---|
| C001 | Germany | Returning |
| C002 | France | New |

If I run:

    orders_joined <- orders %>%
      left_join(customers, by = "customer_id")

The result is:

| order_id | customer_id | revenue | country | segment |
|---|---|---:|---|---|
| O001 | C001 | 100 | Germany | Returning |
| O002 | C002 | 200 | France | New |
| O003 | C999 | 150 | NA | NA |

Order `O003` stays in the table because `left_join()` keeps all rows from `orders`.

But `C999` does not exist in the customer table, so `country` and `segment` become missing.

### Why this matters

This can affect KPI reporting.

For example, if I calculate revenue by country:

    orders_joined %>%
      group_by(country) %>%
      summarise(revenue = sum(revenue), .groups = "drop")

I may get a missing country group:

| country | revenue |
|---|---:|
| Germany | 100 |
| France | 200 |
| NA | 150 |

This is important because the missing match may mean:

- wrong customer ID
- customer table not fully loaded
- typo in the key
- deleted customer record
- wrong ID format
- source-system problem

### How to check before joining

Use `anti_join()` to find left-table rows with no match in the right table:

    orders %>%
      anti_join(customers, by = "customer_id")

This returns orders whose `customer_id` does not exist in `customers`.

### Key lesson

> A `left_join()` does not remove unmatched rows. It keeps them and fills right-side columns with `NA`. Always check unmatched keys before trusting the joined result.

---

## Pitfall 3: Joining tables at different grains can repeat values and cause overcounting

### The problem

Tables do not need to have the same grain to be joined, but I must understand what happens after the join.

A common mistake is joining aggregated data to detailed data.

Example:

`orders` table:

| order_id | month | sales_channel | revenue |
|---|---|---|---:|
| O001 | 2026-03 | Paid Search | 100 |
| O002 | 2026-03 | Paid Search | 200 |
| O003 | 2026-03 | Social | 150 |
| O004 | 2026-03 | Paid Search | 120 |

Grain:

> one row per order

`marketing_spend` table:

| month | sales_channel | spend |
|---|---|---:|
| 2026-03 | Paid Search | 2600 |
| 2026-03 | Social | 1500 |

Grain:

> one row per month and sales channel

If I join marketing spend directly to orders:

    orders_with_spend <- orders %>%
      left_join(marketing_spend, by = c("month", "sales_channel"))

The result is:

| order_id | month | sales_channel | revenue | spend |
|---|---|---|---:|---:|
| O001 | 2026-03 | Paid Search | 100 | 2600 |
| O002 | 2026-03 | Paid Search | 200 | 2600 |
| O003 | 2026-03 | Social | 150 | 1500 |
| O004 | 2026-03 | Paid Search | 120 | 2600 |

The Paid Search spend of `2600` appears three times because there are three Paid Search orders.

If I now calculate:

    sum(orders_with_spend$spend)

I get:

    2600 + 2600 + 1500 + 2600 = 9300

But the real marketing spend was:

    2600 + 1500 = 4100

The spend was overcounted because monthly channel-level data was repeated across order-level rows.

### Safer approach

First aggregate orders to the same grain as marketing spend:

    orders_month_channel <- orders %>%
      group_by(month, sales_channel) %>%
      summarise(
        revenue = sum(revenue),
        orders = n_distinct(order_id),
        .groups = "drop"
      )

Now the grain is:

> one row per month and sales channel

Then join:

    marketing_report <- orders_month_channel %>%
      left_join(marketing_spend, by = c("month", "sales_channel"))

The result is safer:

| month | sales_channel | revenue | orders | spend |
|---|---|---:|---:|---:|
| 2026-03 | Paid Search | 420 | 3 | 2600 |
| 2026-03 | Social | 150 | 1 | 1500 |

Now I can calculate metrics like ROAS more safely:

    marketing_report %>%
      mutate(roas = revenue / spend)

### Key lesson

> Be careful when joining aggregated data to detailed data. Values like marketing spend, monthly targets, or budgets can be repeated across many rows and become overcounted.

---

# Professional checklist before using `left_join()`

Before every `left_join()`, I should ask:

1. What is the grain of the left table?
2. What is the grain of the right table?
3. What should one row represent after the join?
4. Is the join key unique in the right table?
5. Are there unmatched keys?
6. Should the row count stay the same or increase?
7. Are any values from the right table being repeated across many rows?
8. Could this join inflate KPIs such as revenue, orders, customers, marketing spend, CAC, or ROAS?

---

# Summary

The top 3 pitfalls when using `left_join()` are:

| Pitfall | Why it is dangerous | How to check |
|---|---|---|
| Duplicate keys in the right table | Can multiply rows and inflate KPIs | `count(key) %>% filter(n > 1)` |
| Unmatched keys | Creates `NA` values after the join | `anti_join()` |
| Joining at the wrong grain | Can repeat aggregated values and cause overcounting | Check grain before and after the join |

Most important rule:

> A `left_join()` can run successfully but still produce a wrong analytical table. Always check duplicate keys, unmatched keys, row counts, and grain before trusting the result.


