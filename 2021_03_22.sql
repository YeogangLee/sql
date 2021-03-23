-- docker = Linux 역할, 앞으로 DB를 사용할 때 사용하게 될 것
-- BIOS 화면에서 F7
-- cpu configuration
-- ㄴ 인텔 가상화 기술 - Enabled
-- 설정 후 다시 F7 눌러서 기본 화면, 그리고 F12; Save & Reset 아니면 F10으로 저장+리셋, 화면에 쓰여 있음


-- ORACLE
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM lprod, prod
WHERE lprod.lprod_gu = prod.prod_lgu;

-- ANSI
SELECT lprod_gu, prod_id, lprod_nm, prod_name
FROM prod JOIN lprod ON (lprod.lprod_gu = prod.prod_lgu);


-- 취업하고 실무 중에 ...
유지보수 중요, 설계서를 제대로 리뷰하지 않으면 다음 사람이 굉장히 힘들어진다


데이터 결합 실습 join2]
- erd 다이어그램을 참고하여 buyer, prod 테이블을 조인하여
buyer별 담당하는 제품 정보를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
-- buyer별 @

SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM buyer b, prod p
GROUP BY b.buyer_id
HAVING b.buyer_id;

-- buyer 별로 그룹 X, alias 전부 없어도 실행 가능
SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM buyer b, prod p
WHERE b.buyer_id = p.prod_buyer;

-- 인출된 최종의 개수를 보고 싶다면 질의 결과에서 데이터 아무거나 하나 누르고 ctrl End
-- 만약 50개라면 그건 페이징 단위가 50개일 확률이 높다, 실제로 50개일 수 있기도 하고.

-- 웹 프로그래밍 자주하는 예제
-- 게시판, 쇼핑몰


데이터 결합 실습 join3]
- erd 다이어그램을 참고하여 member, cart, prod 테이블을 조인하여
회원별 장바구니에 담은 제품 정보를 다음과 같은 결과가 나오는 쿼리를 작성해보세요.
(핵심: 테이블 3개 조인, 초심자에게는 oracle 표기가 더 편할 것)

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE mem_id = cart_member
  AND cart_prod = prod_id;
  
  
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart, prod ON (mem_id = cart_member AND cart_prod = prod_id);


join3]
1. FROM 에 테이블 나열
2. 테이블을 연결할 연결고리 컬럼 찾기

-- 없는 컬럼이라 오류, 없는 테이블이라던가 - ERD 다이어그램에서 확인
SELECT *
FROM member, cart
WHERE member.member_id = cart.cart_member;

-- 컬럼명 수정 후 쿼리 작성
-- ORACLE 
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
  AND cart.cart_prod = prod.prod_id;

ANSI 작성법
FROM member JOIN cart ON (....) JOIN 다른 테이블 ON
또는 엔터키로 구분 지어서
FROM member JOIN cart ON (....) 
    JOIN 다른 테이블 ON

-- ANSI
-- 처음부터 테이블 3개를 쓰는 게 아니라,
-- 2개 먼저 써보고 데이터 출력 되면 하나 추가하는 방식으로
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
            JOIN prod ON (cart.cart_prod = prod.prod_id); --**
    

-- batch 테이블 추가
-- 코드 워크시트에 복붙, 전체 선택 CTRL A + CTRL ENTER, 
-- 그 다음에 기존 코드 다 지우고 COMMIT; 입력 후 드래그할 필요 없이 ctrl+ENTER

-- BATCH - 실무 사례의 테이블을 단순화시켜 들고온 것

SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle;
cid 고객이 pid 제품을 day 날에 cnt 개 먹는다

1번 고객
2 4 6 월 수 금 은 야쿠르트100 제품 1개
3 5   화 목    은 야쿠르트400 제품 1개


11시 15분 까지
join 실습.pdf 파일 보고 batch.sql 실습문제(4~7) 풀기
hr계정(exerd) 실습 8~13은 숙제


데이터 결합 join4]

-- ORACLE
SELECT cu.cid, cnm, pid, day, cnt
FROM customer cu, cycle cy
WHERE cu.cid = cy.cid
  AND cnm IN ('brown', 'sally');
  
-- ANSI
SELECT cu.cid, cnm, pid, day, cnt
FROM customer cu JOIN cycle cy ON (cu.cid = cy.cid AND cnm IN ('brown', 'sally')); 
  
  
join4]
SELECT *
FROM customer, cycle
WHERE customer.cid = cycle.cid;

SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
  AND cnm IN ('brown', 'sally');
  

데이터 결합 join5]
-- ORACLE
SELECT cu.cid, cnm, cy.pid, pnm, day, cnt
FROM customer cu, cycle cy, product p
WHERE cu.cid = cy.cid
  AND cy.pid = p.pid
  AND cnm IN ('brown', 'sally');
  
-- ANSI
SELECT cu.cid, cnm, cy.pid, pnm, day, cnt
FROM customer cu JOIN cycle cy ON (cu.cid = cy.cid) 
                 JOIN product p ON (cy.pid = p.pid)
                 AND cnm IN ('brown', 'sally');  

join5]
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt -- 4번에서 여기에 pnm을 추가
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
  AND cycle.pid = product.pid
  AND customer.cnm IN ('brown', 'sally');

-- JOIN이 헷갈리면 엑셀 파일에 색칠하면서 그려봐라.


데이터 결합 join6]


-- ORACLE
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
  AND cycle.pid = product.pid
  AND customer.cnm IN ('brown', 'sally')
GROUP BY customer.cid, customer.cnm, cycle.pid, product.pnm;
-- GROUP BY 전의 쿼리 결과를 보면 컬럼 4개의 값이 같다, 저걸로 GROUP BY 해줘라

-- // 이걸로 기본형태 잡고, 여기서 필요 없는 정보 날리기

-- @에러, 수정했는데 다시 보기
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY customer.cid, customer.cnm, cycle.pid, product.pnm;



-- ANSI 
SELECT cu.cid, cnm, cy.pid, pnm, cnt
FROM customer cu JOIN cycle cy ON (cu.cid = cy.cid) 
                 JOIN product p ON (cy.pid = p.pid);
-- 테이블 3개 JOIN 
-- 뒤에 ON(조건) 키워드 없을시 오류 발생
-- 오라클 표기에서 WHERE이 없다고 해서, ANSI 표기에서 ON을 없애면 안 된다. 


데이터 결합 join7]
-- ORACLE
SELECT cy.pid, pnm, cnt
FROM cycle cy, product p
WHERE cy.pid = p.pid;

-- ANSI
SELECT cy.pid, pnm, cnt
FROM cycle cy JOIN product p ON (cy.pid = p.pid);


-- username 추가
/*
SELECT *
FROM dba_users;

-- 지금부터 hr username을 살릴 것

ALTER USER hr ACCOUNT UNLOCK;
-- User HR이(가) 변경되었습니다.

-- 다시 조회
SELECT *
FROM dba_users;

-- hr 계정의 비밀번호를 java로 변경
ALTER USER hr IDENTIFIED BY java;
-- User HR이(가) 변경되었습니다.

-- 다시 조회
SELECT *
FROM dba_users;

*/


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
