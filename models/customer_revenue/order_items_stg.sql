select orderid as ORDER_ID,
  orderitemid as order_item_id,
  productid as product_id,
  quantity,
  unitprice as unit_price,
  quantity * unitprice as total_price,
  updated_at
from {{source('landing', 'order_items')}}