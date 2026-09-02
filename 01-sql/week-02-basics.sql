-- ============================================
-- 2-жума: SQL негизи
-- Тема: SELECT, WHERE, ORDER BY, LIMIT, DISTINCT, NULL
-- Максат: 30 маселе
-- ============================================
--
-- ЭРЕЖЕ: ар бир суроону жазардан МУРУН, төмөнкү сапка
-- эмне күтөрүңдү жаз. Анан иштет. Дал келбесе — токто, ойлон.
--
-- Үлгү:
--   -- Күтөм: ~40 сап, эки мамыча (name, score)
--   SELECT name, score FROM students WHERE score > 100;
--   -- Чыкты: 38 сап. Дал келди.
--
-- ============================================


-- --------------------------------------------
-- 1. SELECT жана WHERE
-- --------------------------------------------

-- 1.1  Find the title of each film
-- Күтөм: 14 катар, 1 тилке
SELECT title FROM movies;
-- Чыкты: 14. Дал келди.



-- 1.2 Find the director of each film
-- Күтөм: 14 катар, 1 тилке
SELECT director FROM movies;
-- Чыкты: 14. Дал келди.

-- 1.3 Find the title and director of each film
-- Күтөм: 14 катар, 2 тилке
SELECT title, director FROM movies;
-- Чыкты: 14. Дал келди.


-- 1.4 Find the title and year of each film
-- Күтөм: 14 катар, 2 тилке
SELECT title, year FROM movies;
-- Чыкты: 14. Дал келди.


-- 1.5 Find all the information about each film
-- Күтөм: 14 катар, 5 тилке
SELECT * FROM movies;
-- Чыкты: 14. Дал келди.


-- 1.6  Find the movie with a row id of 6   [sqlbolt 2-сабак]
-- Күтөм: 1 катар, 5 тилке — id primary key, кайталанбайт
SELECT * FROM movies WHERE id = 6;
-- Чыкты: 1. Дал келди.

-- 1.7  Find the movies released in the years between 2000 and 2010   [sqlbolt 2-сабак]
-- Күтөм: 10 катар — 11 жыл, жылына бирден чыгат деп ойлодум
SELECT * FROM movies WHERE year BETWEEN 2000 AND 2010;
-- Чыкты: 8. ЖАҢЫЛДЫМ — 10 күттүм, 2ге аз чыкты.

-- 1.8  Find the movies not released in the years between 2000 and 2010   [sqlbolt 2-сабак]
-- Күтөм: 4 катар — Pixar'дын 20 жылдык тарыхынан болжолдодум
SELECT * FROM movies WHERE year NOT BETWEEN 2000 AND 2010;
-- Чыкты: 6. ЖАҢЫЛДЫМ — 14-8=6 деп эсептесем болмок, болжолдоп отурдум.

-- 1.9  Find all the Toy Story movies   [sqlbolt 3-сабак]
-- Күтөм: 3 катар — Toy Story сериясында 3 фильм бар
SELECT title FROM movies WHERE title LIKE 'Toy Story%';
-- Чыкты: 3. Дал келди.

-- 1.10  Find all the movies directed by John Lasseter   [sqlbolt 3-сабак]
-- Күтөм: 3-4 катар — Lasseter Pixar'дын алгачкы фильмдерин тарткан
SELECT title FROM movies WHERE director = 'John Lasseter';
-- Чыкты: 5. ЖАҢЫЛДЫМ — 3-4 күттүм, 1ге көп чыкты.

-- 1.11  Find all the movies (and director) not directed by John Lasseter   [sqlbolt 3-сабак]
-- Күтөм: 9 катар — 14-5=9 деп эсептедим
SELECT title, director FROM movies WHERE director != 'John Lasseter';
-- Чыкты: 10. ЖАҢЫЛДЫМ — таблицада 14 эмес, 15 катар бар экен (WALL-G кошулуптур). 15-5=10.

-- 1.12  Find all the WALL-* movies   [sqlbolt 3-сабак]
-- Күтөм: 2 катар — мурунку натыйжада WALL-E жана WALL-G көрдүм
SELECT title FROM movies WHERE title LIKE 'WALL-%';
-- Чыкты: 2. Дал келди.

-- 1.13  Toy Story фильмдерин IN аркылуу табуу (өз машыгуум)
-- Күтөм: 3 катар — 1.9да LIKE менен 3 чыккан
SELECT title FROM movies WHERE title IN ('Toy Story', 'Toy Story 2', 'Toy Story 3');
-- Чыкты: 3. Дал келди.

-- --------------------------------------------
-- 2. ORDER BY жана LIMIT
-- --------------------------------------------

-- 2.1  Find the first 5 Pixar movies and their release year   [sqlbolt 2-сабак]
-- Күтөм: 5 катар, 2 тилке — LIMIT 5 бешөөнү кайтарат, SELECTте эки тилке атадым
SELECT title, year FROM movies
LIMIT 5;
-- Чыкты: 5 катар, 2 тилке. Дал келди.

-- 2.2  List all directors of Pixar movies (alphabetically), without duplicates   [sqlbolt 5-сабак]
-- Күтөм: сан жазган жокмун — 11 эң көбү деп гана билчүмүн
SELECT DISTINCT director FROM movies ORDER BY director ASC;
-- Чыкты: 7 режиссёр. 15 фильмге 7 режиссёр — орточо 2.1 фильмден.

-- 2.3  List the last four Pixar movies released (ordered from most recent to least)   [sqlbolt 5-сабак]
-- Күтөм: 4 катар, 2 тилке — тапшырмада "four" деп жазылган, SELECTте эки тилке атадым
--         Кошумча божомол: эң жаңы фильм 2014-жылдыкы болушу мүмкүн
SELECT title, year FROM movies ORDER BY year DESC LIMIT 4;
-- Чыкты: 4 катар, 2 тилке. Дал келди.
--         Кошумча: эң жаңысы 2013 чыкты — бир жылга жаңылдым.
--         Таблица 2013тө токтойт, Pixar андан кийин да фильм чыгарган.

-- 2.4  List the first five Pixar movies sorted alphabetically   [sqlbolt 5-сабак]
-- Күтөм: 5 катар, 1 тилке — 15 фильмди алфавит боюнча иреттеп, биринчи 5өөнү алам
SELECT title FROM movies ORDER BY title LIMIT 5;
-- Чыкты: 5 катар, 1 тилке. Дал келди.

-- 2.5  List the next five Pixar movies sorted alphabetically   [sqlbolt 5-сабак]
-- Күтөм: 5 катар, 1 тилке — 2.4тун уландысы, алфавит боюнча 6-10-фильмдер
SELECT title FROM movies ORDER BY title LIMIT 5 OFFSET 5;
-- Чыкты: 5 катар, 1 тилке. Дал келди.



-- --------------------------------------------
-- 3. DISTINCT
-- --------------------------------------------

-- 3.1
-- Күтөм:



-- --------------------------------------------
-- 4. NULL — эң маанилүү бөлүк
-- --------------------------------------------
--
-- Суроо: эмне үчүн `WHERE score = NULL` эч качан эч нерсе кайтарбайт?
-- Жообуңду ушул жерге өз сөзүң менен жаз:
--
-- ЖООП:
--  NULL дегени — белгисиз маани. Ноль да эмес, бош текст да эмес.
-- Ошондуктан score = NULL деген салыштыруу UNKNOWN кайтарат.
--  WHERE болсо TRUE болгон катарларды гана сактайт.
-- UNKNOWN сакталбайт, ошондуктан жыйынтык дайыма бош чыгат.
-- Туурасы: IS NULL / IS NOT NULL


-- 4.1
-- Күтөм:



-- ============================================
-- Жуманын жыйынтыгы
-- ============================================
-- Чечилген маселе саны:
-- Эң кыйын болгону:
-- errors.md файлына жазылган каталар:
