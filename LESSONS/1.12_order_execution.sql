/* find the top ten companies for posting jobs
they must have >3000 postings
*/

select 
    cd.name,
    count(jpf.*)
from job_postings_fact as jpf
left join company_dim as cd
    on jpf.company_id = cd.company_id
group by cd.name;

select 
    cd.name,
    count(jpf.job_id)
from job_postings_fact as jpf
left join company_dim as cd
    on jpf.company_id = cd.company_id
where jpf.job_country = 'United States'
group by cd.name;


select 
    cd.name,
    count(jpf.*)
from job_postings_fact as jpf
left join company_dim as cd
    on jpf.company_id = cd.company_id
where jpf.job_country = 'United States'
group by cd.name
having count(jpf.job_id) >3000;

select 
    cd.name,
    count(jpf.*) as posting_count
from job_postings_fact as jpf
left join company_dim as cd
    on jpf.company_id = cd.company_id
where jpf.job_country = 'United States'
group by cd.name
having count(jpf.job_id) >3000
order by posting_count desc;


--Uisng explain
explain
select 
    cd.name,
    count(jpf.*)
from job_postings_fact as jpf
left join company_dim as cd
    on jpf.company_id = cd.company_id
where jpf.job_country = 'United States'
group by cd.name
having count(jpf.job_id) >3000;


--Usng explain analyze
explain analyze
select 
    cd.name,
    count(jpf.*)
from job_postings_fact as jpf
left join company_dim as cd
    on jpf.company_id = cd.company_id
where jpf.job_country = 'United States'
group by cd.name
having count(jpf.job_id) >3000;