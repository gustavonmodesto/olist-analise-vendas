-- Evolução mensal, variação percentual e mês anterior.
-- LAG compara com a linha anterior disponível, não necessariamente mês calendário anterior.
WITH vendas_mensais AS (
    SELECT DATE_TRUNC('month', o.order_purchase_timestamp)::date AS mes_data,
           COUNT(DISTINCT o.order_id) AS pedidos,
           ROUND(SUM(oi.price), 2) AS receita,
           ROUND(SUM(oi.price) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS ticket_medio
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)::date
), comparativo AS (
    SELECT mes_data, pedidos, receita, ticket_medio,
           LAG(receita) OVER (ORDER BY mes_data) AS receita_periodo_anterior,
           LAG(mes_data) OVER (ORDER BY mes_data) AS data_periodo_anterior
    FROM vendas_mensais
)
SELECT TO_CHAR(mes_data, 'YYYY-MM') AS mes, pedidos, receita, ticket_medio,
       receita_periodo_anterior,
       CASE WHEN data_periodo_anterior = (mes_data - INTERVAL '1 month')::date
                  AND receita_periodo_anterior <> 0
            THEN ROUND(100.0 * (receita - receita_periodo_anterior) / receita_periodo_anterior, 2)
            ELSE NULL END AS crescimento_mensal_pct
FROM comparativo
ORDER BY mes_data;
