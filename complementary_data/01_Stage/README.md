# Курсовой проект по курсу GeekBrains "Базы данных. PostgreSQL."

## Этап 1

Проанализировать бизнес-логику приложения и создать структуру базы данных, которая
может использоваться для хранения данных этого приложения. В базе данных должно быть
минимум десять таблиц. Если таблиц получается более двадцати то рекомендуется
ограничиться частью функционала приложения и не превышать это количество. В качестве
отчета по этой части проекта необходимо приложить команды создания таблиц.

### Список таблиц

| №   | Название таблицы    | Описание                                                   |
| --- | ------------------- | ---------------------------------------------------------- |
| 1   | authorization_types | Типы авторизации пользователей.                            |
| 2   | users               | Пользователи. Hot info.                                    |
| 3   | user_profiles       | Профили пользователей. 1:1 с пользователями                |
| 4   | viewer_profiles     | Профили зрителей. Может быть несколько на пользователя     |
| 5   | genres              | Жанры фильмов.                                             |
| 6   | movie_types         | Виды фильмов.                                              |
| 7   | movies              | Фильмы.                                                    |
| 8   | stars               | Пользовательские звезды (оценки)                           |
| 9   | image_types         | Виды изображений.                                          |
| 10  | images              | Изображения                                                |
| 11  | video_types         | Виды видео                                                 |
| 12  | videos              | Видео.                                                     |
| 13  | positions           | Виды персоналий (актер, режисер, продюсер и т.п.)          |
| 14  | persons             | Персоналии                                                 |
| 15  | roles               | В ролях.                                                   |
| 16  | movie_positions     | Титры :) не знаю как назвать. Актеры, режисеры, осветители |

### Пользовательсие типы данных

| №   | Тип              | Описание                                                            |
| --- | ---------------- | ------------------------------------------------------------------- |
| 1   | genders          | Пол. ENUM.                                                          |
| 2   | age_restrictions | Возрастные ограничения. ENUM. В России их 5 (0+, 6+, 12+, 16+, 18+) |
