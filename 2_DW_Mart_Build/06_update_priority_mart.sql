--Step 6 : Mart - Update Priority roles mart

--Update Data Engineer to Priority 1
update priority_mart.priority_roles 
set priority_lvl = 1
where role_name = 'Data Engineer';

-- Add Data Scientist as level 3
insert into priority_mart.priority_roles(role_id, role_name, priority_lvl)
values (4, 'Data Scientist', 3);

select*from priority_mart.priority_roles;


-- .read LESSONS/1.24/priority_jobs_snapshot.sql
--- Create temp table 
create or replace temp table src_priority_jobs as 
select
jpf. job_id,
jpf.job_title_short,
cd.name as company_name,
jpf.job_posted_date,
jpf.salary_year_avg,
r.priority_lvl,
current_timestamp as update_at
from 
    job_postings_fact as jpf
left join company_dim as cd 
    on  jpf.company_id = cd.company_id 
inner join priority_mart.priority_roles as r 
    on jpf.job_title_short = r.role_name;




--MERGE INTO
merge into priority_mart.priority_jobs_snapshots as tgt
using src_priority_jobs as src 
on tgt.job_id = src.job_id 

when matched and tgt.priority_lvl is distinct from src.priority_lvl 
    then
        update set 
            priority_lvl = src.priority_lvl,
            update_at = src.update_at

when not matched then 
    insert(
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    update_at
)
values (
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.update_at )

when not matched by source then delete;


--Final query check

select 
    job_title_short,
    count(*) as job_count,
    min(priority_lvl) as priority_lvl,
    min(update_at) as updated_at 
from priority_mart.priority_jobs_snapshots 
group by job_title_short 
order by job_count desc;