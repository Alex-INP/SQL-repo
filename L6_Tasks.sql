USE vk;
/* Задание: Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения (JOIN пока не применять)*/
-- Было:
SELECT user_id, filename, size 
  FROM media 
  ORDER BY size DESC
  LIMIT 10;
-- Стало: добавили кавычки к size
SELECT user_id, filename, `size` 
  FROM media 
  ORDER BY `size` DESC
  LIMIT 10;
  
/* Задание: Пусть задан некоторый пользователь. 
Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.*/
-- Решение:  
SELECT id AS target_user, (SELECT from_user_id FROM messages WHERE to_user_id = users.id GROUP BY from_user_id ORDER BY from_user_id LIMIT 1) AS top_msg_user FROM users WHERE id = 4;

/* Задание: Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.*/
-- Решение:
SELECT user_id, birthday, (SELECT count(target_id) FROM likes WHERE target_id = profiles.user_id AND target_type_id = (SELECT id FROM target_types WHERE name = "users")) AS `likes` 
FROM profiles ORDER BY birthday DESC LIMIT 10;

/* Задание: Определить кто больше поставил лайков (всего) - мужчины или женщины?*/
-- Решение:
SELECT 
sum((SELECT count(user_id) FROM likes WHERE user_id = profiles.user_id AND profiles.gender = 'm' AND target_type_id = (SELECT id FROM target_types WHERE name = "users"))) AS `M`, 
sum((SELECT count(user_id) FROM likes WHERE user_id = profiles.user_id AND profiles.gender = 'f' AND target_type_id = (SELECT id FROM target_types WHERE name = "users"))) AS `F`
FROM profiles;

/* Задание: Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.*/
-- Решение: 
SELECT user_id, count(user_id) FROM (SELECT user_id FROM likes
UNION ALL
SELECT from_user_id FROM messages 
UNION ALL
SELECT user_id FROM posts) al GROUP BY user_id ORDER BY count(user_id) DESC LIMIT 10;