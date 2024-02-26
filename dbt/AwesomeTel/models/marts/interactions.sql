
SELECT account_id::varchar as account_id,
       date::date,
       time_in_queue::int as time_in_queue,
       handling_time_s::int as handling_time_s,
       call_reason,
       customer_satisfaction_after_call
  FROM {{ source('input', 'interactions') }}
 WHERE account_id IS NOT NULL  
   AND date IS NOT NULL  
   AND time_in_queue IS NOT NULL
   AND time_in_queue > 0
   AND handling_time_s IS NOT NULL
   AND handling_time_s > 0
   AND date::date <= current_date
