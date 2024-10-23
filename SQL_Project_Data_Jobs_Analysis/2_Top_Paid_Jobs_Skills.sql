-- PROJECT 2 (TOP PAID JOBS' SKILLS)

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