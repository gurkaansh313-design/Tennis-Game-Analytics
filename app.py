import streamlit as st
import pandas as pd
import plotly.express as px

# Page configuration 
st.set_page_config(page_title="Tennis Analytics", layout="wide")

# Title
st.title("🎾 Tennis Game Analytics Dashboard")


# LOAD DATA (CSV)

competitor = pd.read_csv("competitor.csv")
ranking = pd.read_csv("ranking.csv")

# Merge data (like SQL JOIN)
df = competitor.merge(ranking, on="competitor_id")

# SIDEBAR FILTERS

st.sidebar.header("🔍 Filters")

rank_range = st.sidebar.slider("Select Rank Range", 1, 100, (1, 10))
country_filter = st.sidebar.text_input("Enter Country")

# Apply filters
filtered_df = df[
    (df['rank'] >= rank_range[0]) &
    (df['rank'] <= rank_range[1])
]

if country_filter:
    filtered_df = filtered_df[
        filtered_df['country'].str.contains(country_filter, case=False)
    ]


# KPI SECTION

col1, col2, col3 = st.columns(3)

col1.metric("Total Competitor", competitor.shape[0])
col2.metric("Total Countries", competitor['country'].nunique())
col3.metric("Highest Points", ranking['points'].max())


# CLEAN TABLE DISPLAY

st.subheader("📊 Filtered Competitor")

clean_df = filtered_df[['name', 'country', 'rank', 'points']]

clean_df = clean_df.rename(columns={
    'name': 'Player Name',
    'country': 'Country',
    'rank': 'Rank',
    'points': 'Points'
})

st.dataframe(clean_df)


# CHARTS

# Top Players
st.subheader("🏆 Top Players by Points")

top_df = df.sort_values(by="points", ascending=False).head(10)

fig1 = px.bar(top_df, x="name", y="points", title="Top 10 Players")
st.plotly_chart(fig1)

# Country Distribution
st.subheader("🌍 Competitor by Country")

country_df = competitor['country'].value_counts().reset_index()
country_df.columns = ['country', 'total']

fig2 = px.pie(country_df.head(10), names="country", values="total", title="Top Countries")
st.plotly_chart(fig2)


# LEADERBOARD

st.subheader("🥇 Leaderboard")

leader_df = df.sort_values(by="rank").head(10)

leader_df = leader_df[['name', 'rank', 'points']]
leader_df.columns = ['Player Name', 'Rank', 'Points']

st.table(leader_df)


# INSIGHTS

st.subheader("📌 Key Insights")

st.write("""
- USA leads in number of competitors.
- Rankings show strong stability at the top.
- Competitor distribution is uneven across countries.
- Top players dominate total points.
""")
