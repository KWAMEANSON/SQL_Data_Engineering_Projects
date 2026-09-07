select
jpf.*,
cd.*
from
    job_postings_fact as jpf 
left join company_dim as cd 
    on jpf.company_id = cd.company_id 
limit 10;


select
    jpf.job_id,
    jpf.job_title_short,
    cd.name as company_name,
    cd.company_id,
    jpf.job_location
from
    job_postings_fact as jpf 
left join company_dim as cd 
    on jpf.company_id = cd.company_id 
limit 10;


select
    jpf.job_id,
    jpf.job_title_short,
    cd.name as company_name,
    cd.company_id,
    jpf.job_location
from
    job_postings_fact as jpf 
left join company_dim as cd 
    on jpf.company_id = cd.company_id 
;

select
    jpf.job_id,
    jpf.job_title_short,
    cd.name as company_name,
    cd.company_id,
    jpf.job_location
from
    job_postings_fact as jpf 
right join company_dim as cd 
    on jpf.company_id = cd.company_id 
limit 10;


select
    jpf.job_id,
    jpf.job_title_short,
    cd.name as company_name,
    cd.company_id,
    jpf.job_location
from
    job_postings_fact as jpf 
inner join company_dim as cd 
    on jpf.company_id = cd.company_id 
;






select *
from information_schema.tables;
where table_catalog = 'data_job'

select
    jpf.*,
    cd.*
from
    job_postings_fact as jpf
left join company_dim as cd
    on jpf.company_id = cd.company_id
    limit 10;


select
*
from
job_postings_fact
limit 5;


describe company_dim;
describe job_postings_fact;

select 
    jpf.job_id,
    jpf.company_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name,
    jpf.job_location
from  job_postings_fact as jpf
left join company_dim as cd
on jpf.company_id = cd.company_id
limit 10;


select count(*)
from job_postings_fact;

select 
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name,
    jpf.job_location
from  job_postings_fact as jpf
right join company_dim as cd
on jpf.company_id = cd.company_id;

select 
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name,
    jpf.job_location
from  job_postings_fact as jpf
inner join company_dim as cd
on jpf.company_id = cd.company_id;


select 
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name,
    jpf.job_location
from  job_postings_fact as jpf
full join company_dim as cd
on jpf.company_id = cd.company_id;



describe skills_dim;
describe skills_job_dim;


select 
jpf.job_id,
jpf.job_title_short,
sjd.skill_id,
--sd.skills
from job_postings_fact as jpf
left join skills_job_dim as sjd
on jpf.job_id = sjd.job_id 
limit 10;


select 
 jpf.job_id,
 jpf.job_title_short,
 sjd.skill_id,
 sd.skills 
from
 job_postings_fact as jpf
left join skills_job_dim as sjd 
 on jpf.job_id = sjd.job_id
left join skills_dim as sd 
 on sjd.skill_id = sd.skill_id
limit 10;


