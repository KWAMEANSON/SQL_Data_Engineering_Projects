select
    job_id,
    job_title_short,
    salary_year_avg,
    company_id
from 
    job_postings_fact
limit
    10;


select
    *
from
    company_dim
limit
    10;

select
 *
from
company_dim
where
name in ('Meta', 'Facebook');

select *
from skills_job_dim
limit 5;

select *
from skills_dim
limit 5;


select *
from information_schema.tables;

select *
from information_schema.columns
where table_catalog = 'data_jobs';


select table_name, column_name, data_type
from information_schema.columns
where table_catalog = 'data_jobs';


pragma show_tables;

Describe job_postings_fact;

pragma show_tables_expanded;

describe 
    job_postings_fact;

describe company_dim;

describe company_id

pragma show_tables;


something 564 