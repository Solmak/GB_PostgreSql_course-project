/* 5
Создать два сложных (многотабличных) запроса с использованием подзапросов.
*/

/*
Найти пять самых рейтинговых фильмов, оцененых более одного раза.
Вывести id, название, рейтинг, количество оценок, имя и фамилию пользователя, который оценил этое фильм первым
*/
SELECT 
    movies.id,
    movies.title,
    (SELECT ROUND(AVG(number_of_stars),1) 
	 	FROM stars 
	 WHERE movie_id = movies.id
	 GROUP BY movie_id
	) AS rate,
    (SELECT COUNT(number_of_stars)
	 	FROM stars 
	 WHERE movie_id = movies.id
	 GROUP BY movie_id
	) AS number_of_ratings,
	(SELECT (name || ' ' || surname ) 
	 	FROM user_profiles
	 	WHERE user_id = (SELECT user_id 
						 	FROM stars 
						 	WHERE movies.id = movie_id
							ORDER BY rated_at
							LIMIT 1)
	 ) as first_user
    FROM movies
	WHERE (SELECT COUNT(number_of_stars)
	 	FROM stars 
	 WHERE movie_id = movies.id
	 GROUP BY movie_id) > 1
    ORDER BY rate DESC NULLS LAST LIMIT 5;


/*
Найти актеров фильма, который пользователь с именем Rooney Cooley отметил последним.
Вывести, имя и фамилию актера, фильм актера с наивысшим рейтингом, рейтинг фильма
*/
SELECT
    -- актер
    person_name || ' ' || person_surname AS actor_name,
    (
    -- название фильма
    SELECT
        m.title AS actor_best_movie
    FROM
        movies m
    WHERE
        m.id = (
        SELECT
            --  лучший фильм
            s.movie_id
        FROM
            stars s
        GROUP BY
            s.movie_id
        HAVING
            s.movie_id IN (
            SELECT
                r.movie_id
            FROM
                roles r
            WHERE
                r.person_id = p.id)
        ORDER BY
            avg(s.number_of_stars) DESC
        LIMIT 1
            )
    LIMIT 1
        ),
    (
    -- звезды фильма
    SELECT  
         round( avg(s2.number_of_stars), 1) AS best_movie_rate
    FROM
        stars s2
    WHERE
        s2.movie_id = (
        SELECT
            --  лучший фильм
            s.movie_id
        FROM
            stars s
        GROUP BY
            s.movie_id
        HAVING
            s.movie_id IN (
            SELECT
                r.movie_id
            FROM
                roles r
            WHERE
                r.person_id = p.id)
        ORDER BY
            avg(s.number_of_stars) DESC
        LIMIT 1
            )
        )
FROM
    persons p
WHERE
    p.id IN (
    SELECT
        r2.person_id
    FROM
        roles r2
    WHERE
        r2.movie_id = (
        SELECT
            s3.movie_id
        FROM
            stars s3
        WHERE
            s3.user_id = (
            SELECT
                up.user_id
            FROM
                user_profiles up
            WHERE
                up."name" = 'Rooney'
                AND up.surname = 'Cooley'
            LIMIT 1)
        ORDER BY
            s3.rated_at DESC
        LIMIT 1));

