/* Этап 1
Проанализировать бизнес-логику приложения и создать структуру базы данных, которая
может использоваться для хранения данных этого приложения. В базе данных должно быть
минимум десять таблиц. Если таблиц получается более двадцати то рекомендуется
ограничиться частью функционала приложения и не превышать это количество. В качестве
отчета по этой части проекта необходимо приложить команды создания таблиц.
*/

-- Создаем с нуля всю структуру. Возможно кроме внешних ключей.

-- Очистка структуры
BEGIN;
    DROP TABLE IF EXISTS stars;
    DROP TABLE IF EXISTS roles;
    DROP TABLE IF EXISTS movie_positions;
    DROP TABLE IF EXISTS persons;
    DROP TABLE IF EXISTS viewer_profiles;
    DROP TABLE IF EXISTS user_profiles;
    DROP TABLE IF EXISTS users;
    DROP TABLE IF EXISTS images;
    DROP TABLE IF EXISTS image_types;
    DROP TABLE IF EXISTS authorization_types;
    DROP TABLE IF EXISTS genres;
    DROP TABLE IF EXISTS videos;
    DROP TABLE IF EXISTS movies;
    DROP TABLE IF EXISTS movie_types;
    DROP TABLE IF EXISTS video_types;
    DROP TABLE IF EXISTS positions;
    DROP TYPE  IF EXISTS genders;
    DROP TYPE  IF EXISTS age_restrictions;
--ROLLBACK;
--COMMIT;

--BEGIN;
-- Типы авторизации
    CREATE TABLE authorization_types (
        id SERIAL PRIMARY KEY,
        name VARCHAR(20) UNIQUE
    );

-- Типы изображений
    CREATE TABLE image_types (
        id SERIAL PRIMARY KEY,
        type_name VARCHAR(20) UNIQUE
    );

-- Изображения
    CREATE TABLE images (
        id SERIAL PRIMARY KEY,
        image_type_id INTEGER,
        image_url VARCHAR(150) UNIQUE,
        CONSTRAINT images_image_type_id_fk 
            FOREIGN KEY (image_type_id)
            REFERENCES image_types(id)
            ON DELETE SET NULL
    );

-- Пользователи
    CREATE TABLE users (
        id SERIAL PRIMARY KEY,
        phone VARCHAR(15) UNIQUE,
        is_confirmed_phone BOOLEAN DEFAULT FALSE,
        email VARCHAR(256) UNIQUE,
        is_confirmed_email BOOLEAN DEFAULT FALSE,
        authorization_type INTEGER DEFAULT 1,
        CONSTRAINT users_authorization_type_fk 
            FOREIGN KEY (authorization_type)
            REFERENCES authorization_types(id)
            ON DELETE SET NULL
    );

-- Профили пользователей
    CREATE TYPE genders AS ENUM ('male', 'female');
    CREATE TABLE user_profiles (
        user_id INTEGER PRIMARY KEY,
        name VARCHAR(25),
        surname VARCHAR(25),
        gender genders,
        birthday DATE,
        country VARCHAR(50),
        locality VARCHAR(50),
        personal_site VARCHAR(250),
        vk VARCHAR(100),
        twitter VARCHAR(100),
--        interests VARCHAR(30)[],  -- Заполнение сложных данных...
        about_yourself TEXT,
        avatar_image_id INTEGER,
        CONSTRAINT user_profiles_user_id_fk 
            FOREIGN KEY (user_id)
            REFERENCES users(id)
            ON DELETE CASCADE,
        CONSTRAINT users_profiles_avatar_image_id_fk 
            FOREIGN KEY (avatar_image_id)
            REFERENCES images(id)
            ON DELETE SET NULL 
);

-- Жанры фильмов
    CREATE TABLE genres (
        id SERIAL PRIMARY KEY,
        genre_name VARCHAR(20) UNIQUE
    );

-- Профили зрителей
    CREATE TYPE age_restrictions AS ENUM ('0+', '6+', '12+', '16+', '18+');
    CREATE TABLE viewer_profiles (
        id SERIAL PRIMARY KEY,
        user_id INTEGER,
        genres_ids INTEGER[],   -- TODO внешний ключ на массив
        age_restriction age_restrictions,
        CONSTRAINT viewer_profiles_user_id_fk 
            FOREIGN KEY (user_id)
            REFERENCES users(id)
            ON DELETE CASCADE
    );

-- Типы фильмов
    CREATE TABLE movie_types (
        id SERIAL PRIMARY KEY,
        type_name VARCHAR(40) UNIQUE
    );

-- Фильмы
    CREATE TABLE movies (
        id SERIAL PRIMARY KEY,
        movie_type_id INTEGER NOT NULL,    -- TODO Оставим fk на 3-й этап
        title VARCHAR(150) NOT NULL,
        original_title VARCHAR(150) NOT NULL,
        age_restriction age_restrictions,
        movie_genres INTEGER[],     -- TODO внешний ключ на массив
        date_of_release DATE,
        country VARCHAR(50),
        running_time TIME,
        stars_rate REAL
    );

-- Звезды (оценки)
-- Разочарование года... Нельзя целые...
    --CREATE TYPE stars AS ENUM (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
    CREATE TABLE stars (
        movie_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        number_of_stars INTEGER,    -- TODO Триггер на добавление 1-10
        rated_at DATE,              -- FIXME переделать на timestamp  
        PRIMARY KEY (movie_id, user_id)
    );

-- Типы видео
    CREATE TABLE video_types (
        id SERIAL PRIMARY KEY,
        type_name VARCHAR(20) UNIQUE
    );

-- Видео
    CREATE TABLE videos (
        id SERIAL PRIMARY KEY,
        movie_id INTEGER,
        video_type_id INTEGER,
        image_url VARCHAR(150) UNIQUE,
        CONSTRAINT videos_video_type_id_fk 
            FOREIGN KEY (video_type_id)
            REFERENCES video_types(id)
            ON DELETE SET NULL,
        CONSTRAINT videos_movie_id_fk 
            FOREIGN KEY (movie_id)
            REFERENCES movies(id)
            ON DELETE SET NULL
    );

-- Виды персоналий 
    CREATE TABLE positions (
        id SERIAL PRIMARY KEY,
        position_name VARCHAR(20) UNIQUE
        );

-- Персоналии
    CREATE TABLE persons (
        id SERIAL PRIMARY KEY,
        person_name VARCHAR(25),
        person_surname VARCHAR(25),
        person_middle_name VARCHAR(25),
        person_full_name_original VARCHAR(60),
        main_photo_id INTEGER UNIQUE,
        birthday DATE,
        height REAL,
        positions_ids INTEGER[],     -- TODO внешний ключ на массив
        CONSTRAINT persons_main_photo_id_fk 
            FOREIGN KEY (main_photo_id)
            REFERENCES images(id)
            ON DELETE SET NULL
    );

--В ролях
    CREATE TABLE roles (
        id SERIAL PRIMARY KEY,
        movie_id INTEGER NOT NULL,
        person_id INTEGER NOT NULL, -- TODO внешний ключ на 3 этап
        character_name VARCHAR(100),
        is_main_role BOOLEAN NOT NULL DEFAULT FALSE,
        CONSTRAINT roles_movie_id_fk 
            FOREIGN KEY (movie_id)
            REFERENCES movies(id)
            ON DELETE SET NULL
    );

-- Добавил еще одну. :) Сделал бы в сложном типе, но нереально сгенерить тестовые данные
    CREATE TABLE movie_positions (
        movie_id INTEGER NOT NULL,
        person_id INTEGER NOT NULL,
        position_id INTEGER NOT NULL,
        PRIMARY KEY (movie_id, person_id, position_id)
    );

--ROLLBACK;
COMMIT;
