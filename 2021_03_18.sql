DATE, NULL, CASE_END, DECODE, 
GROUP_FUNCTION5(MIN, MAX, AVG, SUM, COUNT), MOD, ROUND, GROUP_BY
날짜 관련 함수

MONTHS_BETWEEN(start date, end date)  -- 넷 중 이것만 숫자 반환
인자 : start date, end date, 반환값 : 두 일자 사이의 개월 수

ADD_MONTHS(date, number) (***)
인자 : date, number 더할 개월 수 : date로부터 n개월 뒤의 날짜 date

NEXT_DAY(date) (***)
인자 : date, number(weekday, 주간일자)
date 이후의가장 첫 번째 주간일자에 해당하는 date를 반환

LAST_DAY(date) (***) 
인자 : date : date가 속한 월의 마지막 일자를 date 형태로 반환


MONTHS_BETWEEN
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
       ADD_MONTHS(SYSDATE, 5) add_months,
       TO_DATE('2021-02-15', 'YYYY-MM-DD'),
       ADD_MONTHS(TO_DATE('2021-02-15', 'YYYY-MM-DD'), 5),
       -- SQL의 인덱스 1부터 시작 - 1 일요일 2 월요일 ... 6 금요일 7 토요일
       NEXT_DAY(SYSDATE, 6) NEXT_DAY,
       LAST_DAY(SYSDATE) -- 월마다 일수가 다 다르기 때문에 유용
FROM emp;

-- SYSDATE를 이용하여 SYSDATE가 속한 월의 첫 번째 날짜 구하기
       SYSDATE로 년, 월까지 문자로 구하기 || '01'
       '202103' || '01' ==> '20210301'
SELECT TO_DATE('20210301', 'YYYYMMDD'),
       TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM') || '01', 'YYYYMMDD') FIRST_DAY
FROM emp;


       

Function date 종합 실습 fn3]
- 파라미터로 yyyymm 형식의 문자열을 사용해서 (ex. yyyymm = 201912)
해당 년월에 해당하는 일자 수를 구해보세요

yyyymm = 201912 -> 31
yyyymm = 201911 -> 30
yyyymm = 201602 -> 29 (2016년은 윤년)

SELECT :yyyymm --여기서부터 시작
FROM dual;

-
SELECT :yyyymm, 
마지막 날짜 -> LAST_DAY(날짜)
SELECT :YYYYMM, LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM'))
FROM dual;
날짜에서 원하는 부분만 빼내기
SELECT :YYYYMM,
       TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD') DT
FROM dual;
-- 입력값에 따라 바뀌는 유연한 모델 완성

SELECT :YYYYMM, LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM'))
FROM dual;

SELECT :YYYYMM, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD') DT
FROM dual;


형변환
- 명시적 형변환 : TO_DATE, TO_CHAR, TO_NUMBER
- 묵시적 형변환 : 

SELECT *
FROM emp
WHERE empno = '7369';
문자 -> 숫자?
숫자 -> 문자?

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';


오늘 날짜 -> 문자열 -> 날짜
SYSDATE -> TO_CHAR -> TO_DATE
목적 : 시분초를 없애기 위해

SELECT TO_DATE('2021', 'YYYY') -- 서버의 현재시간의 월, 1일, 0시 0분 0초가 기본값으로 들어간다
FROM dual;

SELECT TO_DATE('2021' || '0101', 'YYYYMMDD') -- 문자열을 날짜 형태로 초기화 가능
FROM dual;




EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

FROM TABLE(DBMS_XPALN.DISPLAY);

- 테이블 읽는 방법 // SQLD 시험 단골 문제
1. 위에서 아래로
2. 단, 들여쓰기가 되어 있을 경우(자식 노드), 자식 노드부터 읽는다.

0  A
1*  B
=> 1-0

0  SELECT
1   NESTED
2    TABLE
3*    INDEX
4    TABLE
5*    INDEX

=> 3-2-5-4-1-0


FUNCTION (NUMBER) -- 잘 사용하지는 않음
9: 숫자
0: 강제로 0표시
, : 1000자리 표시
. : 소수점
L : 화폐단위(사용자 지역)
$ : 달러 화폐 표시


NULL 처리 함수 : 4가지, 하나를 알면 연달아 알 수 있는
-- 1 
NVL(expr1, expr2) -- expr - 컬럼이 됐든 값이 됐든 어떤 값
: expr1이 NULL값이 아니면 expr1을 사용하고, expr1이 NULL값이면 expr2로 대체해서 사용한다

if(expr1 == null)
    System.out.println(expr2)
else
    System.out.println(expr1)

emp 테이블에서 comm의 컬럼 값이 NULL일 경우 0으로 대체해서 조회하기
SELECT empno, comm, NVL(comm, 0)
FROM emp;

SELECT empno, comm, NVL(comm, 0), sal, sal+comm, sal+NVL(comm, 0), NVL(sal+comm, 0)
FROM emp;

-- 2
NVL2(expr1, expr2, expr3)
널값을 피하기 위한 방법

if(expr1 != null)
    System.out.println(expr2);
else
    System.out.println(expr3);
    
comm이 null이 아니면 sal+comm을 반환,
comm이 null이면 sal을 반환

SELECT empno, sal, comm, NVL2(comm, sal+comm, sal)
FROM emp;

SELECT empno, sal, comm, NVL2(comm, sal+comm, sal), sal + NVL(comm, 0)
FROM emp;   -- 마지막 두 컬럼은 같은 결과값

-- 3
NULLIF(expr1, expr2)
값이 같으면 널처리 해주기, 일부러 NULL값을 만들어 주는, 잘 쓰지는 않음

if(expr1 == expr2)
    System.out.println(null)
else
    System.out.println(expr1)

SELECT *
FROM emp;

SELECT empno, sal, NULLIF(sal, 1250)
FROM emp;

-- 4
COALESCE(expr1, expr2, expr3, ...) 재귀함수
인자의 개수가 정해져 있지 않다, 개발자가 끝내면 끝인 것

: 인자들 중에 가장 먼저 등장하는 null이 아닌 인자를 반환

if(expr1 != null)
    System.out.println(expr1);
else
    System.out.println(expr2, expr3, ...);

if(expr2 != null)
    System.out.println(expr2);
else
    System.out.println(expr3, ...);

SELECT empno, sal, comm, COALESCE(
FROM emp;


FUNCTION null 실습 fn4]
- emp 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
(nvl,nvl2,coalesce)

SELECT empno, ename, mgr, NVL(mgr, 9999) ngr_n, NVL2(mgr, mgr, 9999) mgr_n_1, COALESCE(mgr, 9999) mgr_n_2
FROM emp;

SELECT empno, ename, mgr, NVL(mgr, 9999) ngr_n, NVL2(mgr, mgr, 9999) mgr_n_1, COALESCE(mgr, null, 9999) mgr_n_2
FROM emp;


FUNCTION null 실습 fn5]
- users 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
  reg_dt가 null일 경우 sysdate를 적용

SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) n_reg_dt
FROM users
WHERE userid in ('cony','sally','james','moon'); -- 행이 4행으로 제한되어 있으므로 WHERE 절을 써줘야겠죠

DESC users;


조건분기
1. CASE 절
    CASE expr1 비교식(참거짓을 판단할 수 있는 수식) THEN 사용할 값     => if
    CASE expr2 비교식(참거짓을 판단할 수 있는 수식) THEN 사용할 값2    => else if
    CASE expr3 비교식(참거짓을 판단할 수 있는 수식) THEN 사용할 값2    => else if
    ELSE 사용할 값 4                                               => else
   END 
    
2. DECODE 함수 => COALESCE 함수처럼 가변인자 사용
-- else if가 몇 개 올지 모르죠.
if()
else if()
else if()
...
else

DECODE (expr1, search1, return1, search2, return2, search3, return3, ... [, default]);

if(expr1 == search1)
    System.out.println(return1)
else if(expr1 == search2)    
    System.out.println(return1)
else if(expr1 == search3)    
    System.out.println(return3)
else
    System.out.println(default)

-- 동등 비교가 아닌, 대소 비교는 DECODE 함수에서 사용 불가능 
-- 하지만 대부분의 비교가 동등이고, 사람들은 CASE END 절보다 DECODE 함수 선호  

DECODE( expr1,
            search1, return1,
            search2, return2,
            search3, return3,
            ....[, defualt])


조건분기 실습

직원들의 급여를 인상하려고 한다
job이 SALESMAN 이면 현재 급여에서 5%를 인상
job이 MANAGER 이면 현재 급여에서 10%를 인상
job이 PRESIDENT 이면 현재 급여에서 20%를 인상

그 이외의 직군은 현재 급여를 유지

SELECT ename, job, sal, 인상된 급여
FROM emp;

SELECT ename, job, sal, 
-- 인상된 급여
-- CASE END 컬럼 한 개의 표현
    CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal -- sal * 1.0
    END raised_sal_CASE,
    DECODE(job, 
            'SALESMAN',sal * 1.05,
            'MANAGER', sal * 1.10,
            'PRESIDENT', sal * 1.20,
            sal * 1.0) raised_sal_DECODE
            -- defalt 값으로 쓰인 sal * 1.0을 작성하지 않으면
            -- null 값이 나온다.
FROM emp;


condition 실습 cond1]
- emp 테이블을 이용하여 deptno에 따라 부서명으로 변경해서
다음과 같이 조회되는 쿼리를 작성하세요

10 -> 'ACCOUNTING'
20 -> 'RESEARCH'
30 -> 'SALES'
40 -> 'OPERATIONS'
기타 다른 값 -> 'DDIT'

SELECT empno, ename, 
       DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname,
       job
FROM emp;
/*
-- 나중에 CASE 함수로도 해보기
       CASE
         WHEN deptno = 10 THEN sal * 1.05
         WHEN deptno = 20 THEN sal * 1.10
         WHEN deptno = 30 THEN sal * 1.20
         WHEN deptno = 40 THEN sal * 1.20
         ELSE 'DDIT' -- sal * 1.0
       END raised_sal_CASE,
*/

SELECT ename, deptno,
  CASE
    WHEN deptno = 10 THEN 'ACCOUNTING'
    WHEN deptno = 20 THEN 'RESEARCH'
    WHEN deptno = 30 THEN 'SALES'
    WHEN deptno = 40 THEN 'OPERATIONS'
    ELSE 'DDIT'
  END changed
FROM emp;


condition 실습 cond2]
- emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진 대상자인지
조회하는 쿼리를 작성하세요. (생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다)
검진 대상자 : 홀수년도 - 홀수해 출생자 / 짝수년도 - 짝수해 출생자

SELECT empno, ename, hiredate, 
       CASE 
         WHEN MOD(TO_CHAR((hiredate, 'YYYY'),2)) = 0 THEN '비대상자'  
         WHEN MOD(TO_CHAR((hiredate, 'YYYY'),2)) = 1 THEN '대상자'
       END CONTACT_TO_DOCTOR
FROM emp;

SELECT empno, ename, hiredate, 
       CASE 
         WHEN MOD(TO_DATE(TO_CHAR(hiredate, 'YYYY')),2) = 0 THEN '비대상자'  
         WHEN MOD(TO_DATE(TO_CHAR(hiredate, 'YYYY')),2) = 1 THEN '대상자'  
       END CONTACT_TO_DOCTOR
FROM emp;


SELECT empno, ename, hiredate, 
    CASE
        WHEN
            MOD(TO_CHAR(hiredate, 'yyyy'), 2) = 
            MOD(TO_CHAR(SYSDATE, 'yyyy'), 2) THEN '대상자'
            -- 0, 1 상수를 쓰게 될 경우 매 년도에 따라 코드를 고쳐야 한다
            -- 그래서 SYSDATE를 이용해 년도가 바뀔 때마다 고치지 않아도 된다
        ELSE '비대상자'
    END CONTACT_TO_DOCTOR,
    DECODE( MOD(TO_CHAR(hiredate, 'yyyy'), 2), 
                            MOD(TO_CHAR(SYSDATE, 'yyyy'), 2), '건강검진 대상자',
                                                                    '건강검진 비대상자') CONTACT_TO_DOCTOR_DECODE
FROM emp;

SELECT empno, ename, hiredate,
    CASE
        WHEN
            MOD(TO_CHAR(hiredate,'yyyy'), 2) =
            MOD(TO_CHAR(SYSDATE,'yyyy'), 2) THEN '대상자'
        ELSE '비대상자'
    END CONTACT_TO_DOCTOR,
    DECODE(MOD(TO_CHAR(hiredate,'YYYY'),2),
           MOD(TO_CHAR(SYSDATE,'YYYY'),2), '대상자', '비대상자')
FROM emp;




condition 실습 cond3]
- users 테이블을 이용하여 reg_dt에 따라 
올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요.
(생년을 기준으로 하나 여기서는 reg_dt를 기준으로 한다)

SELECT userid, usernm, reg_dt, 
    CASE
        WHEN
            MOD(TO_CHAR(reg_dt,'yyyy'),2) = 
            MOD(TO_CHAR(SYSDATE, 'yyyy'), 2) THEN '대상자'
        ELSE '비대상자' 
    END "contact to doctor" -- 관사...
FROM users
WHERE userid IN ('brown', 'cony', 'james', 'moon', 'sally');


-- 교육공학 - 메타인지, 내가 무엇을 알고 모르는가 ...
-- 여기까지가 싱글 로우 함수
-- 이제부터 그룹 함수 


GROUP FUNCTION 
: 여러 행을 그룹으로 하여 하나의 행으로 결과값을 반환하는 함수
ex. 부서별 조직원수 
ex. 부서별 가장 높은 급여
ex. 부서별 급여 평균

-- 전부 중요 **********
AVG : 평균
COUNT : 건수
MAX : 최대값
MIN : 최소값
SUM : 합
-- *******************


10 , 5000
20, 3000
30, 2850

SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno;

SELECT deptno, MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), 
               COUNT(sal), -- 그룹핑된 행 중에 sal 컬럼의 값이 NULL이 아닌 행의 건수
               COUNT(mgr), -- 그룹핑된 행 중에 mgr 컬럼의 값이 NULL이 아닌 행의 건수
               COUNT(*) -- 그룹핑된 행 건수
FROM emp
GROUP BY deptno;


14
-- GROUP BY를 사용하지 않을 경우 테이블의 모든 행을 하나의 행으로 그룹핑한다.
SELECT COUNT(*), MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal)
FROM emp;

SELECT COUNT(*), MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal)
FROM emp
GROUP BY deptno;


-- GROUP BY 절에 나온 컬럼이 SELECT절에 그룹함수가 적용되지 않은 채로 기술되면 에러
-- 그룹핑을 할 수 없음, 공통점이 없는 2개를 묶어서?
SELECT deptno, empno, MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno; 

-- 에러X
SELECT deptno,
        MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno; 


SELECT deptno, 'TEST', 100,
        MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*),
        SUM(NVL(comm, 0)), -- 이렇게 널처리 해주지 않아도 ㄱㅊ
        NVL(SUM(comm, 0)) -- 위와 아래 중 아래가 더 효율적, 아래는 널처리를 1번만 하는데, 위는 널 처리를 매 행마다 한다
FROM emp

-- WHERE LOWER(ename) = 'smith'  
      -- COUNT(*) >= 4 -- 에러
GROUP BY deptno, -- null과의 연산인데도 값이 무시됨, GROUP BY 에서 알아서...
HAVING COUNG(*) >= 4; -- 자꾸 에러남


Group function
- 그룹 함수에서 B@null 컬럼은 계산에서 제외된다@B
group by 절에 작성된 컬럼 이외의 컬럼이 select 절에 올 수 없다
where 절에 그룹 함수를 조건으로 사용할 수 없다
- having 절 사용
where sum(sal) > 3000 (X)
having sum(sal) > 3000 (O)


Function group function 실습 grp1]
- emp 테이블을 이용하여 다음을 구하시오
    직원 중 가장 높은 급여
    직원 중 가장 낮은 급여
    직원의 급여 평균 (소수점 두 자리까지 나오도록 반올림)
    직원의 급여 합
    직원 중 급여가 있는 직원의 수 null 제외
    직원 중 상급자가 있는 직원의 수 null 제외
    전체 직원의 수

SELECT 
FROM emp


grp 1]
SELECT MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp; -- mgr에는 널 값이 1개 있기 때문에 sal보다 1이 적다

Function group function 실습 grp2]
SELECT  deptno, MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;


grp2]
SELECT  deptno, MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;









