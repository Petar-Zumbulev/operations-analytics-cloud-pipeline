import sqlite3
import pandas as pd

# Connect to database
conn = sqlite3.connect("hassia_practice.db")
cursor = conn.cursor()

# Drop old tables so the script is repeatable
cursor.execute("DROP TABLE IF EXISTS customers")
cursor.execute("DROP TABLE IF EXISTS products")
cursor.execute("DROP TABLE IF EXISTS orders")
cursor.execute("DROP TABLE IF EXISTS order_items")
cursor.execute("DROP TABLE IF EXISTS shipments")

# Create tables
cursor.execute("""
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name TEXT,
    region TEXT
)
""")

cursor.execute("""
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT,
    category TEXT
)
""")

cursor.execute("""
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date TEXT,
    order_month TEXT,
    status TEXT
)
""")

cursor.execute("""
CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    unit_price REAL
)
""")

cursor.execute("""
CREATE TABLE shipments (
    shipment_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    shipped_date TEXT,
    delivered_date TEXT
)
""")

# Insert data
customers_data = [
    (1, "Rewe", "Hessen"),
    (2, "Edeka", "Bayern"),
    (3, "Kaufland", "NRW"),
    (4, "Lidl", "Hessen")
]

products_data = [
    (1, "Mineralwasser Classic", "Water"),
    (2, "Mineralwasser Still", "Water"),
    (3, "Apfelschorle", "Soft Drink")
]

orders_data = [
    (1001, 1, "2026-01-05", "2026-01", "delivered"),
    (1002, 2, "2026-01-12", "2026-01", "delivered"),
    (1003, 1, "2026-02-03", "2026-02", "cancelled"),
    (1004, 3, "2026-02-10", "2026-02", "delivered"),
    (1005, 4, "2026-02-15", "2026-02", "open")
]

order_items_data = [
    (1, 1001, 1, 100, 0.80),
    (2, 1001, 3, 50, 1.20),
    (3, 1002, 2, 200, 0.75),
    (4, 1004, 1, 150, 0.80),
    (5, 1004, 3, 70, 1.20),
    (6, 1005, 2, 300, 0.75)
]

shipments_data = [
    (1, 1001, "2026-01-06", "2026-01-08"),
    (2, 1002, "2026-01-13", "2026-01-15"),
    (3, 1004, "2026-02-11", "2026-02-14")
]

cursor.executemany("INSERT INTO customers VALUES (?, ?, ?)", customers_data)
cursor.executemany("INSERT INTO products VALUES (?, ?, ?)", products_data)
cursor.executemany("INSERT INTO orders VALUES (?, ?, ?, ?, ?)", orders_data)
cursor.executemany("INSERT INTO order_items VALUES (?, ?, ?, ?, ?)", order_items_data)
cursor.executemany("INSERT INTO shipments VALUES (?, ?, ?, ?)", shipments_data)

conn.commit()

# Helper function to run SQL and print results
def run_query(title, query):
    print("\n" + "=" * 60)
    print(title)
    print("=" * 60)
    df = pd.read_sql_query(query, conn)
    print(df)

# 1. Basic SELECT
run_query("All orders", """
SELECT *
FROM orders;
""")

# 2. Filter delivered orders
run_query("Delivered orders only", """
SELECT *
FROM orders
WHERE status = 'delivered';
""")

# 3. Revenue per order
run_query("Revenue per order", """
SELECT
    order_id,
    SUM(quantity * unit_price) AS order_revenue
FROM order_items
GROUP BY order_id;
""")

# 4. Revenue per customer
run_query("Revenue per customer", """
SELECT
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'delivered'
GROUP BY c.customer_name
ORDER BY total_revenue DESC;
""")

# 5. Revenue per product
run_query("Revenue per product", """
SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status = 'delivered'
GROUP BY p.product_name
ORDER BY total_revenue DESC;
""")

# 6. Orders without shipment
run_query("Orders without shipment", """
SELECT
    o.order_id,
    o.status
FROM orders o
LEFT JOIN shipments s
    ON o.order_id = s.order_id
WHERE s.order_id IS NULL;
""")

conn.close()