/* Пункт 1
Проанализировать бизнес-логику приложения и создать структуру базы данных, которая
может использоваться для хранения данных этого приложения. В базе данных должно быть
минимум десять таблиц. Если таблиц получается более двадцати то рекомендуется
ограничиться частью функционала приложения и не превышать это количество. В качестве
отчета по этой части проекта необходимо приложить команды создания таблиц.
*/

-- Очистка структуры


-- Типы авторизации
DROP TABLE IF EXISTS authorization_types;
CREATE TABLE authorization_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20)
);

-- Пользователи
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    phone VARCHAR(12) UNIQUE,
    is_confirmed_phone BOOLEAN DEFAULT FALSE,
    email VARCHAR(256) UNIQUE,
    is_confirmed_email BOOLEAN DEFAULT FALSE,
    login_type INT DEFAULT 1,
/*    CONSTRAINT authorization_types_login_type_fk 
        FOREIGN KEY (login_type)
        REFERENCES authorization_types(id)
        ON DELETE SET NULL */
);

-- Профили пользователей
DROP TABLE IF EXISTS user_profiles;
DROP TYPE  IF EXISTS genders;
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
    interests VARCHAR(30)[],
    about_yourself TEXT,
    avatar_image_id INTEGER

/*  CONSTRAINT users_profiles_user_id_fk 
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
    CONSTRAINT users_profiles_avatar_image_id_fk 
        FOREIGN KEY (avatar_image_id)
        REFERENCES images(id)
        ON DELETE SET NULL */
);

-- Жанры фильмов
DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
    id SERIAL PRIMARY KEY,
    genre_name VARCHAR(20)
);

-- Профили зрителей
DROP TABLE IF EXISTS viewer_profiles;
DROP TYPE  IF EXISTS age_restrictions;
CREATE TYPE age_restrictions AS ENUM (0, 6, 12, 16, 18);
CREATE TABLE viewer_profiles (
    id SERIAL PRIMARY KEY,
    user_id INT,
    genres_ids INTEGER[],
    age_restriction age_restrictions,
    CONSTRAINT viewer_profiles_user_id_fk 
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

-- Типы фильмов
DROP TABLE IF EXISTS movie_types;
CREATE TABLE movie_types (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(20)
);

-- Фильмы
DROP TABLE IF EXISTS moveis;
CREATE TABLE moveis (
    id SERIAL PRIMARY KEY,
    movie_type INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    original_title VARCHAR(150) NOT NULL,
    movie_genres INTEGER[],
    date_of_release DATE,
    country VARCHAR(50),
    running_time TIME,
    stars_rate REAL
);

-- Звезды (оценки)
DROP TABLE IF EXISTS stars;
DROP TYPE IF EXISTS stars;
CREATE TYPE stars AS ENUM (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
CREATE TABLE stars (
    movie_id INT NOT NULL,
    user_id INT NOT NULL
    number_of_stars stars,
    rated_at DATE,
    PRIMARY KEY (movie_id, user_id)
);

-- Типы изображений
DROP TABLE IF EXISTS image_types;
CREATE TABLE image_types (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(20)
);

-- Изображения
DROP TABLE IF EXISTS images;
CREATE TABLE images (
    id SERIAL PRIMARY KEY,
    image_url VARCHAR(50)
    movie_id INT,
);

-- Типы видео
DROP TABLE IF EXISTS video_types;
CREATE TABLE video_types (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(20)
);

-- Видео
DROP TABLE IF EXISTS videos;
CREATE TABLE videos (
    id SERIAL PRIMARY KEY,
    image_url VARCHAR(50)
    movie_id INT,
);

-- Виды персоналий 
DROP TABLE IF EXISTS person_types;
CREATE TABLE person_types (
    id SERIAL PRIMARY KEY
);

-- Персоналии
DROP TABLE IF EXISTS persons;
CREATE TABLE persons (
    id SERIAL PRIMARY KEY
);

--В ролях
DROP TABLE IF EXISTS roles;
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    person_id INTEGER NOT NULL
    character_name VARCHAR(100)
    is_main_role BOOLEAN NOT NULL DEFAULT FALSE
);
