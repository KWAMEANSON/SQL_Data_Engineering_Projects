DROP SCHEMA IF EXISTS skills_mart CASCADE;

CREATE SCHEMA skills_mart;

CREATE TABLE skills_mart.dim_skills (
    skill_id INTEGER PRIMARY KEY,
    skills VARCHAR,
    type VARCHAR
);

INSERT INTO skills_mart.dim_skills (
    skill_id,
    skills,
    type
)
SELECT
    skill_id,
    skills,
    type
FROM skills_dim;

CREATE TABLE skills_mart.dim_date_month (
    month_start_date DATE PRIMARY KEY,
    year INTEGER,
    month INTEGER,
    quarter INTEGER,
    quarter_name VARCHAR,
    year_quarter VARCHAR
);

INSERT INTO skills_mart.dim_date_month (
    month_start_date,
    year,
    month,
    quarter,
    quarter_name,
    year_quarter
)
SELECT DISTINCT
    DATE_TRUNC('month', job_posted_date)::DATE AS month_start_date,
    EXTRACT(year FROM job_posted_date)::INTEGER AS year,
    EXTRACT(month FROM job_posted_date)::INTEGER AS month,
    EXTRACT(quarter FROM job_posted_date)::INTEGER AS quarter,
    'Q-' || EXTRACT(quarter FROM job_posted_date)::INTEGER AS quarter_name,
    EXTRACT(year FROM job_posted_date)::INTEGER
        || '-Q'
        || EXTRACT(quarter FROM job_posted_date)::INTEGER AS year_quarter
FROM job_postings_fact
WHERE job_posted_date IS NOT NULL;

CREATE TABLE skills_mart.fact_skill_demand_monthly (
    skill_id INTEGER,
    month_start_date DATE,
    job_title_short VARCHAR,
    postings_count INTEGER,
    remote_postings_count INTEGER,
    health_insurance_postings_count INTEGER,
    degree_postings_count INTEGER,
    PRIMARY KEY (skill_id, month_start_date, job_title_short),
    FOREIGN KEY (skill_id)
        REFERENCES skills_mart.dim_skills(skill_id),
    FOREIGN KEY (month_start_date)
        REFERENCES skills_mart.dim_date_month(month_start_date)
);

INSERT INTO skills_mart.fact_skill_demand_monthly (
    skill_id,
    month_start_date,
    job_title_short,
    postings_count,
    remote_postings_count,
    health_insurance_postings_count,
    degree_postings_count
)
WITH job_postings_prep AS (
    SELECT
        sjd.skill_id,
        DATE_TRUNC('month', jpf.job_posted_date)::DATE AS month_start_date,
        jpf.job_title_short,
        CASE
            WHEN jpf.job_work_from_home = TRUE THEN 1
            ELSE 0
        END AS is_remote,
        CASE
            WHEN jpf.job_health_insurance = TRUE THEN 1
            ELSE 0
        END AS has_health_insurance,
        CASE
            WHEN jpf.job_no_degree_mention = FALSE THEN 1
            ELSE 0
        END AS degree_mentioned
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    WHERE jpf.job_posted_date IS NOT NULL
)
SELECT
    skill_id,
    month_start_date,
    job_title_short,
    COUNT(*)::INTEGER AS postings_count,
    SUM(is_remote)::INTEGER AS remote_postings_count,
    SUM(has_health_insurance)::INTEGER AS health_insurance_postings_count,
    SUM(degree_mentioned)::INTEGER AS degree_postings_count
FROM job_postings_prep
GROUP BY
    skill_id,
    month_start_date,
    job_title_short;

SELECT
    'Skill Dimension' AS table_name,
    COUNT(*) AS record_count
FROM skills_mart.dim_skills
UNION ALL
SELECT
    'Date Month Dimension',
    COUNT(*)
FROM skills_mart.dim_date_month
UNION ALL
SELECT
    'Skill Demand Fact',
    COUNT(*)
FROM skills_mart.fact_skill_demand_monthly;


select * from skills_mart.dim_skills limit 5 ;
select * from skills_mart.dim_date_month limit 5;
select * from skills_mart.fact_skill_demand_monthly limit 5;


