-- PROJECT 4 (HIGHEST PAID SKILLS)

SELECT
    skills_dim.skills,
    avg(job_postings_fact.salary_year_avg) as average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills_dim.skills
ORDER BY average_salary DESC NULLS LAST
LIMIT 10;