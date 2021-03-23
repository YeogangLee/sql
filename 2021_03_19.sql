grp3]
SELECT
    CASE
    WHEN deptno = 10 THEN 'ACCOUNTING'
    WHEN deptno = 20 THEN 'RESEARCH'
    WHEN deptno = 30 THEN 'SALES'
    WHEN deptno = 40 THEN 'OPERATIONS'
    ELSE 'DDIT'
  END dname, sal
FROM emp;
--GROUP BY deptno;

deptno, MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp


grp4]
- emp 테이블을 이용하여 다음을 구하시오
직원의 입사 년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성

SELECT TO_CHAR(hiredate, 'yyyymm') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm')
ORDER BY TO_CHAR(hiredate, 'yyyymm');


grp5]
SELECT TO_CHAR(hiredate, 'yyyy') hire_yyyy, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyy')
ORDER BY TO_CHAR(hiredate, 'yyyy');


grp6]
SELECT COUNT(*)
FROM dept;

grp7]
- 직원이 속한 부서의 개수를 조회하는 쿼리, emp 테이블 사용

SELECT COUNT(*)
FROM
(SELECT deptno
FROM emp
GROUP BY deptno);
-- 인라인 뷰를 사용하면 안에 있는 데이터들은 궁금해하지 않는다.


#데이터 결합
JOIN
- RDBMS는 "중복을 최소화"하는 형태의 데이터베이스
- 다른 테이블과 결합하여 데이터를 조회
-- JOIN이 없는 쿼리는 없다

부서명 변경으로 직원의 정보를 수정해야 하는 상황
-> 테이블을 분리하여 저장하는 경우, 
직원의 정보를 일일이 변경할 필요 없이
부서테이블의 부서명만 변경하면 된다
(직원 테이블의 deptno), (부서테이블의 deptno)로 연결된 상황
-> emp 테이블과 dept 테이블의 연결고리(deptno)로 조인하여 실제 부서명을 조회한다

데이터를 확장(결합)
1. 컬럼에 대한 확장 : JOIN
2. 행에 대한 확장 : 집합 연산자(UNION ALL, UNION;합집합, MINUS;차집합, INTERSECT;교집합)


JOIN
1. 표준 SQL
-- 정형vs비정형 데이터 비교하며 표준SQL 언급했었다.
2. 비표준 SQL - DBMS 회사에서 만든 고유의 SQL 문법 -- 개발자들이 선호, 간단해서

2개를 다 알려드릴 것, 근데 종류가 많아서 헷갈릴 거다.
그래서 하나하나 알지 않아도 된다. 
-> 하나로 커버할 수 있는 것을 주로 공부할 것, 나머지는 그런 문법이 있구나

ANSI 미국 국가표준 협회, 비영리기관
ECMA 스크립트 - 6주 뒤에 배울 자바스크립트, 유럽 표준 ...

ANSI : SQL
ORACLE : SQL

ANSI- NATURAL JOIN
- 조인하고자 하는 테이블의 연결 컬럼명, 타입이 동일한 경우
  ex. (emp.deptno, dept.deptno)
- 연결 컬럼의 값이 동일할 때(=) 컬럼이 확장된다

SELECT ename, dname
FROM emp NATURAL JOIN dept;

SELECT emp.empno, emp.ename, deptno -- 연결고리 컬럼(deptno)의 경우는 "한정자"를 쓸 수 없다.
FROM emp NATURAL JOIN dept;         -- 한정자 내용 0316 내용 참고


-- 오라클 조인은 딱 하나
ORACLE join :
1. FROM 절에 조인할 테이블을 (,) 콤마로 구분하여 나열 
2. WHERE : 조인할 테이블의 연결조건을 기술
-- WHERE : 행에 대한 제한, 두 테이블의 연결 조건

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;
-- WHERE deptno = deptno; -- 어떤 테이블의 deptno인지 알 수 없다.
-- "column ambiguously defined" - 컬럼이 모호하게 정의되어 있습니다.

연산 결과 deptno, deptno_1 이렇게 중복되어 나온다

// 이 방법이 유일한 오라클 조인

7369 SMITH, 7902 FORD
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m -- 동일한 한정자, 정상적 조회 X 이럴때 필요 -> 테이블 별칭
                  -- 테이블 별칭은 ALIAS 키워드를 쓸 수 없는 특징이 있다. 생략된 상태로 사용
WHERE e.mgr = m.empno;
-- mgr에 null 값이 존재하므로 결과에 포함되지 않는다.


ANSI SQL : JOIN WITH USING -- 추가적인 부분
JOIN 하려고 하는 테이블의 컬럼명과 타입이 같은 컬럼이 두 개 이상일 때
두 컬럼을 모두 조인 조건으로 참여시키지 않고, 개발자가 원하는 특정 컬럼으로만 연결을 시키고 싶을 때 사용

SELECT *
FROM emp JOIN dept USING(deptno);

-- 오라클 문법
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;


-- 위의 애들 커버 **
JOIN WITH ON : 
NATURAL JOIN, JOIN WITH USING 을 대체할 수 있는 보편적인 문법
조인 컬럼 조건을 개발자가 임의로 지정

SELECT 
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

차이점 :
오라클은 JOIN 이 없고, ANSI에서 JOIN WITH ON 이 쓰이는 부분인 FROM을 WHERE절이 대신한다


사원 번호, 사원 이름, 해당 사원의 상사 사번, 해당 사원의 상사 이름 
: JOIN WITH ON 을 이용하여 쿼리 작성

-- 이걸 수정
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

(단 사원번호가 7369에서 7698인 사원들만 조회)
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;


SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno
AND e.empno BETWEEN 7369 AND 7698;
-- 위 아래 같은 결과
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.empno BETWEEN 7369 AND 7698
AND  e.mgr = m.empno;


오라클의 실행계획을 보기 전까지는
쿼리문이 어떻게 풀리겠다 아는 것은 어렵다. 실행 순서, 어디부터 읽어올지 등
OPIMIZER
RULE BASE OPTIMIZER(1~15)
최근 -> COST BASE OPTIMIZER 비용 기반, 각종 상황을 고려해서 예측 어려움


논리적인 조인 형태
1. SELF JOIN : 조인 테이블이 같은 경우
- 계층구조(회사 내 직원들의 계급)
2. NONEQUI-JOIN : 조인 조건이 =(equals)가 아닌 조인 -- 이해 중요 **
SQL은 논리적인 사고를 주로 필요로 한다               -- 생각보다 많이 쓰이니 알아둬라.

-- 시험 제출]
SELECT *
FROM emp, dept
-- WHERE emp.deptno = dept.deptno;
WHERE emp.deptno != dept.deptno; -- 부서번호가 다를 때 연결해라
-- 속하지 않은 부서와 연결하면 14 * 3 = 42, 결과는 42건
-- 이상할 수 있지만 문법적으로 문제가 없고 실제로 쓰이는 경우가 있다.


SELECT *
FROM salgrade; 


-- selgrage를 이용하여 직원의 급여 등급 구하기
-- empno, ename, sal, 급여 등급
-- ansi, oracle

SELECT *
FROM emp;

-- X 틀림
SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e JOIN salgrade s ON (e.sal = s.grade);

-- ORACLE
SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;

-- 이러한 조건을 만들어 낼 수 있어야 한다. 
-- 연습을 통해, 엑셀, 수학문제 손으로 푸는 것처럼

-- ANSI
SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e JOIN salgrade s ON (e.sal BETWEEN s.losal AND s.hisal);


데이터 결합 실습 join0]
- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
ORDER BY deptno;

                     -- deptno 가 정확히 어디 테이블에 소속됐는지 모호해서 에러
SELECT empno, ename, emp.deptno, dname -- emp. 한정자를 적어주면 에러 X
FROM emp, dept
WHERE emp.deptno = dept.deptno;


데이터 결합 실습 join0_1]
- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성
부서번호가 10, 30인 데이터만 조회

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno IN (10, 30)
AND dept.deptno IN (10,30); -- 조건 하나만 작성해도 문제 없다


데이터 결합 실습 join0_2]
- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리 작성
급여가 2500 초과

SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.sal > 2500;


데이터 결합 실습 join0_3]
- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리 작성
급여 2500 초과, 사번이 7600보다 큰 직원

SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal > 2500 
AND empno > 7600
ORDER BY empno;


데이터 결합 실습 join0_4]
- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리 작성
급여 2500 초과, 사번이 7600보다 크고, RESEARCH 부서에 속하는 직원

SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal > 2500 
AND empno > 7600
AND dname = 'RESEARCH'
-- AND emp.deptno = 20; -- 같은 결과



