CREATE DATABASE social_media_ad;
USE social_media_ad;
select * from AdEvents;





SHOW WARNINGS LIMIT 10;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/social_media_ad/Cleaned_Ad_Events.csv'
INTO TABLE AdEvents
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@event_id, @ad_id, @user_id, @day_of_week, @time_of_day, @event_type, @date, @time)
SET
event_id     = TRIM(@event_id),
ad_id        = TRIM(@ad_id),
user_id      = TRIM(@user_id),
day_of_week  = TRIM(@day_of_week),
time_of_day  = TRIM(@time_of_day),
event_type   = TRIM(@event_type),
date         = STR_TO_DATE(TRIM(@date), '%d-%m-%Y'),
time         = TRIM(@time);

SHOW WARNINGS LIMIT 5;
SELECT COUNT(*) FROM AdEvents;


CREATE TABLE Ads (
    ad_id INT,
    campaign_id INT,
    ad_platform VARCHAR(100),
    ad_type VARCHAR(100),
    target_gender VARCHAR(20),
    target_age_group VARCHAR(20),
    target_interests VARCHAR(255)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/social_media_ad/Ads.csv'
INTO TABLE Ads
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Ads;



CREATE TABLE Campaigns (
    campaign_id INT,
    name VARCHAR(255),
    start_date DATE,
    end_date DATE,
    duration_days INT,
    total_budget DECIMAL(10,2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/social_media_ad/Campaigns.csv'
INTO TABLE Campaigns
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT * FROM Campaigns;


CREATE TABLE Users (
    user_id VARCHAR(20),
    user_gender VARCHAR(10),
    user_age INT,
    age_group VARCHAR(10),
    country VARCHAR(100),
    location VARCHAR(100),
    interests VARCHAR(255)
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/social_media_ad/Users.csv'
INTO TABLE Users
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT * FROM Users;

# Total engagement by campaign
SELECT c.name AS campaign_name,
       COUNT(ae.event_id) AS total_events
FROM AdEvents ae
JOIN Ads a ON ae.ad_id = a.ad_id
JOIN Campaigns c ON a.campaign_id = c.campaign_id
GROUP BY c.name
ORDER BY total_events DESC;

##Engagement by ad platform


SELECT a.ad_platform,
       COUNT(ae.event_id) AS total_events
FROM AdEvents ae
JOIN Ads a ON ae.ad_id = a.ad_id
GROUP BY a.ad_platform;


##Engagement by user gender and age group
SELECT u.user_gender,
       u.age_group,
       COUNT(ae.event_id) AS total_events
FROM AdEvents ae
JOIN Users u ON ae.user_id = u.user_id
GROUP BY u.user_gender, u.age_group;

#Peak engagement time

SELECT day_of_week, time_of_day, COUNT(*) AS total_events
FROM AdEvents
GROUP BY day_of_week, time_of_day
ORDER BY total_events DESC;
