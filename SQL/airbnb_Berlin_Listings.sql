DROP TABLE IF EXISTS airbnb_berlin_listings;
CREATE TABLE airbnb_berlin_listings(
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