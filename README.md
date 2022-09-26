# Курсовой проект по курсу GeekBrains "Базы данных. PostgreSQL."

За основу проекта взят сервис "Кинопоиск".

## Наименование файлов

За основу соглашения о наименовании взяты пункты требований к курсовому проекту. Отчет по каждому этапу выполнения именуется по следующему шаблону:
`<номер шага>_Stage_<краткое описание>`

## Дополнительные материалы

Дополнительные материалы храняться в папке `/complementary_data` и разбиты по папкам этапов выполнения. Представляют собой рабочие заметки и материалы к выполнению и, возможно, пояснения.

## Этапы

1. Проанализировать бизнес-логику приложения и создать структуру базы данных, котораяможет использоваться для хранения данных этого приложения. В базе данных должно быть минимум десять таблиц. Если таблиц получается более двадцати то рекомендуетсяо граничиться частью функционала приложения и не превышать это количество. В качестве отчета по этой части проекта необходимо приложить команды создания таблиц.
   - **Отчёт:** [01_Stage_Create_tables](https://github.com/Solmak/GB_PostgreSql_course-project/blob/master/01_Stage_Create_tables.sql)

2. Используя генератор тестовых данных, заполнить созданную БД данными в количестве минимум сто строк для тех таблиц, где это имеет смысл. Доработать данные запросами если это необходимо. В качестве отчёта приложить дамп БД с данными.
   - **Отчёт:** [02_Stage_kp.dump](https://github.com/Solmak/GB_PostgreSql_course-project/blob/master/02_Stage_kp.dump.sql)

3. Создать внешние ключи, если они не были созданы на шаге 1 в командах создания таблиц.В качестве отчета приложить команды создания внешних ключей.
   - **Отчёт:** [03_Stage_Сreating_Foreign_Keys](https://github.com/Solmak/GB_PostgreSql_course-project/blob/master/03_Stage_Сreating_Foreign_Keys.sql)

4. Создать диаграмму отношений. В качестве отчета приложить файл изображения диаграммы отношений.
   - **Отчёт:** [04_Stage_ERD_image](https://github.com/Solmak/GB_PostgreSql_course-project/blob/master/04_Stage_ERD_image.png)

5. Создать два сложных (многотабличных) запроса с использованием подзапросов.
   - **Отчёт:** [05_Stage_Queries](https://github.com/Solmak/GB_PostgreSql_course-project/blob/master/05_Stage_Queries.sql)

6. Создать два сложных запроса с использованием объединения JOIN и без использования подзапросов.
   - **Отчёт:** [06_Stage_Queries](https://github.com/Solmak/GB_PostgreSql_course-project/blob/master/06_Stage_Queries.sql)

7. Создать два представления, в основе которых лежат сложные запросы.
   - **Отчёт:** [07_Stage_Queries](https://github.com/Solmak/GB_PostgreSql_course-project/blob/master/07_Stage_Queries.sql)

8. Создать пользовательскую функцию.
   - **Отчёт:** [08_Stage_Queries](https://github.com/Solmak/GB_PostgreSql_course-project/blob/master/08_Stage_Queries.sql)

9. Создать триггер.
   - **Отчёт:** [09_Stage_Queries](https://github.com/Solmak/GB_PostgreSql_course-project/blob/master/09_Stage_Queries.sql)

10. Для одного из запросов, созданных в пункте 6, провести оптимизацию. В качестве отчета приложить планы выполнения запроса, ваш анализ и показать действия, которые улучшили эффективность запроса.
    - **Отчёт** [10_Stage_Optimization PDF](https://github.com/Solmak/GB_PostgreSql_course-project/blob/master/10_Stage_Optimization.pdf)
    - **Отчёт** [10_Stage_Optimization SQL](https://github.com/Solmak/GB_PostgreSql_course-project/blob/master/10_Stage_Optimization.sql)
