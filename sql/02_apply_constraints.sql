--------------------------------------------------------------------------------
-- SECTION 1: ADD PRIMARY KEYS 
--------------------------------------------------------------------------------

ALTER TABLE bronze.customers
    ADD CONSTRAINT pk_customers PRIMARY KEY (customer_id);

alter table bronze.geolocation
add constraint pk_geolocation_id  primary key (geolocation_id);

ALTER TABLE bronze.order_items
    ADD CONSTRAINT pk_order_items PRIMARY KEY (order_id, order_item_id);

ALTER TABLE bronze.order_payments
    ADD CONSTRAINT pk_order_payments PRIMARY KEY (order_id, payment_sequential);

ALTER TABLE bronze.order_reviews
    ADD CONSTRAINT pk_order_reviews_composite PRIMARY KEY (review_id, order_id);

ALTER TABLE bronze.orders
    ADD CONSTRAINT pk_orders PRIMARY KEY (order_id);

ALTER TABLE bronze.products
   ADD CONSTRAINT pk_products PRIMARY KEY (product_id);

ALTER TABLE bronze.sellers
    ADD CONSTRAINT pk_sellers PRIMARY KEY (seller_id);

ALTER TABLE bronze.product_category_translation
    ADD CONSTRAINT pk_product_category_translation PRIMARY KEY (product_category_name);

--------------------------------------------------------------------------------
-- SECTION 2: ADD FOREIGN KEYS 
--------------------------------------------------------------------------------

ALTER TABLE bronze.orders 
    ADD CONSTRAINT fk_orders_customer_id FOREIGN KEY (customer_id) 
    REFERENCES bronze.customers(customer_id);

ALTER TABLE bronze.order_items 
    ADD CONSTRAINT fk_order_items_order_id FOREIGN KEY (order_id) 
    REFERENCES bronze.orders(order_id);

ALTER TABLE bronze.order_items 
    ADD CONSTRAINT fk_order_items_product_id FOREIGN KEY (product_id) 
    REFERENCES bronze.products(product_id);

ALTER TABLE bronze.order_items 
    ADD CONSTRAINT fk_order_items_seller_id FOREIGN KEY (seller_id) 
    REFERENCES bronze.sellers(seller_id);

ALTER TABLE bronze.order_payments 
    ADD CONSTRAINT fk_order_payments_order_id FOREIGN KEY (order_id) 
    REFERENCES bronze.orders(order_id);

ALTER TABLE bronze.order_reviews 
    ADD CONSTRAINT fk_order_reviews_order_id FOREIGN KEY (order_id) 
    REFERENCES bronze.orders(order_id);



--
select distinct p.product_category_name  from bronze.products AS p
left join bronze.product_category_translation AS t
on p.product_category_name=t.product_category_name
where p.product_category_name is not null
and t.product_category_name IS NULL


--inserting value
insert into bronze.product_category_translation 
(product_category_name, product_category_name_english)
values ('other_category','Other Category')

--updating bronze.product_category_translation 
update bronze.products 
set product_category_name='other_category'
where product_category_name in( select distinct p.product_category_name from  bronze.product_category_translation pct
right join bronze.products p
on pct.product_category_name =p.product_category_name
where  p.product_category_name is not null
and pct.product_category_name is null
)

alter table bronze.products add constraint fk_product_cat
foreign key (product_category_name)
references  bronze.product_category_translation(product_category_name)