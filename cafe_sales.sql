--- KPI Summary 
SELECT
    COUNT(DISTINCT transaction_id) AS total_transactions,
    ROUND(SUM(total_price), 2) AS total_revenue,
    ROUND(AVG(total_price), 2) AS avg_transaction_value,
    ROUND(SUM(quantity), 2) AS total_units_sold,
    ROUND(AVG(quantity), 2) AS avg_units_per_transaction
FROM cafe_sales_clean;

--- Top 5 best-selling products
SELECT
    product,
    ROUND(SUM(quantity), 2) AS units_sold
FROM cafe_sales_clean
GROUP BY product
ORDER BY units_sold DESC
LIMIT 5;

--- Top 5 product by revenue
SELECT product,
    ROUND(SUM(total_price), 2) AS revenue
FROM cafe_sales_clean
GROUP BY product
ORDER BY revenue DESC
LIMIT 5;

--- Payment method analysis
SELECT
    payment_method,
    COUNT(*) AS transactions,
    ROUND(SUM(total_price), 2) AS revenue,
    ROUND(AVG(total_price), 2) AS avg_transaction_value
FROM cafe_sales_clean
GROUP BY payment_method
ORDER BY revenue DESC;

--- Purchase type analysis
SELECT
    purchase_type,
    COUNT(*) AS transactions,
    ROUND(SUM(total_price), 2) AS revenue,
    ROUND(AVG(total_price), 2) AS avg_transaction_value
FROM cafe_sales_clean
GROUP BY purchase_type
ORDER BY revenue DESC;


--- Store performance analysis ---
--- Revenue by store location
SELECT
    store_location,
    COUNT(DISTINCT transaction_id) AS transactions,
    ROUND(SUM(quantity), 2) AS units_sold,
    ROUND(SUM(total_price), 2) AS revenue,
    ROUND(AVG(total_price), 2) AS avg_transaction_value
FROM cafe_sales_clean
GROUP BY store_location
ORDER BY revenue DESC;

--- Best selling products by store location
WITH product_store_sales AS (
    SELECT
        store_location,
        product,
        SUM(quantity) AS units_sold,
        ROW_NUMBER() OVER (
            PARTITION BY store_location
            ORDER BY SUM(quantity) DESC
        ) AS rn
    FROM cafe_sales_clean
    GROUP BY store_location, product
)
SELECT
    store_location,
    product,
    units_sold
FROM product_store_sales
WHERE rn = 1
ORDER BY store_location;

--- They must really like juice

--- Trend analysis ---
--- Daily sales trends
SELECT
    order_date,
    COUNT(DISTINCT transaction_id) AS transactions,
    ROUND(SUM(total_price), 2) AS daily_revenue,
    ROUND(AVG(total_price), 2) AS avg_transaction_value
FROM cafe_sales_clean
GROUP BY order_date
ORDER BY order_date;

--- Monthly sales trends
SELECT
    SUBSTR(order_date, 1, 7) AS sales_month,
    COUNT(DISTINCT transaction_id) AS transactions,
    ROUND(SUM(total_price), 2) AS revenue
FROM cafe_sales_clean
GROUP BY SUBSTR(order_date, 1, 7)
ORDER BY sales_month;

---Product performance by channel
SELECT
    purchase_type,
    product,
    ROUND(SUM(quantity), 2) AS units_sold,
    ROUND(SUM(total_price), 2) AS revenue
FROM cafe_sales_clean
GROUP BY purchase_type, product
ORDER BY purchase_type, revenue DESC;

--- Store ranking by operational efficiency: A simple store scorecard:

SELECT
    store_location,
    ROUND(SUM(total_price), 2) AS revenue,
    COUNT(DISTINCT transaction_id) AS transactions,
    ROUND(SUM(quantity) * 1.0 / COUNT(DISTINCT transaction_id), 2) AS units_per_transaction,
    ROUND(SUM(total_price) * 1.0 / COUNT(DISTINCT transaction_id), 2) AS revenue_per_transaction
FROM cafe_sales_clean
GROUP BY store_location
ORDER BY revenue_per_transaction DESC;

--- Add profitability modeling for portfolio value, as the raw data does not include costs, so let's create a simple cost model

--- Create a product cost table

DROP TABLE IF EXISTS product_costs;

CREATE TABLE product_costs (
    product TEXT PRIMARY KEY,
    estimated_unit_cost REAL
);


-- Add estimated costs manually:
INSERT INTO product_costs (product, estimated_unit_cost) VALUES
('Coffee', 1.20),
('Tea', 0.90),
('Latte', 1.80),
('Cappuccino', 1.70),
('Mocha', 1.95),
('Espresso', 1.00),
('Hot Chocolate', 1.60),
('Americano', 1.10);


-- Now, let's edit this list to match the real product names
--Product profitability analysis
SELECT
    s.product,
    ROUND(SUM(s.quantity), 2) AS units_sold,
    ROUND(SUM(s.total_price), 2) AS revenue,
    ROUND(SUM(s.quantity * c.estimated_unit_cost), 2) AS estimated_cost,
    ROUND(SUM(s.total_price) - SUM(s.quantity * c.estimated_unit_cost), 2) AS estimated_gross_profit,
    ROUND(
        (SUM(s.total_price) - SUM(s.quantity * c.estimated_unit_cost)) * 100.0 / SUM(s.total_price),
        2
    ) AS gross_margin_pct
FROM cafe_sales_clean s
JOIN product_costs c
    ON s.product = c.product
GROUP BY s.product
ORDER BY estimated_gross_profit DESC;

--- Now we can do a Store profitability analysis
SELECT
    s.store_location,
    ROUND(SUM(s.total_price), 2) AS revenue,
    ROUND(SUM(s.quantity * c.estimated_unit_cost), 2) AS variable_cost,
    ROUND(SUM(s.total_price) - SUM(s.quantity * c.estimated_unit_cost), 2) AS contribution_profit
FROM cafe_sales_clean s
JOIN product_costs c
    ON s.product = c.product
GROUP BY s.store_location
ORDER BY contribution_profit DESC;

