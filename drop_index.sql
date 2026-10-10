DROP INDEX IF EXISTS idx_customer_zip;
DROP INDEX IF EXISTS idx_seller_zip;
DROP INDEX IF EXISTS idx_geolocation_zip;

DROP INDEX IF EXISTS idx_order_customer;
DROP INDEX IF EXISTS idx_order_time;

DROP INDEX IF EXISTS idx_order_item_order;
DROP INDEX IF EXISTS idx_order_item_product;
DROP INDEX IF EXISTS idx_order_item_seller;

DROP INDEX IF EXISTS idx_order_payment;

DROP INDEX IF EXISTS idx_order_review_order;
DROP INDEX IF EXISTS idx_order_review_date_score;

DROP INDEX IF EXISTS idx_lead_closed_segment;
DROP INDEX IF EXISTS idx_lead_qualified_date;

DROP INDEX IF EXISTS idx_product_category;
