select unnest([1,1,1,2])
union 
select unnest([1,1,3]);

select unnest([1,1,1,2])
union all
select unnest([1,1,3]);

select unnest([1,1,1,2])
intersect
select unnest([1,1,3]);

select unnest([1,1,1,2])
intersect all
select unnest([1,1,3]);

select unnest([1,1,1,2])
except
select unnest([1,1,3]);

select unnest([1,1,1,2])
except all
select unnest([1,1,3]);

select unnest([1,1,3])
except
select unnest([1,1,1,2]);   


create or replace temp table job_2023 as 
select * exclude (job_id, job_posted_date)
from job_postings_fact 
where extract(year from job_posted_date) = 2023;

select * from job_2023;

create or replace temp table job_2024 as 
select * exclude (job_id, job_posted_date)
from job_postings_fact 
where extract(year from job_posted_date) = 2024;

select * from job_2024; 

-- which unique job postings appeared in either 2023 or 2024?
select * from job_2023
union 
select * from job_2024;

select count(*) from job_2023
union 
select count(*) from job_2024;

-- Which job postings appeared across both years, counting duplicates? 
select * from job_2023 
union all 
select * from job_2024;

-----------------SIMPLIFIED TABLE--------------
select count(*) from job_2023 
union all 
select count(*) from job_2024;

select 'jobs_2023' as table_name,
count(*) from job_2023 
union 
select 'jobs_2024' as table_name,
count(*) from job_2024;

select 'jobs_2023' as table_name,
count(*) from job_2023 
union all
select 'jobs_2024' as table_name,
count(*) from job_2024;

--Which Job posting appeared in 2023 but not in 2024?
select * from job_2023 
except 
select * from job_2024;


--  Which job postings form 2023 remain after subtracting matching 2024 postings, one-for-one?
select * from job_2023 
except all
select * from job_2024;

--- Which job postings appeared in both 2023 and 2024
select * from job_2023 
intersect 
select * from job_2024;

--- Which job postings appeared in both 2023 and 2024, duplicates preserved?
select * from job_2023 
intersect all
select * from job_2024;
