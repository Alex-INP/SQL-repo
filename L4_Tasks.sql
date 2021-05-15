
-- ТЕМА КУРСОВОГО ПРОЕКТА: база данных "Управление сельскохозяйственным предприятием."

USE vk;
SELECT * FROM users LIMIT 10;

UPDATE users SET updated_at = now() WHERE updated_at < created_at 

SELECT * FROM profiles LIMIT 10;
CREATE TEMPORARY TABLE genders (name char(1));
INSERT INTO genders VALUES ("M"), ("F");
SELECT * FROM genders;
UPDATE profiles SET gender = (SELECT name FROM genders ORDER BY rand() LIMIT 1);

CREATE TABLE user_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  name VARCHAR(100) NOT NULL COMMENT "Название статуса (уникально)",
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Справочник статусов";  
INSERT INTO user_statuses (name) VALUES ('single'), ('married');
SELECT * FROM user_statuses;

UPDATE profiles SET status = NULL;
ALTER TABLE profiles RENAME COLUMN status TO user_status_id;
ALTER TABLE profiles MODIFY COLUMN user_status_id int UNSIGNED;
UPDATE profiles SET user_status_id = (SELECT id FROM user_statuses ORDER BY rand() LIMIT 1);



-- Новые таблицы с городами и странами.
CREATE TABLE countries (
 id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 name varchar(100) NOT NULL,
 created_at datetime NOT NULL DEFAULT current_timestamp,
 updated_at datetime NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp
 );

SELECT * FROM countries;
INSERT INTO countries (name) VALUES ('Russia'),('United Kingdom'),('France'),('South Korea');

CREATE TABLE cities (
 id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 name varchar(100) NOT NULL,
 country_id int UNSIGNED NOT NULL ,
 created_at datetime NOT NULL DEFAULT current_timestamp,
 updated_at datetime NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp,
 FOREIGN KEY (country_id) REFERENCES countries(id) 
 );

SELECT * FROM cities;

INSERT INTO cities (name, country_id) VALUES ('Moscow', 1),('Tula', 1),('Ryazan', 1),('Habarovsk', 1),('Obninsk', 1),
('London', 2),('Manchester', 2),('Edinburg', 2),('Glazgo', 2),('Brighton', 2),
('Paris', 3),('Monreal', 3),('Lion', 3),('Marselle', 3),('La Roshelle', 3),
('Seoul', 4),('Incheon', 4),('Gwangju', 4),('Busan', 4),('Daegu', 4);

UPDATE profiles SET city = NULL;
ALTER TABLE profiles RENAME COLUMN city TO city_id;
ALTER TABLE profiles DROP country;
ALTER TABLE profiles MODIFY COLUMN city_id int UNSIGNED;
ALTER TABLE profiles ADD FOREIGN KEY (city_id) REFERENCES cities(id);
UPDATE profiles SET city_id = (SELECT id FROM cities ORDER BY rand() LIMIT 1); 
 -- Конец 



SELECT * FROM messages;
ALTER TABLE messages ADD COLUMN media_id int UNSIGNED AFTER body; 
UPDATE messages SET from_user_id = floor(1+Rand()*100), from_user_id = floor(1+Rand()*100);
UPDATE messages SET media_id = floor(1+rand()*100);

SELECT * FROM media LIMIT 10;
UPDATE media SET user_id = floor(1+rand()*100);

UPDATE media SET SIZE = floor(10000+(rand()*1000000)) WHERE SIZE < 1000;

DROP TABLE IF EXISTS extensions;
CREATE TEMPORARY TABLE extensions (name varchar(10));
INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mpeg'), ('png');
SELECT * FROM extensions;
UPDATE media SET filename = concat('http://dropbox.net/vk/', filename, '.', 
(SELECT name FROM extensions ORDER BY rand() LIMIT 1));

UPDATE media SET metadata = concat('{"owner":"', 
  (SELECT concat(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '"}');  
ALTER TABLE media MODIFY COLUMN metadata JSON;

SELECT * FROM media_types;
truncate media_types;
INSERT INTO media_types (name) VALUES ('photo'), ('video'), ('audio');

SELECT * FROM media LIMIT 10;
UPDATE media SET media_type_id = floor(1 + rand() * 3);

DESC friendship;
SELECT * FROM friendship LIMIT 10;
 /*!40000 ALTER TABLE `friendship` DISABLE KEYS */;
 UPDATE friendship SET 
  user_id = floor(1 + rand() * 100),
  friend_id = floor(1 + rand() * 100);
UPDATE friendship SET friend_id = friend_id + 1 WHERE user_id = friend_id;
 /*!40000 ALTER TABLE `friendship` ENABLE KEYS */;
 
SELECT * FROM friendship_statuses;
truncate friendship_statuses;
INSERT INTO friendship_statuses (name) VALUES ('Requested'), ('Confirmed'), ('Rejected');

UPDATE friendship SET status_id = floor(1 + rand() * 3); 

DESC communities;
SELECT * FROM communities;
DELETE FROM communities WHERE id > 20;

SELECT * FROM communities_users;
UPDATE communities_users SET community_id = floor(1 + rand() * 20);

