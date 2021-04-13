2021-04-13 EXTRA-LECTURE_02)조인 JOIN
- 다수 개의 테이블로부터 필요한 자료 추출
- RDBMS에서 가장 중요한 연산

1. 내부 조인
 - 조인 조건을 만족하지 않는 행은 무시
 
예);상품 테이블에서 상품의 분류별 상품의 수를 조회하시오.
    ALIAS는 분류코드, 분류명, 상품의 수
    
88 상품테이블에서 사용한 분류 코드의 종류
SELECT DISTINCT PROD_LGU
  FROM PROD; -- PROD 6행, LPROD는 10행, LPROD가 행이 더 많다.


2. 외부 조인
SELECT A.LPROD_GU AS 분류코드/*기준*/, -- 분류코드는 두 테이블에서 동시에 가지고 있지만, 행이 더 많은 테이블을 사용
       A.LPROD_NM AS 분류명, 
       COUNT(*) AS "상품의 수"
  FROM LPROD A, PROD B
 WHERE LPROD_GU = PROD_LGU
 GROUP BY A.LPROD_GU, A.LPROD_NM
 ORDER BY 1;

예); 2005년 5월 매출자료와 거래처 테이블을 이용하여 거래처별 상품매출정보를 조회하시오.
     ALIAS 는 거래처코드, 거래처명, 매출액
     -- 거래처는 매입과 관련, 고객은 판매와 관련
     -- 거래처 정보는 CART 테이블에 없다.
     -- 매출은 PROD 테이블에 있다.


SELECT B.PROD_BUYER 거래처코드, 
       C.BUYER_NAME 거래처명, 
       SUM(A.CART_QTY * B.PROD_PRICE)매출액
  FROM CART A, PROD B, BUYER C
 WHERE A.CART_PROD = B.PROD_ID
--   AND B.PROD_LGU = C.BUYER_LGU -- P숫자3자리 -- 이거 포함, 결과 28행 -- 상품코드
   AND B.PROD_BUYER = C.BUYER_ID -- P숫자5자리 -- 이거 포함, 결과 12행 -- 판매자코드
   -- 1.SELECT에 있는게 B.PROD_BUYER니까, 그래서 이걸로 이너조인 하는 건가..
   -- 2.종류를 검색하니 PROD_BUYER가 행이 더 많기도 하다...
   
   -- 상품은 여러 개일 수 있어도 거래처는 여러 개일 수가 없다...
   -- 한 거래처에서 여러 품목을 다룰 수는 있어도,
   -- 한 거래처가 여러 거래처와 ... 물론 여러 거래처와 거래를 할 수는 있겠지만
   -- 먼가 한 품목에 대해 여러 거래처와 거래를 하지는 않을 거니까
   -- 상품보다는 좀 더 관계? 또는 값이 유일할 것 같은 그런 느낌이 있고,,.. 기준! 이되는 컬럼들을 생각해보자.
   -- 대부분 기본키로 조인하는 경우가 많다. - 이렇게 해보고 이게 아니라면 다른 조건으로 다시 해보면 된다. - 희소한, 중복이 되지 않는 컬럼 값들
   
   AND A.CART_NO LIKE '200505%'
 GROUP BY B.PROD_BUYER, C.BUYER_NAME
 ORDER BY 1;

-- 종류 검색 
SELECT DISTINCT PROD_LGU
  FROM PROD; 
SELECT DISTINCT PROD_BUYER
  FROM PROD; 
  
  
SELECT 거래처코드, 거래처명, 매출액
  FROM CART A, PROD B, BUYER C
  
-- 기간 전체 매출
SELECT B.PROD_BUYER AS 거래처코드,
       C.BUYER_NAME AS 거래처명,
       SUM(A.CART_QTY * B.PROD_PRICE) AS 매출액
  FROM CART A, PROD B, BUYER C
 WHERE A.CART_PROD = B.PROD_ID -- 단가를 얻기 위해 조인
   AND B.PROD_BUYER = C.BUYER_ID -- 거래처명 얻기 위해 조인
 GROUP BY B.PROD_BUYER, C.BUYER_NAME; 

-- 2005년 5월달의 매출 
SELECT B.PROD_BUYER AS 거래처코드,
       C.BUYER_NAME AS 거래처명,
       SUM(A.CART_QTY * B.PROD_PRICE) AS 매출액
  FROM CART A, PROD B, BUYER C
 WHERE A.CART_PROD = B.PROD_ID -- 단가를 얻기 위해 조인
   AND B.PROD_BUYER = C.BUYER_ID -- 거래처명 얻기 위해 조인
   AND A.CART_NO LIKE '200505%'
 GROUP BY B.PROD_BUYER, C.BUYER_NAME; 


(ANSI 내부조인 형식)
SELECT 컬럼list 
  FROM 테이블명1개;
 INNER JOIN 테이블명2(조인조건 
  [AND 일반조건])
 INNER JOIN 테이블명3(조인조건 -- VIEW로 나오는 결과와 조인되는 것
  [AND 일반조건])
          :
 WHERE 조건;

CART는 BUYER와 공통된 컬럼이 없다.


(ANSI 방식)
SELECT B.PROD_BUYER AS 거래처코드,
       C.BUYER_NAME AS 거래처명,
       SUM(A.CART_QTY * B.PROD_PRICE) AS 매출액
  FROM CART A
 INNER JOIN PROD B ON(A.CART_PROD = B.PROD_ID
   AND A.CART_NO LIKE '200505%')
 INNER JOIN BUYER C ON(B.PROD_BUYER = C.BUYER_ID)
 GROUP BY B.PROD_BUYER, C.BUYER_NAME
 ORDER BY 1; 
 

문제1);
2005년 1월~3월 거래처별 매입정보를 조회하시오.
ALIAS 는 거래처코드, 거래처명, 매입금액 합계이고
매입금액 합계가 500만원 이상인 거래처만 검색하시오.

매입테이블 BUYPROD에 거래처코드 없다? - PROD 테이블을 거쳐야 하는 거지

SELECT A.PROD_BUYER 거래처코드,
       B.BUYER_NAME 거래처명,
       SUM(C.CART_QTY * A.PROD_PRICE) "매입금액 합계"
       
  FROM PROD A, BUYER B, CART C
 WHERE A.PROD_BUYER = B.BUYER_ID
   AND C.CART_PROD = A.PROD_ID
   AND C.CATY_NO LIKE IN ('200501','200502','200503')
 GROUP BY A.PROD_BUYER, B.BUYER_NAME;


문제2);
사원테이블EMPLOYEES 에서 부서별 평균 급여보다
급여를 많이 받는 직원들의 수를 부서별로 조회하시오.
ALIAS 는 부서코드, 부서명, 부서평균급여, 인원수

이건 복잡해, 서브쿼리 써야하고
특정 직원이 속한 부서의 평균 급여와 비교
전체 직원과 비교하는 게 아니라
부서 별로 몇명이냐~ 각 부서별로 평균급여가 얼마냐.     


