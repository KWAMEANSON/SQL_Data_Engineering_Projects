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