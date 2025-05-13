-- Table: bronze.customers
CREATE TABLE IF NOT EXISTS bronze.customers (
    customer_id VARCHAR(50) ,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR(100),
    customer_state VARCHAR(2)
);

-- Table: bronze.geolocation
CREATE TABLE IF NOT EXISTS bronze.geolocation (
    geolocation_zip_code_prefix INTEGER,
    geolocation_lat NUMERIC(11,8), 
    geolocation_lng NUMERIC(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2),
    geolocation_id SERIAL 
);

-- Table: bronze.order_items
CREATE TABLE IF NOT EXISTS bronze.order_items (
    order_id VARCHAR(50),
    order_item_id INTEGER,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP WITHOUT TIME ZONE,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2)
    
);

-- Table: bronze.order_payments
CREATE TABLE IF NOT EXISTS bronze.order_payments (
    order_id VARCHAR(50),
    payment_sequential INTEGER,
    payment_type VARCHAR(30),
    payment_installments INTEGER,
    payment_value NUMERIC(10,2)
    
);

-- Table: bronze.order_reviews
CREATE TABLE IF NOT EXISTS bronze.order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INTEGER,
    review_comment_title VARCHAR(100),
    review_comment_message TEXT,
    review_creation_date TIMESTAMP WITHOUT TIME ZONE,
    review_answer_timestamp TIMESTAMP WITHOUT TIME ZONE
    -- Composite Primary Key (review_id, order_id) will be added in 02_apply_constraints.sql
);

-- Table: bronze.orders
CREATE TABLE IF NOT EXISTS bronze.orders (
    order_id VARCHAR(50) ,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP WITHOUT TIME ZONE,
    order_approved_at TIMESTAMP WITHOUT TIME ZONE,
    order_delivered_carrier_date TIMESTAMP WITHOUT TIME ZONE,
    order_delivered_customer_date TIMESTAMP WITHOUT TIME ZONE,
    order_estimated_delivery_date TIMESTAMP WITHOUT TIME ZONE
);

-- Table: bronze.products
CREATE TABLE IF NOT EXISTS bronze.products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght DOUBLE PRECISION, 
    product_description_lenght DOUBLE PRECISION,  
    product_photos_qty DOUBLE PRECISION,
    product_weight_g DOUBLE PRECISION,
    product_length_cm DOUBLE PRECISION,
    product_height_cm DOUBLE PRECISION,
    product_width_cm DOUBLE PRECISION
);

-- Table: bronze.sellers
CREATE TABLE IF NOT EXISTS bronze.sellers (
    seller_id VARCHAR(50) ,
    seller_zip_code_prefix INTEGER,
    seller_city VARCHAR(100),
    seller_state VARCHAR(2)
);

-- Table: bronze.product_category_translation
CREATE TABLE IF NOT EXISTS bronze.product_category_translation (
    product_category_name VARCHAR(100) ,
    product_category_name_english VARCHAR(100)
);
