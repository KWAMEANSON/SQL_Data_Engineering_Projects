---ARRAY : AN ORDERED COLLECTIOIN OF THE SAME TYPE VALUES
select [1,2,3,4];
select ['Python', 'SQL', 'R'] as skills_array;

select 'python' as skill
union all 
select 'R'
union all 
select 'SQL';


with skills as (
    select 'python' as skill
union all 
select 'R'
union all 
select 'SQL'
) select skill from skills;


with skills as (
    select 'python' as skill
union all 
select 'R'
union all 
select 'SQL'
)select array_agg(skill) as skills_array
from skills;


---accessing via an index on the array
with skills as (
    select 'python' as skill
union all 
select 'R'
union all 
select 'SQL'
),skills_array as (
select array_agg(skill) as skills
from skills
) select skills[1] as first_skills 
from skills_array;


---Getting the precise index
with skills as (
    select 'python' as skill
union all 
select 'R'
union all 
select 'SQL'
),skills_array as (
select array_agg(skill order by skills) as skills
from skills
) select skills[1] as first_skill,
skills[2] as second_skill,
skills[3] as third_skill
from skills_array;



---STRUCT :  A composite data type with multiple fields
select {skill: 'python', type: 'programming'} as skill_struct;

select 
    struct_pack(
        skill:= 'python',
        type:= 'programming'
    ) as s;

with skill_struct as (
select 
    struct_pack(
        skill:= 'python',
        type:= 'programming'
    ) as s
) select *
from skill_struct;

--Indexing
with skill_struct as (
select 
    struct_pack(
        skill:= 'python',
        type:= 'programming'
    ) as s
) select s.skill,
s.type
from skill_struct;

--more indexing

select 'python' as skill, 'progamming' as type 
union all 
select 'R', 'programming' 
union all 
select 'SQL', 'query language'; 

with skill_table as (
    select 'python' as skill, 'progamming' as type 
union all 
select 'R', 'programming' 
union all 
select 'SQL', 'query language'
) 
select struct_pack(
    skill := skill,
    type := type
) from skill_table;


---Array of structs
select [
    {skill: 'python', type: 'programming'},
    {skill: 'sql', type: 'query language'},
    {skill: 'R', type: 'programming'}
] as skills_array_of_structs;

--Removing the array agg will give output in different style
with skill_table as (
    select 'python' as skill, 'progamming' as type 
union all 
select 'R', 'programming' 
union all 
select 'SQL', 'query language'
),skill_array_struct as (
select array_agg(
    struct_pack(
        skill := skill,
        type := type)
)
    from skill_table)
select
*
from skill_array_struct;

--- Indexing
with skill_table as (
    select 'python' as skill, 'progamming' as type 
union all 
select 'R', 'programming' 
union all 
select 'SQL', 'query language'
),skill_array_struct as (
select
    struct_pack(
        skill := skill,
        type := type) as strype
    from skill_table )
select
strype.skill,
strype.type
from skill_array_struct;


with skill_table as (
    select 'python' as skill, 'progamming' as type 
union all 
select 'R', 'programming' 
union all 
select 'SQL', 'query language'
),skill_array_struct as (
select array_agg(
    struct_pack(
        skill := skill,
        type := type)
) array_struct
    from skill_table)
select
array_struct[1].skill,
array_struct[2],
array_struct[3].type
from skill_array_struct; 



--- MAP : unordered collection of dynamic key-value pairs
select map {'skill' : 'python', 'type' : 'programming'}; --map keys must be unique

with skill_map as (
    select map {'skill' : 'python', 'type' : 'programming'} as skill_type
 ) select 
    skill_type ['skill']
from 
    skill_map;

with skill_map as (
    select map {'skill' : 'python', 'type' : 'programming'} as skill_type
 ) select 
    skill_type ['skill'],
    skill_type['type']
from 
    skill_map;


---JSON 
select '{"skill":"python", "type":"programming"}'::JSON as skill_json;

with raw_skill_json as (
    select '{"skill":"python", "type":"programming"}'::JSON as skill_json
) select skill_json
    from raw_skill_json;

with raw_skill_json as (
    select '{"skill":"python", "type":"programming"}'::JSON as skill_json
) select 
    struct_pack(
        skill := json_extract_string(skill_json, '$.skill'),
        type := json_extract_string(skill_json, '$.type')
    )
    from raw_skill_json;


--JSON to Array of structs
with raw_json as (
    select 
    '[
    {"skill":"python","type":"programming"},
    {"skill":"SQL","type":"query_language"},
    {"skill":"R","Type":"Programming"}]' :: json as skill_json 
) 
select array_agg(
        struct_pack(
                skill := json_extract_string(e.value, '$.skill'),
                type := json_extract_string(e.value, '$.type')
        )
        order by json_extract_string(e.value, '$.skill')
) as skills 
from raw_json, json_each(skill_json) as e; 



-- Arrays -Final Example
-- Build a flat skill table for co-workers to access job titles, salary info and skills in one table

select
    jpf.job_id,
    jpf.job_title,
    jpf.salary_year_avg,
    sd.skills
from job_postings_fact as jpf 
left join skills_job_dim as sjd 
 on jpf.job_id = sjd.job_id 
left join skills_dim as sd 
 on sd.skill_id = sjd.skill_id;


select
    jpf.job_id,
    jpf.job_title,
    jpf.salary_year_avg,
   array_agg(sd.skills) as skills_array
from job_postings_fact as jpf 
left join skills_job_dim as sjd 
 on jpf.job_id = sjd.job_id 
left join skills_dim as sd 
 on sd.skill_id = sjd.skill_id
 group by all;
 