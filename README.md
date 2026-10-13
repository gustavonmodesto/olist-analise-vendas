# Olist | Análise de Vendas com PostgreSQL e Python

**Projeto de portfólio.** Análise de dados públicos de e-commerce com foco em indicadores de vendas, sazonalidade, categorias e distribuição geográfica.

## Contexto e objetivo
Transformar registros transacionais em indicadores de negócio: pedidos entregues, receita de produtos (sem frete), ticket médio, faturamento por categoria/estado e evolução mensal. O objetivo é demonstrar modelagem de consultas, JOINs, agregações, CTEs e funções de janela.

## Fonte dos dados
**Olist Brazilian E-Commerce Public Dataset** (Kaggle). Este repositório **não distribui** os dados originais. O banco local utilizado no estudo contém as tabelas `customers`, `orders`, `order_items` e `products`.

## Estrutura
- `sql/01_validacao.sql`: contagens e status dos pedidos.
- `sql/02_indicadores.sql`: KPIs gerais, por estado e por categoria.
- `sql/03_evolucao_mensal.sql`: CTE, `LAG` e crescimento mensal.
- `sql/04_export_dashboard.sql`: extrato para o dashboard.
- `app.py`: dashboard Streamlit que lê o CSV exportado.
- `requirements.txt`: dependências do dashboard.

## Como executar
1. Configure PostgreSQL e importe as quatro tabelas do dataset Olist com os nomes citados acima.
2. Execute os scripts na ordem no pgAdmin Query Tool.
3. Execute `sql/04_export_dashboard.sql` e exporte o resultado (com cabeçalhos) para `dados/mensal.csv` em formato CSV.
4. No terminal, dentro da pasta do projeto, execute `pip install -r requirements.txt` e depois `streamlit run app.py`.
5. Confirme a coerência das métricas com as consultas no pgAdmin antes de divulgar números ou capturas do dashboard.

## Regras de negócio
- Apenas `order_status = 'delivered'`.
- Receita = `SUM(order_items.price)`; não inclui frete, descontos ou custos.
- Pedidos = `COUNT(DISTINCT orders.order_id)` para evitar duplicação pelo JOIN com itens.
- Ticket médio = receita / quantidade de pedidos distintos.
- A data mensal utiliza `order_purchase_timestamp`, não a data de entrega.
- A taxa mensal compara somente meses consecutivos; quando o mês calendário anterior está ausente, retorna `NULL`.

## Evidências e limitações
As consultas básicas de vendas, agrupamentos e ticket médio foram praticadas no PostgreSQL durante o estudo. Os scripts completos e o aplicativo foram preparados para publicação, mas **não foram executados nesta entrega contra o banco local do autor**. Os resultados devem ser validados no computador com a base restaurada. O dashboard em Streamlit é uma alternativa de visualização; não é um arquivo Power BI (`.pbix`).

## Próximas melhorias
- Validar os scripts e registrar capturas reais dos resultados.
- Conferir consistência temporal e qualidade dos dados.
- Expandir análise de categorias, geografia e sazonalidade.
- Construir versão no Power BI e publicar imagens autorizadas.

## Autor
Gustavo Nunes Modesto — Engenharia de Software | Dados e BI.
