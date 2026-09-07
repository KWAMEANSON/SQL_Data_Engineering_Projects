/* Question : What are the highest-paying skills for data engineers?
 - calculate the median salary for each skill required in data engineer positions
 - focus on remote positions with specified salaries
 - include skill frequency to identify both salary and demand
 - why?
   . help identify which skills comand the highest compensation
     while also showing how common those skills are, providing a more complete
     picture for skill development priorities.
    
   . The median is used instead of the average to reduce the impact of outlier salaries.
   */

describe job_postings_fact;
describe skills_dim;
describe skills_job_dim;

select
sd.skills, 
count(jpf.job_location) as demand_count,
median (jpf.salary_year_avg) as median_salary,
round(median_salary, 2) as Rounded_Median_Salary
from job_postings_fact as jpf
inner join skills_job_dim as sjd 
 on jpf.job_id = sjd.job_id 
inner join skills_dim as sd 
 on sjd.skill_id = sd.skill_id 
where 
 jpf.job_title_short = 'Data Engineer' and job_location = 'Anywhere'
 and job_work_from_home = TRUE
group by sd.skills
having demand_count >100
order by Rounded_Median_Salary desc 
limit 20;

/*
┌────────────┬──────────────┬───────────────┬───────────────────────┐
│   skills   │ demand_count │ median_salary │ Rounded_Median_Salary │
│  varchar   │    int64     │    double     │        double         │
├────────────┼──────────────┼───────────────┼───────────────────────┤
│ rust       │          232 │      210000.0 │              210000.0 │
│ terraform  │         3248 │      184000.0 │              184000.0 │
│ golang     │          912 │      184000.0 │              184000.0 │
│ spring     │          364 │      175500.0 │              175500.0 │
│ neo4j      │          277 │      170000.0 │              170000.0 │
│ gdpr       │          582 │      169615.5 │              169615.5 │
│ zoom       │          127 │      168437.5 │              168437.5 │
│ graphql    │          445 │      167500.0 │              167500.0 │
│ mongo      │          265 │      162250.0 │              162250.0 │
│ fastapi    │          204 │      157500.0 │              157500.0 │
│ django     │          265 │      155000.0 │              155000.0 │
│ bitbucket  │          478 │      155000.0 │              155000.0 │
│ crystal    │          129 │      154223.5 │              154223.5 │
│ c          │          444 │      151500.0 │              151500.0 │
│ atlassian  │          249 │      151500.0 │              151500.0 │
│ typescript │          388 │      151000.0 │              151000.0 │
│ kubernetes │         4202 │      150500.0 │              150500.0 │
│ css        │          262 │      150000.0 │              150000.0 │
│ node       │          179 │      150000.0 │              150000.0 │
│ ruby       │          736 │      150000.0 │              150000.0 │
└────────────┴──────────────┴───────────────┴───────────────────────┘
  20 rows                                                 4 columns
  */