SELECT datname FROM pg_database;

SELECT * FROM bronze.customers LIMIT 10; -- Added LIMIT for brevity in a checks file
SELECT * FROM bronze.order_items LIMIT 10;
SELECT * FROM bronze.order_payments LIMIT 10;
SELECT * FROM bronze.order_reviews LIMIT 10;
SELECT * FROM bronze.orders LIMIT 10;
SELECT * FROM bronze.geolocation LIMIT 10;
SELECT * FROM bronze.product_category_translation LIMIT 10;
SELECT * FROM bronze.sellers LIMIT 10;
SELECT * FROM bronze.products LIMIT 10;

--Open your terminal or command prompt.
--Navigate to the root directory of your project
--with psql connect to with your database and  then run \i sql/04_misc_data_checks_and_exports.sql

\copy (SELECT * FROM bronze.order_performance_summery) TO 'data/processed/order_performance.csv' WITH CSV HEADER;
\copy (SELECT * FROM bronze.product_category_performance) TO 'data/processed/product_category.csv' WITH CSV HEADER;
\copy (SELECT * FROM bronze.customer_geographic_analysis) TO 'data/processed/customer_geographic.csv' WITH CSV HEADER;
\copy (SELECT * FROM bronze.seller_performance_analysis) TO 'data/processed/seller_performance.csv' WITH CSV HEADER;