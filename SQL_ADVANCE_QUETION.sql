-- NUMBER OF JOBS PER SKILL FOR JOBS WITH LOCATION 'ANYWHERE'
-- my approach

-- CTEs for clculating the no. of jobs for data analyst as well as job location as work from home.
WITH jpf AS 
(
    SELECT
        jp.job_id
    FROM
        job_postings_fact AS jp
    WHERE
        jp.job_work_from_home = TRUE
        AND jp.job_title_short = 'Data Analyst'    
)
-- main query to get the no. of jobs per skill name for data analyst jobs with location REMOTE.
SELECT 
    s.skill_id,
    s.skills AS skill_name,
    COUNT(jpf.job_id) AS total_jobs
FROM
    skills_dim AS s
LEFT JOIN 
    skills_job_dim AS c
    ON c.skill_id = s.skill_id
LEFT JOIN
    jpf
    ON jpf.job_id = c.job_id
GROUP BY 
    s.skills, s.skill_id
ORDER BY
    total_jobs DESC

-- NUMBER OF JOBS PER SKILL FOR JOBS WITH LOCATION 'ANYWHERE'
-- lukeb' approach

-- CTEs for clculating the no. of jobs for data analyst with work from home.
WITH jpf AS 
(
    SELECT
        sk.skill_id,
        COUNT(*) AS total_jobs
    FROM
        skills_job_dim AS sk
    INNER JOIN
        job_postings_fact AS jp
        ON jp.job_id = sk.job_id
    WHERE
        jp.job_work_from_home = TRUE
        AND jp.job_title_short = 'Data Analyst'    
    GROUP BY
        sk.skill_id
)
SELECT 
    skills.skill_id,
    skills AS skill_name,
    jpf.total_jobs
FROM
    jpf
INNER JOIN
    skills_dim AS skills
    ON skills.skill_id = jpf.skill_id
ORDER BY
    total_jobs DESC;





