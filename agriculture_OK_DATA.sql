SELECT * FROM contracts c ;

-- Изменение данных таблицы accounts.
DROP TABLE IF EXISTS currency;
CREATE TEMPORARY TABLE currency(name varchar(30));
INSERT INTO currency VALUES ("USD"),("RUB"),("EUR");
UPDATE accounts SET currency_type = (SELECT * FROM currency ORDER BY rand() LIMIT 1);

UPDATE accounts SET branch_id = floor(1+rand()*7);

UPDATE accounts SET updated_at = NOW() WHERE updated_at < created_at;

-- Изменение данных таблицы animal storages.
UPDATE animalstorages SET updated_at = NOW() WHERE updated_at < created_at;

-- Изменение данных таблицы branch.
UPDATE branch SET updated_at = NOW() WHERE updated_at < created_at;

-- Изменение данных таблицы contracts.
UPDATE contracts SET updated_at = NOW() WHERE updated_at < created_at;

DROP TABLE IF EXISTS con_oper;
CREATE TEMPORARY TABLE con_oper(name varchar(50));
INSERT INTO con_oper VALUES ("buy"), ("sell");
UPDATE contracts SET operation_type = (SELECT * FROM con_oper ORDER BY rand() LIMIT 1);

UPDATE contracts SET counterparty_id = floor(1+rand()*25);

-- Изменение данных таблицы counterparty.
UPDATE counterparty SET data = concat('{"city":"Moscow", "INN":',(floor(1000000000+rand()*9999999999)), '}');

-- Изменение данных таблицы employees.
DROP TABLE IF EXISTS genders;
CREATE TEMPORARY TABLE genders (name CHAR(1));
INSERT INTO genders VALUES ('M'), ('F'); 
UPDATE employees SET gender = (SELECT * FROM genders ORDER BY rand() LIMIT 1);

UPDATE employees SET birth_date = date_format(birth_date, '1980-%m-%d') WHERE birth_date > '1980-01-01';
UPDATE employees SET employment_date = date_format(employment_date, '2000-%m-%d') WHERE birth_date < '2000-01-01';
UPDATE employees SET created_at = employment_date;
UPDATE employees SET updated_at = NOW() WHERE updated_at < created_at;
UPDATE employees SET branch_id = floor(1+rand()*7);

-- Изменение данных таблицы instrumentsstorages.
UPDATE instrumentsstorages SET updated_at = NOW() WHERE updated_at < created_at;
-- Изменение данных таблицы instrumentsstorages.
UPDATE machinerystorages SET updated_at = NOW() WHERE updated_at < created_at;
-- Изменение данных таблицы materialsstorages.
UPDATE materialsstorages SET updated_at = NOW() WHERE updated_at < created_at;

DROP TABLE IF EXISTS units;
CREATE TEMPORARY TABLE units (name CHAR(10));
INSERT INTO units VALUES ('kg'), ('liter'), ('pood'); 
UPDATE materialsstorages SET unit_name = (SELECT name FROM units ORDER BY rand() LIMIT 1);

-- Изменение данных таблицы land.
UPDATE land SET updated_at = NOW() WHERE updated_at < created_at;
UPDATE land SET branch_id = floor(1+rand()*7);

-- Изменение данных таблицы nomenclature.
UPDATE nomenclature SET good_type_id = floor(1+rand()*4);

DROP TABLE IF EXISTS material;
CREATE TEMPORARY TABLE material (name char(10));
INSERT INTO material VALUES ('hay'), ('sawdust'), ('sand');

DROP TABLE IF EXISTS animal;
CREATE TEMPORARY TABLE animal (name char(10));
INSERT INTO animal VALUES ('goat'), ('cow'), ('chicken');

DROP TABLE IF EXISTS instruments;
CREATE TEMPORARY TABLE instruments (name varchar(50));
INSERT INTO instruments VALUES ('showel'), ('pitchfork'), ('wheelbarrow');

DROP TABLE IF EXISTS machinery;
CREATE TEMPORARY TABLE machinery (name CHAR(10));
INSERT INTO machinery VALUES ('bus'), ('tractor'), ('harvester');

UPDATE nomenclature SET `type` = (SELECT name FROM material ORDER BY rand() LIMIT 1) WHERE good_type_id = 1;
UPDATE nomenclature SET `type` = (SELECT name FROM animal ORDER BY rand() LIMIT 1) WHERE good_type_id = 2;
UPDATE nomenclature SET `type` = (SELECT name FROM instruments ORDER BY rand() LIMIT 1) WHERE good_type_id = 3;
UPDATE nomenclature SET `type` = (SELECT name FROM machinery ORDER BY rand() LIMIT 1) WHERE good_type_id = 4;
