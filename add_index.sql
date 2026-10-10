CREATE INDEX idx_customer_zip ON customers(customer_zip_code_prefix);
CREATE INDEX idx_seller_zip ON sellers(seller_zip_code_prefix);
CREATE INDEX idx_geolocation_zip ON geolocation(geolocation_zip_code_prefix);

CREATE INDEX idx_order_customer ON orders(customer_id);
CREATE INDEX idx_order_time ON orders(order_purchase_timestamp, order_delivered_customer_date);

CREATE INDEX idx_order_item_order ON order_items(order_id);
CREATE INDEX idx_order_item_product ON order_items(product_id);
CREATE INDEX idx_order_item_seller ON order_items(seller_id);

CREATE INDEX idx_order_payment ON order_payments(order_id, payment_type);

CREATE INDEX idx_order_review_order ON order_reviews(order_id);
CREATE INDEX idx_order_review_date_score ON order_reviews(review_creation_date DESC, review_score DESC);

CREATE INDEX idx_lead_closed_segment ON leads_closed(lead_type, business_segment);
CREATE INDEX idx_lead_qualified_date ON leads_qualified(first_contact_date, origin);

CREATE INDEX idx_product_category ON products(product_category_name);