# CHAPTER 03 | SQL 기본문법

## 03-1 | 기본중에 기본 SELECT ~FROM ~WHERE

### 03-1-1 | 기본 조회하기: SELECT ~FROM
-- 1) USE 문 
USE market_db;

-- 2) SELECT와 FROM
USE market_db;
SELECT * FROM member;

SELECT * FROM market_db.member;
SELECT mem_name FROM member;
SELECT addr, debut_date, mem_name FROM member;
-- 열 이름의 별칭 
SELECT addr 주소, debut_date "데뷔 일자", mem_name FROM member;

## 03-1-2 | 특정한 조건만 조회하기: SELECT ~FROM ~WHERE
-- 1) 기본적인 WHERE 절 
SELECT * FROM member WHERE mem_name = '블랙핑크';
SELECT * FROM member WHERE mem_number = 4;

-- 2) 관계 연산자, 논리 연산자의 사용
SELECT mem_id, mem_name FROM member WHERE height <= 162;
-- -- AND
SELECT mem_name, height, mem_number FROM member WHERE height >= 165 AND mem_number >6;
-- -- OR
SELECT mem_name, height, mem_number FROM member WHERE height >=165 OR mem_number >6;

-- 3) BETWEEN ~AND
SELECT mem_name, height FROM member WHERE height >= 163 AND height <=165;
SELECT mem_name, height FROM member WHERE height BETWEEN 163 AND 165;

-- 4) IN()
SELECT mem_name, addr FROM member WHERE addr = '경기' OR addr = '전남' OR addr = '경남';
SELECT mem_name, addr FROM member WHERE addr IN('경기', '전남', '경남');

-- 5) LIKE
SELECT * FROM member WHERE mem_name LIKE '우%';
SELECT * FROM member WHERE mem_name LIKE '__핑크';

## 03 -1 (부록) | 서브 쿼리
SELECT height FROm member WHERE mem_name = '에이핑크';
SELECT mem_name, height FROM member WHERE height > 164;

SELECT mem_name, height FROM member
	WHERE height > (SELECT height FROM member WHERE mem_name = '에이핑크');
    
# 03-2 | 좀더 깊게 알아보는 SELECT 문 
## 03-2-1 | ORDER BY 절 
-- 오름차순(Default)
SELECT mem_id, mem_name, debut_date FROM member ORDER BY debut_date;
-- 내림차순
SELECT mem_id, mem_name, debut_date FROM member ORDER BY debut_date DESC;
-- 순서는 ORDER BY 가 뒤에 와야함 (WHERE가 앞)
SELECT mem_id, mem_name, debut_date, height FROM member WHERE height >= 164 ORDER BY height DESC;
-- 정렬기준 여러개
SELECT mem_id, mem_name, debut_date, height FROM member WHERE height >=164 ORDER BY height DESC, debut_date ASC;

## 03-2-2 | 출력의 개수를 제한: LIMIT
SELECT * FROM member LIMIT 3;
SELECT mem_name, debut_date FROM member ORDER BY debut_date LIMIT 3; 
-- 중간부터 출력
SELECT mem_name, height FROM member ORDER BY height DESC LIMIT 3,2;

## 03-2-3 | 중복된 결과를 제거: DISTINCT
SELECT addr FROm member;
SELECT addr FROM member ORDER BY addr;
-- 고유값 
SELECT DISTINCT addr FROM member;

## 03-2-4 | GROUP BY 절 
SELECT mem_id, amount FROM buy ORDER BY mem_id;
-- 1) 집계 함수 
SELECT mem_id, SUM(amount) FROM buy GROUP BY mem_id; 
SELECT mem_id '회원 아이디', SUM(amount) '총 구매 개수' FROM buy GROUP BY mem_id; 
-- 곱하기
SELECT mem_id '회원 아이디', SUM(price*amount) '총 구매 금액' FROM buy GROUP BY mem_id;
-- 평균 
SELECT AVG(amount) '평균 구매 개수' FROM buy;
SELECT mem_id, AVG(amount) '평균 구매 개수' FROM buy GROUP BY mem_id;
-- Count 
SELECT COUNT(*) FROM member;
SELECT COUNT(phone1) '연락처가 있는 회원' FROM member;
-- 2) Having
SELECT mem_id '회원 아이디', SUM(price*amount) '총 구매 금액' FROM buy GROUP BY mem_id;
SELECT mem_id '회원 아이디', SUM(price*amount) '총 구매 금액' 
	FROM buy GROUP BY mem_id HAVING SUM(price*amount) > 1000;

SELECT mem_id '회원 아이디', SUM(price*amount) '총 구매 금액' FROM buy GROUP BY mem_id
	HAVING SUM(price*amount) > 1000;
    
SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액" FROM buy GROUP BY mem_id
	HAVING SUM(price*amount) > 1000 ORDER BY SUM(price*amount) DESC;
    
# 03-3 | 데이터 변경을 위한 SQL 문
-- 앞서 배운 SELECT는 이미 만들어 놓은 테이블에서 데이터를 추출하는 구문입니다. 
-- 이번 절에서는 입력, 수정, 삭제를 통해 행 데이터를 구축하는 방법을 상세하게 알아보겠슴니다.

## 03-3-1 데이터 입력: INSERT
-- 1) INSERT 문의 기본 문법
USE market_db;
CREATE TABLE hongong1 (toy_id INT, toy_name CHAR(4), age INT);
INSERT INTO hongong1 VALUES (1, '우디', 25);
-- age입력하고 싶지 않다면 비우고 해당 위치에 Null이 들어간다.
INSERT INTO hongong1 (toy_id, toy_name) values(2, '버즈');
-- 열의 순서를 바꾸고 싶다면 순서를 맞춰서 쓰면 된다.
INSERT INTO hongong1 (toy_name, age, toy_id) VALUES('제시', 20, 3);

-- 2) 자동으로 증가하는 AUTO_INCREMENT
CREATE TABLE hongong2 (
	toy_id INT AUTO_INCREMENT PRIMARY KEY,
    toy_name CHAR(4),
    age INT);
    
INSERT INTO hongong2 VALUES (NULL, '보핖', 25);
INSERT INTO hongong2 VALUES (NULL, '슬링키', 22);
INSERT INTO hongong2 VALUES (NULL, '렉스', 21);
SELECT * FROM hongong2;
-- 현재 어느 숫자까지 증가되었는지 확인이 필요 (자동 증가로 3까지 입력되었다는 의미)
SELECT LAST_INSERT_ID();
-- AUTO_INCREMEN로 입ㄱ되는 값이 100부터 시작하도록 변경
ALTER TABLE hongong2 AUTO_INCREMENT=100;
INSERT INTO HONGONG2 VALUES(NULL, '재남', 35);
SELECT * FROM hongong2;

-- 시작 값을 1000으로 설정하고: @@auto_increment_increment를 변경시켜야 합니다.
CREATE TABLE hongong3 (
	toy_id INT AUTO_INCREMENT PRIMARY KEY,
    toy_name CHAR(4),
    age INT);
ALTER TABLE hongong3 AUTO_INCREMENT = 1000; -- 시작값은 1000으로 지정
SET @@auto_increment_increment =3; -- 증가값은 3으로 지정

##### 시스템 변수
-- 시스템 변수란 MySQL에서 자체적으로 가지고 있는 설정값이 저장된 변수를 말합니다.
-- 주로 MySQL의 환경과 관련된 내용이 저장되어 있으며, 그 개수는 500개 이상입니다.

-- 시스템 변수는 앞에 @@가 붙는 것이 특정이며 시스템 변수의 값을 확인하려면 SELECT @@시스템변수를 실행
-- 만약 전체 시스템 변수의 종류를 알고 싶다면 SHOW GLOBAL VARIABLES를 실행하면 된다.

-- 처음 시작되는 값과 증가값을 확인해보자
INSERT INTO hongong3 VALUES(NULL, '토마스', 20);
INSERT INTO hongong3 VALUES(NULL, '제임스', 23);
INSERT INTO hongong3 VALUES(NULL, '고든', 25);
SELECT * FROM hongong3;

-- 3 다른 테이블의 데이터를 한 번에 입력하는 INSERT INTO ~ SELECT
SELECT COUNT(*) FROM world.city;
-- DESC(describe) 출력
DESC world.city;
SELECT * FROM world.city LIMIT 5;
-- 도시이름(Name)과 인구(Population)를 가져와봅니다. 먼저 테이블을 만들겠습니다. 
CREATE TABLE city_popul (city_name CHAR(35), population INT);
-- world.city 테이블의 내용을 city_popul 테이블에 입력 
INSERT INTO city_popul
	SELECT Name, Population FROM world.city;
## 03-3-2 | 데이터 수정: UPDATE
-- 1) 앞에서 생성한 city_popul 테이블의 도시 이름(city_name) 중에서 'Seoul'을 서울로 변경해보겠습니다.
USE market_db;
UPDATE city_popul
	SET city_name = '서울'
    WHERE city_name = 'Seoul';
SELECT * FROm city_popul WHERE city_name = '서울';
-- 2) 필요하면 한꺼번에 여러 열의 값을 변경 가능하다. (콤마로 분리)
UPDATE city_popul
	SET city_name = '뉴욕', population = 0 -- 명칭도 수정, 인구도 수정    
    WHERE city_name = 'NEW YORK';
SELECT * FROM city_popul WHERE city_name = '뉴욕';
-- 3) WHERE가 없는 UPDATE문 
-- UPDATE에 WHERE 절을 쓰지 않으면 전체가 업데이트 된다(이건 실행하지마라 ******)
UPDATE city_popul
	SET city_name = '서울';

UPDATE city_popul
	SET population = population/10000;
SELECT * FROM city_popul LIMIT 5;

## 03-3-3 | 데이터 삭제: DELETE (테이블의 행 데이터를 삭제해야 하는 경우 발생)
DELETE FROM city_popul WHERE city_name LIKE 'New%';
DELETE FROm city_popul
	WHERE city_name LIKE 'New%'
    LIMIT 5;
    
## 03-3-4 | 좀 더 알아보기: 대용량 테이블의 삭제 
CREATE TABLE big_table1 (SELECT * FROM world.city, sakila.country);
CREATE TABLE big_table2 (SELECT * FROM world.city, sakila.country);
CREATE TABLE big_table3 (SELECT * FROM world.city, sakila.country);
SELECT COUNT(*) FROm big_table1;

-- DELETE, DROP, TRUNCATE
DELETE FROM big_table1; -- 삭제가 오래 걸림 (테이블을 남긴다)
DROP TABLE big_table2; -- 테이블 자체를 삭제합니다.
TRUNCATE TABLE big_table3;  -- DELTE와 같은 효과지만 속도가 빠르다. (테이블을 남긴다)

