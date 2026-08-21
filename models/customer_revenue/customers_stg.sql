{{  config(materialized='table') }}

select customerid as CUSTOMER_ID,
  concat(FIRSTNAME, ' ', LASTNAME) as customer_name,
   EMAIL, 
   PHONE, 
   ADDRESS, 
   CITY, 
   STATE, 
   ZIPCODE as zip_code, 
   UPDATED_AT
from {{source('landing', 'customers')}}
