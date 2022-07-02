# 04-1 | MySQL의 데이터 형식

## 04-1-1 | 데이터 형식 
-- 1) 정수형
USE market_db;
CREATE TABLE hongong4 (
	tinyint_col TINYINT,
    smallint_col SMALLINT,
    int_col INT,
    bigint_col BIGINT );

-- 범위가 된다.    
INSERT INTO hongong4 VALUES(127, 32767, 2147483647, 9000000000000000000);    
-- 범위를 초과한다.
INSERT INTO hongong4 VALUES(128, 32768, 2147483648, 90000000000000000000);

-- 앞에서 짠 member 테이블 (비효율VER)
CREATE TABLE member -- 회원 테이블 
	(mem_id CHAR(8) NOT NULL PRIMARY KEY, -- 회원 아이디(PK)
    mem_name VARCHAR(10) NOT NULL, -- 이름
    mem_number INT NOT NULL, -- 인원수(***** -21억 ~ +21억, 굳이?)
    addr CHAR(2) NOT NULL, -- 주소(경기, 서울, 경남 식으로 2글자만 입력)
    phone1 CHAR(3), -- 연락처의 국번(02, 031, 055 등) 
    phone2 CHAR(8), -- 연락처의 나머지 전화번호(하이픈 제외)
    height SMALLINT, -- 평균 키 (***** -32768 ~ +32767 굳이)
    debut_date DATE -- 데뷔 일자
    );
    
CREATE TABLE member -- 회원 테이블    
	( mem_id CHAR(8) NOT NULL PRIMARY KEY, -- 회원 아이디(PK)
	mem_name VARCHAR(10) NOT NULL,
    mem_number TINYINT NOT NULL,
    addr CHAR(2) NOT NULL,
    phone1 CHAR(3),
    phone2 CHAR(8),
    height TINYINT UNSIGNED, -- 평균 키
    debut_date DATE -- 데뷔 일자
);    
    
-- 2) 문자형
	-- CHAR는 문자를 의미하는 Character의 약자로, 고정길이 문자형이며 자릿수가 고정되어 있다.
	-- CHAR(10)에 '가나다' 3글자만 저장해도 10자리를 모두 확보한 후에 앞에 3자리를 사용하고 7자리는 낭비하게 됩니다.
	-- 이와 달리 VARCHAR(Variable Character)는 가변 길이 문자형으로 주어진 길이만 사용함(속도가 느림)

	-- 대량의 데이터 형식
		-- CHAR는 최대 255자까지, VARCHAR는 최대 16383까지 지정이 가능합니다. 
	CREATE TABLE big_table (
		data1 CHAR(256),
		data2 VARCHAR(16384) ); 
    
	-- 넷플릭스 테이블 만들기    
    CREATE DATABASE netflix_db;
    USE netflix_db;
    CREATE TABLE movie
		(movie_id INT,
        movie_title VARCHAR(30),
        movie_director VARCHAR(20),
        movie_star VARCHAR(20),
        movie_script LONGTEXT, -- 자막은 LONGTEXT(1~4294967295 바이트)
        movie_film LONGBLOB -- 동영상(LONGBLOB) 대용량의 텍스트와 이진 데이터를 저장할 수 있습니다.
        );

-- 3) 실수형
	-- FLOAT: 4 바이트 | 소수점 아래 7자리까지 표현
    -- DOUBLE: 8 바이트 | 소수점 아래 15자리까지 표현 
    
-- 4) 날짜
	-- DATE: 3 바이트 | YYYY-MM-DD 형식으로 사용 
    -- TIME: 3 바이트 | 시간만 저장 HH:MM:SS 형식으로 사용 
    -- DATETIME: 8 바이트 | YYYY-MM-DD HH:MM:SS
    
## 04-1-2 | 변수의 사용
USE market_db;
SET @myVAR1 = 5 ;
SET @myVAR2 = 4.25 ;

SELECT @myVAR1 ;
SELECT @myVar1 + @myVar2 ;

SET @txt = '가수 이름 ==> ';
SET @height = 166 ;
SELECT @txt, mem_name FROM member WHERE height > @height;

-- LIMIT을 사용해보자(오류가 난다 LIMIT에는 변수를 사용할 수 없다.)
SET @count = 3;
SELECT mem_name, height FROm member ORDER BY height LIMIT @count;

-- 이를 해결하는 것이 PREPARE와 EXECUTE입니다. 
SET @count = 3; -- @count 변수에 3을 대입했습니다. 
PREPARE mySQL FROM 'SELECT mem_name, height FROM member ORDER BY height LIMIT ?';
-- PREPARE는 'SELECT ~ LIMIT ?' 문을 실행하지 않고 mySQL이라는 이름으로 준비만 해놓습니다.
-- 주의해서 볼 것은 LIMIT 다음에 오는 물음표(?)입니다. 
EXECUTE mySQL USING @count; 

## 04-1-3 | 데이터 형 변환 
	-- 문자형을 정수형으로 바꾸거나, 반대로 정수형을 문자형으로 바꾸는 것을 "데이터의 형 변환(type Conversion)이라고 부릅니다.
	-- 형 변환에는 직접 함수를 사용해서 변환하는 명시적인 변환(Explicit Conversion)
	-- 별도의 지시 없이 자연스럽게 변환되는 "암시적인 변환(Implicit Conversion)이 있다.
    
-- 1) 함수를 이용한 명시적인 변환 | CAST. (), CONVERT()이며 형식만 다를 뿐 동일한 기능 수행 
SELECT AVG(price) AS '평균 가격' FROM buy;
	-- a) 정수로 바꿔보자
	SELECT CAST(AVG(price) AS SIGNED) '평균 가격' FROM buy;
	-- 또는
	SELECT CONVERT(AVG(price) , SIGNED) '평균 가격' FROM buy;

SELECT CAST('2022$12$12' AS DATE);
SELECT CAST('2022/12/12' AS DATE);
SELECT CAST('2022%12%12' AS DATE);
SELECT CAST('2022@12@12' AS DATE);

SELECT num, CONCAT(CAST(price AS CHAR), 'X', CAST(amount AS CHAR), '=') 
	'가격X수량', price*amount '구매액'
	FROM buy;

-- 2) 암시적인 변환
SELECT '100' + '200';
SELECT CONCAT('100', '200');
SELECT CONCAT(100, '200');
SELECT 100 + '200';

# 04-2 | 두 테이블을 묶는 조인 
-- 지금까지 하나의 테이블을 다루는 작업을 위주로 공부했습니다.
-- 이를 기반으로 지금부터는 두 개의 테이블이 서로 관계되어 있는 상태를 고려해서 학습을 진행하겠습니다.

## 04-2-1 | 내부 조인 
-- 1) 일대 관계의 이해 
	-- 두 테이블의 조인을 위해서는 테이블이 일대다(one to many) 관계로 연결되어야 합니다. 
    -- 머넞 일대다 관계에 대해서 알아보겠습니다.
    
-- 2) 내부 조인의 기본 
USE market_db;
SELECT * FROM buy INNER JOIN member ON buy.mem_id = member.mem_id
WHERE buy.mem_id = 'GRL';

SELECT * FROM buy INNER JOIN member ON buy.mem_id = member.mem_id;

-- 3) 내부 조인의 간결한 표현 
SELECT 
	mem_id, mem_name, prod_name, addr, CONCAT(phone1, phone2) '연락처' 
FROM buy
	INNER JOIN member
    ON buy.mem_id = member.mem_id;

-- 테이블_이름.열_이름 형식으로 작성해보겠습니다.
SELECT buy.mem_id, member.mem_name, buy.prod_name, member.addr,
	CONCAT(member.phone1, member.phone2) '연락처'
FROM buy
	INNER JOIN member
    ON buy.mem_id = member.mem_id;

-- 별침 
SELECT B.mem_id, M.mem_name, B.prod_name, M.addr, 
		CONCAT(M.phone1, M.phone2) '연락처'
FROM buy B
	INNER JOIN member M
    ON B.mem_id = M.mem_id;

-- 4)내부 조인의 활용
SELECT M.mem_id, M.mem_name, B.prod_name, M.addr
FROM buy B
	INNER JOIN member M
    ON B.mem_id = M.mem_id
ORDER BY M.mem_id;

## 04-2-2 | 외부 조인
-- 내부 조인은 두 테이블에 모두 데이터가 있어야만 결과가 나옵니다.
-- 이와 달리 외부 조인은 한쪽에만 데이터가 있어도 결과가 나옵니다.alter

-- 1) 외부 조인의 기본
	-- 외부조인은 두 테이블을 조인할 때 필요한 내용이 한쪽 테이블에만 있어도 결과를 추출할 수 있다.
    -- 자주 사용되지는 않지만 가끔 사용됨으로 알아두면 좋다
    
    -- LEFT OUTER JOIN은 '왼쪽 테이블의 내용을 모두 출력한다'.
SELECT M.mem_id, M.mem_name, B.prod_name, M.addr
FROM member M
	LEFT OUTER JOIN buy B
    ON M.mem_id = B.mem_id
ORDER By M.mem_id;

-- 2) RIGHT OUTER JOIN으로 출력하며 오른쪽을 전부
SELECT DISTINCT M.mem_id, B.prod_name, M.addr
FROM buy B
	RIGHT OUTER JOIN member M
	ON M.mem_id = B.mem_id    
ORDER BY M.mem_id;

-- 3) 외부 조인의 활용
	-- 내부 조인으로 매한 기록이 있는 회원들의 목록만 추출해 감사문을 보냈었다.
	-- 이번에는 반대로 회원가입만 하고, 한번도 구매한적이 없는 회원의 목록을 구해보자
    
SELECT DISTINCT M.mem_id, B.prod_name, M.mem_name, M.addr
FROM member M
	LEFT OUTER JOIN buy B
    ON M.mem_id = B.mem_id
WHERE B.prod_name IS NULL
ORDER BY M.mem_id;

-- 4) 상호 조인
	-- ON 구문을 사용할 수 없다.
    -- 결과의 내용은 의미가 없습니다. 랜덤으로 조인하기 때문입니다.
    -- 상호 조인의 주 용도는 테스트하기 위해 대용량의 데이터를 생성할 때입니다.
SELECT * 
FROM buy 
CROSS JOIN member;
    
SELECT COUNT(*) '데이터 개수'
	FROM sakila.inventory
		CROSS JOIN world.city;
        
CREATE TABLE cross_table
	SELECT * 
		FROM sakila.actor -- 200건
			CROSS JOIN world.country; -- 239건
SELECT * FROM cross_table LIMIT 5;        

-- 5) 자체 조인 | 자신이 자신과 조인한다는 의미 
USE market_db;
CREATE TABLE emp_table (emp CHAR(4), manager CHAR(4), phone VARCHAR(8));

INSERT INTO emp_table VALUES('대표', NULL, '0000');
INSERT INTO emp_table VALUES('영업이사', '대표', '1111');
INSERT INTO emp_table VALUES('관리이사', '대표', '2222');
INSERT INTO emp_table VALUES('정보이사', '대표', '3333');
INSERT INTO emp_table VALUES('영업과장', '영업이사', '1111-1');
INSERT INTO emp_table VALUES('경리부장', '관리이사', '2222-1');
INSERT INTO emp_table VALUES('인사부장', '관리이사', '2222-2');
INSERT INTO emp_table VALUES('개발팀장', '정보이사', '3333-1');
INSERT INTO emp_table VALUES('개발주임', '정보이사', '3333-1-1');

-- 별칭 달기
SELECT A.emp "직원", B.emp "직속상관", B.phone "직속상관연락처"
FROM emp_table A
	INNER JOIN emp_table B
    ON A.manager = B.emp
WHERE A.emp = '경리부장';

# 04-3 | SQL 프로그래밍
	-- SQL은 아펏 배운 것처럼 SELECT, INSERT, UPDATE, DELETE 등을 사용합니다.
    -- 그래서 C, 자바, 파이썬 같은 프로그래밍 언어와는 많이 달라보입니다.
    -- 하지만 필요시 SQL만으로도 멋진 프로그램을 만들 수 있다.

## 04-3-1 | IF 문

-- 1) IF 문의 기본형식
DROP PROCEDURE IF EXISTS ifProc1;
DELIMITER $$
CREATE PROCEDURE ifProc1()
BEGIN
	IF 100 = 100 THEN
		SELECT '100은 100과 같습니다.';
	END IF;
END $$
DELIMITER ;
CALL ifProc1();

-- 2) IF ~ ELSE 문
DROP PROCEDURE IF EXISTS ifProc2;
DELIMITER $$
CREATE PROCEDURE ifProc2()
BEGIN 	
	DECLARE myNum INT;
    SET myNum = 200;
    IF myNum = 100 Then
		SELECT '100입니다.' ; 
	ELSE 
		SELECT '100이 아닙니다.';
	END IF;
END $$
DELIMITER ; 
CALL ifProc2();

-- 3) IF 문의 활용
DROP PROCEDURE IF EXISTS ifProc3;
DELIMITER $$
CREATE PROCEDURE ifProc3()
BEGIN
	-- 변수를 준비함 
	DECLARE debutDate DATE; -- 데뷔 일자 
    DECLARE curDate DATE; -- 오늘 
    DECLARE days INT; -- 활동한 일수 
    
    SELECT debut_date INTO debutDate
		FROM market_db.member
        WHERE mem_id = 'APN';
        
    SET curDATE = CURRENT_DATE();  -- 현재 날씨 
	SET days = DATEDIFF(curDATE, debutDate); -- 날씨의 차이, 일 단위 
    
	IF (days/365) >= 5 THEN
		SELECT CONCAT('데뷔한 지', days, '일이나 지났습니다. 핑순이들 축하합니다!');         
	ELSE 
		SELECT '데뷔한 지' +  days + '일 밖에 안되었네요. 핑순이들 화이팅~'; 
        
	END IF;
END $$
DELIMITER ;
CALL ifProc3();

-- 여기서 잠깐 
	-- CURRENT_DATE(): 오늘 날짜를 알려줍니다.
    -- CURRENT_TIMESTAMP(): 오늘 날짜 및 시간을 함께 알려주니다.
    -- DATEDIFF(날짜1, 날짜2): 날짜2부터 날짜1까지 일수로 몇일인지 알려줍니다.
    
SELECT CURRENT_DATE(), DATEDIFF('2021-12-31', '2000-1-1');

# 04-4 | CASE 문 

## 04-4-1 | 
	-- IF 문은 참 아니면 거짓 두가지만 있기 때문에 2중 분기라는 용어를 사용합니다.
    -- CASE는 2가지 이상의 여러 가지 경우일 때 처리가 가능하므로 '다중 분기'라고 부릅니다.

DROP PROCEDURE IF EXISTS caseProc;
DELIMITER $$
CREATE PROCEDURE caseProc()
BEGIN 
	-- 변수 선언과 지정
	DECLARE point INT;
    DECLARE credit CHAR(1);
    SET point = 96 ;
    
    CASE 
		WHEN point >= 90 THEN
			SET credit = 'A';
		WHEN point >= 80 THEN
			SET credit = 'B';
		WHEN point >= 70 THEN
			SET credit = 'C';
		WHEN point >= 60 THEN
			SET credit ='D';
		ELSE
			SET credit = 'F';
		END CASE ;
		SELECT CONCAT('취득점수 ==>', point), CONCAT('학점==>', credit);
END $$
DELIMITER ;
CALL caseProc();
    
-- 1) CASE 문의 활용 
	-- 아래와 같이 회원들의 등급을 나눠보려고한다.
		-- 1500 이상 : 최우수 고객 
        -- 1000 ~ 1499: 우수 고객 
        -- 1 ~ 999: 일반 고객 
        -- 0 이하: 유령 고객 

-- 1-1) STEP 1
SELECT mem_id, SUM(price*amount) " 총 구매액" 
FROM buy
GROUP BY mem_id;        

-- 1-2) STEP 2
SELECT mem_id, SUM(price*amount) "총 구매액"
FROM buy 
GROUP BY mem_id 
ORDER BY SUM(price*amount) DESC; 

-- 1-3) STEP 3
SELECT B.mem_id, M.mem_name, SUM(price*amount) "총 구매액"
FROM buy B 
	INNER JOIN member M
    ON B.mem_id = M.mem_id 
GROUP BY B.mem_id
ORDER BY SUM(price*amount) DESC; 

-- 1-4
SELECT M.mem_id, M.mem_name, Sum(price*amount) '총구매액'
FROM buy B 
	RIGHT OUTER JOIN member M
    ON B.mem_id = M.mem_id
GROUP BY M.mem_id
ORDER BY SUM(price*amount) DESC;

SELECT M.mem_id, M.mem_name, SUM(price*amount) "총구매액",
	CASE
		WHEN (SUM(price*amount) >= 1500) THEN '최우수고객'
        WHEN (SUM(price*amount) >= 1000) THEN '우수고객'
        WHEN (SUM(price*amount) >= 1) THEN '일반고객'
        ELSE '유령고객'
	END '회원동급'
FROM buy B
	RIGHT OUTER JOIN member M
		ON B.mem_id = M.mem_id
GROUP BY M.mem_id 
ORDER BY SUM(price*amount) DESC;

## 04-4-2 | WHILE 

DROP PROCEDURE IF EXISTS whileProc;
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE i INT; -- 1에서 100까지 증가할 변수 
    DECLARE hap INT ; -- 더한 값을 누적할 변수 
	
    SET i = 1;
    SET hap = 0;
    
    WHILE (i <=100) DO
		SET hap = hap + i;
        SET i = i + 1;
	END WHILE ;
    
    SELECT '1부터 100까지의 합 ==>', hap;
END $$
DELIMITER ;
CALL whileProc();

-- 1) WHILE 문의 응용 | ITERATE문과 LEAVE 문을 활용할 수 있다.

	-- ITERATE[레이블]: 지정한 레이블로 가서 계속 진행한다.
    -- LEAVE[레이블]: 지정한 레이블을 빠져 나갑니다. 즉 WHILE문이 종료됩니다.
    
DROP PROCEDURE IF EXISTS 