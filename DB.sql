DROP DATABASE IF EXISTS project;
CREATE DATABASE project;
USE project;


# 커뮤니티 테이블 생성
CREATE TABLE post (
                      id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                      regDate DATETIME NOT NULL,
                      updateDate DATETIME NOT NULL,
                      title CHAR(100) NOT NULL,
                      `body` TEXT NOT NULL
);

ALTER TABLE post MODIFY COLUMN `body` LONGTEXT;
# 나중에 추가할 것
image VARCHAR(250) NOT NULL;

SELECT * FROM post;
SELECT title FROM post WHERE title LIKE '%모집%' LIMIT 10;


# 게시판 테이블 생성
CREATE TABLE board (
                       id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                       parent_id INT(10) UNSIGNED DEFAULT NULL COMMENT '부모 게시판 ID (NULL이면 1차 메뉴)',
                       regDate DATETIME NOT NULL,
                       updateDate DATETIME NOT NULL,
                       `code` CHAR(100) NOT NULL UNIQUE COMMENT '게시판 코드(ex. Q&A, 안내, 후기 등)',
                       `name` CHAR(100) NOT NULL UNIQUE COMMENT '게시판 이름',
                       delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '삭제 여부 (0=삭제 전, 1=삭제 후)',
                       delDate DATETIME COMMENT '삭제 날짜'
);

ALTER TABLE board
DROP COLUMN parent_id;

# 회원 테이블 생성
CREATE TABLE `member` (
                          id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                          regDate DATETIME NOT NULL,
                          updateDate DATETIME NOT NULL,
                          loginId CHAR(100) NOT NULL,
                          loginPw CHAR(200) NOT NULL,
                          `authLevel` SMALLINT(2) UNSIGNED DEFAULT 3 COMMENT '권한 레벨 (3=일반, 7=관리자)',
                          `name` CHAR(20) NOT NULL,
                          nickname CHAR(20) NOT NULL,
                          cellphone CHAR(20) NOT NULL,
                          email CHAR(50) NOT NULL,
                          delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '탈퇴 여부 (0=탈퇴 전, 1=탈퇴 후)',
                          delDate DATETIME COMMENT '탈퇴 날짜'
);


# 자료실 테이블 생성
CREATE TABLE resources (
                           id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                           memberId INT(10) UNSIGNED NOT NULL,
                           boardId INT(10) UNSIGNED NOT NULL,
                           regDate DATETIME NOT NULL,
                           updateDate DATETIME NOT NULL,
                           title VARCHAR(50) NOT NULL,
                           `body` TEXT NOT NULL,
                           image VARCHAR(250) NOT NULL,
                           pdf VARCHAR(250) NOT NULL,
                           zip VARCHAR(250) NOT NULL
);

select * from resources;
alter table resources add column hwp varchar(255) not null after zip;
ALTER TABLE resources ADD COLUMN word VARCHAR(255) NOT NULL AFTER hwp;
alter table resources add column xlsx varChar(255) not null after word;
ALTER TABLE resources ADD COLUMN pptx varChar(255) NOT NULL AFTER xlsx;
alter table resources add column postId int(10) unsigned not null after id;

ALTER TABLE resources
    MODIFY pdf VARCHAR(255) NULL,
    MODIFY pptx VARCHAR(255) NULL,
    MODIFY hwp VARCHAR(255) NULL,
    MODIFY word VARCHAR(255) NULL,
    MODIFY xlsx VARCHAR(255) NULL,
    MODIFY zip VARCHAR(255) NULL,
    MODIFY image VARCHAR(255) NULL;


# 좋아요 테이블 생성
CREATE TABLE `like` (
                        id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                        regDate DATETIME NOT NULL,
                        updateDate DATETIME NOT NULL,
                        memberId INT(10) UNSIGNED NOT NULL,
                        relTypeCode CHAR(100) NOT NULL COMMENT '관련 데이터 타입 코드',
                        relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
                        `like` INT(10) NOT NULL
);


# 댓글 테이블 생성
CREATE TABLE `comment` (
                           id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                           regDate DATETIME NOT NULL,
                           updateDate DATETIME NOT NULL,
                           memberId INT(10) UNSIGNED NOT NULL,
                           relTypeCode CHAR(100) NOT NULL COMMENT '관련 데이터 타입 코드',
                           relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
                           `body` TEXT NOT NULL
);

select * from `comment`;

# 자격증 테이블
CREATE TABLE qualifications(
                               id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                               `name` VARCHAR(100) NOT NULL COMMENT '자격증 이름',
                               issuing_agency VARCHAR(100) COMMENT '발급 기관',
                               organizing_agency VARCHAR(100) COMMENT '주관 기관(시행/운영)',
                               grade VARCHAR(30) DEFAULT NULL COMMENT '급수 (해당 시에만 입력)',
                               category_code VARCHAR(50) DEFAULT NULL COMMENT '무도, 응급, 경호, 그 외 등 내부 분류용(UI에 표시 안함)',
                               `type` VARCHAR(50) DEFAULT NULL COMMENT '자격증 종류 (예: 국가기술, 민간, 국제 등)',
                               applyUrl varchar(300) comment '접수 사이트 링크'
);

SELECT * FROM qualifications;




# 채용정보 테이블
CREATE TABLE job_posting(
                            id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                            title VARCHAR(255) NOT NULL,	-- 공고 제목
                            company_name VARCHAR(255) NOT NULL,	-- 기업명
                            certificate TEXT NOT NULL,	-- 우대 자격
                            start_date date NOT NULL,	-- 시작일
                            end_date date NOT NULL,	-- 마감일
                            originalUrl VARCHAR(255)   -- 개별 페이지
);


#찜 테이블
CREATE TABLE job_favorite(
                             id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                             memberId INT(10) UNSIGNED NOT NULL,
                             jobPostingId INT(10) UNSIGNED NOT NULL,
                             regDate DATETIME NOT NULL,
                             updateDate DATETIME NOT NULL
);

SELECT * FROM job_favorite;

alter table job_favorite
drop column job_posting_id,
drop column member_id,
drop column reg_date,
drop column update_date;

# 자소서/면접 저장 테이블
CREATE TABLE interview_answers (
                                   id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                   memberId INT UNSIGNED NOT NULL,
                                   regDate DATETIME NOT NULL,
                                   updateDate DATETIME NOT NULL,
                                   question TEXT NOT NULL,
                                   answer TEXT NOT NULL,
                                   category VARCHAR(50) COMMENT '면접 / 자소서 구분',
                                   FOREIGN KEY (memberId) REFERENCES MEMBER(id)
);

# 알림 기능 테이블
CREATE TABLE notification (
                              id INT(10) AUTO_INCREMENT PRIMARY KEY,
                              memberId INT(10) NOT NULL,           -- 알림 받는 회원 ID (외래키 가능)
                              title VARCHAR(255) NOT NULL,      -- 알림 제목
                              link VARCHAR(255) DEFAULT NULL,   -- 알림 클릭 시 이동할 링크
                              regDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 알림 생성일시
                              isRead BOOLEAN NOT NULL DEFAULT FALSE  -- 읽음 여부
);

select * from notification;

ALTER TABLE notification DROP COLUMN member_id;
ALTER TABLE notification DROP COLUMN is_read;
ALTER TABLE notification DROP COLUMN reg_date;

rename table interview_answers to gpt_answer;

select * from gpt_answer;

SELECT * FROM job_posting;

SELECT * FROM board;

# post 테이블에 좋아요 컬럼 추가
ALTER TABLE post ADD COLUMN `like` INT(10) UNSIGNED NOT NULL DEFAULT 0;

# post 테이블에 댓글 수 컬럼 추가
ALTER TABLE post ADD COLUMN CommentCnt INT(10) UNSIGNED NOT NULL DEFAULT 0;

## 멤버 아이디 추가
ALTER TABLE post ADD COLUMN memberId INT(10) UNSIGNED NOT NULL AFTER updateDate;

## 게시판 번호 추가
ALTER TABLE post ADD COLUMN boardId INT(10) NOT NULL AFTER `memberId`;

alter table post add column hit int(10) unsigned not null default 0;

# 게시글 테스트 데이터 생성
INSERT INTO post
SET regDate = NOW(),
updateDate = NOW(),
title = '제목1',
`body` = '내용1';

INSERT INTO post
SET regDate = NOW(),
updateDate = NOW(),
title = '제목2',
`body` = '내용2';

INSERT INTO post
SET regDate = NOW(),
updateDate = NOW(),
title = '제목3',
`body` = '내용3';


# 게시판 데이터 생성
insert into board
set regDate = now(),
updateDate = NOW(),
`code` = 'Q&A',
`name` = '질문 게시판';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '공유',
`name` = '정보 공유';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '후기',
`name` = '합격 후기';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '자유',
`name` = '자유게시판';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '기출',
`name` = '기출문제';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '자료',
`name` = '요약자료';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '뉴스',
`name` = '경호 뉴스';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '법률',
`name` = '관련 법률';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '면접',
`name` = '면접 코칭';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '자기소개서',
`name` = '자기소개서';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '공고',
`name` = '채용 공고';


# 자격증 데이터 생성
insert into qualifications
set `name` = '경비지도사',
issuing_agency = '한국산업인력공단',
organizing_agency = '경찰청 생활안전과',
grade = '일반/기계',
category_code = '경호',
`type` = '국가공인자격',
applyUrl = 'https://www.q-net.or.kr/man001.do?gSite=L&gId=09';

INSERT INTO qualifications
SET `name` = '신변보호사',
issuing_agency = '(사)한국경비협회',
organizing_agency = '(사)한국경비협회 ',
category_code = '경호',
`type` = ' 국가공인 민간자격',
applyUrl ='https://www.ksan.or.kr/test/offer.do';

INSERT INTO qualifications
SET `name` = '소방안전관리자',
issuing_agency = '한국소방안전원',
organizing_agency = '한국소방안전원',
grade = '특급, 1급, 2급, 3급',
category_code = '소방',
`type` = '국가전문자격',
applyUrl = 'https://www.kfsi.or.kr/mobile/exam/ExamApplyList.do';

INSERT INTO qualifications
SET `name` = '위험물기능사',
issuing_agency = '한국산업인력공단',
organizing_agency = '소방청',
category_code = '소방',
`type` = '국가기술자격',
applyUrl = 'https://www.q-net.or.kr/rcv001.do?id=rcv00103&gSite=Q&gId=';

INSERT INTO qualifications
SET `name` = '산업보안관리사',
issuing_agency = '(사)한국산업기술보호협회',
organizing_agency = '(사)한국산업기술보호협회',
category_code = '경호',
`type` = '국가공인 자격',
applyUrl = 'https://license.kaits.or.kr/web/main.do?screenTp=USER';

INSERT INTO qualifications
SET `name` = 'TOEIC',
issuing_agency = '한국TOEIC위원회',
organizing_agency = '한국TOEIC위원회',
category_code = '외국어',
`type` = '국가공인 민간 자격',
applyUrl = 'https://m.exam.toeic.co.kr/receipt/receiptStep1.php';

#자격증 일정 데이터 생성
INSERT INTO qualification_schedule
(qualificationId, `round`, examType, regType, regStart, regEnd, examStart, examEnd, resultDate, region, applyUrl)
VALUES
(1, '2025년 제1회', '통합', '정기', '2025-09-22', '2025-09-26', '2025-11-15', '2025-11-15', '2025-12-31', NULL, 'https://www.q-net.or.kr/crf005.do?id=crf00502&jmCd=3120');

select * from qualifications;

# 회원 테스트 데이터 생성

#관리자
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'admin',
loginPw = SHA2('admin',256),
`authLevel` = 7,
`name` = '관리자',
nickname = '관리자',
cellphone = '01012341234',
email = 'abc@gmail.com';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test1',
loginPw = SHA2('test1',256),
`name` = '회원1',
nickname = '회원1',
cellphone = '01012341234',
email = 'tanjiro@gmail.com';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test2',
loginPw = 'test2',
`name` = SHA2('test2',256),
nickname = '회원2',
cellphone= '01056785678',
email = 'pikachyu@gmail.com';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test3',
loginPw = SHA2('test3',256),
`name` = '회원3',
nickname = '회원3',
cellphone = '01078787878',
email = 'shinJJang@gmail.com';


ALTER TABLE job_posting ADD COLUMN dday INT DEFAULT NULL;

# 회원 번호 설정
UPDATE post
SET memberId = 2
WHERE id = 1;

UPDATE post
SET memberId = 3
WHERE id = 2;

UPDATE post
SET memberId = 4
WHERE id  = 3;

UPDATE post
SET memberId = 5
WHERE id = 4;

SELECT * FROM board;