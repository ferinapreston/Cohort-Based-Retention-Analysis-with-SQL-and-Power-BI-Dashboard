CREATE DATABASE retention_db;
USE retention_db;
CREATE TABLE orders (id INT,user_id INT,total FLOAT,created DATE);
select * from orders;

CREATE TEMPORARY TABLE user_first_week AS
SELECT user_id, DATE_SUB(MIN(created), INTERVAL WEEKDAY(MIN(created)) DAY) AS first_week FROM orders GROUP BY user_id;

CREATE TEMPORARY TABLE user_order_weeks AS
SELECT o.user_id,DATE_SUB(o.created, INTERVAL WEEKDAY(o.created) DAY) AS order_week,uf.first_week,
ROUND(DATEDIFF(DATE_SUB(o.created, INTERVAL WEEKDAY(o.created) DAY), uf.first_week) / 7) AS week_index
FROM orders o
JOIN user_first_week uf ON o.user_id = uf.user_id;

SELECT 
    first_week,
    COUNT(DISTINCT IF(week_index = 0, user_id, NULL)) AS week0,
    COUNT(DISTINCT IF(week_index = 1, user_id, NULL)) AS week1,
    COUNT(DISTINCT IF(week_index = 2, user_id, NULL)) AS week2,
    COUNT(DISTINCT IF(week_index = 3, user_id, NULL)) AS week3,
    COUNT(DISTINCT IF(week_index = 4, user_id, NULL)) AS week4,
    COUNT(DISTINCT IF(week_index = 5, user_id, NULL)) AS week5,
    COUNT(DISTINCT IF(week_index = 6, user_id, NULL)) AS week6,
    COUNT(DISTINCT IF(week_index = 7, user_id, NULL)) AS week7,
    COUNT(DISTINCT IF(week_index = 8, user_id, NULL)) AS week8,
    COUNT(DISTINCT IF(week_index = 9, user_id, NULL)) AS week9,
    COUNT(DISTINCT IF(week_index = 10, user_id, NULL)) AS week10
FROM user_order_weeks
WHERE week_index BETWEEN 0 AND 10
GROUP BY first_week
ORDER BY first_week;




















