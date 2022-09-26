/*
Создать два представления, в основе которых лежат сложные запросы.
*/

-- 1
DROP VIEW IF EXISTS top5;
CREATE VIEW top5 AS 
SELECT
    DISTINCT 
    m.id,
    m.title,
    avg(s.number_of_stars) OVER (PARTITION BY m.id) AS rate,
    count(s.movie_id) OVER (PARTITION BY m.id) AS number_of_ratings,
    FIRST_VALUE(up."name" || ' ' || up.surname)
        OVER (PARTITION BY m.id
ORDER BY
    s.rated_at) AS first_user
FROM
    movies m
JOIN stars s ON
    m.id = s.movie_id
JOIN user_profiles up ON
    up.user_id = s.user_id
ORDER BY
    rate DESC
LIMIT 5;

-- 2
DROP VIEW IF EXISTS rooney_cooley_actors;
CREATE VIEW rooney_cooley_actors AS 
SELECT
    p.person_name || ' ' || p.person_surname AS actor,
    m.title AS movie_title,
    r.character_name AS role,
    s.number_of_stars AS user_rate
FROM
    persons p
JOIN roles r ON
    r.person_id = p.id
JOIN stars s ON
    s.movie_id = r.movie_id
JOIN user_profiles up ON
    up.user_id = s.user_id
JOIN movies m ON m.id = s.movie_id
WHERE
    up."name" = 'Rooney'
    AND up.surname = 'Cooley'
ORDER BY actor;
