/* Question:  What are the most in-demand skills for data engineers?
 - identify the top 10 in-demand skills for data engineers
 -focus on remote job postings
 - Why?
  . Retrieve the top 10 skills with the highest demand in the remote job market, 
    providing insight into the most valuable skills for
    data engineers seeking remote work.
 */

describe job_postings_fact;

select distinct job_title_short
from job_postings_fact;
   
describe skills_job_dim;

describe skills_dim;

select distinct 
count(job_location)
from job_postings_fact
where job_location = 'Anywhere' and job_title_short = 'Data Engineer';


select 
*
from job_postings_fact as jpf
inner join skills_job_dim as sjd
 on jpf.job_id = sjd.job_id
inner join skills_dim as sd
 on sjd.skill_id = sd.skill_id
limit 10;

select 
 sd.skills,
 count(jpf.*) as demand_count
from job_postings_fact as jpf
inner join skills_job_dim as sjd
 on jpf.job_id = sjd.job_id
inner join skills_dim as sd
 on sjd.skill_id = sd.skill_id
where jpf.job_location = 'Anywhere' and
      jpf.job_work_from_home = TRUE and job_title_short = 'Data Engineer'
group by 
    sd,skills
order by 
    demand_count desc
limit 10;

/*

┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │        29221 │
│ python     │        28776 │
│ aws        │        17823 │
│ azure      │        14143 │
│ spark      │        12799 │
│ airflow    │         9996 │
│ snowflake  │         8639 │
│ databricks │         8183 │
│ java       │         7267 │
│ gcp        │         6446 │
└────────────┴──────────────┘
  10 rows         2 columns
*/

