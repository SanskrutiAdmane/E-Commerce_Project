# Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

select kpil.day_end,round((kpil.total_pmt/(select sum(payment_value) from
olist_order_payments_dataset))*100,2) as perc_pmtvalue
from
(select ord.day_end,sum(pmt.payment_value) as total_pmt
from olist_order_payments_dataset as pmt join
(select distinct(order_id),case when weekday(order_purchase_timestamp) in (5,6) then "Weekend"
else "Weekday" end as day_end from olist_orders_dataset) as ord on ord.order_id=pmt.order_id group by ord.day_end)
as kpil;


#Number of Orders with review score 5 and payment type as credit card.

select pmt.payment_type,count(pmt.order_id)
as total_orders from olist_order_payments_dataset as pmt join
(select distinct ord.order_id,rw.review_score from olist_orders_dataset as ord
join olist_order_reviews_dataset rw on ord.order_id=rw.order_id where review_score=5) as rw5
on pmt.order_id=rw5.order_id group by pmt.payment_type order by total_orders desc;


# Average number of days taken for order delivered customer date for pet_shop

select
prod.product_category_name,
round(avg(datediff(ord.order_delivered_customer_date , ord.order_purchase_timestamp)) , 0) as Avg_delivery_days
from olist_orders_dataset ord
join
(SELECT product_id , Order_id , product_category_name
from olist_products_dataset
join olist_order_items_dataset using(product_id)) as prod
on ord.order_id = prod.order_id
where prod.product_category_name = "Pet_shop"
group by prod.product_category_name ;


# Average price and payment values from customers of sao paulo city

WITH orderItemsAvg AS 
(
Select round(AVG(item.price)) AS Average_price
from olist_order_items_dataset item
join olist_orders_dataset ord ON item.order_id = ord.order_id
join olist_customers_dataset cust ON ord.customer_id = cust.customer_id
where cust.customer_city = "Sao Paulo"
)
select
(select Average_price from orderItemsAvg) AS Average_price,
round(AVG(pmt.payment_value)) AS Average_payment_value
from olist_order_payments_dataset pmt
Join olist_orders_dataset ord ON pmt.order_id = ord.order_id
join olist_customers_dataset cust ON ord.customer_id = cust.customer_id
where cust.customer_city = "Sao Paulo";



#Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

select rw.review_score,
round(avg(datediff(ord.order_delivered_customer_date,ord.order_purchase_timestamp)),0)
as avg_shipping_days
from olist_orders_dataset as ord join olist_order_reviews_dataset rw on 
rw.order_id=ord.order_id group by rw.review_score order by rw.review_score;



