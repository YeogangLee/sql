OUTER JOIN
: 연결 조건에 실패했을 때 데이터가 두 테이블 중 한쪽은 나오게끔
  두 테이블 다 나올 수는 없다, 연결에 실패했기 때문에
  => 컬럼 연결이 실패해도 [기준]이 되는 테이블 쪽의 컬럼 정보는 나오도록 하는 조인 JOIN

1. LEFT OUTER JOIN
2. RIGHT OUTER JOIN
3. FULL OUTER JOIN


1. LEFT OUTER JOIN : [기준]이 왼쪽에 기술한 테이블이 되는 OUTER JOIN
 테이블1 JOIN 테이블2
 테이블1 LEFT OUTER JOIN 테이블2

2. RIGHT OUTER JOIN : [기준]이 오른쪽에 기술한 테이블이 되는 OUTER JOIN
테이블1 JOIN 테이블2
테이블1 LEFT OUTER JOIN 테이블2
==
테이블2 RIGHT OUTER JOIN 테이블1

3. FULL OUTER JOIN : 추후(사용빈도 적음, 나중에 정리)

FULL OUTER JOIN = LEFT OUTER + RIGHT OUTER - 중복데이터 제거
사용 빈도는 거의 없지만, 정의 정도는 기억해둬도.




직원의 이름, 직원의 상사 이름 두 개의 컬럼이 나오도록 JOIN query 작성
(13건, KING 나오지 않아도 ㄱㅊ, 수업 시간에 했었던)

SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;
-- 같은 테이블끼리 조인하는 것 : SELF JOIN

-- ANSI
-- 결과 행 13건
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

-- 결과 행 14건
SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);


-- ORACLE로 변형
-- 1. 일단 ORACLE 기본 형태 맞춰주기
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- 2. 누락이 되는 쪽 괄호 안에 +
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+); -- 데이터가 안 나오는 곳에 (+)를 붙여준다.
-- 기준이 아닌 곳에 (+)를 붙여준다?

SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);
-- LEFT OUTER JOIN 사용 -> 오른쪽은 기준이 아니라 둘 다 null 값이 나오는 걸 확인


-- 아래 둘 비교
-- 1. ON 절에 조건 10번 기술
SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND m.deptno = 10);
-- SELECT의 ename은 나오고 뒤에 2개는 안 나오는 상황, emp m의 데이터를 deptno 10번 말고 다 지웠기 때문(조건에 그렇게 기술되어 있으니)

-- 2. WHERE 절에 조건 10번 기술
SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno) -- 여기까지 하면 원래대로 결과행은 14행 
WHERE m.deptno = 10; -- WHERE에 기술하면 행을 제한하는 조건으로 사용된 것, 그래서 10 데이터 행 말고는 조회 X

-- 오라클 표기, (+)
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
  AND m.deptno(+) = 10; -- ORACLE에서는 OUTER JOIN에 연결하는 컬럼을 다 (+)를 붙인다.

-- 오라클 표기2 (+)을 부분적으로 사용한 경우, ANSI의 행이 제한된 결과
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
  AND m.deptno = 10;


-- 선생님 의견으로는 오라클 표기가 더 편하고, 어떤 표기를 쓸 것인지는 입사한 회사에서 알려줄 것


-- 아래의 둘은 같은 말
SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT e.ename, m.ename, m.deptno
FROM emp m RIGHT OUTER JOIN emp e ON (e.mgr = m.empno);


-- 데이터는 몇 건이 나올까? 그려볼 것
SELECT e.ename, m.ename, m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT e.empno, e.ename, e.mgr, m.empno, m.ename, m.mgr
FROM emp e, emp m;

-- 직접 그려보기, 몇 번을 매니저 컬럼으로 하는 값이 있나요?
e.ename     m.ename
NULL        SMITH
NULL        ALLEN
NULL        WARD
SCOTT       JONES //
FORD        JONES //
NULL        MARTIN
ALLEN       BLAKE **
WARD        BLAKE **
MARTIN      BLAKE **
TURNER      BLAKE **
JAMES       BLAKE **
MILLER      CLARK ##
ADAMS       SCOTT $$
JONES       KING %%
BLAKE       KING %%
CLARK       KING %%
NULL        TURNER
NULL        ADAMS
NULL        JAMES
SMITH       FORD ^^
NULL        MILLER

총 21행, 이렇게 이런 식으로 따라 가면 돼요.

지금 이 설명 이유 -> FULL OUTER JOIN 때문에
FULL OUTER JOIN = LEFT OUTER + RIGHT OUTER - 중복데이터 제거
사용 빈도는 거의 없지만, 정의 정도는 기억해둬도.

-- FULL OUTER : LEFT(14) + RIGHT(21) - 동일한 중복 데이터 중 1개만 남기고 제거(13) = 22
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

-- 14건
SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

위에 총 13행은 중복 데이터
맨 밑에 있는 KING은 오른쪽 NULL -> RIGHT OUTER JOIN 하면 X


-- FULL OUTER JOIN 은 오라클 SQL 문법으로 제공하지 않는다
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr(+) = m.empno(+);
-- 오류 메세지 : "a predicate may reference only one outer-joined table"
-- 한 쪽에만 아우터 조인 (+)을 제공한다. - FULL OUTER 지원 X


-- 오늘은 4시간 동안 OUTER JOIN에 대한 얘기만 하는 중...

실습 outerjoin 1]
SELECT *
FROM buyprod;
-- buy_prod 의 제품 이름은 뭘까? -> ERD 다이어그램에서 찾아보기

SELECT *
FROM buyprod
WHERE buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');

지금 내가 하고 싶은 것은
모든 제품을 다 보여주고, 실제 구매가 있을 때는 구매수량을 조회, 없을 경우는 NULL로 표현

제품 코드 : 판매 수량
P102000001  NULL
P102000002  NULL
P102000003  11
P102000004  13
P102000005  22
...

- buyprod 테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목 밖에 없다.
모든 품목이 나올 수 있도록 쿼리를 작성해보세요.

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');

기준이 되는 것 prod, 왜냐하면 3,4,5 열이 지금 NULL 값이 없으니까? XXXXXXXXXXXXXXX
=> 기준이 prod가 되는 이유는, 문제의 요구사항에 그렇게 적혀있기 때문, "모든 품목이 나올 수 있도록"

-- ANSI
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id AND buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD'));

-- 한 행으로 다 합하면 모든 행수를 구할 수 있다, 이것과 아우터 조인했을 때의 값이 같아야 한다.
SELECT COUNT(*)
FROM prod;

-- 하지만 실무를 하다보면 행 개수가 맞아도 잘못 조회했을까봐 불안할 때가 있다,
-- 하지만 적어도 행 개수는 지키셨다.

-- ORACLE
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod 
WHERE buyprod.buy_prod(+) = prod.prod_id 
AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');
