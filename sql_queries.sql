create database game_analytics;
Use game_analytics;

# categories
-- Retrieving data 
Select * from categories;

-- rows and columns
Select count(*) from categories;
 
# competition

-- Retrieving data 
Select * from competitions;

-- rows and columns
Select count(*) from competitions;

# complexes

-- Retrieving data 
Select * from complexes;

-- rows and columns
Select count(*) from complexes;

# venues

-- Retrieving data 
Select * from venues;

-- rows and columns
Select count(*) from venues;

-- -- Data mismatch due to foreign key constraint, so clearing and re-importing venues table 

-- Clear existing data
DELETE FROM venues;

-- Disable  foreign key 
SET FOREIGN_KEY_CHECKS = 0;

-- verifying 
Select count(*) from venues;

# competitor

-- Retrieving data 
Select * from competitors;

-- rows and columns
Select count(*) from competitors;

# ranking

-- Retrieving data 
Select * from ranking;

-- rows and columns
Select count(*) from ranking;


USE game_analytics;

-- =========================================
-- Competition Analysis Queries
-- =========================================

-- Q1: List all competitions along with category name
SELECT c.competition_name,
       cat.category_name
FROM competitions c
JOIN categories cat
ON c.category_id = cat.category_id;

-- Q2: Count competitions in each category
SELECT cat.category_name,
       COUNT(c.competition_id) AS total_competitions
FROM categories cat
LEFT JOIN competitions c
ON cat.category_id = c.category_id
GROUP BY cat.category_name
ORDER BY total_competitions DESC;

-- Q3: Find all competitions of type 'doubles'
SELECT *
FROM competitions
WHERE type = 'doubles';

-- Q4: Competitions for specific category (ITF Men)
SELECT c.*
FROM competitions c
JOIN categories cat
ON c.category_id = cat.category_id
WHERE cat.category_name = 'ITF Men';

-- Q5: Parent competitions and sub-competitions
-- Not possible with current schema because no parent-child relationship column exists
-- in competitions table.

-- Q6: Distribution of competition types by category
SELECT cat.category_name,
       c.type,
       COUNT(*) AS total
FROM competitions c
JOIN categories cat
ON c.category_id = cat.category_id
GROUP BY cat.category_name, c.type
ORDER BY total DESC;

-- Q7: Competitions with no parent (top-level competitions)
-- Not possible because parent_id column is not available in competitions table


-- =========================================
-- Venue + Complex Analysis
-- =========================================
 
-- Q1: Venues with associated complex name
SELECT v.venue_name,
       c.complex_name
FROM venues v
JOIN complexes c
ON v.complex_id = c.complex_id;

-- Q2: Count venues in each complex
SELECT c.complex_name,
       COUNT(v.venue_id) AS total_venues
FROM complexes c
LEFT JOIN venues v
ON c.complex_id = v.complex_id
GROUP BY c.complex_name
ORDER BY total_venues DESC;

-- Q3: Venues in specific country
SELECT *
FROM venues
WHERE country_name = 'Chile';

-- Q4: All venues and timezones
SELECT venue_name, timezone
FROM venues;

-- Q5: Complexes having more than one venue
SELECT complex_id,
       COUNT(*) AS total_venues
FROM venues
GROUP BY complex_id
HAVING COUNT(*) > 1;

-- Q6: Venues grouped by country
SELECT country_name,
       COUNT(*) AS total_venues
FROM venues
GROUP BY country_name
ORDER BY total_venues DESC;

-- Q7: Venues for specific complex
SELECT v.*
FROM venues v
JOIN complexes c
ON v.complex_id = c.complex_id
WHERE c.complex_name = 'Nacional';


-- =========================================
-- Competitor + Ranking Analysis
-- =========================================

-- Q1: Competitors with rank and points
SELECT c.name,
       r.rank,
       r.points
FROM competitors c
JOIN ranking r
ON c.competitor_id = r.competitor_id
ORDER BY r.rank ASC;

-- Q2: Top 5 competitors
SELECT c.name,
       r.rank,
       r.points
FROM competitors c
JOIN ranking r
ON c.competitor_id = r.competitor_id
WHERE r.rank <= 5
ORDER BY r.rank;

-- Q3: Stable rank (no movement)
SELECT c.name,
       r.rank,
       r.movement
FROM competitors c
JOIN ranking r
ON c.competitor_id = r.competitor_id
WHERE r.movement = 0;

-- Q4: Total points for specific country
SELECT c.country,
       SUM(r.points) AS total_points
FROM competitors c
JOIN ranking r
ON c.competitor_id = r.competitor_id
WHERE c.country = 'Croatia'
GROUP BY c.country;

-- Q5: Competitors per country
SELECT country,
       COUNT(*) AS total_competitors
FROM competitors
GROUP BY country
ORDER BY total_competitors DESC;

-- Q6: Highest points current week
SELECT c.name,
       r.points
FROM competitors c
JOIN ranking r
ON c.competitor_id = r.competitor_id
ORDER BY r.points DESC
LIMIT 10;




-- =========================================
-- COMPETITION ANALYSIS INSIGHTS
-- =========================================

-- Insight 1:
-- ITF Men category has the highest number of competitions (2198),
-- followed closely by ITF Women (2032).
-- This indicates that these two categories dominate the overall competition structure.

-- Insight 2:
-- Challenger category also shows strong presence with 991 competitions,
-- making it the third most active competition category.

-- Insight 3:
-- Singles and doubles competitions are almost equally distributed
-- within major categories.
-- Example:
-- ITF Men -> singles: 1099, doubles: 1099
-- ITF Women -> singles: 1014, doubles: 1018
-- This reflects a balanced tournament structure.

-- Insight 4:
-- Junior and Exhibition categories have significantly fewer events,
-- suggesting niche or limited tournament scheduling.

-- Insight 5:
-- Specific category analysis for 'ITF Men' shows both singles and doubles
-- events across multiple countries, indicating wide international coverage.

-- Key Finding:
-- ITF Men category has perfectly balanced singles and doubles events.




-- =========================================
-- VENUE + COMPLEX ANALYSIS INSIGHTS
-- =========================================

-- Insight 1:
-- National Tennis Center has the highest number of venues (73),
-- making it the most significant tennis complex in the dataset.

-- Insight 2:
-- Other major complexes include:
-- Buenos Aires Lawn Tennis Club (29)
-- Melbourne Park (25)
-- Hurd Tennis Center (24)
-- This indicates strong venue concentration in major global tennis hubs.

-- Insight 3:
-- Country-wise venue distribution shows that the United States
-- has the maximum number of venues (633),
-- followed by Italy (279), France (272), and China (234).

-- Insight 4:
-- Venue data is globally distributed across multiple time zones
-- such as America, Asia, Australia, and Pacific regions,
-- highlighting international tournament coverage.

-- Insight 5:
-- Chile-specific query shows multiple venues located in Santiago,
-- all mapped to the same complex, indicating centralized tournament hosting.

-- Insight 6:
-- Multiple complexes have more than one venue,
-- which suggests that large tournaments are hosted
-- using multiple courts within the same complex.

-- Insight 7:
-- Specific complex analysis (Nacional) shows venue-level details,
-- useful for drill-down analysis and dashboard filtering.

-- Key Finding:
-- United States contributes the highest venue count,
-- indicating it is the most active country for tournament infrastructure.




-- =========================================
-- COMPETITOR + RANKING ANALYSIS INSIGHTS
-- =========================================

-- Insight 1:
-- Carlos Alcaraz holds the highest points (13550),
-- making him the top-ranked competitor in the dataset.

-- Insight 2:
-- Top 5 rankings include globally recognized players
-- such as Alcaraz, Sabalenka, Sinner, Djokovic, and Swiatek,
-- indicating a balanced representation of men’s and women’s rankings.

-- Insight 3:
-- Stable rank analysis shows multiple players with
-- no rank movement (movement = 0),
-- which indicates ranking consistency in the current week.

-- Insight 4:
-- Croatia contributes a total of 6977 ranking points,
-- showing strong national-level competitor performance.

-- Insight 5:
-- Country-wise competitor distribution shows that
-- USA has the highest number of competitors (102),
-- followed by France (77) and Italy (66).

-- Insight 6:
-- Highest points analysis confirms that
-- Alcaraz and Sinner are leading the current week rankings,
-- with Sabalenka also maintaining very high points.

-- Insight 7:
-- The ranking dataset highlights strong dominance
-- from USA and European countries in global tennis rankings.

-- Key Finding:
-- USA has the highest number of competitors (102).

-- Key Finding:
-- Carlos Alcaraz leads with 13550 points.

-- Key Finding:
-- Multiple top players show zero movement,
-- indicating ranking stability.


