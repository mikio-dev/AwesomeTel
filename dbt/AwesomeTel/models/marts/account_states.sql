SELECT account_id,
       date as call_date,
       lead(date) OVER (PARTITION BY account_id ORDER BY date) as next_call_date,
       call_reason,
       customer_satisfaction_after_call,
       time_in_queue,
       handling_time_s,
       CASE WHEN call_reason = 'Billing' 
            THEN customer_satisfaction_after_call
            ELSE NULL
        END as satisfaction_billing,
       CASE WHEN call_reason = 'Churn' 
            THEN customer_satisfaction_after_call
            ELSE NULL
        END as satisfaction_churn,
       CASE WHEN call_reason = 'Product' 
            THEN customer_satisfaction_after_call
            ELSE NULL
        END as satisfaction_product,
       CASE WHEN call_reason = 'Technical' 
            THEN customer_satisfaction_after_call
            ELSE NULL
        END as satisfaction_technical
  FROM {{ ref('interactions') }}
