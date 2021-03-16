-- 2021-03-12 복습
조건에 맞는 데이터 조회 : WHERE 절 - 기술한 조건을 참TRUE으로 만족하는 행들만 조회한다(FILTER);

-- row : 14개, col : 8개 - 컬럼 이름까지 외울 것
SELECT *
FROM emp
WHERE 1 = 1;

SELECT *
FROM emp
--WHERE deptno = deptno; -- 총 14행 출력, 1 = 1
WHERE 1 != 1;

int a = 20;
String a = "20";
  '20';

SELECT 'SELECT * FROM ' || table_name || ';'
FROM user_tables;

DBMS - 다른 사용자가 데이터를 수정할 때 데이터를 사용할 수 없다

'81/03/01'
TO_DATE('81/03/01', 'YY/MM/DD')

-- 입사일자가 1982년 1월 1일 이후인 모든 직원을 조회하는 SELECT 쿼리를 작성하세요
-- => 날짜를 비교해라 + 1월 1일 이후 -> 1월 1일 포함
30 > 20 : 숫자 > 숫자
날짜 > 날짜
2021-03-15 > 2021-03-12

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD'); 
-- TO_DATE('19820101', 'YYYYMMDD'), TO_DATE('1982-01-01', 'YYYY-MM-DD')


#연산자
WHERE 절에서 사용 가능한 연산자
(비교 / -, !=, >, <, ...)
a + b : 이항 연산자
a++ ==> a = a+1; : 단항 연산자
++a ==> a = a+1; : 단항 연산자


#BETWEEN AND
비교대상 BETWEEN 비교대상의 허용 시작값 AND 비교대상의 허용 종료값 
ex. 부서번호가 10번에서 20번 사이에 속한 직원들만 조회

SELECT *
FROM emp
WHERE deptno BETWEEN 10 AND 20; -- BETWEEN A AND B : 결과에 A, B 포함 - 이상, 이하


emp 테이블에서 급여(sal)가 1000보다 크거나 같고 2000보다 작거나 같은 직원들만 조회
-- sal >= 1000 AND sal <= 2000

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

-- 잠깐 논리연산
true AND true ==> true
true AND false ==> false
true OR false ==> true

SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000;

SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000
  AND deptno = 10;
  

-- 조건에 맞는 데이터 조회하기 (BETWEEN ... AND ... 실습 WHERE1)
- emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의
ename, hiredate 데이터를 조회하는 쿼리를 작성하시오.
(단, 연산자는 between을 사용한다)

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01', 'YYYY/MM/DD') AND TO_DATE('1983/01/01', 'YYYY/MM/DD');

BETWEEN AND : 포함(이상, 이하)
              초과, 미만의 개념을 적용하려면 비교연산자를 사용
              
              
IN 연산자 -- = OR
대상자 IN (대상자와 비교할 값1, 대상자와 비교할 값2, 대상자와 비교할 값3, ...)
deptno IN(10, 20) ==> deptno값이 10이나 20이면 TRUE;

SELECT *
FROM emp
WHERE deptno IN(10, 20);

SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;

SELECT *
FROM emp
WHERE 10 IN(10, 20);
-- => 10은 10이나 20과 같다
--      TRUE  OR FALSE    => TRUE


-- 조건에 맞는 데이터 조회하기 (IN 실습 WHERE3)
- users 테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회하시오.
(IN 연산자 사용)

SELECT *
FROM users
WHERE userid IN ('brown', 'cony', 'sally');

SELECT userid 아이디, usernm 이름, alias 별명
FROM users
WHERE userid IN ('brown', 'cony', 'sally');
-- WHERE userid 'brown' OR userid 'cony' OR userid 'sally'


LIKE 연산자: 문자열 매칭 조회
게시글 : 제목 검색, 내용 검색
        제목에 [맥북에어]가 들어가는 게시글만 조회

        1. 얼마 안된 맥북에어 팔아요
        2. 맥북에어 팔아요
        3. 팝니다 맥북에어

-- 마스킹 문자        
% : 0개 이상의 문자
_ : 1개의 문자

SELECT *
FROM users
WHERE userid LIKE 'c%';

- userid가 c로 시작하면서 c 이후에 3개의 글자가 오는 사용자
SELECT *
FROM users
WHERE userid LIKE 'c___';

- userid에 l;엘이 들어간 모든 사용자 조회
SELECT *
FROM users
WHERE userid LIKE '%l%'; -- 문자열 데이터의 대소문자를 구분


-- 조건에 맞는 데이터 조회하기 (LIKE, %, _ 실습 WHERE4)
- member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오.

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';


-- 조건에 맞는 데이터 조회하기 (LIKE, %, _ 실습 WHERE5)
- member 테이블에서 회원의 이름에 [이]가 들어가는 모든 사람의
mem_id, mem_name을 조회하는 쿼리를 작성하시오

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';



테이블: 게시글
제목 컬럼 : 제목
검색 : 맥북에어

SELECT *
FROM 게시글
WHERE 제목 LIKE '%맥북에어%';
   OR 내용 LIKE '%맥북에어%'

제목 OR 내용  =>
1       2       
TRUE    TRUE    TRUE
TRUE    FALSE   TRUE
FALSE   TRUE    TRUE
FALSE   FALSE   FALSE


IS, IS NOT (NULL 비교)
emp 테이블에서 comm 컬럼의 값이 NULL인 사람만 조회

SELECT *
FROM emp
WHERE comm IS NULL; -- IS NULL <-> IS NOT NULL
      sal = 1000
      sal != 1000

emp 테이블에서 매니저가 없는 직원만 조회

SELECT *
FROM emp
WHERE mgr IS NULL;


-- 조건에 맞는 데이터 조회하기 (IS NULL 실습 WHERE6)
emp 테이블에서 comm 컬럼의 값이 NULL인 사람만 조회 -- 위에서 함


오늘 지금까지 배운 연산자 : BETWEEN, IN, LIKE, IS/IS NOT


논리 연산자 : AND, OR, NOT
AND : 두 가지 조건을 동시에 만족시키는지 확인할 때
      조건1 AND 조건2
OR : 두 가지 조건 중 하나라도 만족시키는지 확인할 때
     조건1 OR 조건2
NOT : 부정형 논리연산자, 특정 조건을 부정
mgr IS NULL : mgr 컬럼의 값이 NULL인 사람만 조회
mgr IS NOT NULL : mgr 컬럼의 값이 NULL이 아닌 사람만 조회

emp 테이블에서 mgr의 사번이 7698이면서 -- 이면서 -> AND
sal 값이 1000보다 큰 직원만 조회;
-- 2가지 조건

-- 조건의 순서는 결과와 무관하다
SELECT *
FROM emp
WHERE mgr = 7698 AND sal > 1000
-- <=> WHERE  sal > 1000 AND mgr = 7698;
-- 조건의 순서는 결과와 무관하다

AND 조건이 많아지면 : 조회되는 데이터 건수는 줄어든다
OR 조건이 많아지면 : 조회되는 데이터 건수는 많아진다

NOT : 부정형 연산자, 다른 연산자와 결합하여 쓰인다
      IS NOT, NOT IN, NOT LIKE
      
SELECT *
FROM emp
WHERE deptno NOT IN (30); -- !3

SELECT *
FROM emp
WHERE ename NOT LIKE 'S%';


! 중요.
! NOT IN 연산자 사용시 주의점 : 비교값 중에 NULL이 포함되면 데이터가 조회되지 않음

-- IN
SELECT *
FROM emp
WHERE mgr IN(7698,7839, NULL);
==>
mgr = 7698 OR mgr = 7839 OR mgr = NULL

-- NOT IN
SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839, NULL);
==>
!(mgr = 7698 OR mgr = 7839 OR mgr = NULL)
==>
mgr != 7698 AND mgr != 7839 AND mgr != NULL -- 시험 제출
==>
TRUE FALSE 의미가 없음 AND FALSE

주의 : mgr != NULL 
mgr != NULL 은 항상 거짓이기 때문에 = AND FALSE


where 7]
논리연산 (AND, OR 실습 WHERE7)
- emp 테이블에서 job이 SALESMAN 이고 입사일자가 1981년 6월 1일 이후인
직원의 정보를 다음과 같이 조회하세요.

SELECT *
FROM emp
WHERE job LIKE 'SALESMAN' AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD'); -- 주의. LIKE는 정식 리터럴 표기가 아님
-- WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
-- 이후는 날짜 포함!!

where 8]
논리연산 (AND, OR 실습 WHERE8)
- emp 테이블에서 부서번호가 10번이 아니고
입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
(IN, NOT IN 연산자 사용 금지)

SELECT *
FROM emp
WHERE deptno != 10 -- deptno NOT IN (10)
AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

where 9] NOT IN 사용
SELECT *
FROM emp
WHERE deptno NOT IN (10)
AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');


where 10] IN 사용
- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 
입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
(부서는 10, 20, 30만 있다고 가정하고 IN 연산자를 사용)

SELECT *
FROM emp
WHERE deptno IN (20, 30) 
AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');


where 11]
논리연산 (AND, OR 실습 WHERE11)
- emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인
직원의 정보를 다음과 같이 조회하세요.

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');


where 12] 풀면 좋고, 못 풀어도 괜찮은 문제
논리연산 (AND, OR 실습 WHERE12)
- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는
직원의 정보를 다음과 같이 조회하세요.

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';  
-- 암묵적 형변환, empno는 숫자인데 문자열 비교를 통한 연산


where 13]
- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는
직원의 정보를 다음과 같이 조회하세요. (LIKE 연산자 사용 금지)

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno BETWEEN 7800 AND 7899;


SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno BETWEEN 7800 AND 7899
OR empno BETWEEN 780 AND 789
OR empno = 78;





 