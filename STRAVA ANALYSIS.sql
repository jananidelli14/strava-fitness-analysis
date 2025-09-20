drop table if exists stravafitness;

create table stravafitness(
Id BIGINT,
ActivityDate VARCHAR,
TotalSteps INT,
TotalDistance NUMERIC,
TrackerDistance NUMERIC,
LoggedActivitiesDistance NUMERIC,
VeryActiveDistance NUMERIC,
ModeratelyActiveDistance NUMERIC,
LightActiveDistance NUMERIC,
SedentaryActiveDistance NUMERIC,
VeryActiveMinutes INT,
FairlyActiveMinutes INT,
LightlyActiveMinutes INT,
SedentaryMinutes INT,
Calories INT
);

--ANALYSIS ON "DETAILED PROFILE OF EACH USER SEGMENT"
SELECT
    CASE
        WHEN "totalsteps" < 5000 THEN 'Sedentary'
        WHEN "totalsteps" BETWEEN 5000 AND 10000 THEN 'Lightly Active'
        ELSE 'Active'
    END AS user_type,
    COUNT(DISTINCT "id") AS number_of_users
FROM
    public.stravafitness
GROUP BY
    user_type;

--Calories and Activity by User Segment
SELECT
    CASE
        WHEN "totalsteps" < 5000 THEN 'Sedentary'
        WHEN "totalsteps" BETWEEN 5000 AND 10000 THEN 'Lightly Active'
        ELSE 'Active'
    END AS user_type,
    AVG("calories") AS avg_calories_burned,
    AVG("lightlyactiveminutes") AS avg_lightly_active_minutes,
    AVG("fairlyactiveminutes") AS avg_fairly_active_minutes,
    AVG("veryactiveminutes") AS avg_very_active_minutes,
    AVG("sedentaryminutes") AS avg_sedentary_minutes
FROM
    public.stravafitness
GROUP BY
    user_type;

-- Total Days Logged Per User
SELECT
    "id",
    COUNT(DISTINCT "activitydate") AS total_days_logged
FROM
    public.stravafitness
GROUP BY
    "id"
ORDER BY
    total_days_logged DESC;


--. Categorizing Users by Consistency
WITH UserConsistency AS (
    SELECT
        "id",
        COUNT(DISTINCT "activitydate") AS total_days_logged
    FROM
        public.stravafitness
    GROUP BY
        "id"
)
SELECT
    CASE
        WHEN total_days_logged >= 25 THEN 'Highly Consistent'
        WHEN total_days_logged >= 15 AND total_days_logged < 25 THEN 'Moderately Consistent'
        ELSE 'Sporadic'
    END AS user_consistency_type,
    COUNT(*) AS number_of_users
FROM
    UserConsistency
GROUP BY
    user_consistency_type
ORDER BY
    number_of_users DESC;



--CREATING TABLE FOR MINUTES SLEEP 

CREATE TABLE minutes_sleep(
Id BIGINT,
date VARCHAR,
value INT,
logid NUMERIC
);

--Analysis of Sleep Stages by User
SELECT
    "id",
    COUNT(CASE WHEN "value" = 1 THEN 1 END) AS minutes_awake,
    COUNT(CASE WHEN "value" = 2 THEN 1 END) AS minutes_light_sleep,
    COUNT(CASE WHEN "value" = 3 THEN 1 END) AS minutes_deep_sleep,
    COUNT(*) AS total_minutes_logged
FROM
    public.minutes_sleep
GROUP BY
    "id"
ORDER BY
    "id";


--Count Days Logged Per User
SELECT
    "id",
    COUNT(DISTINCT "date") AS total_days_logged
FROM
    minutes_sleep
GROUP BY
    "id"
ORDER BY
    total_days_logged DESC;

