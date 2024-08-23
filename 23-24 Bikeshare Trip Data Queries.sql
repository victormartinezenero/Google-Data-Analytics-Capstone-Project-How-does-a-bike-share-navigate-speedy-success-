-- STEP 1: COMBINING ALL 12 MONTHS IN ONE SINGLE TABLE

DROP TABLE IF EXISTS `bikeshare_capstone_project.23_24_bikeshare_data`;

CREATE TABLE IF NOT EXISTS `bikeshare_capstone_project.23_24_bikeshare_data` AS (
  SELECT * FROM `bikeshare_capstone_project.bs0823`
  UNION ALL
  SELECT * FROM `bikeshare_capstone_project.bs0923`
  UNION ALL
  SELECT * FROM `bikeshare_capstone_project.bs1023`
  UNION ALL
  SELECT * FROM `bikeshare_capstone_project.bs1123`
  UNION ALL
  SELECT * FROM `bikeshare_capstone_project.bs1223`
  UNION ALL
  SELECT * FROM `bikeshare_capstone_project.bs0124`
  UNION ALL
  SELECT * FROM `bikeshare_capstone_project.bs0224`
  UNION ALL
  SELECT * FROM `bikeshare_capstone_project.bs0324`
  UNION ALL
  SELECT * FROM `bikeshare_capstone_project.bs0424`
  UNION ALL
  SELECT * FROM `bikeshare_capstone_project.bs0524`
  UNION ALL
  SELECT * FROM `bikeshare_capstone_project.bs0624`
  UNION ALL
  SELECT * FROM `bikeshare_capstone_project.bs0724`
  
);

-- Counting number of values for final verification

SELECT COUNT(*)
FROM `bikeshare_capstone_project.23_24_bikeshare_data`

-- STEP 2: DATA EXPLORATION

  -- 1-CHECKING DATA TYPES OF EACH COLUMN
SELECT
  column_name,
  data_type
FROM
  `bikeshare_capstone_project`.INFORMATION_SCHEMA.COLUMNS
WHERE
  table_name = '23_24_bikeshare_data'

  --2.CHECKING NULL VALUES

WITH counts AS (
  SELECT 
    COUNT (*) - COUNT(ride_id) AS ride_id,
    COUNT (*) - COUNT(rideable_type) AS rideable_type,
    COUNT (*) - COUNT(started_at) AS started_at,
    COUNT (*) - COUNT(ended_at) AS ended_at,
    COUNT (*) - COUNT(start_station_name) AS start_station_name,
    COUNT (*) - COUNT(start_station_id) AS start_station_id,
    COUNT (*) - COUNT(end_station_name) AS end_station_name,
    COUNT (*) - COUNT(end_station_id) AS end_station_id,
    COUNT (*) - COUNT(start_lat) AS start_lat,
    COUNT (*) - COUNT(start_lng) AS start_lng,
    COUNT (*) - COUNT(end_lat) AS end_lat,
    COUNT (*) - COUNT(end_lng) AS end_lng,
    COUNT (*) - COUNT(member_casual) AS member_casual
  FROM `bikeshare_capstone_project.23_24_bikeshare_data`
)
SELECT column_name, count_null
FROM counts
UNPIVOT(count_null FOR column_name IN (
  ride_id, rideable_type, started_at, ended_at, 
  start_station_name, start_station_id, end_station_name, 
  end_station_id, start_lat, start_lng, end_lat, end_lng, 
  member_casual
))
ORDER BY column_name

  -- start_station_name: 947025 null values
  -- start_station_id: 947025 null values
  -- end_station_name: 989476 null values

 -- 3.CHECKING DUPLICATE VALUES

SELECT
    COUNT(ride_id) - COUNT(DISTINCT ride_id) AS number_of_duplicates
FROM `bikeshare_capstone_project.23_24_bikeshare_data`
 -- 211 duplicate trips

--4. RIDEABLE TYPES

SELECT DISTINCT rideable_type, COUNT(rideable_type) AS no_of_trips
FROM `bikeshare_capstone_project.23_24_bikeshare_data_clean`
GROUP BY rideable_type

-- three types of bikes: docked, classic and electric

--5. USER TYPES

SELECT DISTINCT member_casual, COUNT(member_casual) AS member_or_casual
FROM `t-emissary-410210.bikeshare_capstone_project.23_24_bikeshare_data`
GROUP BY member_casual

-- two types of users_ members or casual users

--6. TRIPS LONGER THAN A DAY AND SHORTER THAN A MINUTE

SELECT 
  COUNT(CASE WHEN TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1440 THEN 1 END) AS longer_than_a_day,
  COUNT(CASE WHEN TIMESTAMP_DIFF(ended_at, started_at, MINUTE) < 1 THEN 1 END) AS less_than_a_minute
FROM `bikeshare_capstone_project.23_24_bikeshare_data`

  -- 8001 trips longer than a day

  -- 131281 trips less than a minute

--8. TRIPS WITH MISSING STATION INFORMATION

SELECT COUNT(*) AS trips_with_missing_station
FROM `bikeshare_capstone_project.23_24_bikeshare_data`
WHERE start_station_name IS NULL or end_station_name IS NULL

-- 147311 values with either no start station name or end station name

--9. TRIPS WITH MISSING COORDINATES INFORMATION

SELECT COUNT(*) AS trips_with_missing_coordinates
FROM `bikeshare_capstone_project.23_24_bikeshare_data`
WHERE start_lat IS NULL OR end_lat IS NULL OR start_lng IS NULL OR end_lng IS NULL

-- 7756 values with either no start/end lat or lng

-- STEP 3: DATA CLEANING

-- Creating a new table with no duplicates and null values and creating the columns of trip duration, day of the week and month. Also, I'm not considering trips below 1 minutes and longer than a day (1440 min)

DROP TABLE IF EXISTS `bikeshare_capstone_project.23_24_bikeshare_data_clean`;

CREATE TABLE IF NOT EXISTS`bikeshare_capstone_project.23_24_bikeshare_data_clean` AS (
  SELECT DISTINCT
  ride_id,
  CASE
    WHEN rideable_type = "docked_bike" THEN 'classic_bike'
    ELSE rideable_type
  END AS rideable_type,
  started_at,
  ended_at,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng,
  member_casual,  
  TIMESTAMP_DIFF(ended_at,started_at, MINUTE) AS ride_length  
  FROM `bikeshare_capstone_project.23_24_bikeshare_data`
  WHERE( 
    start_station_name IS NOT NULL AND
    end_station_name IS NOT NULL AND
    start_lat IS NOT NULL AND
    end_lat IS NOT NULL AND
    start_lng IS NOT NULL AND
    end_lng IS NOT NULL AND
    TIMESTAMP_DIFF(ended_at,started_at, MINUTE) > 1 AND TIMESTAMP_DIFF(ended_at,started_at, MINUTE) <= 1440
  )
)

-- STEP 4: DATA ANALYSIS

-- ARE ALL OUR USERS MEMBERS?
SELECT member_casual AS type_of_user, COUNT(ride_id) AS number_of_users
FROM `t-emissary-410210.bikeshare_capstone_project.23_24_bikeshare_data_clean`
GROUP BY member_casual

--- WHAT IS THE USAGE OF OUR ELECTRIC AND CLASSIC BIKES?

---electric bikes

SELECT member_casual AS type_of_user, COUNT (ride_id) AS number_of_users
FROM `t-emissary-410210.bikeshare_capstone_project.23_24_bikeshare_data_clean`
WHERE rideable_type = 'electric_bike'
GROUP BY member_casual

--- classic bikes

SELECT member_casual AS type_of_user, COUNT (ride_id) AS number_of_users
FROM `t-emissary-410210.bikeshare_capstone_project.23_24_bikeshare_data_clean`
WHERE rideable_type = 'classic_bike'
GROUP BY member_casual

-- WHAT IS THE USAGE OF OUR BIKES? (DAY OF THE WEEK)

SELECT 
  member_casual AS type_of_user,  
  CASE EXTRACT
    (DAYOFWEEK FROM started_at)
    WHEN 1 THEN 'SUN'
    WHEN 2 THEN 'MON'
    WHEN 3 THEN 'TUES'
    WHEN 4 THEN 'WED'
    WHEN 5 THEN 'THURS'
    WHEN 6 THEN 'FRI'
    WHEN 7 THEN 'SAT'
  END AS day_of_week,
  COUNT(ride_id) AS number_of_users
FROM `t-emissary-410210.bikeshare_capstone_project.23_24_bikeshare_data_clean`
GROUP BY member_casual, day_of_week

-- WHAT IS THE USAGE OF OUR BIKES? (HOUR OF THE DAY)

SELECT member_casual AS type_of_user,EXTRACT(HOUR FROM started_at) as hour_of_day, COUNT(ride_id) AS number_of_users
FROM `t-emissary-410210.bikeshare_capstone_project.23_24_bikeshare_data_clean`
GROUP BY member_casual, EXTRACT(HOUR FROM started_at)

-- WHAT IS THE USAGE OF OUR BIKES? (SEASON OF THE YEAR)

SELECT 
  member_casual AS type_of_user,
 CASE
    WHEN EXTRACT(MONTH FROM started_at) IN (12, 1, 2) THEN 'Winter'
    WHEN EXTRACT(MONTH FROM started_at) IN (3, 4, 5) THEN 'Spring'
    WHEN EXTRACT(MONTH FROM started_at) IN (6, 7, 8) THEN 'Summer'
    WHEN EXTRACT(MONTH FROM started_at) IN (9, 10, 11) THEN 'Fall'
  END AS season, 
  COUNT(ride_id) AS number_of_users
FROM `t-emissary-410210.bikeshare_capstone_project.23_24_bikeshare_data_clean`
GROUP BY member_casual, season

-- WHAT IS THE AVERAGE TRIP TIME OF OUR USERS?

SELECT member_casual AS type_of_user,EXTRACT(MONTH FROM started_at) as month_of_the_year, ROUND(AVG(ride_length),2) AS ride_length
FROM `t-emissary-410210.bikeshare_capstone_project.23_24_bikeshare_data_clean`
GROUP BY member_casual, month_of_the_year


-- WHAT ARE THE MOST FREQUENT TRIPS

SELECT
  start_station_name,
  end_station_name,
  member_casual AS type_of_user,
  COUNT(ride_id) AS number_of_users,
  AVG(start_lat) AS start_lat,
  AVG(start_lng) AS start_lng,
  AVG(end_lat) AS end_lat,
  AVG(end_lng) AS end_lng
FROM `t-emissary-410210.bikeshare_capstone_project.23_24_bikeshare_data_clean`
GROUP BY member_casual,start_station_name, end_station_name
ORDER BY number_of_users DESC
LIMIT 20