---.read LESSONS/1.21_DDL_DML_Pt1.sql-- for creating idempotenet
drop database if exists job_mart;
drop table if exists staging.preferred_roles;

CREATE DATABASE if not exists job_mart;  ---creating database

show DATABASES;

create database if not exists job_mart; --preventing error

--drop database job_mart;  --deleting database

--drop database if exists job_mart; --preventing error

select *
from information_schema.schemata; --checking schema

---creating a staging schema since main schema for job mart is creating
create schema if not exists job_mart.staging;


use job_mart;  -- to prevent writing always

create schema if not exists staging;

select *
from information_schema.schemata; -- checking if exist

-- drop schema job_mart.staging; --uncomment to run


create table if not exists staging.preferred_roles (  --creating a table in staging
    role_id integer,
    role_name varchar
);


--Checking table

select *
from information_schema.tables
where table_catalog = 'job_mart';


--droping the main one
--drop table if exists main.preferred_roles;

-- Checking dropped table
select *
from information_schema.tables
where table_catalog = 'job_mart';

-- Confirming Job_mart still exist
show databases;
show tables;

/* USING INSERT*/

 --duplication issues
 Insert into staging.preferred_roles (role_id, role_name)
values 
 (1, 'Data Engineer'),
 (2, 'Senior Data Engineer'),
 (3, 'Software Engineer');

select *
 from staging.preferred_roles;

 -- setting primary key to prevent duplication issues
 drop table staging.preferred_roles; --1st drop table
 
 create table if not exists staging.preferred_roles(  -- second create again
    role_id integer primary key,
  role_name varchar);

  --checking table
  select *
  from information_schema.tables
  where table_catalog = 'job_mart';

  --imputing the values thereof
  Insert into staging.preferred_roles (role_id, role_name)
values 
 (1, 'Data Engineer'),
 (2, 'Senior Data Engineer'),
 (3, 'Software Engineer');



---USING ALTER
alter table staging.preferred_roles
add column preferred_roles boolean;

select *
from staging.preferred_roles;

alter table staging.preferred_roles
drop column preferred_roles;

alter table staging.preferred_roles
add column preferred_roles boolean;


--USING UPDATE
update staging.preferred_roles
set preferred_roles = TRUE
where role_id = 1 or role_id = 2;

update staging.preferred_roles
set preferred_roles = FALSE
where role_id = 3;

select *
from staging.preferred_roles;

---USING ALTER
alter table staging.preferred_roles
rename to priority_role;

--select *
--from staging.preferred_roles;---This table name is changed

select *
from staging.priority_role;

--renaming a column
alter table staging.priority_role
rename column preferred_roles to priority_level;

--recoding data type
alter table staging.priority_role
alter column priority_level type  integer;

update staging.priority_role
set priority_level = 3
where role_name = 'Software Engineer';

select *
from staging.priority_role;



