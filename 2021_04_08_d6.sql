2021-04-08_01
/*

*/


- 테이블의 구조 변경 : ALTER TABLE 테이블명

1.테이블 컬럼명 변경 : RENAME COLUMN A TO B;
ALTER TABLE 테이블명
    RENAME COLUMN 변경 대상 컬럼 TO 변경 컬럼명;
    
ex. TEMP 테이블의 ABC를 QAZ라는 컬럼명으로 변경
    ALTER TABLE TEMP
        RENAME COLUMN ABC TO QAZ;
        
2.컬럼 데이터타입(크기) 변경 : MODIFY A 자료형(크기)
ALTER TABLE 테이블명
    MODIFY 컬럼명 데이터타입(크기);
    
ex. TEMP 테이블의 ABC 컬럼을 NUMBER(10)으로 변경하는 경우
ALTER TABLE TEMP
    MODIFY ABC NUMBER(10);
    -- 해당 컬럼의 내용을 모두 지워야 변경 가능   
    

- 1.VARCHAR2 -> CHAR -> 2.VARCHAR2

1의 VARCHAR2 는 쓰지 않는 공간은 알아서 버려준다
그런데 고정된 크기를 갖는 CHAR 로 변환 후 다시 VARCHAR2 로 변환을 거치면
2의 VARCHAR2 는 고정된 크기를 갖는 CHAR 크기를 그대로 가지면서
기존의 VARCHAR2 같은 속성을 지니지 않는다. 
    

-- 저번 시간 이어서

사용예);
오늘이 2005년 1월 31일이라고 가정하고 오늘까지 발생된 상품입고 정보를 이용하여
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
재고수불 테이블을 UPDATE 하는 프로시저를 생성하시오. --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1. 프로시저명 : PROC_REMAIN_IN
2. 매개변수 : 상품코드, 매입수량
3. 처리 내용 : 해당 상품코드에 대한 입고수량, 현 재고수량, 날짜 UPDATE

-- 여기서 시작
CREATE PROCEDURE PROC_REMAIN_IN()
IS -- 지역변수
BEGIN -- SELECT 일반 SQL 쿼리문
END;

88
1. 2005년 상품별 매입수량 집계 -- 프로시저 밖에서 처리
   -- SELECT 문 필요
2. 1의 결과 각 행을 PROCEDURE 에 전달
   -- CURSOR 필요
3. PROCEDURE 에서 재고 수불테이블 UPDATE

모드에서 데이터를 받으므로 IN 사용

(PROCEDURE 생성)
CREATE OR REPLACE PROCEDURE PROC_REMAIN_IN(
    P_CODE PROD.PROD_ID%TYPE, -- 참조형 데이터타입 사용 가능
    -- 변수명과 자료형 사이에 IN 생략 가능
    P_CNT IN NUMBER) -- XX크기지정XX, 매개변수는 데이터 타입만 쓴다
IS
-- 지역변수, 쓸 게 없을 때는 비워두기
BEGIN
    UPDATE REMAIN
       SET (REMAIN_I, REMAIN_J_99, REMAIN_DATE) 
         = (SELECT REMAIN_I + P_CNT, REMAIN_J_99 + P_CNT, TO_DATE('2005/01/31', 'YYYY/MM/DD')
              FROM REMAIN
             WHERE REMAIN_YEAR = '2005'
               AND PROD_ID = P_CODE) -- 서브쿼리라서 SELECT, FROM, WHERE 명시
        -- 현재 REMAIN_I가 가지고 있는 값(기존 재고) + P_CNT (새로 들어오는 상품)
     WHERE REMAIN_YEAR = '2005'
       AND PROD_ID = P_CODE;
END;

2.프로시저 실행 명령
EXEC|EXECUTE 프로시저명[(매개변수 LIST)];
- 단, 익명블록 등 또다른 프로시저나 함수에서 프로시저 호출시 'EXEC|EXECUTE'는 생략해야 한다
-- 그러면 또다른 프로시저, 함수 외에 프로시저는 어디서 또 쓰일 수 있는거지?

(2005년 상품별 매입집계)
SELECT BUY_PROD BCODE,
       SUM(BUY_QTY) BAMT
        -- SELECT : 프로시저한테 넘겨줘야 하는 것들, 그냥 컬럼은 상관X,
        --          그런데 함수가 적용된 SUM(BUY_QTY)은 어떻게 넘길까?
        --          => 컬럼 별칭 사용
        -- 이제까지 컬럼 별칭은 컬럼 제목 정리에만 사용해왔는데,
        -- 이렇게 함수가 적용된 컬럼값을 넘겨주는 데에 사용되기도 한다.
  FROM BUYPROD
 WHERE BUY_DATE BETWEEN TO_DATE('2005/01/01', 'YYYY/MM/DD') AND TO_DATE('2005/01/31', 'YYYY/MM/DD')
 GROUP BY BUY_PROD;


(익명블록 작성)
DECLARE
    CURSOR CUR_BUY_AMT 
    IS
    SELECT BUY_PROD BCODE, SUM(BUY_QTY) BAMT
      FROM BUYPROD
     WHERE BUY_DATE BETWEEN TO_DATE('2005/01/01', 'YYYY/MM/DD') AND TO_DATE('2005/01/31', 'YYYY/MM/DD')
     GROUP BY BUY_PROD;
BEGIN
-- 이전에 만들었던 프로시저 호출
    FOR REC01 IN CUR_BUY_AMT LOOP
        PROC_REMAIN_IN(REC01.BCODE, REC01.BAMT); -- 커서가 행을 읽어오기 때문에, 테이블명(커서이름.컬럼명)
        -- (상품코드, 매입수량) -> (BCODE, BAMT) -> (REC01.BCODE, REC01.BAMT)
    END LOOP;
END;        


88 remain테이블의 내용을 VIEW 로 구성
CREATE OR REPLACE VIEW V_REMAIN01
AS
    SELECT * FROM REMAIN;
CREATE OR REPLACE VIEW V_REMAIN02
AS
    SELECT * FROM REMAIN;

SELECT * FROM V_REMAIN01;
SELECT * FROM V_REMAIN02;
-- 실수 - 뷰 생성때 WITH READ ON을 안 써서 둘이 똑같아졌다.


사용예);
회원아이디를 입력 받아 그 회원의 이름, 주소와 직업을
반환하는 프로시저를 작성하시오.
1. 프로시저명 : PROC_MEM_INFO -- 매개변수가 몇 개 필요? 4개 필요 -> 입력용/1.회원아이디, 출력용/2.이름,3.주소,4.직업
2. 매개변수 : 입력용 - 회원아이디
             출력용 - 이름, 주소, 직업
-- 프로시저는 반환값이 없지만, 매개변수를 통해서는 반환할 수 있다

(프로시저 생성)
CREATE OR REPLACE PROCEDURE PROC_MEM_INFO (
    P_ID MEMBER.MEM_ID%TYPE, -- 입력용 변수는 IN 생략 가능
    P_NAME OUT MEMBER.MEM_NAME%TYPE, -- 출력용 변수는 OUT 생략 불가능
    P_ADDR OUT VARCHAR2, 
    P_JOB OUT MEMBER.MEM_JOB%TYPE)
    -- . -> 소속을 의미
    -- 자바 vs C++
    -- 자바에는 다중 상속이 없고, C++에서는 ::로 다중상속 이용
    -- 근데 사실 없앤척 한거지 자바에도 다중 상속 이용 가능
    -- 부모 둘 다 가지고 있는 속성을 자식이 물려 받으면, 아빠가 준건지 엄마가 준건지
    -- 자바에서는 알 수 없지만, C++에서는 다중 상속을 이용해서, 누구의 속성인지 알 수 있다
AS
BEGIN
    SELECT MEM_NAME, MEM_ADD1||' '||MEM_ADD2, MEM_JOB
      INTO P_NAME, P_ADDR, P_JOB
      FROM MEMBER
     WHERE MEM_ID = P_ID;
END;
-- 프로시저를 실행하면, 프로시저 밖에서 OUT 매개변수를 받는다
-- 블록에서 OUT 매개변수를 받아서 사용한다
-- 일반 SQL은 변수 선언 불가능 -> PLSQL을 이용해서 이 프로시저를 실행시킨다

(실행)
-- 키보드로 입력 받기 : ACCEPT ㅁㅊㅊ
ACCEPT PID PROMPT '회원아이디 : ' -- PROMPT : 입력 창을 띄워준다.
DECLARE
    V_NAME MEMBER.MEM_NAME%TYPE;
    V_ADDR VARCHAR2(200); -- 여기는 익명블럭, 프로시저에서는 크기XX
    V_JOB MEMBER.MEM_JOB%TYPE;
BEGIN
               -- LOWER로 입력 받으면 대소문자 입력 구분없이 소문자로 취급
    PROC_MEM_INFO(LOWER('&PID'), V_NAME, V_ADDR, V_JOB); -- &PID : ID는 입력받아서 프로시저한테 넘겨줄 거야
    DBMS_OUTPUT.PUT_LINE('회원아이디 :'||'&PID'); -- 출력할 때도 PID가 아닌, 입력받을 때처럼 &PID 이렇게 사용
    DBMS_OUTPUT.PUT_LINE('회원 이름 : '||V_NAME);
    DBMS_OUTPUT.PUT_LINE('회원 주소 : '||V_ADDR);
    DBMS_OUTPUT.PUT_LINE('회원 직업 : '||V_JOB);
END;
-- c001 입력해서 확인
-- 테이블에 없는 데이터를 입력하면 "no data found" 오류 발생


문제);
년도를 입력 받아 해당 년도에 구매를 가장 많이한 회원이름과 구매액을
반환하는 프로시저를 작성하시오
1. 프로시저명 : PROC_MEM_PTOP
2. 매개변수 : 입력용 - 년도
             출력용 - 회원명, 구매액
-- 한 사람만 찾는 거라서 커서 사용X

--(생성)
--CREATE OR REPLACE PROCEDURE PROC_MEM_PTOP(
--    P_YEAR IN BUYPROD.BUY_DATE%TYPE,
--    P_NAME OUT MEMBER.MEM_NAME%TYPE,
--    P_COST OUT BUYPROD.BUY_COST%TYPE     )
--AS
--BEGIN
--    SELECT C.CART_NO, A.MEM_NAME, B.BUY_COST 
--      INTO P_YEAR, P_NAME, P_COST
--      FROM MEMBER A, BUYPROD B, CART C
--    WHERE B.BUY_PROD = C.CART_PROD
--      AND A.MEM_ID = C.CART_MEMBER;
--END;
--
--(실행)
--ACCEPT PYEAR PROMPT '구매 연도 : '
--DECLARE
--    V_NAME MEMBER.MEM_NAME%TYPE;
--    V_COST BUYPROD.BUY_COST%TYPE;
--BEGIN
--    PROC_MEM_INFO('&PYEAR', V_NAME, V_COST);
--    DBMS_OUTPUT.PUT_LINE('구매 연도 :'||'&PYEAR');
--    DBMS_OUTPUT.PUT_LINE('회원 이름 : '||V_NAME);
--    DBMS_OUTPUT.PUT_LINE('구매 가격 : '||V_COST);
--END;


-- 일반 SQL 쿼리 작성을 못하니 손도 못 대고 있지...
- 2005년 회원별 구매금액
필요한 컬럼 : 회원명 또는 회원아이디

SELECT C.CART_MEMBER,
       SUM(C.CART_QTY * P.PROD_PRICE) "회원별 구매금액"
  FROM CART C, PROD P
 WHERE C.CART_PROD = P.PROD_ID
 GROUP BY C.CART_MEMBER
 ORDER BY 2 DESC; -- SELECT 문에서 첫 번째 컬럼이 1, 두 번째 컬럼이 2
-- 여기서 나온 두 컬럼을 프로시저한테 넘겨준다

SELECT C.CART_MEMBER,
       SUM(C.CART_QTY * P.PROD_PRICE) "회원별 구매금액"
  FROM CART C, PROD P
 WHERE C.CART_PROD = P.PROD_ID
   AND ROWNUM = 1
   AND SUBSTR(C.CART_NO, 1, 4) = '2005'
 GROUP BY C.CART_MEMBER
 ORDER BY 2 DESC; -- SELECT 문에서 첫 번째 컬럼이 1, 두 번째 컬럼이 2
-- 순서 이상, 이걸 잡아주기 위해 서브쿼리 사용


-- 서브쿼리 이용 88**
SELECT M.MEM_NAME, A.AMT 
    -- 이름은 MEMBER 테이블에 있다
  FROM (SELECT C.CART_MEMBER AS MID,
               SUM(C.CART_QTY * P.PROD_PRICE) AS AMT
          FROM CART C, PROD P
         WHERE C.CART_PROD = P.PROD_ID
           AND SUBSTR(C.CART_NO, 1, 4) = '2005'
         GROUP BY C.CART_MEMBER
         ORDER BY 2 DESC) A, MEMBER M
WHERE M.MEM_ID = A.MID -- 이름 가지고 오고 싶어서 JOIN
  AND ROWNUM = 1; -- ROWNUM 을 바깥에 이용
  
-- 얘를 못 만들면 프로시저는 의미가 없다, 껍데기


-- 오라클 복습 안해도 되는데, 수업시간에 집중해라
CREATE OR REPLACE PROCEDURE PROC_MEM_PTOP(
    P_YEAR IN CHAR,
    P_NAME OUT MEMBER.MEM_NAME%TYPE, -- 일반 자료형 VARCHAR2 를 사용하더라도 상관은 없지만, 
                                     -- 기존에 존재하는 테이블의 컬럼을 정확히 알고 있을 때는
                                     -- 기존에 존재하는 데이터 타입을 사용하면 좋다
    P_AMT OUT NUMBER)
AS
BEGIN
SELECT M.MEM_NAME, A.AMT -- 이름은 MEMBER 테이블에 있다
  INTO P_NAME, P_AMT
  FROM (SELECT C.CART_MEMBER AS MID,
               SUM(C.CART_QTY * P.PROD_PRICE) AS AMT
          FROM CART C, PROD P
         WHERE C.CART_PROD = P.PROD_ID
           AND SUBSTR(C.CART_NO, 1, 4) = P_YEAR
         GROUP BY C.CART_MEMBER
         ORDER BY 2 DESC) A, MEMBER M
WHERE M.MEM_ID = A.MID -- 이름 가지고 오고 싶어서 JOIN
  AND ROWNUM = 1; -- ROWNUM 을 바깥에 이용
END;


(실행)
DECLARE
    V_NAME MEMBER.MEM_NAME%TYPE; -- 매개변수가 아니니 ; 붙여줘라
    V_AMT NUMBER := 0;
BEGIN
    -- EXEC, EXECUTE 반드시 생략 -> 익명블록 내부에서 호출했으므로
    PROC_MEM_PTOP('2005', V_NAME, V_AMT);
    DBMS_OUTPUT.PUT_LINE('회원이름 : '||V_NAME);
    DBMS_OUTPUT.PUT_LINE('구매금액 : '||TO_CHAR(V_AMT, '99,999,999'));
END;
  
  
문제);
2005년도 구매금액이 없는 회원을 찾아 회원테이블(MEMBER)의
삭제여부 컬럼(MEM_DELETE)의 값을 'Y'로 변경하는 프로시저 작성

1. 구매금액이 없는 회원을 찾는다 - 회원번호 필요
2. 여러명일 경우 CURSOR 이용 - 커서에서 회원번호 생성
3. 커서에서 읽은 값을 MEMBER 테이블과 비교
4. 그 행들을 Y로 업데이트

SELECT *
  FROM CART, MEMBER
 WHERE member.mem_id = cart.cart_member;
 
select h.컬럼1, s.컬럼1 from 테이블 h inner join 테이블 s on h.컬럼2 = s.컬럼2
where h.컬럼1 != s.컬럼1

SELECT C.CART_MEMBER,
       SUM(C.CART_QTY * P.PROD_PRICE) "회원별 구매금액"
  FROM CART C, PROD P
 WHERE C.CART_PROD = P.PROD_ID
 GROUP BY C.CART_MEMBER
 ORDER BY C.CART_MEMBER;
 
SELECT b.mem_id
FROM (SELECT cart_member, mem_id
        FROM CART, MEMBER
       WHERE member.mem_id = cart.cart_member) A, MEMBER B
WHERE b.mem_id NOT IN a.mem_id;


-- https://yamalab.tistory.com/7
-- 주문하지 않은 고객의 이름
select name
from customer cs
where cs.custid not in (select od.custid
                        from orders od)

1.구매금액이 없는 회원
SELECT mem_id
  FROM member
 WHERE member.mem_id NOT IN (SELECT cart_member FROM cart);

-- 2.패스

SELECT a.mem_id, b.MEM_DELETE
  FROM (SELECT mem_id
          FROM member
         WHERE member.mem_id NOT IN (SELECT cart_member FROM cart)) A, MEMBER B
 WHERE A.mem_id = b.mem_id;  


업데이트 프로시저
(PROCEDURE 생성)
CREATE OR REPLACE PROCEDURE PROC_REMAIN_IN(
    P_ID OUT MEMBER.MEM_ID%TYPE,
    P_DELETE OUT MEMBER.MEM_DELETE%TYPE) -- XX크기지정XX, 매개변수는 데이터 타입만 쓴다
AS
BEGIN
    UPDATE MEMBER
       SET (MEM_DELETE) = ('Y')
--    SELECT MEM_ID, MEM_DELETE
     FROM MEMBER
     WHERE MEM_ID IN (SELECT P_ID
                        FROM member
                       WHERE member.mem_id NOT IN (SELECT cart_member FROM cart));
       AND member.mem_id NOT IN (SELECT cart_member FROM cart)
                               
--                     (SELECT a.mem_id
--                        FROM (SELECT mem_id
--                                FROM member
--                               WHERE member.mem_id NOT IN (SELECT cart_member FROM cart)) A, MEMBER B
--                       WHERE A.mem_id = b.mem_id)
END;

ROLLBACK;

