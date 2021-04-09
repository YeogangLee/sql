2021-04-09_01
/*

*/
(프로시저 생성)
(일반 SQL)
(실행)
(일반 SQL)
(익명블록)

프로시저에서 할 일, 익명 블럭에서 프로시저를 호출해서 할 일 구분할 줄 알아야 한다
서브쿼리가 필요할지 아닐지 ...
-- 지금은 어렵더라도 경험에 의해 길러질 수 있다

-- 지난 시간 이어서
);
2005년도 구매금액이 없는 회원을 찾아 회원테이블(MEMBER)의
삭제여부 컬럼(MEM_DELETE)의 값을 'Y'로 변경하는 프로시저 작성

(생성)
CREATE OR REPLACE PROCEDURE PROC_MEM_UPDATE(
    P_MID IN MEMBER.MEM_ID%TYPE
    -- 꼭 사용자가 입력하는 값에만 IN 을 사용하는 게 아니라,
    -- 추가적인 변수를 필요로 하면, 그때도 IN 사용
)
AS
BEGIN
    -- (SQL1 - 프로시저) 
    UPDATE MEMBER
       SET MEM_DELETE = 'Y'
     WHERE MEM_ID = P_MID;
    COMMIT;
END;

(SQL2 - 구매금액이 없는 회원) => CART 테이블에 없는 회원
- 2005년에 구매 이력이 있는 회원
SELECT DISTINCT CART_MEMBER
  FROM CART
 WHERE CART_NO LIKE '2005%';

- '2005년에 구매 이력이 있는 회원'들에 없는 회원 
SELECT MEM_ID
  FROM MEMBER
 WHERE MEM_ID NOT IN (SELECT CART_MEMBER
                        FROM CART
                       WHERE CART_NO LIKE '2005%');
-- 내가 작성 
- 구매 금액이 없는 회원
SELECT mem_id
  FROM member
 WHERE mem_id NOT IN (SELECT cart_member 
                        FROM cart
                        -- 2005년 조건을 여기 추가했어야 했다);
                        
                        
프로젝트 진행 -> 눈높이가 중요, 자기 눈높이에 맞춰 쉽게 개발 ...
               세상은 그렇게 돌아가지 않는데도 불구하고
내가 좋아하는 주제가 아니라, 업체가 좋아하는 주제 PMS라던가 ..


(프로시저 생성)
CREATE OR REPLACE PROCEDURE PROC_MEM_UPDATE(
    P_MID IN MEMBER.MEM_ID%TYPE
    -- 꼭 사용자가 입력하는 값에만 IN 을 사용하는 게 아니라,
    -- 추가적인 변수를 필요로 하면, 그때도 IN 사용
)
AS
BEGIN
    -- (SQL1 - 프로시저) 
    UPDATE MEMBER
       SET MEM_DELETE = 'Y'
     WHERE MEM_ID = P_MID;
    COMMIT;
END;


(익명블럭)
DECLARE
    -- 커서는 DECLARE 안에 쓴다, 프로시저는 BEGIN에서 호출
    CURSOR CUR_MEM_ID
    IS
    SELECT MEM_ID
      FROM MEMBER
     WHERE MEM_ID NOT IN (SELECT CART_MEMBER
                            FROM CART
                           WHERE CART_NO LIKE '2005%');
BEGIN
    FOR REC_MID IN CUR_MEM_ID LOOP
        PROC_MEM_UPDATE(REC_MID.MEM_ID);
    END LOOP;
END;




#USER DEFINED FUNCTION(FUNCTION)
- 사용자 정의 함수
- 반환값이 존재 - 큰 장점
- 자주 사용되는 복잡한 QUERY 등을 모듈화시켜 컴파일 한 후 호출하여 사용

(사용형식)
CREATE [OR REPLACE] FUNCTION 함수명[(
    매개변수 [IN|OUT|INOUT] 데이터타입 [{:=|DEFAULT} EXPR][,]
                            :
    매개변수[IN|OUT|INOUT] 데이터타입 [{:=|DEFAULT} EXPR])]
    
    RETURN 데이터타입
    -- 세미콜론 사용X, 함수에서 반환할 타입 메서드 제일 처음에 쓰는 것처럼 ex. int sum()
AS | IS
    선언영역; -- 변수, 상수, 커서
BEGIN
    실행문;
    RETURN 변수|수식; -- 88 다른 프로시저 생성이나 익명블럭 생성과 다른 점
    [EXCEPTION
        예외처리문;]
END;


사용예);
장바구니 상품테이블에서 2005년 6월 5일 판매된 상품코드를 입력받아
상품명을 출력하는 함수를 작성하시오.
1. 함수명 : FN_PNAME_OUTPUT
2. 매개변수 : 입력용 - 상품코드
             출력용 - 없음
3. 반환값 : 상품명


(함수 생성)
CREATE FUNCTION FN_PNAME_OUTPUT(
    P_CODE IN PROD.PROD_ID%TYPE)
    RETURN PROD.PROD_ID%TYPE -- 특이하게 괄호 바깥에 작성, 세미콜론X
AS
    V_PNAME PROD.PROD_NAME%TYPE; -- 이름을 잠깐 보관하기 위해 변수 생성
BEGIN
    -- (일반 SQL1 - 함수)
    SELECT PROD_NAME INTO V_PNAME
      FROM PROD
     WHERE PROD_ID = P_CODE;
     
     RETURN V_PNAME;
END;


(실행)
(일반 SQL2)
SELECT CART_MEMBER, FN_PNAME_OUTPUT(CART_PROD) -- 상품 코드를 입력 받고, 상품 이름을 들고오는 함수
  FROM CART
 WHERE CART_NO LIKE '20050605%';
-- SELECT가 한 번 실행될 때 마다 함수 호출 -> 알아서 3번 실행된다 -> 커서가 필요 없다
-- 프로시저에서는 단 한 번 실행으로 한 번 출력해야 하니까, 그 사이에 반복 기능을 수행하는 커서가 필요


사용예);
2005년 5월 모든 상품에 대한 매입현황을 조회하시오.
ALIAS 는 상품코드, 상품명, 매입수량, 매입금액

OUTER JOIN 써야겠죠.
일반 OUTER JOIN 쓸 수 있나요? 사용 못해요.
해결 방법 2가지 -> ANSI OUTER JOIN / 서브쿼리

상품명 끌고 오려면 JOIN 해야겠죠
문제의 '모든' -> 안팔린건 0, 팔린건 팔린대로 데이터 들고오고

SELECT 상품코드, 상품명, 매입수량, 매입금액
  FROM BUYPROD A, PROD B 
  -- 상품코드는 BUYPROD, PROD 둘 다 있는데, 어디꺼를 써야할까?
  -- 아무거나? XX 행이 부족한쪽의 상품코드를 쓰면 NULL이 나온다
 
 - OUTER JOIN 사용할 때 주의
  1. 공통된 컬럼이 있으면 행이 많은 쪽 테이블의 컬럼을 사용
  2. COUNT 함수 쓸 때 * 사용 X 
     -> 결과가 무조건 1이 나온다, COUNT 함수는 행을 체크, NULL값도 1로 체크, 그래서 *말고 컬럼명 아무거나 기입

SELECT B.PROD_ID AS 상품코드,
       B.PROD_NAME AS 상품명,
       SUM(A.BUY_QTY) AS 매입수량,
       SUM(A.BUY_QTY * B.PROD_COST) AS 매입금액
  FROM BUYPROD A, PROD B -- PROD가 BUYPROD보다 훨씬 많다. 뭐가??
 WHERE A.BUY_PROD(+) = B.PROD_ID
   AND A.BUY_DATE BETWEEN '20050501' AND '20050531' -- 일반조건
   -- 이 날짜 조건이 없으면 
 GROUP BY B.PROD_ID, B.PROD_NAME;
 -- 총 74개 출력, 2005년 전체

-> 36행 결과는 내부조인이 나왔다 왜? 180행의 AND 가 일반조건이라서
외부조인조건이 일반조인조건과 결합되면 내부조인으로 바뀌어 처리된다 -> ANSI 조인이나 서브쿼리를 써야 한다

- 수정시작
(ANSI OUTER JOIN)
SELECT B.PROD_ID AS 상품코드,
       B.PROD_NAME AS 상품명,
       NVL(SUM(A.BUY_QTY),0) AS 매입수량,
       NVL(SUM(A.BUY_QTY * B.PROD_COST),0) AS 매입금액
  FROM BUYPROD A
  RIGHT OUTER JOIN PROD B ON(A.BUY_PROD = B.PROD_ID)-- B테이블이 더 자료수가 많기 때문에 B사용 
 -- WHERE A.BUY_PROD(+) = B.PROD_ID -- 이게 위의 ON으로, (+) 빠지고 조건으로 들어간다
   AND A.BUY_DATE BETWEEN '20050501' AND '20050531'
 GROUP BY B.PROD_ID, B.PROD_NAME;
-- 이제 74개가 출력, 하지만 NULL값 그대로

-- => 방금 ANSI OUTER JOIN 이용해서 해결
-- 아우터 조인 쓰기 싫으면, 서브쿼리에서 날짜 처리해서 사용


(서브쿼리)
SELECT BUY_PROD,
       SUM(BUY_QTY),
       SUM(BUY_QTY * BUY_COST)
  FROM BUYPROD
 WHERE BUY_DATE BETWEEN '20050501' AND '20050531'
 GROUP BY BUY_PROD;
 
-- 이걸 PROD와 아우터조인하면 되겠죠
=>
SELECT B.PROD_ID AS 상품코드,       -- 2. 문제 보고 SELECT 할, 필요한 데이터 적고
       B.PROD_NAME AS 상품명,
       NVL(A.QAMT, 0) AS 구입수량,
       NVL(A.HAMT, 0) AS 구입금액
    FROM(SELECT BUY_PROD AS BID,    -- 1. 서브쿼리로 먼저 보내고
                SUM(BUY_QTY) AS QAMT, -- 매입 수량 합계
                SUM(BUY_QTY * BUY_COST) AS HAMT -- 매입 구매 합계
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN '20050501' AND '20050531'
          GROUP BY BUY_PROD) A, PROD B
 WHERE A.BID(+) = B.PROD_ID;        -- 3. 두 테이블 중 어디가 자료가 적고 많은지 확인 후 (+)적어주기


(함수 사용)
CREATE OR REPLACE FUNCTION FN_BUYPROD_AMT(                              -- 1
    P_CODE IN PROD.PROD_ID%TYPE)
    RETURN VARCHAR2 
    -- 수량, 매입금액 합계를 구해서 넘겨줘야겠지 -> 잘생각해봐, 함수는 리턴 최대 1개 -> ?
    -- ????? 꼭 여기서 다 해결할 필요는 없어요
IS
    V_RES VARCHAR2(100); -- 매입수량과 매입금액을 문자열로 변환하여 기억할 변수, 반환될 데이터
    V_QTY NUMBER := 0; -- 매입수량 합계
    V_AMT NUMBER := 0; -- 매입금액 합계
BEGIN
    SELECT SUM(BUY_QTY), SUM(BUY_QTY * BUY_COST) INTO V_QTY, V_AMT      -- 11
      FROM BUYPROD
     WHERE BUY_PROD = P_CODE
       AND BUY_DATE BETWEEN '20050501' AND '20050531';
     
     IF V_QTY IS NULL THEN
        V_RES:='0';
     ELSE
         -- 다음에 바로 RETURN을 쓰는 게 아니라, 편법을 써서 둘을 문자열 하나로 합쳐서 반환
--         V_RES := TO_CHAR(V_QTY, '9,999')||', '||TO_CHAR(V_AMT, '99,999,999');
         V_RES := '수량 : '||V_QTY||', '||'구매금액 : '||TO_CHAR(V_AMT, '99,999,999');    -- 21
     END IF;
     
     RETURN V_RES;
END;


(실행)
SELECT PROD_ID AS 상품코드, 
       PROD_NAME AS 상품명,
       FN_BUYPROD_AMT(PROD_ID) AS 구매내역
  FROM PROD;
-- 모든 상품에 대해 처리




상품코드를 입력 받아 2005년도 상품별 평균판매횟수, 판매수량합계, 판매금액합계를 
출력할 수 있는 함수를 작성하시오.
1. 함수명 : FN_CART_QAVG, FN_CART_QAMT, FN_CART_FAMT
        -- 평균판매횟수,   판매수량합계,   판매금액합계
2. 매개변수 : 입력용 - 상품코드, 년도
             출력용 - 없음
3. 반환값 : 평균판매횟수, 판매수량합계, 판매금액합계

-- FN_CART_QAVG
CREATE OR REPLACE FN_CART_QAVG(
    P_CODE IN PROD.PROD_ID%TYPE,
    P_YEAR CHAR) 
    RETURN NUMBER
AS
    V_QAVG NUMBER := 0;
    V_YEAR CHAR(5) := P_YEAR || '%'; -- 나중에 LIKE 사용할 때 안붙이고 사용하려고
BEGIN
    SELECT ROUND(AVG(CART_QTY)) INTO V_QAVG
      FROM CART
     WHERE CART_NO LIKE V_YEAR,
       AND CART_PROD = P_CODE; 
       
     RETURN V_QAVG;
END;
-- 오류

(실행)
SELECT PROD_ID,
       PROD_NAME,
       FN_CART_QAVG(PROD_ID, '2005')
  FROM PROD;




[문제]
2005년 2~3월 제품별 매입수량을 구하여 재고수불테이블을 UPDATE 하시오.
처리일자는 2005년 3월 마지막일이다. - 함수 이용, 이름은 알아서
-- 빨리해야 TRIGGER 이용할 수 있어요

(함수생성)
CREATE FUNCTION FN_REMAIN_IN(
    P_CODE PROD.PROD_ID%TYPE,
    P_CNT IN NUMBER) 
    RETURN NUMBER 
AS
    V_PQTY NUMBER := 0;
BEGIN
    -- (일반SQL1)
    UPDATE REMAIN
       SET (REMAIN_I, REMAIN_J_99, REMAIN_DATE) 
         = (SELECT REMAIN_I + P_CNT, REMAIN_J_99 + P_CNT, TO_DATE('2005/01/31', 'YYYY/MM/DD')
              FROM REMAIN
             WHERE REMAIN_YEAR = '2005'
               AND PROD_ID = P_CODE)
     WHERE REMAIN_YEAR = '2005'
       AND PROD_ID = P_CODE;
END;


(실행)
 SELECT BUY_PROD BCODE, SUM(BUY_QTY) BAMT
      FROM BUYPROD
     WHERE BUY_DATE BETWEEN TO_DATE('2005/02/01', 'YYYY/MM/DD') AND TO_DATE('2005/02/31', 'YYYY/MM/DD')
     GROUP BY BUY_PROD;


LAST_DAY(SYSDATE);

--
CREATE OR REPLACE FN_REMAIN_UPDATE(
    P_PID IN PROD.PROD_ID%TYPE,
    P_QTY IN BUYPROD.BUY_QTY%TYPE,
    P_DATE IN DATE)  
    RETURN VARCHAR2
AS
    V_MESSAGE VARCHAR2(100);
BEGIN
    UPDATE REMAIN
       SET (REMAIN_I, REMAIN_J_99, REMAIN_DATE) = (
            SELECT REMAIN_I + P_QTY, REMAIN_J_99 + P_QTY, P_DATE
              FROM REMAIN
             WHERE REMAIN_YEAR = '2005' -- REMAIN 테이블에서 상품을 찾아 집어넣으면, 
                                        -- REMAIN 테이블에 있는 '모든' 상품들이 업데이트 된다.
                                        -- 근데 모든행에 값이 들어있지는 않겠죠. 그런 애들은 NULL값 처리가 된다.
                                        -- WHERE절이 없으면 모든 행이 처리 대상
               AND PROD_ID = P_PID) -- 현재 가지고 있는 테이블에 2,3월 입고수량 추가
     WHERE REMAIN_YEAR = '2005'
       AND PROD_ID = P_PID; -- 업데이트될 쿼리에 적용되어질 조건
    V_MESSAGE := P_PID||'제품 입고처리 완료';
    RETURN V_MESSAGE;
END;
-- 오류
    
SELECT * FROM REMAIN;

DECLARE
    CURSOR CUR_BUYPROD
    IS
        SELECT BUY_PROD, SUM(BUY_QTY) AS AMT
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN TO_DATE('2005/02/01', 'YYYY/MM/DD') AND TO_DATE('2005/03/31', 'YYYY/MM/DD')
         GROUP BY BUY_PROD;
    V_RES VARCHAR2(100);
BEGIN
    FOR REC_BUYPROD IN CUR_BUYPROD LOOP
        V_RES:=FN_REMAIN_UPDATE(REC_BUYPROD.BUY_PROD, REC_BUYPROD.AMT, LAST_DAY('20050331'));
        DBMS_OUTPUT.PUT_LINE(V_RES);
    END LOOP;
END;
-- 오류




2021-04-09_02 TRIGGER
#TRIGGER
- 어떤 이벤트가 발생하면 그 이벤트의 발생 전, 후로 자동적으로 실행되는
  코드블록(프로시저의 일종)
  
(사용형식)
CREATE TRIGGER 트리거명
-- 타이밍은 2개: BEFORE, AFTER - AFTER가 주로 쓰인다.
  (timing)BEFORE|AFTER (event)INSERT|UPDATE|DELETE -- 이벤트 종류는 이 3가지가 전부다.
  ON 테이블명
  [FOR EACH ROW] -- 각 행마다 적용, 자주 쓴다, 행단위 트리거는 결과행마다 한번씩 트리거가 나온다
                 -- 트리거 수행 중에 다른 트리거를 호출하면 문제 발생 -> 데이터 보호를 위해 락이 걸리고 오류가 발생한다
                 -- :NEW, :OLD 나중에 이런 변수 사용, 사용하면 편리하다 
                                                    -- 사용이 편리 ...
  [WHEN 조건] -- 이벤트를 발생시킬 구체적인 정보를 추가로 기입하고 싶을 때 사용
[DECLARE
    변수, 상수, 커서; -- 왜냐하면 위에 AS가 없기 때문
]
 BEGIN
    명령문(들); -- 88트리거처리문88
    [EXCEPTION
        예외처리문;
    ]   
 END;

- TIMING : 트리거처리문 수행 시점(BEFORE : 이벤트 발생 전, AFTER : 이벤트 발생 후)
- EVㅗENT  : 트리거가 발생될 원인 행위 : INSERT, UPDATE, DELETE (OR로 연결 사용 가능, ex.INSERT OR UPDATE OR DELETE) 
- 테이블명: 이벤트가 발생되는 테이블 이름
- FOR EACH ROW : 행단위 트리거 발생, 생략되면 문장단위 트리거 발생
- WHEN 조건 : 행단위 트리거에서만 사용 가능, 이벤트가 발생될 세부 조건 추가 설정

신속하게 바로 뒤따라 와야 할 업무들을 처리
ex. 물건을 주문했다
카트에 주문 넣기 -> 재고에서 마이너스 
INSERT CART 후에 -> UPDATE REMAIN 트리거 발생

프로젝트 시작하면 DB설계가 제일 힘들다.
-- 내일 주말이라 좋기는 한데 걱정스러워...
교림 SOFT 양방향 교육 도구 - DB 설계 공부



-- 복붙, 마음의 속도 만족감
-- 그리는나, 발전




 