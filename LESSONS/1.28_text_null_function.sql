select length('SQL');

select char_length('SQL');

select lower('SQL');

select upper('sql');

select right('SQL',2);

select left('SQL',2);

select substring('SQL',2,1);

select substring('SQL',2,2);


Select concat('SQL','-','Function');

select 'SQL' || '-' || 'Function';


select ' SQL ';

select trim(' SQL '); 

select replace('SQL','Q','_');   ---learn about REGEXP_REPLACE

---Final Example 
with title_lower as (
    select 
        job_title,
        job_title_short,
        lower(trim(job_title)) as job_title_clean
    from job_postings_fact
)

select
    job_title,
    case 
        when job_title_clean like '%data%' and job_title_clean like '%analyst%'
            then 'Data Analyst'
        when job_title_clean like '%data%' and job_title_clean like '%scientist%'
            then 'Data Scientist'
        when job_title_clean like '%data%' and job_title_clean like '%engineer%'
            then 'Data Engineer'
        else 'Other'
    end as job_title_category,
    job_title_short
    from title_lower  
    limit 30;

--compare to
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
limit 30;


--NULL FUNCTIONS
--- WHEN EXPRESSIONS ARE EQUAL IT WILL RETURN NULL BUT WILL RETURN 1ST EXPRESSION FOR ELSE

select nullif(20,20);
select nullif(20,23);
select nullif(15,20);


--COALESCE --it will show the first non null value
select coalesce(2,null,4);
select coalesce(null, null,3);

select 
    salary_year_avg,
    salary_hour_avg,
    coalesce(salary_year_avg,salary_hour_avg *2080)
from job_postings_fact
where salary_year_avg is not null or salary_hour_avg is not null
limit 10;

select 
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    coalesce(salary_year_avg,salary_hour_avg *2080) as standardized_salary,
case 
    when standardized_salary is null then 'Missing'
    when standardized_salary < 75_000 then 'Low'
    when standardized_salary < 150_000 then 'Mid'
else 'High'
end as salary_bucket 
from job_postings_fact 
order by standardized_salary desc;