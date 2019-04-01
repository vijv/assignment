<JINJA>
-- set num_months variable as desired
{% set num_months = 4 %}
WITH first_txn AS (
  SELECT
    user_id,
    MIN(transaction_date) AS min_txn_date
  FROM
    vvij_test_raw
  GROUP BY
    user_id
)
SELECT
  {% for mon in range(1, num_months + 2) %}
      {% if mon == num_months + 1 %}
        {% set alias = 'gt_month_' ~ num_months %}
      {% else %}
        {% set alias = 'month_' ~ mon %}
      {% endif %}
      COUNT_IF(month_num = {{ mon }}) * 1.0/COUNT_IF(month_num = 0) AS "{{ alias }}",
  {% endfor %}
  DATE_TRUNC('month', g.min_txn_date) AS activation_month
FROM (
  SELECT
    raw.user_id,
    first_txn.min_txn_date,
    CASE
      WHEN raw.transaction_date = first_txn.min_txn_date THEN 0
      {% for mon in range(num_months) %}
          WHEN raw.transaction_date BETWEEN
            DATE_ADD('day', 1, DATE_ADD('month', {{ mon }}, first_txn.min_txn_date))
            AND DATE_ADD('month', {{ mon + 1 }}, first_txn.min_txn_date)
            THEN {{ mon + 1 }}
      {% endfor %}
      ELSE {{ num_months + 1 }}
    END AS month_num
  FROM
    vvij_test_raw raw
  JOIN
    first_txn
  ON
    raw.user_id = first_txn.user_id
  GROUP BY
    1, 2, 3
) g
GROUP BY
    DATE_TRUNC('month', g.min_txn_date)
</JINJA>
