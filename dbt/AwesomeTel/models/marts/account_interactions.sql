SELECT ac.account_id,
       ac.language,
       ac.gender,
       ac.birthday,
       ac.zip_code,
       ac.payment_method,
       ac.age,
       ac.first_purchase_date,
       ac.last_terminate_date,
       ac.tenure,
       ac.is_churned,
       ac.churned_date,
       CASE WHEN s1.account_id IS NOT NULL THEN TRUE ELSE FALSE END as has_call,
       s1.call_date,
       s1.next_call_date,
       s1.call_reason,
       s1.customer_satisfaction_after_call,
       s1.time_in_queue,
       s1.handling_time_s,
       s1.satisfaction_billing,
       s1.satisfaction_churn,
       s1.satisfaction_product,
       s1.satisfaction_technical
  FROM {{ ref('account_churn') }} ac
  LEFT JOIN {{ ref('account_states') }} s1
    ON ac.account_id = s1.account_id
   AND ac.churned_date - INTERVAL '1 MONTH' >= s1.call_date 
   AND ac.churned_date - INTERVAL '1 MONTH' < s1.next_call_date
 ORDER BY ac.account_id