-- bucket salaries 
-- < 25 = 'Low'
-- 25 - 50 = 'medium'
-- >50 = 'High' 

select 
    job_title_short,
    salary_hour_avg,
    case 
        when salary_hour_avg < 25 
            then 'Low'
        when salary_hour_avg < 50 
            then 'Medium'
        Else 'High'
    end as salary_category 
from job_postings_fact 
where salary_hour_avg is not null
limit 20;

--Handling Missing Data (NULLS)
-- Filter NULL salary values

select 
    job_title_short,
    salary_hour_avg,
    case 
        when salary_hour_avg < 25 
            then 'Low'
        when salary_hour_avg < 50 
            then 'Medium' 
        when salary_hour_avg is null 
            then 'Missing'
        Else 'High'
    end as salary_category 
from job_postings_fact 
limit 20;


-- Categorizing Categorical Values
-- Classify the 'job_title' column values as:
    -- 'Data Analyst'
    -- 'Data Engineer'
    -- 'Data Scientist'

select 
    job_title,
    case 
        when job_title like '%ata%' and job_title like '%lyst%'
            then 'Data Analyst'
        when job_title like '%ata%' and job_title like '%cien%'
            then 'Data Scientist'
        when job_title like '%ata%' and job_title like '%gineer%'
            then 'Data Engineer'
        else 'Other'
    end as job_category,
    job_title_short
from job_postings_fact
order by random()
limit 20;

-- Conditional Aggregation
-- Calculate Median Salaries for different Buckets
    -- < $100k
    -- >= $100k

select 
    job_title_short,
    count(*) as total_postings,
    median(
        case
            when salary_year_avg < 100_000 then salary_year_avg
        end 
    )as median_low_salary,
    median(
        case 
           when salary_year_avg >= 100_000 then salary_year_avg
        end 
    )as median_high_salary
from job_postings_fact 
where salary_year_avg is not null 
group by job_title_short;

-- Final Example: Conditional Calculations
-- Compute a standardized_salary using yearly salary and adjusted hourly salary ( eg. 2080 hr/yr)
-- Categorize salaries into tiers of;
    -- < 75k 'Low'
    -- 75k - 150k 'Medium'
    -- >= 150k 'High' 

with salaries as (
select 
    job_title_short,
    salary_hour_avg,
    salary_year_avg,
    case
        when salary_year_avg is not null 
            then salary_year_avg
        when salary_hour_avg is not null 
            then salary_hour_avg * 2080
    end as standardized_salary
from job_postings_fact
where salary_year_avg is not null 
    or  
      salary_hour_avg is not null 
)
select *,
    case 
        when standardized_salary < 75_000 then 'Low'
        when standardized_salary < 150_000 then 'Medium'
        else 'High'
    end as salary_bucket
from salaries
order by random()
limit 20;