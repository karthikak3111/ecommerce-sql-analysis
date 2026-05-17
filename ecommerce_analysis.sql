CREATE DATABASE ecommerce_project;
USE ecommerce_project;
DROP TABLE orders;

CREATE TABLE orders (
  order_id VARCHAR(20),
  customer_id VARCHAR(20),
  order_date DATE,
  year INT,
  month INT,
  quarter VARCHAR(5),
  day_of_week VARCHAR(20),
  product_name VARCHAR(100),
  category VARCHAR(50),
  unit_price_usd DECIMAL(10,2),
  quantity INT,
  subtotal_usd DECIMAL(10,2),
  discount_pct INT,
  discount_amount_usd DECIMAL(10,2),
  shipping_fee_usd DECIMAL(10,2),
  tax_pct INT,
  tax_amount_usd DECIMAL(10,2),
  total_amount_usd DECIMAL(10,2),
  payment_method VARCHAR(50),
  device_used VARCHAR(50),
  delivery_days INT,
  delivery_date DATE,
  order_status VARCHAR(30),
  returned INT,
  customer_rating VARCHAR(10),
  session_duration_minutes DECIMAL(10,2),
  pages_viewed_before_purchase INT,
  is_repeat_customer INT
);

select count(*) from orders;

select * from orders limit 10;

-- Total Revenue --
SELECT 
  ROUND(SUM(total_amount_usd),2) AS total_revenue
FROM orders
WHERE order_status = 'Delivered';

-- Total Customers --
SELECT 
  COUNT(DISTINCT customer_id) AS total_customers
FROM orders;

-- Top Selling Categories --
SELECT 
  category,
  ROUND(SUM(total_amount_usd),2) AS revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY category
ORDER BY revenue DESC;

-- Top 10 Products --
SELECT 
  product_name,
  ROUND(SUM(total_amount_usd),2) AS revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;

-- Monthly Revenue Trend --
SELECT 
  year,
  month,
  ROUND(SUM(total_amount_usd),2) AS revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY year, month
ORDER BY year, month;

-- Return Rate Analysis --
SELECT 
  category,
  COUNT(*) AS total_orders,
  SUM(returned) AS returned_orders,
  ROUND(SUM(returned)*100/COUNT(*),2) AS return_rate
FROM orders
GROUP BY category
ORDER BY return_rate DESC;

-- Payment Method Analysis --
SELECT 
  payment_method,
  COUNT(*) AS total_orders,
  ROUND(SUM(total_amount_usd),2) AS revenue
FROM orders
GROUP BY payment_method
ORDER BY revenue DESC;

-- Repeat Customer Analysis --
SELECT 
  CASE
    WHEN is_repeat_customer = 1 THEN 'Repeat'
    ELSE 'New'
  END AS customer_type,
  
  COUNT(*) AS orders,
  ROUND(SUM(total_amount_usd),2) AS revenue
FROM orders
GROUP BY is_repeat_customer;

-- Device-wise Revenue --
SELECT 
  device_used,
  ROUND(SUM(total_amount_usd),2) AS revenue
FROM orders
GROUP BY device_used
ORDER BY revenue DESC;

-- Delivery Performance --
SELECT 
  delivery_days,
  COUNT(*) AS total_orders,
  ROUND(AVG(CAST(customer_rating AS DECIMAL(3,1))),2) AS avg_rating
FROM orders
WHERE customer_rating IS NOT NULL
GROUP BY delivery_days
ORDER BY delivery_days;

SELECT 
  product_name,
  category,
  total_amount_usd,
  
  RANK() OVER(
    PARTITION BY category
    ORDER BY total_amount_usd DESC
  ) AS product_rank
FROM orders;

-- Running Revenue --
SELECT 
  order_date,
  ROUND(SUM(total_amount_usd),2) AS daily_revenue,

  ROUND(
    SUM(SUM(total_amount_usd)) OVER(
      ORDER BY order_date
    ),2
  ) AS running_revenue

FROM orders
GROUP BY order_date;


