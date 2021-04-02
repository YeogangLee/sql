--=01
SELECT 실습 select1]
- lprod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요;
SELECT * FROM lprod;

- buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성하세요;
SELECT buyer_id, buyer_name
FROM buyer;

- cart 테이블에서 모든 데이터를 조회하는 쿼리 작성하세요;
SELECT *
FROM cart;

- member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리 작성하세요;
SELECT mem_id, mem_pass, mem_name
FROM member;


column alias 실습 SELECT2]
- prod 테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하시오.
(단 prod_id -> id, prod_name -> name으로 컬럼 별칭을 지정)
SELECT prod_id "id", prod_name "name"
FROM prod;

- lprod 테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회하는 쿼리를 작성하시오.
(단 lprod_gu -> gu, lprod_nm -> nm으로 컬럼 별칭을 지정)
SELECT lprod_gu "gu", lprod_nm "nm"
FROM lprod;

- buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하시오.
(단 buyer_id -> 바이어아이디, buyer_name -> 이름으로 컬럼 별칭을 지정)
SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;


--=02,03

where 1]
- emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의
ename, hiredate 데이터를 조회하는 쿼리를 작성하시오. (단, 연산자는 between을 사용한다)

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYYMMDD') AND TO_DATE('19830101', 'YYYYMMDD');


where 3]
- users 테이블에서 userid가 brown, cony, sally인 데이터를 
다음과 같이 조회하시오. (IN 연산자 사용)

SELECT *
FROM users
WHERE userid IN ('brown','cony','sally'); 

SELECT userid 아이디, usernm 이름, alias 별명
FROM users
--WHERE userid IN ('brown', 'cony', 'sally');
WHERE userid = 'brown' OR userid = 'cony' OR userid = 'sally';



where 4]
- member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 
조회하는 쿼리를 작성하시오.

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';


where 5]
- member 테이블에서 회원의 이름에 [이]가 들어가는 모든 사람의
mem_id, mem_name을 조회하는 쿼리를 작성하시오.

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '이%' OR LIKE '%이%' OR LIKE '%이'; --//


where 6]
- emp 테이블에서 comm 컬럼의 값이 NULL인 사람만 조회
SELECT *
FROM emp
WHERE comm IS NULL;


- emp 테이블에서 매니저가 없는 직원만 조회
SELECT *
FROM emp
WHERE mgr IS NULL;


where 7]
- emp 테이블에서 job이 SALESMAN 이고 입사일자가 1981년 6월 1일 이후인 -- 이후는 날짜 포함 **
직원의 정보를 다음과 같이 조회하세요.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate >= TO_CHAR('19810601', 'YYYYMMDD');


where 8]
- emp 테이블에서 부서번호가 10번이 아니고
입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
(IN, NOT IN 연산자 사용 금지)
SELECT *
FROM emp
WHERE deptno != 10
  AND hiredate >= TO_DATE('19810601','YYYYMMDD');


where 9]
- emp 테이블에서 부서번호가 10번이 아니고
입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
(IN, NOT IN 연산자 사용)
SELECT *
FROM emp
WHERE deptno NOT IN (10)
  AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');


where 10] 
- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 
입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
(부서는 10, 20, 30만 있다고 가정하고 IN 연산자를 사용)
SELECT *
FROM emp
WHERE deptno IN (20, 30)
  AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');


where 11]
- emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인
직원의 정보를 다음과 같이 조회하세요.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR hiredate >= TO_DATE('19810601', 'YYYYMMDD');


where 12]
- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는
직원의 정보를 다음과 같이 조회하세요.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';
--   OR empno = '78%'; 주의, 문자열과의 연산은 LIKE LIKE LIKE !!!


where 13]
- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는
직원의 정보를 다음과 같이 조회하세요. (LIKE 연산자 사용 금지)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno = 78
   OR empno BETWEEN 780 AND 789
   OR empno BETWEEN 7800 AND 7899;


--
이후로 => 이 날짜 포함 !
문자열과 비교는 '=' 마스킹 문자 사용은 LIKE


--=04

WHERE 13]

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno BETWEEN 7800 AND 7899
OR empno BETWEEN 780 AND 789
OR empno = 78;


WHERE 14]
논리연산(AND, OR 실습 WHERE14)
- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하면서 
  입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
  (t.사원번호는 전부 4자리인 것으로 가정)
  
힌트.
--- emp 테이블에서
--1. job이 SALESMAN이거나
--2. 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인
--직원의 정보를 다음과 같이 조회하세요.
--(1번 조건 또는 2번 조건을 만족하는 직원)
--(t.사원번호는 전부 4자리인 것으로 가정)
;
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR (hiredate >= TO_DATE('19810601', 'YYYYMMDD') AND empno LIKE '78%');
      

-- // WHERE의 기본적 내용 끝


데이터 정렬 ORDER BY 1]
- dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요
- dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요
* 컬럼명을 명시하지 않았습니다. 지난 수업시간에 배운 내용으로 올바른 컬럼을 찾아보세요.

SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc DESC;

DESC dept;


데이터 정렬 ORDER BY 2]
- emp 테이블에서 상여comm 정보가 있는 사람들만 조회하고,
상여를 많이 받는 사람이 먼저 조회되도록 정렬하고,
상여가 같을 경우 사번으로 내림차순 정렬하세요.
(상여가 0인 사람은 상여가 없는 것으로 간주)
;
SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm != 0
ORDER BY comm DESC, empno DESC;


데이터 정렬 ORDER BY 3]
- emp 테이블에서 관리자가 있는 사람들만 조회하고, 직군job 순으로 오름차순 정렬하고,
직군이 같을 경우 사번이 큰 사원이 먼저 조회되도록 쿼리를 작성하세요.

SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;


데이터 정렬 ORDER BY 4]
- emp 테이블에서 10번 부서deptno 혹은 30번 부서에 속하는 사람 중
급여sal가 1500이 넘는 사람들만 조회하고 이름으로 내림차순 정렬되도록 쿼리를 작성하세요.

SELECT *
FROM emp
WHERE deptno IN (10, 30)
  AND sal > 1500
ORDER BY ename DESC;


가상컬럼 ROWNUM 1]
- emp 테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성해보세요.
(정렬없이 진행하세요, 결과는 화면과 다를 수 있습니다.)
-- 정렬없이 진행하려면 뭘 없애야 하는 거지

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;


가상컬럼 ROWNUM 2]
- ROWNUM 값이 11~20(11~14)인 값만 조회하는 쿼리를 작성해보세요. -- emp 테이블은 행이 14개
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 11 AND 14;

SELECT *
FROM (SELECT ROWNUM rn, empno, ename
        FROM emp)
WHERE rn BETWEEN 11 AND 14;


가상컬럼 ROWNUM 3]
- emp 테이블의 사원 정보를 이름컬럼으로 오름차순 적용했을 때의
11~14번째 행을 다음과 같이 조회하는 쿼리를 작성해보세요.
;
SELECT *
FROM (SELECT ROWNUM rn, empno, ename
      FROM
         (SELECT empno, ename
          FROM emp
          ORDER BY ename))
WHERE rn BETWEEN 11 AND 14;


--
- 상여가 0인 사람은 상여가 없는 것으로 간주
-> AND comm != 0

- ROWNUM을 1이 아닌 숫자부터 사용
SELECT *
FROM
    (SELECT ROWNUM rn, empno, ename
    FROM emp)
WHERE rn BETWEEN 11 AND 14;

- ROWNUM 과 순서 있는 컬럼을 사용
SELECT *
FROM (SELECT ROWNUM rn, empno, ename
      FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename))
WHERE rn BETWEEN 11 AND 14;


--=05

FUNCTION DATE 실습 fn1]
1. 2019년 12월 31일을 date형으로 표현
2. 2019년 12월 31일을 date형으로 표현하고 5일 이전 날짜
3. 현재 날짜
4. 현재 날짜에서 3일 전 값

위 4개 컬럼을 생성하여 다음과 같이 조회하는 쿼리를 작성하세요.
(PT 예시는 현재 날짜가 2019/10/24)
;
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY,
       TO_DATE('2019/12/31', 'YYYY/MM/DD') -5 LASTDAY_BEFORE5,
       SYSDATE NOW,
       SYSDATE - 3 NOW_BEFORE3
FROM dual;


Function date 실습 fn2]
오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오.
1. 년-월-일
2. 년-월-일 시간(24)-분-초
3. 일-월-년

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH, 
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME, 
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY 
FROM dual;



날짜 함수 연습1]
'2021-03-17' ==> '2021-03-17 12:41:00'
\\
TO_CHAR(날짜, 포맷팅 문자열)
SELECT TO_CHAR(TO_DATE('2021-03-17', 'YYYY-MM-DD'), 'YYYY-MM-DD HH24:MI:SS')
FROM dual;

where cs_rcv_dt between 
    to_date( to_char(sysdate-5, 'YYYYMMDD') , 'YYYYMMDD') and 
    to_date(to_char(sysdate,'yyyymmdd') || '23:59:59', 'YYYYMMDD hh24:mi:ss')
    
    CONCAT('HELLO', CONCAT(',', 'WORLD'))

SELECT SYSDATE, TO_DATE(TO_CHAR(SYSDATE-5, 'YYYYMMDD'), 'YYYYMMDD')
FROM dual;
\\

SELECT TO_DATE('2021-03-17', 'YYYY-MM-DD')
FROM dual;

SELECT TO_CHAR(TO_DATE('2021-03-17', 'YYYY-MM-DD'), 'YYYY-MM-DD HH24:MI:SS')
FROM dual;
-- 중복해서 사용, 일종의 저번의 CONCAT 개념

-- 현재 날짜의 시, 분, 초 가져오기
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') FROM dual;

SELECT TO_CHAR(TO_DATE('20210506', 'YYYYMMDD')) || ' ' || TO_CHAR(SYSDATE, 'HH24:MI:SS')
FROM dual;

-- //날짜 자리에 바인드변수 적용 불가 ㅠㅠ
    -> 바인드 변수 이름을 :date로 두고 했으니 안 된다!!
    날짜 바인드 변수 이름 : ':YYYYMMDD'
SELECT TO_CHAR(TO_DATE(:YYYYMMDD, 'YYYYMMDD')) || ' ' || TO_CHAR(SYSDATE, 'HH24:MI:SS')
FROM dual;



날짜 함수 연습2] 시분초 시간 0처리
SELECT SYSDATE
FROM dual; -- 현재 날짜 + 시각 같이 출력

SELECT SYSDATE, TO_DATE(TO_CHAR(SYSDATE-5, 'YYYYMMDD'), 'YYYYMMDD')
FROM dual; -- 시분초 시간 0처리

SYSDATE 는 시각이 같이 출력된다 그래서
1. TO_CHAR 사용으로 시분초 출력 X, 'YYYYMMDD' 형태로 문자열로 변환
2. 이후 TO_DATE 사용 -> SYSDATE 를 날짜로 사용할 것이므로
   포맷팅은 TO_CHAR 와 동일하게 'YYYYMMDD'


--
시분초 시간 0 처리
=> SYSDATE -> TO_CHAR -> TO_DATE, 두 함수 다 날짜 포맷형은 'YYYY/MM/DD' 사용 

현재 날짜의 시, 분, 초 가져오기
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') FROM dual;


--=6

FIRST DAY 구하기 연습1]
SYSDATE를 이용하여 SYSDATE가 속한 월의 첫 번째 날짜 구하기
       

=> SYSDATE로 년, 월까지 문자로 구하기 || '01'
     '202103' || '01' ==> '20210301'

       


Function date 종합 실습 fn3]
- 파라미터로 yyyymm 형식의 문자열을 사용해서 (ex. yyyymm = 201912)
해당 년월에 해당하는 일자 수를 구해보세요

yyyymm = 201912 -> 31
yyyymm = 201911 -> 30
yyyymm = 201602 -> 29 (2016년은 윤년)

SELECT :yyyymm --여기서부터 시작
FROM dual;






FUNCTION null 실습 fn4]
- emp 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
(nvl,nvl2,coalesce) 표그림 - 널값에 9999 채워넣기

SELECT empno, ename, mgr, NVL(mgr, 9999) ngr_n, NVL2(mgr, mgr, 9999) mgr_n_1, COALESCE(mgr, 9999) mgr_n_2
FROM emp

SELECT empno, ename, mgr, NVL(mgr, 9999) ngr_n, NVL2(mgr, mgr, 9999) mgr_n_1, COALESCE(mgr, null, 9999) mgr_n_2
FROM emp -- COALESCE 함수가 두 번째 인자 null을 인식 후 세 번째 인자 9999를 값으로 반환했다, 따라서 위 아래 쿼리문 결과는 같다




FUNCTION null 실습 fn5]
- users 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
  reg_dt가 null일 경우 sysdate를 적용

SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) n_reg_dt
FROM users
WHERE userid in ('cony','sally','james','moon'); -- 행이 4행으로 제한되어 있으므로 WHERE 절을 써줘야겠죠



