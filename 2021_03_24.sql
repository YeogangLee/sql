-- SQL 성취도 평가 리뷰

SMITH 가 속한 부서에 있는 직원들을 조회하기
=> 20번 부서에 속하는 직원들 조회하기 
-- -> 하드코딩, 만약 SMITH가 부서 이동을 한다면?

방법
1. SMITH 가 속한 부서번호를 알아낸다
2. 1번에서 알아낸 부서번호로 해당 부서에 속하는 직원을 emp 테이블에서 검색한다

1. 부서번호 = 20
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

2. 같은 부서 직원 조회
SELECT *
FROM emp
WHERE deptno = 20;


서브 쿼리 이용 SUB QUERY
: 쿼리의 결과를 다른 쿼리에 들고와서 사용

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');

-- 쿼리의 어디에서도 20이라는 값은 나오지 않음
-- 문제에도 마찬가지로 값이 나오지 않았다 -> 값을 직접적으로 쓰지 않는 게 더 적합한 방법이다.                
                
            --  WHERE ename = 'SMITH' OR ename = 'ALLEN');
            --  IN 키워드로 해결 가능
=>
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH' OR ename = 'ALLEN');


SUBQUERY : 쿼리의 일부로써 사용되는 쿼리

1. 사용 위치에 따른 분류
- SELECT : 스칼라 서브 쿼리 - 서브쿼리의 실행결과가 1개의 행, 1개의 컬럼을 반환하는 쿼리
- FROM : 인라인 뷰
- WHERE : 서브쿼리
            - 메인쿼리의 컬럼을 가져다가 사용할 수 있다
            - 반대로 메인쿼리에서 서브쿼리의 컬럼을 가져가서 사용할 수 없다

2. 반환 값에 따른 분류 (행, 컬럼의 개수에 따른 분류)
- 행 - 다중행, 단일행, 
  컬럼 - 단일컬럼, 복수컬럼
  : 종류는 총 2x2=4가지
  
- 다중행 단일 컬럼 (IN, NOT IN)
- 다중행 복수 컬럼 (PAIRWISE)
- 단일행 단일 컬럼
- 단일행 복수 컬럼
-- 단일행은 크게 의미가 없다 ...
  
3. main-sub query 의 관계에 따른 분류
- 상호 연관 서브 쿼리(correlated subquery) 
  : 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓴 경우
  ==> 메인쿼리가 없으면 -> 서브쿼리만 실행 !불가능!

- 비상호 연관 서브 쿼리(non-correlated subquery) 
  : 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓰지 !않은! 경우
  ==> 메인쿼리가 없어도, 서브쿼리만 실행 가능 -- 위에 코드에서 IN 뒤 괄호 안(= 서브쿼리)만 실행해도 실행 가능
    


서브쿼리 실습 sub1]
-- 평균 급여보다 높은 급여를 받는 직원의 수를 조회하세요.

SELECT AVG(sal)
FROM emp;

SELECT *
FROM emp
WHERE sal >= 2073;
    
SELECT COUNT(*)
FROM emp
WHERE sal >= 2073;

SELECT COUNT(*)
FROM emp
WHERE sal >= (SELECT AVG(sal)
              FROM emp);
              
    
서브쿼리 실습 sub2]
-- 평균 급여보다 높은 급여를 받는 직원의 정보를 조회

-- sub2]
SELECT *
FROM emp
WHERE sal >= (SELECT AVG(sal)
                FROM emp);

SELECT *
FROM emp
WHERE sal >= (SELECT AVG(sal) FROM emp)
  AND deptno IN (SELECT deptno FROM emp);
-- AND 뒤의 조건이 항상 참이라 결과는 sub2] 쿼리와 동일


SELECT deptno, AVG(sal)
FROM emp
WHERE deptno IN (SELECT deptno FROM emp )
GROUP BY deptno
ORDER BY deptno;


SELECT AVG(sal)
FROM emp
WHERE deptno = 10;



서브쿼리 실습 sub3]
- SMITH 와 WARD 사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를 다음과 같이 작성하세요

SELECT *
FROM emp m
WHERE m.deptno IN (SELECT s.deptno
                  FROM emp s
                  WHERE s.ename IN ('SMITH', 'WARD'));

-- 별칭 안 써도 실행 가능
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                  FROM emp
                  WHERE ename IN ('SMITH', 'WARD'));


MULTI ROW 연산자
 IN : = + OR
 비교 연산자 ANY
 비교 연산자 ALL
 
SELECT *
FROM emp e
WHERE sal < ANY(
                SELECT s.sal
                FROM emp s
                WHERE s.ename IN ('SMITH', 'WARD')
                );
                
직원 중에 급여값이 SMITH(800) 나 WARD(1250) 의 급여보다 작은 직원을 조회
==> 직원 중에 급여값이 1250보다 작은 직원 조회

-- ANY 키워드는 아래처럼 대체 가능하므로, 크게 강조하고 싶지 않다
SELECT *
FROM emp e
WHERE sal < (   SELECT MAX(s.sal)
                FROM emp s
                WHERE s.ename IN ('SMITH', 'WARD')
            );


직원의 급여가 800보다 작고 1250보다 작은 직원 조회
    ==> 직원의 급여가 800보다 작은 직원 조회

SELECT *
FROM emp e
WHERE e.sal < ALL(  SELECT s.sal
                    FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'));
-- ALL 키워드 대체                    
SELECT *
FROM emp m
WHERE m.sal < (SELECT MIN(s.sal)
             FROM emp s
             WHERE s.ename IN ('SMITH', 'WARD'));
                    
상호, 비상호 구분 기준 : 단독 실행 가능 여부                


SUBQUERY 사용시 !주의점 NULL 값
IN ()
NOT IN ()

-- IN
SELECT *
FROM emp
WHERE deptno IN (10, 20);
WHERE deptno IN (10, 20, NULL);
==> deptno = 10 OR deptno = 20 OR deptno = NULL;
                               OR     FALSE
-- NOT IN                                    
SELECT *
FROM emp
WHERE deptno NOT IN (10, 20, NULL);
==> !(deptno = 10 OR deptno = 20 OR deptno = NULL);
==> deptno != 10 AND deptno != 20 AND deptno != NULL);
                                  AND     FALSE
                                  
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM   emp);
-- 이것도 비상호 연관 서브 쿼리
-- null 값이 조회가 되는 행이 있는 경우 조회 불가
-- 나중에 실무하며, NOT IN 을 사용 후 결과가 나오지 않는다 -> 서브쿼리에 NULL 값이 있는지 확인


-- 2번째 시험 문제]
-- 직원들 중 매니저가 아닌 직원들의 조회 쿼리
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, 9999)
                    FROM   emp);    -- 8행 조회
                    
7844	TURNER	SALESMAN	7698ㅇ	1981/09/08 00:00:00	1500	0	30
7521	WARD	SALESMAN	7698ㅇ	1981/02/22 00:00:00	1250	500	30
7654	MARTIN	SALESMAN	7698ㅇ	1981/09/28 00:00:00	1250	1400	30
7499	ALLEN	SALESMAN	7698ㅇ	1981/02/20 00:00:00	1600	300	30
7934	MILLER	CLERK	7782ㅇ	1982/01/23 00:00:00	1300		10
7369	SMITH	CLERK	7902ㅇ	1980/12/17 00:00:00	800		20
7876	ADAMS	CLERK	7788ㅇ	1983/01/12 00:00:00	1100		20
7900	JAMES	CLERK	7698ㅇ	1981/12/03 00:00:00	950		30                    


-- 직원들 중 매니저인 직원들의 조회 쿼리                    
SELECT *
FROM emp
WHERE empno IN (SELECT NVL(mgr, 9999)
                FROM   emp);    -- 6행 조회
                
7902ㅇ	FORD	ANALYST	7566ㅇ	1981/12/03 00:00:00	3000		20
7698ㅇ	BLAKE	MANAGER	7839ㅇ	1981/05/01 00:00:00	2850		30
7839ㅇ	KING	PRESIDENT		1981/11/17 00:00:00	5000		10
7566ㅇ	JONES	MANAGER	7839ㅇ	1981/04/02 00:00:00	2975		20
7788ㅇ	SCOTT	ANALYST	7566ㅇ	1982/12/09 00:00:00	3000		20
7782ㅇ	CLARK	MANAGER	7839ㅇ	1981/06/09 00:00:00	2450		10                
              



PAIRWISE : 순서쌍

SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
                FROM emp
               WHERE empno IN (7499, 7782))
  AND deptno IN (SELECT deptno
                   FROM emp
                  WHERE empno IN (7499, 7782));

-- ALLEN(30, 7698), CLARK(10, 7839)
SELECT ename, mgr, deptno
  FROM emp
 WHERE empno IN (7499, 7782);
 
SELECT *
FROM emp
WHERE mgr IN (7698, 7839)
  AND deptno IN (10, 30);
=> mgr, deptno
7698 10 / 7698 30 / 7839 10 / 7939 30
   X         O         O         X
   
요구사항] : ALLEN 또는 CLARK 의 소속 부서번호와 같으면서 상사도 같은 직원들을 조회

=> PAIRWISE를 사용하면 원하는 순서쌍만 조회 가능 (위의 불필요한 1,4 데이터 조회X), 문법적으로는 쉽다
   실무하다가 언젠가 나올테니 기억, 기억 안나면 그때 가서 ORACLE PAIRWISE, NON PAIRWISE 검색해보세요
   
SELECT mgr, deptno
FROM emp
WHERE ename IN ('ALLEN', 'CLARK');

-- ORACLE
SELECT mgr, deptno
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE ename IN ('ALLEN', 'CLARK'));
                    

DISTINCT 가 쓰이는 경우
1. 설계가 잘못되 경우
2. 개발자가 SQL을 잘 작성하지 못하는 사람인 경우
3. 요구사항이 이상한 경우


스칼라 서브쿼리 
: SELECT 절에 사용된 쿼리, 1개의 행, 1개의 컬럼을 반환하는 서브쿼리
  잘못 쓰면 성능에 영향이 가므로, 남용 금지
  
-- ex.
SELECT empno, ename, SYSDATE
FROM emp;

SELECT SYSDATE
FROM dual; -- dual : 함수 조회할 때 많이 사용

SELECT empno, ename, (SELECT SYSDATE FROM dual)
FROM emp; -- 첫 번째 쿼리와 결과 동일

SELECT empno, ename, (SELECT SYSDATE, SYSDATE FROM dual) -- 여기 
FROM emp; -- 컬럼 2개 : 스칼라 서브쿼리 조건 불만족, 해당 실행 X, 단, 서브쿼리 혼자는 실행 가능


emp 테이블에는 해당 직원이 속한 부서번호는 관리하지만,
해당 부서명 정보는 dept 테이블에만 있다
-> 해당 직원이 속한 <부서 이름>을 알고 싶으면 dept 테이블과 조인을 해야 한다

SELECT empno, ename, deptno
FROM emp;

SMITH : SELECT dname FROM dept WHERE deptno = 20;
ALLEN : SELECT dname FROM dept WHERE deptno = 30;
CLARK : SELECT dname FROM dept WHERE deptno = 10;

SELECT empno, ename, deptno, (SELECT dname FROM dept WHERE deptno = 20)
FROM emp;                                                  -- 현재 20이라는 값으로 고정이 돼 있음

SELECT empno, ename, deptno, 
        (SELECT dname FROM dept WHERE dept.deptno = emp.deptno)
FROM emp;

상호연관 서브쿼리는 항상 메인 쿼리가 먼저 실행된다. - 순서 보장
비상호연관 서브쿼리는 순서 보장 X

비상호연관 서브쿼리는 메인쿼리가 먼저 실행될 수도 있고
                   서브쿼리가 먼저 실행될 수도 있다
                   => 성능측면에서 유리한 쪽으로 오라클이 선택

SELECT empno, ename, deptno
FROM emp; -- 여기까지 행 개수 14번 실행

SELECT empno, ename, deptno, 
        (SELECT dname FROM dept WHERE dept.deptno = emp.deptno)
FROM emp; -- 여기까지 메인쿼리 1번 + 행 개수 14 = 총 15번 실행

SELECT empno, ename, deptno, 
        (SELECT dname FROM dept WHERE dept.deptno = emp.deptno),
        (SELECT dname FROM dept WHERE dept.deptno = emp.deptno)
FROM emp; -- 여기까지 메인쿼리 1번 + 행 개수 14 + 행 개수 14 = 총 29번 실행


JOIN 에 대한 두려움으로, 스칼라 서브쿼리 막 쓰지 말 것

SQL이 어려운 이유는 
=> 1. 눈에 보이는 게 전부가 아니고, 
   2. 절차가 있는데 그 절차는 ORACLE이 결정하는 절차
   

인라인 뷰 : SELECT QUERY 
- inline : 해당 위치에 직접 기술함
  inline view : 해당 위치에 직접 기술한 view
  view : SELECT QUERY
  view : QUERY(O) ==> view table(X), 연세 있으신 분들이 이렇게 설명하면 알아서 필터링해서 듣기
  @@ 뷰는 쿼리이지 테이블이 아니다. @@ - 쿼리를 빠르게 하려면 뷰를 써야 한다? X, 빨리? -> 뷰를 잘 작성
  
ex.
(SELECT deptno, ROUND(AVG(sal), 2)
 FROM emp
 GROUP BY deptno)

SELECT *
FROM (SELECT deptno, ROUND(AVG(sal), 2)
      FROM emp
      GROUP BY deptno);
      


-- 아까의 sub2]와 비슷한 실습 문제
아래 쿼리는 직원 전체의 급여 평균보다 높은 급여를 받는 직원을 조회하는 쿼리

SELECT *
FROM emp
WHERE sal >= (SELECT AVG(sal)
                FROM emp);

-- 상호 연관, 비상호 연관 개념을 알기 위한 좋은 예제]
이제는, 직원이 속한 부서의 급여 평균보다 높은 급여를 받는 직원을 조회

비교 대상은 동일하다

SELECT empno, ename, sal, deptno
FROM emp;

일단 20번 부서의 급여 평균을 구해야 한다
-- 이게 올바른 방식
SELECT AVG(sal)
FROM emp
WHERE deptno = 20;

-- 이렇게 꼬는(불필요한 데이터까지 조회하는) 방식을 사용하지 마세요
SELECT deptno, AVG(sal)
FROM emp
GROUP BY deptno;

20번 부서의 급여 평균 (2175)
SELECT AVG(sal)
FROM emp
WHERE deptno = 20;

10번 부서의 급여 평균 (2916.666)
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;


SELECT empno, ename, sal, deptno
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp
             WHERE deptno = 20 ); -- 메인, 서브 같은 emp 테이블을 조회 -> 한정자 emp.deptno 소용X -> 별칭 사용

-- 별칭 사용
SELECT empno, ename, sal, deptno
FROM emp e
WHERE e.sal > (SELECT AVG(sal)
             FROM emp a
             WHERE a.deptno = e.deptno );


-- 서브쿼리의 컬럼을 메인쿼리에 가져가서 사용할 수 없다
SELECT e.empno, e.ename, e.sal, e.deptno, a.avg_sal -- a는 FROM 절에 사용된 테이블이 아니므로 오류
FROM emp e
WHERE e.sal > (SELECT AVG(sal) avg_sal
             FROM emp a
             WHERE a.deptno = e.deptno );
             
-- 비효율적이지만 요구사항을 만족시키는 유형
SELECT e.empno, e.ename, e.sal, e.deptno, 
            (SELECT AVG(sal) avg_sal
             FROM emp a
             WHERE a.deptno = e.deptno )
FROM emp e
WHERE e.sal > (SELECT AVG(sal) avg_sal
             FROM emp a
             WHERE a.deptno = e.deptno );

             
             
1. 서브쿼리에서 메인 쿼리를 참조
2. 서브쿼리 혼자 실행 불가능
==> 상호연관은 항상 쿼리 실행 순서-절차가 있다 
  
-- 데이터 확인 해보기, 정말 30번 부서는 1600보다 평균 급여가 낮은지                
SELECT AVG(sal)
FROM emp
WHERE deptno = 30;
                
                
deptno, dname, loc
-- INSERT INTO dept VALUES (99, 'ddit', 'dasjeon');
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;                

-- 추가된 행 확인
SELECT *
FROM dept;


서브쿼리 실습 sub4]
- dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없음
직원이 속하지 않은 부서를 조회하는 쿼리를 작성해 보세요.

-- 여기서 시작
SELECT *
FROM dept
WHERE ???;

직원이 속하지 않은 부서 ==> 우리가 알 수 있는 건 직원이 속한 부서

-- 직원이 속한 부서
SELECT deptno
FROM emp;

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);



서브쿼리 실습 5]
- cycle, product 테이블을 이용하여 
cid = 1인 고객이 애음하지 않는 제품을 조회하는 쿼리를 작성하세요.

PID     PNM


sub5]
-- 여기서 시작
SELECT *
FROM product;

-- 고객이 안 먹는 제품을 가지고 있지는 않지만 알 수는 있다
SELECT *
FROM cycle
WHERE cid = 1;

SELECT *
FROM product
WHERE pid NOT IN (SELECT NVL(pid, 0)
                    FROM cycle
                    WHERE cid = 1);


-- 하드 코딩
SELECT *
FROM product
WHERE pid NOT IN (100, 100, 400, 400);

-- 서브쿼리 이용
-- sub5]
SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                    FROM cycle
                   WHERE cid = 1);


                   
-- 프로그래머스 사이트
코딩테스트 연습
자바, SQL 고득점 Kit ...

여기서 공부해도 괜찮다
ORACLE 강의가 생각보다 많이 없다.
ORACLE 문법은 아닌데, 기본적인 것들이니까.