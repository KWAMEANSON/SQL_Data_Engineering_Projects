-- COUNT ROWS - Aggregation Only
select count(*)
from job_postings_fact;

--Count rows - window function
select 
job_id,
count(*) over ()
from job_postings_fact;


--Partition By --Find hourly salary
select 
job_id,
job_title_short,
salary_hour_avg,
avg(salary_hour_avg) over (
    partition by job_title_short
)
from job_postings_fact
order by random() 
limit 10;

select 
job_id,
job_title_short,
salary_hour_avg,
avg(salary_hour_avg) over (
    partition by job_title_short, company_id
)
from job_postings_fact
where salary_hour_avg is not null 
order by random() 
limit 10;

-- Ranking hourly salary
select 
job_id,
job_title_short,
salary_hour_avg,
rank() over (
    order by salary_hour_avg desc
) as rank_hourly_salary
from job_postings_fact
where salary_hour_avg is not null 
order by salary_hour_avg desc 
limit 10;


---Partition by and Order by --Running Average Hourly Salary
select 
job_posted_date,
job_title_short,
salary_hour_avg,
avg(salary_hour_avg) over (
    partition by job_title_short
    order by job_posted_date
) as cummulative_avg_hourly_by_title
from job_postings_fact
where salary_hour_avg is not null 
order by job_title_short,
        job_posted_date
limit 10;

--- Partition By & Order by - Ranking by job_title_short
select 
job_id,
job_title_short,
salary_hour_avg,
rank() over (
    -- partition by job_title_short 
    order by salary_hour_avg desc
) as rank_hourly_salary
from job_postings_fact
where salary_hour_avg is not null 
order by 
    salary_hour_avg desc,
    job_title_short
limit 10;

-- Ranking functions - Rank() vs Dense_Rank
select 
job_id,
job_title_short,
salary_hour_avg,
rank() over (
    -- partition by job_title_short 
    order by salary_hour_avg desc
) as rank_hourly_salary
from job_postings_fact
where salary_hour_avg is not null 
order by 
    salary_hour_avg desc,
    job_title_short
limit 140;


select 
job_id,
job_title_short,
salary_hour_avg,
dense_rank() over (
    -- partition by job_title_short 
    order by salary_hour_avg desc
) as rank_hourly_salary
from job_postings_fact
where salary_hour_avg is not null 
order by 
    salary_hour_avg desc,
    job_title_short
limit 140;


--Row_number() - Providing a new job_id
select 
    *
from job_postings_fact
order by job_posted_date
limit 20;

select 
    *,
    Row_number() over(
        order by job_posted_date
    )
from job_postings_fact
order by job_posted_date
limit 20;


-- LAG() - Time based comaparison of comapny yearly salary
select
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    lag(salary_year_avg) over(
        partition by company_id 
        order by job_posted_date 
    ) as previous_postings_salary 
from 
    job_postings_fact 
where salary_year_avg is not null 
order by company_id, job_posted_date 
limit 60;


select
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    lag(salary_year_avg) over(
        partition by company_id 
        order by job_posted_date 
    ) as previous_postings_salary,
    (salary_year_avg - previous_postings_salary) as Salary_Change
from 
    job_postings_fact 
where salary_year_avg is not null 
order by company_id, job_posted_date 
limit 60;

---LEAD() does the opposite of LAG()