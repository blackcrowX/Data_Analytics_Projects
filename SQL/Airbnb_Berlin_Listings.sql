DROP TABLE IF EXISTS Airbnb_Berlin_Listings;
CREATE TABLE Airbnb_Berlin_Listings(
	id NUMERIC,
	name VARCHAR(255),
	host_id NUMERIC,
	host_name VARCHAR(255),
	neighbourhood_group VARCHAR(255),
	neighbourhood VARCHAR(255),
	latitude NUMERIC,
	longitude NUMERIC,
	room_type VARCHAR(255),
	price NUMERIC,
	minimum_nights NUMERIC,
	number_of_reviews NUMERIC,
	last_review DATE,
	reviews_per_month NUMERIC,
	calculated_host_listings_count NUMERIC,
	availability_365 NUMERIC,
	number_of_reviews_ltm NUMERIC,
	license TEXT
)

-- Window Functions with OVER

-- Average price with OVER
SELECT
	id,
	name,
	neighbourhood_group,
	AVG(price) OVER()
FROM Airbnb_Berlin_Listings;

-- Average, minimum and maximum price with OVER
SELECT
	id,
	name,
	neighbourhood_group,
	AVG(price) OVER(),
	MIN(price) OVER(),
	MAX(price) OVER()
FROM Airbnb_Berlin_Listings;

-- Difference from average price with OVER
SELECT
	id,
	name,
	neighbourhood_group,
	price,
	ROUND(AVG(price) OVER(), 2),
	ROUND((price - AVG(price) OVER()), 2) AS diff_from_avg
FROM Airbnb_Berlin_Listings;

-- Percent of average price with OVER()
SELECT
	id,
	name,
	neighbourhood_group,
	price,
	ROUND(AVG(price) OVER(), 2) AS avg_price,
	ROUND((price / AVG(price) OVER() * 100), 2) AS percent_of_avg_price
FROM Airbnb_Berlin_Listings;

-- Percent difference from average price
SELECT
	id,
	name,
	neighbourhood_group,
	price,
	ROUND(AVG(price) OVER(), 2) AS avg_price,
	ROUND((price / AVG(price) OVER() - 1) * 100, 2) AS percent_diff_from_avg_price
FROM Airbnb_Berlin_Listings;

--****************************************************

-- PARTITION BY

-- PARTITION BY neighbourhood group
SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	AVG(price) OVER(PARTITION BY neighbourhood_group) AS avg_price_by_neigh_group
FROM Airbnb_Berlin_Listings;

-- PARTITION BY neighbourhood group and neighbourhood
SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	AVG(price) OVER(PARTITION BY neighbourhood_group) AS avg_price_by_neigh_group,
	AVG(price) OVER(PARTITION BY neighbourhood_group, neighbourhood) AS avg_price_by_group_and_neigh
FROM Airbnb_Berlin_Listings;

-- Neighbourhood group and neighbourhood group and neighbourhood delta
SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	AVG(price) OVER(PARTITION BY neighbourhood_group) AS avg_price_by_neigh_group,
	AVG(price) OVER(PARTITION BY neighbourhood_group, neighbourhood) AS avg_price_by_group_and_neigh,
	ROUND(price - AVG(price) OVER(PARTITION BY neighbourhood_group), 2) AS neigh_group_delta,
	ROUND(price - AVG(price) OVER(PARTITION BY neighbourhood_group, neighbourhood), 2) AS group_and_neigh_delta
FROM Airbnb_Berlin_Listings;

--******************************************************

-- ROW_NUMBER

-- overall price rank
SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank
FROM Airbnb_Berlin_Listings;

-- neighbourhood price rank
SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
	ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh_group_price_rank
FROM Airbnb_Berlin_Listings;

-- Top 3
SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
	ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh_group_price_rank,
	CASE
		WHEN ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) <= 3 THEN 'Yes'
		ELSE 'No'
	END AS top3_flag
FROM Airbnb_Berlin_Listings;

--*********************************************************

-- RANK
SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
	RANK() OVER(ORDER BY price DESC) AS overall_price_rank_with_rank,
	ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh_group_price_rank,
	RANK() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh_group_price_rank_with_rank
FROM Airbnb_Berlin_Listings;

-- DENSE_RANK
SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
	RANK() OVER(ORDER BY price DESC) AS overall_price_rank_with_rank,
	DENSE_RANK() OVER(ORDER BY price DESC) AS overall_price_rank_with_dense_rank
FROM Airbnb_Berlin_Listings;

--*********************************************************

-- LAG BY 1 period
SELECT
	id,
	name,
	host_name,
	price,
	last_review,
	LAG(price) OVER(PARTITION BY host_name ORDER BY last_review)
FROM Airbnb_Berlin_Listings;

-- LAG BY 2 periods
SELECT
	id,
	name,
	host_name,
	price,
	last_review,
	LAG(price, 2) OVER(PARTITION BY host_name ORDER BY last_review)
FROM Airbnb_Berlin_Listings;

-- LEAD by 1 period
SELECT
	id,
	name,
	host_name,
	price,
	last_review,
	LEAD(price) OVER(PARTITION BY host_name ORDER BY last_review)
FROM Airbnb_Berlin_Listings;

-- LEAD by 2 periods
SELECT
	id,
	name,
	host_name,
	price,
	last_review,
	LEAD(price, 2) OVER(PARTITION BY host_name ORDER BY last_review)
FROM Airbnb_Berlin_Listings;

--******************************************************

-- Top 3 with subquery to select only the 'Yes' values in the top3_flag column
SELECT * FROM (
	SELECT
		id,
		name,
		neighbourhood_group,
		neighbourhood,
		price,
		ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
		ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh_group_price_rank,
		CASE
			WHEN ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) <= 3 THEN 'Yes'
			ELSE 'No'
		END AS top3_flag
	FROM Airbnb_Berlin_Listings
	) a
WHERE top3_flag = 'Yes'
