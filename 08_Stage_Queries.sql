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


-- Дополнительно. Внешний ключ на элементы массива.
-- Для таблиц "movies" и "viewer_profiles"

CREATE OR REPLACE FUNCTION check_foreign_key_array(data anyarray, ref_schema text, ref_table text, ref_column text)
    RETURNS BOOL
    RETURNS NULL ON NULL INPUT
    LANGUAGE plpgsql
AS
$body$
DECLARE
    fake_id text;
    sql text default format($$
            select id::text
            from unnest($1) as x(id)
            where id is not null
              and id not in (select %3$I
                             from %1$I.%2$I
                             where %3$I = any($1))
            limit 1;
        $$, ref_schema, ref_table, ref_column);
BEGIN
    EXECUTE sql USING data INTO fake_id;

    IF (fake_id IS NOT NULL) THEN
        RAISE NOTICE 'Array element value % does not exist in column %.%.%', fake_id, ref_schema, ref_table, ref_column;
        RETURN false;
    END IF;

    RETURN true;
END
$body$;

-- Добавляем CONSTRAINT в наши таблицы
ALTER TABLE movies 
ADD CONSTRAINT movies_movie_genres_check 
CHECK (check_foreign_key_array(movie_genres, 'public'::text, 'genres'::text, 'id'::text));

ALTER TABLE viewer_profiles
ADD CONSTRAINT viewer_profiles_genres_ids_check 
CHECK (check_foreign_key_array(genres_ids, 'public'::text, 'genres'::text, 'id'::text));

-- Tests
SELECT * FROM genres g ;
UPDATE movies SET movie_genres = '{1,2,8}' WHERE id = 2;    -- Ok
UPDATE movies SET movie_genres = '{1,2,83}' WHERE id = 2;   -- Error
SELECT m.id, m.movie_genres FROM movies m WHERE m.id = 2;
