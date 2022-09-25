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
	) AS number_of_stars,
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
Найти актеров фильма, который пользователь с определенным id отметил последним.
Вывести, имя и фамилию актера, фильм актера с наивысшим рейтингом, рейтинг фильма
*/
SELECT 
    person_name || ' ' || person_surname AS actor_name,
    'best movie' AS actor_best_movie,
    'rate' AS best_movie_rate,
    'user' AS user_name
FROM persons
WHERE persons.id = 22
;

