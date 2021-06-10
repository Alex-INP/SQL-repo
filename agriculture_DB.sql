/*База данных сельхоз предприятия. Осуществляет хранение информации о филиалах, количеству сотрудников в них. О земельных участках.
 * Ведеь складской учет как животных на филиалах, так и техники, инструментов и материалов. 
 * Также БД хранит данные контрагентов и контрактов заключенных с ними на покупку\продажу той или иной единицы хранимого имущества*/

DROP DATABASE IF EXISTS agriculture;
CREATE DATABASE agriculture;
USE agriculture;

CREATE TABLE branch(
 id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY comment "идентификатор филиала",
 name varchar(250) NOT NULL comment "название филиала",
 address varchar (500) NOT NULL comment "адрес филиала",
 director_id int UNSIGNED NOT NULL comment "идентификатор управляющего филиала", 
 created_at datetime NOT NULL DEFAULT current_timestamp,
 updated_at datetime NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp
) comment "филиалы предприятия";

CREATE TABLE employees(
 id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY comment "идентификатор сотрудника",
 name varchar(250) NOT NULL comment "имя",
 surname varchar(250) NOT NULL comment "фамилия",
 patronymic varchar(250) comment "отчество",
 gender char NOT NULL comment "пол",
 birth_date datetime NOT NULL comment "дата рождения",
 employment_date datetime comment "когда принят в штат",
 branch_id int UNSIGNED NOT NULL comment "идентификатор отделения",
 created_at datetime NOT NULL DEFAULT current_timestamp,
 updated_at datetime NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp,
 CONSTRAINT branch_key FOREIGN KEY (branch_id) REFERENCES branch(id) ON UPDATE CASCADE ON DELETE CASCADE
) comment "сотрудники";

CREATE TABLE goods (
id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY comment "идентификатор вида товара",
name varchar(100) NOT NULL comment "название вида товара"
) comment "названия видов товара: животные, инструменты итд.";

CREATE TABLE nomenclature(
id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY comment "идентификатор номенклатурной единицы",
name varchar (150) NOT NULL UNIQUE comment "название номенклатурной единицы",
`type` varchar(100) NOT NULL comment "тип номенклатурной единицы: зерно\корова\комбайн итд",
 good_type_id int UNSIGNED NOT NULL comment "вид номенклатурной единицы: техника\инструменты\сырье\животные",
description text comment "описание номенклатурной единицы",
FOREIGN KEY (good_type_id) REFERENCES goods(id)
)comment "описание сырья";

CREATE TABLE machineryStorages(
 branch_id int UNSIGNED NOT NULL comment "идентификатор филиала",
 machinery_id int UNSIGNED NOT NULL comment "идентификатор техники",
 quantity int UNSIGNED comment "количество единиц техники",
 PRIMARY KEY (branch_id, machinery_id),
 FOREIGN KEY (branch_id) REFERENCES branch(id) ON UPDATE CASCADE ON DELETE CASCADE,
 FOREIGN KEY (machinery_id) REFERENCES nomenclature(id),
 created_at datetime NOT NULL DEFAULT current_timestamp,
 updated_at datetime NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp
) comment "количество техники в филиалах";

CREATE TABLE materialsStorages(
 branch_id int UNSIGNED NOT NULL comment "идентификатор филиала",
 material_id int UNSIGNED NOT NULL comment "идентификатор сырья",
 quantity int UNSIGNED comment "количество единиц сырья",
 unit_name varchar(100) comment "наименование единицы измерения сырья (литр, килограмм, баррель итд.)",
 PRIMARY KEY (branch_id, material_id),
 FOREIGN KEY (branch_id) REFERENCES branch(id) ON UPDATE CASCADE ON DELETE CASCADE,
 FOREIGN KEY (material_id) REFERENCES nomenclature(id),
 created_at datetime NOT NULL DEFAULT current_timestamp,
 updated_at datetime NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp
) comment "количество сырья в филиалах";

CREATE TABLE instrumentsStorages(
 branch_id int UNSIGNED NOT NULL comment "идентификатор филиала",
 instrument_id int UNSIGNED NOT NULL comment "идентификатор инструмента",
 quantity int UNSIGNED comment "количество единиц инструмента",
 PRIMARY KEY (branch_id, instrument_id),
 FOREIGN KEY (branch_id) REFERENCES branch(id) ON UPDATE CASCADE ON DELETE CASCADE,
 FOREIGN KEY (instrument_id) REFERENCES nomenclature(id),
 created_at datetime NOT NULL DEFAULT current_timestamp,
 updated_at datetime NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp
) comment "количество инструментов в филиалах";

CREATE TABLE animalStorages(
 branch_id int UNSIGNED NOT NULL comment "идентификатор филиала",
 animal_id int UNSIGNED NOT NULL comment "идентификатор типа животного",
 quantity int UNSIGNED comment "количество единиц скота",
 PRIMARY KEY (branch_id, animal_id),
 FOREIGN KEY (branch_id) REFERENCES branch(id) ON UPDATE CASCADE ON DELETE CASCADE,
 FOREIGN KEY (animal_id) REFERENCES nomenclature(id),
 created_at datetime NOT NULL DEFAULT current_timestamp,
 updated_at datetime NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp
) comment "количество животных в филиалах";

CREATE TABLE land(
 id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY comment "идентификатор земельного участка",
 branch_id int UNSIGNED NOT NULL comment "идентификатор филиала",
`size` int UNSIGNED NOT NULL comment "размер участка в гектарах",
 address text NOT NULL comment "адрес земельного участка",
 created_at datetime NOT NULL DEFAULT current_timestamp,
 updated_at datetime NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp,
 FOREIGN KEY (branch_id) REFERENCES branch(id) ON UPDATE CASCADE ON DELETE CASCADE
) comment "описание земельных участков";

CREATE TABLE counterparty(
 id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY comment "идентификатор контрагента",
 name varchar(300) NOT NULL comment "название контрагента",
 `data` json comment "прочие данные о контрагенте"
) comment "описание контрагентов";

CREATE TABLE accounts(
 id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY comment "идентификатор контрагента",
 branch_id int UNSIGNED NOT NULL comment "идентификатор филиала",
 currency bigint NOT NULL DEFAULT 0 comment "количество валюты",
 currency_type varchar(100) NOT NULL comment "тип валюты",
 bank varchar(300) NOT NULL comment "название банка",
 created_at datetime NOT NULL DEFAULT current_timestamp,
 updated_at datetime NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp,
 FOREIGN KEY (branch_id) REFERENCES branch(id) ON UPDATE CASCADE ON DELETE CASCADE
) comment "расчетные счета";

CREATE TABLE contracts (
 id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY comment "идентификатор контракта",
 `number` int UNSIGNED UNIQUE comment "номер контракта",
 counterparty_id int UNSIGNED NOT NULL comment "идентификатор контрагента",
 operation_type varchar(100) NOT NULL comment "тип операции покупка\продажа",
 type_id int UNSIGNED NOT NULL comment "тип товара",
 quantity int UNSIGNED comment "количество единиц товара",
 created_at datetime NOT NULL DEFAULT current_timestamp,
 updated_at datetime NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp,
 FOREIGN KEY (counterparty_id) REFERENCES counterparty(id),
 FOREIGN KEY (type_id) REFERENCES nomenclature(id)
) comment "данные о контрактах";


-- ПРОЦЕДУРА Получает на вход таблицу и искомый тип. Выдает только те айди филиалов в которых есть искомый тип, также айди вида и количество на складе.
DROP PROCEDURE IF EXISTS show_storage;
delimiter //
CREATE PROCEDURE show_storage(tablename varchar(100), need_type varchar(100))
BEGIN 
	CASE tablename
	WHEN 'animalstorages' THEN 
	SELECT branch_id, animal_id, quantity FROM animalstorages WHERE animal_id IN (SELECT id FROM nomenclature WHERE `type` = need_type);
	WHEN 'instrumentsstorages' THEN 
	SELECT branch_id, instrument_id, quantity FROM instrumentsstorages WHERE instrument_id IN (SELECT id FROM nomenclature WHERE `type` = need_type);
	WHEN 'machinerystorages' THEN 
	SELECT branch_id, machinery_id , quantity FROM machinerystorages WHERE machinery_id IN (SELECT id FROM nomenclature WHERE `type` = need_type);
	WHEN 'materialsstorages' THEN 
	SELECT branch_id, material_id , quantity FROM materialsstorages WHERE material_id IN (SELECT id FROM nomenclature WHERE `type` = need_type);
	END CASE;
END //
delimiter ;
