
SELECT deptno
FROM (SELECT empno, ename 
      FROM emp);
      
      
SELECT ROWNUM, empno, ename
FROM (SELECT empno, ename 
      FROM emp
      ORDER BY ename);
      

SELECT *
FROM 
(SELECT ROWNUM, empno, ename
FROM (SELECT empno, ename 
      FROM emp
      ORDER BY ename));
-- 결과가 달라진 게 없음


-------------------------------------------------------


WHERE 조건1 : 10건

WHERE 조건1
  AND 조건2 : 10건을 넘을 수 없음

ex.  
WHERE deptno = 10
  AND sal > 500
  
  
SELECT a.*
FROM
(SELECT ROWNUM rn, empno, ename
FROM
(SELECT empno, ename
FROM emp
ORDER BY ename)) a
WHERE rn BETWEEN 11 AND 14;
-- WHERE sal BETWEEN 500 AND 1000; 위와 같은 개념


SELECT *
FROM 
(SELECT ROWNUM rn, empno, ename
FROM (SELECT empno, ename 
      FROM emp
      ORDER BY ename))
WHERE rn BETWEEN (:page-1)*:pageSize + 1 AND :page*:pageSize ;
-- :page, :pageSize -> 바인딩 변수


#Function
- Single row function
단일 행을 기준으로 작업하고, 행당 하나의 결과를 반환
특정 컬럼의 문자열 길이 : length(ename)
- Multi row function
여러 행을 기준으로 작업하고, 하나의 결과를 반환
그룹함수 : count, sum, avg


함수명을 보고
1. 파라미터가 어떤 게 들어갈까? - 타입
2. 몇 개의 파라미터가 들어갈까?
3. 반환되는 값은 무엇일까?


character : LOWER, UPPER, INITCAP

SELECT ename, LOWER(ename), UPPER(ename), INITCAP(ename)
FROM emp;

SELECT ename, LOWER(ename), LOWER('TEST')
FROM emp;


문자열 조합
CONCAT 
문자열 2개 입력, 1개 반환
concatenate 사슬 같이 잇다
concatenation 연쇄


SELECT ename, LOWER(ename), LOWER('TEST'),
       SUBSTR(ename, 1, 3)
FROM emp;

SELECT ename, LOWER(ename), LOWER('TEST'),
       SUBSTR(ename, 2) -- 문자열 끝까지 반환
       REPLACE(ename, 'S', 'T') -- S를 T로 변환
FROM emp;


-- 문자열 조작
INSTR, LPAD|RPAD, TRIM, REPLACE


DUAL table

SELECT *
FROM dual;

- sys 계정에 있는 테이블
- 누구나 사용 가능
- DUMMY 컬럼 하나만 존재하며 값은 'X'이며 데이터는 한 행만 존재
어디에 쓰는 걸까? 
- 사용용도
  : 데이터와 관련없이 - 함수 실행, 시퀀스 실행
    merge 문에서 merge : insert + update(crud의 update)
    데이터 복제시 connect by level


ex. 함수 실행
SELECT 1, ename
FROM emp;

SELECT LENGTH('TEST')
FROM emp;   -- 14행 출력

SELECT LENGTH('TEST')
FROM dual;  -- 1행만 출력


-- MULTI ROW에서는 사용할 수가 없어서
-- 그냥 FUNCTION이 아닌 SINGLE ROW를 붙임
SINGLE ROW FUNCTION : WHERE 절에서도 사용 가능
emp 테이블에 등록된 직원들 중에 직원의 이름이 5글자를 초과하는 직원만 조회

SELECT * -- 특정 컬럼에 대한 언급이 없으므로 *
FROM emp
WHERE LENGTH(ename) > 5;


SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';
-- WHERE ename = UPPER('smith'); -- 위와같은 결과

SELECT *
FROM emp
WHERE ename = UPPER('smith');

-- BUT 둘 중 하나는 권장하지 않는 게 있다
-- => WHERE LOWER(ename) = 'smith';
-- 모든 ename행에 LOWER 함수를 적용시키기 때문

SELECT *
FROM emp
WHERE ename = 'SMITH';
-- 이렇게 하는 게 가장 좋겠지만


1. 좌변을 가공하지 말아라. -> 컬럼을 가공하지 말라 ex. WHERE LOWER(ename) = 'smith';
1-1. 인덱스 컬럼은 비교되기 전에 변형이 일어나면 인덱스를 사용할 수 없으므로.




ORACLE 문자열 함수

SELECT 'HELLO' || ',' || 'WORLD',
        -- => CONCAT('HELLO', ',', 'WORLD')
        CONCAT('HELLO', CONCAT(',', 'WORLD')) CONCAT, -- 맨 마지막의 CONCAT은 ALIAS
        SUBSTR('HELLO, WORLD', 1, 5) SUBSTR,
        LENGTH('HELLO, WORLD') LENGTH, -- 공백도 포함, 길이는 12
        INSTR('HELLO, WORLD', 'O') INSTR, -- 5 반환, 처음부터 시작 
        INSTR('HELLO, WORLD', 'O', 6) INSTR2, -- 9 반환, 6부터 카운트 시작
        LPAD('HELLO, WORLD', 15, '*') LPAD, -- PADDING의 준말
        RPAD('HELLO, WORLD', 15, '=') RPAD, -- PADDING의 준말
        REPLACE('HELLO, WORLD', 'O', 'X') REPLACE, -- O를 X로 치환
        TRIM('   HELLO, WORLD   ') TRIM,
        -- 공백을 제거, 문자열의 앞과, 뒷부분에 있는 공백만 제거
        TRIM('D' FROM 'HELLO, WORLD') TRIM -- 알파벳 D 제거
FROM dual;


#NUMBER 숫자 조작

ROUND 반올림 - 인자 2개
TRUNC 내림 - 인자 2개
MOD 나눗셈의 나머지 

java : 10 % 3 => 1;

-- 10 피제수, 3 제수
SELECT MOD(10, 3)
FROM dual;

SELECT
ROUND(105.54, 1) round1, -- 반올림 결과가 소수점 첫 번째 자리까지 나오도록 : 소수점 둘째 자리에서 반올림
ROUND(105.55, 1) round2, -- 반올림 결과가 소수점 첫 번째 자리까지 나오도록 : 소수점 둘째 자리에서 반올림
ROUND(105.55, 0) round3, -- 반올림 결과가 첫 번째 자리(일의 자리)까지 나오도록 : 소수점 첫째 자리에서 반올림
ROUND(105.55, -1) round4, -- 반올림 결과가 두 번째 자리(십의 자리)까지 나오도록 : 정수 첫째(일의 자리)에서 반올림
ROUND(105.55) round5 -- 소수점 첫 번째 자리에서 반올림
FROM dual;

java 세로 편집 : ALT SHIFT A

SELECT
TRUNC(105.54, 1) trunc1, -- 절삭 결과가 소수점 첫 번째 자리까지 나오도록 : 소수점 둘째 자리에서 절삭 :
TRUNC(105.55, 1) trunc2, -- 절삭 결과가 소수점 첫 번째 자리까지 나오도록 : 소수점 둘째 자리에서 절삭 :
TRUNC(105.55, 0) trunc3, -- 절삭 결과가 첫 번째 자리(일의 자리)까지 나오도록 : 소수점 첫째 자리에서 절삭 : 105
TRUNC(105.55, -1) trunc4, -- 절삭 결과가 두 번째 자리(십의 자리)까지 나오도록 : 정수 첫째(일의 자리)에서 절삭 : 100
TRUNC(105.55) trunc5 -- 소수점 첫 번째 자리에서 절삭
FROM dual;

-- ex : 7499, ALLEN, 1600, 1, 600
SELECT empno, ename, sal, sal을 1000으로 나눴을 때의 몫, sal을 1000으로 나눴을 때의 나머지 
FROM emp;

SELECT empno, ename, sal, sal/1000, MOD(sal, 1000) 
FROM emp;

==>
SELECT empno, ename, sal, TRUNC(sal/1000), MOD(sal, 1000) 


날짜 <--> 문자
서버의 현재 시간 : SYSDATE

SELECT SYSDATE,
       SYSDATE + 1, -- 일
       SYSDATE + 1/24, -- 시간
       SYSDATE + 1/24/60, -- 분
       SYSDATE + 1/24/60/60 -- 초
FROM dual;


FUNCTION DATE 실습 fn1]
1. 2019년 12월 31일을 date형으로 표현
2. 2019년 12월 31일을 date형으로 표현하고 5일 이전 날짜
3. 현재 날짜
4. 현재 날짜에서 3일 전 값

위 4개 컬럼을 생성하여 다음과 같이 조회하는 쿼리를 작성하세요.
(PT 예시는 현재 날짜가 2019/10/24)

SELECT TO_DATE('19/12/31', 'YYYY/MM/DD') LASTDAY,
       TO_DATE('19/12/31', 'YYYY/MM/DD') - 5 LASTDAY_BEFORE5,
       SYSDATE NOW,
       SYSDATE - 3 NOW_BEFORE3
FROM dual;


TO_DATE() : 인자-문자, 문자의 형식
TO_CHAR() : 인자-날짜, 문자의 형식

SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD') -- YYYY, MM, DD 각각 따로 사용도 가능
FROM dual


NLS : YYYY/MM/DD HH24:MI:SS
-- 52~53
-- 주간요일(D) 0-일요일, 1-월요일, 2-화요일, ...... 6-토요일
SELECT SYSDATE, TO_CHAR(SYSDATE, 'IW'), TO_CHAR(SYSDATE, 'D') -- 현재 주차, 현재 요일
FROM dual;



date FORMAT
YYYY : 4자리 년도
MM : 2자리 월
DD : 2자리 일자
D : 주간 일자 (1~7)
IW : 주차 (1~53)
HH, HH12 : 2자리 시간 12시간 표현
HH24     : 2자리 시간 24시간 표현
MI : 2자리 분
SS : 2자리 초



Function date 실습 fn2]

오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오.
1. 년-월-일
2. 년-월-일 시간(24)-분-초
3. 일-월-년

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;


'2021-03-17' ==> '2021-03-17 12:41:00'

SELECT TO_DATE('2021-03-17', 'YYYY-MM-DD')
FROM dual;

SELECT TO_CHAR(TO_DATE('2021-03-17', 'YYYY-MM-DD'), 'YYYY-MM-DD HH24:MI:SS')
FROM dual;
-- 중복해서 사용, 일종의 저번의 CONCAT 개념

SELECT SYSDATE
FROM dual; -- 현재 날짜 + 시각 같이 출력

SELECT SYSDATE, TO_DATE(TO_CHAR(SYSDATE-5, 'YYYYMMDD'), 'YYYYMMDD')
FROM dual; -- 시분초 시간 0처리



