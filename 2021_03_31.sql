분석함수 window 실습 ana2]

- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인 급여, 부서번호와
해당 사원이 속한 부서의 급여 평균을 조회하는 쿼리를 작성하세요 (급여 평균은 소수점 둘째 자리까지)


분석함수인지 아닌지 알 수 있는 키워드
: OVER()


SELECT empno, ename, sal, deptno,
       ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
       -- 해당 부서의 가장 낮은 급여
       -- 해당 부서의 가장 높은 급여
       -- COUNT(*) OVER (PARTITION BY deptno) cnt 
FROM emp;


SELECT empno, ename, sal, deptno,
       ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal,
       MIN(sal) OVER (PARTITION BY deptno) min_sal,
       MAX(sal) OVER (PARTITION BY deptno) max_sal,
       SUM(sal) OVER (PARTITION BY deptno) sum_sal,
       COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;
-- GROUP BY 를 사용하지 않고도 이렇게 조회할 수 있다


분석 함수 / window 함수 (그룹 내 행 순서)
- LAG(col) 이전 행의 컬럼 값
- LEAD(col) 이후 행의 컬럼 값


연습]
SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC;

- 자신보다 급여 순위가 한 단계 낮은 사람의 급여를 5번째 컬럼으로 생성

SELECT empno, ename, hiredate, sal,
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate)
FROM emp
ORDER BY sal DESC;


분석 함수 / window 함수
그룹 내 행 순서 실습 ana5]
- window function 을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여,
전체 사원 중 급여 순위가 1단계 높은 사람의 급여를 조회하는
쿼리를 작성하세요 (급여가 같을 경우 입사일이 빠른 사람이 높은 순위)

SELECT empno, ename, hiredate, sal,
        LAG(sal) OVER (ORDER BY sal DESC, hiredate)
FROM emp
ORDER BY sal DESC;


실습 ana5_1] 분석 함수 사용X
- window function 을 이용하지 않고, 모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여,
전체 사원 중 급여 순위가 1단계 높은 사람의 급여를 조회하는
쿼리를 작성하세요 (급여가 같을 경우 입사일이 빠른 사람이 높은 순위)

SELECT empno, ename, hiredate, sal,
        ROW_NUMBER() OVER(ORDER BY sal DESC, hiredate) sal_row_number
FROM emp
ORDER BY sal DESC, hiredate;

-- 1단계 : 각 행에 행 번호row number 부여
-- SELECT 절에 바로 ROWNUM을 사용할 수는 있지만
-- 원하는 결과가 나오지 않을 수 있다

SELECT *
FROM
(SELECT a.*, ROWNUM rn
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a) a,
(SELECT a.*, ROWNUM rn
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a) b
WHERE a.rn-1 = b.rn;

-- 정렬 조건 하나 더 추가 후, 필요한 데이터만
SELECT a.empno, a.ename, a.hiredate, a.sal, b.sal
FROM
(SELECT a.*, ROWNUM rn
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a) a,
(SELECT a.*, ROWNUM rn
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a) b
WHERE a.rn-1 = b.rn(+)
ORDER BY a.sal DESC, a.hiredate;


그룹내 행 순서 실습 ana6]
- window function 을 이용해서 모든 사원에 대해 사원번호, 사원이름, 입사일자, 직군job, 급여 정보와
담당업무JOB 별 급여 순위가 1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요.
(급여가 같을 경우 입사일이 빠른 사람이 높은 순위)

SELECT empno, ename, hiredate, job, sal,
        LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) job_sal
FROM emp;


분석함수 OVER ([] [] [])

LAG, LEAD 함수의 두 번째 인자 : 이전, 이후 몇 번째 행을 가져올지 표기
SELECT empno, ename, hiredate, job, sal,
        LAG(sal,2) OVER (ORDER BY sal DESC, hiredate) "sal-second"
FROM emp;


그룹내 행 순서 - 생각해보기, 
실습 no_ana3]
모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여를 급여가 낮은 순으로 조회하고,
급여가 동일할 경우 입사일을 기준으로 조회

급여의 누적합을 ... 조회하는 쿼리를 작성하세요.

-- HINT : rownum, 범위조인

SELECT empno, ename, hiredate, job, sal,
        LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) job_sal
FROM emp;

SELECT empno, ename, hiredate, sal,
        ROW_NUMBER() OVER(ORDER BY sal DESC, hiredate) sal_row_number
FROM emp
ORDER BY sal DESC, hiredate;

- 인라인뷰 만들기
(SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno) a


SELECT a.empno, a.ename, a.sal, SUM(b.sal)
FROM
(SELECT a.*, ROWNUM rn
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno) a) a,
(SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno) a) b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;


SELECT empno, ename, sal, SUM(sal) OVER() c_sum
FROM emp;

1. ROWNUM
2. INLINE VIEW
3. NON-EQUI-JOIN
4. GROUP BY

엑셀로 그려봐라. 색칠해라.

SELECT empno, ename, sal, SUM(sal) OVER() c_sum
FROM emp
ORDER BY sal, empno;


분석함수() OVER ([PARTITION] [ORDER] [WINDOWING])
WINDOWING : 윈도우 함수의 대상이 되는 행을 지정
UNBOUNDED PRECEDING : 특정 행을 기준으로 모든 이전행(LAG)
    n PRECEDING : 특정 행을 기준으로 N행 이전행(LAG)
CURRENT ROW : 현재행, 현재 자기 자신
UNBOUNDED FOLLOWING : 특정 행을 기준으로 모든 이후행(LEAD)
    n FOLLOWING : 특정 행을 기준으로 N행 이후행(LEAD)


분석함수() OVER ([] [ORDER] [WINDOWING])    
SELECT empno, ename, sal, SUM(sal) OVER (ORDER BY sal, empno) c_sum
FROM emp
ORDER BY sal, empno;


분석함수() OVER ([] [ORDER] [WINDOWING])    
SELECT empno, ename, sal, 
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum, -- 하지만 이걸 추천, 명확하니까.
    SUM(sal) OVER (ORDER BY sal, empno ROWS UNBOUNDED PRECEDING) c_sum -- 위아래 같은 컬럼값, 현재행이 기본 설정 되어 있다
FROM emp
ORDER BY sal, empno;
-- 아래 쿼리보다 이 쿼리를 많이 쓴다. 누적합.

SELECT empno, ename, sal, 
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum,
    SUM(sal) OVER (ORDER BY sal, empno ROWS UNBOUNDED PRECEDING) c_sum
FROM emp
ORDER BY sal, empno;


그룹내 행 순서 실습 ana7]
- 사원번호, 사원이름, 부서번호, 급여 정보를 부서별로 급여, 사원번호, 오름차순으로 정렬했을 때
자신의 급여와 선행하는 사원들의 급여 합을 조회하는 쿼리를 작성하세요 / window 함수 사용

SELECT empno, ename, deptno, sal, 
    SUM(sal) OVER ([PARTITION BY deptno] [ORDER BY sal, empno] [ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW]) c_sum, 
    SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp
ORDER BY sal, empno;


범위 설정 WINDOWING - rows와 range
- rows 물리적인 row
- range 논리적인 값의 범위

ROWS 와 RANGE 의 차이
SELECT empno, ename, sal,
        SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_c_sum,
        SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_c_sum,
        SUM(sal) OVER (ORDER BY sal) no_win_c_sum, -- ORDER BY 이후 윈도윙 없을 경우 기본 설정 : RANGE UNBOUNDED PRECEDING
        SUM(sal) OVER () no_ord_c_sum
FROM emp
ORDER BY sal, empno;


range에서는 중복되는 1250값을 하나의 값으로 취급 -> 1250을 더하지 않고, 0을 더해줌
range_c_sum 컬럼, no_win_c_sum 컬럼
: windowing을 적용하지 않으면 기본적으로 range unbounded preceding 값이 들어간다.


수업시간에 다루지 않은 분석함수
RATIO_TO_REPORT
PERCENT_RANK
CUME_DIST
NTILE
자격증]에 관심이 있으면 봐두기


DESC emp;
