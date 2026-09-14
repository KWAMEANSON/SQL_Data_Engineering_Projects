select 
    job_posted_date,
    job_posted_date :: Date as date,
    job_posted_date :: Time as time,
    job_posted_date :: Timestamp as timestamp,
    job_posted_date :: Timestamptz as timestampz
from 
    job_postings_fact
limit 10;

select 
    job_posted_date,
    extract(year from job_posted_date) as job_posted_year
from job_postings_fact
limit 10;
-- You can extract day and month from tampstamp

select 
    extract( year from job_posted_date) as job_posted_year,
    extract( month from job_posted_date) as job_posted_month,
    count(job_id) as job_count
from job_postings_fact
where job_title_short = 'Data Engineer'
group by 
    extract( year from job_posted_date),
    extract( month from job_posted_date)
order by 
    job_posted_year,
    job_posted_month;

-- You can use trunc date and at time zone

select
    '2026-01-01 00:00:00+00' :: Timestamptz at time zone 'EST';

select 
    job_posted_date 
from    
    job_postings_fact
limit 10;

select 
    job_posted_date at time zone 'UTC' at time zone 'EST' 
from 
    job_postings_fact
limit 10;

select 
job_title_short,
job_location,
    job_posted_date at time zone 'UTC' at time zone 'EST' 
from 
    job_postings_fact
where job_location like 'New York, NY';


select 
job_title_short,
job_location,
    job_posted_date at time zone 'UTC' at time zone 'EST' 
from 
    job_postings_fact
where job_location like 'New York, NY';
limit 10;

select 
    extract(hour from job_posted_date at time zone 'UTC') as job_posted_hour,
    count(job_id)
from 
    job_postings_fact
where job_location like 'Ghana'
group by 
    job_posted_hour
order by 
    job_posted_hour;
