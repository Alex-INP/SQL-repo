-- Характерные выборки.

-- Все содержимое складов всех филиалов.
SELECT branch_id, instrument_id AS good_id, quantity, (SELECT 'instrument') AS good_type FROM instrumentsstorages 
UNION ALL 
SELECT branch_id, machinery_id, quantity, (SELECT 'machinery') FROM machinerystorages
UNION ALL
SELECT branch_id, material_id, quantity, (SELECT 'material') FROM materialsstorages
UNION ALL
SELECT branch_id, animal_id, quantity, (SELECT 'animal') FROM animalstorages;

-- Имя, фамилия директоров филиалов а также айди филиала и его название.
SELECT e.name AS director_name, e.surname AS director_surname, b.id AS branch_id , b.name AS branch_name 
FROM employees e JOIN branch b ON b.director_id = e.id; 

-- Только те номера контрактов, которые были заключены на покупку животных.
SELECT `number` FROM contracts WHERE operation_type = 'buy' AND type_id IN 
(SELECT id FROM nomenclature WHERE good_type_id = (SELECT id FROM goods WHERE name = 'animal'));

-- Подсчет количества контрактов совершенных для каждого типа операции.
SELECT operation_type, count(operation_type) AS number_of_contracts FROM contracts c GROUP BY operation_type;

-- Общее количество скота в каждом филиале.
SELECT branch_id, sum(quantity) AS total_animal_count FROM animalstorages GROUP BY branch_id;

-- Только те филиалы, где суммарное количество техники не превышает 100.
SELECT branch_id, sum(quantity) FROM machinerystorages GROUP BY branch_id HAVING sum(quantity) < 100;

-- Размер самого большого земельного участка среди всех филиалов.
SELECT max(`size`) FROM land; 

-- Филиал с самым большим количеством земли в сумме.
SELECT branch_id, sum(`size`) AS total_size FROM land GROUP BY branch_id ORDER BY total_size DESC LIMIT 1; 

-- Только те айди филиалов в которых есть коровы, также айди породы коровы и количество.
SELECT branch_id, animal_id, quantity FROM animalstorages WHERE animal_id IN (SELECT id FROM nomenclature WHERE `type` = 'cow');

-- Имя и фамилия сотрудников и название филиалов в которых они числятся.
SELECT concat(e.name,' ' ,e.surname), f.name FROM employees e INNER JOIN (SELECT id, name FROM branch) AS f ON f.id = e.branch_id ;

-- ПРЕДСТАВЛЕНИЕ Все содержимое складов всех филиалов.
CREATE OR REPLACE VIEW all_storages AS 
SELECT branch_id, instrument_id AS good_id, quantity, (SELECT 'instrument') AS good_type FROM instrumentsstorages 
UNION ALL 
SELECT branch_id, machinery_id, quantity, (SELECT 'machinery') FROM machinerystorages
UNION ALL
SELECT branch_id, material_id, quantity, (SELECT 'material') FROM materialsstorages
UNION ALL
SELECT branch_id, animal_id, quantity, (SELECT 'animal') FROM animalstorages;

-- ПРЕДСТАВЛЕНИЕ Включает в себя некоторую информацию о контракте, а также расширенные данные об обьекте сделки.
CREATE OR REPLACE VIEW detailed_contracts (contract_number, counterparty_id, operation_type, name_of_good, type_of_unit, good_type_id, good_description) AS
SELECT c.`number`, c.counterparty_id , c.operation_type , n.name, n.`type`, n.good_type_id, n.description FROM contracts c JOIN nomenclature n ON c.type_id = n.id ;




