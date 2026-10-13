-- Verificação inicial: execute após restaurar o banco Olist.
SELECT 'customers' AS tabela, COUNT(*) AS registros FROM customers
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'products', COUNT(*) FROM products;

SELECT order_status, COUNT(*) AS pedidos FROM orders GROUP BY order_status ORDER BY pedidos DESC;
