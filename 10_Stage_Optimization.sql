EXPLAIN ANALYZE 
SELECT
    DISTINCT 
    m.id,
    m.title,
    avg(s.number_of_stars) OVER (PARTITION BY m.id) AS rate,
    count(s.movie_id) OVER (PARTITION BY m.id) AS number_of_ratings,
    FIRST_VALUE(up."name" || ' ' || up.surname)
        OVER (PARTITION BY m.id ORDER BY s.rated_at) AS first_user
FROM
    movies m
JOIN stars s ON
    m.id = s.movie_id
JOIN user_profiles up ON
    up.user_id = s.user_id
ORDER BY rate DESC 
LIMIT 5; 


SELECT indexname FROM pg_indexes WHERE tablename = 'stars';

DROP INDEX IF EXISTS stars_movie_id_idx;
DROP INDEX IF EXISTS stars_user_id_idx;
DROP INDEX IF EXISTS stars_rated_at_idx;


CREATE INDEX stars_movie_id_idx ON stars (movie_id);
CREATE INDEX stars_user_id_idx ON stars (user_id);
CREATE INDEX stars_rated_at_idx ON stars (rated_at);

SET enable_seqscan TO ON;

