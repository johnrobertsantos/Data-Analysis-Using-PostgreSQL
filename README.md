# Data Analysis Using SQL

## Overview
Hey there, everybody! This project is about the analysis of data that regards to the job postings of data science jobs all over the world. I aim to analyze any trends and uncover findings in the dataset with the use of an infamous data analysis programming language, SQL! In this particular project, I will be using a relational database management system (RDBMS) called PostreSQL. Do note that the data that will be used here are all gathered on 2023, which is still fairly fresh in my opinion. Without further a do, let's get started!

## Objectives
The main objectives of this project would be simple, to get most of the relevant information out of the dataset we have that are beneficial for those who seek to land data science jobs. To be specific, we broke down these relevant information to the following:

  1. **Identify the Top-Paying Job Postings:** Analyze the dataset to determine which job listings offer the highest salaries over the entire year, providing insights into the most lucrative job opportunities.
  2. **Determine the Skills Required for High-Paying Jobs:** Investigate the job listings with the highest salaries to identify the specific skills or qualifications most frequently associated with these well-paid positions.
  3. **Identify the Most In-Demand Skills:** Analyze the dataset to find out which skills are most frequently requested across all job postings, revealing trends in demand within the job market.
  4. **Analyze Skills Associated with the Highest Salaries:** Assess which specific skills tend to command the highest salaries, helping to correlate particular skills with higher earning potential.
  5. **Recommend Optimal Skills for Data Analysts:** Based on the analysis of salaries and skill demand, identify the key skills that aspiring or current data analysts should focus on to maximize their marketability and earning potential.
     
# Output
## Objective #1
### SQL Query
To identify which are top paid job offers for the year, this is the query I wrote.
```sql
SELECT
    company_dim.name AS company_name,
    job_postings_fact.job_title AS position,
    job_postings_fact.job_country AS job_location,
    job_postings_fact.job_posted_date::DATE AS date_posted,
    job_postings_fact.salary_year_avg AS average_salary
FROM job_postings_fact
LEFT JOIN company_dim 
ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```
To break it down, I first selected the relevant columns for the nature of the job such as the position you'll be applying for, the company itself, and the salary they offer. I also stated in the WHERE clause that it must be job postings for Data Analysts only, and salary offerings must be discrete.

### Results

| Company Name                        | Position                                                     | Job Location      | Date Posted | Average Salary ($) |
|-------------------------------------|-------------------------------------------------------------|-------------------|-------------|----------------|
| Mantys                              | Data Analyst                                                | India             | 2023-02-20  | 650,000       |
| ЛАНИТ                               | Data Base Administrator                                      | Belarus           | 2023-10-03  | 400,000       |
| Torc Robotics                       | Director of Safety Data Analysis                            | United States     | 2023-04-21  | 375,000       |
| Illuminate Mission Solutions        | Sr Data Analyst                                            | United States     | 2023-04-05  | 375,000       |
| Citigroup, Inc                     | Head of Infrastructure Management & Data Analytics - Financial | United States | 2023-07-03  | 375,000       |
| Illuminate Mission Solutions        | HC Data Analyst, Senior                                     | United States     | 2023-08-18  | 375,000       |
| Anthropic                           | Data Analyst                                                | United States     | 2023-06-22  | 350,000       |
| Care.com                            | Head of Data Analytics                                      | United States     | 2023-10-23  | 350,000       |
| Meta                                | Director of Analytics                                       | United States     | 2023-08-23  | 336,500       |
| OpenAI                              | Research Scientist                                          | United States     | 2023-04-19  | 285,000       |

### Analysis
  1. The highest-paying job listed is the Data Analyst position at Mantys, with an average salary of 650,000.0. This salary significantly exceeds all other positions in the dataset, indicating a premium for this role, possibly due to specialized skills or high demand in the industry.
  2. The average salaries for the next several positions are clustered between $285,000 and $400,000. Notably, several positions, including Director of Safety Data Analysis and various senior analyst roles, show an average salary of $375,000, suggesting a competitive market for senior-level analytics roles.
  3. The majority of job postings are located in the United States (7 out of 10). This concentration indicates a robust market for analytics and data-related positions in the U.S., suggesting a potential focus area for job seekers.
  4. The table includes a mix of roles beyond just Data Analysts, such as Data Base Administrator, Director of Analytics, and Research Scientist. This variety showcases the different paths within the data and analytics field, highlighting the importance of specialized skills across these roles.
  5. While the specific skills required for each position are not listed in the table, the variety of job titles suggests a demand for skills related to data analysis, data management, and analytics strategy. Roles like Head of Data Analytics and Director of Analytics imply leadership skills in addition to technical expertise.
  6. The presence of titles like Director of Safety Data Analysis and Head of Infrastructure Management & Data Analytics points towards growing sectors within analytics, such as safety and infrastructure, which may indicate shifting industry needs or emerging trends in data utilization.

## Objective #2
### SQL Query
To determine which skills are demanded for the top paying job postings for data analysts, I wrote this query.
```sql
WITH highest_paid_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE 
        job_title_short = 'Data Analyst' 
    ORDER BY salary_year_avg desc NULLS LAST
    LIMIT 1000
)

SELECT 
    skills_dim.skills,
    count(*) AS skill_demand
FROM highest_paid_jobs
INNER JOIN skills_job_dim 
ON highest_paid_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills_dim.skills
ORDER BY count(*) DESC
LIMIT 5;
```
To break it down, I used a CTE (Common Table Expression) for this query to first narrow down the top 1000 job postings for data analysts ordered by their salary offerings. It is noted that I filtered out those job postings that don't have salary offerings stated. After giving the table a name, I then used it in another query to JOIN the table where the skills needed for the job is listed. I used JOIN again to give names to the skills themselves. And finally, I ordered them by their count.

### Results
| Skills   | Skill Demand |
|----------|--------------|
| SQL      | 606          |
| Python   | 431          |
| Tableau   | 337          |
| Excel    | 231          |
| R        | 220          |

### Analysis
  1. The high demand for SQL and Python suggests that employers prioritize candidates who can handle data effectively, indicating a shift towards more technical skill sets in many industries.
  2. The presence of Tableau in the list emphasizes the importance of visualization skills in making data comprehensible and actionable.
  3. Although Excel is lower on the list, it remains a fundamental skill, especially in roles that do not require advanced programming knowledge.
  4. R's lower demand compared to Python indicates that while it is important for specific fields (like statistics and data science), it may not be as universally required.

## Objective #3
### SQL Query
To pinpoint which are the skills that appreared the most for data analyst job postings, here is ther query that I wrote.
```sql
SELECT 
    skills_dim.skills,
    count(skills_dim.skills) AS skill_count
FROM job_postings_fact
FULL JOIN skills_job_dim
ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills_dim.skills
ORDER BY 
    count(skills_dim.skills) DESC
LIMIT 10;
```
To break it down, this query involves nothing too complicated aside from the aggregation function of count that I used to count all of the occurances where a skill is mentioned in the job postings. I ordered them descendingly by the number of their count to determine the top 10 skills.
### Results
| Skills    | Skill Count |
|-----------|-------------|
| SQL       | 385,750     |
| Python    | 381,863     |
| AWS       | 145,718     |
| Azure     | 132,851     |
| R         | 131,285     |
| Tableau    | 127,500     |
| Excel     | 127,341     |
| Spark     | 114,928     |
| Power BI  | 98,363      |
| Java      | 85,854      |

### Analysis
1. SQL (385,750) and Python (381,863) are at the top of the list, showing that database management and versatile programming are critical for many industries, especially in data science, analytics, and backend development.
2. AWS (145,718) and Azure (132,851) indicate a growing demand for cloud computing skills as businesses increasingly migrate to cloud infrastructure for flexibility, scalability, and cost efficiency.
3. R (131,285), Tableau (127,500), and Power BI (98,363) are essential tools for data analysis and visualization, reflecting the importance of transforming raw data into actionable insights in modern businesses.
4. Spark (114,928) represents the rising need for big data processing technologies, particularly in fields like data engineering and machine learning, where large-scale data manipulation is crucial.
5. Excel (127,341) remains highly relevant, demonstrating that foundational skills in data organization and analysis are still important, even with the rise of more specialized tools.
6. Java (85,854) continues to be a valuable programming language for building large-scale applications and systems, especially in enterprise software development and Android app development.

## Objective #4
### SQL Query
This is the query I wrote to get the highest paid skills in the dataset.
```sql
SELECT
    skills_dim.skills,
    avg(job_postings_fact.salary_year_avg) as average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills_dim.skills
ORDER BY average_salary DESC NULLS LAST
LIMIT 10;
```
The query is also a matter of a simple aggregation of the average function. This gets the average of all salaries listed for each skills through the GROUP BY clause in which we indicated skills themselves.
### Results
| Skills        | Average Salary ($)      |
|---------------|-------------------------|
| Debian        | 196,500.00              |
| RingCentral   | 182,500.00              |
| Mongo         | 170,714.89              |
| Lua           | 170,500.00              |
| dplyr         | 160,667.21              |
| Haskell       | 155,757.67              |
| ASP.NET Core  | 155,000.00              |
| Node          | 154,408.02              |
| Cassandra     | 154,124.26              |
| Solidity      | 153,639.95              |

### Analysis

1. Debian leads with an average salary of $196,500, reflecting its demand in specialized system administration roles.
2. RingCentral follows at $182,500, showing the value of expertise in cloud-based communication platforms.
3. Mongo and Lua, both offering around $170,000, highlight the importance of database management and scripting skills.
4. dplyr, at $160,667, is a high-paying skill in data manipulation, especially for R programmers.
5. Haskell and ASP.NET Core, with salaries over $155,000, show that niche programming skills are highly valued.
6. Node and Cassandra, at $154,408 and $154,124 respectively, emphasize the demand for backend development and big data expertise.
7. Solidity, offering $153,639, reflects the premium placed on blockchain development skills.
   
It is important to note that despite high average salaries, they are considered niche skills to have which means that their count of occurances in the whole job postings for 2023 are very miniscule compared to others.

## Objective #5
### SQL Query
This was the query I wrote to determine the 'optimal' skills to learn as a data analyst.
```sql
WITH top_10_skills AS (
    SELECT 
        skills_dim.skills,
        avg(job_postings_fact.salary_year_avg) AS average_salary
    FROM job_postings_fact
    FULL JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
    LEFT JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        skills_dim.skills IS NOT NULL AND
        job_postings_fact.salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skills
    ORDER BY 
        count(skills_dim.skills) DESC
    LIMIT 10
)

SELECT
    skills,
    average_salary
FROM top_10_skills
ORDER BY average_salary DESC;
```
Optimal can be very vague without explanation. The 'optimal' skills in this case would mean skills that are in-demand, and has a high salary offering. To do so, we used a CTE for this query to first determine the top 10 skills based in their count of occurances in the job postings. It is also important to note that in the WHERE clause, we pinpointed that the position would be for data analysts, there must be an indicated skill, and the salary must be discrete. After creating the table, it was only a matter of adding another query below to sort the table based on the average salary of the top 10 skills.

### Results
| Skills      | Average Salary ($)      |
|-------------|-------------------------|
| Python      | 101,511.85              |
| R           | 98,707.80               |
| Tableau     | 97,978.08               |
| SQL         | 96,435.33               |
| SQL Server  | 96,191.42               |
| SAS         | 93,707.36               |
| Power BI    | 92,323.60               |
| PowerPoint  | 88,315.61               |
| Excel       | 86,418.90               |
| Word        | 82,940.76               |

### Analysis
1. Python leads the table with an average salary of $101,511, highlighting its significance in data science, software development, and automation roles.
2. R and Tableau follow with average salaries of $98,707 and $97,978, indicating strong demand for statistical programming and data visualization skills.
3. SQL and SQL Server both exceed $96,000, demonstrating the high value placed on database management expertise.
4. SAS and Power BI, with average salaries of $93,707 and $92,323, reflect the importance of data analytics and business intelligence in organizations.
5. Office tools like PowerPoint, Excel, and Word have lower average salaries, ranging from $82,940 to $88,315, but remain essential for business communication and operations.
6. Overall, programming, analytics, and database management skills command higher salaries, showcasing their critical role in today’s data-driven environments.

## Ending Remarks
That wraps up this project! I must say, SQL as a language is far more easier to comprehend than python (for context, I studied python first before jumping into SQL). But despite it being easier than python, I can still see why this skill is sought after the most for data analysts. It is easy to grasp, yet at the same time, can handle and explore large databases. It sure is fun though learning how CTE's and subqueries are made. Before I formally end this, thanks again to Luke for the course he published on YouTube. This repo would not be possible without his help. Now then, here's to more SQL in the future! 
