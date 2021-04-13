2021-04-13_01)패키지 Package

- 논리적 연관성 있는 PL/SQL 타입, 변수, 상수, 함수, 프로시저 등의 항목들을 묶어 놓은 것
- 모듈화, 캡슐화 기능 제공
- 관련성 있는 서브프로그램의 집합으로 DISK I/O 이 줄어 효율적 -- DISK I/O 시간이 꽤 길다

1.PACKAGE 구조
- 구성 : 선언부, 본문부
1)선언부
- 패키지에 포함될 변수, 프로시저, 함수 등을 선언

(사용형식)
CREATE [OR REPLACE] PACKAGE 패키지명
IS|AS
    TYPE 구문;
    상수[변수] 선언문;
    커서;
    함수|프로시저 프로토타입;
              :
END 패키지명;

--DECLARE, BEGIN 없다

-- java
접근지정자 메서드명 (매개변수 LIST) { -- 이 부분을 프로토타입이라고 한다.
}
=> SQL 패키지의 선언부와 같다.

batch 파일 : 자동으로 실행되어질 프로그램 목록들

프로그램 개시 -> 아직 구체적 결과X
미리 업무 분담, 서로 다른 함수명, 변수명 사용하면 나중에 통합하기 어렵다
=> 가이드라인 만들어주기 : 선언부의 역할
 가이드라인 생성 후 업무 : 본문부에 코딩
 
--- 대전 업무 많은 곳 3가지
--1.수정XX? - 신입이라면 많이 배울 수도 있겠다마는...
--2.오송 식약청 - 수출입 관리까지 해야해, 그래도 개발원에서 많이 간다
--              신입은 몸값 생각하지 말고.. 이후 경력 5년까지 생각
--3.- 스킵..


= 유스케이스 다이어그램
: 쓰임새 - 하나의 기능, 인수테스트의 테스트 케이스가 된다.
사용자가 원하는 것은 기능, 유스케이스에 명시된 기능은 반드시 만들고,
유스케이스에 없는 기능을 필요로 한다면 추가 요금 - PM이 하는 일

계정 이력이 꾸준히 추가되어야 한다 -> 함수든 프로시저든 항상 업데이트를 할 수 있는 대비


2)본문부
- 선언부에서 정의한 서브프로그램의 구현 담당

(사용 형식)
CREATE [OR REPLACE] PACKAGE BODY 패키지명
IS|AS
    상수, 커서, 변수 선언;
    
    FUNCTION 함수명(매개변수 LIST)
        RETURN 타입명
    BEGIN
        PL/SQL 명령(들);
        RETURN expr;
    END 함수명;
             :
             
END 패키지명;             
             

사용예);
상품 테이블에 신규 상품을 등록하는 업무를 패키지로 구성하시오.
-- 1. 상품의 분류를 알아야 한다 -> 분류 코드를 알고 구성
-- 2. 분류 코드 내에 있는 상품 코드 중에 제일 큰 값의 상품 코드를 알아야 한다.
--    제일큰값+1을 신규 상품에게 부여하기 위해
-- 3. 상품 테이블에 상품 입력
-- 4. 재고수불 테이블에 상품 정보 넣기

분류 코드 확인 -> 상품 코드 생성 -> 상품 테이블에 등록 -> 재고 수불 테이블 등록
: 반환값이 있어서 함수를 이용하면 편하다 -> 함수 -> 프로시저 -> 프로시저 
- 분류 코드 확인
분류 코드 있다 - 기존에 있는 분류 코드 사용
분류 코드 없다 - 프로시저로 분류 코드 생성

-- 패키지 선언부
CREATE OR REPLACE PACKAGE PROD_NEWITEM_PKG
IS
    V_PROD_LGU LPROD_GU%TYPE;
    -- 분류코드 생성
    FUNCTION FN_INSERT_LPROD(
        P_GU IN LPROD.LPROD_GU%TYPE,
        P_NM IN LPROD.LPROD_NM%TYPE)
        RETURN LPROD.LPROD_GU%TYPE; -- 분류코드 반환
    -- 상품코드 생성 및 상품 등록
    PROCEDURE PROC_CREATE_PROD_ID(
        -- PROD에서 NULL값을 허용하지 않는 컬럼만 나열
        P_GU IN LPROD.LPROD_GU%TYPE,
        P_NAME IN PROD.PROD_NAME%TYPE),
        P_BUYER IN PROD.PROD_BUYER%TYPE,
        P_COST IN NUMBER,
        P_PRICE IN NUMBER,
        P_SALE IN NUMBER,
        P_OUTLINE IN PROD.PROD_IMG%TYPE,
        P_IMG IN PROD_PROD_IMG%TYPE,
        P_TOTALSTOCK IN PROD.PROD_TOTALSTOCK%TYPE,
        P_PROPERSTOCK IN PROD.PROD_PROPERSTOCK%TYPE);
    -- 재고수불 테이블 삽입
    PROCEDURE PROC_INSERT_REMAIN(
        P_YEAR IN CHAR,
        P_ID IN PROD.PROD_ID%TYPE,
        P_AMT NUMBER);

END PROD_NEWITEM_PKG;        


(패키지 본문 생성) -- BODY 키워드가 있어서, 선언부와 이름이 같아도 된다
CREATE OR REPLACE PACKAGE BODY PROD_NEWITEM_PKG
IS
    V_LPROD_GU LPROD.LPROD_GU%TYPE;
    V_PROD_ID PROD.PROD_ID%TYPE;
    
    FUNCTION FN_INSERT_LPROD(
        P_GU IN LPROD.LPROD_GU%TYPE,
        P_NM IN LPROD.LPROD_NM%TYPE)
        RETURN LPROD.LPROD_GU%TYPE; 분류코드 반환
    IS
        V_ID NUMBER := 0;
    BEGIN
        SELECT MAX(LPROD_ID)+1 INTO V_ID
          FROM LPROD;
        INSERT INTO LPROD
            VALUES(V_ID, P_GU, P_NM)
        RETURN P_GU;
    END;
    -- 상품코드 생성 및 상품 등록
    PROCEDURE PROC_CREATE_PROD_ID(
        P_GU IN LPROD.LPROD_GU%TYPE,
        P_NAME IN PROD.PROD_NAME%TYPE),
        P_BUYER IN PROD.PROD_BUYER%TYPE,
        P_COST IN NUMBER,
        P_PRICE IN NUMBER,
        P_SALE IN NUMBER,
        P_OUTLINE IN PROD.PROD_IMG%TYPE,
        P_IMG IN PROD_PROD_IMG%TYPE,
        P_TOTALSTOCK IN PROD.PROD_TOTALSTOCK%TYPE,
        P_PROPERSTOCK IN PROD.PROD_PROPERSTOCK%TYPE,
        P_ID OUT PROD.PROD_ID%TYPE) -- 함수를 사용하지 않고, 매개변수로 값 넘겨주기
    IS
        V_PID PROD.PROD_ID%TYPE;
        V_CNT NUMBER := 0;
    BEGIN
        SELECT COUNT(*) INTO V_CNT
          FROM PROD
         WHERE PROD_ID LIKE P_GU||'%';
         
        IF V_CNT = 0 THEN
            V_PID = P_GU || '000001';
        ELSE 
            SELECT 'P'||(SUBSTR(A.M, 2) + 1) -- 분류코드가 P202인 입고상품의 상품 코드 
              FROM (SELECT MAX(PROD_ID) AS M
                      FROM PROD
                    WHERE PROD_LGU = 'P202') A;
        END IF;
        P_ID := V_PID;
    END;
    INSERT INTO PROD()
        VALUES(V_PID, P_NAME, P_GU, P_BUYER, P_COST, P_PRICE, P_SALE,
                P_OUTLINE, P_IMG, P_TOTALSTOCK, P_PROPERSTOCK)
    -- 재고수불 테이블 삽입
    PROCEDURE PROC_INSERT_REMAIN(
        P_ID IN PROD.PROD_ID%TYPE,
        P_AMT NUMBER)
    IS
    BEGIN
        INSERT INTO REMAIN(REMAIN_YEAR, PROD_ID, REMAIN_J_00, REMAIN_I, REMAIN_J_99, REMAIN_DATE)
            VALUES('2005', P_ID, P_AMT, P_AMT, P_AMT, SYSDATE); -- 왜 같은 P_AMT을 3번이나 사용
    END;

END PROD_NEWITEM_PKG;

문제 - 분류코드가 P202인 입고상품의 상품 코드
SELECT 'P'||(SUBSTR(A.M, 2) + 1) -- SUBSTR(문자열,N,M) -- 두 번째 인덱스 M 생략하면 N부터 뒤에 전부 포함
  FROM (SELECT MAX(PROD_ID) AS M
          FROM PROD
         WHERE PROD_LGU = 'P202') A;

(실행)
(신규분류코드-'P701','농축산물'-를 사용하는 경우)
DECLARE
    V_LGU LPROD.LPROD_GU%TYPE;
    V_PID PROD_PROD_ID%TYPE;
BEGIN
    V_LGU := PROD_NEWITEM_PKG.FN_INSERT_LPROD('P701','농축산물');
    PROD_NEWITEM_PKG.PROC_CREATE_PROD_ID(V_LGU, '소시지','P20101',10000,13000,11000,' ',' ',0,0,V_PID);
    PROD_NEWITEM_PKG.PROC_INSERT_REMAIN(V_PID, 10);
END;





