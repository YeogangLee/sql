2021-04-06_01 -- (화)

-- 저번 시간 이어서
-- 서브쿼리 내의 AND ROWNUM = 1 삭제 후  
SELECT D.MID AS 회원번호,
       B.MEM_NAME AS 회원명,
       D.AMT AS 구매금액합
  FROM (SELECT A.CART_MEMBER AS MID,
               SUM(C.PROD_PRICE * A.CART_QTY) AS AMT
          FROM CART A, PROD C
         WHERE A.CART_PROD = C.PROD_ID
      GROUP BY A.CART_MEMBER
      ORDER BY 2 DESC) D, MEMBER B
WHERE D.MID = B.MEM_ID
  AND ROWNUM = 1;
  
  
-- 위의 view 생성
CREATE VIEW V_MAXAMT AS
    SELECT D.MID AS 회원번호,
           B.MEM_NAME AS 회원명,
           D.AMT AS 구매금액합
      FROM (SELECT A.CART_MEMBER AS MID,
                   SUM(C.PROD_PRICE * A.CART_QTY) AS AMT
              FROM CART A, PROD C
             WHERE A.CART_PROD = C.PROD_ID
          GROUP BY A.CART_MEMBER
          ORDER BY 2 DESC) D, MEMBER B
    WHERE D.MID = B.MEM_ID
      AND ROWNUM = 1;
  
SELECT * FROM V_MAXAMT;


이전까지의 SELECT  : SELECT FROM WHERE 
앞으로 배울 SELECT : SELECT INTO FROM WHERE

-- 오라클에서 ""이 사용되는 경우
1. 오라클에서 허용되지 않는 글자들을 사용할 때 ex.공백, 소문자
2. TO_CHAR, TO_DATE 등에서 사용자가 문자열을 직접 정의할 때


(익명블록)

DECLARE
    V_MID V_MAXAMT.회원번호%TYPE;
    V_NAME V_MAXAMT.회원명%TYPE;
    V_AMT V_MAXAMT.구매금액합%TYPE;
    V_RES VARCHAR2(100);
BEGIN
    --SELECT 회원번호, 회원명, 구매금액합
    SELECT 회원번호, 회원명, 구매금액합 INTO V_MID, V_NAME, V_AMT
      FROM V_MAXAMT;
    
    V_RES := V_MID||', '||V_NAME||', '||TO_CHAR(V_AMT, '99,999,999');
    DBMS_OUTPUT.PUT_LINE(V_RES);
END;    
    

-- 아래 문제 풀기 전에 DBMS 출력 창 띄우기
-- 보기 메뉴 > DBMS 출력 선택 
-- > DBMS 출력 창에서 창 활성화 시키기 : 초록색 + 눌러서 접속할 계정 선택

(상수사용예);
- 키보드로 수 하나를 입력 받아 그 값을 반지름으로 하는 원의 넓이를 구하시오.

ACCEPT P_NUM PROMPT '원의 반지름 : '
DECLARE
    V_RADIUS NUMBER := TO_NUMBER('&P_NUM');
    V_PI CONSTANT NUMBER := 3.1415926;
    V_RES NUMBER := 0;
BEGIN
    V_RES := V_RADIUS * V_RADIUS * V_PI;
    DBMS_OUTPUT.PUT_LINE('원의 너비 : '||V_RES);
END;
    

--
커서의 실행 프로세스
1.선언 DECLARE - 2.오픈 OPEN - 3.가져오기, 페치 FETCH - 4.종료, 클로즈 CLOSE

커서가 만들어지고 제일 처음 시작하는 포인터의 위치는 제일 위의 행
반복문 안에 페치 명령이 들어가면, 커서의 여러 행들을 반복적으로 처리할 수 있다

읽어오는 과정 페치 FETCH
닫기 CLOSE


#커서 CURSOR
- 커서는 쿼리문의 영향을 받은 행들의 집합
- 묵시적 커서 IMPLICITE, 명시적 커서 EXPLICITE 로 구분
- 커서의 선언은 선언부에서 수행
- 커서의 OPEN, FETCH, CLOSE 는 실행부에서 기술


1) 묵시적 커서 IMPLICITE CURSOR
- 이름이 없는 커서
- 항상 CLOSE 상태이기 때문에 커서 내로 접근 불가능

(커서 속성)
-----------------------------------------------------------------------
 속성               의미
-----------------------------------------------------------------------
 SQL%ISOPEN        커서가 OPEN 되었으면 참 TRUE 반환, 묵시적 커서는 항상 FALSE
 SQL%NOTFOUND      커서 내부에 읽을 자료가 없으면 참 TRUE 반환
 SQL%FOUND         커서 내부에 읽을 자료가 있으면 참 TRUE 반환
 SQL%ROWCOUNT      커서 내의 자료 수 반환, 행의 수
 
-- 위의 속성 이름 SQL%... 에서 SQL이 뜻하는 것은,
-- 원래 커서 이름인데 묵시적 커서는 이름이 없으므로 SQL을 붙여준 것이다.


2) 명시적 커서 EXPLICITE CURSOR
- 이름이 있는 커서
- 생성 -> OPEN -> FETCH -> CLOSE 순으로 처리해야 함(단, FOR 문은 제외)
--FOR 문에서는 인라인 커서 ...
-- 커서는 A 테이블의 자료를 들고올 때 사용, JOIN 할 필요가 없게 만드는 ... 또는 JOIN의 역할을 줄여주는

(1) 생성
(사용형식)
    CURSOR 커서명[(매개변수 list)]
    IS
        SELECT 문;
        
-- 다중행을 처리할 때 CURSOR를 많이 사용한다
-- 사용형식이 뷰하고 비슷하죠?

사용예)
상품 매입 테이블(BUYPROD)에서 2005년 3월 상품별 매입현황(상품코드, 상품명, 거래처명, 매입수량)을
출력하는 쿼리를 작성하시오.

DECLARE
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_BNAME BUYER.BUYER_NAME%TYPE;
    V_AMT NUMBER:=0; -- 초기화
    
    CURSOR CUR_BUY_INFO IS
        SELECT BUY_PROD, -- SELECT문부터 실행하면 6행 출력 
               SUM(BUY_QTY)
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
         GROUP BY BUY_PROD;
         
BEGIN
    -- 커서를 오픈하는 오픈 명령이 필요
    
END;


(2) OPEN 문
- 명시적 커서를 사용하기 전 커서를 OPEN

(사용형식) OPEN 커서명[(매개변수 list)];
-- 커서를 사용하려면 반드시 오픈 후 사용, 그래야 내부로 포인터가 접근할 수 있다

DECLARE
    -- 변수 선언
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_BNAME BUYER.BUYER_NAME%TYPE;
    V_AMT NUMBER:=0; -- 초기화
    
    -- (1)생성
    CURSOR CUR_BUY_INFO IS
        SELECT BUY_PROD, -- SELECT문부터 실행하면 6행 출력 
               SUM(BUY_QTY) AS AMT
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
         GROUP BY BUY_PROD;
         
BEGIN
    -- OPEN : BEGIN 과 END 사이에 자리한다.
    OPEN CUR_BUY_INFO;
END;


(3) FETCH 문
- 커서 내의 자료를 읽어오는 명령
- 대부분 반복문 내부에서 사용

(사용형식) FETCH 커서명 INTO 변수명
: 커서 내의 컬럼값을 INTO 다음 기술된 변수에 할당
-- SELECT 와 비슷하다


DECLARE
    -- 변수 선언
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_BNAME BUYER.BUYER_NAME%TYPE;
    V_AMT NUMBER:=0; -- 초기화
    
    -- (1)생성
    CURSOR CUR_BUY_INFO IS
        SELECT BUY_PROD, -- SELECT문부터 실행하면 6행 출력 
               SUM(BUY_QTY) AS AMT
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
         GROUP BY BUY_PROD;
         
BEGIN
    -- (2)오픈
    OPEN CUR_BUY_INFO;
    LOOP
        -- (3)페치 FETCH
        FETCH CUR_BUY_INFO INTO V_PCODE, V_AMT; -- 제일 처음 읽을 때 6행 중 1행의 값을 들고온다 - P201000020 39
        EXIT WHEN CUR_BUY_INFO%NOTFOUND; -- 값이 참일 때 밖으로 빠져나가자
            SELECT PROD_NAME, BUYER_NAME INTO V_PNAME, V_BNAME
              FROM PROD, BUYER
             WHERE PROD_ID = V_PCODE
               AND PROD_BUYER = BUYER_ID;
        DBMS_OUTPUT.PUT_LINE('상품코드 : '||V_PCODE);
        DBMS_OUTPUT.PUT_LINE('상품명 : '||V_PCODE);
        DBMS_OUTPUT.PUT_LINE('거래처명 : '||V_PCODE);
        DBMS_OUTPUT.PUT_LINE('매입수량 : '||V_PCODE);
        DBMS_OUTPUT.PUT_LINE('-------------------');
        DBMS_OUTPUT.PUT_LINE('자료수 : '||CUR_BUY_INFO%ROWCOUNT); -- 전체 행의 수, 몇 행의 자료를 처리했는지 알고 싶을 때
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('전체 자료수 : '||CUR_BUY_INFO%ROWCOUNT); -- 자료수를 출력 마지막에 1번만 쓰고 싶으면, 반복문 밖에 코드 사용
    -- 반복문이 끝나고 커서 닫아주기
    CLOSE CUR_BUY_INFO; -- (4)CLOSE
END;


사용예); 상품분류코드 'P102'에 속한 상품의 상품명, 매입가격, 마일리지를 출력하는 커서를 작성하시오.

(표준SQL)
SELECT PROD_NAME AS 상품명,
       PROD_COST AS 매입가격,
       PROD_MILEAGE AS 마일리지
  FROM PROD
 WHERE PROD_LGU = 'P102';
 -- 마일리지가 전부 null 값인 데이터들 조회됨
 
(PL/SQL)로 처리하면 한줄씩만 처리를 해서, 이렇게 다중행 결과를 출력할 수 없다. -> 단일행만 가능
다중행을 위해 커서가 필요, 커서를 반복적으로 처리하기 위해 반복문 필요

표준 SQL을 쓰면 안되나요?
반드시 익명블록을 써야하는 상황이 있다

(익명블록)
ACCEPT P_LCODE PROMPT '분류코드 : '
DECLARE 
    -- 출력되어야 하는 것들은 대부분 변수로 설정
    V_PNAME PROD.PROD_NAME%TYPE;
    V_COST PROD.PROD_COST%TYPE;
    V_MILE PROD.PROD_MILEAGE%TYPE;
    
--    CURSOR CUR_PROD_COST() IS
--        -- IS 뒤에, 위의 표준 SQL을 복붙 하는데 별칭은 필요X
--        SELECT PROD_NAME, PROD_COST, PROD_MILEAGE
--          FROM PROD
--         WHERE PROD_LGU = 'P102'
    -- 주석처리 후 아래처럼 변경해서 진행
         
    -- 매개변수 사용 예시
    CURSOR CUR_PROD_COST(P_LGU LPROD.LPROD_GU%TYPE) IS     
        SELECT PROD_NAME, PROD_COST, PROD_MILEAGE
          FROM PROD
         WHERE PROD_LGU = P_LGU;

BEGIN
    OPEN CUR_PROD_COST('&P_LCODE'); -- 괄호 안에 'P102'에서 &로 값 변경
    DBMS_OUTPUT.PUT_LINE('상품명       '||'단가    '||'마일리지');
    DBMS_OUTPUT.PUT_LINE('---------------------------------');
    LOOP
        FETCH CUR_PROD_COST INTO V_PNAME, V_COST, V_MILE;
        EXIT WHEN CUR_PROD_COST%NOTFOUND; -- 커서 속성이 참-아무것도 발견되지 않음-이 되면 LOOP를 빠져 나가기 
        -- DBMS_OUTPUT.PUT_LINE(V_PNAME||'  '||V_COST||'  '||V_MILE); -- 이대로 쓰면 마일리지의 null값은 출력되지 않음
        DBMS_OUTPUT.PUT_LINE(V_PNAME||'  '||V_COST||'  '||NVL(V_MILE, 0));
    END LOOP;
    CLOSE CUR_PROD_COST;
END;
         



2021-04-06_02
#조건문
- 개발 언어의 조건문과 동일한 기능 제공

(사용형식1)
    IF 조건식 THEN
        명령문1;
    [ELSE
        명령문2;]
    END IF;

(사용형식2)
    IF 조건식1 THEN
        명령문1;
    ELSIF 조건식2 THEN
        명령문2;
    [ELSIF 조건식3 THEN
        명령문3;
        :
    ELSE
        명령문 n;]    
    END IF;

(사용형식3) 중첩
    IF 조건식1 THEN
        명령문1;
        IF 조건식 1-1 THEN
            명령문 1-2;
        ELSE 
            명령문2;
        END IF;
    ELSE
        명령문 3;    
    END IF;

    
사용예);
상품 테이블에서 'P201' 분류에 속한 상품들의 평균 단가를 구하고, 해당 분류에 속한 상품들의 판매 단가를 비교하여
같으면 '평균 가격 상품', 적으면 '평균 가격 이하 상품', 많으면 '평균 가격 이상 상품'을 출력하시오.
출력은 상품코드, 상품명, 가격, 비고 이다.

표준SQL을 사용하면 간단하지만.. 일단 블럭 사용

(익명블럭)
DECLARE
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_PRICE PROD.PROD_PRICE%TYPE;
    V_REMARKS VARCHAR2(50);    
    V_AVG_PRICE PROD.PROD_PRICE%TYPE;
    
    CURSOR CUR_PROD_PRICE
    IS
        SELECT PROD_ID, PROD_NAME, PROD_PRICE           -- 이 순서와
          FROM PROD
         WHERE PROD_LGU = 'P201';
    
BEGIN
    SELECT ROUND(AVG(PROD_PRICE)) INTO V_AVG_PRICE
    FROM PROD
       WHERE PROD_LGU = 'P201';

    OPEN CUR_PROD_PRICE;
    LOOP
        FETCH CUR_PROD_PRICE INTO V_PCODE, V_PNAME, V_PRICE;    -- 이 순서가 동일해야 한다
        EXIT WHEN CUR_PROD_PRICE%NOTFOUND;
        
        IF V_PRICE > V_AVG_PRICE THEN
            V_REMARKS := '평균 가격 이상 상품';
        -- ** ELSIF 주의 **
        ELSIF V_PRICE < V_AVG_PRICE THEN
            V_REMARKS := '평균 가격 이하 상품';
        ELSE
            V_REMARKS := '평균 가격 상품';
        END IF;
        DBMS_OUTPUT.PUT_LINE(V_PCODE||', '||V_PNAME||', '||V_PRICE||', '||V_REMARKS);
    END LOOP;
    CLOSE CUR_PROD_PRICE;
END;    
--    SELECT ROUND(AVG(PROD_PRICE)) INTO V_AVG_PRICE
--        FROM PROD
--       WHERE PROD_LGU = 'P201';
    
--    SELECT PROD_ID, PROD_NAME, PROD_PRICE INTO V_PCODE, V_PNAME, V_PRICE
--    -- 오류 발생 : PROD_ID는 21개라서 한 데이터에 들어갈 수 없다. -> 커서 사용
--        FROM PROD
--       WHERE PROD_LGU = 'P201'; 
-- END;

UNCONDITIONAL 조건문 GOTO 사용자제 ..

2.CASE 문
- JAVA의 SWITCH CASE 문과 유사 기능 제공
- 다방향 분기 기능 제공
- break 문이 필요 없음, 실행이 끝나면 알아서 각 분기에서 나감

(사용형식1) - 변수 사용
    CASE 변수명 | 수식
        WHEN 값1 THEN
            명령1;
        WHEN 값2 THEN
            명령2;
              :
        ELSE
            명령N;
    END CASE;
    
(사용형식2)
CASE WHEN 조건식1 THEN
          명령1;
     WHEN 조건식2 THEN
          명령2;   
            :
     ELSE
          명령N;
END CASE;        


사용예); 
수도요금 계산
    톤당 단가
    1-10  : 350원
    11-20 : 550원
    21-30 : 900원
    그 이상: 1500원
    
    하수도 사용료
    사용량 * 450원
    
26톤 사용시 요금
    (10 * 350) + (10 * 550)+ (6 * 900) + (26 * 450)
        = 3500 + 5500 + 5400 + 11,700
        = 26,100원

        
-- 사용자에게 사용량을 입력받기 위해 ACCEPT 사용
ACCEPT P_AMOUNT PROMPT '물 사용량 : '
DECLARE
    V_AMT NUMBER := TO_NUMBER('&P_AMOUNT');
    V_WA1 NUMBER := 0; --물 사용 요금
    V_WA2 NUMBER := 0; -- 하수도 사용료
    V_HAP NUMBER := 0; -- 요금 합계
BEGIN
    CASE WHEN V_AMT BETWEEN 1 AND 10 THEN
              V_WA1 := V_AMT*350;
        WHEN V_AMT BETWEEN 11 AND 20 THEN
              V_WA1 := 3500 + (V_AMT-10)*550;
        WHEN V_AMT BETWEEN 21 AND 30 THEN
              V_WA1 := 3500 + 5500 + (V_AMT-20)*900;
        ELSE
              V_WA1 := 3500 + 5500 + 9000 + (V_AMT-30)*1500;
    END CASE;
    V_WA2 := V_AMT*450;
    V_HAP := V_WA1 + V_WA2;
    DBMS_OUTPUT.PUT_LINE(V_AMT||'톤의 수도 요금 : '||V_HAP);  
END;
    







