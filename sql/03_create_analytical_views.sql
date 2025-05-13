-- creating a view of order summery( for deliverd)
create view bronze.order_performance_summery as 
select	    o.order_id,
			o.order_purchase_timestamp,
			o.order_status,
			o.order_delivered_customer_date,
			o.order_estimated_delivery_date,
			extract(day from (o.order_delivered_customer_date -o.order_purchase_timestamp)) as actual_delivery_days,
			case 
				when  o.order_delivered_customer_date<=o.order_estimated_delivery_date 
				then 'On Time' 
				else 'Delayed'
			end as delivery_status,
			op.payment_type,
			op.payment_Installments,
			op.payment_value,
			count(oi.product_id) as items_count,
			sum(oi.price ) as order_product_value,
			sum(oi.freight_value) as order_freight_value,
			sum(oi.price+oi.freight_value) as order_total_value,
 			orv.review_score
from bronze.orders o 
left join bronze.order_payments as op on o.order_id=op.order_id
left join bronze.order_reviews as orv on o.order_id=orv.order_id
left join bronze.order_items as oi on o.order_id=oi.order_id
where o.order_status ='delivered'
group by o.order_id, o.order_status,o.order_purchase_timestamp,o.order_delivered_customer_date,
			o.order_estimated_delivery_date,op.payment_type,
			op.payment_Installments,
			op.payment_value,orv.review_score;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- creating view for product category Performance
create view bronze.product_category_performance as 
select pc.product_category_name_english as category_name,
		count(distinct ot.order_id) as order_count,
		count(p.product_id) as  itmes_sold,
		count(distinct p.product_id) as unique_products,
		round(avg(orv.review_score)) as avg_review_score,
		SUM(ot.price) AS total_revenue,
    	SUM(ot.freight_value) AS total_freight,
    	ROUND(AVG(ot.price), 2) AS avg_price,
		ROUND(AVG(EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))), 2) AS avg_delivery_days
from bronze.order_items as ot
join bronze.products as p on ot.product_id=p.product_id
left join bronze.product_category_translation as pc on p.product_category_name=pc.product_category_name
join bronze.orders as o on ot.order_id=o.order_id
left join bronze.order_reviews as orv on o.order_id=orv.order_id
where o.order_status='delivered' and 
	  pc.product_category_name_english is not null and
	  pc.product_category_name is not null
group by pc.product_category_name_english
order by total_revenue desc

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--customer geographic analysis
create view bronze.customer_geographic_analysis as
select 
		c.customer_state,
		count (distinct o.order_id) as order_count,
		count (distinct c.customer_id) as customer_count,
		round(avg(orv.review_score),2) as avg_review_score,
		round(avg(payment.payment_value),2) as avg_order_value,
		ROUND(AVG(EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))), 2) AS avg_delivery_days,
		sum(payment.payment_value) as total_revenue
from bronze.customers as c
join bronze.orders as o on c.customer_id=o.customer_id
left join bronze.order_reviews as orv on o.order_id=orv.order_id
left join (select order_id,
			sum(payment_value) as payment_value 
			from bronze.order_payments 
			group by 
			       order_id ) payment on o.order_id=payment.order_id
where 
	o.order_status = 'delivered'
	group by c.customer_state
	order by total_revenue desc
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--seller performance analysis
create view bronze.seller_performance_analysis as
select s.seller_id,
		s.seller_state,
		count (distinct ot.order_id ) as orders_count,
		count(ot.product_id) as product_sold,
		round(avg(orv.review_score),2) as avg_review_score,
		sum(ot.price) as total_revenue,
		ROUND(AVG(EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))), 2) AS avg_delivery_days,
		ROUND(
        SUM(CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 1 ELSE 0 END)::DECIMAL / 
        COUNT(DISTINCT ot.order_id) * 100, 2
    ) AS on_time_delivery_rate
from bronze.sellers as s 
 join bronze.order_items  as ot on s.seller_id= ot.seller_id
 join bronze.orders as o on ot.order_id=o.order_id
 left join bronze.order_reviews as orv on o.order_id=orv.order_id
 where o.order_status='delivered'
 group by s.seller_id,
		s.seller_state
order by total_revenue DESC