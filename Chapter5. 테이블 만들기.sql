# 05-1 | 테이블 만들기 

## 05-1-1 | 데이터베이스와 테이블 설계하기 

## 05-1-2 | GUI 환경에서 테이블 만들기
-- 1) 데이터베이스 생성하기
CREATE DATABASE naver_db; 

-- 2) 테이블 생성하기 

-- 3) 데이터 입력하기 

# 05-2 | SQL로 테이블 만들기 
CREATE TABLE sample_table (num INT); 

-- 1) 데이터베이스 생성하기 
DROP DATABASE IF EXISTS naver_db; 
CREATE DATABASE naver_db; 

-- 2)테이블 생성하기 
USE naver_db;
DROP TABLE IF EXISTS member;
CREATE TABLE member -- 회원테이블 
	(mem_id CHAR(8), -- 회원 아이디(PK)
    mem_name VARCHAR(10), -- 이름 
    mem_number TINYINT, -- 인원수 
    addr CHAR(2), -- 주소(경기, 서울, 경남 식으로 2글자만 입력) 
    phone1 CHAR(3), -- 연락처의 국번(02, 031, 055 등) 
    phone2 CHAR(8), -- 연락처의 나머지 전화번호(하이픈 제외) 
    height TINYINT UNSIGNED, -- 평균 키 
    debut_date DATE -- 데뷔 일자 
    ); 


-- 3) NULL/NOT NULL을 고려한다.    
DROP TABLE IF EXISTS member; -- 기존에 있으면 삭제 
CREATE TABLE member 
( mem_id CHAR(8) NOT NULL,
mem_name VARCHAR(10) NOT NULL, 
mem_number TINYINT NOT NULL, 
addr CHAR(2) NOT NULL,
phone1 CHAR(3) NULL,
phone2 CHAR(8) NULL,
height TINYINT UNSIGNED NULL,
debut_date DATE NULL
);

-- 4) PRIMARY KEY 설정 
DROP TABLE IF EXISTS member ; 
CREATE TABLE member
(mem_id CHAR(8) NOT NULL PRIMARY KEY,
mem_name VARCHAR(10) NOT NULL,
mem_number TINYINT NOT NULL,
addr CHAR(2) NOT NULL, 
phone1 CHAR(3) NULL,
phone2 CHAR(8) NULL,
height TINYINT UNSIGNED NULL,
debut_date DATE NULL
);

-- 5) buy 테이블 만들기 
DROP TABLE IF EXISTS buy; -- 기존에 있으면 삭제 
CREATE TABLE buy -- 구매 테이블 
( num INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK) 
mem_id CHAR(8) NOT NULL, -- 아이디(FK)
prod_name CHAR(6) NOT NULL, -- 제품 이름 
group_name CHAR(4) NULL, -- 분류
price INT UNSIGNED NOT NULL, -- 가격 
amount  SMALLINT UNSIGNED NOT NULL -- 수량 
); 

-- 6) buy: Foeign target 
DROP TABLE IF EXISTS buy; -- 기존에 있으면 삭제 
CREATE TABLE buy 
( num INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
mem_id CHAR(8) NOT NULL,
prod_name CHAR(6) NOT NULL, 
group_name CHAR(4) NULL, 
price INT UNSIGNED NOT NULL,
amount SMALLINT UNSIGNED NOT NULL, 
FOREIGN KEY(mem_id) REFERENCES member(mem_id)
) ; 

-- 7) 데이터 입력하기 
INSERT INTO member VALUES('TWC', '트와이스', 9, '서울', '02', '11111111', 167, '2015-10-19');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남', '055','22222222', 173, '2016-8-8');
INSERT INTO member VALUES('WMW', '여자친구', '경기', '031', '33333333', 166, '2015-1-15');

INSERT INTO buy VALUES(NULL, 'BLK', '지갑', NULL, 30, 2);
INSERT INTO buy VALUES(NULL, 'BLK', '맥북프로','디지털', 1000, 1);
INSERT INTO buy VALUES(NULL, 'APN', '아이폰', '디지털', 200, 1);

# 05-2 | 제약조건으로 테이블을 견고하게 
-- 테이블에는 기본 키, 외래 키와 같은 제약조건을 설정할 수 있습니다. 
-- 제약조건은 테이블을 구성하는 핵심 개념으로 이를 잘 이해하고 활용한다면 좋은 코드를 짤 수 있다.

## 05-2-1 | 제약조건의 기본 개념과 종류
	-- 제약조건(Constraint)은 데이터의 무결성을 지키기 위해 제한하는 조건
		-- PRIMARY KEY 제약 조건
        -- FOREIGN KEY 제약 조건 
        -- UNIQUE 제약조건 
        -- DEFAULT 정의 
        -- NULL 값 허용 
	
## 05-2-1 | 기본 키 제약조건 

-- 1) CREATE TABLE에서 설정 기본 키 제약조건 
USE naver_db;
DROP TABLE IF EXISTS buy, member; 
CREATE TABLE member 
( mem_id CHAR(8) NOT NULL PRIMARY KEY,
  mem_name VARCHAR(10) NOT NULL,
  height TINYINT UNSIGNED NULL 
  ); 
	-- 회원 테이블(member) 및 구매 테이블(buy) 열을 일부 생략해서 단순화시키겠습니다. 
    
DESCRIBE member;

-- 2) DROP 
DROP TABLE IF EXISTS member; 
CREATE TABLE member 
( mem_id CHAR(8) NOT NULL,
  mem_name VARCHAR(10) NOT NULL,
  height TINYINT UNSIGNED NULL,
  PRIMARY KEY (mem_id)
) ;  

-- 3) ALTER TABLE에서 설정하는 기본 키 제약 조건 
DROP TABLE IF EXISTS member; 
CREATE TABLE member
( mem_id CHAR(8) NOT NULL,
  mem_name VARCHAR(10) NOT NULL, 
  height TINYINT UNSIGNED NULL
); 

ALTER TABLE member 
	ADD CONSTRAINT 
    PRIMARY KEY (mem_id); 
    
	-- 앞서 CREATE TABLE 안에 PRIMARY KEY를 설정한 거솨 지금 ALTER TABLE로 PRIMARY KEY를 지정한 것은 동일     
DROP TABLE IF EXISTS member;
CREATE TABLE member 
( mem_id CHAR(8) NOT NULL,
  mem_name VARCHAR(10) NOT NULL,
  height TINYINT UNSIGNED NULL,
  CONSTRAINT PRIMARY KEY PK_member_mem_id (mem_id)
  ); 

## 05-2-2 | 외래 키 제약조건 

-- 1) CREATE TABLE에서 설정하는 외래 키 제약조건 

DROP TABLE IF EXISTS buy, member;
CREATE TABLE member 
( mem_id CHAR(8) NOT NULL PRIMARY KEY,
  mem_name VARCHAR(10) NOT NULL,
  height TINYINT UNSIGNED NULL);
  
CREATE TABLE buy 
( num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  mem_id CHAR(8) NOT NULL,
  prod_name CHAR(6) NOT NULL,
  FOREIGN KEY(mem_id) REFERENCES member(mem_id)
  );

-- 외래 키 의 형식은 FOREIGN KEY(열_이름) REFERENCES 기준_테이블(열_이름) 

-- 2) ALTER TABLE에서 설정하는 외래 제약 조건 
DROP TABLE IF EXISTS buy;

CREATE TABLE buy
( num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  mem_id CHAR(8) NOT NULl,
  prod_name CHAR(6) NOT NULL 
  );

ALTER TABLE buy
	ADD CONSTRAINT 
    FOREIGN KEY(mem_id)
    REFERENCES member(mem_id) ;
    
-- 3) 기준 테이블의 열이 변경될 경우 
SELECT * FROM member; 
SELECT * FROM buy;

INSERT INTO member VALUES('BLK', '블랙핑크', 163);
INSERT INTO buy VALUES(NULL, 'BLK', '지갑');
INSERT INTO buy VALUES(NULL, 'BLK', '맥북');   

SELECT M.mem_id, M.mem_name, B.prod_name
FROM buy B
	INNER JOIN member M
    ON B.mem_id = M.mem_id ; 
    
UPDATE member SET mem_id = 'PINK' WHERE mem_id = 'BLK';

DELETE FROM member WHERE mem_id = 'BLK';

-- 물려있는 값들이 있기 때문에 업데이트 되지 않는다.
-- ON UPDATE CASCADE / ON DELETE CASCADE 문 

DROP TABLE IF EXISTS buy;
CREATE TABLE buy
( num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  mem_id CHAR(8) NOT NULL,
  prod_name CHAR(6) NOT NULL );
  
ALTER TABLE buy
	ADD CONSTRAINT
    FOREIGN KEY(mem_id) REFERENCES member(mem_id) 
    ON UPDATE CASCADE 
    ON DELETE CASCADE;
    
INSERT INTO buy VALUES(NULL, 'BLK', '지갑');
INSERT INTO buy VALUES(NULL, 'BLK', '맥북');

UPDATE member SET mem_id = 'PINK' WHERE mem_id = 'BLK';

SELECT M.mem_id, M.mem_name, B.prod_name
FROM buy B
	INNER JOIN member M
    ON B.mem_id = M.mem_id;

DELETE FROM member WHERE mem_id = 'PINK';

SELECT * FROM buy;

## 05-2-3 | 기타 제약 조건 

-- 1) 고유 키 제약 조건 
	-- 고유키(Unique) 제약조건은 '중복되지 않는 유일한 값'을 입력해야하는 조건입니다. 
    -- 차이점은 고유 키 제약조건은 NULL 값을 허용한다는 것입니다. 
    
DROP TABLE IF EXISTS buy, member; 
CREATE TABLE member 
( mem_id CHAR(8) NOT NULL PRIMARY KEY,
  mem_name VARCHAR(10) NOT NULL, 
  height TINYINT UNSIGNED NULL,
  email CHAR(30) NULL UNIQUE ); 

INSERT INTO member VALUES('BLK', '블랙핑크', 163, 'pink@gmail.com');
INSERT INTO member VALUES('TWC', '오마이걸', 167, NULL);
INSERT INTO member VALUES('APN', '에이핑크', 164, 'pink@gmail.com');

-- 2) 체크 제약 조건 

DROP TABLE IF EXISTS  member;
CREATE TABLE member 
( mem_id CHAR(8) NOT NULL PRIMARY KEY,
  mem_name VARCHAR(10) NOT NULL,
  height TINYINT UNSIGNED NULL CHECK (height>= 100),
  phone1 CHAR(3) NULL);
  
INSERT INTO member VALUES('BLK', '블랙핑크', 163, NULL);
INSERT INTO member VALUES('TWC', '트와이스', 99, NULL);

SELECT * FROM member;

ALTER TABLE member 
	ADD CONSTRAINT
	CHECK (phone1 IN ('02', '031', '032', '054', '055', '061'));
    
INSERT INTO member VALUES('TWC', '트와이스', 167, '02'); -- 가능 
INSERT INTO member VALUES('OMY', '오마이걸', 167, '010'); -- 불가능  

-- 3) 기본값 정의 
DROP TABLE IF EXISTS member; 
CREATE TABLE member 
( mem_id CHAR(8) NOT NULL PRIMARY KEY, 
  mem_name VARCHAR(10) NOT NULL, 
  height TINYINT UNSIGNED NULL DEFAULT 160,
  phone1 CHAR(3) NULL ) ;

ALTER TABLE member
	ALTER COLUMN phone1 SET DEFAULT '02';

INSERT INTO member VALUES('RED', '레드벨벳', 161, '054');
INSERT INTO member VALUES('SPC', '우주소녀', default, default);
SELECT * FROM member; 

# 05-3 | 가상의 테이블: 뷰 
USE market_db ; 
CREATE VIEW v_member 
	AS 
	SELECT mem_id, mem_name, addr FROM member;
    
SELECT * FROM v_member;

SELECT mem_name, addr FROM v_member 
WHERE addr IN ('서울', '경기');

SELECT B.mem_id, M.mem_name, B.prod_name, M.addr,
	   CONCAT(M.phone1, M.phone2) '연락처'
FROM buy B
	INNER JOIN member M
    ON B.mem_id = M.mem_id;

CREATE VIEW v_memberbuy 
AS 
	SELECT B.mem_id, M.mem_name, B.prod_name, M.addr,
			CONCAT(M.phone1,"-",M.phone2) '연락처'
		FROM buy B
			INNER JOIN member M
            ON B.mem_id = M.mem_id;
## 05-3-1 | 뷰의 실제 작동 

-- 1) 뷰의 실제 생성, 수정, 삭제 
USE market_db; 
CREATE VIEW v_viewtest1 
AS 
	SELECT B.mem_id, "Member ID", M.mem_name AS "Member name",
    B.prod_name "Product Name", 
		CONCAT(M.phone1, M.phone2) AS "Office Phone"
	FROM buy B 
		INNER JOIN member M 
        ON B.mem_id = M.mem_id ; 
SELECT DISTINCT `Member ID`, `Member Name` FROM v_viewtest1; 

-- 2) ALTER VIEW 
ALTER VIEW v_viewtest1
AS 
	SELECT B.mem_id '회원 아이디', M.mem_name AS '회원 이름',
		   B.prod_name '제품 이름', 
           CONCAT(M.phone1, M.phone2) AS '연락처'           
	   FROM buy B	
		   INNER JOIN member M
		   ON B.mem_id = M.mem_id;
SELECT DISTINCT `회원 아이디`, `회원 이름` FROM v_viewtest1;
       
DROP VIEW v_viewtest1;       
		
-- 3) 뷰의 정보 확인 
USE market_db ;
CREATE OR REPLACE VIEW v_viewtest2 
AS 
	SELECT mem_id, mem_name, addr FROM member; 

DESCRIBE v_viewtest2;
DESCRIBE member; 	   

SHOW CREATE VIEW v_viewtest2;

-- 4) 뷰를 통한 데이터의 수정/삭제 
	-- 뷰를 통해서 테이블의 데이터를 수정할 수도 있습니다.
	-- v_member 뷰를 통해 데이터를 수정해보겠습니다.
UPDATE v_member SET addr = '부산' WHERE mem_id = 'BLK';

INSERT INTO v_member(mem_id, mem_name, addr) VALUES('BTS', '방탄소년단', '경기');
	-- mem_number 열은 NOT NULL로 설정되어서 반드시 입력해줘야 합니다. 
    -- 현재의 v_member에서는 mem_number 열을 참조하고 있지 않으므로 값을 입력할 방법이 없습니다.
    
CREATE VIEW v_height167 
	AS
		SELECT * FROM member WHERE height >= 167;
	SELECT * FROM v_height167; 
    
DELETE FROM v_height167 WHERE height < 167;

-- 5) 뷰를 통한 데이터의 입력 : WHERE절이 있기 때문에 INSERT를 해도 입력되지 않음
INSERT INTO v_height167 VALUES('TRA', '티아라', 6, '서울', NULL, NULL, 159, '2005-01-01');
SELECT * FROM v_height167;

	-- 이럴 떄 예약어 "WITH CHECK OPTION"을 통해 뷰에 설정된 값의 범위가 벗어나는 값은 입력되지 않도록 할 수 있다. 
ALTER VIEW v_height167 
AS 
	SELECT * FROM member WHERE height >= 167 
		WITH CHECK OPTION ;
	
INSERT INTO v_height167 VALUES("TOB", '텔레토비', 4, '영국', NULL, NULL, 140, '1995-01-01'); 

-- 하나의 테이블로 만든 뷰를 단순 뷰라 하고, 두 개 이상의 테이블로 만든 뷰를 복합뷰라고합니다.
-- 복합 뷰는 주로 두 테이블을 조인한 결과로 뷰를 만들 때 사용합니다. 
CREATE VIEW v_complex 
AS
	SELECT B.mem_id, M.mem_name, B.prod_name, M.addr
    FROM buy B 
		INNER JOIN member M
		ON B.mem_id = M.mem_id ; 
    
-- 6) 뷰가 참조하는 테이블의 삭제

DROP TABLE IF EXISTS buy, member; 

SELECT * FROM v_height167;

CHECK TABLE v_height167;
