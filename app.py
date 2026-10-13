"""Dashboard local do projeto Olist; requer dados/mensal.csv exportado do PostgreSQL."""
from pathlib import Path
import pandas as pd
import plotly.express as px
import streamlit as st

st.set_page_config(page_title="Olist | Vendas", layout="wide")
st.title("Olist | Análise de vendas")
st.caption("Pedidos entregues · Receita dos produtos, sem frete · Data da compra")
path = Path(__file__).parent / "dados" / "mensal.csv"
if not path.exists():
    st.info("Para visualizar os dados reais, execute sql/04_export_dashboard.sql no pgAdmin e exporte o resultado como dados/mensal.csv.")
    st.stop()
df = pd.read_csv(path, sep=None, engine="python", encoding="utf-8-sig")
expected = {"mes", "pedidos", "receita", "ticket_medio"}
if not expected.issubset(df.columns):
    st.error(f"Colunas ausentes no CSV: {', '.join(sorted(expected - set(df.columns)))}")
    st.stop()
for col in ["pedidos", "receita", "ticket_medio"]:
    df[col] = pd.to_numeric(df[col], errors="coerce")
df["mes_data"] = pd.to_datetime(df["mes"].astype(str) + "-01", errors="coerce")
df = df.dropna(subset=["mes_data", "receita", "pedidos"]).sort_values("mes_data")
if df.empty:
    st.warning("O arquivo não contém linhas válidas.")
    st.stop()
periodos = df["mes"].tolist()
inicio, fim = st.select_slider("Período", options=periodos, value=(periodos[0], periodos[-1]))
view = df[(df["mes"] >= inicio) & (df["mes"] <= fim)].copy()
receita = view["receita"].sum()
pedidos = int(view["pedidos"].sum())
ticket = receita / pedidos if pedidos else 0
c1, c2, c3 = st.columns(3)
c1.metric("Receita dos produtos (R$)", f"{receita:,.2f}")
c2.metric("Pedidos entregues", f"{pedidos:,}")
c3.metric("Ticket médio (R$)", f"{ticket:,.2f}")
st.plotly_chart(px.line(view, x="mes", y="receita", markers=True, title="Receita mensal"), use_container_width=True)
st.plotly_chart(px.bar(view, x="mes", y="pedidos", title="Pedidos mensais"), use_container_width=True)
st.dataframe(view[["mes", "pedidos", "receita", "ticket_medio"]], use_container_width=True, hide_index=True)
st.caption("O ticket médio do período é calculado como receita total dividida por pedidos totais; não é a média simples dos tickets mensais.")
