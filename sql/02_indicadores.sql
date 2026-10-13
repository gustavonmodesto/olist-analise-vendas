-- Indicadores de pedidos entregues. Receita = soma dos preços dos itens, SEM frete.
-- Não somar pedidos após JOIN com itens sem COUNT(DISTINCT), pois um pedido pode ter vários itens.
SELECT
  COUNT(DISTINCT o.order_id) AS pedidos_entregues,
  COUNT(*) AS itens_vendidos,
  ROUND(SUM(oi.price), 2) AS receita_produtos,
  ROUND(SUM(oi.price) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS ticket_medio_produtos
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- Receita por estado (localização do cliente)
SELECT c.customer_state AS estado,
       COUNT(DISTINCT o.order_id) AS pedidos,
       ROUND(SUM(oi.price), 2) AS receita,
       ROUND(SUM(oi.price) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS ticket_medio
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY receita DESC;

-- Receita por categoria (categoria pode ser NULL)
SELECT COALESCE(p.product_category_name, 'sem_categoria') AS categoria,
       COUNT(DISTINCT o.order_id) AS pedidos,
       ROUND(SUM(oi.price), 2) AS receita
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'delivered'
GROUP BY COALESCE(p.product_category_name, 'sem_categoria')
ORDER BY receita DESC;
