-- Execute no pgAdmin e exporte o resultado como CSV: dados/mensal.csv
WITH mensal AS (
  SELECT DATE_TRUNC('month', o.order_purchase_timestamp)::date AS mes_data,
         COUNT(DISTINCT o.order_id) AS pedidos,
         ROUND(SUM(oi.price), 2) AS receita,
         ROUND(SUM(oi.price) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS ticket_medio
  FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY 1
)
SELECT TO_CHAR(mes_data, 'YYYY-MM') AS mes, pedidos, receita, ticket_medio
FROM mensal ORDER BY mes_data;
