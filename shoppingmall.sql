-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        10.5.19-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- shoppingmall 데이터베이스 구조 내보내기
CREATE DATABASE IF NOT EXISTS `shoppingmall` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `shoppingmall`;

-- 테이블 shoppingmall.address 구조 내보내기
CREATE TABLE IF NOT EXISTS `address` (
  `address_no` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(50) NOT NULL,
  `address` text NOT NULL,
  `address_lastdate` datetime NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`address_no`) USING BTREE,
  KEY `FK_d_address_id` (`id`) USING BTREE,
  CONSTRAINT `FK_address_id_list` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.address:~6 rows (대략적) 내보내기
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` (`address_no`, `id`, `address`, `address_lastdate`, `createdate`, `updatedate`) VALUES
	(2, 'user2', '부천시 몰라로', '2023-03-01 00:00:00', '2023-03-01 00:00:00', '2023-03-01 00:00:00'),
	(3, 'user3', '서울시 가산로', '2023-04-01 00:00:00', '2023-04-01 00:00:00', '2023-04-01 00:00:00'),
	(4, 'user4', '제주시 감귤로', '2023-05-01 00:00:00', '2023-05-01 00:00:00', '2023-05-01 00:00:00'),
	(5, 'user1', '경기 수원시 장안구 송죽동 496 1층', '2023-06-23 17:24:53', '2023-06-23 17:24:53', '2023-06-23 17:24:53'),
	(6, 'user1', '수원시 칠보로', '2023-06-23 17:27:44', '2023-06-23 17:27:44', '2023-06-23 17:27:44'),
	(7, 'user1', '수원시 칠보로', '2023-06-24 16:44:31', '2023-06-24 16:44:31', '2023-06-24 16:44:31');
/*!40000 ALTER TABLE `address` ENABLE KEYS */;

-- 테이블 shoppingmall.answer 구조 내보내기
CREATE TABLE IF NOT EXISTS `answer` (
  `answer_no` int(11) NOT NULL AUTO_INCREMENT,
  `q_no` int(11) NOT NULL,
  `id` varchar(50) NOT NULL,
  `answer_content` text NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`answer_no`),
  KEY `FK_answer_employee` (`id`) USING BTREE,
  KEY `FK_answer_question` (`q_no`) USING BTREE,
  CONSTRAINT `FK_answer_employee` FOREIGN KEY (`id`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_answer_question` FOREIGN KEY (`q_no`) REFERENCES `question` (`q_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.answer:~5 rows (대략적) 내보내기
/*!40000 ALTER TABLE `answer` DISABLE KEYS */;
INSERT INTO `answer` (`answer_no`, `q_no`, `id`, `answer_content`, `createdate`, `updatedate`) VALUES
	(1, 2, 'admin1', '해외배송은 불가능합니다. 감사합니다.', '2023-05-02 00:00:00', '2023-05-02 00:00:00'),
	(2, 3, 'admin1', '선불결제만 가능합니다. 감사합니다.', '2023-05-02 00:00:00', '2023-05-02 00:00:00'),
	(3, 5, 'admin1', '봄철 계절꽃은 판매종료되었습니다. 감사합니다.', '2023-05-02 00:00:00', '2023-05-02 00:00:00'),
	(4, 8, 'admin1', '프리저브드 화분은 판매 예정입니다. 감사합니다.', '2023-05-02 00:00:00', '2023-05-02 00:00:00'),
	(6, 7, 'admin1', '예', '2023-06-23 17:48:33', '2023-06-23 17:48:33');
/*!40000 ALTER TABLE `answer` ENABLE KEYS */;

-- 테이블 shoppingmall.cart 구조 내보내기
CREATE TABLE IF NOT EXISTS `cart` (
  `cart_no` int(11) NOT NULL AUTO_INCREMENT,
  `product_no` int(11) NOT NULL,
  `id` varchar(50) NOT NULL,
  `cart_cnt` int(11) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`cart_no`),
  KEY `FK_cart_product` (`product_no`),
  KEY `FK_cart_id` (`id`) USING BTREE,
  CONSTRAINT `FK_cart_id` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_cart_product` FOREIGN KEY (`product_no`) REFERENCES `product` (`product_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.cart:~3 rows (대략적) 내보내기
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` (`cart_no`, `product_no`, `id`, `cart_cnt`, `createdate`, `updatedate`) VALUES
	(2, 4, 'user2', 10, '2023-05-05 00:00:00', '2023-05-05 00:00:00'),
	(3, 24, 'user3', 10, '2023-05-05 00:00:00', '2023-05-05 00:00:00'),
	(4, 25, 'user4', 10, '2023-05-05 00:00:00', '2023-05-05 00:00:00');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;

-- 테이블 shoppingmall.category 구조 내보내기
CREATE TABLE IF NOT EXISTS `category` (
  `category_name` varchar(50) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.category:~5 rows (대략적) 내보내기
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` (`category_name`, `createdate`, `updatedate`) VALUES
	('계절꽃', '2022-01-01 00:00:00', '2023-06-24 19:07:37'),
	('기타', '2022-01-01 00:00:00', '2022-01-01 00:00:00'),
	('꽃다발', '2022-01-01 00:00:00', '2022-01-01 00:00:00'),
	('꽃화분', '2022-01-01 00:00:00', '2022-01-01 00:00:00'),
	('화환/조화', '2022-01-01 00:00:00', '2022-01-01 00:00:00');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;

-- 테이블 shoppingmall.customer 구조 내보내기
CREATE TABLE IF NOT EXISTS `customer` (
  `id` varchar(50) NOT NULL,
  `cstm_name` varchar(50) NOT NULL,
  `cstm_address` text NOT NULL,
  `cstm_email` varchar(50) NOT NULL,
  `cstm_birth` datetime NOT NULL,
  `cstm_gender` enum('남','여') NOT NULL,
  `cstm_phone` varchar(50) NOT NULL,
  `cstm_rank` enum('씨앗','새싹','꽃') NOT NULL DEFAULT '씨앗',
  `cstm_point` int(11) NOT NULL DEFAULT 0,
  `cstm_last_login` datetime NOT NULL,
  `cstm_agree` enum('Y','N') NOT NULL,
  `updatedate` datetime NOT NULL,
  `createdate` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `FK_customer_id_list` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.customer:~6 rows (대략적) 내보내기
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` (`id`, `cstm_name`, `cstm_address`, `cstm_email`, `cstm_birth`, `cstm_gender`, `cstm_phone`, `cstm_rank`, `cstm_point`, `cstm_last_login`, `cstm_agree`, `updatedate`, `createdate`) VALUES
	('user1', '이강산', '수원시 칠보로   ', 'sanlee@naver.com', '1997-12-27 00:00:00', '남', '01024370000', '새싹', 9380, '2023-06-27 17:41:11', 'Y', '2023-06-23 17:38:02', '2023-02-01 00:00:00'),
	('user2', '이예은', '부천시 몰라로', 'yesilver@naver.com', '2000-02-02 00:00:00', '여', '01012345678', '새싹', 7900, '2023-03-03 00:00:00', 'Y', '2023-03-01 00:00:00', '2023-03-01 00:00:00'),
	('user3', '신정음', '서울시 가산로', 'melody@naver.com', '2000-01-01 00:00:00', '여', '01012345678', '새싹', 7900, '2023-04-04 00:00:00', 'Y', '2023-04-01 00:00:00', '2023-04-01 00:00:00'),
	('user4', '김미선', '제주시 감귤로', 'givemesun@naver.com', '1994-03-03 00:00:00', '여', '01012345678', '새싹', 7900, '2023-05-03 00:00:00', 'Y', '2023-05-01 00:00:00', '2023-05-01 00:00:00'),
	('user7', '김하성', '샌디에이고주 파드리스', 'castlekim@naver.com', '1994-05-05 00:00:00', '남', '01012345678', '꽃', 10500, '2023-06-27 16:53:15', 'Y', '2023-02-01 00:00:00', '2022-10-01 00:00:00'),
	('user9', '오타니', '로스앤젤레스 에인절스', 'ohyouride@google.com', '1994-12-27 00:00:00', '남', '01012345678', '꽃', 10300, '2023-05-03 00:00:00', 'Y', '2023-02-01 00:00:00', '2022-12-01 00:00:00');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;

-- 테이블 shoppingmall.discount 구조 내보내기
CREATE TABLE IF NOT EXISTS `discount` (
  `discount_no` int(11) NOT NULL AUTO_INCREMENT,
  `product_no` int(11) NOT NULL,
  `discount_start` datetime NOT NULL,
  `discount_end` datetime NOT NULL,
  `discount_rate` double NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`discount_no`),
  KEY `FK_discount_product` (`product_no`),
  CONSTRAINT `FK_discount_product` FOREIGN KEY (`product_no`) REFERENCES `product` (`product_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.discount:~5 rows (대략적) 내보내기
/*!40000 ALTER TABLE `discount` DISABLE KEYS */;
INSERT INTO `discount` (`discount_no`, `product_no`, `discount_start`, `discount_end`, `discount_rate`, `createdate`, `updatedate`) VALUES
	(1, 1, '2023-06-10 00:00:00', '2023-06-30 00:00:00', 0.3, '2023-05-05 00:00:00', '2023-06-26 16:49:10'),
	(2, 8, '2023-06-15 00:00:00', '2023-07-15 00:00:00', 0.6, '2023-05-05 00:00:00', '2023-06-26 16:49:10'),
	(3, 13, '2023-06-01 00:00:00', '2023-06-30 00:00:00', 0.5, '2023-05-05 00:00:00', '2023-05-05 00:00:00'),
	(4, 14, '2023-06-01 00:00:00', '2023-06-30 00:00:00', 0.5, '2023-05-05 00:00:00', '2023-05-05 00:00:00'),
	(5, 5, '2023-06-01 00:00:00', '2023-06-30 00:00:00', 0.5, '2023-05-05 00:00:00', '2023-06-26 16:49:10');
/*!40000 ALTER TABLE `discount` ENABLE KEYS */;

-- 테이블 shoppingmall.employees 구조 내보내기
CREATE TABLE IF NOT EXISTS `employees` (
  `id` varchar(50) NOT NULL,
  `emp_name` varchar(50) NOT NULL,
  `emp_level` enum('1','2') NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `FK_employee_id_list` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.employees:~2 rows (대략적) 내보내기
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` (`id`, `emp_name`, `emp_level`, `createdate`, `updatedate`) VALUES
	('admin1', '부사장', '1', '2022-02-01 00:00:00', '2022-02-01 00:00:00'),
	('admin2', '사장', '2', '2022-01-01 00:00:00', '2022-01-01 00:00:00');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;

-- 테이블 shoppingmall.id_list 구조 내보내기
CREATE TABLE IF NOT EXISTS `id_list` (
  `id` varchar(50) NOT NULL,
  `last_pw` varchar(50) NOT NULL,
  `active` enum('Y','N') NOT NULL,
  `createdate` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.id_list:~11 rows (대략적) 내보내기
/*!40000 ALTER TABLE `id_list` DISABLE KEYS */;
INSERT INTO `id_list` (`id`, `last_pw`, `active`, `createdate`) VALUES
	('admin1', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'Y', '2022-01-01 00:00:00'),
	('admin2', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'Y', '2022-01-01 00:00:00'),
	('user1', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'Y', '2023-02-01 00:00:00'),
	('user2', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'Y', '2023-03-01 00:00:00'),
	('user3', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'Y', '2023-04-01 00:00:00'),
	('user4', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'Y', '2023-05-01 00:00:00'),
	('user5', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'N', '2022-07-01 00:00:00'),
	('user6', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'N', '2022-08-01 00:00:00'),
	('user7', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'Y', '2022-10-01 00:00:00'),
	('user8', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'N', '2022-09-01 00:00:00'),
	('user9', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'N', '2022-12-01 00:00:00');
/*!40000 ALTER TABLE `id_list` ENABLE KEYS */;

-- 테이블 shoppingmall.orders 구조 내보내기
CREATE TABLE IF NOT EXISTS `orders` (
  `order_no` int(11) NOT NULL AUTO_INCREMENT,
  `product_no` int(11) NOT NULL,
  `id` varchar(50) NOT NULL,
  `order_status` enum('결제완료','배송중','배송완료','취소') NOT NULL,
  `order_cnt` int(11) NOT NULL,
  `order_price` int(11) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`order_no`),
  KEY `FK_order_product` (`product_no`),
  KEY `FK_order_id` (`id`) USING BTREE,
  CONSTRAINT `FK_order_id` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_order_product` FOREIGN KEY (`product_no`) REFERENCES `product` (`product_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.orders:~3 rows (대략적) 내보내기
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` (`order_no`, `product_no`, `id`, `order_status`, `order_cnt`, `order_price`, `createdate`, `updatedate`) VALUES
	(15, 1, 'user1', '취소', 2, 55860, '2023-06-27 17:39:48', '2023-06-27 17:40:05'),
	(16, 8, 'user1', '결제완료', 4, 24000, '2023-06-27 17:40:18', '2023-06-27 17:40:18'),
	(17, 9, 'user1', '배송완료', 6, 96000, '2023-06-27 17:40:33', '2023-06-27 17:41:02');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;

-- 테이블 shoppingmall.point_history 구조 내보내기
CREATE TABLE IF NOT EXISTS `point_history` (
  `point_no` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL,
  `point_pm` enum('+','-') NOT NULL,
  `point` int(11) NOT NULL,
  `createdate` datetime NOT NULL,
  PRIMARY KEY (`point_no`),
  KEY `FK_point_history_orders` (`order_no`),
  CONSTRAINT `FK_point_history_orders` FOREIGN KEY (`order_no`) REFERENCES `orders` (`order_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.point_history:~8 rows (대략적) 내보내기
/*!40000 ALTER TABLE `point_history` DISABLE KEYS */;
INSERT INTO `point_history` (`point_no`, `order_no`, `point_pm`, `point`, `createdate`) VALUES
	(38, 15, '-', 300, '2023-06-27 17:39:48'),
	(39, 15, '+', 2793, '2023-06-27 17:39:48'),
	(40, 15, '+', 300, '2023-06-27 17:40:05'),
	(41, 15, '-', 2793, '2023-06-27 17:40:05'),
	(42, 16, '-', 5000, '2023-06-27 17:40:18'),
	(43, 16, '+', 1200, '2023-06-27 17:40:18'),
	(44, 17, '-', 3000, '2023-06-27 17:40:33'),
	(45, 17, '+', 2880, '2023-06-27 17:40:33');
/*!40000 ALTER TABLE `point_history` ENABLE KEYS */;

-- 테이블 shoppingmall.product 구조 내보내기
CREATE TABLE IF NOT EXISTS `product` (
  `product_no` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) NOT NULL,
  `product_name` varchar(50) NOT NULL,
  `product_price` int(11) NOT NULL,
  `product_status` enum('판매중','품절') NOT NULL,
  `product_info` text NOT NULL,
  `product_stock` int(11) NOT NULL,
  `product_sale_cnt` int(11) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`product_no`),
  KEY `FK_product_category` (`category_name`),
  CONSTRAINT `FK_product_category` FOREIGN KEY (`category_name`) REFERENCES `category` (`category_name`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.product:~28 rows (대략적) 내보내기
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` (`product_no`, `category_name`, `product_name`, `product_price`, `product_status`, `product_info`, `product_stock`, `product_sale_cnt`, `createdate`, `updatedate`) VALUES
	(1, '꽃다발', '꽃다발-장미', 39900, '판매중', '1개당 25송이 기준가 입니다.', 100, 200, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(2, '꽃다발', '꽃다발-데이지', 39900, '판매중', '1개당 20송이 기준가 입니다.', 99, 102, '2023-01-01 00:00:00', '2023-06-27 17:39:48'),
	(3, '꽃다발', '꽃다발-작약', 39900, '판매중', '1개당 30송이 기준가 입니다.\n\n1송이 : 첫 눈에 반했습니다. \n2송이 : 이 세계에는 당신과 저 뿐입니다 \n3송이 : 사랑합니다. 고백. 당신과 나, 우리의 사랑\n4송이 : 죽을때까지 이 마음 변치 않습니다\n5송이 : 당신을 만난 것에 진심의 기쁨을\n6송이 : 당신에게 푹 빠졌습니다. 서로 존중하고, 사랑하며, 이해합시다\n7송이 : 은밀한 사랑\n8송이 : 당신의 배려, 마음씀씀이에 감사를\n9송이 : 언제나 당신을 사랑하고 있습니다\n10송이 : 머리부터 발끝까지 완벽한 당신\n11송이 : 누구(10)보다도 당신(1)을 사랑합니다\n12송이 : 저와 사귀어주시겠습니까?\n13송이 : 영원한 우정\n21송이 : 당신에게 제 모든 것을\n24송이 : 하루종일 당신만이 떠오릅니다\n50송이 : 당신을 향한 영원한 사랑\n99송이 : 영원한 사랑. 언제나 좋아했습니다\n100송이 : 100%의 사랑\n101송이 : 더할나위 없이 사랑합니다\n108송이 : 결혼해주시겠습니까?\n144송이 : 몇 번을 다시 태어나도 당신을 사랑합니다\n365송이 : 매일같이 사랑스러운 당신\n999송이 : 어느 생이건 당신을 사랑합니다\n\n꽃말은 \'부끄러움\'.\n\n꽃 모양 때문인지 모란꽃과 자주 오인되기도 하지만, 두 식물 모두 엄연히 다르다. 모란은 나무이며 작약은 풀이다. 꽃이 비슷해도 줄기를 보면 그것이 확연히 차이나는 걸 알 수 있다. 다만 둘 다 아름다운 꽃의 대명사로 여겨 동양권에서 미인을 모란이나 작약에 빗대기도 했다. 또 미인을 상징하는 관용구 중에는 \'서면 작약, 앉으면 모란, 걸으면 백합\'이라는 말도 있다.', 100, 40, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(4, '꽃다발', '꽃다발-카네이션', 39900, '판매중', '1개당 15송이 기준가 입니다.\n\n1송이 : 첫 눈에 반했습니다. \n2송이 : 이 세계에는 당신과 저 뿐입니다 \n3송이 : 사랑합니다. 고백. 당신과 나, 우리의 사랑\n4송이 : 죽을때까지 이 마음 변치 않습니다\n5송이 : 당신을 만난 것에 진심의 기쁨을\n6송이 : 당신에게 푹 빠졌습니다. 서로 존중하고, 사랑하며, 이해합시다\n7송이 : 은밀한 사랑\n8송이 : 당신의 배려, 마음씀씀이에 감사를\n9송이 : 언제나 당신을 사랑하고 있습니다\n10송이 : 머리부터 발끝까지 완벽한 당신\n11송이 : 누구(10)보다도 당신(1)을 사랑합니다\n12송이 : 저와 사귀어주시겠습니까?\n13송이 : 영원한 우정\n21송이 : 당신에게 제 모든 것을\n24송이 : 하루종일 당신만이 떠오릅니다\n50송이 : 당신을 향한 영원한 사랑\n99송이 : 영원한 사랑. 언제나 좋아했습니다\n100송이 : 100%의 사랑\n101송이 : 더할나위 없이 사랑합니다\n108송이 : 결혼해주시겠습니까?\n144송이 : 몇 번을 다시 태어나도 당신을 사랑합니다\n365송이 : 매일같이 사랑스러운 당신\n999송이 : 어느 생이건 당신을 사랑합니다\n\n빨간 색"카네이션"의 꽃말: 어머니의 사랑, 감동\n분홍색의 "카네이션"의 꽃말: 여성의 사랑, 열애, 아름다운 몸짓\n백색의 "카네이션"의 꽃말: 순수한 사랑, 내 사랑은 살아 있어요, 존경', 92, 59, '2023-01-01 00:00:00', '2023-06-27 17:40:18'),
	(5, '꽃다발', '꽃다발-프리저브드', 39900, '판매중', '1개당 5송이 기준가 입니다. 원하는 꽃으로 만들어 드립니다. \n\n인조꽃 프리저브드 드라이플라워다발\n\n1송이 : 첫 눈에 반했습니다. \n2송이 : 이 세계에는 당신과 저 뿐입니다 \n3송이 : 사랑합니다. 고백. 당신과 나, 우리의 사랑\n4송이 : 죽을때까지 이 마음 변치 않습니다\n5송이 : 당신을 만난 것에 진심의 기쁨을\n6송이 : 당신에게 푹 빠졌습니다. 서로 존중하고, 사랑하며, 이해합시다\n7송이 : 은밀한 사랑\n8송이 : 당신의 배려, 마음씀씀이에 감사를\n9송이 : 언제나 당신을 사랑하고 있습니다\n10송이 : 머리부터 발끝까지 완벽한 당신\n11송이 : 누구(10)보다도 당신(1)을 사랑합니다\n12송이 : 저와 사귀어주시겠습니까?\n13송이 : 영원한 우정\n21송이 : 당신에게 제 모든 것을\n24송이 : 하루종일 당신만이 떠오릅니다\n50송이 : 당신을 향한 영원한 사랑\n99송이 : 영원한 사랑. 언제나 좋아했습니다\n100송이 : 100%의 사랑\n101송이 : 더할나위 없이 사랑합니다\n108송이 : 결혼해주시겠습니까?\n144송이 : 몇 번을 다시 태어나도 당신을 사랑합니다\n365송이 : 매일같이 사랑스러운 당신\n999송이 : 어느 생이건 당신을 사랑합니다\n\n프리저브드는 “보존하다” 라는 뜻으로 생화를 특수 보전용액을 통해 탈수, 탈색, 착색, 보존, 건조의 단계를 거쳐 생화의 아름다움을 그대로 장기간 보존 할 수 있도록 만든 새로운 개념의 꽃입니다.\n프리저브드 플라워는 조화도 아니고 드라이플라워도 아닌 생화 그대로이면서 물이 필요없는 꽃입니다.\n유럽과 특히 일본에서는 “시들지 않는 꽃”, “마법의 꽃”이라 불리며 선풍적인 인기를 누리고 있습니다.', 100, 80, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(6, '꽃화분', '꽃화분-동백나무', 27000, '판매중', '1개당 1그루 기준가 입니다.\n\n씨앗에서 동백기름을 짜는데, 쉽게 산패하지 않아 예전에는 꽤 유용하게 사용되었다. \n예를 들면 여자들이 동백기름으로 머리를 손질하기도 했고, 목재 등에 먹여 썩는 것을 방지하기도 하고, 윤활유나 철물의 녹 방지용으로 사용 할 수 있다. \n물론 식용유로도 사용할 수 있다. 다만 식품위생법이 까다롭기 때문에 식품으로 유통되는 양은 꽤나 적다.\n 뭐 굳이 찾으려는 사람도 적은 편... 윤활유등 대체 물질이 많아진 이후로는 그냥 관상용으로 심고 있지만 요즘 천연물질이 각광받으면서 화장품의 원료와 목공 쪽에서 천연 마감제로도 수요가 다시 늘고 있다고 한다.\n\n또한, 가까운 사촌관계인 차나무처럼 잎을 우려내여 동백차로 마실 수 있는데, 신기하게 카페인과 카테킨도 똑같이 들어있다고 한다.\n\n동백나무의 열매가 다 익으면 저절로 벌어지며 씨앗이 노출되는데, 이 때 식물 바이러스에 감염되어 씨앗이 형성되지 않으면 섬유질이 뒤틀리며 마치 빵같은 식감으로 변형된다. \n이를 동백빵이라고 하는데, 한국의 시골 등지에서 종종 먹곤 한다. 맛은 아주 옅은 단 맛이 나는 바삭바삭한 공갈빵이라고.', 91, 63, '2023-01-01 00:00:00', '2023-06-27 17:40:33'),
	(7, '꽃화분', '꽃화분-선인장', 15000, '판매중', '1개당 2그루 기준가 입니다.\n\n보통 기둥 모양을 한 선인장이 가장 널리 알려져 있으나, 실제로는 평범한 나무와 별 다를 바 없는 원시적인 형태의 선인장에서부터 덩굴 형태의 착생식물까지 그 종류가 다양하다.\n\n이 중 나무 모양 선인장을 제외한 선인장들은 잎이 퇴화되었으며, 표피의 두께가 두꺼운 데다가 숨구멍이 거의 없어 수분의 손실이 다른 식물에 비하여 매우 적다.\n\n선인장과에 속한 모든 식물은 광합성 과정 중 대부분 낮에 이산화탄소 합성을 하는 C3와 C4 식물들과는 다르게, 밤에 이산화탄소를 저장해서 쓰는 CAM 식물들이며, 다육식물 구조로 이루어져 내부에 수분을 저장할 수 있는지라 건조한 환경에서도 오랫동안 생존할 수 있다.\n\n지구상에서 가장 환경이 척박한 사막에서 보란 듯이 자생하는 종답게 생명력 자체도 매우 끈질겨서 종류에 따라서는 갈기갈기 찢긴 상태더라도, 잘린 조각에 싹이 트는 눈점이 하나라도 남아있다면 다시 뿌리를 내리고 싹을 틔워서 살아가는 강력한 생명력을 자랑한다.\n\n선인장은 다른 종의 선인장끼리 접붙이기가 가능하다. 삼각주+비모란 접붙이기 선인장은 꽃가게에서 흔히 볼 수 있을 정도다. 게발선인장과 목선인장도 접붙이기가 가능하다.\n', 100, 88, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(8, '꽃화분', '꽃화분-후쿠시아', 15000, '판매중', '1개당 1그루 기준가 입니다. \n\n넝쿨성 관엽식물\n\n독일의 식물학자이자 의사인 레오나르도 후크스를 기념하기 위해 후쿠시아라는 이름이 붙여졌 다. 특이한 형태의 꽃을 피우는 분화로 오늘날 유럽에서는 2,000품종이 재배에 이용되고 있다. 여름철에서 가을에 이르는 동안 애용되는 분화이다.\n\n \n꽃색은 자색 또는 적색, 꽃 밥은 홍적색, 비색 또는 백색이며, 꽃잎은 꽃밥보다 짧고, 아래를 향하여 느러지는 것이 마치 등과 흡사하므로 일명 등 꽃이라고도 칭한다.\n\n\n주로 온실에 서 화분 식재되어 30~60cm정도의 높이까지 된다. 원산지가 안데스 산간지방이기 때문에 서늘하고 습기가 약간 있는 곳이 좋다. 여름의 더위에 약하지만 가을이 되면 다시 튼튼한 꽃을 맺는다. 내한성도 약하므로 실 내에서 겨울을 지낸다. 개화전후의 포기는 충분한 관수가 필요하지만, 그외의 시기는 건조에 비교적 강하다.', 100, 12, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(9, '꽃화분', '꽃화분-수국', 16000, '판매중', '1개당 5송이(뿌리) 기준가 입니다.\n\n꽃말은 냉정, 냉담과 무정, 변덕, 변심이다. 또, 위와는 다르게 진실한 사랑, 처녀의 꿈,[3], 진심,[4] 인내심이 강한 사랑이라는 꽃말도 존재한다.\n\n또한 꽃의 색으로 토양의 pH를 확인할 수 있는데 pH6.0~6.5 정도의 토양에선 핑크색, pH4.5 정도의 산성토에선 푸른색을 띈다. 토양이 산성에서 점점 중성으로 올라갈수록, 보라색, 자주색, 옅은 자주색, 분홍색으로 변한다. 품종에 따라서 색깔이 고정되는 경우도 있다.\n한반도·중국·일본 등의 동아시아 등지에 분포하며, 본래는 중국 원산이지만, 중국에서는 자생군락이 발견되지 않으며, 일본에서 품종 개량이 많이 되었다. 미스 사오리, 치쿠의 바람, 만화경, 미카의 물떼새 등 특이한 이름으로 판매 중. 품종보호 탓에 시중에서 파는 수국보다 꽤 비싸지만(15cm 포트묘 기준 2만원 전후) 정말 풍성하고 아름다운 꽃으로 개량된 품종들이 많다. 영국, 일본의 원예식물 콘테스트가 열릴 때마다 일본산 수국들은 상위권에 위치할 정도로 높이 평가받는다.', 100, 25, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(10, '꽃화분', '꽃화분-철쭉', 16000, '판매중', '1개당 5송이(뿌리) 기준가 입니다.\n\n학교의 정원 길가에 가로수 사이사이에 심어 두어 매년 꽃이 필 때쯤이면 아름다운 꽃을 감상할 수 있다. 철쭉 묘목이 상당히 저렴해서 아파트나 가정집에서 싸게 넓은 곳을 식재하는 용도로 많이 쓰이고 있다. 반그늘을 좋아하므로 아파트에서도 잘 자란다.\n\n철쭉은 다양한 색의 꽃이 피고 품종에 따라 따라 크기가 다르고 일부 품종은 겹꽃이어서 5개 이상의 꽃잎을 지니다.\n\n영산홍과도 매우 닮았으며, 식물을 잘 모르는 사람은 철쭉과 영산홍을 거의 구별하지 못한다고 보아도 무방하다. 간단한 구별법은 수술의 수를 세어보는 것. 철쭉과 진달래는 수술의 수가 10개지만 영산홍은 5개다.\n\n꽃말은 \'자제, 사랑의 즐거움\'이다.\n\n한국에서는 산지 등에서 흔히 볼 수 있지만 영어 이름이 Royal Azalea라는 거창한 이름에서도 알 수 있듯이 꽃이 진달래속 중에서도 대형이고, 수많은 협회에서 상을 타낸 유명한 꽃이다. 일본에서도 국명인 クロフネツツジ 이외에 ツツジの女王(철쭉의 여왕)이라고도 불리며, 17~18세기 진달래류가 유행하던 때에 큰 꽃과 기품으로 큰 인기를 끌었다고 한다.', 100, 22, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(11, '화환/조화', '화환-동양란_랜덤', 44000, '판매중', '동양란 랜덤+화분세트 개업화분 축하화환\n\n동양란은 서양란에 대응하는 명칭으로,\n아시아권의 온대지방에서 자라는 난초과 식물입니다.\n예로부터 고고한 자태와 그윽한 향기를 품고 있는 모습이 선비와 같다고 보았으며,\n군자의 상징으로 통합니다.\n\n그래서 그런지\n주로 취임, 영전, 승진 등을 축하하기 위해\n고급스러운 선물로 여겨지고 있습니다.\n\n동양란 물주는 방법\n\n모든 식물이 그러하듯, 동양란도 마찬가지로 키우는 환경에 따라 다르게 물을 줘야 합니다.\n\n보통\n겨울에는 한낮에 15-20일에 한번,\n여름에는 해가 진 후 4-5일에 한번,\n봄이나 가을에는 이름 아침이나 해가 진 후 일주일에 한번\n정도라고 볼 수 있습니다\n\n자주자주 조금씩 물 주기는\n뿌리가 썩어 난이 죽을 수도 있습니다!!\n화분 밑으로 물이 충분히 빠질 만큼 듬뿍 주세요!\n양동이 등에 물을 가들 부어놓고 분을 푹 담갔다가 꺼내거나, 난 잎 위에서부터 잎을 씻듯이\n샤워기 수압을 조절하면서 분 밑으로 물이 흐를 만큼 주면 됩니다 :D', 100, 88, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(12, '화환/조화', '화환-서양란_랜덤', 44000, '판매중', '서양란 랜덤+화분세트 개업화분 축하화환\n\n서양란은 꽃이 화려하고 꽃 지름이 크고 넓으며 품종이 다양한데다가 꽃이 오래가서 분심기 꽃의 여왕이라 불린다. 19세기에 들어와서 영국을 중심으로 양란재배가 활발해지기 시작하여 수많은 교배종이 만들어졌고, 강열한 색채와 변화가 다양한 꽃의 화려함이 정적인 동양란과는 대조를 이룬다.\n\n서양란 특징 \n서양란이 고령지대의 꽃이라고 생각하고 있던 시대는 이미 지나가고 우리들이 손쉽게 재배할 수 있을 만큼 가까와지고 각지에서 열리고 있는 양란전은 대단한 인기가 있다. 양란의 원산지는 열대, 아열대 지역의 해변에서 높은 산지에까지 분포되어 있기 때문에 그것들이 원종과 교배 개량한 품종을 재배하기에는 추운 월동과 더운 월하에도 다소의 마음 가짐이 필요하다\n\n\n일반적인 서양란 관리법\n하루종일 햇빛이 잘 들어오는 곳에서 관리하며 충분한 햇빛을 쪼여준다.\n최저온도는 5~10도면 되고 특히 고온을 좋아하는 반다는 15도 이상을 유지한다.\n물은 표토가 마르는 것을 기준으로 따뜻한날 오전에 실시하는데, 보통 1주일이 주기가 된다.\n습도는 50~60%, 시비와 소독은 하지 않아도 된다. 개화종은 보통 15도 정도에서 조금 높은 습도로 관리해야 꽃이 오래간다.\n찬바람이 잎에 직접 닿지 않게 하면서 통풍은 가급적 원활하게 해준다. 난방기구의 뜨거운 바람이 잎에 직접닿지 않도록 유의한다.', 100, 64, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(13, '화환/조화', '화환-특대', 80000, '판매중', '축하화환 특대 사이즈 개업 개원 사무실 이전 등\n\n"진심으로 축하드립니다"\n정성껏 제작한 축하화환으로 결혼식, 개업식등 기쁜날을. 축하해 주세요.', 100, 27, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(14, '화환/조화', '화환-중~대', 58000, '판매중', '축하화환 중~대 사이즈 개업 개원 사무실 이전 등\n\n"진심으로 축하드립니다"\n정성껏 제작한 축하화환으로 결혼식, 개업식등 기쁜날을. 축하해 주세요.', 100, 49, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(15, '화환/조화', '화환-소~중', 32000, '판매중', '축하화환 소~중 사이즈 개업 개원 사무실 이전 등\n\n"진심으로 축하드립니다"\n정성껏 제작한 축하화환으로 결혼식, 개업식등 기쁜날을. 축하해 주세요.', 100, 74, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(16, '화환/조화', '조화-특대', 80000, '판매중', '근조화환 특대 사이즈 장례 장례식등\n\n근조화환 3단 기본형 리본 문구\n리본 왼편\n리본 왼편에는 보내는 사람의 정보를 적습니다.\n회사명 (소속기관) + 직급 + 이름\n리본 오른편\n주로 ‘삼가 故人의 冥福을 빕니다’ 라고 적습니다. 한글로 써도 되고 한자로 섞어서 쓰기도 합니다.\n기독교나 천주교는 를 한글로 ‘昇天을 哀悼합니다‘ 라고 적기도 합니다.\n', 100, 47, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(17, '화환/조화', '조화-중~대', 58000, '판매중', '근조화환 중~대 사이즈 장례 장례식등\n\n근조화환 3단 기본형 리본 문구\n리본 왼편\n리본 왼편에는 보내는 사람의 정보를 적습니다.\n회사명 (소속기관) + 직급 + 이름\n리본 오른편\n주로 ‘삼가 故人의 冥福을 빕니다’ 라고 적습니다. 한글로 써도 되고 한자로 섞어서 쓰기도 합니다.\n기독교나 천주교는 를 한글로 ‘昇天을 哀悼합니다‘ 라고 적기도 합니다.\n', 100, 90, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(18, '화환/조화', '조화-소~중', 32000, '판매중', '근조화환 소~중 사이즈 장례 장례식등\n\n근조화환 3단 기본형 리본 문구\n리본 왼편\n리본 왼편에는 보내는 사람의 정보를 적습니다.\n회사명 (소속기관) + 직급 + 이름\n리본 오른편\n주로 ‘삼가 故人의 冥福을 빕니다’ 라고 적습니다. 한글로 써도 되고 한자로 섞어서 쓰기도 합니다.\n기독교나 천주교는 를 한글로 ‘昇天을 哀悼합니다‘ 라고 적기도 합니다.\n', 100, 21, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(19, '기타', '기타-인간화환', 7900, '판매중', '인간화환 원하는 문구 작성 #졸업식 #축제 #결혼식 #체육대회 ', 100, 290, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(20, '기타', '기타-돈다발', 12900, '판매중', '만원권 오만원권 혼합 가능\n\n상품 구매하실 때 원하시는 금액도 함께 입금해주시면 됩니다! \n\n#어버이날 #결혼식 #축제\n\n\n\n', 100, 270, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(21, '기타', '기타-화분_소', 5900, '판매중', '화분 소 사이즈 \n\n화분 고르는 꿀팁!\n\n1. 우리 집 창문은 남향? 동향?\n식물을 키울 내 공간에 빛이 얼마나 들어오나요? \n집을 고를 때 빛의 방향을 따지듯이, 식물이 살 공간을 고를 때도 빛의 방향을 고려해주어야 한답니다. \n남쪽을 보는 창문으로는 밝은 빛이 들어오고, 동쪽이나 서쪽으로 난 창문은 중간 정도의 빛, 북쪽으로는 약한 빛이 들어오겠지요? \n대부분의 실내식물은 창문을 통해 들어오는 밝은 빛을 좋아하지만, \n강한 햇빛을 직접 받으면 잎이 탈 수도 있으니 햇살이 너무 셀 때는 얇은 커튼을 쳐서 빛을 간접적으로 받을 수 있게 도와주세요.\n우리 집이 어두운 편이라면 스투키, 크로톤, 안스리움 등과 같이 반음지에서 잘 자라는 식물이나, \n스킨답서스, 금전수, 행운목 등과 같이 음지에서도 잘 자라는 아이를 들여보세요. \n햇빛은 식물의 밥이기 때문에, 부족하면 배고프고, 과하면 배탈이 난답니다. \n반려식물이 살아갈 공간의 밝기를 살피고, 그 밝기에서 잘 자라는 반려식물을 들여주세요.\n\n2. 내 생활 습관과 맞는 식물이 있답니다.\n바쁜 스케줄로 물 주기를 자주 깜빡한다거나, 곁에 있어도 없는 존재로 취급하기 일쑤여서 식물 키우기 망설이시나요? \n어떤 식물들은 세심한 관리 없이도 잘 자란답니다. \n다육식물이나 금전수는 적당한 빛이 들어오는 곳에서 키운다면 당신이 멀리 여행을 떠난 동안에도 잘 지낼 수 있어요.\n식물을 돌볼 시간이 좀 더 있거나, 반려식물 키우기를 즐기는 분이라면 세심한 관심이 필요한 공중식물이나 난초류, 고사리류 식물 키우기에 도전해보는 것도 재미있을 거예요. \n이런 섬세한 식물에게는 매일 물을 뿌려주면서 적절한 습도를 유지해주어야 하거든요.\n\n', 100, 70, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(22, '기타', '기타-화분_중', 8900, '판매중', '화분 중 사이즈 \n\n화분 고르는 꿀팁!\n\n1. 우리 집 창문은 남향? 동향?\n식물을 키울 내 공간에 빛이 얼마나 들어오나요? \n집을 고를 때 빛의 방향을 따지듯이, 식물이 살 공간을 고를 때도 빛의 방향을 고려해주어야 한답니다. \n남쪽을 보는 창문으로는 밝은 빛이 들어오고, 동쪽이나 서쪽으로 난 창문은 중간 정도의 빛, 북쪽으로는 약한 빛이 들어오겠지요? \n대부분의 실내식물은 창문을 통해 들어오는 밝은 빛을 좋아하지만, \n강한 햇빛을 직접 받으면 잎이 탈 수도 있으니 햇살이 너무 셀 때는 얇은 커튼을 쳐서 빛을 간접적으로 받을 수 있게 도와주세요.\n우리 집이 어두운 편이라면 스투키, 크로톤, 안스리움 등과 같이 반음지에서 잘 자라는 식물이나, \n스킨답서스, 금전수, 행운목 등과 같이 음지에서도 잘 자라는 아이를 들여보세요. \n햇빛은 식물의 밥이기 때문에, 부족하면 배고프고, 과하면 배탈이 난답니다. \n반려식물이 살아갈 공간의 밝기를 살피고, 그 밝기에서 잘 자라는 반려식물을 들여주세요.\n\n2. 내 생활 습관과 맞는 식물이 있답니다.\n바쁜 스케줄로 물 주기를 자주 깜빡한다거나, 곁에 있어도 없는 존재로 취급하기 일쑤여서 식물 키우기 망설이시나요? \n어떤 식물들은 세심한 관리 없이도 잘 자란답니다. \n다육식물이나 금전수는 적당한 빛이 들어오는 곳에서 키운다면 당신이 멀리 여행을 떠난 동안에도 잘 지낼 수 있어요.\n식물을 돌볼 시간이 좀 더 있거나, 반려식물 키우기를 즐기는 분이라면 세심한 관심이 필요한 공중식물이나 난초류, 고사리류 식물 키우기에 도전해보는 것도 재미있을 거예요. \n이런 섬세한 식물에게는 매일 물을 뿌려주면서 적절한 습도를 유지해주어야 하거든요.\n\n', 100, 150, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(23, '기타', '기타-화분_대', 11900, '판매중', '화분 대 사이즈 \n\n화분 고르는 꿀팁!\n\n1. 우리 집 창문은 남향? 동향?\n식물을 키울 내 공간에 빛이 얼마나 들어오나요? \n집을 고를 때 빛의 방향을 따지듯이, 식물이 살 공간을 고를 때도 빛의 방향을 고려해주어야 한답니다. \n남쪽을 보는 창문으로는 밝은 빛이 들어오고, 동쪽이나 서쪽으로 난 창문은 중간 정도의 빛, 북쪽으로는 약한 빛이 들어오겠지요? \n대부분의 실내식물은 창문을 통해 들어오는 밝은 빛을 좋아하지만, \n강한 햇빛을 직접 받으면 잎이 탈 수도 있으니 햇살이 너무 셀 때는 얇은 커튼을 쳐서 빛을 간접적으로 받을 수 있게 도와주세요.\n우리 집이 어두운 편이라면 스투키, 크로톤, 안스리움 등과 같이 반음지에서 잘 자라는 식물이나, \n스킨답서스, 금전수, 행운목 등과 같이 음지에서도 잘 자라는 아이를 들여보세요. \n햇빛은 식물의 밥이기 때문에, 부족하면 배고프고, 과하면 배탈이 난답니다. \n반려식물이 살아갈 공간의 밝기를 살피고, 그 밝기에서 잘 자라는 반려식물을 들여주세요.\n\n2. 내 생활 습관과 맞는 식물이 있답니다.\n바쁜 스케줄로 물 주기를 자주 깜빡한다거나, 곁에 있어도 없는 존재로 취급하기 일쑤여서 식물 키우기 망설이시나요? \n어떤 식물들은 세심한 관리 없이도 잘 자란답니다. \n다육식물이나 금전수는 적당한 빛이 들어오는 곳에서 키운다면 당신이 멀리 여행을 떠난 동안에도 잘 지낼 수 있어요.\n식물을 돌볼 시간이 좀 더 있거나, 반려식물 키우기를 즐기는 분이라면 세심한 관심이 필요한 공중식물이나 난초류, 고사리류 식물 키우기에 도전해보는 것도 재미있을 거예요. \n이런 섬세한 식물에게는 매일 물을 뿌려주면서 적절한 습도를 유지해주어야 하거든요.\n\n', 100, 35, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(24, '계절꽃', '계절꽃-해바라기', 4900, '판매중', '여름 제철꽃 해바라기 1송이 당 가격입니다.\n\n1송이 : 첫 눈에 반했습니다. \n2송이 : 이 세계에는 당신과 저 뿐입니다 \n3송이 : 사랑합니다. 고백. 당신과 나, 우리의 사랑\n4송이 : 죽을때까지 이 마음 변치 않습니다\n5송이 : 당신을 만난 것에 진심의 기쁨을\n6송이 : 당신에게 푹 빠졌습니다. 서로 존중하고, 사랑하며, 이해합시다\n7송이 : 은밀한 사랑\n8송이 : 당신의 배려, 마음씀씀이에 감사를\n9송이 : 언제나 당신을 사랑하고 있습니다\n10송이 : 머리부터 발끝까지 완벽한 당신\n11송이 : 누구(10)보다도 당신(1)을 사랑합니다\n12송이 : 저와 사귀어주시겠습니까?\n13송이 : 영원한 우정\n21송이 : 당신에게 제 모든 것을\n24송이 : 하루종일 당신만이 떠오릅니다\n50송이 : 당신을 향한 영원한 사랑\n99송이 : 영원한 사랑. 언제나 좋아했습니다\n100송이 : 100%의 사랑\n101송이 : 더할나위 없이 사랑합니다\n108송이 : 결혼해주시겠습니까?\n144송이 : 몇 번을 다시 태어나도 당신을 사랑합니다\n365송이 : 매일같이 사랑스러운 당신\n999송이 : 어느 생이건 당신을 사랑합니다\n\n세계적으로 이름에 \'태양\'에 해당되는 말이 들어가는 꽃이라 많은 사람들이 하루 종일 해를 바라본다고 알고 있으나 이는 잘못된 상식이다. 상술한 다른 언어들에서의 이름뿐만 아니라 학명도 Helianthus니 전 세계적인 오해인 듯. 봉오리를 피우는 영양소 합성을 위해 봉오리가 피기 전까지만 해를 향하게 방향을 바꾸는 것이며, 꽃이 핀 후엔 그냥 그대로 있는다. 꽃에는 광합성 기능이 없으니 당연히 주광성도 없다. 식물에서 광합성을 담당하는 엽록소는 모두 녹색을 띤다.\n\n미신과 속담에서는 복을 불러오거나 재물을 불러온다는 속설이 있다. 그래서 사람들은 해바라기가 그려진 그림이나 액자를 집 안에 걸어두기도 한다.', 100, 57, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(25, '계절꽃', '계절꽃-튤립', 2700, '품절', '봄 제철꽃 튤립 1송이 당 가격입니다.\n\n1송이 : 첫 눈에 반했습니다. \n2송이 : 이 세계에는 당신과 저 뿐입니다 \n3송이 : 사랑합니다. 고백. 당신과 나, 우리의 사랑\n4송이 : 죽을때까지 이 마음 변치 않습니다\n5송이 : 당신을 만난 것에 진심의 기쁨을\n6송이 : 당신에게 푹 빠졌습니다. 서로 존중하고, 사랑하며, 이해합시다\n7송이 : 은밀한 사랑\n8송이 : 당신의 배려, 마음씀씀이에 감사를\n9송이 : 언제나 당신을 사랑하고 있습니다\n10송이 : 머리부터 발끝까지 완벽한 당신\n11송이 : 누구(10)보다도 당신(1)을 사랑합니다\n12송이 : 저와 사귀어주시겠습니까?\n13송이 : 영원한 우정\n21송이 : 당신에게 제 모든 것을\n24송이 : 하루종일 당신만이 떠오릅니다\n50송이 : 당신을 향한 영원한 사랑\n99송이 : 영원한 사랑. 언제나 좋아했습니다\n100송이 : 100%의 사랑\n101송이 : 더할나위 없이 사랑합니다\n108송이 : 결혼해주시겠습니까?\n144송이 : 몇 번을 다시 태어나도 당신을 사랑합니다\n365송이 : 매일같이 사랑스러운 당신\n999송이 : 어느 생이건 당신을 사랑합니다\n\n세계 화훼시장에서 큰 몫을 차지하고 있는 꽃으로, 생산량이 많아 가격도 싸고 기르기도 쉬워 원예 입문자에게 추천하기도 한다. 하지만 기르기 쉬운 것과 꽃 피우기 쉬운 것은 별개. 원종튤립(야생종)은 그냥 노지에 묻어놓기만 하면 매년 튤립을 보여주지만, 원예종으로 개량된 튤립(우리가 흔히 아는 튤립)은 한국의 덥고 습한 여름을 견디지 못하고 녹거나 썩어 사라지는 경우가 대부분. 최대 수출국인 네덜란드는 서늘한 기후 덕분에 튤립 구근이 성장하기에 좋다. 한국은 보통 한 구근으로 딱 한 번만 꽃을 보고 버리는 것이 일반적.', 0, 77, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(26, '계절꽃', '계절꽃-백합', 6900, '판매중', '여름 제철꽃 백합 1송이 당 가격입니다.\n\n1송이 : 첫 눈에 반했습니다. \n2송이 : 이 세계에는 당신과 저 뿐입니다 \n3송이 : 사랑합니다. 고백. 당신과 나, 우리의 사랑\n4송이 : 죽을때까지 이 마음 변치 않습니다\n5송이 : 당신을 만난 것에 진심의 기쁨을\n6송이 : 당신에게 푹 빠졌습니다. 서로 존중하고, 사랑하며, 이해합시다\n7송이 : 은밀한 사랑\n8송이 : 당신의 배려, 마음씀씀이에 감사를\n9송이 : 언제나 당신을 사랑하고 있습니다\n10송이 : 머리부터 발끝까지 완벽한 당신\n11송이 : 누구(10)보다도 당신(1)을 사랑합니다\n12송이 : 저와 사귀어주시겠습니까?\n13송이 : 영원한 우정\n21송이 : 당신에게 제 모든 것을\n24송이 : 하루종일 당신만이 떠오릅니다\n50송이 : 당신을 향한 영원한 사랑\n99송이 : 영원한 사랑. 언제나 좋아했습니다\n100송이 : 100%의 사랑\n101송이 : 더할나위 없이 사랑합니다\n108송이 : 결혼해주시겠습니까?\n144송이 : 몇 번을 다시 태어나도 당신을 사랑합니다\n365송이 : 매일같이 사랑스러운 당신\n999송이 : 어느 생이건 당신을 사랑합니다\n\n한국에는 10여 종 이상의 자생 나리가 있으며 역시 대부분이 원예종으로서도 큰 손색이 없다. 원추리는 나리와 비슷하지만, 이후에 바뀐 분류체계에서는 백합목이 아닌 아스파라거스목으로 목부터 다르다. 개나리도 나리와 꽃 모양이 비슷한데, 나리보다 못하거나 개처럼 흔하다고 해서 개- 접두사가 붙어 개나리가 되었지만 외떡잎식물강이 아닌 쌍떡잎식물강으로 강부터 다르다. ', 100, 72, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(27, '계절꽃', '계절꽃-천일홍', 5900, '품절', '가을 제철꽃 천일홍 1송이 당 가격입니다.\n\n1송이 : 첫 눈에 반했습니다. \n2송이 : 이 세계에는 당신과 저 뿐입니다 \n3송이 : 사랑합니다. 고백. 당신과 나, 우리의 사랑\n4송이 : 죽을때까지 이 마음 변치 않습니다\n5송이 : 당신을 만난 것에 진심의 기쁨을\n6송이 : 당신에게 푹 빠졌습니다. 서로 존중하고, 사랑하며, 이해합시다\n7송이 : 은밀한 사랑\n8송이 : 당신의 배려, 마음씀씀이에 감사를\n9송이 : 언제나 당신을 사랑하고 있습니다\n10송이 : 머리부터 발끝까지 완벽한 당신\n11송이 : 누구(10)보다도 당신(1)을 사랑합니다\n12송이 : 저와 사귀어주시겠습니까?\n13송이 : 영원한 우정\n21송이 : 당신에게 제 모든 것을\n24송이 : 하루종일 당신만이 떠오릅니다\n50송이 : 당신을 향한 영원한 사랑\n99송이 : 영원한 사랑. 언제나 좋아했습니다\n100송이 : 100%의 사랑\n101송이 : 더할나위 없이 사랑합니다\n108송이 : 결혼해주시겠습니까?\n144송이 : 몇 번을 다시 태어나도 당신을 사랑합니다\n365송이 : 매일같이 사랑스러운 당신\n999송이 : 어느 생이건 당신을 사랑합니다\n\n중남미 원산의 한해살이풀로 높이 40cm 정도이다. 줄기는 곧추서며 가지가 잘 갈라지고 전체에 털이 있다. 잎은 마주나기하며, 길이 3-10cm인 긴 타원형이나 거꿀달걀꼴 긴 타원형으로 가장자리가 밋밋하다. 꽃은 7-10월에 피며 붉은색이지만 연한 붉은색이나 흰색 등이 있다. 꽃은 꽃잎이 없고 대신 긴 줄기에 붉은색, 분홍색, 오렌지색, 흰색의 포(苞)가 달린다. 가는 줄기 끝에 공 모양의 꽃이 한 개씩 핀다. 5개의 수술과 1개의 암술이 있는데, 수술은 합쳐져서 통처럼 되고 암술대는 끝이 2개로 갈라진다. 열매에는 바둑알 같은 종자가 1개씩 들어있다.', 0, 57, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(28, '계절꽃', '계절꽃-국화', 5900, '품절', '겨울 제철꽃 국화 1송이 당 가격입니다.\n\n1송이 : 첫 눈에 반했습니다. \n2송이 : 이 세계에는 당신과 저 뿐입니다 \n3송이 : 사랑합니다. 고백. 당신과 나, 우리의 사랑\n4송이 : 죽을때까지 이 마음 변치 않습니다\n5송이 : 당신을 만난 것에 진심의 기쁨을\n6송이 : 당신에게 푹 빠졌습니다. 서로 존중하고, 사랑하며, 이해합시다\n7송이 : 은밀한 사랑\n8송이 : 당신의 배려, 마음씀씀이에 감사를\n9송이 : 언제나 당신을 사랑하고 있습니다\n10송이 : 머리부터 발끝까지 완벽한 당신\n11송이 : 누구(10)보다도 당신(1)을 사랑합니다\n12송이 : 저와 사귀어주시겠습니까?\n13송이 : 영원한 우정\n21송이 : 당신에게 제 모든 것을\n24송이 : 하루종일 당신만이 떠오릅니다\n50송이 : 당신을 향한 영원한 사랑\n99송이 : 영원한 사랑. 언제나 좋아했습니다\n100송이 : 100%의 사랑\n101송이 : 더할나위 없이 사랑합니다\n108송이 : 결혼해주시겠습니까?\n144송이 : 몇 번을 다시 태어나도 당신을 사랑합니다\n365송이 : 매일같이 사랑스러운 당신\n999송이 : 어느 생이건 당신을 사랑합니다\n\n세계 각국에서 장례식 때 백장미와 더불어 흰 국화를 바치는 풍습이 전한다. 이 풍습은 4만 년 전 구석기 시대 고인돌이나 5천 년 전 메소포타미아의 기록에서도 찾아볼 수 있다. 한국에는 개화기 이후에 서구 그리스도교 문화가 들어옴에 따라 복식 등이 간소화되고, 영전에 꽃을 바치는 일이 생겼는데 거기에 어울리는 흰 꽃[2]이 국화밖에 없어 국화를 바쳤다고 한다. 세계적으로는 흰 장미를 장례에 가장 으뜸 꽃으로 여기지만, 국내를 포함한 동양에서는 흰 장미를 구하기 힘들어서 흰 국화로 헌화를 하는 독특한 문화가 있다.\n\n', 0, 57, '2023-01-01 00:00:00', '2023-01-01 00:00:00');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;

-- 테이블 shoppingmall.product_img 구조 내보내기
CREATE TABLE IF NOT EXISTS `product_img` (
  `product_no` int(11) NOT NULL,
  `product_ori_filename` text NOT NULL,
  `product_save_filename` text NOT NULL,
  `product_filetype` varchar(50) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`product_no`),
  CONSTRAINT `FK_product_img_product` FOREIGN KEY (`product_no`) REFERENCES `product` (`product_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.product_img:~28 rows (대략적) 내보내기
/*!40000 ALTER TABLE `product_img` DISABLE KEYS */;
INSERT INTO `product_img` (`product_no`, `product_ori_filename`, `product_save_filename`, `product_filetype`, `createdate`, `updatedate`) VALUES
	(1, 'bouquet_rose', 'bouquet_rose', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(2, 'bouquet_daisy', 'bouquet_daisy', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(3, 'bouquet_daisy', 'bouquet_daisy', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(4, 'bouquet_zakyak', 'bouquet_zakyak', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(5, 'bouquet_carnation', 'bouquet_carnation', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(6, 'pot_dongbaek', 'pot_dongbaek', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(7, 'pot_suninjang', 'pot_suninjang', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(8, 'pot_fukusia', 'pot_fukusia', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(9, 'pot_sugook', 'pot_sugook', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(10, 'pot_chulzzook', 'pot_chulzzook', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(11, 'hwahwan_east', 'hwahwan_east', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(12, 'hwahwan_west', 'hwahwan_west', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(13, 'hwahwan_huge', 'hwahwan_huge', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(14, 'hwahwan_mid', 'hwahwan_mid', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(15, 'hwahwan_small', 'hwahwan_small', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(16, 'geunjo_huge', 'geunjo_huge', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(17, 'geunjo_mid', 'geunjo_mid', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(18, 'geunjo_small', 'geunjo_small', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(19, 'etc_human', 'etc_human', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(20, 'etc_moneybouquet', 'etc_moneybouquet', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(21, 'etc_hwaboon_small', 'etc_hwaboon_small', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(22, 'etc_hwaboon_mid', 'etc_hwaboon_mid', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(23, 'etc_hwaboon_big', 'etc_hwaboon_big', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(24, 'season_sunflower', 'season_sunflower', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(25, 'season_tulip', 'season_tulip', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(26, 'season_lily', 'season_lily', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(27, 'season_chunilhong', 'season_chunilhong', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
	(28, 'season_gughwa', 'season_gughwa', 'jpg', '2023-01-01 00:00:00', '2023-01-01 00:00:00');
/*!40000 ALTER TABLE `product_img` ENABLE KEYS */;

-- 테이블 shoppingmall.pw_history 구조 내보내기
CREATE TABLE IF NOT EXISTS `pw_history` (
  `pw_no` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(50) NOT NULL,
  `pw` varchar(50) NOT NULL,
  `createdate` datetime NOT NULL,
  PRIMARY KEY (`pw_no`),
  KEY `FK_pw_history_id_list` (`id`),
  CONSTRAINT `FK_pw_history_id_list` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.pw_history:~14 rows (대략적) 내보내기
/*!40000 ALTER TABLE `pw_history` DISABLE KEYS */;
INSERT INTO `pw_history` (`pw_no`, `id`, `pw`, `createdate`) VALUES
	(4, 'user2', '*B12289EEF8752AD620294A64A37CD586223AB454', '2023-03-01 00:00:00'),
	(5, 'user2', '*A4B6157319038724E3560894F7F932C8886EBFCF', '2023-03-02 00:00:00'),
	(6, 'user3', '*B12289EEF8752AD620294A64A37CD586223AB454', '2023-04-01 00:00:00'),
	(7, 'user3', '*A4B6157319038724E3560894F7F932C8886EBFCF', '2023-04-02 00:00:00'),
	(8, 'user4', '*B12289EEF8752AD620294A64A37CD586223AB454', '2023-05-01 00:00:00'),
	(9, 'user4', '*A4B6157319038724E3560894F7F932C8886EBFCF', '2023-05-02 00:00:00'),
	(10, 'user5', '*A4B6157319038724E3560894F7F932C8886EBFCF', '2022-07-01 00:00:00'),
	(11, 'user6', '*A4B6157319038724E3560894F7F932C8886EBFCF', '2022-08-01 00:00:00'),
	(12, 'user7', '*A4B6157319038724E3560894F7F932C8886EBFCF', '2022-10-01 00:00:00'),
	(13, 'user8', '*A4B6157319038724E3560894F7F932C8886EBFCF', '2022-09-01 00:00:00'),
	(14, 'user9', '*A4B6157319038724E3560894F7F932C8886EBFCF', '2022-12-01 00:00:00'),
	(17, 'user1', '*97E7471D816A37E38510728AEA47440F9C6E2585', '2023-06-23 11:33:04'),
	(19, 'user1', '*00A51F3F48415C7D4E8908980D443C29C69B60C9', '2023-06-23 17:37:42'),
	(23, 'user1', '*A4B6157319038724E3560894F7F932C8886EBFCF', '2023-06-24 16:42:18');
/*!40000 ALTER TABLE `pw_history` ENABLE KEYS */;

-- 테이블 shoppingmall.question 구조 내보내기
CREATE TABLE IF NOT EXISTS `question` (
  `q_no` int(11) NOT NULL AUTO_INCREMENT,
  `product_no` int(11) NOT NULL,
  `id` varchar(50) NOT NULL,
  `q_category` enum('상품','결제','배송','기타') NOT NULL,
  `q_answer` enum('Y','N') NOT NULL DEFAULT 'N',
  `q_title` varchar(50) NOT NULL,
  `q_content` text NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`q_no`),
  KEY `FK_question_product` (`product_no`),
  KEY `FK_question_customer` (`id`),
  CONSTRAINT `FK_question_customer` FOREIGN KEY (`id`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_question_product` FOREIGN KEY (`product_no`) REFERENCES `product` (`product_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.question:~8 rows (대략적) 내보내기
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` (`q_no`, `product_no`, `id`, `q_category`, `q_answer`, `q_title`, `q_content`, `createdate`, `updatedate`) VALUES
	(1, 5, 'user1', '상품', 'N', '프리저브드 꽃 종류', '무궁화도 만들수있나요?', '2023-05-02 00:00:00', '2023-05-02 00:00:00'),
	(2, 13, 'user1', '배송', 'Y', '화환 배송지', '해외배송도 되나요?', '2023-05-02 00:00:00', '2023-05-02 00:00:00'),
	(3, 19, 'user2', '결제', 'Y', '후불 가능 여부', '후불결제도 가능한가요?', '2023-05-02 00:00:00', '2023-05-02 00:00:00'),
	(4, 20, 'user2', '상품', 'N', '지폐선택', '5만원권으로만 가능한가요?', '2023-05-02 00:00:00', '2023-05-02 00:00:00'),
	(5, 24, 'user3', '상품', 'Y', '튤립끝났나요?', '튤립사고싶은데 판매끝났나요?', '2023-05-02 00:00:00', '2023-05-02 00:00:00'),
	(6, 1, 'user3', '상품', 'N', '이쁘게 해주세요', '안시든걸로 예쁘게 해주세요~', '2023-05-02 00:00:00', '2023-06-24 19:04:16'),
	(7, 24, 'user4', '상품', 'Y', '도구는 안파나요?', '꽃꽃이 도구는 안파나요?', '2023-05-02 00:00:00', '2023-06-23 17:48:33'),
	(8, 5, 'user4', '상품', 'Y', '프리저브드 화분', '프리저브드 다발말고 화분은 안파나요?', '2023-05-02 00:00:00', '2023-05-02 00:00:00');
/*!40000 ALTER TABLE `question` ENABLE KEYS */;

-- 테이블 shoppingmall.review 구조 내보내기
CREATE TABLE IF NOT EXISTS `review` (
  `order_no` int(11) NOT NULL,
  `review_title` varchar(50) NOT NULL,
  `review_content` text NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`order_no`),
  CONSTRAINT `FK_review_order` FOREIGN KEY (`order_no`) REFERENCES `orders` (`order_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.review:~1 rows (대략적) 내보내기
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` (`order_no`, `review_title`, `review_content`, `createdate`, `updatedate`) VALUES
	(17, '이뻐요', '좋아요', '2023-06-27 17:41:40', '2023-06-27 17:41:40');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;

-- 테이블 shoppingmall.review_img 구조 내보내기
CREATE TABLE IF NOT EXISTS `review_img` (
  `order_no` int(11) NOT NULL,
  `review_ori_filename` text NOT NULL,
  `review_save_filename` text NOT NULL,
  `review_filetype` varchar(50) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`order_no`),
  CONSTRAINT `FK_review_img_review` FOREIGN KEY (`order_no`) REFERENCES `review` (`order_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shoppingmall.review_img:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `review_img` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_img` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
