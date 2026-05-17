SELECT 
    COUNT(job_id) AS job_count,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'REMOTE'
        WHEN job_location = 'New York' THEN 'Local'
        ELSE 'On-site'
    END AS job_location_category
FROM
    job_postings_fact
WHERE
 job_title_short ='Data Analyst'
GROUP BY
    job_location_category;


-- practice_problems_1 :

SELECT 
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg BETWEEN  0 AND 50000 THEN 'LOW'
        WHEN salary_year_avg BETWEEN 50001 AND 100000 THEN 'STANDARD'
        WHEN salary_year_avg >100_000  THEN 'HIGH'
    END AS salary_category
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
    AND
    job_title_short = 'Data Analyst'
ORDER BY
 salary_year_avg DESC;