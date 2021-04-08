2021-04-02_01
/*
01
SEQUENCE 객체
: 자동으로 증가되는 값을 반환할 수 있는 객체
  
생성 방법
CREATE SEQUENCE SEQ_시퀀스명
 START WITH 시작값;
 
생성 후 조회
SELECT SEQ_LPROD.CURRVAL
 FROM dual;

- AUTO INCREMENT 컬럼 속성 vs SEQUENCE 객체
: 객체는 테이블에 독립적이므로,
여러 테이블에서 동시에 SEQUENCE 객체 이용 가능

- 시퀀스가 사용되는 곳
SELECT 문의 SELECT 절 (서브쿼리는 제외)
INSERT 문의 SELECT 절 (서브쿼리), VALUES 절
-- ㄴ 시퀀스 문제로 접했던 조건
UPDATE 문의 SET 절

- 시퀀스 사용이 제한되는 곳


02
SYNONYM 객체
: 동의어를 의미, 긴 이름의 객체를 쉽게 사용하기 위한 용도로 주로 사용

생성 방법
: CREATE OR REPLACE SYNONYM 시너넘이름 FOR 객체명ex.테이블명;

- 테이블 별칭은 해당 쿼리 안에서만 유효하지만,
SYNONYM 동의어는 해당 데이터베이스를 사용하는 동안 계속 존재한다


03
INDEX 객체
: 데이터 검색 효율을 증대 시키기 위한 도구
  !주의! 별도의 추가공간이 필요하고 INDEX FILE 을 위한 PROCESS 가 요구됨

생성 방법
: CREATE INDEX 인덱스명 ON 테이블명(컬럼명1);

삭제 방법 
: DROP INDEX 인덱스명;

- 인덱스의 종류
UNIQUE		- 중복X, null 값을 가질 수 있다
NON UNIQUE	- 중복 허용
NORMAL INDEX 	- 기본 인덱스, 트리 구조로 구성

[문제
1. 시퀀스를 이용하여 테이블에 자료 삽입
2. SYNONYM 을 이용한 테이블 조회
*/

AUTO INCREMENT 속성
: 참 -> 행을 하나씩 증가시킬 때, 자동으로 값도 하나씩 증가한다?

AUTO INCREMENT 컬럼의 속성 vs SEQUENCE 객체
: 테이블에 독립적이냐 아니냐
  객체는 테이블에 독립적이다 -> 여러 테이블에서 동시에 SEQUENCE 객체를 이용할 수 있다.


SEQUENCE 객체
- 자동으로 증가되는 값을 반환할 수 있는 객체
- 테이블에 독립적(다수의 테이블에서 동시 참조 가능)
- 기본키로 설정할 적당한 컬럼이 존재하지 않는 경우,
  자동으로 증가되는 컬럼의 속성으로 주로 사용됨

사용형식);
CREATE SEQUENCE 시퀀스명
    [START WITH n]
    [INCREMENT BY n]
    [MAXVALUE n | NOMAXVALUE]
    [MINVALUE n | NOMINVALUE]
    [CYCLE | NOCYCLE]
    [CACHE n | NOCACHE]
    [ORDER | NOORDER]
    
- START WITH n : 시작 값, 생략하면 MINVALUE
- INCREMENT BY n : 증감값, 생략시 1으로 설정된다
- MAXVALUE n : 사용하는 최대값, default 는 NOMAXVALUE 이고 10^27까지 사용
    ex. 생산 제품 300가지 -> 제품 코드 9900번까지 쓸 수 있게 하자.
    한 컬럼이 가질 수 있는 값의 범위 => ? 숙제 - 도메인
    
- MINVALUE n : 사용하는 최소값, default 는 NOMINVALUE 이고 생략시 1으로 설정
- CYCLE : 최대(최소)까지 도달한 후 다시 시작할 것인지 여부 default 는 NOCYCLE
- CACHE n : 생성할 값을 캐시에 미리 만들어 사용 default는 CACHE = 20
-- 컴퓨터는 사실상 더하기 연산만 할 수 있다, 컴퓨터 내부에는 ADDER 만 ... 나눗셈이 가장 수행 소요 시간이 길다
- ORDER : 정의된 대로 시퀀스 생성 강제, default 는 NOORDER
ㄴ 명령하다, 강제하다 라는 뜻(순서가 아닌)
  한 번 건너뛴 숫자는 재사용이 불가능하다
  
** 시퀀스 객체 의사 컬럼(PSEUDO COLUMN)
1. 시퀀스명.NEXTVAL : '시퀀스'의 다음 값 반환
2. 시퀀스명.CURRVAL : '시퀀스'의 현재 값 반환 --  CURRENT VALUE

: 시퀀스 생성 이후 한 번도 사용하지 않았다면 CURRVAL 을 사용할 수 없다. - 값이 없으므로 
  -> 시퀀스가 생성되고 해당 세션의 첫 번째 명령은 반드시 "시퀀스명.NEXTVAL" 이어야 함
  
  
사용예); LPROD 테이블에 다음 자료를 삽입하시오. (단, 시퀀스를 이용)
    [자료]
    LPROD_ID : 10번부터
    LPROD_GU : P501,  P502,  P503
    LPROD_NM : 농산물, 수산물, 임산물
    
--
문제에서, 시퀀스를 이용 -> 시퀀스 먼저 만들자
1)시퀀스 생성
CREATE SEQUENCE SEQ_LPROD
START WITH 10;

-- 현재 값 조회
-- 불가능
SELECT SEQ_LPROD.CURRVAL
FROM dual;
-- CURRVAL : 세션 생성 후 나를 아직 안 만든 것 -> 참조 포인터가 아직 만들어지지 않음

SELECT SEQ_LPROD.NEXTVAL
FROM dual;


2)자료 삽입
INSERT INTO LPROD

- 컬럼명 사용 경우
1. 자료를 삽입하려 할 때, 삽입할 위치를 알기 위해, INSERT INTO 테이블명(컬럼명)
2. 특정 컬럼에만 자료 삽입, NULL 을 허용하지 않은 컬럼만 생략 가능

INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL, 'P501', '농산물');
SELECT * FROM LPROD;

-- 자료가 이상하게 삽입됐을 때는
-- 1. 입력된 자료 삭제
-- 2. 시퀀스 삭제
-- 이후에 다시 시퀀스 생성 후 자료 삽입

DELETE LPROD 
WHERE LPROD_NM = '농산물';

-- 객체 삭제
DROP SEQUENCE SEQ_LPROD;
DROP 객체타입 객체명;

--

--INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL, 'P501', '농산물');
INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL, 'P502', '수산물');
INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL, 'P503', '임산물');

SELECT * FROM LPROD;

-- 여기까지 CURRVAL 사용하지 않았다, NEXTVAL만 사용 

사용예);
    오늘이 2005년 7월 28일인 경우 'm001' 회원이 
    제품 'P20100004'을 5개 구입했을 때 CART 테이블에 해당 자료를 삽입하는 쿼리를 작성하시오.
    -- 먼저 날짜를 2005년 7월 28일로 변경 후 작성할 것
    
이벤트가 발생됨에 따라 트리거를 발생시켜,
실행해야 하는 쿼리를 만들어 자동으로 실행한다.

# CART_NO 생성
SELECT TO_CHAR(SYSDATE, 'YYYYMMDD')
FROM dual;
-- SYSDATE 가 안되면
SELECT TO_CHAR(TO_DATE('20050728', 'YYYYMMDD'))
FROM dual;

SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') || SUBSTR(CART_NO, 9)
FROM cart;

SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') || MAX(SUBSTR(CART_NO, 9)) + 1
FROM cart;

-- 현재가 2005년 7월 28일이라면 SYSDATE 이용 가능
--SELECT TO_CHAR(TO_CHAR(SYSDATE, 'YYYYMMDD') || MAX(SUBSTR(CART_NO, 9)) + 1)
--FROM cart;

SELECT TO_CHAR('20050728' || MAX(SUBSTR(CART_NO, 9)) + 1)
FROM cart;
SELECT TO_CHAR(MAX(CART_NO)+1) 
FROM cart;
-- 위 둘은 같은 결과

MAX 함수를 쓸 수 있다 
> 그 컬럼의 모든 값은 숫자로 이루어져 있거나 숫자로 변환될 수 있는 문자열로 이루어져 있다
  문자 + 숫자 같은 데이터는 MAX 함수 적용 불가

-- 순번 확인
SELECT MAX(SUBSTR(CART_NO, 9)) FROM CART;

-- 시퀀스 생성
CREATE SEQUENCE SQL_CART
    START WITH 5;
    
INSERT INTO cart(cart_member, cart_no, cart_prod, cart_qty)
VALUES('m001', TO_CHAR(SYSDATE, 'YYYYMMDD')||TRIM(TO_CHAR(SQL_CART, '99999')), 'P201000004', 5);
-- 오류 발생: column not allowed here 
-- SQL_CART.NEXTVAL 을 이용하지 않아서

INSERT INTO cart(cart_member, cart_no, cart_prod, cart_qty)
VALUES('m001', TO_CHAR(SYSDATE, 'YYYYMMDD') ||
      TRIM(TO_CHAR(SQL_CART.NEXTVAL, '00000')), 'P201000004', 5);
      
select * from cart;      


-- 대전 SW개발회사
2. 소파이텍 ? 소프트 아이텍 ? 
   신입교육 : 1일 1게시판 

-- 시퀀스가 사용되는 곳
- SELECT 문의 SELECT 절 (서브쿼리는 제외)
- INSERT 문의 SELECT 절 (서브쿼리), VALUES 절
- UPDATE 문의 SET 절

-- 시퀀스의 사용이 제한되는 곳
- SELECT, DELETE, UPDATE 문에서 사용되는 서브쿼리
- VIEW를 대상으로 사용하는 쿼리
- DISTINCT 가 사용된 SELECT 절
- GROUP BY / ORDER BY가 사용된 SELECT 문
- 집합연산자(UNION, MINUS, INTERSECT)가 사용된 SELECT 문
- SELECT 문의 WHERE 절

각 테이블마다 똑같은 시퀀스 값을 쓰고 싶다
시퀀스 생성 -> 시퀀스의 NEXTVAL을 사용하는 쿼리를 따로 생성


2021-04-02_02
SYNONYM 객체
- 동의어를 의미
- 오라클에서 생성된 객체에 별도의 이름을 부여
- 긴 이름의 객체를 쉽게 사용하기 위한 용도로 주로 사용

(사용형식)
CREATE [OR REPLACE] SYNONYM 동의어 이름
   FOR 객체명;

- '객체'에 별도의 이름인 '동의어 이름'을 부여   

사용예);
- HR계정의 REGIONS 테이블의 내용을 조회
SELECT hr.region.reion_id AS 지역코드
       hr.region.region_name AS 지역명
  FROM hr.regions;
  
- 테이블 별칭을 사용한 경우
SELECT a.reion_id AS 지역코드
       a.region_name AS 지역명
  FROM hr.regions a;

- 동의어를 사용한 경우
CREATE OR REPLACE SYNONYM reg FOR hr.regions;
SELECT a.region_id as 지역코드,
       a.region_name as 지역명
  FROM reg a;
  
-- 컬럼 별칭
--1. 출력의 제목으로 사용
--2. 서브쿼리에서 다른 쿼리의 결과물을 참조하고자 할 때
 
-- 테이블 별칭
조인에 참여하는 테이블들은 관계가 맺어져야 한다
부모 테이블과 자식 테이블의 키 값이 일치해야 한다
-> 해당 쿼리 안에서만 유효
but 동의어는 해당 데이터베이스를 사용하는 동안 계속 존재한다


-- 몸관리, 스트레칭 잘해라
손목, 목, 허리 나간다


2021-04-02_03
INDEX 객체
- 데이터 검색 효율을 증대 시키기 위한 도구
- DBMS의 부하를 줄여 전체 성능 향상
- 별도의 추가공간이 필요하고 INDEX FILE 을 위한 PROCESS 가 요구됨
1) 인덱스가 요구되는 곳
  - 자주 검색되는 컬럼
  - 기본키(자동 인덱스 생성)와 외래키
  - SORT, GROUP 의 기본 컬럼
  - JOIN 조건에 사용되는 컬럼
2) 인덱스가 불필요한 곳
  - 컬럼의 도메인이 적은 경우(성별, 나이 등)
  - 검색 조건으로 사용했으나 데이터의 대부분이 반환되는 경우
  - SELECT 보다 DML 명령의 효율성이 중요한 경우
  
- 해싱기법
저장할 자료를 숫자화 시켜, 그 숫자를 가공해, 저장할 번지수 ...

3) 인덱스의 종류
(1) UNIQUE
    - 중복 값을 허용하지 않는 인덱스
    - NULL 값을 가질 수 있으나 이것도 중복해서는 안 됨
    - 기본키, 외래키 인덱스가 이에 해당
(2) NON UNIQUE
    - 중복 값을 허용하는 인덱스
(3) Normal INDEX
    - default INDEX
    - 트리 구조로 구성(동일 검색 횟수 보장)
    - 컬럼값과 ROWID(물리적 주소)를 기반으로 저장
(4) Funtion-Based Normal Index
    - 조건절에 사용되는 함수
(5) Bitmap Index
    - ROWID 와 컬럼 값을 이진으로 변환하여 이를 조합한 값을 기반으로 저장
    - 추가, 삭제, 수정이 빈번히 발생되는 경우 비효율적


의미상주어 - 주민등록번호
학번은 나중에 부여받은 값
인조키 ARTIFICIAL PRIMARY KEY : 학번, 사번, 제품코드 ... 

NULL 값 허용 - 사장은 부서가 없기 때문에.

SELECT * FROM employees
WHERE department_id IS NULL;
  
  