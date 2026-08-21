{{ config(materialized = 'table')}}

with orders_revenue as 
  (select order_id, 
     sum(total_price) as revenue
    from {{ ref('order_items_stg')}}
    group by order_id)

select o.ORDER_ID,
   o.CUSTOMER_ID,
   o.order_date,
   o.employee_id,
   o.store_id,
   o.order_status,
   o.updated_at,
   r.revenue
from {{ref('orders_stg')}} as o
join orders_revenue as r
using(order_id)  
