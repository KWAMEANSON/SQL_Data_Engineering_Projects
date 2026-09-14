--Subquery is a query inside another query

select *
from (
    select *
    from job_postings_fact
    where salary_year_avg is not null
      or salary_hour_avg is not null
);

--CTE
with valid_salaries as(
    select *
    from job_postings_fact
    where salary_year_avg is not null
      or salary_hour_avg is not null
)
select *
from valid_salaries;

---Moving deeper into Subqueries

-- Scenario 1 - subquery in select statement
--- show each job's salary next to the overall market median
select 
job_title_short,
( 
    select median(salary_year_avg)
    from job_postings_fact
)as market_median_salary
from job_postings_fact
limit 10;

----NOTICE THE DIFFERENCE
select 
job_title_short,
median(salary_year_avg) as job_median_salary
from job_postings_fact
group by job_title_short
limit 10;

-----THIS TOO
select 
job_title_short,
median(salary_year_avg) as job_median_salary,
(
    select median(salary_year_avg)
    from job_postings_fact
)as market_median_salary
from job_postings_fact
group by job_title_short
limit 10;

---THIS ANSWERS THE QUESTION
select 
job_title_short,
salary_year_avg,
(
    select median(salary_year_avg)
    from job_postings_fact
)as market_median_salary
from job_postings_fact
where salary_year_avg is not null
limit 10;

-- SCENARIO 2 -SUBQUERY IN FROM
/*Stage only jobs that are remote before aggregating to determine
   the remote median salary per job */
select
job_title_short,
median(salary_year_avg) as job_median_salary,
(
    select median(salary_year_avg)
    from job_postings_fact
    where job_work_from_home =TRUE
)as market_remote_median_salary
from (
    select
        job_title_short,
        salary_year_avg
        from job_postings_fact
        where job_work_from_home = TRUE 
) as clean_jobs
group by job_title_short
limit 10;

--SCENARIO 3 -SUBQUERY IN HAVING
---Keep only job titles whose median salary is above the overall median:

select
job_title_short,
median(salary_year_avg) as job_median_salary,
(
    select median(salary_year_avg)
    from job_postings_fact
    where job_work_from_home =TRUE
)as market_remote_median_salary
from (
    select
        job_title_short,
        salary_year_avg
        from job_postings_fact
        where job_work_from_home = TRUE 
) as clean_jobs
group by job_title_short
having median(salary_year_avg) > market_remote_median_salary
limit 10;



-- CTE eg.
--- Compare how much more (or less) remote roles pay compared to onsite roles for each job title.
---Use CTE to calculate the median salary by title and work arrangement, then compare those medians.

with title_median as (
    select 
        job_title_short,
        job_work_from_home,
        median(salary_year_avg):: int as median_salary
    from job_postings_fact
    where job_country = 'United States'
    group by 
    job_title_short,
    job_work_from_home
)

select
 r.job_title_short,
 r.median_salary as remote_median_salary,
 o.median_salary as onsite_median_salary,
 (r.median_salary - o.median_salary) as remote_premium
 from 
    title_median as r
inner join title_median as o
    on r.job_title_short = o.job_title_short
where r.job_work_from_home = TRUE
    AND o.job_work_from_home = FALSE
order by remote_premium desc;


select *
from range(3) as src(key);

select *
from range(2) as tgt(key);

select *
from range(3) as src(key)
where exists (
    select 1
    from range(2) as tgt(key)
    where tgt.key = src.key
);

--You can use anything implace of 1
select *
from range(3) as src(key)
where not exists (
    select 1
    from range(2) as tgt(key)
    where tgt.key = src.key
);


-- Final Example
-- Identify job postings that have no associated skill before loading them into data mart
select *
    from job_postings_fact
order by job_id 
limit 10;

select *
from skills_job_dim
order by job_id 
limit 40;

select *
    from job_postings_fact as tgt
    where not exists (
        select *
        from skills_job_dim as src
        where tgt.job_id = src.job_id
    )
order by job_id;

select *
    from job_postings_fact as tgt
    where exists (
        select *
        from skills_job_dim as src
        where tgt.job_id = src.job_id
    )
order by job_id;