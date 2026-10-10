ALTER TABLE products DROP CONSTRAINT IF EXISTS fk_products_category;
ALTER TABLE orders DROP CONSTRAINT IF EXISTS fk_orders_customer;
ALTER TABLE order_items DROP CONSTRAINT IF EXISTS fk_items_order;
ALTER TABLE order_items DROP CONSTRAINT IF EXISTS fk_items_product;
ALTER TABLE order_items DROP CONSTRAINT IF EXISTS fk_items_seller;
ALTER TABLE order_payments DROP CONSTRAINT IF EXISTS fk_payments_order;
ALTER TABLE order_reviews DROP CONSTRAINT IF EXISTS fk_reviews_order;
ALTER TABLE leads_closed DROP CONSTRAINT IF EXISTS fk_closed_mql;
ALTER TABLE leads_closed DROP CONSTRAINT IF EXISTS fk_closed_seller;

ALTER TABLE customers DROP CONSTRAINT IF EXISTS customers_pkey;
ALTER TABLE sellers DROP CONSTRAINT IF EXISTS sellers_pkey;
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_pkey;
ALTER TABLE product_category_name_translation DROP CONSTRAINT IF EXISTS product_category_name_translation_pkey;
ALTER TABLE leads_qualified DROP CONSTRAINT IF EXISTS leads_qualified_pkey;
ALTER TABLE leads_closed DROP CONSTRAINT IF EXISTS leads_closed_pkey;
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_pkey;
ALTER TABLE order_reviews DROP CONSTRAINT IF EXISTS order_reviews_pkey;
ALTER TABLE order_items DROP CONSTRAINT IF EXISTS order_items_pkey;
ALTER TABLE order_payments DROP CONSTRAINT IF EXISTS order_payments_pkey;
ALTER TABLE geolocation DROP CONSTRAINT IF EXISTS geolocation_pkey;

ALTER TABLE geolocation DROP COLUMN IF EXISTS geolocation_id;

ALTER TABLE customers ADD PRIMARY KEY (customer_id);
ALTER TABLE sellers ADD PRIMARY KEY (seller_id);
ALTER TABLE products ADD PRIMARY KEY (product_id);
ALTER TABLE product_category_name_translation ADD PRIMARY KEY (product_category_name);

ALTER TABLE leads_qualified ADD PRIMARY KEY (mql_id);
ALTER TABLE leads_closed ADD PRIMARY KEY (mql_id);

ALTER TABLE geolocation ADD COLUMN geolocation_id SERIAL PRIMARY KEY;

ALTER TABLE orders ADD PRIMARY KEY (order_id);

ALTER TABLE order_reviews ADD PRIMARY KEY (review_id, order_id);

ALTER TABLE order_items ADD PRIMARY KEY (order_id, order_item_id);
ALTER TABLE order_payments ADD PRIMARY KEY (order_id, payment_sequential);

ALTER TABLE products
ADD CONSTRAINT fk_products_category 
FOREIGN KEY (product_category_name) 
REFERENCES product_category_name_translation(product_category_name);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer 
FOREIGN KEY (customer_id) 
REFERENCES customers(customer_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_items_order 
FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_items_product
FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE order_items 
ADD CONSTRAINT fk_items_seller 
FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);

ALTER TABLE order_payments
ADD CONSTRAINT fk_payments_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE order_reviews
ADD CONSTRAINT fk_reviews_order 
FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE leads_closed
ADD CONSTRAINT fk_closed_mql 
FOREIGN KEY (mql_id) REFERENCES leads_qualified(mql_id);