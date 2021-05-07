DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;

USE vk;

CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
  first_name VARCHAR(100) NOT NULL COMMENT "��� ������������",
  last_name VARCHAR(100) NOT NULL COMMENT "������� ������������",
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "�����",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "�������",
  -- ���������� ��� ������� "users" � "profiles". ���� �� ������, � ���, ����� ������ ��������� ������ ������ �����?
  gender CHAR(1) NOT NULL COMMENT "���",
  birthday DATE COMMENT "���� ��������",
  photo_id INT UNSIGNED COMMENT "������ �� �������� ���������� ������������",
  status VARCHAR(30) COMMENT "������� ������",
  city VARCHAR(130) COMMENT "����� ����������",
  country VARCHAR(130) COMMENT "������ ����������",
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������������";  

/* ������� ��� �������.

CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "������ �� ������������", 
  gender CHAR(1) NOT NULL COMMENT "���",
  birthday DATE COMMENT "���� ��������",
  photo_id INT UNSIGNED COMMENT "������ �� �������� ���������� ������������",
  status VARCHAR(30) COMMENT "������� ������",
  city VARCHAR(130) COMMENT "����� ����������",
  country VARCHAR(130) COMMENT "������ ����������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������",
  FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT "�������"; */


CREATE TABLE messages (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
  from_user_id INT UNSIGNED NOT NULL COMMENT "������ �� ����������� ���������",
  to_user_id INT UNSIGNED NOT NULL COMMENT "������ �� ���������� ���������",
  body TEXT NOT NULL COMMENT "����� ���������",
  is_important BOOLEAN COMMENT "������� ��������",
  is_delivered BOOLEAN COMMENT "������� ��������",
  created_at DATETIME DEFAULT NOW() COMMENT "����� �������� ������",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������",
  FOREIGN KEY (from_user_id) REFERENCES users(id),
  FOREIGN KEY (to_user_id) REFERENCES users(id)
) COMMENT "���������";


CREATE TABLE friendship_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "�������� �������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������� ������";


CREATE TABLE friendship (
  user_id INT UNSIGNED NOT NULL COMMENT "������ �� ���������� ��������� ���������",
  friend_id INT UNSIGNED NOT NULL COMMENT "������ �� ���������� ����������� �������",
  status_id INT UNSIGNED NOT NULL COMMENT "������ �� ������ (������� ���������) ���������",
  requested_at DATETIME DEFAULT NOW() COMMENT "����� ����������� ����������� �������",
  confirmed_at DATETIME COMMENT "����� ������������� �����������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������",  
  PRIMARY KEY (user_id, friend_id) COMMENT "��������� ��������� ����",
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (friend_id) REFERENCES users(id),
  FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
) COMMENT "������� ������";


CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� �����",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "�������� ������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"  
) COMMENT "������";


CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "������ �� ������",
  user_id INT UNSIGNED NOT NULL COMMENT "������ �� ������������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������", 
  PRIMARY KEY (community_id, user_id) COMMENT "��������� ��������� ����",
  FOREIGN KEY (community_id) REFERENCES communities(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
) COMMENT "��������� �����, ����� ����� �������������� � ��������";

/* ������� ��� �������.
  
CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "�������� ����",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "���� �����������"; */


CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",
  user_id INT UNSIGNED NOT NULL COMMENT "������ �� ������������, ������� �������� ����",
  filename VARCHAR(255) NOT NULL COMMENT "���� � �����",
  size INT NOT NULL COMMENT "������ �����",
  metadata JSON COMMENT "���������� �����",
  -- ������ ��������� ������� "media_types" ��������� ������������ ������, ������� ��� �����������, ����. ��� �������� ���� �����. ����������� �� � type_name, ��� �������. ������ ������������.
  type_name VARCHAR(255) NOT NULL /*UNIQUE*/ COMMENT "�������� ����",
  -- ������ ������ ������� �� ������� �� ���.
  -- media_type_id INT UNSIGNED NOT NULL COMMENT "������ �� ��� ��������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������",
  FOREIGN KEY (user_id) REFERENCES users(id)
  -- ������ ������ �� ��� ������������� ������� media_types.
  -- FOREIGN KEY (media_type_id) REFERENCES media_types(id)
) COMMENT "����������";



 