-- Databricks notebook source
-- MAGIC %md
-- MAGIC Explore the items table 
-- MAGIC - View the menu_items table and find the number of the items that are on the menu
-- MAGIC - What are the most and least expensive items on the menu
-- MAGIC - How many Italian dishes are on the menu? 
-- MAGIC   - What are the most and least expensive Italian dishes on the menu
-- MAGIC - How many dishes are in each category? What is the average dish price within each category?

-- COMMAND ----------

describe menu_items;

-- COMMAND ----------

-- 1. View the menu_items table 
SELECT * FROM menu_items;

-- COMMAND ----------

-- 2. Find the number of items on the menu
SELECT COUNT(1) FROM menu_items;

-- COMMAND ----------

SELECT category, COUNT(1) FROM menu_items
GROUP BY category;

-- COMMAND ----------

-- 3. What are the most and least expensive items on the menu

-- Least expensive
SELECT * FROM menu_items
ORDER BY price
LIMIT 5;

-- COMMAND ----------

-- Most expensive
SELECT * FROM menu_items
ORDER BY price DESC
LIMIT 5;

-- COMMAND ----------

-- 4. How many Italian dishes are on the menu 
SELECT COUNT(item_name) FROM menu_items
WHERE category = "Italian";

-- COMMAND ----------

-- 5. What are the most and least expensive Italian dishes on the 

-- Most expensive
SELECT item_name, category, price FROM menu_items
WHERE category = "Italian"
ORDER BY price DESC;

-- COMMAND ----------

-- Least expensive
SELECT item_name, category, price FROM menu_items
WHERE category = "Italian"
ORDER BY price;

-- COMMAND ----------

-- 6. How many dishe are in each category 
SELECT category, COUNT(category) FROM menu_items
GROUP BY category;

-- COMMAND ----------

-- 7. What is the average dish price within each category 
SELECT category, AVG(price) FROM menu_items
GROUP BY category;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Objective 2: Explore the orders table 
-- MAGIC - View the order_details table. What is the date range of the table 
-- MAGIC - How many order were made within this date range?
-- MAGIC - Which orders had the most number of items?
-- MAGIC - How many orders had more than 12 items?

-- COMMAND ----------

describe order_details;

-- COMMAND ----------

-- 1. View the table 
SELECT * FROM order_details
LIMIT 10;

-- COMMAND ----------

-- 2. What is the date range of the table 
-- SELECT MIN(order_date), MAX(order_date) FROM order_details

-- First order date
SELECT order_date FROM order_details
ORDER BY order_details_id
LIMIT 1;

-- COMMAND ----------

-- Last order date
SELECT order_date FROM order_details
ORDER BY order_details_id DESC
LIMIT 1;

-- COMMAND ----------

-- 3. How many orders we made within this date range
SELECT COUNT(DISTINCT order_id) FROM order_details;

-- COMMAND ----------

-- 4. How many items were ordered within this date range
SELECT COUNT(*) FROM order_details;

-- COMMAND ----------

-- 5. Whcih orders had the most number of items
SELECT order_id, COUNT(item_id) AS num_items FROM order_details
GROUP BY order_id
ORDER BY num_items DESC
LIMIT 10;

-- COMMAND ----------

-- 6. How many orders had more than 12 items
SELECT COUNT(*) FROM
(SELECT order_id, COUNT(item_id) AS num_items FROM order_details
GROUP BY order_id
HAVING num_items > 12);

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Objective 3: Analyze customer behavior 
-- MAGIC - Combine the menu_items and order_details tables into one table 
-- MAGIC - What were the least and most ordered items? What category were they in?
-- MAGIC - What were the top 5 orders that spent the mot money?
-- MAGIC - View the details of the highest spend order. What insights can you gather from the results?
-- MAGIC - View the details of top 5 highest spend orders. What insights can you gather from the results?

-- COMMAND ----------

-- 1. Combine the menu_items and order_details tables into one table 
SELECT * FROM order_details od 
LEFT JOIN menu_items mi 
ON od.item_id = mi.menu_item_id
LIMIT 10;

-- COMMAND ----------

-- 2. What were the least and most ordered items? What category were they in?

-- Least ordered items
SELECT item_name, category, COUNT(order_details_id) FROM order_details od 
LEFT JOIN menu_items mi 
ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY COUNT(order_details_id);

-- COMMAND ----------

-- Most ordered 
SELECT item_name, category, COUNT(order_details_id) FROM order_details od 
LEFT JOIN menu_items mi 
ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY COUNT(order_details_id) DESC;

-- COMMAND ----------

-- 3. What were the top 5 orders that spent the most money?
SELECT order_id, SUM(price) AS TotalSpend FROM order_details od 
LEFT JOIN menu_items mi 
ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY TotalSpend DESC
LIMIT 5;

-- COMMAND ----------

-- 4. View the details of the highest spend order. What insights can you gather from the results?
SELECT category, COUNT(od.item_id) FROM order_details od 
LEFT JOIN menu_items mi 
ON od.item_id = mi.menu_item_id
WHERE od.order_id = 440
GROUP BY category;

-- COMMAND ----------

-- 5. View the details of the highest spend order. What insights can you gather from the results?
SELECT category, COUNT(od.item_id) FROM order_details od 
LEFT JOIN menu_items mi 
ON od.item_id = mi.menu_item_id
WHERE od.order_id IN (440, 2075, 19557, 330, 2675)
GROUP BY category;

-- COMMAND ----------

-- Break the result table from above down a little 
SELECT order_id, category, COUNT(od.item_id) FROM order_details od 
LEFT JOIN menu_items mi 
ON od.item_id = mi.menu_item_id
WHERE od.order_id IN (440, 2075, 19557, 330, 2675)
GROUP BY order_id, category;

-- COMMAND ----------

