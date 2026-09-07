select *
from
information_schema.columns
where table_name = 'job_postings_fact';

describe job_postings_fact;

DESCRIBE 
select 
    job_title_short,
    salary_year_avg
from 
    job_postings_fact;


select cast(123 as varchar);

select cast('123' as int);

select 
    job_id, 
    job_work_from_home,
    job_posted_date,
    salary_year_avg
from 
    job_postings_fact
limit 10;


-- Converting Boolen to numeric value
select 
cast(job_work_from_home as int) as job_work_from_home
from job_postings_fact
limit 30;


--Convert job_posted_date to date

select
    cast(job_posted_date as date) as job_posted_date
from job_postings_fact
limit 10;

--convert salary_yr_avg to decimal

select cast(salary_year_avg as decimal(10,0)) as salary_year_avg
from job_postings_fact
where salary_year_avg is not null
limit 20;

select 
cast(job_work_from_home as int) as job_work_from_home,
cast(job_posted_date as date) as job_posted_date,
cast(salary_year_avg as decimal(10,0)) as salary_year_avg
from job_postings_fact
where salary_year_avg is not null
limit 20;


select
job_id,
company_id,
cast(job_work_from_home as int) as job_work_from_home,
cast(job_posted_date as date) as job_posted_date,
cast(salary_year_avg as decimal(10,0)) as salary_year_avg
from job_postings_fact
where salary_year_avg is not null
limit 20;

select
cast(job_id as varchar),
cast(company_id as  varchar),
cast(job_work_from_home as int) as job_work_from_home,
cast(job_posted_date as date) as job_posted_date,
cast(salary_year_avg as decimal(10,0)) as salary_year_avg
from job_postings_fact
where salary_year_avg is not null
limit 20;

select
cast(job_id as varchar) || cast(company_id as  varchar),  --Unique Identifier
cast(job_work_from_home as int) as job_work_from_home,
cast(job_posted_date as date) as job_posted_date,
cast(salary_year_avg as decimal(10,0)) as salary_year_avg
from job_postings_fact
where salary_year_avg is not null
limit 20;

select
cast(job_id as varchar)||'-'||cast(company_id as  varchar), --More unique identifier
cast(job_work_from_home as int) as job_work_from_home,
cast(job_posted_date as date) as job_posted_date,
cast(salary_year_avg as decimal(10,0)) as salary_year_avg
from job_postings_fact
where salary_year_avg is not null
limit 20;

select
job_id :: varchar ||'-'|| company_id ::  varchar, --More unique identifier
job_work_from_home :: int as job_work_from_home,
job_posted_date :: date as job_posted_date,
salary_year_avg :: decimal(10,0) as salary_year_avg
from job_postings_fact
where salary_year_avg is not null
limit 20;

select
(2.25 +67) ::float;


select
(2.25 +67) ::int;


