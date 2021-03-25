월별실적
                반도체     핸드폰     냉장고
2021년 1월 :     500       300       400
2021년 2월 :     0         0         0
2021년 3월 :     500       300       400
.
.
.
2021년 12월 :     500       300       400

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

-- ORACLE
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
  AND buyprod.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

-- ANSI
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod(+) = prod.prod_id 
                                       AND buyprod.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD'));


select *
from prod;

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');

기준이 되는 것 prod, 왜냐하면 3,4,5 열이 지금 NULL 값이 없으니까? XXXXXXXXXXXXXXX
=> 기준이 prod가 되는 이유는, 문제의 요구사항에 그렇게 적혀있기 때문, "모든 품목이 나올 수 있도록"


-- 한 행으로 다 합하면 모든 행수를 구할 수 있다
-- 이것과 아우터 조인했을 때의 값이 같아야 한다.
=> OUTER JOIN 결과 = OUTER JOIN의 기준이 되는 테이블의 행 수와 동일
SELECT COUNT(*)
FROM prod;

-- 하지만 실무를 하다보면 행 개수가 맞아도 잘못 조회했을까봐 불안할 때가 있다,
-- 하지만 적어도 행 개수는 지키셨다.

-- ORACLE
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod 
WHERE buyprod.buy_prod(+) = prod.prod_id 
  AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

SELECT *
FROM buyprod;



outerjoin2]
outerjoin1에서 작업 시작, buy_date 컬럼이 null인 항목이 안 나오도록
다음처럼 데이터를 채워지도록 쿼리 작성

outerjoin 1번을 참고
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id 
  AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

outerjoin2] + 3] null 값 0 처리
SELECT TO_DATE(:yyyymmdd, 'YYYY/MM/DD'), buy_prod, prod_id, prod_name, NVL(buy_qty, 0)
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id 
  AND buy_date(+) = TO_DATE(:yyyymmdd, 'YYYY/MM/DD');


outerjoin4] 
- cycle, product 테이블을 이용해 고객이 애음하는 제품 명칭을 표현하고,
애음하지 않는 제품도 다음과 같이 조회되도록 쿼리를 작성하세요
(고객은 cid=1인 고개만 나오도록 제한, null 처리)

SELECT *
FROM cycle;
-- 1번 고객의 제품 종류는 2개 : 100, 400 

SELECT *
FROM product;

SELECT c.pid, p.pnm, c.cid, c.day, c.cnt
FROM cycle c, product p
WHERE c.pid = p.pid;

-- 바인딩 변수 사용 -> SELECT 절과 ON 절의 cid가 같은 값을 의미하는 구나 알 수 있다, 그냥 컬럼을 1로 적는 것보다 좋은 방법
SELECT product.*, :cid, cycle.day, cycle.cnt
FROM product LEFT JOIN cycle ON (product.pid = cycle.pid AND cid = :cid);

-- ANSI
SELECT product.*, :cid, NVL(cycle.day,0) day, NVL(cycle.cnt,0) cnt
FROM product LEFT JOIN cycle ON (product.pid = cycle.pid AND cid = :cid);

-- ORACLE
SELECT product.*, :cid, NVL(cycle.day,0) day, NVL(cycle.cnt,0) cnt
FROM product, cycle
WHERE product.pid = cycle.pid(+)
  AND cid(+) = :cid;
  -- cid 뒤의 (+) 기호를 빼면 200, 300 제품의 행 출력 X 
  -- 그리고 cid 컬럼은 CYCLE, CUSTOMER에 있다.
  
  

-- 과제@
outerjoin5] 
outerjoin4를 바탕으로 고객 이름 컬럼 추가하기
-> customer 테이블에 있는 고객 이름을 어떻게 들고올 것인가

SELECT product.*, :cid, NVL(cycle.day,0) day, NVL(cycle.cnt,0) cnt, customer.cnm
FROM product, cycle, customer
WHERE product.pid = cycle.pid(+)
  AND cycle.cid(+) = :cid
  AND cycle.cid = customer.cid -- cycle 테이블쪽 null 값을 처리해서 JOIN
  AND customer.cid = :cid;

--
SELECT product.*, :cid, NVL(cycle.day,0) day, NVL(cycle.cnt,0) cnt, customer.cnm
FROM product, cycle, customer
WHERE product.pid = cycle.pid(+)
  AND cycle.cid(+) = :cid
  AND cycle.cid = customer.cid(+) 
  AND customer.cid(+) = :cid;
  
SELECT *
from customer;

SELECT product.pid, pnm, :cid, cnm, NVL(day, 0) AS day, NVL(cnt, 0) AS cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = :cid)
    LEFT OUTER JOIN customer ON (:cid = customer.cid);
  

-- 지금까지 강조한 것, 개념을 잘 정리할 필요
1. WHERE
2. GROUP BY(그룹핑) -- 개념 이해를 못하면 사용하면서 계속 문제가 될 것
3. JOIN
문법 : ANSI vs ORACLE
논리적 형태 : SELF JOIN, NON-EQUI-JOIN <-> EQUI-JOIN
-- 급여등급 구할 때 썼었다, NON-EQUI-JOIN 나중의 작업속도에 큰 영향을 미친다
연결조건(성공 실패에 따라 조회 여부 결정)
: OUTER JOIN <-> INNER JOIN : 연결이 성공적으로 이루어진 행에 대해서만 조회가 되는 조인

SELECT *
FROM dept JOIN emp ON (dept.deptno = emp.deptno); -- INNER 키워드가 없더라도 INNER JOIN


CROSS JOIN
- 별도의 연결 조건이 없는 조인
- 묻지마 조인
- 두 테이블의 행 간 연결 가능한 모든 경우의 수로 연결
  ==> CROSS JOIN 의 결과는 두 테이블의 행 수를 곱한 값과 같은 행이 반환된다
  데이터 복제를 위해 사용

SELECT *
FROM emp, dept;
-- WHERE 절이 없다
=
SELECT *
FROM emp CROSS JOIN dept;


데이터 결합 cross join 실습 1]
- customer, product 테이블을 이용하여 고객이 애음 가능한 모든 제품의 정보를 결합하여
다음과 같이 조회되도록 쿼리 작성

SELECT *
FROM customer, product;


-- 끊고 갈 타이밍, 지금까지 공부한 것들 종합적 정리





