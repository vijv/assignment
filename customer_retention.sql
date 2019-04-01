-- Assumption: transaction_date is of DATE type
WITH first_txn AS (
  SELECT
    user_id,
    MIN(transaction_date) AS min_txn_date
  FROM
    raw_transactions
  GROUP BY
    user_id
)
SELECT
  DATE_TRUNC('month', g.min_txn_date) AS activation_month,
  -- below metrics can be rounded and casted to varchar to display as
  -- percentage if required
  COUNT_IF(month_num = 1) * 1.0/COUNT_IF(month_num = 0) AS "first_month",
  COUNT_IF(month_num = 2) * 1.0/COUNT_IF(month_num = 0) AS "second_month",
  COUNT_IF(month_num = 3) * 1.0/COUNT_IF(month_num = 0) AS "third_month",
  COUNT_IF(month_num = 4) * 1.0/COUNT_IF(month_num = 0) AS "gt_third_month"
FROM (
  SELECT
    raw.user_id,
    first_txn.min_txn_date,
    CASE
      WHEN raw.transaction_date = first_txn.min_txn_date THEN 0
      WHEN raw.transaction_date BETWEEN DATE_ADD('day', 1, first_txn.min_txn_date)
        AND DATE_ADD('month', 1, first_txn.min_txn_date) THEN 1
      WHEN raw.transaction_date BETWEEN DATE_ADD('day', 1, DATE_ADD('month', 1, first_txn.min_txn_date))
        AND DATE_ADD('month', 2, first_txn.min_txn_date) THEN 2
      WHEN raw.transaction_date BETWEEN DATE_ADD('day', 1, DATE_ADD('month', 2, first_txn.min_txn_date))
        AND DATE_ADD('month', 3, first_txn.min_txn_date) THEN 3
      ELSE 4  -- for greather than 3rd retention month
    END AS month_num
  FROM
    raw_transactions raw
  JOIN
    first_txn
  ON
    raw.user_id = first_txn.user_id
  GROUP BY
    1, 2, 3
    -- group by is needed as a user can have more than one transaction in a month
) g
GROUP BY
  1
