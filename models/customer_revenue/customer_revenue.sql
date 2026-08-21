select c.customer_id,
  c.customer_name,
  count(1) as orders_count,
  sum(revenue) as revenue,

from {{ ref('customers_stg')}} c 
join {{ ref('orders_fact')}} o
using (customer_id)
group by c.customer_id,
   c.customer_name
   