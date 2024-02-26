WITH accounts as (
    SELECT DISTINCT
           ai.account_id,
           ai.language,
           ai.gender,
           ai.birthday,
           ai.zip_code,
           ai.payment_method,
           ai.age,
           min(ph.valid_from) over(partition by ai.account_id) as first_purchase_date,
           max(ph.valid_to) over(partition by ai.account_id) as last_terminate_date
      FROM {{ ref('account_info') }} ai
      LEFT JOIN {{ ref('product_holdings') }} ph
        ON ai.account_id = ph.account_id
)
SELECT a.*,
       CASE WHEN last_terminate_date < '9999-12-31' 
            THEN last_terminate_date - first_purchase_date
            ELSE CURRENT_DATE - first_purchase_date
        END as tenure,
       CASE WHEN last_terminate_date < '9999-12-31' 
            THEN TRUE
            ELSE FALSE
        END as is_churned,
       CASE WHEN last_terminate_date < '9999-12-31' 
            THEN last_terminate_date
            ELSE NULL
        END as churned_date
  FROM accounts a
 ORDER BY a.account_id