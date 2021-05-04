-- create database if not exists example;
use example;
create table if not exists users(id int unsigned not null primary key auto_increment, name varchar(100));