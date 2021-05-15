-- Задание: Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
CREATE DATABASE test;
USE test;
DROP TABLE IF EXISTS users;
CREATE TABLE users (id int UNSIGNED, created_at datetime, updated_at datetime);
INSERT users (id) VALUES (1),(2),(3),(4),(5),(6),(7); 
SELECT * FROM users;

-- Решение:
UPDATE users SET created_at = current_timestamp , updated_at = current_timestamp;

/*Задание: Таблица users была неудачно спроектирована. 
Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.*/
DROP TABLE IF EXISTS users;
CREATE TABLE users (id int UNSIGNED, created_at varchar(100), updated_at varchar(100));
INSERT users VALUES (1, "21.10.2017 8:10", "22.10.2017 8:10"),
(2, "23.10.2017 8:10", "24.10.2017 8:10"),(3, "25.10.2017 8:10", "26.10.2017 8:10"),
(4, "27.10.2017 8:10", "28.10.2017 8:10"),(5, "29.10.2017 8:10", "30.10.2017 8:10"),
(6, "31.10.2017 8:10", "01.11.2017 8:10"),(7, "02.11.2017 8:10", "03.11.2017 8:10");
DESC users;
SELECT * FROM users;

-- Решение:
UPDATE users SET created_at=concat(substring(created_at,7,4),"-",
substring(created_at,4,2),"-",
substring(created_at,1,2)," ",
substring(created_at,12,1),":",
substring(created_at,14,2),":00"),
updated_at=concat(substring(updated_at,7,4),"-",
substring(updated_at,4,2),"-",
substring(updated_at,1,2)," ",
substring(updated_at,12,1),":",
substring(updated_at,14,2),":00");

ALTER TABLE users MODIFY COLUMN created_at datetime;
ALTER TABLE users MODIFY COLUMN updated_at datetime;
SELECT * FROM users;
DESC users;

/* Задание: В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
0, если товар закончился и выше нуля, если на складе имеются запасы. 
Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
Однако нулевые запасы должны выводиться в конце, после всех записей.
*/
CREATE TABLE storehouses_products (value int);
INSERT storehouses_products VALUES (12),(123),(0),(8),(65),(0),(664),(83);
SELECT * FROM storehouses_products;

-- Решение:
SELECT value FROM storehouses_products ORDER BY (value = 0), value;

/* Задание: (по желанию) Из таблицы users необходимо извлечь пользователей, 
 родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august).*/

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at varchar(100) COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', 'september'),
  ('Наталья', 'august'),
  ('Александр', 'november'),
  ('Сергей', 'may'),
  ('Иван', 'may'),
  ('Мария', 'october');
 SELECT * FROM users;

-- Решение:
SELECT * FROM users WHERE birthday_at = 'may' OR birthday_at = 'august';

/*Задание:(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
 * SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
 * Отсортируйте записи в порядке, заданном в списке IN.*/ 
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
 SELECT * FROM catalogs;

-- Решение:
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY (id = 5) DESC;

/*Задание: Подсчитайте средний возраст пользователей в таблице users.*/ 
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');
  SELECT * FROM users;

-- Решение:
SELECT avg((YEAR(now())-YEAR(birthday_at))) FROM users;

/*Задание: Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 * Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/ 
 
-- Решение:
SELECT count(dayname(date_format(birthday_at, "2021-%m-%d"))) AS week_count, 
dayname(date_format(birthday_at, "2021-%m-%d")) AS week_day 
FROM users GROUP BY week_day;

/*Задание: (по желанию) Подсчитайте произведение чисел в столбце таблицы.*/ 
CREATE TABLE numbers(num int);
INSERT numbers VALUES (2),(3),(4),(7),(9);
SELECT * FROM numbers;

-- Решение:
SELECT exp(sum(log(num))) FROM numbers;
