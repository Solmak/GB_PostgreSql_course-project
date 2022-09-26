/*
Создать триггер.
*/

-- Проверка на количество звезд в таблице stars.
CREATE OR REPLACE
FUNCTION check_user_stars_trigger()
RETURNS TRIGGER AS
$$
BEGIN
IF NEW.number_of_stars NOT BETWEEN 1 AND 10
THEN
    RAISE EXCEPTION 'Incorrect number of stars %! From 1 to 10, please!', NEW.number_of_stars;
END IF;

RETURN NEW;
END
$$
LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER check_user_stars_on_update BEFORE UPDATE ON stars 
FOR EACH ROW
EXECUTE FUNCTION check_user_stars_trigger();

CREATE OR REPLACE TRIGGER check_user_stars_on_insert BEFORE INSERT ON stars 
FOR EACH ROW
EXECUTE FUNCTION check_user_stars_trigger();

-- Tests
INSERT INTO stars (movie_id,user_id,number_of_stars)
VALUES (34,89,12);
UPDATE stars SET number_of_stars = 11 WHERE movie_id = 34 AND user_id = 88;




-- Дополнительно. Проверка жанров. Пока не работает. Не срабатывает триггер

CREATE OR REPLACE
FUNCTION check_movie_genres_trigger()
RETURNS TRIGGER AS
$$
DECLARE genre_row RECORD;
BEGIN
FOR genre_row IN
        SELECT id FROM genres
    LOOP 
        RAISE NOTICE 'Incorrect genre % in array!', genre_row.id;
        IF NOT genre_row.id = ANY (NEW.movie_genres)
        THEN
            RAISE EXCEPTION 'Incorrect genre % in array!', genre_row.id;
        END IF;
    END LOOP;
RETURN NEW;
END
$$
LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER check_movie_genres_on_update BEFORE UPDATE ON stars 
FOR EACH ROW
EXECUTE FUNCTION check_movie_genres_trigger();

CREATE OR REPLACE TRIGGER check_movie_genres_on_insert BEFORE INSERT ON stars 
FOR EACH ROW
EXECUTE FUNCTION check_movie_genres_trigger();

-- Tests
UPDATE movies SET movie_genres = '{7,2,3}' WHERE id = 2;
SELECT m.id, m.movie_genres FROM movies m WHERE m.id = 2;
