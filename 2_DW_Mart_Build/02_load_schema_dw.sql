/* select *
         from read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
         AUTO_DETECT = true) 
         limit 10;
*/


insert into company_dim (company_id, name)
select company_id, name
from read_csv("C:/Users/Lenovo/Downloads/company_dim.csv",
auto_detect = true);


insert into skills_dim ( skill_id, skills, type)
select skill_id, skills, type
from read_csv("C:/Users/Lenovo/Downloads/skills_dim.csv",
auto_detect = true);


insert into job_postings_fact(
    job_id,
company_id,
job_title_short,
job_title,
job_location,
job_via,
job_schedule_type,
job_work_from_home,
search_location,
job_posted_date,
job_no_degree_mention,
job_health_insurance,
job_country,
salary_rate,
salary_year_avg,
salary_hour_avg
) 
select job_id,
company_id,
job_title_short,
job_title,
job_location,
job_via,
job_schedule_type,
job_work_from_home,
search_location,
job_posted_date,
job_no_degree_mention,
job_health_insurance,
job_country,
salary_rate,
salary_year_avg,
salary_hour_avg
from read_csv("C:/Users/Lenovo/Downloads/job_postings_fact.csv",
auto_detect = true);

insert into skills_job_dim(skill_id, job_id)
select skill_id, job_id 
from read_csv("C:/Users/Lenovo/Downloads/skills_job_dim.csv",
auto_detect = true);

