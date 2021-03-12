
1. 파일과 DBMS의 차이
2. SQL 구문의 종류 4가지 - DDL, DML, DCL, TCL
3. 수업시간 SQL cording rule
- keyword는 대문자, 그 외에는 소문자
4. 트랜잭션 : 논리적인 일의 단위 - 여러 작업을 합쳐 놓은 것
5. SQL 학습 이유 : B@DBMS과 통신하기 위한 유일한 수단@B - 구조화된 질의어
   NOSQL(비정형 제품) => 제품마다 다름
6. 
SELECT 테이블의 컬럼명을 콤마로 구분하여 나열 | *
FROM 가져올 데이터가 담긴 테이블 이름

----------------------------------------------------------------------

SELECT *
FROM prod;

-- 컬럼명 오류 : "PROD_NAEM": invalid identifier
SELECT prod_id, prod_naem
FROM prod;

-- 테이블명 오류 : "table or view does not exist"
SELECT prod_id, prod_name
FROM proc;


앞으로 접속 할 때
SQL 시트 메뉴 (연두색 - SQL 버튼), 회색 -> 화살표 옆에

[stu 계정]에 있는 prod 테이블의 모든 컬럼을 조회하는 SELECT 쿼리;SQL 작성
SELECT *
FROM prod;

[stu 계정]에 있는 prod 테이블의 prod_id, prod_name 두 개의 컬럼만 조회하는 SELECT 쿼리;SQL 작성
SELECT prod_id, prod_name
FROM prod;


에러메세지, 오류 발생 시
이유가 뭔지 보며 해결해라

- 컬럼명 오타

ORA-00904: "PROD_MANE": invalid identifier
00904. 00000 -  "%s: invalid identifier"
*Cause:    
*Action:
4행, 17열에서 오류 발생

오류가 발생하면 당황하지 말고, 오류 메세지를 읽기

ORA-00904: 는 에러코드, 그 뒤를 보면,
영어 모르면 구글 번역기에서.
invalid identifier 잘못된 식별자


- 테이블명 오타

ORA-00942: table or view does not exist
00942. 00000 -  "table or view does not exist"
*Cause:    
*Action:
5행, 6열에서 오류 발생


- 별칭 중복, AS ALIAS 중복

ORA-00923: FROM keyword not found where expected
00923. 00000 -  "FROM keyword not found where expected"
*Cause:    
*Action:
138행, 57열에서 오류 발생

AS에 또 AS를 적용시켜 에러가 발생했지만
오류메세지에는 AS에 관련한 언급이 없다.
이런 경우도 있다.

-- 정상적인 코드
SELECT 'SELECT * FROM ' || table_name || ';' QUERY
FROM user_tables;

-- 에러 발생 코드
SELECT 'SELECT * FROM ' || table_name || ';' table_name QUERY
FROM user_tables;

';' 뒤의 table_name도 ALIAS, QUERY도 ALIAS


================================================================

SELECT 실습 select1
- lprod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요

- buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성하세요

- cart 테이블에서 모든 데이터를 조회하는 쿼리 작성하세요

- member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리 작성하세요

------------------------------------------------------------------

SELECT *
FROM lprod;

SELECT buyer_id, buyer_name
FROM buyer;

SELECT *
FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;

=================================================================


연산
- 숫자, 날짜 타입에 대해 가능한 연산
+, -, *, /, ( )
() 우선순위 변경


# 컬럼 정보를 보는 방법
1. SELECT *  ==> [컬럼의 이름]을 알 수 있다
2. SQL DEVELOPER의 [테이블 객체]를 클릭하여 정보 확인 
- 해당 컬럼의 [데이터타입]도 알 수 있는 방법
-- 데이터타입은 크게 3가지 : 문자, 숫자, 날짜
			VARCHAR(BYTE), NUMBER, DATE
3. DESC 테이블명; //DESCRIBE 설명하다 - beschreiben

DESC emp;

-- 이 방법도 [데이터타입] 조회 가능 
-- ctrl ENT 결과가 질의결과로 나오는 게 아닌 스크립트로 출력

beschreiben 서술하다, 설명하다
berichten  보고하다
berechnen  계산하다


NUMBER(4, 0)
: 전체 자리 4자리, 소수점은 없다

NUMBER(7, 2)
: 전체자리 7자리, 소수점은 2자리까지 허용


-- 문자열 VARCHAR(10 BYTE)
자바의 String => SQL의 VARCHAR (10 BYTE)
VARCHAR는 용량이 제한되어 있다. 


숫자, 날짜에서 사용가능한 연산자
일반적인 사칙연산 + - / *, 우선순위 연산자 ( )


null
값이 없고, 값이 올지 안 올지 모름

not null
널이 될 수 없다, 반드시 값이 있어야 하는 컬럼



# SQL에서의 변수
SQL에도 변수 개념이 있다 - 컬럼명

SELECT empno + 10
FROM emp;

empno는 number라서 + 연산 가능

SELECT empno, empno + 10
FROM emp;

SELECT empno, empno + 10, 10
FROM emp;

여기서의 10 또한 expression
SELECT 뒤의 컬럼 정보가 아닌 모든 것들을 expression

==> empno의 값이 바뀌지 않는다
아무리 SELECT를 하더라도, 값을 바꿔 조회를 하더라도,
값이 변경되지 않는다. 값 변경은 UPDATE로 가능하기 때문

empno + 10
==> expression 표현
이런 empno + 10을 표현이라고 부른다
: 테이블에는 존재하지는 않지만, 개발자가 수식을 줘서 표현한 것 


SELECT empno, empno + 10, 10,
          hiredate, hiredate+10
FROM emp;

날짜 + 10
날짜의 일수가 더해짐 15일 -> 25일
날짜 - 10
날짜의 일수가 빼짐 15일 -> 5일

날짜는 덧셈, 뺄셈만 연산 가능

자바의 변수와 비슷한 개념
int a = 5;
System.our.println(a+10);
변수 자체의 값은 변경x


# ALIAS
하지만 10, 컬럼명을 이렇게만 쓰면 의미 전달이 불분명
그러면 컬럼명을 바꿔줘야겠죠
그럴 때 쓰는 게 ALIAS : 그냥 문자

SELECT문 기본 형식
SELECT * | { 컬럼 | 표현식 [AS] [ALIAS], ... } 

ALIAS : 컬럼의 이름을 변경
        컬럼 | expression [AS] [별칭명]
SELECT empno, empno + 10 AS empno_plus -- AS는 옵션, AS를 쓰면 보기가 편한 대신 코드가 길어진다
FROM emp;

SELECT empno empnumber, empno + 10 emp_puls, 10, hiredate, hiredate + 10
FROM emp;


SELECT empno empno, empno + 10 AS empno_plus -- empno ALIAS를 한 번 더 준 것
FROM emp;				      -- 기존 컬럼명과 동일하게 ALIAS
-- SELECT empno empno @T
-- 앞의 empno는 컬럼, 뒤의 empno는 ALIAS

별칭명은 대문자로 나옴 
=> "" 큰 따옴표 사용하면 소문자로 나옴
" " 사용시 => 컬럼명에 띄어쓰기 삽입 가능, 숫자 컬럼명도 가능


SELECT empno "empno", empno + 10 AS empno_plus -- 소문자 ALIAS
FROM emp;

SELECT empno "emp no", empno + 10 AS empno_plus -- 공백 포함 ALIAS
FROM emp;

=> 소문자 컬럼명 empno, 공백 포함 컬럼명 emp no



#NULL
NULL : 아직 모르는 값
         0과 공백은 NULL과 다르다
         **** NULL을 포함한 연산은 결과가 항상 NULL ****
         ==> NULL 값을 다른 값으로 치환해주는 함수

SELECT ename, sal, comm
FROM emp;


========================================================================

column alias 실습 SELECT2
- prod 테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하시오.
(단 prod_id -> id, prod_name -> name으로 컬럼 별칭을 지정)

- lprod 테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회하는 쿼리를 작성하시오.
(단 lprod_gu -> gu, lprod_nm -> nm으로 컬럼 별칭을 지정)

- buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하시오.
(단 buyer_id -> 바이어아이디, buyer_name -> 이름으로 컬럼 별칭을 지정)

-------------------------------------------------------------------------

SELECT prod_id "id", prod_name "name"
FROM prod;

SELECT lprod_gu AS "gu", lprod_nm AS "nm"
FROM lprod;

SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;


=========================================================================

이번에 배울 건 중요하다

#literal : 값 자체를 의미
literal 표기법 : 값을 표현하는 방법

SELECT empno, 10, 'Hello World' -- SQL에서는 ''작은 따옴표로 문자열 표현 "큰따옴표"X
FROM emp;


SELECT empno, 10, Hello World
FROM emp;

문자열의 literal 표현
java "Hello" 
sql 'Hello'


문자열 연산
java : String msg = "Hello"+", World";
SELECT empno + 10, 
FROM emp;

SELECT empno + 10, ename + ',World' -- 에러
FROM emp;

SELECT empno + 10, ename || ',World' -- SQL의 문자열 결합 ||
FROM emp;

함수 Function
SELECT empno + 10, ename || ',World',
       CONCAT(ename, ', World')
FROM emp;

-- 이건 오류가 발생한다
SELECT empno + 10, ename || 'Hello' || ',World',
       CONCAT(ename, 'Hello', ', World') 
       -- CONCAT(문자열1, 문자열2)
       -- CONCAT: 결합할 두 개의 문자열을 입력받아 결합하고 결합된 문자열을 반환해 준다
       -- 3개 이상의 문자열에는 CONCAT을 사용할 수 X
FROM emp;


아이디 : brown
아이디 : apeach
.
.
SELECT userid
FROM users;

SELECT '아이디 : ' || userid,
       CONCAT('아이디 : ', userid)
FROM users;


# user_tables -- //오라클이 제공하는 내부 기능 테이블
SELECT *
FROM user_tables; 
-- 없는 테이블인데 실행이 된다?
-- 오라클에서 만든, 유저가 가지고 있는 테이블 목록을 보여주는 user_table, 오라클이 내부적으로 관리하는 테이블

SELECT table_name
FROM user_tables;


SELECT 'SELECT * FROM ' || table_name || ';' QUERY
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';' table_name,
       CONCAT(CONCAT('SELECT * FROM ', table_name), ';')
FROM user_tables;


--
CONCAT(문자열1, 문자열2, 문자열3)
==> CONCAT(문자열1과 문자열2가 결합된 문자열, 문자열3)
==> CONCAT(CONCAT(문자열1, 문자열2), 문자열3)
==> CONCAT(문자열1||문자열2, 문자열3)


SELECT 'SELECT * FROM ' || table_name || ';' table_name,
       CONCAT(CONCAT('SELECT * FROM ', table_name), ';'),
       CONCAT('SELECT * FROM ' || table_name, ';')
FROM user_tables;


조건에 맞는 데이터 조회하기
#조건연산자
WHERE절
=       같은 값
!=, <>  다른 값
>, >=, <, <=

-- 부서 번호가 10인 직원들만 조회
-- 부서번호 : deptno
SELECT *
FROM emp
WHERE deptno = 10;

-- users 테이블에서 userid 컬럼의 값이 brown인 사용자만 조회
-- ***** SQL 키워드는 대소문자를 가리지 않지만 데이터 값은 대소문자를 구분한다
SELECT * 
FROM users
WHERE userid = 'brown';
-- WHERE userid = brown; -- 오라클에서 brown을 컬럼명으로 인식

-- emp 테이블에서 부서번호가 20번보다 큰 부서에 속한 직원 조회
SELECT * 
FROM emp
WHERE deptno > 20;

-- emp 테이블에서 부서번호가 20번 부서에 속하지 않은 모든 직원 조회
SELECT * 
FROM emp
WHERE deptno != 20;

WHERE : 기술한 조건을 참TRUE으로 만족하는 행들만 조회한다(FILTER)

-- 결과는 테이블 전체 출력
SELECT * 
FROM emp
WHERE 1=1;

-- 결과는 출력결과 없음
SELECT * 
FROM emp
WHERE 1=2;

-- 81년 3월 1일 이후 입사자 조회
SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= 81년 3월 1일, 81/03/01
날짜 값을 표기하는 방법을 모름
날짜에 대해서는 literal 표기법을 배우지 않음

SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= '81/03/01'; 
-- 1. 미국, 유럽에서는 오해할 수 있음 연월일 순서
-- 2. 문자열로 표현하면 날짜형식에 따라 달라져야 하므로 위험
날짜형식
RR/MM/DD
YYYY/MM/DD HH24:MI:SS
4자리 연도 표기가 더 좋다

문자열을 날짜 타입으로 변환하는 방법
TO_DATE(날짜 문자열, 날짜 문자열의 포맷팅)
TO_DATE('1983/12/11', 'YYYY/MM/DD')

SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1981-03-01', 'YYYY-MM-DD'); -- 결과값 /

SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1981/03/01', 'YYYY/MM/DD'); 



