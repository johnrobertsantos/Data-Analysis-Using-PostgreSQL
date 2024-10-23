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