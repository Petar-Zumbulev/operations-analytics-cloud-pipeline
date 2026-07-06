# Day 4 Notes — R-to-Python Transfer

## Goal

Today I translated familiar R/tidyverse workflows into Python/pandas.

The goal is not to learn random syntax. The goal is to reuse the same data analysis logic I already know from R and express it in Python.

---

## Main translation table

| R / tidyverse                | Python / pandas                      | Meaning                       |
| ---------------------------- | ------------------------------------ | ----------------------------- |
| `mutate()`                   | `.assign()` or `df["new_col"] = ...` | Create or modify columns      |
| `filter()`                   | Boolean filtering                    | Keep rows based on conditions |
| `arrange()`                  | `.sort_values()`                     | Sort rows                     |
| `group_by()` + `summarise()` | `.groupby().agg()`                   | Aggregate by groups           |
| `left_join()`                | `.merge(..., how="left")`            | Join tables                   |
| `pivot_longer()`             | `.melt()`                            | Wide to long                  |
| `pivot_wider()`              | `.pivot()` / `.pivot_table()`        | Long to wide                  |

---

## Important pandas filtering rules

In pandas, each condition should be inside parentheses.

Example:

```python
orders[
    (orders["status"] == "Delivered") &
    (orders["order_value"] >= 100)
]
```

Use:

```text
& = AND
| = OR
~ = NOT
```

This is different from normal Python `and` / `or`.

---

## mutate() vs assign()

In R:

```r
orders %>%
  mutate(
    is_completed = status == "Delivered",
    revenue = if_else(status == "Delivered", order_value, 0)
  )
```

In Python:

```python
orders_with_revenue = orders.assign(
    is_completed = orders["status"] == "Delivered",
    revenue = orders["order_value"].where(orders["status"] == "Delivered", 0)
)
```

Professional meaning:

Creating columns is not just technical. It defines business logic.

Example:

```text
Revenue = order value only if the order was delivered.
Returned or cancelled orders should not count as revenue.
```

---

## filter() vs boolean filtering

In R:

```r
orders_with_revenue %>%
  filter(status == "Delivered", order_value >= 100)
```

In Python:

```python
high_value_delivered_orders = orders_with_revenue[
    (orders_with_revenue["status"] == "Delivered") &
    (orders_with_revenue["order_value"] >= 100)
]
```

Important:

In pandas, filtering is written as:

```text
dataframe[condition]
```

For multiple conditions:

```text
dataframe[(condition_1) & (condition_2)]
```

---

## arrange() vs sort_values()

In R:

```r
orders %>%
  arrange(desc(order_value))
```

In Python:

```python
orders_sorted = orders.sort_values(
    by="order_value",
    ascending=False
)
```

Meaning:

```text
Sort the rows by order_value from highest to lowest.
```

---

## group_by() + summarise() vs groupby().agg()

In R:

```r
orders_with_revenue %>%
  group_by(sales_channel) %>%
  summarise(
    total_orders = n(),
    total_revenue = sum(revenue),
    avg_order_value = mean(order_value),
    .groups = "drop"
  )
```

In Python:

```python
channel_summary = (
    orders_with_revenue
    .groupby("sales_channel")
    .agg(
        total_orders=("order_id", "count"),
        total_revenue=("revenue", "sum"),
        avg_order_value=("order_value", "mean")
    )
    .reset_index()
)
```

Important:

`groupby("sales_channel")` creates groups.

`.agg(...)` tells pandas what summary numbers to calculate.

`.reset_index()` makes the result a normal flat table again.

This is similar to using `.groups = "drop"` in R.

---

## left_join() vs merge()

In R:

```r
orders_with_revenue %>%
  left_join(customers, by = "customer_id")
```

In Python:

```python
orders_joined = orders_with_revenue.merge(
    customers,
    on="customer_id",
    how="left"
)
```

Meaning:

```text
Keep all rows from orders_with_revenue.
Bring matching customer information from customers.
```

The left table is:

```text
orders_with_revenue
```

The right table is:

```text
customers
```

The join key is:

```text
customer_id
```

The join type is:

```text
left join
```

---

## Data quality habit after joins

After every left join, check unmatched rows.

Example:

```python
unmatched_orders = orders_joined[
    orders_joined["customer_name"].isna()
]
```

Why this matters:

A join can run successfully but still produce bad analytical results.

Example:

```text
If an order has customer_id C999 but C999 does not exist in the customer table,
the technical join works, but the business data is incomplete.
```

Possible business impact:

* customer segment KPIs may be wrong
* country-level revenue may be understated
* customer lifetime value may be incomplete
* reporting may silently exclude unmatched records

A useful check is the unmatched rate:

```python
num_unmatched_orders = unmatched_orders.shape[0]
unmatched_rate = num_unmatched_orders / orders_joined.shape[0]

print(f"Unmatched orders: {num_unmatched_orders}")
print(f"Unmatched rate: {unmatched_rate:.2%}")
```

Professional meaning:

```text
The join did not technically crash, but the data quality check found a business problem.
```

This is exactly the type of thinking that makes the project stronger for analytics engineering and junior data engineering roles.

---

## pivot_longer() vs melt()

In R:

```r
monthly_sales %>%
  pivot_longer(
    cols = c(Online, Store, Partner),
    names_to = "sales_channel",
    values_to = "monthly_revenue"
  )
```

In Python:

```python
monthly_sales_long = monthly_sales.melt(
    id_vars="month",
    value_vars=["Online", "Store", "Partner"],
    var_name="sales_channel",
    value_name="monthly_revenue"
)
```

Important grain change:

Before:

```text
one row per month
```

After:

```text
one row per month per sales channel
```

Whenever data changes shape, I should ask:

```text
What is one row now?
```

This is the grain of the table.

---

## pivot_wider() vs pivot()

In R:

```r
monthly_sales_long %>%
  pivot_wider(
    names_from = sales_channel,
    values_from = monthly_revenue
  )
```

In Python:

```python
monthly_sales_wide = monthly_sales_long.pivot(
    index="month",
    columns="sales_channel",
    values="monthly_revenue"
).reset_index()
```

Optional cleanup:

```python
monthly_sales_wide.columns.name = None
```

Meaning:

```text
Take the values in sales_channel and turn them into separate columns.
```

---

## Customer-level summary example

Business question:

```text
For each customer, how many orders did they place, how much revenue did they generate, and what was their average order value?
```

Python solution:

```python
customer_summary = (
    orders_joined
    .groupby(["customer_id", "customer_name", "country", "segment"], dropna=False)
    .agg(
        total_orders=("order_id", "count"),
        delivered_orders=("is_completed", "sum"),
        total_revenue=("revenue", "sum"),
        avg_order_value=("order_value", "mean")
    )
    .reset_index()
    .sort_values(by="total_revenue", ascending=False)
)
```

Important detail:

```python
dropna=False
```

Why?

```text
Because one order has customer_id C999 and no matched customer.
If I do not handle missing joined values carefully, pandas may hide missing groups in some grouped operations.

For data quality work, I often want to keep missing/unmatched groups visible.
```

---

## Most important lesson today

The logic is the same across R and Python.

I am not starting from zero.

I already understand:

* filtering
* creating columns
* grouping
* summarising
* joining
* reshaping
* checking grain
* checking unmatched joins

Now I am learning the pandas syntax for those same ideas.

---

## Professional reasoning

This day matters because real data jobs often require switching between tools.

A business problem might be solved in R, Python, SQL, or a BI tool, but the core thinking is the same:

```text
What is the grain?
What does each row represent?
What business rule am I applying?
Did the join behave correctly?
Are missing values visible?
Are KPIs based on trustworthy data?
```

The syntax changes, but the analytical thinking stays the same.

---

## Portfolio relevance

This day supports the project because most data analyst, analytics engineer, and junior data engineering roles expect Python/pandas fluency.

The important professional skill is not only writing pandas code, but writing pandas code that respects:

* business logic
* table grain
* join correctness
* missing values
* KPI definitions
* data quality problems

This connects directly to the bigger project goal:

```text
raw messy data
→ validation and cleaning
→ processed analytical tables
→ SQL database
→ KPI reporting
→ forecasting / predictive model
→ cloud architecture documentation
```

---

## End-of-day deliverables

By the end of Day 4, these files should exist:

```text
r_drills/day_04_r_to_python_comparison.R
notebooks/day_04_r_to_python_translation.ipynb
notes/notes_day_04.md
```

---

## End-of-day checklist

I should be able to explain:

```text
mutate() = assign() / new column creation

filter() = boolean filtering

arrange() = sort_values()

group_by() + summarise() = groupby().agg()

left_join() = merge(..., how="left")

pivot_longer() = melt()

pivot_wider() = pivot()

After every join, check unmatched rows.

After every pivot, check the grain.
```

---

## Git commands

After finishing the files:

```bash
git status
git add r_drills/day_04_r_to_python_comparison.R notebooks/day_04_r_to_python_translation.ipynb notes/notes_day_04.md
git commit -m "Complete day 4 R to Python transfer"
```

---

## Next day focus

Day 5 will introduce the main Python packages used in this project:

* pandas
* NumPy
* matplotlib
* seaborn or plotly
* scikit-learn
* statsmodels
* pathlib
* logging

The goal will be to understand what each package is for and how they fit into a real project workflow.
