SELECT *
FROM jobs;
-- hr 계정 밖에서 입력하면 없는 테이블이라고 뜬다.


데이터 결합 실습 join8]

SELECT r.region_id, r.region_name, c.country_name
FROM countries c, regions r
WHERE c.region_id = r.region_id
  AND region_name = 'Europe';


데이터 결합 실습 join9]

SELECT r.region_id, r.region_name, c.country_name, l.city
FROM countries c, regions r, locations l
WHERE r.region_id = c.region_id
  AND c.country_id = l.country_id
  AND region_name = 'Europe';
  

데이터 결합 실습 join10]

SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name
FROM countries c, regions r,  locations l, departments d
WHERE r.region_id = c.region_id
  AND c.country_id = l.country_id
  AND l.location_id = d.location_id
  AND region_name = 'Europe';
  

데이터 결합 실습 join11]

SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name
    , CONCAT(e.first_name, e.last_name) name
FROM countries c, regions r,  locations l, departments d, employees e
WHERE r.region_id = c.region_id
  AND c.country_id = l.country_id
  AND l.location_id = d.location_id
  AND d.department_id = e.department_id
  AND region_name = 'Europe';
  
  
데이터 결합 실습 join12]

SELECT e.employee_id, CONCAT(e.first_name, e.last_name) name, j.job_id, j.job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id;


데이터 결합 실습 join13]

-- null값 포함하면 107이지만, 제거해서 문제의 106으로 만들기
SELECT e.manager_id, CONCAT(e.first_name, e.last_name) mgr_name, e.employee_id, CONCAT(e.first_name, e.last_name) name,
    j.job_id, j.job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id
--  AND e.manager_id != null -- 항상 거짓
  AND e.manager_id IS NOT NULL
ORDER BY e.manager_id, e.employee_id;


SELECT e.manager_id, CONCAT(e.first_name, e.last_name) mgr_name, e.employee_id, CONCAT(e.first_name, e.last_name) name,
    j.job_id, j.job_title
FROM employees e JOIN jobs j ON (e.job_id = j.job_id)
ORDER BY e.manager_id, e.employee_id;




