--sub-query creation to filter job postings for the month of January 
SELECT *
FROM 
    (
     SELECT *
     FROM job_postings_fact
     WHERE EXTRACT(MONTH FROM job_posted_date) = 1        
    ) AS january_jobs;

-- CTE(common table expression) for defining temporary result set that you can reference.
WITH january_jobs AS 
    (
        SELECT *
        FROM job_postings_fact
        WHERE EXTRACT(MONTH FROM job_posted_date) = 1        
    )

SELECT *
FROM january_jobs;

--prcatice_problem_1: companies offering jobs with no degree requirement using sub-query.

SELECT
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE
    company_id IN 
    (
        SELECT 
            company_id
        FROM 
            job_postings_fact
        WHERE 
            job_no_degree_mention = True
        ORDER BY
            company_id
    );

-- practice_problem_2 
WITH company_job_count AS
(   SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM 
        job_postings_fact
    GROUP BY
        company_id
)
--referencing to the CTEs

SELECT
    company_dim.name as company_name,
    company_job_count.total_jobs
FROM
    company_dim
LEFT JOIN
    company_job_count
    ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC; 

--practice_problem_3 : 2:41:59

SELECT 
    skills,
    (
    SELECT
        COUNT(skills_job_dim.skill_id) AS skill_count
    FROM
        skills_job_dim
    )
FROM
    skills_dim
LEFT JOIN
    skills_job_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY
    skills
ORDER BY
    count(skills_job_dim.skill_id) DESC;


-- practice_problem_4 : 2:41:59
WITH company_size AS
(
    SELECT
        company_id,
        count(job_id) AS job_count, 
        CASE
        WHEN COUNT(job_id) < 10 THEN 'Small'
            WHEN COUNT(job_id) BETWEEN 10 AND 50 THEN 'Medium'
            WHEN COUNT(job_id) >50 THEN 'Big'
        END AS size_category
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT
    c.name AS company_name,
    s.size_category as company_size,
    s.job_count as total_jobs
FROM
    company_dim AS c
JOIN
    company_size AS s
    ON c.company_id = s.company_id
GROUP BY 
    c.name, s.size_category, s.job_count
ORDER BY
   s.job_count DESC;
 