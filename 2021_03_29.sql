이제 실습 시작
실습파일의 dept_h 파일 열어서 테이블 추가

-- 테이블 정상적으로 추가 됐는지 조회
SELECT *
FROM dept_h;


h-1] 최상위 노드부터 리프 노드까지 탐색하는 계층 쿼리 작성
(LAPD를 이용한 시각적 표현까지 포함)

SELECT deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm, p_deptcd, LEVEL
FROM dept_h
START WITH p_deptcd IS NULL
-- START WITH p_deptcd = NULL --> 이렇게 쓰면 어떠한 행도 출력X
CONNECT BY PRIOR deptcd = p_deptcd; 
CONNECT BY 현재 행의 deptcd = 앞으로 읽을 행의 p_deptcd
// PSUEDO 가상코드, 위처럼 논리를 말로 나타낸 것, 
// 특정 언어를 지칭하지 않음, 각 언어에 맞게 코드를 짜보는 것도 공부가 될 것


SQL 응용
계층쿼리 실습 h_2]
정보시스템부 하위의 부서계층 구조를 조회하는 쿼리를 작성하세요.

SELECT LEVEL, deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptnm = '정보시스템부'
CONNECT BY PRIOR deptcd = p_deptcd; -- 하향
-- CONNECT BY PRIOR p_deptcd = deptcd; -- 상향

나부터 방문? 자식부터 방문?
ORACLE 계층 쿼리의 탐색 순서는 ? PRE-ORDER 프리오더, 
LEVEL-ORDER이려면
A
_B
_B2
__C
__C2
이런 식으로 상위레벨을 우선으로 모아서 출력


계층쿼리 상향식 실습 h_3]
- 디자인팀에서 시작하는 상향식 계층 쿼리를 작성하세요
SELECT LEVEL, deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptnm = '디자인팀'
CONNECT BY PRIOR p_deptcd = deptcd; -- 상향
CONNECT BY 현재 행의 부모(P_DEPT_CD) = 앞으로 읽을 행의 부서코드(DEPT_CD)


계층형쿼리 복습 - 인덱스번호1 없는 파일
실습파일에서 테이블 추가
-- 추가된 테이블 조회
SELECT *
FROM h_sum;


h_4]
SELECT LPAD(' ', (LEVEL-1)*4) || s_id s_id, value
FROM h_sum
START WITH ps_id IS NULL
CONNECT BY PRIOR s_id = ps_id;

-- s_id는 데이터타입이 숫자? 문자?
DESC h_sum; 
-- s_id는 문자

SELECT LPAD(' ', (LEVEL-1)*4) || s_id s_id, value
FROM h_sum
START WITH s_id = '0' -- s_id 컬럼은 문자형이므로 정확하게 같이 자료형을 맞춰줌
CONNECT BY PRIOR s_id = ps_id;

PRIOR 이 있다 -> 현재 위치와 ?이전위치?에 대한 조회
PRIOR 이 없다 -> 앞으로 찾아갈 행에 대한 조회

