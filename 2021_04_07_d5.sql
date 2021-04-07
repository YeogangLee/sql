2021-04-06_01 -- (수)
/*    
- 01 반복문 : LOOP 문, WHILE 문, FOR 문
- LOOP 나가기 : EXIT WHEN 조건;
- 커서에 사용하는 FOR 문 : 커서의 OPEN, FETCH, CLOSE 문은 생략

- 02 저장 프로시저
: 프로시저는 결과가 없기 때문에, SELECT 문 WHERE 절에 사용 불가
- 프로시저 생성 방법
- 테이블 생성 방법
- 테이블에서 다른 테이블로 자료 삽입 방법

문제 - 1)LOOP문 구구단, LOOP문 피보나치 수
       2)WHILE문 저축금액
         LOOP문 + CURSOR [+WHILE문] 이용 -> member 테이블 컬럼값 구하기
       3)FOR문 구구단, LOOP문 + FOR문 [+인라인커서] 이용 -> 테이블 컬럼값 구하기
*/

- 개발 언어의 반복문과 같은 기능 제공
- loop, while, for 문

1) LOOP 문
- 반복문의 기본 구조
- JAVA의 DO문과 유사한 구조
- 기본적으로 무한 루프 구조

(사용형식)
    LOOP
        반복처리문(들);
        [EXIT WHEN 조건;]
    END LOOP;

- 'EXIT WHEN 조건' : 조건이 참인 경우 반복문의 범위를 벗어난다
  대표적인 무한루프 - ex.운영체제, 게임

vs while
while은 거짓일 때 반복을 멈추지만
loop는 조건이 참일 때 반복을 멈춘다

사용예) 구구단의 7단을 출력
DECLARE
    V_CNT NUMBER := 1;
    V_RES NUMBER := 0;
BEGIN
    LOOP
        V_RES := 7*V_CNT;
        DBMS_OUTPUT.PUT_LINE(7||'*'||V_CNT||'='||V_RES);
        V_CNT := V_CNT + 1;
        EXIT WHEN V_CNT > 9;
    END LOOP;
END;
        

사용예); 1-50 사이의 피보나치 수를 구하여 출력하시오
FIBONACCI NUMBER : 첫 번째와 두 번째 수가 1,1로 주어지고
                   세 번째 수부터 두 수의 합이 현재 수가 되는 수열 -> '검색 알고리즘'에 사용, 피보나치 서칭
DECLARE
    V_PNUM NUMBER := 1; -- 이전 수
    V_PPNUM NUMBER := 1; -- 이전전의 수
    V_CURRNUM NUMBER := 0; -- 현재의 수
    V_RES VARCHAR(100);
BEGIN
    V_RES := V_PPNUM||', '||V_PNUM;
    
    LOOP
        V_CURRNUM := V_PPNUM + V_PNUM;
        EXIT WHEN V_CURRNUM >= 50;
        V_RES := V_RES||', '||V_CURRNUM;
        V_PPNUM := V_PNUM;
        V_PNUM := V_CURRNUM;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1~50사이의 피보나치 수 : '|| V_RES);
END;


2) WHILE 문
- 개발 언어의 WHILE 문과 같은 기능
- 조건을 미리 체크하여 조건이 참인 경우에만 반복 처리

(사용형식)
    WHILE 조건
        LOOP
            반복처리문(들);
        END LOOP;

사용예) 첫날에 100원 둘째날부터 전날의 2배씩 저축할 경우
       최초로 100만원을 넘는 날과 저축한 금액을 구하시오.

DECLARE
    V_DAYS NUMBER := 0; --날짜
    V_AMT NUMBER := 100; --하루마다 저축할 금액
    V_SUM NUMBER := 0; --저축한 전체 합계
    
BEGIN
    WHILE V_SUM < 1000000
    LOOP
        V_SUM := V_SUM + V_AMT;
        V_DAYS := V_DAYS + 1;
        V_AMT := V_AMT * 2;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('날수 : '||V_DAYS);
    DBMS_OUTPUT.PUT_LINE('저축액수 : '||V_SUM);
END;        

사용예);
회원테이블(MEMBER)에서 마일리지가 3000 이상인 회원들을 찾아
그들이 2005년 5월 구매한 횟수와 구매금액합계를 구하시오. (커서 사용)
출력은 회원번호, 회원명, 구매횟수, 구매금액

-- 커서의 역할 -> 회원번호, 회원명 구하기

(LOOP를 사용한 커서 실행)

DECLARE                                            -- 1
    V_MID MEMBER.MEM_ID%TYPE; -- 회원번호
    V_MNAME MEMBER.MEM_NAME%TYPE; -- 회원명
    V_CNT NUMBER := 0; -- 구매횟수
    V_AMT NUMBER := 0; -- 구매금액 합계
    
    CURSOR CUR_CART_AMT
    IS
        SELECT MEM_ID, MEM_NAME
          FROM MEMBER
         WHERE MEM_MILEAGE >= 3000;                 -- 11
BEGIN
    OPEN CUR_CART_AMT;
    LOOP
        FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
        EXIT WHEN CUR_CART_AMT%NOTFOUND;
        SELECT SUM(CART_QTY * B.PROD_PRICE),
               COUNT(A.CART_PROD) INTO V_AMT, V_CNT
          FROM CART A, PROD B
         WHERE A.CART_PROD = B.PROD_ID
           AND A.CART_MEMBER = V_MID                -- 21
           -- 조인을 한 이유 : 단가를 들고 오기 위해, 상품코드 비교
           AND SUBSTR(A.CART_NO, 1, 6) = '200505'; -- 1, 6 - 첫 번째 글자부터 여섯 번째 글자까지가 200505와 일치
    DBMS_OUTPUT.PUT_LINE(V_MID||', '||V_MNAME||' => '||V_AMT||'('||V_CNT||')');
    END LOOP;
    CLOSE CUR_CART_AMT;
END;


-- WHILE 문 이용
FOUND, NOTFOUND 어떻게 아나? 읽어봐야 한다
WHILE문을 사용할 때는 반드시 FETCH 문이 WHILE 문 바깥에 존재해야 한다, 루프 명령 제일 밑에

(WHILE 문)

DECLARE
    V_MID MEMBER.MEM_ID%TYPE; -- 회원번호
    V_MNAME MEMBER.MEM_NAME%TYPE; -- 회원명
    V_CNT NUMBER := 0; -- 구매횟수
    V_AMT NUMBER := 0; -- 구매금액 합계
    
    CURSOR CUR_CART_AMT
    IS
        SELECT MEM_ID, MEM_NAME
          FROM MEMBER
         WHERE MEM_MILEAGE >= 3000;
BEGIN
    OPEN CUR_CART_AMT;
    LOOP
        EXIT WHEN CUR_CART_AMT%NOTFOUND;
        SELECT SUM(CART_QTY * B.PROD_PRICE),
               COUNT(A.CART_PROD) INTO V_AMT, V_CNT
          FROM CART A, PROD B
         WHERE A.CART_PROD = B.PROD_ID
           AND A.CART_MEMBER = V_MID
           -- 조인을 한 이유 : 단가를 들고 오기 위해, 상품코드 비교
           AND SUBSTR(A.CART_NO, 1, 6) = '200505'; -- 1, 6 - 첫 번째 글자부터 여섯 번째 글자까지가 200505와 일치
    DBMS_OUTPUT.PUT_LINE(V_MID||', '||V_MNAME||' => '||V_AMT||'('||V_CNT||')');
    FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
    END LOOP;
    CLOSE CUR_CART_AMT;
END;


3) FOR 문
- 반복횟수를 알고 있거나 횟수가 중요한 경우 사용

(사용형식1: 일반적 FOR)
    FOR 인덱스 ID[REVERSE] 최소값..최대값 -- REVERSE 최소, 최대 값 재설정 필요없이 REVERSE 이용
    LOOP
        반복처리문(들);
    END LOOP;


사용예);
구구단의 7단을 FOR 문을 이용해서 구성
DECLARE
     V_CNT NUMBER := 1; -- 승수(1~9)
     V_RES NUMBER := 0; -- 결과
BEGIN
    FOR I IN 1..9 
    LOOP
    V_RES := 7 * I;
    DBMS_OUTPUT.PUT_LINE(7||'*'||I||'='||V_RES);
    END LOOP;
END;
    
(사용형식2 : CURSOR 에 사용하는 FOR)
FOR 레코드명 IN 커서명|(커서 선언문)
LOOP
    반복처리문(들);
END LOOP;

- '레코드명'은 시스템에서 자동으로 설정
- 커서의 컬럼 참조형식 : 레코드명, 커서 컬럼명
- 커서명 대신 커서 선언문(선언부에 존재했던)이 INLINE 형식으로 기술할 수 있음
- FOR 문을 사용하는 경우 커서의 OPEN, FETCH, CLOSE 문은 생략


(FOR 문 사용)
DECLARE
  V_CNT NUMBER:=0;--구매횟수
  V_AMT NUMBER:=0;--구매금액 합계
  
  CURSOR CUR_CART_AMT
  IS 
    SELECT MEM_ID,MEM_NAME
      FROM MEMBER
     WHERE MEM_MILEAGE>=3000; 
BEGIN
  FOR REC_CART IN CUR_CART_AMT LOOP 
    SELECT SUM(A.CART_QTY*B.PROD_PRICE),
           COUNT(A.CART_PROD) INTO V_AMT,V_CNT
      FROM CART A, PROD B
     WHERE A.CART_PROD=B.PROD_ID
       AND A.CART_MEMBER=REC_CART.MEM_ID -- 좌변 개수 6개, 오른쪽은 다름, 일치하지 않아서 커서 사용 불가
       AND SUBSTR(A.CART_NO,1,6)='200505';   
    DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID||', '||REC_CART.MEM_NAME||
                         ' => '||V_AMT||'('||V_CNT||')'); 
  END LOOP;
END; 


(FOR문에서 INLINE 커서 사용)  
DECLARE
  V_CNT NUMBER:=0; --구매횟수
  V_AMT NUMBER:=0; --구매금액 합계
BEGIN
  FOR REC_CART IN (SELECT MEM_ID,MEM_NAME
                     FROM MEMBER
                    WHERE MEM_MILEAGE>=3000)
  LOOP 
    SELECT SUM(A.CART_QTY*B.PROD_PRICE),
           COUNT(A.CART_PROD) INTO V_AMT,V_CNT
      FROM CART A, PROD B
     WHERE A.CART_PROD=B.PROD_ID
       AND A.CART_MEMBER=REC_CART.MEM_ID
       AND SUBSTR(A.CART_NO,1,6)='200505';   
    DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID||', '||REC_CART.MEM_NAME||
                         ' => '||V_AMT||'('||V_CNT||')'); 
  END LOOP;
END; 



2021-04-07_02 저장 프로시저 Stored Procedure : Procedure
- 특정 결과를 산출하기 위한 코드의 집합(모듈)
- 반환값이 없음
- 컴파일 되어 서버에 보관(실행 속도를 증가, 은닉성, 보안성)

- FUNCTION vs PROCEDURE
값을 반환 - FUNCTION : SELECT 문, WHERE 절 
값 반환X - PROCEDURE : 결과가 없기 때문에 SELECT, WHERE 절에서 사용할 수 없음
                      -> 프로시저는 독립적으로 실행, 특정한 산출을 위한 구성으로 이루어짐 -> 로직

(사용형식)                  -- 프로시저명 시작은 PROC_
CREATE [OR REPLACE] PROCEDURE 프로시저명[(
    매개변수명 [IN | OUT | INOUT] 데이터 타입 [[:= | DEFAULT] expr],    
    매개변수명 [IN | OUT | INOUT] 데이터 타입 [[:= | DEFAULT] expr]
                               :
    매개변수명 [IN | OUT | INOUT] 데이터 타입 [[:= | DEFAULT] expr])]
                               -- 데이터 크기 절대 XX NUMBER, VARCHAR2 이런 것만 설정
                               -- INOUT은 사용하지 않을 것을 권고    
AS | IS -- AS, IS 둘 중 하나 사용
    선언영역;    
BEGIN
    실행영역;
END;

- 테이블 생성명령
CREATE TABLE 테이블명(
    컬럼명1 데이터타입[(크기)][NOT NULL][DEFAULT 값|수식][,]
    컬럼명2 데이터타입[(크기)][NOT NULL][DEFAULT 값|수식][,]
                           :
    컬럼명N 데이터타입[(크기)][NOT NULL][DEFAULT 값|수식][,] -- COMMA **
    
    CONSTRAINT 기본키설정명 PRIMARY KEY (컬럼명1[, 컬럼명2, ...])[,] -- 기본키는 주로 'PK_테이블명'
    CONSTRAINT 외래키설정명 FOREIGN KEY (컬럼명1[, 컬럼명2, ...])[,] -- 외래키는 주로  기본키 + 참조하는 테이블명
        REFERENCE 테이블명1(컬럼명1[, 컬럼명2, ...])[,] 
                           :
    CONSTRAINT 외래키설정명 FOREIGN KEY (컬럼명1[, 컬럼명2, ...])[,]
        REFERENCE 테이블명1(컬럼명1[, 컬럼명2, ...])
);
    
문제.
다음 조건에 맞는 재고수불 테이블을 생성하시오.
1. 테이블명 : REMAIN
2. 컬럼
--------------------------------------------------
 컬럼명        데이터타입       제약사항
 -------------------------------------------------
 REMAIN_YEAR  CHAR(4)         PK
 PROD_ID      VARCHAR2(10)    PK & FK
 REMAIN_J_00  NUMBER(5)       DEFAULT 0       -- 기초재고
 REMAIN_I     NUMBER(5)       DEFAULT 0       -- 입고수량     
 REMAIN_O     NUMBER(5)       DEFAULT 0       -- 출고수량       
 REMAIN_J_99  NUMBER(5)       DEFAULT 0       -- 기말재고
 REMAIN_DATE  DATE            DEFAULT SYSDATE -- 처리일자
 
CREATE TABLE remain(     
    REMAIN_YEAR  CHAR(4),
    PROD_ID      VARCHAR2(10),
    REMAIN_J_00  NUMBER(5) DEFAULT 0,
    REMAIN_I     NUMBER(5) DEFAULT 0,
    REMAIN_O     NUMBER(5) DEFAULT 0,
    REMAIN_J_99  NUMBER(5) DEFAULT 0,
    REMAIN_DATE  DATE,
    
    CONSTRAINT pk_remain PRIMARY KEY(remain_year, prod_id),
    CONSTRAINT fk_remain_prod FOREIGN KEY(prod_id) REFERENCES prod(prod_id)  
);

- remain 테이블에 기초 자료 삽입 
년도 : 2005
상품코드 : 상품테이블의 상품코드
기초재고 : 상품테이블의 적정재고 prod_properstock
입고수량 / 출고수량 : 없음
처리일자 : 2004/12/31 

    -- 예외. INSERT 문의 서브쿼리 -> VALUES 절 사용X, 서브쿼리 쓸 때 괄호X
INSERT INTO REMAIN(REMAIN_YEAR, PROD_ID, REMAIN_J_00, REMAIN_J_99, REMAIN_DATE)
SELECT '2005', PROD_ID, PROD_PROPERSTOCK, PROD_PROPERSTOCK, TO_DATE('20041231')
  FROM PROD;

-- 추가된 행 확인
SELECT * FROM remain;    
    
    