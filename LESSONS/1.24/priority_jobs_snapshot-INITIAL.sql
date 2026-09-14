-- .read LESSONS\\1.24\\priority_jobs_snapshot-INITIAL.sql

create or replace table main.priority_jobs_snapshots(
    job_id int primary key,
    job_title_short varchar,
    company_name varchar,
    job_posted_date timestamp,
    salary_year_avg double,
    priority_lvl int,
    update_at timestamp
);

insert into main.priority_jobs_snapshots(
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    update_at
)
select
jpf. job_id,
jpf.job_title_short,
cd.name as company_name,
jpf.job_posted_date,
jpf.salary_year_avg,
r.priority_lvl,
current_timestamp
from data_jobs.job_postings_fact as jpf
left join data_jobs.company_dim as cd 
    on  jpf.company_id = cd.company_id 
inner join staging.priority_roles as r 
    on jpf.job_title_short = r.role_name;

select 
    job_title_short,
    count(*) as job_count,
    min(priority_lvl) as priority_lvl,
    min(update_at) as updated_at 
from priority_jobs_snapshots 
group by job_title_short 
order by job_count desc;


