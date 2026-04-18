import mysql.connector
import streamlit as st
import pandas as pd
import plotly.express as px

# Page config
st.set_page_config(page_title="Tennis Analytics", layout="wide")

# Title
st.title("🎾 Tennis Game Analytics Dashboard")

# DB Connection
connection = mysql.connector.connect(
    host='localhost',
    port=3306,
    user='root',
    password='Nanak@1469',
    database='game_analytics'
)

# Sidebar Filters
st.sidebar.header("🔍 Filters")

rank_range = st.sidebar.slider("Select Rank Range", 1, 100, (1, 10))
country_filter = st.sidebar.text_input("Enter Country")


# KPI SECTION (Homepage)


col1, col2, col3 = st.columns(3)

# Total Competitor
query1 = "SELECT COUNT(*) as total FROM competitor"
df1 = pd.read_sql(query1, connection)
col1.metric("Total Competitor", df1['total'][0])

# Total Countries
query2 = "SELECT COUNT(DISTINCT country) as total FROM competitor"
df2 = pd.read_sql(query2, connection)
col2.metric("Total Countries", df2['total'][0])

# Highest Points
query3 = """
SELECT MAX(points) as max_points FROM ranking
"""
df3 = pd.read_sql(query3, connection)
col3.metric("Highest Points", df3['max_points'][0])


# FILTERED DATA


query = f"""
SELECT c.name, c.country, r.rank, r.points
FROM competitor c
JOIN ranking r
ON c.competitor_id = r.competitor_id
WHERE r.rank BETWEEN {rank_range[0]} AND {rank_range[1]}
"""

if country_filter:
    query += f" AND c.country LIKE '%{country_filter}%'"

df = pd.read_sql(query, connection)

st.subheader("Filtered Competitor")
st.dataframe(df)


# CHARTS


# Top Players Bar Chart
st.subheader("Top Players by Points")

top_query = """
SELECT c.name, r.points
FROM competitor c
JOIN ranking r
ON c.competitor_id = r.competitor_id
ORDER BY r.points DESC
LIMIT 10
"""

top_df = pd.read_sql(top_query, connection)

fig1 = px.bar(top_df, x="name", y="points", title="Top 10 Players")
st.plotly_chart(fig1)

# Country Distribution
st.subheader("Competitor by Country")

country_query = """
SELECT country, COUNT(*) as total
FROM competitor
GROUP BY country
ORDER BY total DESC
LIMIT 10
"""

country_df = pd.read_sql(country_query, connection)

fig2 = px.pie(country_df, names="country", values="total", title="Top Countries")
st.plotly_chart(fig2)


# LEADERBOAD

st.subheader("Leaderboard")

leader_query = """
SELECT c.name, r.rank, r.points
FROM competitor c
JOIN ranking r
ON c.competitor_id = r.competitor_id
ORDER BY r.rank ASC
LIMIT 10
"""

leader_df = pd.read_sql(leader_query, connection)

st.table(leader_df)

# INSIGHTS
st.subheader("Key Insights")
st.write("""
- USA leads in number of competitors.
- Ranking show strong stability at top.
- Competitor distribution in uneven across countries.
- Top 10 players contribute heavily to total points
""")