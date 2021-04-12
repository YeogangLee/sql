2021-04-12_01
d8
/*
- 문장단위 트리거 (잘 사용X)
- 행단위 트리거
   : CREATE 블럭에 FOR EACH ROW 키워드 사용
- CART 테이블이 대표적 행단위 트리거 사용 예시

- DECLARE : 트리거에서 변수 선언할 필요가 있을 때, 이렇게 DECLARE 블록 사용

= SQL의 이벤트 3가지와 :NEW, :OLD 변수 -- 기존에 없던 자료 NEW, 기존에 있는 자료 OLD
- INSERT : NEW
- UPDATE : NEW, OLD -- 기존에 존재하는 데이터는 OLD, 새로 들어오는 데이터는 NEW
- DELETE : OLD

88 트리거 함수
- 트리거를 유발시킨 DML을 구별하기 위해 사용
------------------------------------------------------------------
함수          의미
------------------------------------------------------------------
INSERTING    트리거의 EVENT 가 INSERT 이면 참(TRUE) 반환
UPDATING    트리거의 EVENT 가 UPDATE 이면 참(TRUE) 반환
DELETING     트리거의 EVENT 가 DELETE 이면 참(TRUE) 반환

- 트리거 함수 사용 예시
BEGIN
    IF INSERTING THEN
        V_QTY := :NEW.CART_QTY;
        V_PROD := :NEW.CART_PROD;
    ELSIF UPDATING THEN
        V_QTY := :NEW.CART_QTY - :OLD.CART_QTY;   
        V_PROD := :NEW.CART_PROD; -- PROD는 변동X
    ELSE -- DELETING
        V_QTY := -(:OLD.CART_QTY);
        V_PROD := :OLD.CART_PROD;
    END IF;
...
*/

-- 저번 시간 TRIGGER 이어서
PL/SQL을 사용하며 트리거를 사용할 일이 자주 있을 거다


- 문장단위 트리거
예); 상품 분류 테이블에 자료를 삽입하시오
    '상품분류코드가 추가 되었습니다.'라는 메시지를 트리거를 이용하여 출력하시오
- lprod_gu : 'P601'
- lprod_nm : '신선식품'

(트리거 생성)
CREATE OR REPLACE TRIGGER TG_LPROD_INSERT -- 트리거명 뒤에 괄호X
    AFTER INSERT ON LPROD
    -- FOR EACH ROW 가 생략되어 해당 트리거는 문장단위 트리거, 생략X = 행단위 트리거
BEGIN
    DBMS_OUTPUT.PUT_LINE('상품분류코드가 추가 되었습니다.');
END;

(이벤트)
INSERT INTO LPROD
    VALUES(10,'P601','신선식품'); -- 여기까지만 실행하면 RELOAD 전이라, 추가된 행이 보이지 않음
    
SELECT * FROM LPROD; -- RELOAD 과정 대신 수행

    
- 행단위 트리거
사용예);
매입테이블에서 2005년 4월 16일 상품 'P101000001'을 매입한 다음 -- 매입테이블에 상품 INSERT
재고수량을 UPDATE 하시오.
[매입정보]
1.상품코드 : 'P101000001'
2.날짜 : 20050416
3. 매입수량 : 5
4. 단가 : 210000

CART 테이블이 대표적 행단위 트리거 사용 예시
한 고객이 여러 상품을 샀을 때, 구매 상품의 종류마다(행마다) UPDATE 수행

(트리거 생성)
CREATE OR REPLACE TRIGGER TG_REMAIN_UPDATE
    AFTER INSERT OR UPDATE OR DELETE ON BUYPROD -- BUYPROD 매입장, 매입정보가 저장되는 곳 <-> CART 매출장
    -- 무슨 이벤트 발생 후에 트리거를 실행시킬지 모르거나, 여러 이벤트 후에 트리거를 발생시킬 거라면,
    -- 이렇게 OR로 이벤트를 여러 개 묶는 게 가능
    FOR EACH ROW
BEGIN
    UPDATE REMAIN  -- REMAIN_J_99 현재 재고
       SET (REMAIN_I, REMAIN_J_99, REMAIN_DATE)
         = (SELECT REMAIN_I + :NEW.BUY_QTY, REMAIN_J_99 + :NEW.BUY_QTY, '20050416'
                              -- 기존에 없던 자료 NEW, 기존에 있는 자료 OLD
              FROM REMAIN
             WHERE REMAIN_YEAR = '2005'
               -- AND REMAIN_DATE = TO_DATE('20050416')
               AND PROD_ID = :NEW.BUY_PROD) -- NEW : 한 행 전체를 의미, 컬럼 접근 -> NEW.컬럼이름
     
     WHERE REMAIN_YEAR = '2005'
                -- AND REMAIN_DATE = TO_DATE('20050416')
                AND PROD_ID = :NEW.BUY_PROD;
END;

INSERT INTO BUYPROD
    VALUES(TO_DATE('20050416','YYYYMMDD'),'P101000001',5,210000);

-- 트리거 실행된 후 값 확인    
SELECT * FROM REMAIN ORDER BY REMAIN_DATE DESC;    

- NEW vs OLD
INSERT - NEW
UPDATE - NEW, OLD -- 기존에 존재하는 데이터는 OLD, 새로 들어오는 데이터는 NEW
DELETE - OLD
    
    
88 트리거
- 데이터의 무결성 제약을 강화
- 트리거 내부에는 트랜잭션 제어문(COMMIT, ROLLBACK, SAVEPOINT 등)을 사용할 수 없음
- 트리거 내부에 사용되는 PROCEDURE, FUNCTION 에서도 트랜잭션 제어문을 사용할 수 없음
- LONG, LONG RAW 등의 변수 선언 사용할 수 없음

88 트리거 의사 레코드
1) :NEW - INSERT, UPDATE 에서 사용,
          데이터가 삽입(갱신)될 때, 새롭게 들어오는 자료
          DELETE 시에는 모두 NULL 로 SETTING
          
2) :OLD - DELETE, UPDATE 에서 사용,
          데이터가 삭제(갱신)될 때 이미 존재하고 있던 자료
          INSERT 시에는 모두 NULL 로 SETTING
          
88 트리거 함수
- 트리거를 유발시킨 DML을 구별하기 위해 사용
-----------------------------------------------------
함수          의미
-----------------------------------------------------
INSERTING    트리거의 EVENT 가 INSERT 이면 참(TRUE) 반환
UPDATING     트리거의 EVENT 가 UPDATE 이면 참(TRUE) 반환
DELETING     트리거의 EVENT 가 DELETE 이면 참(TRUE) 반환


사용예1); 장바구니 테이블에 신규 판매자료가 삽입될 때 재고를 처리하는 트리거를 작성

CREATE OR REPLACE TRIGGER TG_REMAIN_CART_UPDATE
    AFTER INSERT OR UPDATE OR DELETE ON CART
    FOR EACH ROW
DECLARE -- 트리거에서 변수 선언할 필요가 있을 때, 이렇게 DECLARE 블록 사용
    V_QTY CART.CART_QTY%TYPE;
    V_PROD PROD.PROD_ID%TYPE;
BEGIN
    IF INSERTING THEN
        V_QTY := :NEW.CART_QTY;
        V_PROD := :NEW.CART_PROD;
    ELSIF UPDATING THEN
        V_QTY := :NEW.CART_QTY - :OLD.CART_QTY;   
        V_PROD := :NEW.CART_PROD; -- PROD는 변동X
    ELSE -- DELETING
        V_QTY := -(:OLD.CART_QTY);
        V_PROD := :OLD.CART_PROD;
    END IF;
    UPDATE REMAIN
       SET REMAIN_O = REMAIN_O + V_QTY, -- 재고 테이블에 OUT되는 수만큼 표시해야 해서 + V_QTY가 맞고
           REMAIN_J_99 = REMAIN_J_99 - V_QTY, -- 재고 테이블에 남아있는 건, V_QTY만큼 나가는 거니까 -V_QTY가 맞다
           REMAIN_DATE = SYSDATE
     WHERE REMAIN_YEAR = '2005'
       AND PROD_ID = V_PROD;
       
    DBMS_OUTPUT.PUT_LINE(V_PROD||'상품 재고수량 변동 : '||V_QTY);
END;


(INSERT - INSERTING)
'a001'회원이 상품 'P101000003'을 5개 구매한 경우
INSERT INTO cart
    VALUES('a001', '2021041200001', 'P101000003', 5); -- => :NEW
-- 값 넣기 전에 기존값 확인 -- 15 21 0 36
SELECT * 
  FROM REMAIN 
 WHERE prod_id = 'P101000003';
 -- 변경 후 -- 15 21 5 31
 
COMMIT;

SELECT * FROM cart;
SELECT * FROM REMAIN ORDER BY REMAIN_DATE DESC;


(UPDATE - UPDATING)
UPDATE CART
   SET CART_QTY = 7
 WHERE CART_NO = '2021041200001'
   AND CART_PROD = 'P101000003';
   
-- 데이터 이상해서 강제 수정   
--UPDATE REMAIN
--   SET REMAIN_O = 0,
--       REMAIN_J_99 = 36
-- WHERE PROD_ID = 'P101000003'; 
 
COMMIT;
   
SELECT *
  FROM CART
 WHERE CART_NO = '2021041200001'
   AND CART_PROD = 'P101000003';
 
SELECT * 
  FROM REMAIN 
 WHERE REMAIN_YEAR = '2005'
   AND prod_id = 'P101000003';


(DELETE - DELETING)
DELETE CART 
 WHERE CART_NO = '2021041200001'
   AND CART_PROD = 'P101000003';

SELECT * 
  FROM REMAIN 
 WHERE prod_id = 'P101000003';

ROLLBACK;


-- 지금 우리가 쓰는 CART 테이블, 같은 품목 여러 개 사면 여러 개만큼 저장
-- BUT 결제는 단 한 번 이루어지니, 불필요한 데이터가 많다


문제);
'f001'회원이 오늘 상품 'P202000001'을 15개 구매했을 때
이 정보를 cart 테이블에 저장한 후 재고수불 테이블과 회원테이블(마일리지)를
변경하는 트리거를 작성하시오. -- CART, REMAIN, MEMBER

-- 문제 풀기전에 마일리지 값 세팅
UPDATE PROD
   SET PROD_MILEAGE = ROUND(PROD_PRICE * 0.001);
COMMIT;

--

INSERT INTO CART               -- 문제에 카트 번호가 없어도, 오늘이라는 말만 보고 알아서 작성?
--  VALUES(CART_MEMBER = 'f001', CART_NO = '2021041200001', CART_PROD = 'P202000001', CART_QTY = 15);
  VALUES('f001', '2021041200001', 'P202000001', 15);
  
SELECT * FROM CART WHERE CART_PROD = 'P202000001';  

(트리거 생성)
CREATE OR REPLACE TRIGGER TG_REMAIN_MEMBER_UPDATE       -- 1
    AFTER INSERT OR UPDATE OR DELETE ON CART
    FOR EACH ROW
DECLARE
    V_MID CART.CART_MEMBER%TYPE;
    V_QTY CART.CART_QTY%TYPE;
    V_PROD CART.PROD_ID%TYPE;
BEGIN
    IF INSERTING THEN
        V_QTY := :NEW.CART_QTY;
        V_PROD := :NEW.CART_PROD;                       -- 11
    ELSIF UPDATING THEN
        V_QTY := :NEW.CART_QTY - :OLD.CART_QTY;   
        V_PROD := :NEW.CART_PROD; -- PROD는 변동X
    ELSE -- DELETING
        V_QTY := -(:OLD.CART_QTY);
        V_PROD := :OLD.CART_PROD;
    END IF;
    
    -- 재고수불 테이블 업데이트
    UPDATE REMAIN
       SET REMAIN_O = REMAIN_O + V_QTY, -- 재고 테이블에 OUT되는 수만큼 표시해야 해서 + V_QTY가 맞고    -- 21
           REMAIN_J_99 = REMAIN_J_99 - V_QTY, -- 재고 테이블에 남아있는 건, V_QTY만큼 나가는 거니까 -V_QTY가 맞다
           REMAIN_DATE = SYSDATE
     WHERE REMAIN_YEAR = '2005'
       AND PROD_ID = V_PROD;

    -- 멤버 테이블 업데이트
    UPDATE MEMBER
       SET MEM_MILEAGE = MEM_MILEAGE - V_QTY
     WHERE MEMBER.MEM_ID = V_MID;

    DBMS_OUTPUT.PUT_LINE(V_PROD||'상품 재고수량 변동 : '||V_QTY);
END;
