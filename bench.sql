-- Q1: idx_customer_zip ------------------------------------------------
\set zip random(1000, 99999)
SELECT customer_id, customer_city, customer_state
FROM customers
WHERE customer_zip_code_prefix = :zip;

-- Q2: idx_order_time --------------------------------------------------
SELECT order_id, order_status, order_purchase_timestamp
FROM orders
WHERE order_purchase_timestamp >= '2017-01-01'
  AND order_purchase_timestamp <  '2018-01-01'
ORDER BY order_purchase_timestamp
LIMIT 100;

-- Q3: idx_order_item_product ------------------------------------------
\set prod_off random(0, 30000)
WITH p AS (
  SELECT product_id FROM products OFFSET :prod_off LIMIT 1
)
SELECT oi.order_id, oi.price, oi.freight_value
FROM order_items oi
WHERE oi.product_id = (SELECT product_id FROM p);

-- Q4: idx_order_review_date_score -------------------------------------
SELECT review_id, order_id, review_score, review_creation_date
FROM order_reviews
WHERE review_creation_date >= '2018-01-01'
  AND review_score = '5'
ORDER BY review_creation_date DESC, review_score DESC
LIMIT 50;

-- Q5: idx_lead_closed_segment -----------------------------------------
\set seg_off random(0, 800)
WITH s AS (
  SELECT lead_type, business_segment FROM leads_closed
  WHERE lead_type IS NOT NULL AND business_segment IS NOT NULL
  OFFSET :seg_off LIMIT 1
)
SELECT lc.mql_id, lc.seller_id, lc.won_date, lc.business_segment
FROM leads_closed lc, s
WHERE lc.lead_type = s.lead_type
  AND lc.business_segment = s.business_segment
LIMIT 100;