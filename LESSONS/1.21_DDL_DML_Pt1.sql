CREATE DATABASE job_mart;  ---creating database

show DATABASES;

create database if not exists job_mart; --preventing error

drop database job_mart;  --deleting database

drop database if exists job_mart; --preventing error

select *
from information_schema.schemata; --checking schema

---creating a staging schema since main schema for job mart is creating
create schema job_mart.staging;


use job_mart;  -- to prevent writing always

create schema if not exists staging;

select *
from information_schema.schemata; -- checking if exist

-- drop schema job_mart.staging; --uncomment to run


create table staging.preferred_roles (  --creating a table
    role_id integer,
    role_name varchar
);


--Checking

select *
from information_schema.tables
where table_catalog = 'job_mart';