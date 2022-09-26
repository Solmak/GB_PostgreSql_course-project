/*
Создать пользовательскую функцию.
*/

-- Функция вычисляет рейтинг фильма на основании оценок пользователей
DROP FUNCTION IF EXISTS movie_rate;
CREATE FUNCTION movie_rate(mv_id INTEGER)
RETURNS REAL AS
$$
SELECT
    avg(s.number_of_stars)
FROM
    stars s
GROUP BY
    s.movie_id
HAVING 
    s.movie_id = mv_id;

$$
LANGUAGE SQL;



-- Процедура обновляет поле рейтинга всех фильмов на основании оценок пользователей
CREATE OR REPLACE PROCEDURE set_movies_stars_rate()
LANGUAGE PLPGSQL AS
$$
DECLARE movie_row RECORD;
BEGIN
FOR movie_row IN
SELECT id
FROM movies
LOOP
UPDATE movies  SET stars_rate  = movie_rate(movie_row.id)
WHERE id = movie_row.id;
END LOOP;
COMMIT;
END;
$$;
