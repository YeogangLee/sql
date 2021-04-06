RDBMS는 검색이 주를 이룬다
빅데이터 등장 이후 검색보다 삽입, 삭제가 주 목적이 됨
SELECT 보다는 나머지 명령어 사용 빈도수가 늘어나게 되었다 > 중요도++

NoSQL 비정형 데이터 등장...

익명뷰
: 이름X, 저장이 안 된다

이름을 부여해서 별도로 저장, 목적
: JOIN, 서브 쿼리 등을 이용해 얻은 결과를 
반복해서 사용하기 위해 여러 번 수행하다 보면 시간이 오래 걸린다.

실무를 하다보면, 데이터 액세스를 위한 시간이 가장 길다

1. 저장해서 사용하면 시간 소요가 적다
2. 민감한 정보의 유출을 막기 위해 ex.계약한 회사마다 다를 수 있는 물품의 각 단가

생성 : CREATE
삭제 : DROP

오라클은 자동 증가를 시켜주는 AUTO INCREMENT 를 지원하지 않는다
대신 이것을 테이블에 독립적으로 제공 -> 시퀀스 객체

시퀀스 : 1씩 증가하거나 1씩 감소하는 숫자들을 자동 생성해주는 객체

인덱스 객체 - 빠른 접근을 위해

자료구조 - 해싱 기법
자바에서 오브젝트 클래스가 가지고 있는 기본 메서드 중에도 이 해싱 기법이 있다 

트리

검색이진트리
정렬

인덱스를 많이 만들면 안 된다 > 적당히 만들어야 한다

--
2021-04-01 View 객체
- TABLE과 유사한 기능 제공
- 보안, QUERY 실행의 효율성, TABLE의 은닉성을 위해 사용
- 사용형식
CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW 뷰이름 [(컬럼LIST)]
AS
    SELECT 문;
    [WITH CHECK OPTION;]
    [WITH READ ONLY;]

    
방문자수 그래프 > 일정 시간 이후 조회할 때마다 뷰 생성, 너무 많다
OR REPLACE : 뷰가 하드디스크에 이미 있으면 덮어 쓰고, 이름이 없으면 새로 생성
             뷰가 존재하면 대체되고 없으면 신규로 생성             

- FORCE, NOFORCE             
FORCE : 원본 테이블이 없어도 뷰를 만들어 준다
        원본 테이블이 존재하지 않아도 뷰를 생성(FORCE), 생성불가(NOFORCE)
COLUMN LIST : 생성된 뷰의 컬럼명
              스키마 : 컬럼의 이름
              저 이름을 그대로 쓰고 싶으면 쓰고, 아니면 컬럼 리스트 사용 
              컬럼 리스트로 기술 되어진 이름들 또한 스키마
WITH CHECK OPTION : SELECT 문의 조건절에 위배되는 DML 명령 실행 거부
WITH READ ONLY : 읽기전용 뷰 생성 -> INSERT, UPDATE, DELETE 수행 불가


사용 예 ) 
사원 테이블에서 부모 부서 코드가 90번 부서에 속한 사원정보를 조회하시오.
조회할 데이터 : 사원번호, 사원명, 부서명, 급여

사용 예 )
회원 테이블에서 마일리지가 3000 이상인 회원의 회원번호, 회원명, 직업, 마일리지를 조회하시오.

SELECT 회원번호, 회원명, 직업, 마일리지
FROM 회원
WHERE 마일리지 >= 3000;

SELECT mem_id, mem_name, mem_job, mem_mileage
FROM member
WHERE mem_mileage >= 3000
ORDER BY mem_mileage;


자바의 특징을 영어단어 하나로 말해보라.
: reuse -> 상속, 다형성, 오버라이딩 ...

=> 뷰 생성 
명령어 : CREATE
CREATE OR REPLACE VIEW V_MEMBER01
AS 
    SELECT mem_id AS 회원번호, 
           mem_name AS 회원명, 
           mem_job AS 직업, 
           mem_mileage AS 마일리지
    FROM member
    WHERE mem_mileage >= 3000;


프로시저 랭귀지 SQL - PLSQL
반복문, 배열 등을 사용할 수 있게 해주는 SQL

SELECT * FROM V_MEMBER01;

(신용환 회원의 자료 검색);
SELECT MEM_NAME, MEM_JOB, MEM_MILEAGE
  FROM MEMBER
-- WHERE MEM_ID = 'C001'; -- 대소문자가 달라서 조회 불가
 WHERE UPPER(MEM_ID) = 'C001';
-- ??????????????????????????????????

(MEMBER 테이블에서 신용환의 마일리지를 10000으로 변경)
UPDATE MEMBER
   SET MEM_MILEAGE = 10000 -- 변경할 컬럼명
 WHERE MEM_NAME = '신용환';

SELECT * FROM V_MEMBER01;

(뷰 V_MEMBER01에서 신용환의 마일리지를 500으로 변경);
UPDATE V_MEMBER01
   SET MEM_MILEAGE = 500 -- 마일리지 = 500
 WHERE MEM_NAME = '신용환'; -- 회원명 = '신용환'
 
SELECT * FROM V_MEMBER01;
-- 신용환 회원 행이 사라졌다.
-- 이유 : 뷰 생성 조건이 마일리지 3천 이상, 마일리지를 500으로 수정하니 조건 불만족 -> 뷰에 포함X


WITH CHECK OPTION 사용 VIEW 생성

ROLLBACK;

CREATE OR REPLACE VIEW v_member01(mid, mname, mjob, mmil)
AS 
    SELECT mem_id AS 회원번호, 
           mem_name AS 회원명, 
           mem_job AS 직업, 
           mem_mileage AS 마일리지
    FROM member
    WHERE mem_mileage >= 3000
    WITH CHECK OPTION;

-- 뷰가 아니라 테이블이라면, 테이블 이름 중복이 안 돼서 생성 불가능

SELECT * FROM v_member01;

뷰에 컬럼명 지정
1. CREATE VIEW 뷰 이름 (컬럼명) -- 제일 우선순위가 높은 방법
2. SELECT 문의 AS 뒤 별칭
3. 

(뷰 V_MEMBER01에서 신용환 회원의 마일리지를 2000으로 변경);
UPDATE v_member01
   SET mmil = 2000
 WHERE UPPER(mid) = 'C001';
 
(테이블 MEMBER에서 신용환 회원의 마일리지를 2000으로 변경);
UPDATE member
   SET mem_mileage = 2000
 WHERE UPPER(mem_id) = 'C001';
 
SELECT * FROM member;

CREATE OR REPLACE VIEW v_member01(mid, mname, mjob, mmil)
AS 
    SELECT mem_id AS 회원번호, 
           mem_name AS 회원명, 
           mem_job AS 직업, 
           mem_mileage AS 마일리지
    FROM member
    WHERE mem_mileage >= 3000
    WITH READ ONLY;
    
ROLLBACK; 

SELECT mem_id, mem_name, mem_job, mem_mileage
FROM member
WHERE UPPER(mem_id) = 'C001';


(뷰 V_MEMBER01에서 오철희 회원의 마일리지를 5700으로 변경)
UPDATE v_member01
   SET mmil = 5700
 WHERE UPPER(mid) = 'k001';
 
WITH READ ONLY 키워드만 사용했으므로, 보기만 할 수 있다 INSERT, DELETE, UPDATE 불가
.
SELECT mem_id AS 회원번호, 
       mem_name AS 회원명, 
       mem_job AS 직업, 
       mem_mileage AS 마일리지
FROM member
WHERE mem_mileage >= 3000
WITH READ ONLY
WITH CHECK OPTION; -- 위 아래 두 키워드 동시사용 불가능

집으로 오라클 파일 복사 ...
> 안된다
1. 쿼리 스크립트 파일, 텍스트 복붙
2. 테이블 복붙 X? > EXPORT 기능, 내보내기
- cmd 창 켜기 > imp sql자기계정명;stu/비밀번호;java file=파일명;expall.dmp ignore=y grants=y indexes=y rows=y full=y > 엔터
-- 입력 : imp stu/java file=expall.dmp ignore=y grants=y indexes=y rows=y full=y

-- 다른 sql계정에 있는 테이블을 조회할 때, 앞에 계정명 사용
SELECT hr.departments.department_id,
       department_name
  FROM hr.departments;

  


2021-04-01_2

-- SQL 처음 설치하면 나타나는 계정 3개
1. 시스템 계정
2. HR 계정 -- HR계정은 활성화시키기 전에는 안 보인다
3. SCOTT 계정

departments 테이블의 parent_id 컬럼, 예제 공부에 좋다 ...
stu 계정에 있음


문제);
HR계정의 사원테이블(employees)에서 50번 부서에 속한 사원 중 급여가 5000 이상인 사원번호, 사원명, 입사일, 급여를
읽기 전용 뷰로 생성하시오. (뷰 이름은 v_emp_sal01, 컬럼명은 원본 테이블의 컬럼명 사용)
뷰가 생성된 후, 뷰와 테이블을 이용해 해당 사원의 사원번호, 사원명, 직무명, 급여를 출력하는 SQL 작성

CREATE OR REPLACE VIEW v_emp_sal01
AS 
    SELECT *
    FROM employees
    WHERE employees.department_id = 50
    AND employees.salary >= 5000
    WITH READ ONLY;
    
SELECT employee_id, emp_name, job_id, salary
FROM v_emp_sal01;

SELECT 사원번호, 사원명, 직무명, 급여
  FROM employees a, jobs b, v_emp_sal01 c
->;
SELECT c.employee_id AS 사원번호, 
       c.emp_name AS 사원명, 
       b.job_id AS 직무명, 
       c.salary AS 급여
  FROM employees a, jobs b, v_emp_sal01 c
 WHERE a.employee_id = c.employee_id
   AND a.job_id = b.job_id;
-- 5개의 커서

CURSOR : SELECT 문 쿼리에 의해 영향을 받은 행들의 집합
커서 사용 이유 : 한 행만 조회 가능
inexlicit INEXPLICIT 익명 커서는 불가능, 1행 찍으면 열고 마지막행 찍으면 커서를 닫기 때문에
explicit EXPLICIT 명시 커서는 가능, 1행씩 오픈해서 읽을 수 있다 - FETCH 과정

단일행, 다중행 SQL
> PLSQL에서 주의해서 사용, 기존 SQL과 사용환경이 많이 달라진다

