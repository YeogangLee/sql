2021-04-05

- 가상화
: VM 웨어 -> 도커
VM 웨어는 예전에는 많이 썼던, 실행하는 데에 자원 소비도 많지만, 도커는 그렇지 않다 

맥 - 오라클 설치 불가
맥은 리눅스 기반이기 때문에, 오라클 리눅스 버젼은 지원X
-> 가상화 이용 : 도커 먼저 인스톨 -> 오라클 인스톨

--

- 사용형식
CREATE [UNIQUE | BITMAP] INDEX 인덱스명
    ON 테이블명(컬럼명1[, 컬럼명2, ...]) [ASC|DESC]

=> CREATE INDEX 인덱스명 ON 테이블명(컬럼명1);

객체 삭제 : DROP 객체명

BITMAP 인덱스
기술하지 않으면 NORMAL INDEX
함수 기반 NORMAL INDEX

2개 이상의 컬럼으로 구성된 인덱스
나중에 사용하며 WHERE 절에서 두 컬럼 중 한 컬럼만 선택시(비교시), 문제 발생
-> 2개의 주소가 필요한데 1개의 주소만 사용한 것이므로, 인덱스 생성의 의미가 없다


- 관계 종류 2가지
1. 식별자 관계 - 직선으로 표현, 엔코아의 DA#5
ex. 쇼핑몰 결제, 물건을 구매한 정보, 결제 취소 -> 주문 내역 가지고 있을 필요X
부모가 삭제되면 자식도 같이 삭제되는 형태
부모의 생존이 자식의 생존을 같이 결정
ex2. 예매 취소

부모테이블의 기본키가, 자식테이블의 외래키이면서 기본키인 관계를 식별자 관계라고 한다

2. 비식별 관계 - 점선 ..... 으로 표현
각 테이블에 컬럼명은 동일한 데이터라면, 같은 컬럼명을 사용하는 게 좋다
그렇지 않으면 JOIN 할 때 불편하다

레퍼런스 관계 REFERENCE - 참조만 하는 관계
소속이 사라졌다고 해서 각 구성원이 사라지는 것은 아니다
NON IDENTIFYING 관계
한 쪽의 생존이 다른 한 쪽의 생존에 영향을 미치지 않는 관계 ex. 교수 - 대학생

식별자 관계 vs 비식별자 관계
: WHERE 이 길어져도 좋으면 식별자 관계를 사용 아니면 JOIN

기본키는 기본키로 설정되면, 그 키값으로 자동으로 인덱스가 생성된다
데이터 추출을 하려면, 모든 기본키를 사용해서 주소를 찾아야 한다.
WHERE 절에 AND, AND,... 로 연결해서
복수 개의 조건문이 나와야 효율적이게 된다.


- PROD 테이블의 NAME 컬럼을 사용해 INDEX 를 만들고 싶다
사용예) 상품 테이블에서 상품명으로 NORMAL INDEX 를 구성하시오. 
);
CREATE INDEX idx_prod_name
    ON prod(prod_name);

사용예) 장바구니 테이블에서 장바구니 번호 중 3번째에서 6글자로 인덱스를 구성하시오.

장바구니번호 : 날짜 8자리 + 로그인순번 5자리
글자수 떼기 -> SUBSTR 사용 (START INDEX, LENGTH)
);
CREATE INDEX idx_cart_no
    ON cart(SUBSTR(cart_no, 3, 6));

인덱스를 확인해 보면
INDEX TYPE | FUNCTION-BASED NORMAL
왜냐하면 함수를 이용해서 인덱스를 생성했기 때문에


@@ 인덱스의 재구성
- 데이터 테이블을 다른 테이블 스페이스로 이동시킨 후
- 자료의 삽입과 삭제 동작 후
  -> 데이터 가공 UPDATE, DELETE 등 가공 후에 자동으로 재구성이 일어난다

자바의 스레드 - 대전역 셔틀버스
대전역으로 가는 데까지 시간이 소요되고, 대전역에서 여기까지 오며 시간이 소요
다음 셔틀버스가 출발할 때까지 일정한 텀이 필요
서비스가 필요한 프로세스들이 대기 중,
얘가 차례대로 CPU로 데려가서 처리해준다
    
사용자가 인덱스 파일을 강제로 재구성 REFRESH 시켜줄 수 있다

(사용형식)
ALTER INDEX 인덱스명 REBUILD;

사실 재구성은 DB 를 튜닝할 때나 사용, SQL 초보자가 다룰 일은 없을 거다
튜닝 -> 제일 먼저 하는 일 : 키 값 확인


2021-04-05 / 02.PL/SQL
- PROCEDURAL LANGUAGE sql의 약자
- 표준 SQL에 절차적 언어의 기능(비교, 반복, 변수 등)이 추가
                            ㄴ 반복 기능 3가지 : LOOP, WHILE, FOR
- 블록(BLOCK) 구조로 구성
- 미리 컴파일되어, 실행 가능한 상태로 서버에 저장되고, 필요시 호출을 통해 사용됨
  -> 서버에 부담을 줄여준다 - 처리 속도가 빨라질 수 있다
- 모듈화, 캡슐화 기능 제공 - 객체 지향 언어
- ANONYMOUS BLOCK, STORED PROCEDURE, USER DEFINED FUNCTION, PACKAGE, TRIGGER 등으로 구성

자바
CALL BY VALUE : 값만 전달하는 방식
CALL BY REFERENCE : string 객체와도 같은 개념, 주소값을 준다
SIDE EFFECT 부작용


1. 익명 블록 ANONYMOUS BLOCK
- PL/SQL 의 기본 구조
- 선언부와 실행부로 구성

(구성형식) : DECLARE - BEGIN - END
DECLARE
/선언영역/
-- 변수, 상수, 커서 선언
-- 상수 - 자바의 FINAL INT
-- 클래스 앞에 FINAL 사용 - 불임 클래스 생성
-- 왼쪽 = 오른쪽
-- : 변수만이 왼쪽 LEFT VALUE 에 올 수 있다 -> 상수는 오른쪽에만 온다
-- 커서 - SQL 명령에 영향을 받는 것들의 집합
BEGIN
/실행영역/
-- BUSINESS LOGIC 처리
[EXCEPTION
 예외 처리 명령;
 -- 비정상적 종료를 방지하고, 정상적 종료로 유도하는 것
 정상적 종료 : INTERRUPT ; 방해하다, 중단하다, 끊다
]
END;


이름이 없다 -> 불러다 쓸 수 없다
그래서 
END;
/
책에서 이렇게 해야 한다는 내용을 볼 수 있을 거에요.

SQL PLUS 라인 에디터 ... 라인 단위로 데이터를 읽어들인다
익명 블럭의 이름을 부르기 위해 / 표기
: 컴파일러가 /를 만나면 실행하라는 의미
ED 라고 하는 리눅스 에디터, 굉장히 복잡한 단축키
지금은 아래 한글에서 복붙 ... 여러분들은 쉽게 공부하고 있어요

SQL DEVELOPER 에서는 /는 필요 없다.


디벨로퍼 보기 메뉴 > DBMS 출력
> DBMS 출력 창에서 +버튼 눌러서 접속 계정 선택하면 창 활성화

사용예) 키보드로 2-9 사이의 값을 입력 받아 그 수에 해당하는 구구단을 작성하시오
);
ACCEPT p_num PROMPT '수 입력(2~9) : '
DECLARE
    v_base NUMBER := TO_NUMBER('&p_num');
    v_cnt NUMBER := 0;
    v_res NUMBER := 0; -- := 파스칼 언어에서 따온
BEGIN
    LOOP
        v_cnt := v_cnt+1;
        EXIT WHEN v_cnt > 9;
        v_res := v_base * v_cnt;
        
        DBMS_OUTPUT.PUT_LINE(v_base || '*' || v_cnt || '=' || v_res);
    END LOOP;

    EXCEPTION WHEN OTHERS THEN -- WHEN OTHERS : 자바의 EXCEPTION 클래스, 최종 예외 처리
        DBMS_OUTPUT.PUT_LINE('예외 발생 : '|| SQLERRM); -- ERRM : ERROR MESSAGE
END; 

오라클은 초기화하지 않으면 초기값으로 NULL이 들어간다


1) 변수, 상수 선언
- 실행영역에서 사용할 변수 및 상수 선언
(1) 변수의 종류
    - SCALAR 변수 : 하나의 데이터를 저장하는 일반적 변수
    - REFERENCES 변수 : 해당 테이블의 컬럼이나 행에 대응하는 타입과 크기를 참조하는 변수
                       ㄴ 행 참조 타입, 컬럼 참조 타입
    - COMPOSITE 변수 : PL/SQL 에서 사용하는 배열 변수 -- COMPOSITE a.합성의, n.합성물
    배열의 단점 2가지 : 1. 같은 타입으로만 구성, 2. 고정된 크기
    보완 -> 자바의 콜렉션 프레임 워크 JCF, PL/SQL 의 COMPOSITE 변수
      ㄴ RECORD TYPE 변수
      ㄴ TABLE TYPE 변수 - 강력하다.
    - BIND 변수 : 파라미터로 넘겨지는 IN, OUT, INOUT 에서 사용되는 변수
                 RETURN 되는 값을 전달받기 위한 변수
                 
    컴파일 언어 vs 인터프리터 언어의 구분
    -> 과거의 정처기 문제, 현재는 구분이 모호해짐
    요즘 언어들은 대부분 2개를 다 섞어 쓴다, 자바도 그렇고.
    바인딩(변수의 값을 저장) 타입/타임이 ... 어떻냐에 따라 둘을 구분할 수 있기는 하다
    통로 역할을 하는 매개변수
    : IN 타입, OUT 타입, INOUT 타입
    INOUT은 IN, OUT 둘 다 사용할 수 있지만, 부담을 너무 많이 주므로 웬만해서는 INOUT 타입 사용 금지 권고

(2)선언방식
  : 변수명 [CONSTANT] 데이터 타입 [:=초기값] -- 할당 연산자 주의, = 이 아니라 :=
    변수명 테이블명, 컬럼명%TYPE [:=초기값] -> 컬럼 참조형
    변수명 테이블명%ROWTYPE -> 행 참조형
    
(3)데이터타입
- 표준 SQL 에서 사용하는 데이터 타입
- PLS_INTEGER , BINARY_INTEGER : -2,147,483,647 ~ 2,147,483,648 까지 자료 처리
- BOOLEAN : TRUE, FALSE, NULL 처리 -- JAVA와 다르게 BOOLEAN에 NULL까지 추가됨
- LONG, LONG RAW : DEPRECATED -- ORACLE의 LONG은 2기가 까지 나타낼 수 있는 문자열 타입 -> 지금은 쓰지 않는다, 클랍CLOB로 대체됨
                   ㄴ 메서드 이름 중에 줄이 그여진 메서드 : 업데이트 지원X, 사용은 가능하지만 업데이트 서비스가 종료된 메서드
                   -- DEPRECATED [데..] a. 유지보수가 중단되어, 사용이 권장되지 않는
            

예) 장바구니에서 2005년 5월 가장 많은 구매(구매 금액 기준)를 한 
   회원정보를 조회하시오.(회원번호, 회원명, 구매금액합)
-- 장바구니 : cart 테이블, 회원 : member 테이블
-- 구매금액 계산을 위한 수량과 단가가 없다 -> prod 테이블                    


(표준 SQL)
);
  SELECT A.CART_MEMBER AS 회원번호,
         B.MEM_NAME AS 회원명,   -- 회원번호, 회원명 둘 중 하나는 쓰지 않아도 ㄱㅊ, 어차피 같은 말이기 때문 
         SUM(PROD_PRICE * CART_QTY) AS 구매금액합 
    FROM CART A, MEMBER B, PROD C
   WHERE A.CART_MEMBER = B.MEM_ID
     AND A.CART_PROD = C.PROD_ID -- 이거를 생락해도 결과는 같다.
GROUP BY A.CART_MEMBER, B.MEM_NAME
ORDER BY 3 DESC;                  


-- ROWNUM 사용
  SELECT A.CART_MEMBER AS 회원번호,
         B.MEM_NAME AS 회원명,
         SUM(PROD_PRICE * CART_QTY) AS 구매금액합 
    FROM CART A, MEMBER B, PROD C
   WHERE A.CART_MEMBER = B.MEM_ID
     AND A.CART_PROD = C.PROD_ID
     AND ROWNUM = 1
GROUP BY A.CART_MEMBER, B.MEM_NAME
ORDER BY 3 DESC;                  
-- 왜 구매금액이 가장 많은 회원인 신영남이 안 나왔을까?


SELECT D.MID AS 회원번호,
       B.MEM_NAME AS 회원명,
       D.AMT AS 구매금액합
  FROM (SELECT A.CART_MEMBER AS MID,
               SUM(C.PROD_PRICE * A.CART_QTY) AS AMT
          FROM CART A, PROD C
         WHERE A.CART_PROD = C.PROD_ID
           AND ROWNUM = 1
      GROUP BY A.CART_MEMBER
      ORDER BY 2 DESC) D, MEMBER B
WHERE D.MID = B.MEM_ID
  AND ROWNUM = 1;