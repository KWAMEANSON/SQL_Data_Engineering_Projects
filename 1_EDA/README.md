# Exploratory Data Analysis w/ SQL: Job Market Analysis  

![Alt Text](/images/1_1_Project1_EDA.png)

A SQL project analyzing the data engineer job
market using real world job postings data. It demonstrate my ability to **write production-quality analystical SQL, design efficient queries, and turn business questions into data-driven insight**.  

## Executive Summary  
 - ✅ **Project scope:** Built **3 analytical queries** that answer key questions about the data engineer job market.  
 - ✅ **Data Modelling:** Used **multi-table joins**
 across fact and dimension tables to extract insights  
 - ✅ **Analyticals:** Applied **aggregations, filtering, and sorting** to find top skills by demand, salary, and overall value  
 - ✅ **Outcome:** Delivered **actionable insight** on SQL/Python dominance, cloud trends and salary patterns   

 If you only have a minute, review these:  
 1. [Top Demanded Skills Query](/1_EDA/01_top_demanded_skills.sql)  
 2. [Top Paying Skills For Data Engineers](1_EDA\02_top_paying_skills.sql)  
 3. [Optimal Skills For Data Engineers](1_EDA\03_most_optimal_skills.sql)  

 
## Problem $ Context  
 Job market analyst need to answer questions like:

- **Most in-demand:** *Which skills are most in-demand for data engineers?*  
- **Highest paid:** *Which skills command the highest salaries?*  
- **Best trade-off:** *what is the optimal skill set balancing demand and compensation?* 

This project analyses a **data warehouse built using a star schema design. The warehouse structure consist of**:  
![Data Warehouse](/images\1_2_Data_Warehouse.png)  

- **Fact Table:** `Job_Postings_fact` - Central table containing job postings detals (job titles, locations, salaries, dates, etc.)
- **Dimension Tables:**  

  - `Company_dim` - Company information linked to job postings
  - `skills_dim` - Skills catalog with skill names and types

- **Bridge Table:** `Skills_job_dim` - Resolves the many-to-many relationship between job postings and skills  

By querying across these interconnected tables, I extracted insights about skill demand, salary patterns, and optimal skill combinations for data engineering roles.
## Tech Stack 
- **Query Engine:** Duckdb for fast OLAP-style analytical queries  
- **Language:** SQL (ANSI-style with analytical functions)  
- **Data Model:** Star schema with fact + dimensions + bridge tables  
- **Development:** VS Code for SQL editing + Terminal for Duckdb CLI  
- **Version Control:** Git/Github for versioned SQL scripts
## Analysis Overview  
###  Query Structure 
1. **[Top Demanded Skills Query](/1_EDA/01_top_demanded_skills.sql)** - Identifies the top most in-demand skills for remote data engineer positions  
2. **[Top Paying Skills For Data Engineers](1_EDA\02_top_paying_skills.sql)** - Analyze the 25 highest-paying skills with salary and demand metrics  
3. **[Optimal Skills For Data Engineers](1_EDA\03_most_optimal_skills.sql)** - Calculates an optimal score using natural log of demand combined with median salary to identify the most valuable skills to learn  

### Key Insights
- Core languages: SQL and Python each appear in ~29,000 job postings, making them the most demanded skills 
- Cloud Platforms: AWS and Azure are critical for modern data engineering roles  
- Infra & tooling: Kubernetes, Docker, and Terraform are associated with premium salaries  
- Big data tools: Apache Spark shows strong demand with competitive compensation
## SQL Skills Demonstration  
### Query Design & Optimization  
- **Complex Joins:** Multi-table `INNER JOIN` opeartions across `Job_postings_fact`, `Skills_job_dim` and `Skills_dim`  
- **Aggregations:** Boolen logic with `WHERE` clauses and multiple conditions
(`Job_title_short`, `Job_work_from_home`, `salary_year_avg IS NOT NULL`)  
- **Sorting & Limiting:** `ORDER BY` with `DESC` and `LIMIT` for top-N analysis



