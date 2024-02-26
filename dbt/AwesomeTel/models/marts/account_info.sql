
SELECT account_id::varchar as account_id,
       UPPER(language) as language,
       UPPER(gender) as gender,
       birthday::date as birthday,
       zip_code::varchar as zip_code,
       payment_method,
       DATE_PART('year', age(current_timestamp, birthday::timestamp))::int as age
  FROM {{ source('input', 'account_info') }}
 WHERE account_id IS NOT NULL
   AND gender IS NOT NULL
   AND birthday IS NOT NULL
   AND birthday::date > '1900-01-01'
   AND zip_code IS NOT NULL
   AND zip_code::varchar between '1000' and '9999'
   AND payment_method IS NOT NULL


