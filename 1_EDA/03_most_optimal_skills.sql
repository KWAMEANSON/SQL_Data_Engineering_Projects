/* Question: What are the most optimal skills for data engineers - balancing both demand and salary?
 - Create a ranking column that combines demand count and median salary to identify the most
  valauble skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why
  . This approach highlight skills that balance market demand and financial reward.
    It weights core skills appropraitely, rather than letting rare, outlier skills distort
    the result
*/


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


select
sd.skills, 
round(median(jpf.salary_year_avg),2) as median_salary,
count(jpf.salary_year_avg) as corrected_count,
median(jpf.salary_year_avg)*count(jpf.salary_year_avg) as optimal_score
from job_postings_fact as jpf
inner join skills_job_dim as sjd 
 on jpf.job_id = sjd.job_id 
inner join skills_dim as sd 
 on sjd.skill_id = sd.skill_id 
where 
 jpf.job_title_short = 'Data Engineer' and job_location = 'Anywhere'
 and job_work_from_home = TRUE
group by sd.skills
having count(jpf.*) >100
order by optimal_score desc 
limit 20;


select
sd.skills, 
round(median(jpf.salary_year_avg),2) as median_salary,
--count(jpf.*) as corrected_count,
round(LN(count(jpf.*)),1) as ln_demand_count,
round(median(jpf.salary_year_avg)*ln(count(jpf.*))/100_000,1) as optimal_score
from job_postings_fact as jpf
inner join skills_job_dim as sjd 
 on jpf.job_id = sjd.job_id 
inner join skills_dim as sd 
 on sjd.skill_id = sd.skill_id 
where 
 jpf.job_title_short = 'Data Engineer' and job_location = 'Anywhere'
 and job_work_from_home = TRUE
 and jpf.salary_year_avg is not null
group by sd.skills
having count(jpf.*) >100
order by optimal_score desc 
limit 20;

/*
┌────────────┬───────────────┬─────────────────┬─────────────────┬────────────────────┐
│   skills   │ median_salary │ corrected_count │ ln_demand_count │   optimal_score    │
│  varchar   │    double     │      int64      │     double      │       double       │
├────────────┼───────────────┼─────────────────┼─────────────────┼────────────────────┤
│ terraform  │      184000.0 │             193 │             5.3 │            9.68335 │
│ python     │      135000.0 │            1133 │             7.0 │  9.494043000000001 │
│ aws        │     137320.31 │             783 │             6.7 │           9.149835 │
│ sql        │      130000.0 │            1128 │             7.0 │           9.136662 │
│ airflow    │      150000.0 │             386 │             6.0 │  8.933755999999999 │
│ spark      │      140000.0 │             503 │             6.2 │           8.708826 │
│ snowflake  │      135500.0 │             438 │             6.1 │  8.241406999999999 │
│ kafka      │      145000.0 │             292 │             5.7 │           8.231293 │
│ azure      │      128000.0 │             475 │             6.2 │           7.889043 │
│ java       │      135000.0 │             303 │             5.7 │           7.713539 │
│ scala      │     137290.48 │             247 │             5.5 │           7.563866 │
│ kubernetes │      150500.0 │             147 │             5.0 │  7.510600999999999 │
│ git        │      140000.0 │             208 │             5.3 │ 7.4725530000000004 │
│ databricks │      132750.0 │             266 │             5.6 │           7.412091 │
│ redshift   │      130000.0 │             274 │             5.6 │  7.297066999999999 │
│ gcp        │      136000.0 │             196 │             5.3 │           7.178236 │
│ hadoop     │      135000.0 │             198 │             5.3 │            7.13916 │
│ nosql      │      134415.0 │             193 │             5.3 │           7.073845 │
│ pyspark    │      140000.0 │             152 │             5.0 │ 7.0334330000000005 │
│ docker     │      135000.0 │             144 │             5.0 │ 6.7092480000000005 │
└────────────┴───────────────┴─────────────────┴─────────────────┴────────────────────┘
  20 rows                                                                   5 columns
  */