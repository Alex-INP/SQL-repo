/* Задание: Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.*/
-- Решение:
SELECT id FROM users WHERE id IN (SELECT user_id FROM orders);

/* Задание: Выведите список товаров products и разделов catalogs, который соответствует товару.*/
-- Решение:
SELECT name, (SELECT name FROM catalogs WHERE id = products.catalog_id) FROM products;

/* Задание: (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
 Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.*/

-- Решение:
SELECT `from`, (SELECT name FROM cities WHERE label = flights.to) FROM flights; 