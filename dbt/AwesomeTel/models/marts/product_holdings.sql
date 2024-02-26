
SELECT DISTINCT
       account_id::varchar as account_id,
       subscription_id::varchar as subscription_id,
       product_family,
       product_name,
       product_price::numeric(38, 2) as product_price,
       valid_from::date as valid_from,
       valid_to:: date as valid_to 
  FROM {{ source('input', 'product_holdings') }}
 WHERE account_id IS NOT NULL
   AND subscription_id IS NOT NULL
   AND product_family IS NOT NULL
   AND product_name IS NOT NULL
   AND product_price IS NOT NULL
   AND valid_from IS NOT NULL
   AND valid_to IS NOT NULL
   AND valid_from < valid_to
