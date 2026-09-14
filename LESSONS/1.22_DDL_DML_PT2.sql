--.read 1.22_DDL_DML_PT2.sql
--- cleaned query: explicitly select job_postings_fact filed and company info

create or replace table  staging.job_postings_flat as
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name AS company_name
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id;



select *
from staging.job_postings_flat
limit 10;

select count(*)
from staging.job_postings_flat;



select 
 jpf.*
from staging.job_postings_flat as jpf
join staging.priority_role as r 
on jpf.job_title_short = r.role_name
where r.priority_level = 1;



create or replace view staging.priority_jobs_flat_view as
select 
 jpf.*
from staging.job_postings_flat as jpf
join staging.priority_role as r 
on jpf.job_title_short = r.role_name
where r.priority_level = 1;


select count(*)
from staging.priority_jobs_flat_view;

select 
    job_title_short,
    count(*) as job_count
from staging.priority_jobs_flat_view
group by job_title_short
order by job_count desc;

----- don't list a schema for temp/temporary
create or replace temporary table senior_jobs_flat_temp as  
select *
from staging.priority_jobs_flat_view
where job_title_short = 'Senior Data Engineer';

select 
    job_title_short,
    count(*) as job_count
from senior_jobs_flat_temp
group by job_title_short
order by job_count desc;


--Looking at each table
select count(*) from staging.job_postings_flat;
select count(*) from staging.priority_jobs_flat_view;
select count(*) from senior_jobs_flat_temp;  --Remember temp has no schema

--Using Delete
Delete from staging.job_postings_flat
where job_posted_date < '2024-01-01';

--Using truncate
/*rerun the tables to get the 1.62 million*/

truncate table staging.job_postings_flat; -- every row is gone

select * from staging.job_postings_flat;  -- but columns name remains

insert into staging.job_postings_flat
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name AS company_name
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
where job_posted_date >= '2024-01-01';



