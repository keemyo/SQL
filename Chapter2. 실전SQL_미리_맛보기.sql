# CHAPTER 2 | 실전용 SQL 미리 맛보기

-- 1. 전체 선택
use shop_db;
SELECT * FROM members;

-- 2. 특정 칼럼만 따오기
SELECT member_name, member_addr FROM member;

-- 3. 특정 조건으로 불러오기
SELECT * FROM member WHERE member_name = '아이유';

# 2-3 | 데이터베이스 개체
## 2-3-1. 인덱스
-- 1.Full Table Scan: 시간이 많이 소요됨
SELECT * FROM member WHERE member_name = '아이유'; 

-- 2. 인덱스 생성하기
	-- 인덱스는 열에 지정합니다. ON member(member_name)의 의미는
    -- member 테이블의 member_name 열에 인덱스를 지정하라는 의미입니다. 
CREATE INDEX idx_member_name ON member(member_name);

-- 3. 인덱스 탐색: Non-Unique Key Lookup (Key Lookup: 인덱스를 통해 찾았다 - 인덱스 검색)
SELECT * FROM member WHERE member_name = '아이유'; 

## 2-3-2 뷰

-- 1. 뷰 만들기
CREATE VIEW member_view AS SELECT * FROM member;

-- 2. 뷰에 접근 
SELECT * FROM member_view;

## 2-3-3 스토어드 프로시저
-- 1. 예시 
SELECT * FROM member WHERE member_name = '나훈아';
SELECT * FROM product WHERE product_name = '삼각김밥';

-- 2. 위 두개를 스토어드 프로시저로 만들기
DELIMITER //
CREATE PROCEDURE myProc() -- 스토어드 프로시저 이름 설정
BEGIN
	SELECT * FROM member WHERE member_name = '나훈아';
    SELECT * FROM product WHERE product_name = '삼각김밥';
END //

-- 3. 스토어드 프로시저 불러오기: Call 문
CALL myProc();