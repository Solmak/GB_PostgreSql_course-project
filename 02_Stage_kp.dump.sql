--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Ubuntu 14.5-1.pgdg22.04+1)
-- Dumped by pg_dump version 14.5 (Ubuntu 14.5-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: age_restrictions; Type: TYPE; Schema: public; Owner: gb_sol
--

CREATE TYPE public.age_restrictions AS ENUM (
    '0+',
    '6+',
    '12+',
    '16+',
    '18+'
);


ALTER TYPE public.age_restrictions OWNER TO gb_sol;

--
-- Name: genders; Type: TYPE; Schema: public; Owner: gb_sol
--

CREATE TYPE public.genders AS ENUM (
    'male',
    'female'
);


ALTER TYPE public.genders OWNER TO gb_sol;

--
-- Name: check_movie_genres_trigger(); Type: FUNCTION; Schema: public; Owner: gb_sol
--

CREATE FUNCTION public.check_movie_genres_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.check_movie_genres_trigger() OWNER TO gb_sol;

--
-- Name: check_user_stars_trigger(); Type: FUNCTION; Schema: public; Owner: gb_sol
--

CREATE FUNCTION public.check_user_stars_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
IF NEW.number_of_stars NOT BETWEEN 1 AND 10
THEN
    RAISE EXCEPTION 'Incorrect number of stars %! From 1 to 10, please!', NEW.number_of_stars;
END IF;

RETURN NEW;
END
$$;


ALTER FUNCTION public.check_user_stars_trigger() OWNER TO gb_sol;

--
-- Name: movie_rate(integer); Type: FUNCTION; Schema: public; Owner: gb_sol
--

CREATE FUNCTION public.movie_rate(mv_id integer) RETURNS real
    LANGUAGE sql
    AS $$
SELECT
    avg(s.number_of_stars)
FROM
    stars s
GROUP BY
    s.movie_id
HAVING 
    s.movie_id = mv_id;

$$;


ALTER FUNCTION public.movie_rate(mv_id integer) OWNER TO gb_sol;

--
-- Name: set_movies_stars_rate(); Type: PROCEDURE; Schema: public; Owner: gb_sol
--

CREATE PROCEDURE public.set_movies_stars_rate()
    LANGUAGE plpgsql
    AS $$
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


ALTER PROCEDURE public.set_movies_stars_rate() OWNER TO gb_sol;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: authorization_types; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.authorization_types (
    id integer NOT NULL,
    name character varying(20)
);


ALTER TABLE public.authorization_types OWNER TO gb_sol;

--
-- Name: authorization_types_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_sol
--

CREATE SEQUENCE public.authorization_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.authorization_types_id_seq OWNER TO gb_sol;

--
-- Name: authorization_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_sol
--

ALTER SEQUENCE public.authorization_types_id_seq OWNED BY public.authorization_types.id;


--
-- Name: genres; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.genres (
    id integer NOT NULL,
    genre_name character varying(20)
);


ALTER TABLE public.genres OWNER TO gb_sol;

--
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_sol
--

CREATE SEQUENCE public.genres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.genres_id_seq OWNER TO gb_sol;

--
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_sol
--

ALTER SEQUENCE public.genres_id_seq OWNED BY public.genres.id;


--
-- Name: image_types; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.image_types (
    id integer NOT NULL,
    type_name character varying(20)
);


ALTER TABLE public.image_types OWNER TO gb_sol;

--
-- Name: image_types_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_sol
--

CREATE SEQUENCE public.image_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.image_types_id_seq OWNER TO gb_sol;

--
-- Name: image_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_sol
--

ALTER SEQUENCE public.image_types_id_seq OWNED BY public.image_types.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.images (
    id integer NOT NULL,
    image_type_id integer,
    image_url character varying(150)
);


ALTER TABLE public.images OWNER TO gb_sol;

--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_sol
--

CREATE SEQUENCE public.images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.images_id_seq OWNER TO gb_sol;

--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_sol
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;


--
-- Name: movie_positions; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.movie_positions (
    movie_id integer NOT NULL,
    person_id integer NOT NULL,
    position_id integer NOT NULL
);


ALTER TABLE public.movie_positions OWNER TO gb_sol;

--
-- Name: movie_types; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.movie_types (
    id integer NOT NULL,
    type_name character varying(40)
);


ALTER TABLE public.movie_types OWNER TO gb_sol;

--
-- Name: movie_types_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_sol
--

CREATE SEQUENCE public.movie_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movie_types_id_seq OWNER TO gb_sol;

--
-- Name: movie_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_sol
--

ALTER SEQUENCE public.movie_types_id_seq OWNED BY public.movie_types.id;


--
-- Name: movies; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.movies (
    id integer NOT NULL,
    movie_type_id integer NOT NULL,
    title character varying(150) NOT NULL,
    original_title character varying(150) NOT NULL,
    age_restriction public.age_restrictions,
    movie_genres integer[],
    date_of_release date,
    country character varying(50),
    running_time time without time zone,
    stars_rate real
);


ALTER TABLE public.movies OWNER TO gb_sol;

--
-- Name: movies_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_sol
--

CREATE SEQUENCE public.movies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movies_id_seq OWNER TO gb_sol;

--
-- Name: movies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_sol
--

ALTER SEQUENCE public.movies_id_seq OWNED BY public.movies.id;


--
-- Name: persons; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.persons (
    id integer NOT NULL,
    person_name character varying(25),
    person_surname character varying(25),
    person_middle_name character varying(25),
    person_full_name_original character varying(60),
    main_photo_id integer,
    birthday date,
    height real,
    positions_ids integer[]
);


ALTER TABLE public.persons OWNER TO gb_sol;

--
-- Name: persons_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_sol
--

CREATE SEQUENCE public.persons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.persons_id_seq OWNER TO gb_sol;

--
-- Name: persons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_sol
--

ALTER SEQUENCE public.persons_id_seq OWNED BY public.persons.id;


--
-- Name: positions; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.positions (
    id integer NOT NULL,
    position_name character varying(20)
);


ALTER TABLE public.positions OWNER TO gb_sol;

--
-- Name: positions_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_sol
--

CREATE SEQUENCE public.positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.positions_id_seq OWNER TO gb_sol;

--
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_sol
--

ALTER SEQUENCE public.positions_id_seq OWNED BY public.positions.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    person_id integer NOT NULL,
    character_name character varying(100),
    is_main_role boolean DEFAULT false NOT NULL
);


ALTER TABLE public.roles OWNER TO gb_sol;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_sol
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO gb_sol;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_sol
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: stars; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.stars (
    movie_id integer NOT NULL,
    user_id integer NOT NULL,
    number_of_stars integer NOT NULL,
    rated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.stars OWNER TO gb_sol;

--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.user_profiles (
    user_id integer NOT NULL,
    name character varying(25),
    surname character varying(25),
    gender public.genders,
    birthday date,
    country character varying(50),
    locality character varying(50),
    personal_site character varying(250),
    vk character varying(100),
    twitter character varying(100),
    about_yourself text,
    avatar_image_id integer
);


ALTER TABLE public.user_profiles OWNER TO gb_sol;

--
-- Name: rooney_cooley_actors; Type: VIEW; Schema: public; Owner: gb_sol
--

CREATE VIEW public.rooney_cooley_actors AS
 SELECT (((p.person_name)::text || ' '::text) || (p.person_surname)::text) AS actor,
    m.title AS movie_title,
    r.character_name AS role,
    s.number_of_stars AS user_rate
   FROM ((((public.persons p
     JOIN public.roles r ON ((r.person_id = p.id)))
     JOIN public.stars s ON ((s.movie_id = r.movie_id)))
     JOIN public.user_profiles up ON ((up.user_id = s.user_id)))
     JOIN public.movies m ON ((m.id = s.movie_id)))
  WHERE (((up.name)::text = 'Rooney'::text) AND ((up.surname)::text = 'Cooley'::text))
  ORDER BY (((p.person_name)::text || ' '::text) || (p.person_surname)::text);


ALTER TABLE public.rooney_cooley_actors OWNER TO gb_sol;

--
-- Name: top5; Type: VIEW; Schema: public; Owner: gb_sol
--

CREATE VIEW public.top5 AS
 SELECT DISTINCT m.id,
    m.title,
    avg(s.number_of_stars) OVER (PARTITION BY m.id) AS rate,
    count(s.movie_id) OVER (PARTITION BY m.id) AS number_of_ratings,
    first_value((((up.name)::text || ' '::text) || (up.surname)::text)) OVER (PARTITION BY m.id ORDER BY s.rated_at) AS first_user
   FROM ((public.movies m
     JOIN public.stars s ON ((m.id = s.movie_id)))
     JOIN public.user_profiles up ON ((up.user_id = s.user_id)))
  ORDER BY (avg(s.number_of_stars) OVER (PARTITION BY m.id)) DESC
 LIMIT 5;


ALTER TABLE public.top5 OWNER TO gb_sol;

--
-- Name: users; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.users (
    id integer NOT NULL,
    phone character varying(15),
    is_confirmed_phone boolean DEFAULT false,
    email character varying(256),
    is_confirmed_email boolean DEFAULT false,
    authorization_type integer DEFAULT 1
);


ALTER TABLE public.users OWNER TO gb_sol;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_sol
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO gb_sol;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_sol
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: video_types; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.video_types (
    id integer NOT NULL,
    type_name character varying(20)
);


ALTER TABLE public.video_types OWNER TO gb_sol;

--
-- Name: video_types_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_sol
--

CREATE SEQUENCE public.video_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.video_types_id_seq OWNER TO gb_sol;

--
-- Name: video_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_sol
--

ALTER SEQUENCE public.video_types_id_seq OWNED BY public.video_types.id;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.videos (
    id integer NOT NULL,
    movie_id integer,
    video_type_id integer,
    image_url character varying(150)
);


ALTER TABLE public.videos OWNER TO gb_sol;

--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_sol
--

CREATE SEQUENCE public.videos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.videos_id_seq OWNER TO gb_sol;

--
-- Name: videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_sol
--

ALTER SEQUENCE public.videos_id_seq OWNED BY public.videos.id;


--
-- Name: viewer_profiles; Type: TABLE; Schema: public; Owner: gb_sol
--

CREATE TABLE public.viewer_profiles (
    id integer NOT NULL,
    user_id integer,
    genres_ids integer[],
    age_restriction public.age_restrictions
);


ALTER TABLE public.viewer_profiles OWNER TO gb_sol;

--
-- Name: viewer_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_sol
--

CREATE SEQUENCE public.viewer_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.viewer_profiles_id_seq OWNER TO gb_sol;

--
-- Name: viewer_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_sol
--

ALTER SEQUENCE public.viewer_profiles_id_seq OWNED BY public.viewer_profiles.id;


--
-- Name: authorization_types id; Type: DEFAULT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.authorization_types ALTER COLUMN id SET DEFAULT nextval('public.authorization_types_id_seq'::regclass);


--
-- Name: genres id; Type: DEFAULT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.genres ALTER COLUMN id SET DEFAULT nextval('public.genres_id_seq'::regclass);


--
-- Name: image_types id; Type: DEFAULT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.image_types ALTER COLUMN id SET DEFAULT nextval('public.image_types_id_seq'::regclass);


--
-- Name: images id; Type: DEFAULT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- Name: movie_types id; Type: DEFAULT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.movie_types ALTER COLUMN id SET DEFAULT nextval('public.movie_types_id_seq'::regclass);


--
-- Name: movies id; Type: DEFAULT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.movies ALTER COLUMN id SET DEFAULT nextval('public.movies_id_seq'::regclass);


--
-- Name: persons id; Type: DEFAULT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.persons ALTER COLUMN id SET DEFAULT nextval('public.persons_id_seq'::regclass);


--
-- Name: positions id; Type: DEFAULT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.positions ALTER COLUMN id SET DEFAULT nextval('public.positions_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: video_types id; Type: DEFAULT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.video_types ALTER COLUMN id SET DEFAULT nextval('public.video_types_id_seq'::regclass);


--
-- Name: videos id; Type: DEFAULT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.videos ALTER COLUMN id SET DEFAULT nextval('public.videos_id_seq'::regclass);


--
-- Name: viewer_profiles id; Type: DEFAULT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.viewer_profiles ALTER COLUMN id SET DEFAULT nextval('public.viewer_profiles_id_seq'::regclass);


--
-- Data for Name: authorization_types; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.authorization_types (id, name) FROM stdin;
1	Логин, пароль
2	ВКонтакте
3	ЯндексID
4	СМС
\.


--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.genres (id, genre_name) FROM stdin;
1	Комедия
2	Мультфильм
3	Ужасы
4	Фантастика
5	Триллер
6	Боевик
7	Мелодрама
8	Детектив
9	Приключения
10	Фэнтези
11	Военный
12	Семейный
13	Аниме
14	Исторический
15	Драма
16	Документальный
17	Детский
18	Криминал
19	Биография
20	Вестерн
21	Фильм-нуар
22	Спортивный
23	Реальное ТВ
24	Короткометражка
25	Музыкальный
26	Мюзикл
27	Ток-шоу
28	Игры
\.


--
-- Data for Name: image_types; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.image_types (id, type_name) FROM stdin;
1	Аватар
2	Постер
3	Портрет
4	Кадр
5	Обложка
6	Фан-арт
\.


--
-- Data for Name: images; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.images (id, image_type_id, image_url) FROM stdin;
1	3	https://netflix.com/site?q=0
2	2	http://twitter.com/sub?search=1
3	2	https://naver.com/en-us?g=1
4	3	https://whatsapp.com/user/110?client=g
5	3	http://cnn.com/settings?page=1&offset=1
6	4	https://walmart.com/sub/cars?p=8
7	4	http://ebay.com/en-us?q=4
8	4	http://whatsapp.com/sub?q=4
9	4	https://facebook.com/sub/cars?ad=115
10	3	https://walmart.com/fr?client=g
11	5	https://baidu.com/sub/cars?ad=115
12	4	http://netflix.com/settings?search=1&q=de
13	5	http://walmart.com/sub?ab=441&aad=2
14	2	http://google.com/sub?q=test
15	1	http://walmart.com/one?search=1&q=de
16	6	https://bbc.co.uk/en-us?ab=441&aad=2
17	3	https://ebay.com/site?q=0
18	3	https://facebook.com/site?p=8
19	4	http://nytimes.com/settings?q=11
20	3	https://bbc.co.uk/site?gi=100
21	4	https://ebay.com/site?search=1
22	4	https://twitter.com/sub/cars?str=se
23	4	https://google.com/group/9?client=g
24	6	http://ebay.com/sub/cars?k=0
25	3	http://facebook.com/one?p=8
26	6	https://nytimes.com/en-us?search=1
27	4	https://baidu.com/one?q=test
28	3	http://wikipedia.org/site?q=11
29	2	http://guardian.co.uk/group/9?q=0
30	5	http://ebay.com/settings?str=se
31	6	http://zoom.us/site?g=1
32	1	https://reddit.com/en-us?k=0
33	4	https://nytimes.com/one?q=4
34	2	https://youtube.com/user/110?q=11
35	5	http://twitter.com/fr?gi=100
36	4	http://reddit.com/en-us?k=0
37	4	http://baidu.com/user/110?search=1
38	3	https://pinterest.com/en-ca?g=1
39	6	https://baidu.com/fr?p=8
40	3	https://naver.com/one?q=11
41	3	https://naver.com/en-us?gi=100
42	4	https://ebay.com/sub?k=0
43	1	https://facebook.com/fr?q=11
44	4	https://nytimes.com/en-us?search=1&q=de
45	4	http://ebay.com/user/110?k=0
46	3	http://cnn.com/fr?q=4
47	2	https://cnn.com/user/110?gi=100
48	4	https://wikipedia.org/fr?page=1&offset=1
49	1	http://nytimes.com/sub?gi=100
50	2	https://cnn.com/sub/cars?q=11
51	6	http://twitter.com/fr?ab=441&aad=2
52	2	http://nytimes.com/sub?g=1
53	3	http://youtube.com/fr?search=1&q=de
54	3	https://bbc.co.uk/user/110?q=11
55	5	https://wikipedia.org/en-ca?q=test
56	5	https://reddit.com/sub/cars?page=1&offset=1
57	4	http://bbc.co.uk/en-ca?str=se
58	2	http://guardian.co.uk/fr?str=se
59	6	https://walmart.com/sub?g=1
60	2	http://wikipedia.org/one?k=0
61	1	http://naver.com/group/9?g=1
62	3	http://naver.com/group/9?search=1
63	5	http://google.com/sub?q=0
64	5	https://zoom.us/en-us?ab=441&aad=2
65	4	http://yahoo.com/group/9?q=0
66	4	http://zoom.us/group/9?str=se
67	3	https://google.com/settings?client=g
68	2	http://bbc.co.uk/fr?search=1&q=de
69	4	http://ebay.com/fr?client=g
70	4	https://baidu.com/en-ca?q=0
71	5	http://yahoo.com/fr?p=8
72	4	http://walmart.com/one?client=g
73	2	https://ebay.com/settings?page=1&offset=1
74	5	https://twitter.com/user/110?k=0
75	5	https://pinterest.com/site?q=4
76	5	https://ebay.com/fr?p=8
77	2	http://naver.com/settings?ab=441&aad=2
78	2	http://bbc.co.uk/sub/cars?gi=100
79	4	https://netflix.com/settings?gi=100
80	5	http://zoom.us/sub/cars?ad=115
81	4	http://google.com/one?gi=100
82	4	http://youtube.com/one?ad=115
83	3	https://netflix.com/user/110?search=1&q=de
84	5	http://nytimes.com/sub/cars?page=1&offset=1
85	4	https://naver.com/site?q=test
86	5	http://yahoo.com/sub/cars?q=0
87	6	http://netflix.com/site?g=1
88	5	http://ebay.com/sub/cars?ad=115
89	4	http://yahoo.com/site?g=1
90	5	https://twitter.com/sub?str=se
91	3	http://wikipedia.org/en-ca?p=8
92	3	https://youtube.com/group/9?k=0
93	4	http://youtube.com/en-us?ad=115
94	6	https://bbc.co.uk/settings?q=11
95	2	https://pinterest.com/fr?q=11
96	4	https://baidu.com/settings?p=8
97	3	http://youtube.com/sub?ad=115
98	2	https://twitter.com/user/110?ad=115
99	2	http://pinterest.com/sub?q=0
100	1	https://naver.com/en-us?search=1&q=de
101	4	https://nytimes.com/en-ca?gi=100
102	4	https://walmart.com/settings?page=1&offset=1
103	6	https://ebay.com/sub?g=1
104	3	http://yahoo.com/sub/cars?str=se
105	6	http://bbc.co.uk/fr?ab=441&aad=2
106	4	https://guardian.co.uk/settings?p=8
107	3	http://baidu.com/one?page=1&offset=1
108	4	http://twitter.com/en-ca?p=8
109	1	https://twitter.com/site?page=1&offset=1
110	5	https://youtube.com/one?client=g
111	6	http://yahoo.com/one?q=11
112	4	http://zoom.us/user/110?q=0
113	1	https://ebay.com/sub/cars?k=0
114	4	https://baidu.com/user/110?client=g
115	3	https://whatsapp.com/settings?g=1
116	5	http://cnn.com/group/9?g=1
117	4	http://whatsapp.com/one?str=se
118	2	http://facebook.com/group/9?q=0
119	4	http://pinterest.com/en-us?search=1
120	5	https://guardian.co.uk/site?gi=100
121	1	https://google.com/fr?q=0
122	5	https://zoom.us/fr?search=1
123	2	https://guardian.co.uk/group/9?k=0
124	2	http://walmart.com/sub/cars?g=1
125	3	https://google.com/en-us?g=1
126	4	http://baidu.com/sub/cars?gi=100
127	6	https://yahoo.com/fr?p=8
128	2	https://cnn.com/user/110?p=8
129	3	http://reddit.com/sub?gi=100
130	3	https://google.com/settings?g=1
131	1	https://baidu.com/fr?str=se
132	3	https://facebook.com/sub/cars?q=11
133	5	http://guardian.co.uk/one?search=1&q=de
134	4	http://google.com/one?q=4
135	5	https://twitter.com/sub?q=4
136	4	http://reddit.com/site?ab=441&aad=2
137	5	https://youtube.com/one?k=0
138	6	http://pinterest.com/sub/cars?search=1&q=de
139	5	https://pinterest.com/user/110?g=1
140	4	https://instagram.com/fr?q=test
141	6	http://twitter.com/sub/cars?q=4
142	4	http://ebay.com/en-ca?p=8
143	5	http://pinterest.com/settings?p=8
144	1	https://reddit.com/sub?search=1
145	4	http://instagram.com/user/110?gi=100
146	1	https://naver.com/sub?ad=115
147	6	http://baidu.com/sub?search=1
148	2	https://reddit.com/site?q=4
149	5	http://yahoo.com/group/9?search=1&q=de
150	1	https://youtube.com/en-us?search=1&q=de
\.


--
-- Data for Name: movie_positions; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.movie_positions (movie_id, person_id, position_id) FROM stdin;
37	81	3
37	52	3
47	56	4
35	64	8
25	38	3
125	14	7
138	136	9
127	58	8
32	57	4
91	38	2
147	36	4
45	88	7
144	111	3
14	8	6
42	87	6
95	35	4
63	22	6
53	82	3
61	92	2
40	48	2
45	25	4
83	75	6
6	57	9
72	148	3
13	128	9
96	104	8
98	18	3
11	31	3
89	97	10
100	20	5
4	31	4
105	60	8
107	56	10
22	108	6
74	24	5
82	130	8
57	23	6
64	36	2
66	37	8
44	93	6
97	106	6
102	70	6
105	142	6
121	135	3
68	31	9
100	2	5
11	10	8
145	68	4
136	53	10
57	4	4
7	77	3
11	133	4
13	120	1
21	85	9
41	131	10
70	88	4
4	96	5
7	20	3
85	26	10
20	109	9
73	104	4
34	89	7
148	75	8
146	42	9
14	132	2
76	19	5
114	128	8
121	84	8
51	99	6
130	82	4
73	88	10
88	143	9
97	3	1
32	87	3
28	5	7
122	112	6
40	4	5
92	121	4
53	35	5
141	129	2
50	85	2
16	33	6
148	139	6
109	122	4
11	35	8
133	51	6
45	139	5
49	126	9
9	14	7
112	23	7
149	37	8
77	94	10
128	100	5
123	92	10
81	3	9
112	65	3
33	126	1
116	53	9
99	149	2
140	83	5
49	76	9
41	145	7
75	70	3
142	32	9
131	63	10
11	27	2
111	65	9
92	52	5
123	39	3
72	82	2
6	36	3
106	119	8
7	110	3
65	72	8
136	117	6
57	95	4
63	139	1
121	90	8
137	27	7
135	117	6
62	98	1
80	99	4
38	53	2
15	9	7
66	103	3
147	107	2
10	119	4
149	56	2
76	57	6
40	114	8
65	135	10
54	19	6
70	142	10
147	67	6
78	96	8
104	139	2
126	75	3
81	84	2
25	86	3
123	29	8
84	133	7
12	97	7
116	12	6
10	83	1
90	122	2
33	131	8
135	16	7
26	111	9
35	136	5
31	6	7
\.


--
-- Data for Name: movie_types; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.movie_types (id, type_name) FROM stdin;
1	Полнометражный фильм
2	Короткометражный фильм
3	Многосерийный фильм
4	Сериал
\.


--
-- Data for Name: movies; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.movies (id, movie_type_id, title, original_title, age_restriction, movie_genres, date_of_release, country, running_time, stars_rate) FROM stdin;
2	2	tempor, est	nec orci.	12+	{7,2,3}	1932-10-02	Philippines	04:06:21	6.6666665
1	3	pellentesque a, facilisis	risus. In mi	6+	{4}	2005-07-04	South Africa	01:35:44	\N
3	1	Vivamus	laoreet ipsum.	12+	{1,2,3}	1985-07-01	Philippines	06:50:49	5.75
4	1	magna.	ut erat.	0+	{13}	1948-01-18	South Africa	07:02:18	3.3333333
5	2	amet, consectetuer	non	6+	{19,22}	1957-12-08	Indonesia	06:36:02	5
6	3	justo. Proin	tortor,	16+	{22}	1972-11-08	United Kingdom	22:21:59	5.2
7	2	neque. Nullam	Sed nec	12+	{1,2,3}	1948-06-04	Australia	16:28:56	3.6666667
8	3	enim consequat purus.	et,	6+	{19,22}	1972-12-29	Norway	08:00:39	7.3333335
9	3	convallis est,	mauris	6+	{26}	1934-03-10	Norway	12:44:43	3.4
10	2	Proin eget odio.	mauris a	12+	{4}	1977-08-31	Brazil	21:05:31	6.6666665
11	2	luctus sit	penatibus	12+	{27,20}	1993-09-03	Nigeria	21:34:22	3.8
12	3	velit	condimentum eget, volutpat	12+	{12,5}	1991-09-10	Austria	12:44:57	6.1666665
13	3	Quisque	in aliquet lobortis,	0+	{4}	2009-04-16	Spain	07:05:23	\N
14	1	arcu. Vestibulum	eget, venenatis	0+	{11,9}	1939-09-24	Costa Rica	01:31:54	4.75
15	1	risus. Donec egestas.	risus. Duis a	6+	{15}	1989-05-31	Ireland	15:57:56	4
16	3	pharetra. Quisque	semper	6+	{11,3}	1953-10-29	Sweden	17:30:50	6.3333335
17	1	volutpat. Nulla	tempor augue ac	6+	{1}	1939-05-05	New Zealand	16:21:12	7
18	3	ligula. Nullam	semper cursus. Integer	6+	{16}	2013-03-09	United Kingdom	09:58:41	5.25
19	4	purus gravida sagittis.	rutrum magna.	0+	{9}	1987-02-18	South Africa	20:02:00	1
20	3	montes, nascetur	ultrices. Duis volutpat	12+	{12}	1952-09-10	Norway	08:30:17	7
21	2	quis	pede.	6+	{1,5,9}	1951-02-11	Canada	17:53:28	5
22	2	Nam interdum	luctus	0+	{19}	2002-08-05	Austria	13:59:40	\N
23	1	lectus pede, ultrices	mauris id	0+	{12}	2009-11-28	Sweden	11:23:59	5
24	3	Nam tempor	lacus.	12+	{11,9}	2008-07-11	Sweden	17:07:54	6.3333335
25	3	risus. In	id magna	12+	{21,23}	1939-09-07	Poland	02:57:25	6
26	3	fringilla ornare	nonummy ac,	12+	{2}	1976-08-04	Poland	19:24:28	6.5
27	3	Nullam	erat vel pede	0+	{1,2,3}	1978-10-10	Canada	06:42:34	8
28	4	est	ligula	6+	{21}	2005-09-02	Singapore	11:07:35	3.8
29	2	lobortis quis, pede.	leo. Cras vehicula	6+	{23}	1940-06-08	Russian Federation	17:24:48	3
30	4	auctor ullamcorper,	ridiculus mus.	16+	{2}	1955-08-05	South Africa	09:00:50	3
31	2	ullamcorper. Duis	auctor, velit eget	0+	{1}	2015-09-24	New Zealand	11:07:33	5.5
32	2	velit. Pellentesque	eu, accumsan	6+	{21}	2014-06-02	Colombia	18:56:15	6
33	3	faucibus. Morbi	sagittis semper. Nam	12+	{6}	1940-06-09	France	21:25:38	5.6666665
34	1	luctus et	urna et	12+	{15}	1978-06-14	China	00:59:07	5
35	3	nulla	ac, fermentum vel,	6+	{17}	1973-09-22	Germany	05:50:18	3.5
36	1	sem,	non enim. Mauris	16+	{10}	1934-05-20	Netherlands	21:51:07	9.666667
37	3	amet, consectetuer	tristique	6+	{2,17}	1949-11-30	Philippines	10:03:51	5.6666665
38	1	pretium et,	lacus pede	6+	{23}	1936-11-27	Brazil	11:39:18	4.5
39	1	Sed	Quisque ac	0+	{7}	1986-11-25	Nigeria	09:35:27	4.5
40	2	mattis. Integer eu	non, feugiat nec,	6+	{24}	1949-07-01	Netherlands	07:48:50	5
41	2	lacus. Mauris	Donec luctus aliquet	12+	{2}	1990-12-28	South Africa	13:36:28	6.4
42	3	consectetuer adipiscing	consectetuer mauris	16+	{21}	2019-01-18	Norway	06:00:00	6.3333335
43	3	Duis risus	vulputate, nisi	6+	{15}	1974-07-09	India	16:30:36	7.3333335
44	4	rutrum	nulla. Cras	0+	{25}	1960-12-08	Sweden	18:03:57	7.3333335
45	1	elit. Curabitur	Integer mollis. Integer	16+	{18}	2005-01-23	France	08:14:04	3.5
46	4	tellus	Cras vulputate	6+	{10}	2006-02-18	Italy	22:22:57	2.5
47	4	et magnis dis	ipsum. Suspendisse	6+	{13}	1969-01-10	Chile	18:07:43	5
48	2	ligula	egestas. Aliquam	12+	{1}	1952-06-06	Peru	23:25:05	6
49	4	ut erat. Sed	et	6+	{28}	1946-02-16	Norway	15:32:44	5
50	3	Aenean eget	dignissim pharetra. Nam	0+	{6}	1943-02-13	Costa Rica	23:20:22	8
51	4	non massa non	ante.	12+	{8}	1950-10-22	Germany	19:12:46	6.5
52	3	nec, malesuada	In mi	0+	{17}	1988-06-26	Indonesia	00:04:22	5.6
53	3	hymenaeos. Mauris	sagittis semper.	6+	{13,7}	2003-08-26	Nigeria	18:48:02	5.6666665
54	1	ac mattis	at, nisi.	6+	{4}	1961-02-12	Spain	10:36:59	4
55	3	ligula. Nullam	non, feugiat nec,	6+	{21,23}	1953-07-15	Spain	08:43:32	7
56	2	Quisque	magnis dis parturient	6+	{28}	1996-06-02	Mexico	03:14:35	7
57	1	Nunc	amet, consectetuer	6+	{1,5,9}	2018-07-15	Canada	04:01:47	7.3333335
58	3	penatibus	Donec tempus, lorem	6+	{17}	2002-01-17	Turkey	19:58:21	5.75
59	2	Vivamus	arcu. Vestibulum ante	0+	{14}	1999-06-03	Costa Rica	00:18:09	4
60	2	et pede.	ipsum. Suspendisse non	12+	{23}	1998-03-24	Peru	13:48:57	4.285714
61	2	sem mollis	lacus. Ut	16+	{3}	2017-04-17	Italy	19:36:49	4.4
62	3	vitae nibh.	eget, volutpat	0+	{17}	1971-11-11	France	10:09:22	6
63	1	mauris.	quam dignissim pharetra.	0+	{6}	1949-12-09	China	07:00:49	6.4
64	1	venenatis vel,	amet ornare lectus	16+	{27,20}	1998-01-27	Peru	20:28:19	4.8333335
65	3	Integer eu	at augue	12+	{5}	1957-01-07	South Korea	11:53:07	6.3333335
66	3	Integer	Cras	12+	{28}	2005-11-10	New Zealand	23:27:39	3
67	3	Morbi vehicula. Pellentesque	Phasellus	0+	{12,5}	1985-06-25	New Zealand	17:11:02	6.25
68	4	Nunc mauris.	Vivamus	6+	{17}	2013-05-25	Italy	18:48:47	7.6666665
69	3	sem ut	ut erat. Sed	12+	{11,9}	2012-01-26	Australia	04:14:14	5.75
70	2	bibendum sed,	purus ac	12+	{12}	1992-01-17	Spain	06:28:55	7
71	3	Mauris quis	nec, diam. Duis	0+	{12}	1940-02-23	United Kingdom	11:45:41	3.3333333
72	4	non, lacinia	consectetuer adipiscing	12+	{23}	1935-07-04	Chile	19:21:07	5.5
73	3	diam luctus	Donec est.	12+	{17}	1966-03-04	Spain	05:10:19	4.8
74	2	Etiam imperdiet dictum	dictum.	6+	{7}	1941-04-18	Sweden	17:03:10	5.6
75	4	mollis nec,	elementum	12+	{4}	1993-11-16	Indonesia	20:49:00	5.8
76	2	egestas. Aliquam	sit amet	12+	{23}	1963-11-20	United States	02:58:00	6.3333335
77	3	enim non	hendrerit	12+	{21,23}	2016-06-25	Ireland	05:35:29	5.2
78	2	ut,	egestas nunc	12+	{14}	1945-08-05	Russian Federation	09:11:26	6.25
79	2	Maecenas libero	lobortis risus. In	12+	{14}	1990-11-14	Pakistan	00:27:36	\N
80	3	sem. Pellentesque	In	0+	{1,5,9}	1969-03-07	Chile	11:17:36	6
81	2	tincidunt,	pede, nonummy ut,	16+	{14}	2005-03-27	France	04:33:51	6.6
82	2	Nunc sed	penatibus	16+	{13}	1984-08-19	Brazil	02:57:04	4
83	2	sit	cubilia	16+	{19,22}	1946-11-17	Vietnam	01:38:10	5.3333335
84	2	dolor, tempus	vel quam	12+	{12}	2016-11-13	Canada	03:18:26	4
85	4	Curabitur ut	suscipit, est	12+	{24}	1981-09-29	Belgium	00:25:03	5
86	3	vitae aliquam	non, cursus	16+	{3}	2004-05-14	Nigeria	10:09:14	6.8333335
87	3	eu augue porttitor	dui, nec	0+	{14}	1989-12-04	Ireland	14:56:56	3
88	2	facilisis lorem	Donec porttitor	12+	{17}	1951-03-24	Netherlands	18:41:48	\N
89	3	In	aliquam iaculis, lacus	16+	{16,3}	1941-11-15	South Africa	17:46:34	5
90	4	mauris	id, ante. Nunc	6+	{14}	2004-06-24	Pakistan	09:44:14	6.8
91	1	consequat, lectus sit	tortor at	6+	{15}	1955-09-10	Turkey	11:22:51	\N
92	3	non, sollicitudin	Integer mollis.	6+	{1,12}	1985-07-13	Belgium	01:31:14	5
93	4	vel pede	justo.	12+	{7}	1936-10-06	Costa Rica	06:01:12	3.75
94	4	ipsum. Phasellus vitae	molestie	6+	{6}	2002-01-31	Spain	00:17:50	8.666667
95	2	odio. Phasellus	fermentum	16+	{11}	1954-05-28	Ireland	11:13:04	6
96	3	In at	sapien, gravida non,	12+	{12}	1955-06-23	Turkey	01:21:54	7.25
97	4	egestas	erat, eget tincidunt	12+	{20}	1961-06-22	Chile	06:32:42	5
98	3	congue	tellus id nunc	12+	{27}	1998-09-17	South Africa	23:56:39	5.6
99	1	quis,	pharetra sed,	12+	{1,2,3}	2012-09-29	Ireland	05:01:01	3.6666667
100	1	Mauris magna. Duis	egestas. Sed pharetra,	6+	{4}	1986-09-22	France	14:19:24	5.2
101	3	elit.	eu	16+	{5}	1940-10-14	Singapore	01:48:13	5
102	2	a, enim. Suspendisse	Pellentesque ut	6+	{13,7}	1955-07-25	Russian Federation	00:22:35	4.714286
103	4	ornare sagittis felis.	Duis gravida.	16+	{16,2}	1956-08-24	South Korea	16:55:22	4
104	2	leo,	non arcu.	12+	{1,2,3}	1970-01-26	Brazil	23:45:28	4.5
105	2	magnis dis parturient	ad litora	12+	{12}	1968-11-16	Russian Federation	07:09:50	2
106	4	ut lacus.	eu turpis.	16+	{8}	1938-10-02	Brazil	19:15:01	6
107	2	tortor nibh	dictum. Phasellus	12+	{5}	1980-12-02	Nigeria	14:56:50	6
108	2	dolor. Nulla semper	amet massa.	6+	{4,28}	1944-01-11	United States	20:02:43	1
109	3	Mauris	eu nibh	6+	{13}	1977-08-09	Colombia	02:28:21	4
110	2	neque vitae	tristique pellentesque,	0+	{14}	2019-09-01	Nigeria	20:01:51	5
111	4	amet metus.	sit amet	16+	{12}	2012-10-19	Canada	16:00:19	4.5
112	2	eu, eleifend	varius et,	12+	{1,2,3}	1988-11-05	Poland	03:16:18	8.5
113	3	dis parturient montes,	semper tellus	0+	{13}	1976-05-25	Ukraine	10:11:24	4.75
114	2	sem. Pellentesque	tellus non magna.	0+	{19}	1987-01-28	Indonesia	09:41:24	5.75
115	2	diam luctus	montes, nascetur	16+	{4}	1957-01-05	Canada	18:29:20	5.8333335
116	3	Cras pellentesque.	Ut	12+	{25}	1939-11-22	Sweden	13:59:08	2.5
117	4	est, mollis	Sed nunc est,	6+	{11,3}	1954-01-15	United Kingdom	13:06:41	2.5
118	3	conubia nostra,	Nullam enim.	12+	{28}	2005-12-03	South Korea	00:46:49	4.875
119	2	dolor	consectetuer adipiscing	12+	{17}	1988-08-01	Vietnam	02:55:58	5
120	1	arcu	elit, pretium	6+	{14}	1946-06-12	Vietnam	01:46:32	4.25
121	2	luctus	at	12+	{18}	2017-12-15	Poland	14:24:11	7.1666665
122	1	nec,	Etiam	6+	{9}	1962-07-30	Netherlands	20:52:31	5.2
123	3	a neque.	interdum. Nunc	12+	{8}	1998-09-03	Canada	20:59:06	3.6666667
124	3	varius orci,	nunc.	12+	{1,12}	2001-04-02	India	01:24:01	3.5
125	2	Aliquam nec enim.	Mauris	6+	{23}	2021-06-17	United Kingdom	19:15:10	6.6
126	3	pede, ultrices	vel, vulputate	6+	{1,5,9}	1969-04-23	Turkey	15:37:14	6.8333335
127	3	dictum. Proin	aliquam	0+	{21,23}	1956-11-20	Singapore	05:26:22	7.2
128	4	nibh. Quisque	viverra. Maecenas iaculis	12+	{7}	1984-07-09	Sweden	05:10:22	7
129	2	quis turpis	sed leo. Cras	12+	{27,20}	1978-05-10	South Korea	10:57:40	5.2
130	1	ac	erat nonummy ultricies	6+	{24}	1933-06-21	Netherlands	19:37:07	7.6666665
131	4	mollis	Aliquam erat	12+	{16,22}	2001-10-22	Vietnam	22:25:33	5
132	3	faucibus orci luctus	neque. Sed eget	6+	{13}	2011-04-22	Australia	17:50:58	\N
133	3	Sed	metus. Vivamus	12+	{13,7}	2018-08-12	Pakistan	17:56:19	3
134	3	et ultrices posuere	malesuada malesuada.	16+	{23}	1934-11-03	Belgium	10:36:41	6.25
135	2	quis turpis	sem. Pellentesque	12+	{8}	1937-06-28	Brazil	03:28:52	6
136	4	tempor lorem,	Ut semper	12+	{11}	1970-03-16	United States	14:32:28	3
137	1	nisl. Quisque	magnis dis	12+	{23}	1962-04-10	Costa Rica	17:39:32	5.5
138	2	auctor, velit eget	a felis	16+	{1,4,8}	1968-11-25	Australia	11:51:13	8.666667
139	4	Donec feugiat	ac,	12+	{27}	1999-05-09	Indonesia	16:57:36	4.25
140	3	erat, in	ipsum. Phasellus	12+	{1,9}	1970-03-10	Pakistan	15:34:07	\N
141	4	non ante	cursus luctus,	6+	{21}	1966-06-22	Belgium	00:52:57	9.5
142	1	lobortis tellus	fringilla, porttitor vulputate,	12+	{6}	1940-08-06	Netherlands	14:40:32	4
143	2	et ultrices posuere	posuere cubilia Curae	12+	{15}	1997-12-20	Italy	06:43:09	5.75
144	3	Quisque	velit	6+	{17}	1998-05-01	Singapore	10:14:51	6.3333335
145	2	dolor. Donec	dictum cursus. Nunc	6+	{28}	1996-04-10	Norway	00:55:00	6
146	4	nisi.	quis urna.	12+	{12}	1992-06-25	Chile	07:51:25	4.3333335
147	2	varius	Nulla	12+	{27,20}	1969-03-28	Netherlands	07:32:07	\N
148	2	et pede. Nunc	varius et, euismod	6+	{28}	1991-09-14	Turkey	21:44:47	7.25
149	3	Donec	Curae Phasellus	12+	{19}	1956-03-17	Norway	15:10:22	2
150	3	elit, dictum	Vivamus	12+	{3}	2014-01-01	Italy	15:16:16	2
\.


--
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.persons (id, person_name, person_surname, person_middle_name, person_full_name_original, main_photo_id, birthday, height, positions_ids) FROM stdin;
1	Priscilla	Jennings	Porter	Price Y. Mendez	\N	1967-07-31	201	{7}
2	Virginia	Drake	Olivia	Liberty T. Hall	\N	1942-06-12	219	{3}
3	Rowan	Pace	Gregory	Benjamin N. Mcknight	\N	1989-08-27	207	{4}
4	Denton	Houston	Vanna	Alexis F. Dorsey	73	1944-03-26	150	{7}
5	Zephania	Walton	Jackson	Reese V. Roman	\N	1939-08-31	210	{3}
6	Merrill	Vasquez	Allistair	Nola I. Pope	93	1937-03-20	175	{2}
7	Devin	Drake	Desiree	Mufutau H. Hester	126	1938-11-04	192	{2}
8	Gloria	Smith	Upton	Gloria D. Goff	119	1948-08-29	190	{3}
9	Quemby	Pacheco	Jada	Wesley H. Sloan	\N	1955-04-14	216	{7}
10	Katelyn	Spencer	Maite	Cameron O. Holcomb	36	1951-06-14	195	{8}
11	Jada	Webster	Blaze	Mari S. Morris	\N	1949-01-19	168	{4}
12	Sydney	Barron	Sylvester	Jelani F. Reynolds	139	1987-11-02	169	{8}
13	Gavin	Underwood	Felicia	Raphael M. Mueller	\N	1962-06-21	176	{4}
14	Olympia	Frederick	Brenden	Rafael Q. O'brien	\N	2014-08-22	148	{5}
15	Madaline	Merrill	Candace	Nathan Q. Hendricks	\N	1971-12-14	216	{7}
16	Lyle	Stafford	Camille	Sylvester F. Gray	\N	1950-12-31	157	{5}
17	Vivien	Lowery	Jael	Danielle D. Clements	\N	1967-08-06	207	{7}
18	Kirestin	Ray	Adrian	Aileen I. Bradshaw	110	1985-06-10	209	{9}
19	Kato	Hansen	Martha	Chloe I. Joyce	23	1971-02-28	199	{9}
20	Louis	Ellis	Alden	Yardley C. Mcgowan	86	1952-03-08	138	{8}
21	Jack	Avila	Melinda	Wade E. Brock	111	1986-07-03	217	{7}
22	Ariel	Lawson	Pearl	Quinn X. Rosa	\N	2006-12-11	152	{1}
23	Maite	Maynard	Melinda	Hiroko S. Summers	\N	1971-11-04	168	{8}
24	Ebony	Marshall	Jayme	Raymond T. Blackburn	\N	1995-10-02	142	{2}
25	Wyoming	Dickson	Avye	Beverly F. Lambert	\N	1990-05-30	212	{4}
26	Gisela	Warner	Nehru	Yasir Y. Cameron	\N	1953-12-27	147	{7}
27	Alexis	Cobb	Amy	Jackson M. Griffin	31	1983-05-03	181	{6}
28	Maile	Zamora	Yen	Neville Z. Wiggins	11	2005-06-03	170	{8}
29	Uta	Hatfield	Justina	Steven R. Black	7	1986-10-16	196	{3}
30	Althea	Bright	Baxter	Stuart M. Calderon	32	2004-10-22	144	{6}
31	Karly	Cantrell	Stewart	Isaac Q. Bowers	109	1968-07-20	159	{2}
32	Savannah	O'donnell	Tiger	Nora Q. Mack	\N	2014-08-13	172	{5}
33	Skyler	Christian	Prescott	Ginger S. Harris	\N	1956-03-07	170	{2}
34	Tanner	Levine	Farrah	Price P. Delgado	\N	1995-08-02	160	{4}
35	Yvette	Pollard	Martin	Akeem X. Sosa	\N	2006-02-27	179	{3}
36	Brody	Myers	Ivan	Lisandra X. Contreras	\N	1972-04-23	187	{5}
37	Kessie	Chambers	Hillary	Paloma D. Sloan	95	1952-09-24	207	{8}
38	Simone	Curtis	Nicole	Amena I. Lewis	12	1998-12-15	147	{8}
39	Tamara	Logan	Neve	Daria K. Cooley	\N	1975-09-21	162	{5}
40	Tanner	Hyde	Rashad	Jade R. Carey	112	1955-09-03	196	{4}
41	Hedda	Atkins	Donovan	Chantale I. Soto	20	1944-02-24	181	{2}
42	Yael	Sharp	Samantha	Maggie H. Whitley	\N	1970-09-04	154	{8}
43	Colorado	Murphy	Savannah	Walker N. Potter	137	2007-02-07	161	{9}
44	Ashton	Sexton	Howard	Maia N. O'donnell	123	1964-09-16	192	{4}
45	Leo	Wiggins	Aspen	Shay H. Jennings	87	1950-08-03	171	{6}
46	Sharon	Luna	Benjamin	Carlos L. Watson	\N	1992-11-16	162	{8}
47	Autumn	Justice	Noelani	Gary M. Pope	128	1937-06-12	205	{5}
48	Jakeem	Harrington	Bernard	Lucian S. Frazier	40	2009-06-28	204	{2}
49	Hayden	Grimes	Isaac	Abbot O. England	\N	1949-01-10	174	{8}
50	Megan	Tyler	Eric	Iona Q. Rivera	26	1973-02-18	189	{2}
51	Lesley	Wade	Sigourney	Kane V. Ball	\N	2012-01-13	160	{6}
52	Ignatius	Kane	Len	Madeson N. Hall	146	1959-11-18	194	{2}
53	Audrey	Fitzpatrick	Bruce	Lacota W. Travis	148	1994-11-16	219	{8}
54	Farrah	Ballard	Dawn	Kenneth B. Mcknight	124	1972-09-28	216	{6}
55	Matthew	Foster	Roary	Blossom Y. Gates	\N	1984-03-29	158	{2}
56	Leroy	Fulton	Harper	James S. Daniel	\N	1968-02-13	184	{2}
57	Yardley	Leon	Patrick	Oren X. Conway	\N	2008-04-08	205	{2}
58	Raya	Weber	Norman	Quon Y. Owens	5	1962-11-01	166	{8}
59	Cade	Mclaughlin	Myra	Keith B. Luna	\N	2012-08-28	205	{5}
60	Melinda	Hubbard	Claudia	Grant R. Wilkins	138	1955-05-25	160	{8}
61	Ali	Holmes	Katell	Rebecca C. Norris	101	1947-12-21	209	{5}
62	Adele	Atkins	Aileen	Erich K. Mcclain	102	2000-07-27	179	{7}
63	Gabriel	Sandoval	Zeus	Kimberly S. Woods	53	1981-07-03	176	{5}
64	Hanae	Mccarthy	Brenden	Tyrone F. Drake	28	2003-05-22	167	{3}
65	Leilani	Reilly	Sasha	Karyn N. Lloyd	107	2000-03-09	137	{2}
66	Carson	Wheeler	Omar	Gabriel U. Kramer	\N	1962-10-03	162	{2}
67	Cameron	Kerr	Elton	Adena Z. Moss	57	1975-11-17	204	{2}
68	Dacey	Maxwell	Shafira	Conan C. Cooper	42	1985-06-17	205	{4}
69	Alea	Britt	Stone	Yolanda E. Hess	77	1942-05-12	136	{8}
70	Harriet	Delacruz	Leigh	Aimee K. Anderson	74	1986-09-13	172	{2}
71	Bethany	Henson	Megan	Josephine L. Carpenter	78	1959-06-04	165	{5}
72	Ezra	Orr	Jaquelyn	Dorian N. Schmidt	\N	1971-06-23	174	{5}
73	Cheryl	Andrews	Rae	Lee F. Nielsen	67	1963-07-26	175	{8}
74	Eugenia	Stephens	Alvin	Garrett C. Hicks	\N	1993-12-05	193	{1}
75	Abigail	Barry	Victor	Latifah T. Paul	141	1944-02-04	140	{8}
76	Raja	Norman	Megan	Josiah L. Cline	\N	1995-08-01	209	{2}
77	Lysandra	Burke	Nyssa	Simone R. Short	132	1983-04-12	176	{9}
78	Quintessa	Pierce	Francesca	Gage I. Grimes	131	1976-01-26	170	{3}
79	Jennifer	Wade	Kiara	Kirk G. Rojas	54	2000-02-18	153	{2}
80	August	Boone	Cole	Ciara B. Howe	118	1979-12-15	139	{7}
81	Wade	Love	Renee	Yuri X. Maxwell	\N	1984-03-02	212	{3}
82	Elijah	Ellison	Ila	Paula U. Flowers	22	1943-03-01	149	{8}
83	Marah	Dickerson	Scarlett	Veda O. Dudley	79	2013-02-27	188	{6}
84	Camden	Rutledge	Otto	Adrienne R. Curry	\N	1952-04-26	194	{6}
85	Cally	Powell	Reece	Amy M. Richard	\N	1985-06-21	138	{5}
86	Karen	Walls	Celeste	Colette G. Lynch	\N	1971-08-19	207	{9}
87	Gil	Wooten	Meghan	Cora C. Castillo	114	1945-12-17	145	{5}
88	Sybill	Hanson	Grace	Arsenio U. Martin	\N	1973-12-28	143	{4}
89	Fatima	Medina	Holmes	Mollie R. Jacobs	104	1994-07-10	132	{7}
90	Karen	Mcgee	Quinn	Luke O. Strong	94	1989-09-26	167	{5}
91	Erich	Burris	Quintessa	Driscoll E. Shepard	\N	2002-12-08	172	{6}
92	Xavier	Kent	Wyatt	Malik A. Willis	48	1937-11-28	193	{3}
93	Maris	Espinoza	Iliana	Quentin Q. Tucker	63	1947-12-17	216	{4}
94	Paloma	Warner	Oprah	Lamar L. Keller	\N	2009-01-05	165	{3}
95	Sopoline	Carlson	Sarah	Uma O. Hodge	\N	1965-11-03	166	{1}
96	Mercedes	Foreman	Marvin	Garrison T. Sandoval	50	1960-09-26	132	{2}
97	Karyn	O'Neill	Arthur	Hiroko K. Knapp	\N	2008-03-07	156	{4}
98	Isaac	Delgado	Vaughan	Larissa Q. Hodges	72	1978-10-10	193	{2}
99	Kasper	Kennedy	Lareina	Debra R. Langley	55	1988-10-18	170	{5}
100	Kay	England	Ginger	Jessamine M. Reilly	\N	1940-04-03	182	{6}
101	Nyssa	Mcdowell	Eric	Channing N. Noble	19	2014-04-12	180	{8}
102	Aladdin	Davenport	Buckminster	Lara H. Nixon	100	1996-01-22	182	{2}
103	Amal	Cantu	Roary	Armand E. Cash	14	1949-04-14	156	{5}
104	Kieran	Hatfield	Noelani	Felicia E. Figueroa	27	1969-03-11	202	{5}
105	Leo	Salas	Lillith	Winifred J. Mcdowell	76	2006-08-26	137	{3}
106	Ahmed	Collins	Constance	Kiona Q. Ballard	98	2011-08-13	219	{9}
107	Trevor	Page	Xena	Athena D. Pierce	90	2009-11-26	177	{9}
108	Sylvester	Johns	Gareth	Jayme B. Potts	8	1993-05-05	165	{6}
109	Joshua	Yates	Marah	Adam F. Morris	25	1999-05-01	213	{4}
110	Marcia	Figueroa	Armando	Isabelle J. Mccoy	45	1978-09-15	208	{2}
111	Scott	Frye	Burton	Jasper U. Gomez	84	2004-12-11	134	{2}
112	Honorato	Calhoun	Suki	Kirk C. Glover	37	1948-03-17	165	{7}
113	Sage	Jenkins	Kai	Libby P. Sargent	82	2006-11-26	207	{4}
114	Zelenia	Harper	Gregory	Kyla S. Dominguez	\N	1952-03-10	134	{9}
115	Jennifer	Oliver	Arsenio	Kyle D. Valencia	38	1983-04-15	147	{8}
116	Beatrice	Bond	Donovan	Laurel V. Preston	113	1975-09-21	186	{5}
117	Colt	Contreras	Hashim	Quinn G. Sherman	43	1943-12-15	217	{5}
118	Vivien	Berry	Gabriel	Fulton N. Good	65	2004-11-17	147	{2}
119	Alice	Thornton	Mannix	Axel H. Roberts	116	1988-01-10	167	{5}
120	Camden	Moran	Wing	Jena V. Guthrie	134	1938-01-02	192	{7}
121	Fulton	Dale	Justin	Arthur U. Murphy	\N	1935-06-08	217	{6}
122	Desiree	Spears	Ina	Beau Q. Mcintyre	\N	2004-07-05	217	{9}
123	Dolan	Stevens	Keaton	Roth G. Lowe	9	1937-11-02	217	{6}
124	Dennis	Murray	Rae	Tasha J. Robertson	\N	1984-03-02	157	{3}
125	Carla	Good	Kitra	Dylan S. Richardson	106	1959-06-24	134	{8}
126	Jenna	Hayes	Zia	Kirk F. Durham	105	2009-08-20	160	{5}
127	Chancellor	Branch	Wilma	Wanda I. Cooley	\N	1951-08-16	203	{8}
128	Amethyst	Aguilar	Eve	Kane K. Wyatt	97	2001-06-28	207	{5}
129	Nomlanga	Galloway	Ria	Octavia J. Mueller	34	1983-11-21	184	{7}
130	Devin	Frazier	Alea	Bell C. Short	\N	1945-07-10	131	{6}
131	Briar	Walters	Fiona	Renee K. Gilmore	\N	1971-12-13	208	{1}
132	David	Dotson	Dale	Hiram N. Craft	135	1970-05-24	207	{1}
133	Yuli	Velez	Jeanette	Armand M. Kirk	59	1992-05-29	218	{4}
134	Caleb	Britt	Ocean	Malcolm H. Oliver	\N	1976-10-03	189	{3}
135	Cally	Hobbs	Vance	Amos O. Jensen	129	1981-10-10	176	{2}
136	Gail	Matthews	Claire	Anjolie S. Silva	91	2005-09-23	199	{3}
137	Rashad	Blair	Martin	Madeson B. Castaneda	4	1970-02-03	203	{5}
138	Miriam	Rush	Alec	Francesca S. Mendoza	88	1935-06-17	176	{2}
139	Owen	Drake	Elaine	Joan D. Stone	16	1955-11-17	162	{9}
140	Moses	Ayers	Lane	Warren F. Reynolds	92	1944-08-23	179	{7}
141	Clinton	Summers	Diana	Ursula G. Turner	\N	1956-03-27	181	{3}
142	Tallulah	Fields	Hector	Travis H. Thompson	\N	1937-02-28	191	{2}
143	Hiram	Downs	Chantale	Nehru L. Butler	121	1970-02-23	168	{6}
144	Mark	Richards	Darrel	Nigel I. Daugherty	\N	1940-10-01	151	{5}
145	Sebastian	Haney	Wallace	Fritz H. Reid	\N	1959-09-25	206	{8}
146	Mercedes	Thomas	Zephania	Mohammad G. Wilkinson	\N	1982-12-01	147	{8}
147	Nayda	Bonner	Haviva	Wang U. Goff	\N	1999-12-28	148	{5}
148	Murphy	Foreman	Jermaine	Aaron U. Pollard	\N	1993-10-20	210	{2}
149	Kirsten	Steele	Rhona	Iliana P. Bartlett	\N	1990-02-01	150	{8}
150	Shea	Barron	Anastasia	Nathan U. Burke	\N	1970-03-14	145	{4}
\.


--
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.positions (id, position_name) FROM stdin;
1	Актер
2	Режисер
3	Продюсер
4	Оператор
5	Художник
6	Гример
7	Каскадер
8	Художник по костюмам
9	Светооператор
10	Консультант
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.roles (id, movie_id, person_id, character_name, is_main_role) FROM stdin;
1	130	65	Brady T. Day	t
2	149	141	Jonah T. Harper	f
3	34	62	Alice L. Barry	f
4	100	117	Guinevere Q. Hatfield	t
5	118	112	Zane H. Franco	t
6	81	70	Ferris X. Waters	t
7	38	65	Plato X. Prince	f
8	35	5	Violet G. Britt	t
9	21	110	Florence N. Preston	t
10	48	89	Owen I. Simmons	f
11	52	59	Nita C. Christensen	f
12	38	29	Carl E. Adams	t
13	65	74	Gretchen U. Middleton	t
14	73	34	Solomon G. Curtis	t
15	12	131	Dolan F. Madden	t
16	27	30	Wilma O. Ball	f
17	14	14	Tatyana S. Stephenson	t
18	73	29	Tobias G. Brewer	f
19	127	120	Joseph P. Tran	f
20	75	106	Edan Q. Burns	t
21	90	88	Halee O. Blankenship	t
22	103	59	Phillip M. Hardin	t
23	78	69	Ruth U. Blair	f
24	124	105	Charles E. Chavez	f
25	45	103	Tanisha V. Coleman	t
26	16	89	Clark M. Salazar	t
27	10	144	Grady X. Michael	t
28	115	80	Pearl M. Berry	f
29	112	31	Graham J. Quinn	t
30	119	127	Mikayla J. Brown	f
31	45	85	Dana E. Fry	f
32	146	83	Scarlett I. Wright	t
33	80	142	Jessica C. Guthrie	f
34	57	145	Jin Q. Manning	t
35	4	116	Micah G. Woodard	t
36	73	106	Lareina J. Donovan	f
37	112	150	Keefe F. Ayers	f
38	27	94	Todd B. Pope	f
39	45	96	Tobias X. Maxwell	f
40	134	69	Noel E. Sloan	f
41	4	30	Brenda V. Thornton	f
42	68	39	Imelda S. House	f
43	128	56	Freya I. Dudley	t
44	80	147	Claudia G. Townsend	t
45	23	38	Sara T. Manning	f
46	36	143	Cade O. Holden	t
47	9	110	Charlotte P. Blake	f
48	143	139	Irma D. Pate	f
49	41	96	Keith N. Ramsey	f
50	127	101	Amir L. Dillon	t
51	136	40	Isabella J. Kirkland	t
52	147	28	Wylie X. Lowe	t
53	67	10	Caldwell J. Short	t
54	46	143	Ivan E. Lawson	t
55	12	61	Lana B. Castaneda	f
56	99	49	Maryam H. Woodard	t
57	146	77	Medge L. Miller	f
58	16	42	Xavier X. Burch	t
59	126	36	Ezekiel M. Garcia	t
60	73	34	Harriet D. Rich	t
61	17	66	Quyn T. Valenzuela	f
62	87	96	Griffin X. Carver	t
63	3	91	Tobias F. Lynch	f
64	131	93	Brent I. Holt	f
65	10	69	Herrod T. Cohen	t
66	11	75	Kennedy K. Gonzales	f
67	110	121	Guy E. Frederick	f
68	3	39	Lani D. Neal	f
69	67	65	Marah C. Glass	t
70	32	139	Velma N. Kelly	t
71	77	64	Dustin H. Snyder	t
72	2	130	Myles U. Blake	f
73	55	137	Geoffrey A. Guerrero	f
74	63	75	Guinevere S. Johns	t
75	85	25	Zenaida G. Velazquez	t
76	40	147	Devin B. Burton	t
77	143	13	Hanna M. Baird	f
78	131	143	Lani G. Christensen	t
79	140	135	Malcolm R. Guthrie	t
80	37	106	Alexander W. Terry	f
81	57	89	Gabriel E. Simpson	t
82	81	95	Audra F. Cohen	t
83	6	135	Claire L. Roy	t
84	43	46	Levi F. Moody	t
85	125	15	Christopher U. O'brien	f
86	99	14	Emi V. Mitchell	t
87	114	87	Rajah B. Pacheco	f
88	42	64	Solomon U. Mills	f
89	9	18	Gareth F. Tate	f
90	25	92	Avye G. Fox	f
91	33	89	Desiree O. Tyler	f
92	57	102	Shelby O. Logan	f
93	76	96	Cheryl U. Horn	t
94	133	149	Inez O. Dalton	t
95	61	45	Brett S. England	f
96	4	73	Dane P. Clemons	f
97	59	17	Jack X. Conner	t
98	22	120	Prescott V. Fuentes	t
99	13	98	Nasim T. Holloway	t
100	15	138	Travis U. Cantrell	t
101	31	79	Vera G. Witt	f
102	40	41	Odette B. Nunez	t
103	16	70	Dominic E. Stafford	f
104	92	31	Odette O. Clay	f
105	101	133	Hedley B. Baker	f
106	109	149	Dustin G. Boyer	t
107	125	3	Sandra V. Mason	t
108	52	128	Hadassah G. Grant	f
109	63	74	Kareem M. Mendoza	f
110	69	66	Teagan O. Moses	f
111	87	110	Jesse K. Potts	t
112	17	38	Kirsten Q. Spencer	f
113	11	19	Octavia K. Nguyen	f
114	56	103	Paloma T. Lester	t
115	85	38	Quamar F. Lowery	t
116	50	11	Drew W. Frazier	f
117	23	74	Burton G. Dickson	f
118	76	4	Rajah T. Lindsay	f
119	43	142	Vaughan M. Roth	t
120	133	20	Hu J. Wooten	t
121	150	13	Aimee K. Downs	t
122	93	25	Zephr Q. Welch	t
123	14	131	Ralph X. Patterson	f
124	3	38	Rudyard V. Rodriguez	t
125	61	143	Theodore T. Mcclure	f
126	60	22	Lucas B. Pearson	f
127	13	77	Benjamin H. Love	f
128	31	131	Jessamine G. Atkins	t
129	49	47	Kimberley U. Kelley	t
130	126	50	Cleo Y. Welch	t
131	48	43	Portia V. Wilkins	t
132	91	75	Walker O. Mckinney	f
133	50	128	Gannon Z. Chan	t
134	31	139	Rosalyn M. Carr	f
135	78	142	Bell K. Herrera	f
136	91	78	Melvin F. Bryan	t
137	134	51	Rinah I. Lane	t
138	11	88	Celeste G. Robertson	t
139	13	148	Michael V. Wood	f
140	103	86	Chadwick D. Saunders	f
141	7	76	Keefe U. Jimenez	t
142	94	148	Keith N. Landry	t
143	22	6	Hu L. Walsh	f
144	38	5	Brady O. Yang	f
145	90	126	Silas W. Church	t
146	67	76	Cain Y. Knapp	f
147	74	73	Dale O. Bryan	t
148	56	6	Wallace R. Dixon	f
149	87	26	Xavier K. Price	f
150	66	120	Robin M. Carter	f
151	41	48	Skyler S. Davidson	f
152	144	44	Leigh J. Pate	t
153	40	92	Robin K. Lloyd	f
154	94	76	Nissim W. Riddle	f
155	1	27	Kasimir J. Clay	t
156	110	30	Macaulay Z. Francis	f
157	46	39	Hilel Q. Hopper	f
158	86	10	Justina W. Munoz	t
159	132	150	Samuel F. Scott	f
160	70	145	Lucian G. England	t
161	60	43	Imani U. Summers	t
162	8	70	Lillith Q. Callahan	t
163	27	61	Evan S. Raymond	f
164	83	31	Macey E. Simpson	t
165	73	109	Raphael K. Lee	f
166	110	62	Alexis S. Fitzgerald	f
167	82	42	Rachel T. Combs	f
168	139	5	David F. Ray	f
169	105	75	Kieran X. Farley	f
170	58	128	Cyrus B. Garner	t
171	73	16	Joseph H. Saunders	f
172	43	24	Karyn N. Pratt	t
173	4	70	Hu G. Cooper	f
174	95	132	Mason K. Middleton	f
175	88	114	Benedict C. Lott	f
176	143	42	Gil W. Morrison	t
177	127	13	Melvin M. Duffy	t
178	85	79	Aurora I. Morris	f
179	126	69	Stuart R. Shaffer	f
180	40	93	Joshua K. Gillespie	t
181	39	43	Quinlan T. Hendricks	f
182	41	11	Quemby Y. Allison	f
183	69	21	Roary B. Richard	t
184	38	14	Yetta K. Pierce	f
185	14	69	Rae R. Shepherd	t
186	62	66	Bert Q. Massey	t
187	106	21	Clio X. Charles	t
188	148	92	Mollie U. Pugh	t
189	72	17	Ulysses H. Delaney	f
190	82	124	Quinn B. Kelly	f
191	84	119	Kuame X. Maynard	f
192	61	111	Kylynn C. Everett	f
193	127	88	Kimberley U. Meyer	t
194	42	148	Zenaida M. Stanley	t
195	122	48	Erin I. Whitfield	f
196	22	60	Winifred W. Glover	t
197	71	99	Honorato P. Robbins	t
198	104	67	Jesse R. Webb	f
199	126	91	Samson A. Strong	t
200	21	64	Channing D. Le	t
201	20	39	Steven W. Le	t
202	64	83	Ruby B. Beard	t
203	118	140	Ivy M. Hart	f
204	46	35	Imogene Q. Hubbard	f
205	79	85	Noble E. Hutchinson	t
206	62	84	Macy N. Roberts	t
207	101	48	Abbot O. Wagner	f
208	133	40	Josiah Z. Jackson	t
209	73	108	Demetria P. Kerr	f
210	65	33	Caleb P. Guthrie	t
211	110	76	Geoffrey U. Dickson	f
212	111	48	Jennifer R. Rhodes	f
213	149	86	Meredith M. Weaver	f
214	70	7	Levi T. Dotson	f
215	100	144	Alvin F. Carrillo	f
216	90	34	Evelyn E. Gaines	t
217	100	100	Ruby Q. Hebert	f
218	128	73	Jessamine E. Gilmore	t
219	29	43	Erica S. Strong	f
220	23	127	Montana K. Cook	f
221	23	34	Chandler E. Reyes	f
222	40	124	Maisie L. Buckley	f
223	144	74	Hamilton Y. Short	t
224	68	18	Rowan J. Doyle	t
225	68	129	Ariel G. Vang	f
226	137	41	Jillian S. Sharp	t
227	123	9	Joy Y. Doyle	f
228	100	5	Graham M. Lowery	t
229	45	71	Jayme T. Lewis	f
230	126	54	Bethany J. Sykes	f
231	143	146	Echo D. Bryan	f
232	23	68	Valentine F. Whitehead	t
233	41	149	Thaddeus F. Mcfadden	f
234	98	131	Blake R. Pate	f
235	102	68	Colt M. Humphrey	f
236	115	86	Colton X. Guzman	t
237	19	107	Natalie Q. Porter	t
238	35	146	Galvin O. Hansen	t
239	75	21	Barry W. Barber	t
240	68	68	Brennan I. Burch	t
241	143	81	Orson Q. Hensley	t
242	79	123	Kennan I. Ballard	t
243	99	109	Carla G. Lowery	t
244	65	112	Lani L. Vasquez	t
245	72	83	Arsenio G. Warner	t
246	17	6	Maite G. Erickson	t
247	59	147	Upton X. Brock	f
248	17	126	Violet R. Pacheco	t
249	56	41	Vance X. Marshall	f
250	9	14	Aimee S. Wall	t
251	106	89	Flavia R. Leach	f
252	57	141	Jared I. Santos	t
253	84	44	April B. Monroe	f
254	24	28	Urielle K. Owens	t
255	63	148	Ferris J. Melendez	f
256	23	80	Travis N. Christensen	f
257	123	38	Yael T. Davis	t
258	99	87	Griffin G. Pugh	f
259	35	26	Ali S. Morin	f
260	91	138	Sharon T. Powers	t
261	113	145	Ian Q. Hurley	t
262	71	47	Hedley O. Wilkins	f
263	141	27	George V. Burch	t
264	69	120	Yuri Y. Barnett	f
265	132	57	Tanner J. Roberson	t
266	64	65	Wayne A. Molina	t
267	6	118	Ivor H. Joyner	f
268	91	45	Kyla W. Burke	f
269	59	26	September Y. Merrill	f
270	16	91	Christen X. Hardin	t
271	82	125	Reese T. Rodgers	t
272	72	47	Marsden G. Spencer	f
273	42	49	Ima H. Duran	t
274	131	118	Leonard E. Wolf	f
275	9	30	Dahlia Y. Farrell	t
276	112	42	Stacey O. Day	t
277	97	58	Burke Y. Copeland	t
278	4	35	Zoe O. Horne	t
279	60	89	Aurora Y. Fleming	f
280	138	148	Emmanuel R. Mueller	f
281	96	34	Ursula M. Rollins	t
282	102	76	Yvonne L. Greer	t
283	122	112	Lydia M. Park	t
284	10	17	Tanner H. Baird	t
285	43	49	Vanna Y. Spence	f
286	21	17	Barry O. Warner	f
287	28	104	Gary S. Rutledge	f
288	78	44	Cathleen G. Alston	f
289	49	14	Jason U. Davis	t
290	1	81	Kiara G. Bailey	t
291	18	43	August O. Cortez	t
292	73	128	Xenos F. Mercado	t
293	70	10	Jerry I. Larson	t
294	46	35	Kenyon R. Blackburn	f
295	22	77	Winifred U. Rojas	f
296	98	67	Gemma D. Saunders	t
297	47	47	Catherine N. Noel	f
298	108	128	Ignatius C. Walker	f
299	99	44	Karyn W. O'connor	f
300	109	43	Serina A. Mooney	f
\.


--
-- Data for Name: stars; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.stars (movie_id, user_id, number_of_stars, rated_at) FROM stdin;
14	112	3	2021-10-27 09:51:25
71	115	6	2022-03-14 01:04:02
134	24	7	2023-04-02 12:48:09
12	139	10	2022-10-29 10:52:11
108	145	1	2021-12-07 12:40:05
97	49	9	2022-04-11 06:00:54
43	100	5	2023-06-17 05:28:16
99	11	4	2022-08-10 06:35:12
89	34	4	2023-06-02 10:14:56
115	142	7	2022-05-27 08:00:43
129	98	1	2023-03-20 05:31:37
10	112	6	2023-01-29 11:27:34
61	31	2	2023-04-18 03:54:57
96	30	6	2022-11-09 06:35:38
61	76	2	2023-08-21 10:01:59
105	25	2	2021-12-16 01:47:44
95	131	6	2022-03-06 04:49:36
16	60	6	2023-07-08 02:24:39
142	5	4	2021-12-17 12:46:37
15	37	5	2023-06-18 11:05:40
118	40	5	2023-05-31 03:28:45
40	19	5	2022-09-03 03:11:59
121	85	5	2023-02-13 08:28:47
69	100	4	2022-06-26 07:54:39
65	141	7	2022-02-21 02:24:15
24	97	5	2022-05-29 05:09:43
37	127	3	2022-09-12 01:36:33
99	32	4	2023-01-28 01:59:38
97	69	7	2022-07-19 06:56:41
28	35	3	2023-09-25 06:06:29
102	50	7	2022-07-01 11:55:37
115	4	6	2023-07-04 06:34:30
8	81	3	2022-02-25 12:44:05
87	9	3	2023-06-03 06:01:46
120	19	8	2023-07-30 02:16:58
94	46	9	2021-11-03 05:31:29
21	29	3	2022-07-05 04:13:13
2	36	10	2022-02-06 05:38:27
85	28	5	2022-12-26 03:09:41
148	65	9	2023-09-14 08:42:22
109	124	5	2022-06-05 03:22:09
141	59	10	2023-04-12 02:59:36
29	93	4	2022-01-10 02:47:13
113	149	7	2023-06-06 12:55:54
111	61	3	2022-11-12 04:47:38
38	66	4	2021-11-29 06:42:13
14	64	7	2022-10-24 08:23:23
44	143	6	2022-10-25 08:04:40
12	98	5	2023-03-08 06:54:25
127	143	9	2023-03-28 02:18:53
115	95	5	2022-08-25 12:06:47
96	76	10	2022-12-29 08:41:18
136	74	4	2023-01-18 02:15:02
78	116	8	2022-03-21 11:38:29
27	112	8	2021-11-02 01:57:50
42	131	10	2023-05-30 08:12:27
60	63	1	2021-12-24 06:29:51
74	6	2	2023-03-31 02:49:07
133	19	6	2022-03-19 04:41:35
76	131	6	2022-01-21 07:00:11
26	132	8	2022-03-10 03:36:32
56	19	8	2023-02-11 04:19:56
50	97	10	2023-04-11 07:07:55
96	15	7	2023-05-27 05:50:39
110	118	8	2021-11-13 02:41:21
59	147	4	2022-08-14 04:47:45
114	24	6	2023-06-24 07:47:44
39	72	6	2023-07-05 10:54:56
47	11	1	2022-11-02 06:14:39
48	102	9	2022-06-09 09:38:24
64	52	2	2023-04-07 09:41:11
40	132	3	2021-12-23 12:59:33
75	25	6	2023-01-22 09:35:24
125	18	7	2021-10-03 02:44:35
138	51	10	2022-12-20 05:21:38
68	49	7	2023-06-07 06:38:31
139	72	3	2023-07-21 02:28:21
6	80	6	2021-11-08 03:41:01
135	10	4	2022-08-02 07:55:20
45	63	2	2023-07-27 04:12:55
46	84	1	2021-11-27 01:35:26
49	70	2	2023-03-16 01:36:08
68	56	9	2021-12-12 10:32:36
150	99	2	2022-06-28 10:17:19
74	34	8	2022-10-26 12:40:05
61	71	1	2022-01-18 06:44:22
77	146	4	2022-11-11 11:24:07
48	127	7	2023-07-14 02:25:29
106	122	7	2022-03-31 10:08:31
6	33	2	2023-02-09 02:12:23
6	141	5	2021-12-28 07:16:18
6	102	9	2023-05-29 04:19:32
15	29	5	2023-08-29 11:36:32
9	46	4	2022-10-01 11:27:28
32	72	4	2022-03-05 04:44:07
85	104	9	2021-12-12 02:37:57
126	83	5	2023-09-13 06:02:33
120	109	2	2023-05-17 09:21:30
61	147	1	2023-01-15 07:29:08
129	49	5	2023-03-06 04:08:23
11	70	2	2022-09-05 01:25:55
41	141	7	2022-08-19 06:03:15
86	144	9	2022-04-11 08:35:39
17	134	4	2022-12-05 02:33:53
74	111	9	2022-05-29 01:22:08
52	43	1	2022-11-10 01:35:12
122	57	8	2022-04-27 11:11:47
128	114	6	2021-12-26 06:39:43
69	112	8	2023-01-05 06:26:40
26	142	6	2023-08-05 09:51:46
143	34	3	2022-01-29 10:25:51
69	43	6	2022-07-18 06:45:00
137	57	7	2022-02-11 11:21:22
104	105	1	2023-01-18 10:31:39
72	106	3	2022-10-13 02:03:21
11	59	1	2022-01-18 11:26:57
97	136	7	2022-01-24 12:19:30
17	91	5	2022-09-21 12:59:22
94	13	7	2022-12-29 09:11:32
77	90	2	2023-06-19 08:11:54
83	4	4	2022-11-30 01:13:31
110	62	1	2023-06-03 05:48:48
139	20	7	2022-10-17 11:36:50
77	97	6	2022-05-25 04:13:00
21	132	9	2022-11-22 08:25:21
33	8	6	2022-04-07 12:29:55
53	136	2	2022-05-11 09:31:01
146	13	8	2022-11-13 06:09:33
43	47	7	2022-10-21 09:36:19
14	123	7	2021-12-30 07:47:38
10	63	10	2022-09-05 05:32:26
98	49	4	2022-07-23 02:25:33
35	60	5	2022-08-10 11:08:15
93	101	2	2022-09-25 10:23:24
16	29	9	2022-12-25 03:24:54
106	13	5	2022-10-27 11:33:26
143	89	9	2021-10-14 11:59:27
125	100	7	2022-01-31 04:02:34
93	92	4	2022-06-30 07:20:58
49	5	8	2023-03-13 02:12:34
41	138	7	2022-02-24 01:48:02
73	95	2	2021-12-20 05:04:13
17	48	9	2023-09-17 05:13:59
60	119	9	2022-09-15 06:04:40
60	91	1	2021-11-16 11:28:02
32	90	6	2022-06-10 05:19:29
73	90	9	2022-11-14 08:16:32
104	53	4	2022-11-21 09:30:47
111	27	3	2022-11-07 08:57:16
122	29	6	2022-06-10 10:40:12
33	38	5	2022-05-19 11:40:16
56	80	5	2023-03-04 09:54:13
61	146	10	2022-02-21 04:59:27
92	75	5	2023-03-04 09:19:40
64	82	6	2022-11-08 07:09:04
119	98	5	2022-10-20 06:00:13
63	73	8	2022-11-30 11:43:09
2	61	5	2021-12-22 06:59:51
71	45	1	2023-02-07 01:37:59
84	83	6	2022-07-12 09:53:18
138	37	8	2021-11-15 08:35:59
39	48	3	2022-08-12 11:57:35
56	144	10	2023-09-04 01:03:56
65	139	7	2021-11-02 05:09:32
112	121	9	2022-09-07 07:50:21
81	104	10	2022-08-01 01:05:06
114	51	6	2022-09-29 09:17:18
7	6	2	2022-06-30 12:21:19
148	17	5	2021-11-09 01:57:40
67	33	8	2022-11-22 05:39:44
120	149	2	2021-10-17 08:40:19
123	21	2	2022-04-26 01:59:22
86	5	7	2022-03-10 04:22:20
14	118	2	2022-08-16 05:16:49
36	134	9	2023-03-11 02:26:19
37	39	8	2023-06-09 12:15:54
65	37	2	2023-07-31 11:15:30
97	20	2	2023-08-04 09:00:34
101	6	3	2022-03-07 03:22:43
63	81	5	2023-01-14 11:07:30
75	26	7	2023-05-28 11:09:20
98	8	1	2022-08-30 06:42:24
100	134	9	2021-10-05 06:10:47
115	64	6	2022-12-21 09:48:46
46	137	3	2022-10-21 04:50:25
60	52	3	2022-12-21 10:26:48
65	38	8	2022-04-07 06:37:49
8	141	10	2022-06-30 02:48:36
29	91	2	2022-12-11 02:27:46
70	101	5	2022-03-23 03:45:37
103	3	6	2022-02-07 08:59:12
38	38	2	2022-07-03 09:23:40
5	3	6	2021-10-22 06:33:00
127	13	9	2021-10-23 04:38:54
45	4	5	2023-05-05 09:31:10
29	127	3	2022-03-24 07:59:13
42	141	3	2022-07-04 06:30:40
90	89	9	2023-03-20 10:58:21
109	1	7	2023-09-24 11:54:34
110	100	6	2023-02-11 10:58:14
37	82	6	2022-05-21 03:02:42
33	113	6	2022-03-20 06:03:02
47	96	5	2023-07-12 02:46:06
26	26	3	2022-06-02 05:07:07
125	67	8	2022-07-17 05:57:59
61	94	9	2023-03-05 12:34:19
136	56	4	2021-11-25 09:58:42
60	67	2	2021-12-08 05:08:48
54	13	4	2021-12-18 12:51:47
100	131	2	2021-10-28 09:24:17
58	46	7	2022-11-11 03:50:32
129	32	9	2022-09-28 01:58:55
21	112	3	2023-05-04 12:42:28
63	7	5	2023-09-10 05:58:19
57	67	10	2022-07-13 12:37:47
124	3	2	2022-12-30 04:23:44
26	141	10	2023-04-06 07:03:57
25	41	9	2023-03-18 09:40:13
112	30	8	2023-04-17 06:27:37
130	127	9	2022-06-21 03:14:48
81	147	2	2023-08-03 11:45:00
52	139	7	2023-04-01 09:14:23
141	114	9	2023-06-11 02:12:47
78	70	2	2023-05-07 06:42:00
28	115	1	2022-04-13 12:57:03
74	41	3	2023-05-04 06:03:48
80	92	2	2022-08-15 05:40:58
44	75	9	2023-01-20 10:26:48
28	72	2	2021-11-18 08:01:31
148	24	5	2023-08-27 04:10:03
101	51	7	2022-08-17 12:43:40
57	14	6	2022-12-06 04:11:56
80	64	10	2022-03-24 05:20:54
63	133	5	2022-08-27 07:23:11
107	27	6	2022-12-19 05:50:32
127	103	3	2021-12-23 01:59:13
38	11	4	2023-05-20 02:16:20
125	49	9	2023-04-08 12:48:45
56	106	5	2023-02-18 05:35:46
10	110	4	2022-10-08 12:49:51
52	108	2	2023-07-01 04:25:21
67	86	3	2021-11-16 12:19:46
26	115	4	2023-09-22 05:03:33
89	54	4	2022-10-03 07:45:05
81	64	8	2023-07-26 02:50:06
84	8	1	2023-02-12 01:53:52
113	146	7	2022-04-17 04:51:54
3	108	7	2021-10-21 08:25:18
28	27	6	2023-05-09 06:04:16
102	80	1	2022-06-05 08:05:04
11	98	8	2023-08-20 11:28:49
64	133	5	2022-02-17 06:46:14
104	112	6	2022-03-23 10:13:40
42	117	6	2023-07-02 06:09:26
81	88	4	2022-03-15 09:21:42
118	116	6	2022-11-11 05:21:25
114	128	6	2022-10-05 03:21:49
144	134	7	2022-11-14 09:37:06
124	108	7	2022-10-23 01:28:31
129	126	10	2022-12-26 02:57:24
7	128	4	2022-07-01 10:14:44
118	22	2	2021-11-01 02:09:13
76	34	4	2022-08-18 02:51:57
148	4	10	2021-12-29 05:37:01
119	23	1	2021-11-08 04:39:57
3	93	9	2022-10-12 11:22:17
129	43	1	2023-03-22 07:17:08
52	12	9	2023-06-20 09:51:48
15	88	3	2023-08-19 07:49:45
78	144	5	2022-11-28 08:49:11
19	72	1	2021-10-03 04:51:09
122	66	2	2022-04-24 09:47:35
52	29	9	2022-01-19 09:07:21
113	132	2	2022-09-19 02:51:26
76	28	9	2022-11-15 10:32:46
109	2	4	2022-11-09 02:58:35
71	82	3	2022-07-21 10:39:08
58	63	8	2021-11-20 01:10:01
120	4	5	2023-04-23 07:55:21
89	56	7	2023-01-23 09:38:46
12	84	7	2023-01-31 10:48:17
134	130	8	2023-01-07 11:00:30
68	15	7	2021-11-16 02:25:18
116	53	2	2022-01-03 11:07:49
36	44	10	2021-10-11 01:50:45
97	8	4	2022-03-20 02:59:02
46	122	3	2023-07-02 02:47:55
12	73	7	2023-09-07 04:20:37
139	146	1	2023-07-02 03:18:04
17	37	8	2022-01-26 05:59:43
126	82	10	2021-10-19 12:23:21
31	75	2	2021-10-22 01:54:39
135	36	7	2023-04-09 11:45:16
8	114	9	2022-03-18 06:44:19
99	93	3	2023-03-13 12:15:06
25	96	3	2023-06-30 08:18:32
4	6	2	2022-12-21 01:33:55
53	90	9	2023-09-19 10:18:30
18	89	4	2022-01-13 11:30:58
74	116	6	2022-12-02 07:55:28
102	58	2	2022-09-06 08:18:01
65	124	6	2021-10-13 07:57:08
27	134	8	2022-01-03 12:51:27
6	73	4	2022-07-01 05:12:59
143	107	7	2022-03-14 10:49:13
110	96	8	2023-02-11 01:25:46
62	89	6	2022-03-28 05:09:50
118	15	9	2023-06-06 08:49:22
121	82	3	2022-11-14 05:44:11
95	45	6	2022-12-19 06:48:06
57	40	6	2022-08-06 12:28:03
94	94	10	2023-03-27 09:50:23
126	17	2	2022-11-06 03:33:04
64	117	2	2023-02-13 03:29:47
126	10	6	2022-10-08 01:34:11
123	14	6	2023-03-16 05:47:49
18	72	3	2021-09-27 06:38:58
149	67	2	2021-12-25 07:00:26
121	41	9	2023-03-11 03:44:56
124	80	2	2023-04-15 08:41:34
55	100	6	2023-03-16 11:09:53
111	126	7	2022-11-03 04:07:30
75	60	4	2023-09-01 06:13:35
30	31	4	2023-08-07 06:41:33
122	100	6	2022-02-01 07:35:52
47	50	10	2022-01-24 12:16:22
118	48	5	2023-05-17 09:48:44
86	142	3	2021-09-29 09:01:56
136	117	1	2022-06-16 10:37:30
16	22	4	2021-10-04 07:12:35
61	36	2	2023-09-21 04:18:36
20	88	9	2023-04-27 02:58:24
83	38	6	2021-11-17 03:58:44
133	104	2	2023-08-30 11:52:11
75	141	8	2023-05-23 11:31:30
12	149	6	2022-10-29 12:14:45
18	148	8	2022-01-09 08:49:22
93	95	4	2023-04-02 03:51:59
102	13	9	2022-06-07 02:23:39
4	111	4	2022-05-07 02:14:48
113	57	3	2022-08-19 03:36:55
24	21	5	2021-12-21 12:41:48
126	140	9	2022-01-09 02:14:06
119	85	7	2022-05-04 06:01:00
51	16	4	2023-01-06 06:40:38
75	32	4	2022-11-20 12:59:43
9	102	3	2021-12-22 03:29:19
131	63	5	2022-12-31 07:46:28
7	147	5	2022-07-20 01:22:08
137	7	4	2023-03-25 09:49:41
3	97	3	2022-05-25 11:48:20
146	89	1	2023-08-16 07:10:43
11	39	3	2022-08-26 07:52:42
144	146	5	2022-11-17 07:28:15
61	110	2	2023-08-22 11:51:09
43	110	10	2022-05-21 02:06:42
97	61	1	2022-11-30 01:46:29
87	111	5	2022-07-27 03:32:08
69	16	5	2022-04-27 05:21:32
78	28	10	2023-02-24 09:31:35
26	46	8	2022-07-20 02:39:14
98	96	9	2023-03-21 01:05:58
127	100	6	2021-10-25 11:49:54
128	150	8	2022-02-26 07:55:10
102	56	6	2021-11-08 12:55:45
100	32	2	2023-07-28 12:33:12
82	26	2	2022-07-21 01:35:58
110	19	2	2023-08-12 06:51:34
119	22	7	2022-05-27 08:18:39
85	35	4	2022-10-20 12:41:30
50	25	6	2022-07-18 02:57:07
96	13	6	2021-10-08 10:45:48
15	7	3	2021-12-02 10:51:19
121	106	9	2022-06-10 11:45:49
81	57	9	2022-07-01 03:48:42
58	94	1	2021-10-26 09:38:27
63	130	9	2023-02-04 08:27:23
77	101	7	2023-03-02 10:03:05
130	143	5	2023-05-02 04:33:00
92	108	9	2023-04-19 08:56:16
121	77	9	2022-08-28 05:48:31
86	65	10	2021-10-18 12:36:49
90	57	7	2022-01-03 04:16:51
36	95	10	2023-01-18 10:17:34
34	139	3	2023-05-05 06:25:36
51	56	9	2022-05-03 07:28:52
18	117	6	2023-04-02 10:24:37
9	67	5	2023-07-29 07:08:08
55	78	8	2022-03-28 01:14:13
60	75	6	2022-08-07 01:31:45
72	98	8	2022-05-07 12:02:00
73	28	4	2023-05-28 01:23:47
11	21	5	2022-08-20 10:57:37
124	75	3	2021-10-25 03:38:39
82	95	3	2021-10-19 07:59:30
122	10	4	2023-06-24 10:19:30
48	101	4	2023-01-12 09:46:34
106	68	6	2022-07-19 02:04:06
12	45	2	2023-04-15 06:36:41
117	25	1	2021-12-25 09:32:35
24	56	9	2023-02-16 10:06:55
139	61	6	2022-02-22 12:05:19
20	27	5	2022-08-23 08:32:05
48	74	4	2022-03-08 07:14:51
44	84	7	2023-08-25 02:13:20
117	115	4	2022-12-09 10:17:24
64	8	8	2021-11-18 03:09:55
127	33	9	2023-01-04 05:59:03
73	53	6	2022-06-01 08:17:13
32	125	8	2022-01-20 08:03:25
116	96	3	2022-08-23 09:19:18
66	55	3	2022-01-02 05:33:23
146	123	4	2023-04-03 06:58:04
58	19	7	2022-08-26 04:47:36
86	57	7	2022-03-30 11:16:57
70	64	9	2022-08-08 11:50:51
47	115	4	2022-06-04 02:10:42
144	125	7	2022-08-19 01:56:19
30	132	2	2023-09-24 02:47:56
118	127	2	2023-03-09 10:47:44
5	138	4	2022-06-22 02:16:51
93	113	5	2023-02-26 05:10:07
3	53	4	2022-01-10 03:50:58
67	15	5	2021-10-11 03:36:59
84	117	1	2021-11-03 10:23:46
35	43	2	2021-10-26 02:51:20
29	22	3	2022-02-03 01:25:58
73	63	3	2023-05-26 09:41:24
135	71	8	2021-12-11 04:49:06
82	116	7	2023-05-12 01:19:45
64	6	6	2021-11-01 09:08:48
28	85	7	2023-07-20 01:33:14
134	80	4	2023-02-09 12:09:59
84	126	8	2023-08-31 02:45:12
40	49	7	2022-12-24 10:20:20
123	86	3	2023-04-19 03:44:39
133	87	1	2023-03-09 09:40:06
41	11	1	2022-12-22 07:40:20
121	86	8	2022-08-19 11:49:16
130	55	9	2023-07-17 09:32:55
100	79	7	2022-10-10 09:26:59
87	99	1	2023-05-04 11:07:09
41	144	7	2023-05-29 04:12:31
56	128	7	2023-08-21 05:52:18
46	118	3	2022-10-19 04:56:57
90	20	8	2023-04-21 04:49:40
48	36	6	2022-09-24 12:27:17
34	88	7	2022-09-18 01:43:24
77	21	7	2022-08-28 03:20:51
125	76	2	2023-05-31 07:03:08
2	90	5	2022-07-23 12:54:08
138	141	8	2022-10-02 01:51:58
85	139	2	2023-06-30 12:33:25
23	49	5	2022-09-11 06:28:25
109	54	2	2022-02-20 02:33:29
40	34	5	2022-08-26 02:49:59
134	84	6	2023-03-25 08:22:36
47	56	5	2022-12-22 05:35:22
118	68	9	2021-11-02 04:07:23
83	57	6	2022-03-09 03:56:28
4	76	4	2023-02-22 01:55:07
102	69	3	2023-02-14 07:06:40
65	53	8	2023-06-22 12:31:03
109	57	2	2021-12-07 07:06:28
38	51	8	2022-06-25 05:39:45
103	115	2	2022-04-30 03:51:36
115	67	4	2021-10-24 10:50:35
143	95	4	2023-04-25 08:21:50
41	17	10	2021-11-01 08:45:24
25	67	7	2023-09-07 12:59:14
61	118	9	2022-04-14 03:42:59
114	59	5	2022-01-15 09:29:53
92	58	1	2022-07-28 05:56:11
9	128	2	2022-01-22 06:41:45
115	135	7	2022-05-30 09:32:30
102	20	5	2023-02-14 07:23:10
90	60	6	2021-10-23 11:25:24
126	97	9	2022-06-08 12:51:55
111	76	5	2022-03-12 08:49:57
61	51	6	2021-11-11 10:58:43
67	92	9	2022-06-11 03:25:41
25	117	5	2023-09-08 04:17:52
17	90	9	2022-01-21 01:15:27
98	2	8	2023-05-04 06:33:54
118	93	1	2023-09-06 08:29:48
98	128	6	2022-06-12 02:55:31
9	78	3	2022-07-11 01:13:08
86	29	5	2022-03-13 01:45:54
31	85	9	2023-01-24 03:34:16
100	14	6	2023-09-03 03:13:21
145	84	6	2022-08-12 07:39:19
104	119	7	2022-02-01 01:13:42
60	110	8	2023-08-10 02:13:49
87	115	3	2022-12-12 05:00:23
53	108	6	2022-08-02 04:59:16
135	104	5	2023-09-09 06:00:27
90	93	4	2021-12-04 09:15:06
\.


--
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.user_profiles (user_id, name, surname, gender, birthday, country, locality, personal_site, vk, twitter, about_yourself, avatar_image_id) FROM stdin;
1	Josephine	Frye	male	1956-11-13	Singapore	Lauro de Freitas	http://whatsapp.com/group/9	https://ebay.com/sub?p=8	http://baidu.com/settings?k=0	in, cursus et, eros. Proin ultrices. Duis volutpat nunc sit amet metus. Aliquam	24
2	Kylan	Cotton	male	1984-03-27	India	La Pintana	https://news.mail.ru/group/9	http://netflix.com/fr?k=0	https://naver.com/en-us?p=8	non massa non ante bibendum ullamcorper. Duis cursus, diam at pretium aliquet, metus urna	20
3	George	Hester	male	1965-04-06	Chile	Volgograd	https://dns-shop.ru/sub/cars	https://ebay.com/sub/cars?p=8	https://google.com/site?ad=115	velit eu sem. Pellentesque ut ipsum ac mi eleifend egestas. Sed pharetra, felis eget	21
4	Craig	Shannon	male	1982-06-04	China	Ereğli	http://netflix.com/sub	https://walmart.com/fr?q=0	http://netflix.com/user/110?client=g	aliquam, enim nec tempus scelerisque, lorem ipsum sodales purus, in molestie tortor nibh	11
5	Melyssa	Vasquez	male	1957-04-05	Colombia	Pamplona	http://mail.ru/sub/cars	https://instagram.com/site?gi=100	https://nytimes.com/fr?k=0	euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a, arcu.	5
6	Ella	Brennan	male	2014-02-10	Belgium	Phan Thiết	https://aliex/en-us	http://instagram.com/en-us?str=se	https://bbc.co.uk/fr?str=se	amet massa. Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices a, auctor	70
7	Todd	Patton	male	2014-06-04	Indonesia	Iquitos	https://livejournal.com/user/110	https://guardian.co.uk/settings?k=0	http://bbc.co.uk/sub/cars?ab=441&aad=2	sem. Pellentesque ut ipsum ac mi eleifend egestas. Sed pharetra, felis eget	76
8	Keith	Haney	male	1967-11-01	South Africa	Savona	https://kinopoisk.ru/settings	http://ebay.com/sub?k=0	http://cnn.com/en-us?q=11	Suspendisse tristique neque venenatis lacus. Etiam bibendum fermentum metus. Aenean sed pede	128
9	Nadine	Scott	male	1981-05-24	France	Envigado	http://kommersant.ru/user/110	http://guardian.co.uk/site?g=1	http://facebook.com/site?q=test	nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui.	37
10	Candice	Palmer	male	2007-11-21	Austria	Puno	https://mk.ru/site	https://baidu.com/group/9?str=se	http://netflix.com/sub/cars?str=se	Sed eu nibh vulputate mauris sagittis placerat. Cras dictum ultricies ligula. Nullam enim. Sed	93
11	Mari	Mcintyre	male	2005-01-02	Poland	Ways	http://fandom.com/en-us	http://nytimes.com/site?q=11	http://nytimes.com/group/9?q=4	aliquet vel, vulputate eu, odio. Phasellus at augue id ante dictum cursus. Nunc mauris	30
12	Clinton	West	male	1967-12-18	Germany	Sibasa	https://wikipedia.org/sub	https://zoom.us/sub?search=1	https://nytimes.com/en-ca?k=0	ipsum nunc id enim. Curabitur massa. Vestibulum accumsan neque et	126
13	Roth	Stone	male	1967-08-05	United States	Fauske	http://sports.ru/sub	https://yahoo.com/sub/cars?search=1&q=de	http://netflix.com/site?search=1&q=de	pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit in	119
14	Hiroko	Kidd	male	1995-02-05	Mexico	Mata de Plátano	http://wikipedia.org/en-ca	http://guardian.co.uk/sub/cars?q=test	http://yahoo.com/user/110?k=0	Cras eget nisi dictum augue malesuada malesuada. Integer id magna et ipsum cursus vestibulum. Mauris	54
15	Ezekiel	Barr	male	1990-04-15	Singapore	Şanlıurfa	http://turbopages.org/en-us	https://guardian.co.uk/settings?q=test	http://nytimes.com/site?q=0	sodales purus, in molestie tortor nibh sit amet orci. Ut sagittis lobortis mauris.	36
16	Fatima	Tyler	male	2003-01-09	United Kingdom	Soledad	http://fandom.com/one	https://reddit.com/group/9?ad=115	http://reddit.com/one?q=4	est ac facilisis facilisis, magna tellus faucibus leo, in lobortis tellus justo sit	135
17	Carol	Sheppard	male	1985-11-15	Germany	Châteauroux	https://drive2.ru/sub/cars	https://baidu.com/settings?search=1&q=de	https://walmart.com/site?gi=100	at fringilla purus mauris a nunc. In at pede. Cras vulputate velit	120
18	John	Cash	male	2002-06-23	Peru	Shreveport	http://championat.com/user/110	http://instagram.com/en-ca?g=1	https://instagram.com/sub/cars?q=11	non, feugiat nec, diam. Duis mi enim, condimentum eget,	36
19	Zena	Mcpherson	male	1998-12-26	Turkey	Sens	http://rambler.ru/fr	http://naver.com/fr?ad=115	https://zoom.us/group/9?q=0	auctor, velit eget laoreet posuere, enim nisl elementum purus,	80
20	Joan	Oneal	male	1975-11-01	Ukraine	Pangkalpinang	http://whatsapp.com/fr	https://guardian.co.uk/sub/cars?page=1&offset=1	https://yahoo.com/en-us?ab=441&aad=2	Proin dolor. Nulla semper tellus id nunc interdum feugiat. Sed nec metus facilisis lorem	91
21	Tasha	Petersen	male	1950-07-09	Costa Rica	Liberia	http://whatsapp.com/en-ca	http://instagram.com/group/9?gi=100	http://whatsapp.com/one?client=g	malesuada vel, convallis in, cursus et, eros. Proin ultrices. Duis	46
22	Noelle	Hall	male	1984-06-07	Spain	Erciş	http://google.com/en-us	https://baidu.com/sub/cars?q=test	http://guardian.co.uk/settings?q=11	sed tortor. Integer aliquam adipiscing lacus. Ut nec urna et	113
23	Shoshana	Dale	male	1968-02-01	Spain	Neu-Isenburg	http://whatsapp.com/site	https://twitter.com/sub?page=1&offset=1	https://facebook.com/fr?search=1	dignissim lacus. Aliquam rutrum lorem ac risus. Morbi metus. Vivamus euismod urna.	28
24	Belle	Yates	male	1971-01-15	United States	Rostov	https://bbc.co.uk/settings	https://zoom.us/sub/cars?ad=115	http://twitter.com/group/9?client=g	Aliquam nisl. Nulla eu neque pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec	53
25	Hyatt	Huff	male	1958-07-20	Australia	Galway	http://pikabu.ru/fr	https://walmart.com/en-ca?q=11	http://reddit.com/settings?p=8	Donec sollicitudin adipiscing ligula. Aenean gravida nunc sed pede. Cum sociis natoque	52
26	Darrel	Ortiz	male	1977-09-22	Germany	Burgos	http://pinterest.com/user/110	http://yahoo.com/user/110?q=11	http://wikipedia.org/en-ca?page=1&offset=1	sit amet orci. Ut sagittis lobortis mauris. Suspendisse aliquet molestie	86
27	Ina	Carey	male	1961-01-21	Turkey	Klerksdorp	http://tiktok.com/site	https://pinterest.com/one?search=1	http://guardian.co.uk/fr?g=1	scelerisque neque sed sem egestas blandit. Nam nulla magna, malesuada vel, convallis in,	69
28	Ryder	Aguirre	male	2003-09-24	Singapore	Pinetown	http://vz.ru/group/9	http://instagram.com/site?ab=441&aad=2	https://naver.com/sub/cars?ab=441&aad=2	adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut nec urna et arcu	121
29	Carolyn	Bartlett	male	1977-10-13	United States	Tampines	https://kinopoisk.ru/group/9	https://whatsapp.com/sub?client=g	https://ebay.com/group/9?ab=441&aad=2	sem egestas blandit. Nam nulla magna, malesuada vel, convallis in,	77
30	Hayley	Brock	male	1956-01-20	United Kingdom	Baubau	http://pinterest.com/group/9	https://pinterest.com/user/110?client=g	https://ebay.com/en-ca?page=1&offset=1	dictum ultricies ligula. Nullam enim. Sed nulla ante, iaculis nec, eleifend non,	75
31	Vanna	Estes	male	2013-01-24	New Zealand	Masterton	https://market.yandex.ru/en-us	https://netflix.com/one?client=g	http://guardian.co.uk/site?ad=115	neque pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc	27
32	Olympia	Prince	male	1953-04-15	Italy	Limache	http://news.mail.ru/fr	https://instagram.com/user/110?q=0	http://bbc.co.uk/fr?q=test	Nunc lectus pede, ultrices a, auctor non, feugiat nec, diam. Duis mi enim,	86
33	Felicia	Witt	male	1992-01-19	Ireland	Vetlanda	http://ria.ru/sub/cars	http://cnn.com/sub?k=0	http://pinterest.com/en-us?client=g	orci luctus et ultrices posuere cubilia Curae Donec tincidunt. Donec vitae erat vel pede	2
34	Jescie	Foreman	male	1961-02-22	India	Guadalupe	https://gosuslugi.ru/fr	http://instagram.com/fr?ab=441&aad=2	https://naver.com/group/9?ad=115	Proin ultrices. Duis volutpat nunc sit amet metus. Aliquam erat volutpat. Nulla facilisis. Suspendisse	20
35	Martena	Burks	male	1993-08-05	Russian Federation	Kaluga	http://mk.ru/settings	https://walmart.com/fr?ab=441&aad=2	http://pinterest.com/user/110?ad=115	Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque	97
36	Ali	Forbes	male	1989-12-27	Costa Rica	Cần Thơ	https://vz.ru/sub/cars	http://facebook.com/group/9?gi=100	http://netflix.com/fr?k=0	eu turpis. Nulla aliquet. Proin velit. Sed malesuada augue ut lacus. Nulla tincidunt,	67
37	Madeline	Beach	male	1957-03-05	South Korea	Belfast	https://t.me/en-ca	http://walmart.com/one?gi=100	http://google.com/site?gi=100	vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae	84
38	Jordan	Munoz	male	1956-05-01	Colombia	Gorzów Wielkopolski	http://vz.ru/sub/cars	https://cnn.com/en-us?str=se	https://yahoo.com/group/9?page=1&offset=1	Proin ultrices. Duis volutpat nunc sit amet metus. Aliquam erat volutpat. Nulla facilisis. Suspendisse	80
39	Lillith	Albert	male	1974-06-14	Russian Federation	Puntarenas	http://rbc.ru/site	http://zoom.us/settings?p=8	http://netflix.com/user/110?q=test	Aliquam ornare, libero at auctor ullamcorper, nisl arcu iaculis enim,	70
40	Ignacia	Lang	male	1965-07-18	Singapore	Charleville-Mézières	https://livejournal.com/fr	https://naver.com/settings?q=11	http://cnn.com/group/9?g=1	at sem molestie sodales. Mauris blandit enim consequat purus.	56
41	Paki	Rodgers	male	1962-04-30	Chile	St. John's	http://gismeteo.ru/sub	https://pinterest.com/settings?g=1	http://google.com/en-us?q=0	mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate, lacus. Cras interdum. Nunc	114
42	Cody	Massey	male	2006-10-30	United States	Tianjin	https://bbc.co.uk/fr	http://cnn.com/site?ad=115	https://wikipedia.org/sub/cars?q=11	sit amet, risus. Donec nibh enim, gravida sit amet, dapibus	15
43	Iona	Vaughn	male	1995-08-07	Vietnam	Remscheid	https://pinterest.com/sub/cars	http://whatsapp.com/one?client=g	https://google.com/one?q=0	metus. In lorem. Donec elementum, lorem ut aliquam iaculis, lacus pede sagittis augue, eu tempor	133
44	Deacon	Ray	male	1952-05-09	Ukraine	Mohmand Agency	http://hh.ru/sub	https://reddit.com/one?q=4	https://twitter.com/one?str=se	erat, in consectetuer ipsum nunc id enim. Curabitur massa. Vestibulum accumsan	140
45	Kessie	Adams	male	2004-06-05	China	Soledad de Graciano Sánchez	http://t.me/user/110	https://google.com/fr?ab=441&aad=2	http://naver.com/user/110?g=1	non, vestibulum nec, euismod in, dolor. Fusce feugiat. Lorem ipsum dolor	110
46	Hyacinth	Mccullough	male	1972-03-10	South Korea	Ereğli	https://kommersant.ru/sub	http://wikipedia.org/user/110?str=se	https://naver.com/sub?q=test	neque sed sem egestas blandit. Nam nulla magna, malesuada vel, convallis in, cursus	26
47	Cassandra	Moses	male	1993-09-14	Vietnam	Sechura	https://pikabu.ru/user/110	https://nytimes.com/sub/cars?search=1	http://walmart.com/sub/cars?q=4	in consectetuer ipsum nunc id enim. Curabitur massa. Vestibulum accumsan neque et	94
48	Erin	Peters	male	1955-12-07	South Africa	Bajaur Agency	https://bbc.co.uk/sub/cars	http://twitter.com/en-us?g=1	http://nytimes.com/sub/cars?q=4	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus	54
49	Reuben	Burris	male	1961-03-25	Indonesia	Punggol	http://ozon.ru/user/110	http://youtube.com/sub/cars?search=1&q=de	http://zoom.us/sub/cars?k=0	Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse	87
50	Joelle	Tucker	male	2009-06-27	Ukraine	Rạch Giá	https://yahoo.com/en-ca	http://twitter.com/settings?p=8	http://google.com/site?q=0	velit. Sed malesuada augue ut lacus. Nulla tincidunt, neque vitae	32
51	Carol	Kidd	male	2006-08-30	Singapore	Cambridge	http://turbopages.org/en-ca	http://ebay.com/user/110?q=11	https://google.com/site?str=se	faucibus orci luctus et ultrices posuere cubilia Curae Phasellus ornare. Fusce mollis.	47
52	Susan	Delgado	male	1995-12-26	Vietnam	Oslo	https://pinterest.com/sub/cars	https://naver.com/sub?q=0	http://whatsapp.com/site?page=1&offset=1	sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin vel nisl.	50
53	Garth	Cain	male	1990-07-27	Philippines	Southaven	http://vz.ru/en-ca	http://reddit.com/settings?ad=115	https://baidu.com/user/110?q=0	Quisque fringilla euismod enim. Etiam gravida molestie arcu. Sed eu nibh vulputate mauris sagittis	84
54	Abbot	Kline	male	1972-08-21	Russian Federation	Palopo	http://google.ru/sub/cars	https://bbc.co.uk/en-ca?k=0	http://instagram.com/site?p=8	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aliquam auctor, velit eget laoreet	113
55	Berk	Mcfadden	male	1966-08-17	Peru	Kostroma	https://gismeteo.ru/group/9	https://nytimes.com/user/110?q=0	https://google.com/group/9?ad=115	cubilia Curae Phasellus ornare. Fusce mollis. Duis sit amet diam eu	65
56	May	Anderson	male	2004-01-14	Turkey	Cambridge	http://tiktok.com/site	http://youtube.com/site?q=test	http://nytimes.com/user/110?p=8	nulla. Cras eu tellus eu augue porttitor interdum. Sed auctor odio a purus. Duis elementum,	146
57	Rooney	Cooley	male	1970-09-26	Turkey	Ilhéus	https://naver.com/user/110	http://bbc.co.uk/one?p=8	https://zoom.us/site?q=0	eleifend. Cras sed leo. Cras vehicula aliquet libero. Integer in magna. Phasellus dolor elit,	132
58	Pearl	Cantrell	male	1994-12-22	New Zealand	Mexico City	https://naver.com/sub	http://reddit.com/site?page=1&offset=1	https://pinterest.com/one?client=g	id enim. Curabitur massa. Vestibulum accumsan neque et nunc.	51
59	Gareth	Mercado	male	2006-09-12	Austria	Sapele	https://instagram.com/sub	http://google.com/en-ca?p=8	http://walmart.com/sub/cars?q=test	venenatis lacus. Etiam bibendum fermentum metus. Aenean sed pede nec ante	100
60	Alexandra	Hubbard	male	1970-05-06	Singapore	Ankara	http://google.com/sub	https://whatsapp.com/one?search=1&q=de	https://twitter.com/fr?client=g	diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent per	46
61	Sopoline	Carroll	male	1975-08-17	Austria	Palembang	https://xnxx.com/site	https://cnn.com/site?str=se	http://instagram.com/group/9?k=0	orci luctus et ultrices posuere cubilia Curae Donec tincidunt. Donec vitae	42
62	Michael	Walters	male	1981-11-24	Turkey	Bellegem	http://vz.ru/settings	http://nytimes.com/site?str=se	http://wikipedia.org/settings?q=11	magna, malesuada vel, convallis in, cursus et, eros. Proin ultrices. Duis volutpat	43
63	Leilani	Cash	male	2010-02-03	France	Parepare	https://ficbook.net/en-us	https://guardian.co.uk/group/9?search=1&q=de	http://yahoo.com/one?p=8	amet, dapibus id, blandit at, nisi. Cum sociis natoque penatibus et magnis dis parturient	62
64	Malik	Morin	male	1989-10-13	Pakistan	Changi	https://t.me/en-ca	https://netflix.com/settings?client=g	https://reddit.com/site?search=1	Nunc mauris. Morbi non sapien molestie orci tincidunt adipiscing. Mauris molestie pharetra	72
65	Hayden	Pruitt	male	2014-10-29	Germany	Vanderbijlpark	http://wildberries.ru/group/9	https://baidu.com/settings?gi=100	https://reddit.com/group/9?k=0	tristique senectus et netus et malesuada fames ac turpis	132
66	Fletcher	Ashley	male	1970-12-26	Ukraine	Chuncheon	http://pinterest.com/en-us	http://netflix.com/en-us?g=1	https://reddit.com/user/110?ad=115	nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra	29
67	Sonya	Moore	male	2013-02-02	France	Flensburg	http://wikipedia.org/en-ca	http://reddit.com/fr?search=1&q=de	http://cnn.com/user/110?p=8	mi pede, nonummy ut, molestie in, tempus eu, ligula. Aenean	26
68	Keely	Daniels	male	2013-04-24	Colombia	Puerto Vallarta	http://rbc.ru/group/9	http://nytimes.com/one?q=4	https://reddit.com/group/9?q=test	metus eu erat semper rutrum. Fusce dolor quam, elementum at, egestas a, scelerisque sed, sapien.	16
69	Xena	Houston	male	1987-11-13	Russian Federation	Gjøvik	http://naver.com/en-ca	https://yahoo.com/site?search=1	http://ebay.com/sub?page=1&offset=1	placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam	84
70	Logan	Pate	male	1983-03-15	Ukraine	Landeck	https://guardian.co.uk/settings	https://reddit.com/site?ab=441&aad=2	https://netflix.com/en-ca?k=0	orci. Donec nibh. Quisque nonummy ipsum non arcu. Vivamus	119
71	Lilah	Mcintosh	male	2004-11-16	France	Ceuta	https://bbc.co.uk/site	http://twitter.com/one?q=0	http://baidu.com/one?ad=115	diam eu dolor egestas rhoncus. Proin nisl sem, consequat nec, mollis vitae, posuere at, velit.	41
72	Channing	Ramos	male	1988-03-03	New Zealand	Murmansk	http://turbopages.org/en-us	http://reddit.com/en-us?g=1	http://cnn.com/user/110?str=se	vitae semper egestas, urna justo faucibus lectus, a sollicitudin orci sem eget massa. Suspendisse eleifend.	16
73	Lenore	Baird	male	1975-01-17	New Zealand	Villa Alemana	https://instagram.com/en-ca	https://twitter.com/fr?k=0	http://netflix.com/settings?q=0	non, sollicitudin a, malesuada id, erat. Etiam vestibulum massa rutrum	72
74	Sydnee	Nunez	male	1960-04-24	Costa Rica	Borno	https://kommersant.ru/sub	https://wikipedia.org/fr?str=se	http://facebook.com/en-us?search=1	mattis. Integer eu lacus. Quisque imperdiet, erat nonummy ultricies ornare, elit	114
75	Alexis	Mercer	male	1964-06-29	Vietnam	Conselice	http://news.mail.ru/group/9	https://cnn.com/site?q=test	http://wikipedia.org/en-us?ab=441&aad=2	rutrum non, hendrerit id, ante. Nunc mauris sapien, cursus in, hendrerit consectetuer,	16
76	Duncan	Irwin	male	1957-03-04	Costa Rica	Cleveland	https://rambler.ru/en-ca	http://baidu.com/one?gi=100	https://bbc.co.uk/en-ca?p=8	Vivamus nisi. Mauris nulla. Integer urna. Vivamus molestie dapibus ligula.	7
77	Fredericka	Carver	male	1977-01-15	Ukraine	Gdańsk	https://rbc.ru/settings	http://instagram.com/en-us?client=g	http://naver.com/user/110?g=1	feugiat. Sed nec metus facilisis lorem tristique aliquet. Phasellus fermentum convallis ligula.	17
78	Serina	Bennett	male	1991-03-07	Poland	Dubbo	http://whatsapp.com/user/110	http://ebay.com/en-us?search=1&q=de	http://google.com/en-us?search=1	Pellentesque tincidunt tempus risus. Donec egestas. Duis ac arcu. Nunc mauris. Morbi	45
79	Grace	Scott	male	2008-12-06	Nigeria	Bontang	http://rbc.ru/sub/cars	http://ebay.com/en-ca?client=g	https://netflix.com/en-ca?ab=441&aad=2	Vestibulum accumsan neque et nunc. Quisque ornare tortor at risus. Nunc ac	145
80	Cooper	Holmes	male	1994-01-11	Spain	Lysychansk	https://twitter.com/site	https://walmart.com/user/110?ab=441&aad=2	http://wikipedia.org/site?gi=100	malesuada fringilla est. Mauris eu turpis. Nulla aliquet. Proin velit. Sed malesuada	49
81	Kelsie	Leach	male	1977-03-29	Pakistan	Limón (Puerto Limón]	https://vz.ru/en-us	http://instagram.com/one?str=se	https://twitter.com/one?search=1	lorem eu metus. In lorem. Donec elementum, lorem ut aliquam iaculis, lacus pede	138
82	Wayne	Berry	male	1978-01-26	Ireland	Bayugan	http://gazeta.ru/en-ca	https://facebook.com/en-ca?q=4	http://yahoo.com/site?p=8	ipsum dolor sit amet, consectetuer adipiscing elit. Aliquam auctor, velit eget laoreet posuere, enim	28
83	Tyrone	Cooley	male	1989-06-26	Netherlands	Cork	https://aliex/en-us	http://naver.com/user/110?client=g	https://facebook.com/en-ca?g=1	Ut sagittis lobortis mauris. Suspendisse aliquet molestie tellus. Aenean egestas hendrerit neque. In	22
84	Prescott	Bender	male	2014-09-24	Brazil	Créteil	http://vz.ru/fr	https://nytimes.com/sub?q=4	https://wikipedia.org/fr?q=test	nibh sit amet orci. Ut sagittis lobortis mauris. Suspendisse aliquet molestie tellus.	118
85	Forrest	Nicholson	male	1999-02-07	Sweden	Queenstown	https://kommersant.ru/sub	https://bbc.co.uk/en-ca?client=g	http://baidu.com/sub?ab=441&aad=2	sem mollis dui, in sodales elit erat vitae risus. Duis a mi	25
86	Kasper	Hammond	male	1987-10-14	Peru	São José	https://naver.com/sub	http://whatsapp.com/en-us?q=test	http://instagram.com/site?page=1&offset=1	ultrices, mauris ipsum porta elit, a feugiat tellus lorem eu metus. In lorem. Donec elementum,	73
87	Vivien	Cole	male	1995-06-30	China	Trujillo	https://sports.ru/group/9	http://ebay.com/sub/cars?search=1	https://google.com/settings?page=1&offset=1	odio. Nam interdum enim non nisi. Aenean eget metus. In nec orci.	29
88	Nicholas	Gibson	male	1981-10-09	Brazil	Belford Roxo	http://pikabu.ru/fr	http://pinterest.com/fr?p=8	https://zoom.us/sub?page=1&offset=1	tortor at risus. Nunc ac sem ut dolor dapibus gravida. Aliquam tincidunt, nunc ac mattis	56
89	Chiquita	Wilkerson	male	2014-08-09	Sweden	Okpoko	http://gismeteo.ru/sub/cars	https://reddit.com/site?gi=100	https://zoom.us/en-ca?k=0	ornare, facilisis eget, ipsum. Donec sollicitudin adipiscing ligula. Aenean gravida nunc	86
90	Akeem	Barrera	male	1976-12-23	Peru	Trollhättan	https://ress.ru/sub/cars	http://ebay.com/sub/cars?q=11	https://facebook.com/fr?q=4	sit amet ornare lectus justo eu arcu. Morbi sit amet massa. Quisque	20
91	Jada	Guy	male	1956-07-26	India	Chañaral	https://music.yandex.ru/settings	https://youtube.com/group/9?page=1&offset=1	https://bbc.co.uk/en-ca?gi=100	gravida molestie arcu. Sed eu nibh vulputate mauris sagittis placerat.	112
92	Aline	Wong	male	2000-05-29	Poland	Irpin	http://gazeta.ru/user/110	https://bbc.co.uk/group/9?q=11	https://pinterest.com/en-us?q=test	vestibulum lorem, sit amet ultricies sem magna nec quam. Curabitur vel lectus. Cum sociis natoque	147
93	Travis	Boyle	male	2001-11-21	Peru	Cabuyao	http://news.rambler.ru/en-us	https://google.com/one?page=1&offset=1	http://guardian.co.uk/en-ca?q=4	Ut tincidunt orci quis lectus. Nullam suscipit, est ac facilisis facilisis, magna tellus	18
94	Yardley	Bradley	male	1957-04-30	Netherlands	Memphis	https://whatsapp.com/sub/cars	http://whatsapp.com/sub?q=4	http://cnn.com/user/110?q=4	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus	135
95	Anika	Flynn	male	1965-02-23	Russian Federation	Cork	https://drive2.ru/sub/cars	http://walmart.com/settings?search=1&q=de	https://cnn.com/group/9?q=test	amet ultricies sem magna nec quam. Curabitur vel lectus. Cum sociis natoque	77
96	Baxter	Yang	male	1963-06-12	Peru	Bielefeld	http://t.me/sub/cars	https://baidu.com/settings?ad=115	http://yahoo.com/fr?client=g	gravida molestie arcu. Sed eu nibh vulputate mauris sagittis placerat. Cras dictum ultricies ligula. Nullam	28
97	Danielle	Livingston	male	1958-01-07	Brazil	Sorsogon City	https://bbc.co.uk/user/110	http://ebay.com/one?str=se	http://wikipedia.org/settings?ab=441&aad=2	leo. Morbi neque tellus, imperdiet non, vestibulum nec, euismod in, dolor. Fusce	25
98	Wyoming	Wallace	male	1959-06-11	Ireland	Puerto Carreño	http://drive2.ru/settings	https://bbc.co.uk/sub/cars?client=g	https://netflix.com/one?ad=115	eu, placerat eget, venenatis a, magna. Lorem ipsum dolor sit	145
99	Colby	Mcdowell	male	1973-12-08	Canada	Río Claro	http://pikabu.ru/group/9	http://netflix.com/en-ca?q=4	https://wikipedia.org/sub/cars?search=1&q=de	Vivamus rhoncus. Donec est. Nunc ullamcorper, velit in aliquet lobortis, nisi nibh	26
100	Drake	Monroe	male	1964-01-08	Nigeria	Cartagena	http://kommersant.ru/sub	http://google.com/sub/cars?gi=100	https://whatsapp.com/settings?search=1	vulputate mauris sagittis placerat. Cras dictum ultricies ligula. Nullam enim. Sed nulla	149
101	Edward	Hogan	male	1956-12-08	Nigeria	Verdalsøra	http://hh.ru/en-ca	https://walmart.com/site?page=1&offset=1	https://twitter.com/fr?q=4	eu lacus. Quisque imperdiet, erat nonummy ultricies ornare, elit elit fermentum risus, at fringilla	32
102	Madonna	Coffey	male	2010-12-17	Spain	Bathgate	http://livejournal.com/one	https://baidu.com/group/9?q=0	https://bbc.co.uk/site?q=0	placerat. Cras dictum ultricies ligula. Nullam enim. Sed nulla ante, iaculis nec, eleifend	131
103	Blossom	Woodard	male	2003-05-28	Netherlands	Neufeld an der Leitha	http://avito.ru/group/9	http://facebook.com/site?q=0	http://baidu.com/fr?ab=441&aad=2	ipsum. Curabitur consequat, lectus sit amet luctus vulputate, nisi	66
104	Jeanette	Garrison	male	2005-01-03	Australia	Lanark	http://netflix.com/en-ca	https://wikipedia.org/fr?q=4	https://cnn.com/fr?q=4	a felis ullamcorper viverra. Maecenas iaculis aliquet diam. Sed diam lorem, auctor quis,	75
105	Hammett	Gibson	male	1981-05-20	China	Belfast	https://nytimes.com/fr	http://nytimes.com/group/9?page=1&offset=1	http://wikipedia.org/sub?client=g	ipsum leo elementum sem, vitae aliquam eros turpis non enim. Mauris	134
106	Deirdre	Bishop	male	1974-10-04	Ukraine	Dörtyol	http://guardian.co.uk/one	https://nytimes.com/group/9?g=1	http://yahoo.com/sub/cars?q=11	lorem ut aliquam iaculis, lacus pede sagittis augue, eu tempor erat neque	125
107	Katell	Branch	male	1986-06-29	United Kingdom	Bannu	https://tiktok.com/site	http://baidu.com/en-ca?q=11	http://ebay.com/sub?ab=441&aad=2	dignissim. Maecenas ornare egestas ligula. Nullam feugiat placerat velit. Quisque varius. Nam	27
108	Lara	Harrington	male	1960-11-07	Netherlands	Kendari	http://wildberries.ru/settings	https://cnn.com/sub/cars?q=11	https://instagram.com/settings?p=8	urna. Vivamus molestie dapibus ligula. Aliquam erat volutpat. Nulla dignissim. Maecenas ornare egestas	127
109	Harriet	Hays	male	1966-04-12	South Korea	Ust-Katav	https://drive2.ru/sub/cars	https://guardian.co.uk/settings?p=8	http://twitter.com/one?ab=441&aad=2	egestas. Sed pharetra, felis eget varius ultrices, mauris ipsum porta	45
110	Carson	Lee	male	1975-01-22	Pakistan	Hall in Tirol	http://sberbank.ru/en-ca	http://netflix.com/fr?p=8	https://nytimes.com/en-us?gi=100	erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas	99
111	Astra	Stanton	male	1957-11-15	Chile	Butte	http://pikabu.ru/sub/cars	https://google.com/settings?ab=441&aad=2	https://ebay.com/group/9?q=4	nec ante. Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere	23
112	Sopoline	Hicks	male	2000-05-15	Netherlands	Huacho	https://cloud.mail.ru/sub/cars	http://wikipedia.org/group/9?p=8	http://ebay.com/group/9?g=1	adipiscing. Mauris molestie pharetra nibh. Aliquam ornare, libero at auctor ullamcorper,	111
113	Vera	Farley	male	2003-10-26	United Kingdom	Lạng Sơn	https://gazeta.ru/user/110	http://facebook.com/group/9?gi=100	https://twitter.com/site?k=0	luctus et ultrices posuere cubilia Curae Phasellus ornare. Fusce mollis.	15
114	Kellie	Valenzuela	male	1969-12-14	Canada	Metro	https://wikipedia.org/site	http://baidu.com/user/110?g=1	https://nytimes.com/en-ca?gi=100	ornare placerat, orci lacus vestibulum lorem, sit amet ultricies sem magna nec quam. Curabitur	54
115	Theodore	Mcneil	male	1991-12-14	Italy	Zaporizhzhia	http://guardian.co.uk/sub	http://nytimes.com/group/9?str=se	https://walmart.com/user/110?q=0	egestas a, dui. Cras pellentesque. Sed dictum. Proin eget odio. Aliquam vulputate	23
116	Kellie	Townsend	male	1990-02-04	Chile	Móstoles	https://whatsapp.com/group/9	https://netflix.com/user/110?client=g	https://naver.com/en-us?ad=115	facilisis non, bibendum sed, est. Nunc laoreet lectus quis massa.	47
117	Linda	Hayden	male	1994-03-15	Vietnam	Phan Rang–Tháp Chàm	http://2gis.ru/sub	http://facebook.com/en-us?search=1&q=de	http://instagram.com/sub?gi=100	nisl arcu iaculis enim, sit amet ornare lectus justo eu arcu. Morbi	89
118	Imelda	Fernandez	male	1965-12-19	Nigeria	Jaén	https://baidu.com/fr	https://facebook.com/group/9?page=1&offset=1	https://baidu.com/one?q=0	erat vitae risus. Duis a mi fringilla mi lacinia mattis. Integer eu	84
119	Todd	Leblanc	male	1979-06-22	Belgium	Bagh	https://youtube.com/en-us	http://guardian.co.uk/group/9?q=4	https://netflix.com/fr?g=1	Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui. Fusce diam nunc,	32
120	Doris	Lloyd	male	1988-10-20	Brazil	Phong Thổ	https://xnxx.com/en-ca	http://baidu.com/sub/cars?client=g	http://whatsapp.com/group/9?p=8	vulputate mauris sagittis placerat. Cras dictum ultricies ligula. Nullam enim. Sed	114
121	Cruz	Riggs	male	1973-12-16	United States	Parys	https://walmart.com/en-us	http://whatsapp.com/sub?search=1	http://youtube.com/en-us?page=1&offset=1	hendrerit a, arcu. Sed et libero. Proin mi. Aliquam gravida mauris	136
122	Cody	Whitehead	male	1951-06-06	Vietnam	Kohima	https://walmart.com/sub	https://wikipedia.org/one?q=test	http://naver.com/one?q=11	conubia nostra, per inceptos hymenaeos. Mauris ut quam vel sapien imperdiet ornare. In	137
123	Amelia	Small	male	2000-03-22	Vietnam	Tomaszów Mazowiecki	https://vk.com/user/110	http://google.com/site?ad=115	https://yahoo.com/one?client=g	Suspendisse eleifend. Cras sed leo. Cras vehicula aliquet libero. Integer in magna. Phasellus	146
124	Larissa	Mccarthy	male	1953-07-19	Turkey	Épernay	https://guardian.co.uk/settings	https://instagram.com/one?k=0	http://pinterest.com/one?q=4	lectus, a sollicitudin orci sem eget massa. Suspendisse eleifend.	147
125	Maris	Nixon	male	2008-06-01	Turkey	Quesada	http://instagram.com/site	https://ebay.com/en-us?search=1	https://naver.com/en-us?client=g	et, euismod et, commodo at, libero. Morbi accumsan laoreet ipsum.	128
126	Vanna	Ballard	male	1977-07-11	Germany	Ansfelden	http://ok.ru/settings	https://naver.com/group/9?q=11	https://guardian.co.uk/fr?search=1&q=de	sed turpis nec mauris blandit mattis. Cras eget nisi dictum	149
127	Ignacia	Giles	male	1951-05-30	Ukraine	Caxias do Sul	http://walmart.com/en-us	https://zoom.us/en-us?gi=100	http://zoom.us/en-ca?str=se	metus urna convallis erat, eget tincidunt dui augue eu tellus. Phasellus elit pede,	96
128	Griffin	Callahan	male	2003-11-27	Pakistan	Wrigley	http://ozon.ru/site	http://ebay.com/sub/cars?gi=100	http://google.com/site?search=1&q=de	fringilla ornare placerat, orci lacus vestibulum lorem, sit amet ultricies sem magna nec quam.	53
129	Lucas	Stevenson	male	1963-05-21	Germany	Da Lat	https://fandom.com/one	http://netflix.com/fr?client=g	http://instagram.com/sub/cars?q=11	Duis cursus, diam at pretium aliquet, metus urna convallis	111
130	Herrod	Reed	male	1984-07-10	Nigeria	Camaragibe	http://samsung.com/user/110	http://youtube.com/site?ab=441&aad=2	http://google.com/one?q=test	Nullam velit dui, semper et, lacinia vitae, sodales at, velit. Pellentesque ultricies dignissim lacus.	39
131	Chloe	Haney	male	1981-07-24	Pakistan	Đồng Hới	http://whatsapp.com/sub/cars	https://twitter.com/en-ca?gi=100	https://pinterest.com/en-ca?search=1&q=de	vitae risus. Duis a mi fringilla mi lacinia mattis. Integer	118
132	Haley	Deleon	male	2007-08-08	Austria	Makiivka	http://facebook.com/en-us	http://instagram.com/fr?str=se	https://ebay.com/fr?str=se	dictum. Proin eget odio. Aliquam vulputate ullamcorper magna. Sed eu eros. Nam consequat dolor	7
133	Halee	Washington	male	2009-12-13	Norway	Lublin	http://bbc.co.uk/group/9	https://yahoo.com/user/110?p=8	http://instagram.com/settings?page=1&offset=1	nec ante blandit viverra. Donec tempus, lorem fringilla ornare placerat, orci lacus	4
134	Judah	Hodges	male	1954-07-19	Mexico	Alençon	https://yahoo.com/user/110	https://pinterest.com/one?k=0	https://cnn.com/one?str=se	volutpat. Nulla dignissim. Maecenas ornare egestas ligula. Nullam feugiat placerat velit. Quisque varius. Nam	35
135	Igor	Sellers	male	1986-05-16	Belgium	Cartagena	https://2gis.ru/en-us	http://walmart.com/en-ca?str=se	http://whatsapp.com/site?str=se	turpis egestas. Fusce aliquet magna a neque. Nullam ut nisi a odio semper cursus.	43
136	Graham	Wagner	male	1952-06-02	Ukraine	Waitara	http://2gis.ru/user/110	http://guardian.co.uk/user/110?g=1	http://yahoo.com/one?ab=441&aad=2	ligula elit, pretium et, rutrum non, hendrerit id, ante.	83
137	Mason	Roberson	male	1989-11-05	Turkey	Dordrecht	http://kommersant.ru/fr	http://ebay.com/sub?str=se	http://wikipedia.org/one?ab=441&aad=2	sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing	28
138	Hayfa	Mclean	male	1957-08-29	Vietnam	Frankston	http://whatsapp.com/en-us	http://zoom.us/site?gi=100	https://youtube.com/en-us?q=test	dis parturient montes, nascetur ridiculus mus. Donec dignissim magna a tortor.	3
139	Fuller	Carson	male	2003-05-24	Netherlands	Lutsk	http://wildberries.ru/one	https://pinterest.com/user/110?q=11	http://whatsapp.com/settings?str=se	Nullam scelerisque neque sed sem egestas blandit. Nam nulla magna, malesuada vel, convallis	92
140	Louis	Sampson	male	2009-08-28	Philippines	Stargard Szczeciński	https://google.com/sub/cars	https://twitter.com/sub/cars?ad=115	https://zoom.us/user/110?str=se	scelerisque, lorem ipsum sodales purus, in molestie tortor nibh sit amet orci. Ut sagittis	64
141	Hyacinth	Luna	male	1970-08-11	Austria	Ciudad Apodaca	http://reddit.com/user/110	https://nytimes.com/site?page=1&offset=1	https://zoom.us/settings?page=1&offset=1	Sed auctor odio a purus. Duis elementum, dui quis accumsan convallis, ante lectus convallis	22
142	Jordan	Malone	male	1985-01-28	Indonesia	Makassar	http://cloud.mail.ru/fr	https://nytimes.com/fr?search=1	https://walmart.com/settings?search=1	tortor at risus. Nunc ac sem ut dolor dapibus gravida. Aliquam tincidunt,	128
143	Ira	Powell	male	1980-12-22	Singapore	Kapfenberg	https://wikipedia.org/sub/cars	http://guardian.co.uk/site?page=1&offset=1	http://reddit.com/site?ab=441&aad=2	Maecenas libero est, congue a, aliquet vel, vulputate eu, odio. Phasellus at	54
144	Melanie	Fisher	male	2014-09-05	Chile	Fauske	http://walmart.com/en-ca	https://facebook.com/sub/cars?search=1&q=de	https://netflix.com/fr?gi=100	posuere at, velit. Cras lorem lorem, luctus ut, pellentesque eget, dictum	119
145	Farrah	Sullivan	male	1986-04-18	China	Gouda	https://rbc.ru/user/110	http://cnn.com/en-us?k=0	https://youtube.com/site?k=0	sodales purus, in molestie tortor nibh sit amet orci. Ut sagittis lobortis mauris.	1
146	Rogan	Garner	male	1966-09-22	Germany	Zwolle	http://youtube.com/one	https://instagram.com/group/9?k=0	https://twitter.com/en-ca?ab=441&aad=2	non quam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.	60
147	Echo	Alford	male	1960-02-09	Colombia	Sangju	https://yahoo.com/settings	https://netflix.com/site?gi=100	https://facebook.com/one?str=se	malesuada id, erat. Etiam vestibulum massa rutrum magna. Cras	71
148	Finn	Alston	male	1998-11-23	Vietnam	Oryol	http://facebook.com/one	https://zoom.us/sub/cars?p=8	http://yahoo.com/fr?ad=115	urna justo faucibus lectus, a sollicitudin orci sem eget massa.	29
149	Rebecca	Kirkland	male	1999-04-22	France	Kilsyth	https://rbc.ru/site	http://cnn.com/group/9?page=1&offset=1	https://google.com/sub/cars?k=0	Phasellus dapibus quam quis diam. Pellentesque habitant morbi tristique	82
150	Maggie	Lynch	male	2002-10-25	China	Karak	https://drom.ru/en-ca	http://wikipedia.org/en-ca?page=1&offset=1	http://naver.com/group/9?q=4	sed, est. Nunc laoreet lectus quis massa. Mauris vestibulum,	131
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.users (id, phone, is_confirmed_phone, email, is_confirmed_email, authorization_type) FROM stdin;
1	1-237-853-3159	t	ut.nisi@hotmail.net	f	1
2	1-565-998-0806	f	sit@google.com	f	3
3	(572) 293-8543	t	dui@outlook.ca	t	2
4	1-848-117-0762	f	egestas.blandit.nam@aol.com	f	3
5	(658) 458-9565	t	morbi.vehicula@outlook.ca	f	4
6	1-976-478-5340	t	gravida.mauris@outlook.edu	f	2
7	1-633-572-8147	f	felis.adipiscing@google.com	f	3
8	(708) 227-6961	t	mi.ac.mattis@aol.couk	t	2
9	1-162-629-7284	f	bibendum.ullamcorper@protonmail.couk	t	4
10	1-459-345-9322	f	sit.amet@outlook.net	f	3
11	(787) 741-4860	f	ante@yahoo.edu	f	4
12	(971) 464-2186	f	per.conubia@protonmail.org	f	3
13	(594) 449-6154	t	nulla@icloud.ca	f	2
14	(429) 542-8427	t	orci.sem.eget@hotmail.edu	t	4
15	(174) 375-7667	t	massa1@google.net	t	3
16	(942) 291-2561	t	ac.mattis@protonmail.org	f	1
17	1-867-410-6061	f	orci.consectetuer@protonmail.net	f	1
18	(687) 340-7797	t	vestibulum.accumsan@aol.edu	t	3
19	1-746-515-4516	t	risus.odio@outlook.couk	t	3
20	(615) 457-6482	t	in.hendrerit@google.com	t	4
21	(516) 606-6892	f	neque@google.com	t	1
22	(963) 686-5371	t	tempor@protonmail.edu	f	2
23	1-976-880-4372	t	arcu.vel@hotmail.edu	t	2
24	1-751-554-2155	f	sociis.natoque@google.org	f	2
25	1-347-942-6075	t	molestie.in@icloud.net	f	3
26	1-948-118-0648	f	ligula@protonmail.edu	f	3
27	1-483-247-8843	f	imperdiet.erat@outlook.couk	f	1
28	1-727-282-2335	t	a.mi@aol.couk	f	3
29	1-915-577-2567	f	magna@protonmail.com	t	2
30	1-635-334-7316	t	magnis.dis@google.org	f	4
31	(701) 552-6981	f	id.mollis.nec@aol.couk	f	4
32	1-321-762-6457	f	eu.ligula@yahoo.edu	f	2
33	1-543-737-4226	t	commodo.tincidunt@protonmail.couk	f	2
34	1-567-307-9826	f	massa@google.net	f	2
35	1-568-531-4522	f	ut@aol.com	f	2
36	1-856-651-3368	t	aptent.taciti@outlook.com	t	2
37	(688) 609-4464	t	nec.urna.et@google.edu	f	4
38	(126) 508-3884	f	gravida.aliquam@outlook.ca	f	4
39	1-626-627-5565	t	nunc@protonmail.org	f	2
40	1-853-809-7328	t	maecenas.mi@aol.com	f	2
41	1-647-885-7606	t	nec.urna.suscipit@protonmail.net	t	1
42	(624) 257-8668	f	auctor@aol.net	f	3
43	(231) 587-9417	f	quam@protonmail.couk	t	3
44	(773) 248-7456	t	imperdiet.non.vestibulum@google.net	t	2
45	1-143-293-8281	f	lorem@google.net	f	2
46	(374) 613-9273	f	id@aol.ca	t	2
47	1-719-577-6214	f	et.rutrum@yahoo.net	t	3
48	(789) 621-2455	t	lobortis@hotmail.ca	f	2
49	(951) 534-1869	f	hendrerit.a.arcu@protonmail.net	t	3
50	1-284-761-6728	t	pellentesque.sed@yahoo.ca	f	3
51	(668) 149-7657	f	tellus.id@yahoo.org	t	1
52	1-762-355-2602	f	turpis.nulla@protonmail.ca	f	2
53	(893) 740-3876	f	ullamcorper.nisl@hotmail.ca	f	3
54	1-308-119-4445	f	elementum.lorem@hotmail.net	t	2
55	1-393-874-6425	t	quisque.fringilla@google.ca	f	2
56	(434) 463-8147	f	sed.auctor@aol.com	f	3
57	(748) 884-7109	t	neque.venenatis@protonmail.couk	f	4
58	(278) 949-6138	t	in.sodales@protonmail.org	f	3
59	1-351-719-1387	t	nulla.tempor@icloud.com	f	4
60	1-613-775-4785	f	fringilla@outlook.org	f	2
61	(366) 436-7045	t	vulputate@google.net	t	1
62	(314) 251-1408	f	sed.nec@google.ca	t	2
63	(398) 726-3618	t	elit.fermentum.risus@hotmail.com	f	2
64	(680) 668-3420	t	eros.proin@hotmail.edu	f	2
65	1-423-759-3127	f	nulla.integer@icloud.com	t	2
66	1-362-946-9047	f	nunc.quis@icloud.ca	t	4
67	(441) 982-8823	t	amet.dapibus@aol.net	f	2
68	1-493-913-5245	t	ullamcorper@yahoo.edu	f	3
69	(662) 458-8453	f	neque@outlook.edu	f	3
70	(229) 219-7616	t	lorem.ipsum@yahoo.org	t	3
71	(955) 267-0527	f	amet@yahoo.org	t	4
72	(347) 348-5514	f	egestas.lacinia.sed@outlook.ca	f	4
73	1-908-487-5643	f	laoreet.ipsum.curabitur@yahoo.ca	f	2
74	(556) 665-9806	t	neque.sed.dictum@google.couk	f	3
75	(669) 835-4459	t	sagittis.semper@protonmail.edu	t	2
76	1-483-341-0743	t	eu@protonmail.couk	t	4
77	(817) 379-9850	t	donec@google.couk	f	2
78	(768) 378-2867	f	sed.nunc@google.couk	f	1
79	1-323-793-2116	f	ac.mattis@google.ca	f	2
80	1-987-778-1832	t	libero.dui.nec@outlook.edu	t	4
81	(876) 130-7906	t	pellentesque.sed@google.org	t	1
82	1-421-327-6893	t	tortor.nunc@protonmail.org	f	1
83	1-402-637-7197	t	tincidunt@protonmail.com	f	1
84	(165) 867-7764	t	cursus@aol.org	f	4
85	(734) 664-6671	t	bibendum@outlook.couk	t	4
86	(623) 640-8301	f	nullam.ut@yahoo.com	f	1
87	(436) 333-0169	f	dolor@outlook.ca	f	2
88	1-819-945-1882	t	urna@yahoo.ca	t	3
89	(436) 414-3606	t	viverra.maecenas@protonmail.com	t	2
90	(832) 686-7833	f	vel.mauris@yahoo.org	t	1
91	1-748-522-0786	t	inceptos.hymenaeos@outlook.org	t	2
92	(315) 158-8842	t	sapien.nunc@aol.net	t	3
93	(385) 648-8142	t	in.cursus.et@protonmail.edu	f	4
94	(635) 832-1167	t	etiam@outlook.couk	t	4
95	1-971-726-3449	f	dolor.dolor.tempus@protonmail.ca	f	2
96	(284) 150-5742	f	erat.volutpat.nulla@protonmail.edu	f	2
97	(522) 872-5708	t	semper.dui@protonmail.org	f	3
98	(241) 648-7173	f	suspendisse@google.ca	t	2
99	1-314-134-3423	f	faucibus.morbi.vehicula@aol.couk	t	2
100	1-556-478-6297	t	sed@icloud.edu	f	3
101	(314) 323-5197	t	morbi@hotmail.com	t	3
102	(534) 954-0786	f	et.malesuada.fames@outlook.com	t	2
103	1-782-705-3925	f	sollicitudin.commodo.ipsum@icloud.edu	t	2
104	(317) 651-5861	t	augue.id@outlook.ca	f	1
105	1-828-124-9512	f	aliquam.arcu@icloud.net	t	1
106	1-572-770-6417	t	elit@yahoo.couk	f	3
107	(857) 461-5255	t	cursus.et@google.net	t	2
108	1-847-551-8917	t	diam.nunc.ullamcorper@outlook.couk	t	2
109	1-889-868-8802	f	donec@icloud.org	f	3
110	(885) 334-6062	f	molestie.orci@google.org	f	3
111	(631) 721-8633	f	eget.lacus@aol.couk	t	3
112	(667) 376-4751	f	aliquam.fringilla@yahoo.couk	t	3
113	1-795-617-1841	t	metus.in@outlook.net	f	1
114	(472) 482-5976	t	facilisi.sed@protonmail.org	f	4
115	1-729-875-6569	f	odio.phasellus@hotmail.com	t	2
116	1-771-641-7818	f	purus.maecenas.libero@aol.edu	t	3
117	1-597-574-2495	f	odio.sagittis.semper@hotmail.edu	f	3
118	(631) 481-1415	t	vehicula.aliquet@protonmail.org	t	2
119	1-593-542-8858	t	odio.semper@yahoo.ca	t	2
120	1-854-418-2221	f	fusce@hotmail.edu	f	3
121	1-964-840-4666	f	erat@hotmail.org	f	4
122	(829) 660-2782	t	ut.pharetra@yahoo.com	t	1
123	(794) 866-2256	f	neque.non@aol.org	t	1
124	(588) 696-3426	f	vitae.semper@icloud.edu	t	4
125	(532) 214-7631	f	donec.feugiat@yahoo.org	t	2
126	1-231-677-5659	t	semper@outlook.com	f	3
127	1-834-460-5312	t	ut.mi@google.org	t	3
128	(450) 871-5218	f	iaculis@aol.org	f	1
129	(330) 109-7451	f	penatibus.et@protonmail.org	t	2
130	(283) 413-9202	t	pharetra.ut@yahoo.edu	t	3
131	1-614-438-7430	f	magnis.dis@google.couk	f	3
132	1-263-884-4202	t	cursus.a@protonmail.ca	t	4
133	(363) 219-8583	t	cras@icloud.couk	f	1
134	1-235-182-3570	t	luctus.curabitur@outlook.net	f	1
135	1-373-726-6385	f	penatibus.et.magnis@protonmail.com	f	3
136	(624) 640-5143	t	lorem.lorem.luctus@aol.net	f	3
137	1-916-215-5188	t	semper.tellus@icloud.net	t	1
138	1-676-942-0586	f	magnis.dis.parturient@outlook.com	f	2
139	(242) 688-2865	f	sed.pede@icloud.org	f	3
140	(452) 784-0561	f	et.magna.praesent@google.ca	t	4
141	1-754-898-0314	f	ipsum@yahoo.com	t	2
142	(985) 877-6104	t	dictum.eleifend@hotmail.couk	f	1
143	1-301-189-4642	f	vitae@google.couk	t	1
144	(337) 340-7523	t	nec.eleifend.non@yahoo.couk	f	2
145	1-106-253-2416	t	sodales.purus@hotmail.net	f	3
146	1-576-900-4717	f	ante.vivamus@protonmail.couk	t	3
147	(646) 474-4379	f	nullam@google.net	t	3
148	1-229-504-5893	f	libero.nec.ligula@hotmail.net	f	4
149	(411) 456-1757	t	nisi.magna@hotmail.net	t	2
150	1-968-753-4839	f	auctor.odio@google.org	t	3
\.


--
-- Data for Name: video_types; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.video_types (id, type_name) FROM stdin;
1	Основное видео
2	Трейлер
3	Фрагмент
4	Тизер
\.


--
-- Data for Name: videos; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.videos (id, movie_id, video_type_id, image_url) FROM stdin;
1	125	2	https://guardian.co.uk/site?gi=100
2	101	3	http://ozon.ru/en-us?g=1
3	123	3	https://nytimes.com/sub/cars?page=1&offset=1
4	66	4	https://whatsapp.com/site?q=4
5	36	4	http://yandex.ru/one?ab=441&aad=2
6	108	3	https://guardian.co.uk/fr?search=1&q=de
7	3	2	http://netflix.com/sub?client=g
8	48	2	https://yandex.ru/user/110?str=se
9	108	2	https://bbc.co.uk/one?page=1&offset=1
10	36	3	http://nytimes.com/one?search=1
11	62	2	https://ress.ru/site?search=1
12	72	3	https://cnn.com/group/9?p=8
13	127	2	http://cloud.mail.ru/group/9?g=1
14	17	3	https://twitch.tv/one?q=4
15	124	4	https://wikipedia.org/user/110?p=8
16	87	2	https://pikabu.ru/en-us?ad=115
17	21	2	https://netflix.com/group/9?ab=441&aad=2
18	56	3	https://turbopages.org/fr?q=test
19	83	2	https://rambler.ru/en-us?g=1
20	36	3	https://cnn.com/user/110?q=0
21	22	2	http://ress.ru/user/110?client=g
22	142	1	http://drive2.ru/en-ca?search=1&q=de
23	111	4	http://twitch.tv/sub?k=0
24	4	3	https://youtube.com/settings?ab=441&aad=2
25	4	2	https://ficbook.net/sub?ab=441&aad=2
26	92	1	https://ficbook.net/sub?search=1&q=de
27	36	2	https://google.com/sub/cars?ad=115
28	149	2	http://avito.ru/sub?k=0
29	4	4	https://wikipedia.org/en-ca?str=se
30	9	1	http://gosuslugi.ru/fr?page=1&offset=1
31	71	2	https://guardian.co.uk/en-ca?ab=441&aad=2
32	69	3	http://bbc.co.uk/site?client=g
33	129	1	http://instagram.com/settings?g=1
34	111	3	https://2gis.ru/one?search=1&q=de
35	9	4	http://google.com/sub/cars?q=test
36	47	4	http://guardian.co.uk/settings?q=4
37	52	2	https://mail.ru/settings?str=se
38	8	1	http://youtube.com/user/110?ab=441&aad=2
39	94	2	https://google.ru/settings?str=se
40	53	4	https://google.ru/fr?q=0
41	101	3	http://mk.ru/en-us?q=0
42	116	2	https://hh.ru/settings?q=4
43	147	1	https://music.yandex.ru/user/110?ad=115
44	118	3	http://yahoo.com/en-us?gi=100
45	36	4	https://rbc.ru/fr?g=1
46	144	4	http://mk.ru/site?page=1&offset=1
47	113	2	https://gosuslugi.ru/sub/cars?g=1
48	141	4	https://avito.ru/sub/cars?page=1&offset=1
49	4	4	http://walmart.com/sub?q=test
50	88	4	http://zoom.us/settings?q=0
51	98	2	http://zoom.us/sub/cars?str=se
52	10	2	https://twitch.tv/one?search=1&q=de
53	142	2	http://zoom.us/en-ca?client=g
54	143	3	https://yahoo.com/fr?q=0
55	96	3	http://sberbank.ru/en-us?q=test
56	79	2	http://pinterest.com/en-ca?q=11
57	26	3	https://fandom.com/sub?q=4
58	6	3	https://yahoo.com/settings?k=0
59	49	3	https://youtube.com/fr?g=1
60	72	2	http://gazeta.ru/fr?k=0
61	125	3	http://instagram.com/user/110?p=8
62	55	4	https://facebook.com/user/110?p=8
63	75	1	https://nytimes.com/en-us?q=4
64	10	3	http://kommersant.ru/group/9?q=11
65	146	3	http://samsung.com/site?q=test
66	106	4	http://vk.com/en-ca?g=1
67	122	1	https://bbc.co.uk/group/9?q=4
68	74	1	http://rambler.ru/user/110?page=1&offset=1
69	52	1	http://livejournal.com/settings?ad=115
70	57	1	https://avito.ru/sub/cars?ab=441&aad=2
71	92	3	http://cnn.com/user/110?search=1
72	56	3	https://yahoo.com/user/110?q=4
73	109	1	http://ficbook.net/group/11?q=4
74	131	3	https://pinterest.com/en-us?gi=100
75	127	4	http://music.yandex.ru/en-ca?ab=441&aad=2
76	102	2	https://xnxx.com/sub?client=g
77	115	4	http://reddit.com/en-us?search=1&q=de
78	16	1	https://yahoo.com/user/110?k=0
79	105	2	https://google.com/fr?k=0
80	46	3	http://reddit.com/en-ca?ab=441&aad=2
81	63	4	https://pikabu.ru/sub/cars?q=test
82	128	3	http://2gis.ru/site?g=1
83	136	2	https://mail.ru/fr?search=1&q=de
84	104	4	http://walmart.com/en-us?q=test
85	48	2	https://ress.ru/fr?p=8
86	136	2	http://yandex.ru/en-ca?str=se
87	3	3	http://tiktok.com/group/9?q=0
88	123	3	https://championat.com/one?gi=100
89	77	3	http://rbc.ru/fr?str=se
90	144	1	http://hh.ru/en-ca?page=1&offset=1
91	37	3	http://livejournal.com/en-ca?page=1&offset=1
92	142	3	https://avito.ru/group/9?str=se
93	75	4	https://gosuslugi.ru/en-ca?ad=115
94	132	4	https://ok.ru/sub?search=1&q=de
95	111	3	https://drive2.ru/sub?p=8
96	122	2	https://ficbook.net/settings?str=se
97	93	3	http://whatsapp.com/one?ad=115
98	110	2	http://pinterest.com/settings?p=8
99	120	1	https://instagram.com/sub/cars?ad=115
100	126	3	http://ozon.ru/one?ad=115
101	12	2	http://wikipedia.org/site?gi=100
102	110	3	http://netflix.com/en-ca?p=8
103	13	2	https://cnn.com/user/110?k=0
104	42	4	http://ficbook.net/en-ca?ad=115
105	31	3	https://market.yandex.ru/site?g=1
106	50	2	https://dns-shop.ru/one?client=g
107	54	4	https://twitch.tv/fr?q=test
108	81	1	http://mk.ru/one?g=1
109	148	1	https://yandex.ru/settings?search=1
110	5	4	https://xvideos.com/en-us?k=0
111	98	2	https://t.me/site?ad=115
112	103	2	http://guardian.co.uk/site?ab=441&aad=2
113	18	2	https://cloud.mail.ru/user/110?p=8
114	136	2	https://news.rambler.ru/one?search=1&q=de
115	44	3	http://drom.ru/one?ab=441&aad=2
116	73	3	https://championat.com/user/110?ab=441&aad=2
117	63	3	https://tiktok.com/user/110?search=1&q=de
118	25	2	http://yahoo.com/user/110?search=1&q=de
119	62	2	http://youtube.com/settings?ab=441&aad=2
120	10	4	https://ebay.com/user/110?q=0
121	131	1	https://2gis.ru/sub?search=1
122	88	2	https://championat.com/site?q=test
123	4	1	http://bbc.co.uk/settings?q=test
124	22	4	https://tiktok.com/site?gi=100
125	119	1	https://whatsapp.com/group/9?search=1
126	116	2	http://xnxx.com/fr?page=1&offset=1
127	16	3	https://pikabu.ru/sub?str=se
128	48	1	https://mail.ru/sub/cars?client=g
129	108	1	https://rus-tv.su/one?p=8
130	69	4	https://netflix.com/group/9?str=se
131	109	2	http://kommersant.ru/one?p=8
132	117	3	https://yandex.ru/site?client=g
133	125	3	https://ebay.com/en-us?client=g
134	114	2	https://cnn.com/sub?ab=441&aad=2
135	134	3	http://yandex.ru/sub?q=test
136	148	4	https://ok.ru/en-us?p=8
137	34	3	http://rus-tv.su/en-ca?q=0
138	19	1	http://mk.ru/fr?str=se
139	43	3	http://ficbook.net/group/9?q=4
140	109	1	http://turbopages.org/fr?ad=115
141	15	1	http://music.yandex.ru/one?gi=100
142	136	2	http://tiktok.com/group/9?client=g
143	19	3	http://netflix.com/site?search=1&q=de
144	83	3	https://yandex.ru/sub/cars?ad=115
145	95	2	http://twitch.tv/en-ca?g=1
146	116	4	https://news.mail.ru/fr?ad=115
147	56	1	https://pikabu.ru/settings?page=1&offset=1
148	10	4	http://nytimes.com/sub?q=0
149	35	3	http://mk.ru/en-ca?k=0
150	126	3	http://championat.com/sub/cars?q=test
151	88	1	https://market.yandex.ru/sub?client=g
152	66	3	http://netflix.com/fr?page=1&offset=1
153	87	1	https://hh.ru/sub/cars?p=8
154	99	3	http://xnxx.com/sub?page=1&offset=1
155	11	2	http://news.rambler.ru/group/9?k=0
156	84	3	http://xnxx.com/site?client=g
157	122	3	http://bbc.co.uk/en-us?search=1
158	29	3	http://kommersant.ru/settings?q=4
159	131	4	http://youtube.com/en-ca?client=g
160	5	4	http://vz.ru/user/110?gi=100
161	60	4	http://drom.ru/user/110?q=0
162	68	3	https://news.rambler.ru/sub/cars?ab=441&aad=2
163	149	3	http://ebay.com/one?k=0
164	52	3	http://aliex/settings?str=se
165	8	3	http://livejournal.com/en-us?q=11
166	96	1	http://wikipedia.org/one?gi=100
167	83	2	https://reddit.com/one?q=test
168	69	4	https://walmart.com/en-us?str=se
169	129	2	http://cnn.com/user/110?str=se
170	123	2	https://mail.ru/user/110?ad=115
171	14	3	https://kommersant.ru/user/110?ad=115
172	79	3	https://sports.ru/one?q=test
173	26	4	https://ficbook.net/site?q=0
174	7	2	http://gazeta.ru/fr?client=g
175	100	2	https://kommersant.ru/group/9?k=0
176	27	2	https://kommersant.ru/user/110?search=1&q=de
177	150	3	https://nytimes.com/sub/cars?q=0
178	15	2	https://drom.ru/site?ab=441&aad=2
179	44	3	https://instagram.com/settings?search=1
180	5	2	http://gismeteo.ru/settings?g=1
181	85	3	http://wikipedia.org/group/9?q=0
182	69	2	https://ebay.com/site?p=8
183	32	2	https://news.rambler.ru/group/9?page=1&offset=1
184	114	1	https://xvideos.com/site?q=0
185	135	1	https://netflix.com/one?ad=115
186	44	2	http://lenta.ru/en-ca?ab=441&aad=2
187	60	3	https://cloud.mail.ru/site?str=se
188	54	1	https://aliex/en-ca?q=11
189	142	1	https://ria.ru/one?client=g
190	71	4	http://pikabu.ru/fr?page=1&offset=1
191	98	2	http://aliex/user/110?q=0
192	68	4	http://yandex.ru/en-ca?search=1&q=de
193	25	2	http://mk.ru/group/9?q=11
194	72	2	https://turbopages.org/fr?p=8
195	46	4	https://fandom.com/one?q=4
196	96	2	http://google.ru/en-us?search=1&q=de
197	12	1	http://vk.com/fr?g=1
198	49	3	https://t.me/user/110?q=11
199	113	2	http://turbopages.org/group/9?search=1&q=de
200	82	2	https://ress.ru/en-ca?str=se
201	96	1	http://yahoo.com/settings?client=g
202	58	3	https://kinopoisk.ru/en-ca?q=4
203	75	1	https://reddit.com/one?ad=115
204	65	2	http://reddit.com/one?p=8
205	6	2	https://kommersant.ru/fr?k=0
206	83	1	https://drom.ru/en-us?p=8
207	31	4	http://nytimes.com/group/9?gi=100
208	37	2	http://rus-tv.su/sub/cars?ad=115
209	39	1	http://vz.ru/settings?q=0
210	97	3	http://kommersant.ru/en-us?p=8
211	29	3	http://news.mail.ru/site?search=1
212	131	2	http://news.mail.ru/group/9?gi=100
213	142	2	https://pikabu.ru/en-ca?search=1
214	49	1	https://ress.ru/settings?str=se
215	91	3	https://music.yandex.ru/fr?search=1
216	67	3	http://pikabu.ru/en-us?search=1&q=de
217	81	4	https://guardian.co.uk/sub/cars?search=1&q=de
218	58	4	http://twitch.tv/fr?q=4
219	63	1	https://rambler.ru/en-ca?search=1
220	100	4	https://tiktok.com/user/110?q=11
221	115	4	http://wikipedia.org/sub/cars?search=1&q=de
222	21	3	http://gismeteo.ru/user/110?search=1&q=de
223	123	3	http://wikipedia.org/en-ca?q=11
224	2	4	http://twitter.com/fr?gi=100
225	110	2	http://ozon.ru/group/9?gi=100
226	75	2	http://guardian.co.uk/en-ca?gi=100
227	42	2	http://whatsapp.com/site?page=1&offset=1
228	95	3	https://xvideos.com/one?search=1
229	84	4	https://pinterest.com/en-ca?q=11
230	38	3	http://kinopoisk.ru/settings?p=8
231	147	2	https://yahoo.com/en-ca?k=0
232	94	4	https://tiktok.com/site?p=8
233	133	1	https://netflix.com/en-us?q=0
234	47	3	https://mk.ru/en-ca?search=1
235	74	4	https://drom.ru/site?str=se
236	68	3	http://livejournal.com/user/110?page=1&offset=1
237	42	4	https://gismeteo.ru/en-ca?search=1
238	17	1	http://rbc.ru/site?gi=100
239	77	2	https://2gis.ru/user/110?str=se
240	39	4	http://mk.ru/settings?str=sedf
241	34	2	http://market.yandex.ru/sub/cars?search=1&q=de
242	81	3	http://vz.ru/group/9?p=8
243	12	3	https://kp.ru/sub/cars?gi=100
244	150	1	https://news.mail.ru/group/9?p=8
245	104	3	https://music.yandex.ru/one?str=se
246	11	3	http://t.me/group/9?p=8
247	71	2	https://lenta.ru/en-ca?q=4
248	104	3	https://wikipedia.org/sub/cars?search=1&q=de
249	32	4	https://championat.com/group/9?p=8
250	119	4	http://championat.com/settings?p=8
251	112	2	http://samsung.com/settings?k=0
252	100	3	https://yandex.ru/group/9?q=test
253	130	1	http://bbc.co.uk/sub?search=1
254	80	3	http://instagram.com/en-ca?str=se
255	134	2	http://mk.ru/settings?str=se
256	28	3	http://kinopoisk.ru/settings?k=0
257	93	2	https://samsung.com/en-ca?q=4
258	6	4	http://xvideos.com/site?k=0
259	103	3	http://vz.ru/site?gi=100
260	148	2	https://wildberries.ru/sub?k=0
261	136	3	http://mk.ru/user/110?q=4
262	105	2	https://twitter.com/user/110?gi=100
263	28	3	http://ress.ru/en-us?search=1&q=de
264	147	2	https://hh.ru/user/110?client=g
265	102	2	https://dns-shop.ru/one?ad=115
266	8	2	https://twitch.tv/fr?search=1&q=de
267	43	3	http://pinterest.com/site?q=0
268	52	4	http://t.me/sub/cars?search=1&q=de
269	133	3	http://netflix.com/one?k=0
270	41	2	http://facebook.com/sub/cars?q=4
271	91	1	https://2gis.ru/sub?page=1&offset=1
272	102	2	http://google.ru/site?q=4
273	56	4	https://walmart.com/settings?q=11
274	20	2	https://xnxx.com/site?q=0
275	77	4	https://championat.com/one?page=1&offset=1
276	121	3	https://rbc.ru/sub/cars?gi=100
277	20	1	http://yandex.ru/en-us?k=0
278	42	3	http://cnn.com/site?k=0
279	51	3	http://turbopages.org/user/110?q=4
280	135	4	http://bbc.co.uk/sub?client=g
281	145	4	http://pinterest.com/one?str=se
282	23	1	https://pinterest.com/settings?page=1&offset=5
283	26	4	https://news.rambler.ru/user/110?q=11
284	146	2	https://mk.ru/sub?p=8
285	53	2	https://guardian.co.uk/sub/cars?page=1&offset=1
286	142	3	https://cloud.mail.ru/sub?str=se
287	69	1	https://t.me/en-ca?page=1&offset=1
288	112	3	https://gismeteo.ru/one?q=0
289	84	3	http://xvideos.com/one?q=4
290	68	2	https://kp.ru/site?gi=100
291	123	2	https://bbc.co.uk/en-us?search=1&q=de
292	10	1	http://youtube.com/en-us?page=1&offset=1
293	147	3	https://wikipedia.org/settings?ab=441&aad=2
294	91	1	http://kp.ru/en-us?q=0
295	43	3	http://twitter.com/settings?search=1
296	110	3	http://vk.com/en-ca?p=8
297	105	2	http://google.ru/sub?gi=100
298	106	1	http://gosuslugi.ru/user/110?ab=441&aad=2
299	10	3	https://twitter.com/one?search=1&q=de
300	10	2	https://pinterest.com/user/110?client=g
301	139	4	https://music.yandex.ru/fr?p=8
302	42	1	http://music.yandex.ru/sub/cars?search=1
303	64	1	https://rbc.ru/one?client=g
304	129	2	http://mail.ru/sub?g=1
305	23	2	https://netflix.com/fr?g=1
306	110	1	http://t.me/group/9?search=1&q=de
307	132	3	http://vk.com/one?str=se
308	7	3	http://tiktok.com/en-us?k=0
309	72	1	http://ress.ru/site?client=g
310	137	2	https://xnxx.com/settings?search=1
311	53	3	http://music.yandex.ru/site?g=1
312	131	2	https://ozon.ru/site?page=1&offset=1
313	119	3	https://championat.com/settings?ab=441&aad=2
314	69	4	https://aliex/site?client=g
315	138	2	https://pinterest.com/settings?page=1&offset=1
316	104	2	http://ok.ru/sub?gi=100
317	116	1	https://ebay.com/group/9?k=0
318	94	4	http://drom.ru/user/110?search=1&q=de
319	100	1	https://yandex.ru/site?gi=100
320	20	3	https://kp.ru/en-us?q=test
321	81	1	https://drom.ru/group/9?q=test
322	95	3	http://ozon.ru/sub?p=8
323	65	2	https://livejournal.com/one?client=g
324	77	2	http://netflix.com/fr?q=4
325	136	1	https://ozon.ru/sub?client=g
326	110	3	https://t.me/fr?p=8
327	38	2	http://news.rambler.ru/user/110?p=8
328	120	2	https://drom.ru/sub/cars?q=4
329	43	1	https://wikipedia.org/en-us?g=1
330	23	2	https://championat.com/user/110?q=11
331	59	1	https://2gis.ru/settings?client=g
332	54	4	https://bbc.co.uk/fr?q=test
333	120	3	http://vz.ru/en-ca?g=1
334	69	1	https://turbopages.org/fr?q=11
335	10	2	http://gazeta.ru/group/9?gi=100
336	13	2	https://aliex/one?search=1
337	89	3	https://pinterest.com/sub?gi=100
338	31	4	http://wikipedia.org/en-ca?search=1&q=de
339	104	3	https://yahoo.com/site?k=0
340	82	1	https://rus-tv.su/fr?ab=441&aad=2
341	99	4	https://whatsapp.com/sub/cars?ab=441&aad=2
342	51	2	https://ebay.com/group/9?q=4
343	149	2	https://yahoo.com/en-us?g=1
344	51	2	https://cnn.com/sub/cars?k=0
345	79	4	http://mk.ru/en-ca?p=8
346	40	3	https://google.ru/one?page=1&offset=1
347	15	2	https://netflix.com/one?q=0
348	30	2	https://rambler.ru/en-us?page=1&offset=1
349	39	3	http://kinopoisk.ru/en-us?p=8
350	97	4	https://music.yandex.ru/settings?q=0
351	54	1	http://google.com/sub/cars?k=0
352	69	1	http://zoom.us/sub?p=8
353	69	4	https://lenta.ru/one?q=11
354	149	4	https://pikabu.ru/en-ca?search=1&q=de
355	65	2	https://championat.com/sub?page=1&offset=1
356	72	4	https://xvideos.com/sub/cars?q=4
357	32	2	https://reddit.com/sub?gi=100
358	103	3	https://wildberries.ru/sub/cars?search=1&q=de
359	5	1	http://whatsapp.com/group/9?q=0
360	98	3	https://kommersant.ru/sub/cars?q=0
361	126	3	http://sports.ru/fr?client=g
362	16	3	http://google.ru/en-ca?search=1&q=de
363	57	2	https://mail.ru/settings?g=1
364	101	3	https://naver.com/one?ad=115
365	112	3	https://ficbook.net/user/110?client=g
366	127	2	http://nytimes.com/sub?ad=115
367	20	3	http://rambler.ru/en-us?q=4
368	87	2	https://wildberries.ru/sub?client=g
369	13	2	https://instagram.com/fr?k=0
370	108	2	https://nytimes.com/sub?search=1&q=de
371	130	2	http://news.mail.ru/one?ad=115
372	19	2	https://drive2.ru/fr?search=1
373	107	2	http://facebook.com/fr?gi=100
374	37	2	https://cnn.com/site?gi=100
375	137	4	http://fandom.com/group/9?g=1
376	22	2	https://dns-shop.ru/en-us?search=1
377	91	2	http://news.mail.ru/group/9?str=se
378	122	3	https://yahoo.com/sub?search=1&q=de
379	101	3	http://news.mail.ru/settings?q=4
380	119	2	http://xvideos.com/user/110?k=0
381	124	2	http://vz.ru/en-ca?q=0
382	116	3	http://xnxx.com/fr?search=1
383	142	4	http://ebay.com/site?q=4
384	24	3	https://sports.ru/fr?p=8
385	15	3	https://xnxx.com/group/9?q=11
386	68	2	http://netflix.com/fr?q=11
387	8	3	http://championat.com/site?search=1&q=de
388	44	4	https://news.rambler.ru/settings?page=1&offset=1
389	26	4	https://tiktok.com/user/110?str=se
390	13	3	https://kommersant.ru/en-us?str=se
391	52	2	http://whatsapp.com/sub/cars?gi=100
392	120	1	http://wildberries.ru/user/110?q=0
393	16	3	http://ozon.ru/settings?q=4
394	98	3	http://kp.ru/fr?p=8
395	87	3	http://guardian.co.uk/user/110?q=11
396	71	3	https://walmart.com/user/110?gi=100
397	30	4	http://gismeteo.ru/group/9?ab=441&aad=2
398	4	2	http://pinterest.com/one?q=4
399	93	2	http://rus-tv.su/sub?page=1&offset=1
400	27	4	http://sberbank.ru/sub/cars?gi=100
\.


--
-- Data for Name: viewer_profiles; Type: TABLE DATA; Schema: public; Owner: gb_sol
--

COPY public.viewer_profiles (id, user_id, genres_ids, age_restriction) FROM stdin;
1	110	{4,8}	6+
2	129	{4,8}	12+
3	99	{4,8}	16+
4	16	{12,6}	6+
5	48	{4,8}	12+
6	114	{12,6}	12+
7	120	{4,8}	0+
8	47	{1,3}	16+
9	64	{4,8}	0+
10	92	{1,3}	16+
11	97	{4,8}	16+
12	130	{1,3}	12+
13	43	{1,3}	6+
14	34	{4,8}	6+
15	48	{4,8}	12+
16	40	{1,3}	6+
17	1	{1,3}	6+
18	107	{4,8}	12+
19	34	{4,8}	6+
20	103	{1,3}	12+
21	59	{12,6}	6+
22	96	{4,8}	6+
23	59	{1,3}	12+
24	109	{12,6}	6+
25	117	{1,3}	16+
26	138	{4,8}	0+
27	146	{4,8}	6+
28	14	{4,8}	16+
29	35	{4,8}	16+
30	150	{1,3}	12+
31	29	{4,8}	0+
32	26	{4,8}	6+
33	118	{4,8}	6+
34	30	{4,8}	12+
35	69	{4,8}	6+
36	142	{4,8}	6+
37	121	{4,8}	6+
38	87	{4,8}	6+
39	139	{12,6}	12+
40	63	{12,6}	16+
41	95	{4,8}	0+
42	132	{4,8}	0+
43	143	{4,8}	12+
44	12	{1,3}	6+
45	81	{1,3}	12+
46	24	{4,8}	6+
47	20	{12,6}	0+
48	119	{4,8}	16+
49	39	{4,8}	6+
50	143	{4,8}	6+
51	69	{4,8}	0+
52	7	{4,8}	12+
53	86	{1,3}	16+
54	57	{4,8}	6+
55	61	{4,8}	12+
56	82	{1,3}	12+
57	17	{1,3}	0+
58	125	{1,3}	0+
59	25	{12,6}	12+
60	148	{4,8}	12+
61	97	{4,8}	16+
62	4	{4,8}	6+
63	141	{12,6}	6+
64	40	{1,3}	6+
65	70	{12,6}	6+
66	9	{12,6}	6+
67	39	{12,6}	16+
68	125	{12,6}	12+
69	140	{1,3}	6+
70	17	{4,8}	6+
71	140	{1,3}	16+
72	115	{12,6}	0+
73	55	{4,8}	0+
74	129	{1,3}	12+
75	145	{1,3}	0+
76	58	{1,3}	16+
77	66	{12,6}	12+
78	109	{4,8}	6+
79	149	{1,3}	6+
80	42	{12,6}	12+
81	50	{1,3}	12+
82	8	{4,8}	6+
83	111	{4,8}	6+
84	112	{4,8}	0+
85	52	{12,6}	16+
86	75	{1,3}	6+
87	103	{4,8}	0+
88	71	{12,6}	0+
89	84	{4,8}	6+
90	61	{12,6}	12+
91	27	{4,8}	0+
92	36	{4,8}	6+
93	134	{4,8}	0+
94	93	{4,8}	16+
95	71	{1,3}	6+
96	132	{1,3}	6+
97	23	{4,8}	0+
98	143	{12,6}	6+
99	22	{4,8}	12+
100	140	{4,8}	16+
101	148	{12,6}	6+
102	29	{4,8}	6+
103	128	{4,8}	12+
104	53	{4,8}	6+
105	75	{4,8}	6+
106	84	{4,8}	12+
107	126	{12,6}	12+
108	70	{4,8}	12+
109	2	{4,8}	0+
110	133	{12,6}	0+
111	14	{1,3}	6+
112	140	{4,8}	0+
113	18	{4,8}	6+
114	60	{1,3}	16+
115	3	{4,8}	16+
116	66	{12,6}	0+
117	96	{1,3}	12+
118	69	{4,8}	6+
119	105	{1,3}	12+
120	27	{12,6}	6+
121	140	{12,6}	12+
122	124	{1,3}	12+
123	74	{1,3}	6+
124	26	{12,6}	16+
125	101	{12,6}	6+
126	142	{12,6}	12+
127	139	{4,8}	6+
128	129	{4,8}	16+
129	105	{1,3}	12+
130	40	{4,8}	6+
131	25	{4,8}	6+
132	27	{1,3}	12+
133	76	{1,3}	16+
134	91	{4,8}	0+
135	98	{1,3}	16+
136	101	{1,3}	6+
137	143	{4,8}	6+
138	72	{12,6}	6+
139	112	{4,8}	6+
140	3	{4,8}	16+
141	72	{4,8}	12+
142	40	{1,3}	0+
143	13	{4,8}	6+
144	64	{4,8}	16+
145	51	{12,6}	12+
146	86	{12,6}	6+
147	30	{4,8}	6+
148	108	{4,8}	6+
149	118	{1,3}	12+
150	56	{12,6}	0+
\.


--
-- Name: authorization_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_sol
--

SELECT pg_catalog.setval('public.authorization_types_id_seq', 4, true);


--
-- Name: genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_sol
--

SELECT pg_catalog.setval('public.genres_id_seq', 28, true);


--
-- Name: image_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_sol
--

SELECT pg_catalog.setval('public.image_types_id_seq', 6, true);


--
-- Name: images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_sol
--

SELECT pg_catalog.setval('public.images_id_seq', 150, true);


--
-- Name: movie_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_sol
--

SELECT pg_catalog.setval('public.movie_types_id_seq', 4, true);


--
-- Name: movies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_sol
--

SELECT pg_catalog.setval('public.movies_id_seq', 150, true);


--
-- Name: persons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_sol
--

SELECT pg_catalog.setval('public.persons_id_seq', 150, true);


--
-- Name: positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_sol
--

SELECT pg_catalog.setval('public.positions_id_seq', 10, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_sol
--

SELECT pg_catalog.setval('public.roles_id_seq', 300, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_sol
--

SELECT pg_catalog.setval('public.users_id_seq', 150, true);


--
-- Name: video_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_sol
--

SELECT pg_catalog.setval('public.video_types_id_seq', 4, true);


--
-- Name: videos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_sol
--

SELECT pg_catalog.setval('public.videos_id_seq', 400, true);


--
-- Name: viewer_profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_sol
--

SELECT pg_catalog.setval('public.viewer_profiles_id_seq', 150, true);


--
-- Name: authorization_types authorization_types_name_key; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.authorization_types
    ADD CONSTRAINT authorization_types_name_key UNIQUE (name);


--
-- Name: authorization_types authorization_types_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.authorization_types
    ADD CONSTRAINT authorization_types_pkey PRIMARY KEY (id);


--
-- Name: genres genres_genre_name_key; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_genre_name_key UNIQUE (genre_name);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: image_types image_types_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.image_types
    ADD CONSTRAINT image_types_pkey PRIMARY KEY (id);


--
-- Name: image_types image_types_type_name_key; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.image_types
    ADD CONSTRAINT image_types_type_name_key UNIQUE (type_name);


--
-- Name: images images_image_url_key; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_image_url_key UNIQUE (image_url);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: movie_positions movie_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.movie_positions
    ADD CONSTRAINT movie_positions_pkey PRIMARY KEY (movie_id, person_id, position_id);


--
-- Name: movie_types movie_types_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.movie_types
    ADD CONSTRAINT movie_types_pkey PRIMARY KEY (id);


--
-- Name: movie_types movie_types_type_name_key; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.movie_types
    ADD CONSTRAINT movie_types_type_name_key UNIQUE (type_name);


--
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- Name: persons persons_main_photo_id_key; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_main_photo_id_key UNIQUE (main_photo_id);


--
-- Name: persons persons_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_pkey PRIMARY KEY (id);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- Name: positions positions_position_name_key; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_position_name_key UNIQUE (position_name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: stars stars_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.stars
    ADD CONSTRAINT stars_pkey PRIMARY KEY (movie_id, user_id);


--
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (user_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: video_types video_types_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.video_types
    ADD CONSTRAINT video_types_pkey PRIMARY KEY (id);


--
-- Name: video_types video_types_type_name_key; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.video_types
    ADD CONSTRAINT video_types_type_name_key UNIQUE (type_name);


--
-- Name: videos videos_image_url_key; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_image_url_key UNIQUE (image_url);


--
-- Name: videos videos_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: viewer_profiles viewer_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.viewer_profiles
    ADD CONSTRAINT viewer_profiles_pkey PRIMARY KEY (id);


--
-- Name: stars check_movie_genres_on_insert; Type: TRIGGER; Schema: public; Owner: gb_sol
--

CREATE TRIGGER check_movie_genres_on_insert BEFORE INSERT ON public.stars FOR EACH ROW EXECUTE FUNCTION public.check_movie_genres_trigger();


--
-- Name: stars check_movie_genres_on_update; Type: TRIGGER; Schema: public; Owner: gb_sol
--

CREATE TRIGGER check_movie_genres_on_update BEFORE UPDATE ON public.stars FOR EACH ROW EXECUTE FUNCTION public.check_movie_genres_trigger();


--
-- Name: stars check_user_stars_on_insert; Type: TRIGGER; Schema: public; Owner: gb_sol
--

CREATE TRIGGER check_user_stars_on_insert BEFORE INSERT ON public.stars FOR EACH ROW EXECUTE FUNCTION public.check_user_stars_trigger();


--
-- Name: stars check_user_stars_on_update; Type: TRIGGER; Schema: public; Owner: gb_sol
--

CREATE TRIGGER check_user_stars_on_update BEFORE UPDATE ON public.stars FOR EACH ROW EXECUTE FUNCTION public.check_user_stars_trigger();


--
-- Name: images images_image_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_image_type_id_fk FOREIGN KEY (image_type_id) REFERENCES public.image_types(id) ON DELETE SET NULL;


--
-- Name: movie_positions movie_positions_movie_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.movie_positions
    ADD CONSTRAINT movie_positions_movie_id_fk FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: movie_positions movie_positions_person_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.movie_positions
    ADD CONSTRAINT movie_positions_person_id_fk FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: movie_positions movie_positions_position_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.movie_positions
    ADD CONSTRAINT movie_positions_position_id_fk FOREIGN KEY (position_id) REFERENCES public.positions(id) ON DELETE CASCADE;


--
-- Name: movies movies_movie_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_movie_type_id_fk FOREIGN KEY (movie_type_id) REFERENCES public.movie_types(id) ON DELETE CASCADE;


--
-- Name: persons persons_main_photo_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_main_photo_id_fk FOREIGN KEY (main_photo_id) REFERENCES public.images(id) ON DELETE SET NULL;


--
-- Name: roles roles_movie_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_movie_id_fk FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON DELETE SET NULL;


--
-- Name: roles roles_person_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_person_id_fk FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: stars stars_movie_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.stars
    ADD CONSTRAINT stars_movie_id_fk FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: stars stars_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.stars
    ADD CONSTRAINT stars_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_profiles user_profiles_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_authorization_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_authorization_type_fk FOREIGN KEY (authorization_type) REFERENCES public.authorization_types(id) ON DELETE SET NULL;


--
-- Name: user_profiles users_profiles_avatar_image_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT users_profiles_avatar_image_id_fk FOREIGN KEY (avatar_image_id) REFERENCES public.images(id) ON DELETE SET NULL;


--
-- Name: videos videos_movie_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_movie_id_fk FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON DELETE SET NULL;


--
-- Name: videos videos_video_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_video_type_id_fk FOREIGN KEY (video_type_id) REFERENCES public.video_types(id) ON DELETE SET NULL;


--
-- Name: viewer_profiles viewer_profiles_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_sol
--

ALTER TABLE ONLY public.viewer_profiles
    ADD CONSTRAINT viewer_profiles_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

