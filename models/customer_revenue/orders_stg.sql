select orderid as ORDER_ID,
  customerid as CUSTOMER_ID,
  orderdate as order_date,
  employeeid as employee_id,
  storeid as store_id,
  status as order_status,
  case when status ='01' then 'In Progress'
      when status ='02' then 'Completed'
      when status ='03' then 'Cancelled'
  end as order_status_desc,
  case when store_id=1000 then 'Online'
       else 'in-store'
  end as order_channel,
  updated_at,
  current_timestamp  as dbt_updated_at 
from {{source('landing', 'orders')}}