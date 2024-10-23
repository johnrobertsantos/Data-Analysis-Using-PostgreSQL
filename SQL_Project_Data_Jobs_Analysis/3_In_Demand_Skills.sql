-- PROJECT 3 (IN-DEMAND SKILLS)

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