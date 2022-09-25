/* Этап 3
Создать внешние ключи, если они не были созданы на шаге 1 в командах создания таблиц.
В качестве отчета приложить команды создания внешних ключей.
*/

-- Что-то делал на первом этапе. Оставил несколько на 3-й

BEGIN;

ALTER TABLE movies
    DROP CONSTRAINT IF EXISTS movies_movie_type_id_fk,
    ADD CONSTRAINT movies_movie_type_id_fk
        FOREIGN KEY (movie_type_id)
        REFERENCES movie_types(id)
        ON DELETE CASCADE;

ALTER TABLE roles
    DROP CONSTRAINT IF EXISTS roles_person_id_fk,
    ADD CONSTRAINT roles_person_id_fk
        FOREIGN KEY (person_id)
        REFERENCES persons(id)
        ON DELETE CASCADE;

ALTER TABLE stars
    DROP CONSTRAINT IF EXISTS stars_movie_id_fk,
    DROP CONSTRAINT IF EXISTS stars_user_id_fk,
    ADD CONSTRAINT stars_movie_id_fk
        FOREIGN KEY (movie_id)
        REFERENCES movies(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT stars_user_id_fk
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE;

ALTER TABLE movie_positions
    DROP CONSTRAINT IF EXISTS movie_positions_movie_id_fk,
    DROP CONSTRAINT IF EXISTS movie_positions_person_id_fk,
    DROP CONSTRAINT IF EXISTS movie_positions_position_id_fk,
    ADD CONSTRAINT movie_positions_movie_id_fk
        FOREIGN KEY (movie_id)
        REFERENCES movies(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT movie_positions_person_id_fk
        FOREIGN KEY (person_id)
        REFERENCES persons(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT movie_positions_position_id_fk
        FOREIGN KEY (position_id)
        REFERENCES positions(id)
        ON DELETE CASCADE;

COMMIT;