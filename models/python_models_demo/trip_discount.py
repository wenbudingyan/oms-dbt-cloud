from snowflake.snowpark import functions as F
from snowflake.snowpark import Window

def model(dbt, session):
    dbt.config(materialized="table") 

    df = dbt.ref("trip_bookings")
    
    window_spec = Window.partitionBy("TRAVELLER_ID") \
                        .orderBy("TRAVELLER_ID", "BOOKING_ID") \
                        .rowsBetween(Window.UNBOUNDED_PRECEDING, Window.CURRENT_ROW)
    
    df_with_theoretical = df.withColumn(
        "THEORETICAL_DISCOUNT", 
        F.col("BOOKING_AMOUNT") * 0.1
    )
    
    df_with_cumulative = df_with_theoretical.withColumn(
        "CUMULATIVE_PREV_DISCOUNT",
        F.sum("THEORETICAL_DISCOUNT").over(window_spec) - F.col("THEORETICAL_DISCOUNT")
    )

    final_df = df_with_cumulative.withColumn(
        "DISCOUNT",
        F.least(  
            F.col("THEORETICAL_DISCOUNT"),
            # 👇 修复点：使用 F.lit() 将整数转换为 Column 对象
            F.greatest(F.lit(0), F.lit(100) - F.col("CUMULATIVE_PREV_DISCOUNT"))  
        )
      ).withColumn(
         "FINAL_AMOUNT",
         F.col("BOOKING_AMOUNT") - F.col("DISCOUNT")
        )
    
    
    result_df = final_df.select(
        F.col("TRAVELLER_ID"),
        F.col("TRAVELLER_NAME"),
        F.col("BOOKING_ID"),
        F.round(F.col("BOOKING_AMOUNT"), 2).alias("BOOKING_AMOUNT"),
        F.round(F.col("DISCOUNT"), 2).alias("DISCOUNT"),
        F.round(F.col("FINAL_AMOUNT"), 2).alias("FINAL_AMOUNT")
    )
    
    return result_df