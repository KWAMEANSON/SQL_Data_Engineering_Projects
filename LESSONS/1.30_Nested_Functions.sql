--Array Intro
select ['Python', 'Sql', 'r'] as skills_array;

select 'python' as skill 
union all 
select 'sql' 
union all 
select 'r';

with skills as (
    select 'python' as skill 
union all 
select 'sql' 
union all 
select 'r'
) 
select skill
from skills; 

with skills as (
    select 'python' as skill 
union all 
select 'sql' 
union all 
select 'r'
) 
select array_agg(skill) as skills_array
from skills;

--using list
with skills as (
    select 'python' as skill 
union all 
select 'sql' 
union all 
select 'r'
) 
select list(skill) as skills_array
from skills;


with skills as (
    select 'python' as skill 
union all 
select 'sql' 
union all 
select 'r'
), skills_array as (
    select array_agg(skill) as skills
from skills
)
select skills 
from skills_array;



---Accessing array using index
-----order is not specified problem
with skills as (
    select 'python' as skill 
union all 
select 'sql' 
union all 
select 'r'
), skills_array as (
    select array_agg(skill) as skills
from skills
)
select skills[1] as skills
from skills_array;


---specifying a consistent order for the index
with skills as (
    select 'python' as skill 
union all 
select 'sql' 
union all 
select 'r'
), skills_array as (
    select array_agg(skill order by skill) as skills
from skills
)
select 
 skills[1] as first_skill,
 skills[2] as second_skill,
 skills[3] as third_skill
from skills_array;


--Struct 
select { skills: 'python', type: 'programming'} as skill_struct;

select 
    struct_pack(
        skill := 'python',
        type := 'programming'
    ) as s; 

with skill_struct as(
select 
    struct_pack(
        skill := 'python',
        type := 'programming'
    ) as s
)
select 
* 
from skill_struct;

---Indexing
with skill_struct as(
select 
    struct_pack(
        skill := 'python',
        type := 'programming'
    ) as s
)
select 
s.skill,
s.type
from skill_struct;



select 'python' as skill, 'programming' as type
union all 
select 'sql', 'query language'
union all 
select 'r', 'programming';

with skill_table as (
    select 'python' as skills, 'programming' as types
union all 
select 'sql', 'query language'
union all 
select 'r', 'programming'
) 
select 
    struct_pack(
        skill := skills,
        type := types
    )
from skill_table;



---Array of structs 
select [
    { skill: 'python', type: 'programming'},
    {skill: 'sql', type: 'query_language'}
] as skills_array_of_structs;


with skill_table as (
    select 'python' as skills, 'programming' as types
union all 
select 'sql', 'query language'
union all 
select 'r', 'programming'
) 
select
array_agg(
    struct_pack(
        skill := skills,
        type := types
    )
)
from skill_table;

with skill_table as (
    select 'python' as skills, 'programming' as types
union all 
select 'sql', 'query language'
union all 
select 'r', 'programming'
), skill_array_struct as (
select
array_agg(
    struct_pack(
        skill := skills,
        type := types
    )
) 
from skill_table
) 
select *
from skill_array_struct;


with skill_table as (
    select 'python' as skills, 'programming' as types
union all 
select 'sql', 'query language'
union all 
select 'r', 'programming'
), skill_array_struct as (
select
array_agg(
    struct_pack(
        skill := skills,
        type := types
    )
) array_struct
from skill_table
) 
select
    array_struct[1],
    array_struct[2],
    array_struct[3]
    from skill_array_struct;


with skill_table as (
select 'python' as skills, 'programming' as types
union all 
select 'sql', 'query language'
union all 
select 'r', 'programming'
), skill_array_struct as (
select
array_agg(
    struct_pack(
        skill := skills,
        type := types
    )
) array_struct
from skill_table
) 
select
    array_struct[1].skill,
    array_struct[2].type,
    array_struct[3]
    from skill_array_struct;

---MAP   -- A map does not take duplicate key and all key must be a string form.
select map{'skill' : 'Python',
'type' : 'Programming'};

with skill_map as(
select map{'skill' : 'Python',
'type' : 'Programming'} as skill_type 
) 
select *
from skill_map;


with skill_map as(
select map{'skill' : 'Python',
'type' : 'Programming'} as skill_type 
) 
select skill_type['skill'], 
        skill_type['type']
from 
    skill_map;


-- JSON
select 
    '{"skill":"python", "type":"programming"}' :: json as skill_json;

select 
    to_json('{"skill":"python", "type":"programming"}') as skill_json;

with raw_skill_json as (
    select 
        '{"skill":"python","type":"programming"}'::json as skill_json 
) 
    select 
        struct_pack(
            skill := json_extract_string(skill_json, '$.skill'),
            type := json_extract_string(skill_json, '$.type')
        )
from raw_skill_json;

with raw_json as (
    select 
    '[
    {"skill":"python","type":"programming"},
    {"skill":"sql","type":"query_language"},
    {"skill":"r","type":"programming"}]' :: json as skills_json
) 
select 
    array_agg(
        struct_pack(
            skill := json_extract_string(e.value, '$.skill'),
            type := json_extract_string(e.value, '$.type')
        ) 
            order by json_extract_string(e.value, '$.skill')
    ) as skills 
    from raw_json, json_each(skills_json) as e;


-- Arrays - Final Example
-- Build a flat skill table for co-worker to access job titles, salary info, skills in one table

create or replace temp table job_skills_array as 
select 
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    array_agg(sd.skills) as skills_array 
from job_postings_fact as jpf 
left join skills_job_dim as sjd 
    on jpf.job_id = sjd.job_id 
left join skills_dim as sd 
    on sd.skill_id = sjd.skill_id 
group by all; 


-- From the perspective of a data analyst, analyze the median salary per skill
with flat_skills as (
select 
    job_id,
    job_title_short,
    salary_year_avg,
    unnest(skills_array) as skill 
from job_skills_array 
) select 
    skill,
    median(salary_year_avg) as median_salary 
from flat_skills
group by skill 
order by median_salary desc;


select 
job_id,
job_title_short,
salary_year_avg,
unnest(skills_type).skill_type as skill_type,
unnest(skills_type).skill_name as skill_name
from  
    job_skills_array;




-- ar