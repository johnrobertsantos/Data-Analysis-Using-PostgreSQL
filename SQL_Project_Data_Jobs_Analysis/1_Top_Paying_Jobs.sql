-- PROJECT 1 (TOP PAYING JOBS)

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