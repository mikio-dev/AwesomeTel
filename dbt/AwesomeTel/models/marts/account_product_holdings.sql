SELECT ai.account_id,
       ai.language,
       ai.gender,
       ai.birthday,
       ai.zip_code,
       ai.payment_method,
       ai.age,
       ph.subscription_id,
       ph.product_family,
       ph.product_name,
       ph.product_price,
       ph.valid_from,
       ph.valid_to,
       CASE WHEN valid_to < '9999-12-31' 
            THEN ph.valid_to - ph.valid_from
            ELSE CURRENT_DATE - ph.valid_from
        END as tenure,
       CASE WHEN valid_to < '9999-12-31' 
            THEN TRUE
            ELSE FALSE
        END as is_churned,
       CASE WHEN valid_to < '9999-12-31' 
            THEN ph.valid_to
            ELSE NULL
        END as churned_date
  FROM {{ ref('account_info') }} ai
  LEFT JOIN {{ ref('product_holdings') }} ph
    ON ai.account_id = ph.account_id
 ORDER BY ai.account_id, ph.valid_from