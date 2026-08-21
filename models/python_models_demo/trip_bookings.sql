select 
TRAVELLER_ID, 
TRAVELLER_NAME, 
BOOKING_ID, 
BOOKING_AMOUNT
from {{ source('training', 'trip_bookings')}}