drop database web;
create database web;
use web;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for banners
-- ----------------------------
DROP TABLE IF EXISTS `banners`;
CREATE TABLE `banners`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `position` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `active` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of banners
-- ----------------------------
INSERT INTO `banners` VALUES (1, 'assets/images/login/1.webp', 'http://localhost:8080/demo/list-product?gender=women', 'Giày nữ thanh lịch', 'HOME_WOMEN_RIGHT', 1, '2025-12-11 23:45:53');
INSERT INTO `banners` VALUES (2, 'https://bizweb.dktcdn.net/100/347/092/themes/708609/assets/banner_product_nangdong.jpg?1767921323274', 'http://localhost:8080/demo/list-product?gender=men', 'giày nam năng động', 'HOME_MEN', 1, '2025-12-11 23:45:53');
INSERT INTO `banners` VALUES (3, 'https://bizweb.dktcdn.net/100/347/092/themes/708609/assets/banner_project_1.jpg?1767921323274', '/list-product?categoryId=4', 'Sneaker lifestyle', 'HOME_MAIN', 1, '2025-12-11 23:45:53');
INSERT INTO `banners` VALUES (4, 'https://bizweb.dktcdn.net/100/347/092/themes/708609/assets/banner_product_noibat.jpg?1767921323274', 'http://localhost:8080/demo/home', 'Banner-bottom', 'HOME_WOMEN_BOTTOM', 1, '2025-12-11 23:45:53');
INSERT INTO `banners` VALUES (5, 'https://bizweb.dktcdn.net/100/347/092/themes/708609/assets/banner.jpg?1767921323274', 'http://localhost:8080/demo/home', 'giày nhật chính hãng', 'HOME_TOP', 1, '2025-12-11 23:45:53');

-- ----------------------------
-- Table structure for brands
-- ----------------------------
DROP TABLE IF EXISTS `brands`;
CREATE TABLE `brands`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `slug` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `logo_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `active` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of brands
-- ----------------------------
INSERT INTO `brands` VALUES (1, 'Nike', 'nike', '/images/brands/nike.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (2, 'Adidas', 'adidas', '/images/brands/adidas.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (3, 'Puma', 'puma', '/images/brands/puma.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (4, 'New Balance', 'new-balance', '/images/brands/new_balance.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (5, 'Converse', 'converse', '/images/brands/converse.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (6, 'Vans', 'vans', '/images/brands/vans.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (7, 'Asics', 'asics', '/images/brands/asics.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (8, 'Reebok', 'reebok', '/images/brands/reebok.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (9, 'Under Armour', 'under-armour', '/images/brands/under_armour.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (10, 'Mizuno', 'mizuno', '/images/brands/mizuno.png', 1, '2025-12-11 23:45:23', '2026-01-15 16:28:09');

-- ----------------------------
-- Table structure for cart_items
-- ----------------------------
DROP TABLE IF EXISTS `cart_items`;
CREATE TABLE `cart_items`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int NOT NULL,
  `product_id` int NOT NULL,
  `variant_id` int NULL DEFAULT NULL,
  `quantity` int NOT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_cart_items_cart`(`cart_id` ASC) USING BTREE,
  INDEX `fk_cart_items_product`(`product_id` ASC) USING BTREE,
  INDEX `fk_cart_items_variant`(`variant_id` ASC) USING BTREE,
  CONSTRAINT `fk_cart_items_cart` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_cart_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_cart_items_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of cart_items
-- ----------------------------
INSERT INTO `cart_items` VALUES (1, 1, 1, NULL, 2, '2025-12-15 23:36:34');
INSERT INTO `cart_items` VALUES (2, 1, 3, NULL, 1, '2025-12-15 23:36:34');
INSERT INTO `cart_items` VALUES (3, 1, 7, NULL, 1, '2025-12-15 23:36:34');
INSERT INTO `cart_items` VALUES (4, 2, 2, NULL, 1, '2025-12-15 23:36:34');
INSERT INTO `cart_items` VALUES (5, 2, 8, NULL, 2, '2025-12-15 23:36:34');

-- ----------------------------
-- Table structure for carts
-- ----------------------------
DROP TABLE IF EXISTS `carts`;
CREATE TABLE `carts`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `active_key` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_carts_active_key`(`active_key` ASC) USING BTREE,
  INDEX `idx_carts_user_active`(`user_id` ASC, `is_active` ASC) USING BTREE,
  CONSTRAINT `fk_carts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carts
-- ----------------------------
INSERT INTO `carts` VALUES (1, 3, '2025-12-15 23:36:21', '2026-01-01 23:31:47', 'ORDERED', 0, NULL);
INSERT INTO `carts` VALUES (2, 4, '2025-12-15 23:36:21', '2026-01-01 23:31:47', 'ORDERED', 0, NULL);
INSERT INTO `carts` VALUES (3, 3, '2025-12-15 23:36:34', '2026-01-01 23:31:53', 'ACTIVE', 1, 3);
INSERT INTO `carts` VALUES (4, 4, '2025-12-15 23:36:34', '2026-01-01 23:31:53', 'ACTIVE', 1, 4);
INSERT INTO `carts` VALUES (5, 1, '2025-12-31 01:27:40', '2026-01-13 21:14:12', 'ACTIVE', 1, 1);
INSERT INTO `carts` VALUES (6, 5, '2026-01-01 23:38:32', '2026-01-01 23:38:32', 'ACTIVE', 1, 5);
INSERT INTO `carts` VALUES (8, 7, '2026-01-11 00:39:15', '2026-01-11 00:40:02', 'ORDERED', 0, NULL);
INSERT INTO `carts` VALUES (9, 7, '2026-01-11 21:26:39', '2026-01-12 20:05:37', 'ORDERED', 0, NULL);
INSERT INTO `carts` VALUES (10, 7, '2026-01-12 20:07:49', '2026-01-12 23:15:45', 'ORDERED', 0, NULL);
INSERT INTO `carts` VALUES (11, 7, '2026-01-12 23:16:48', '2026-01-12 23:16:51', 'ORDERED', 0, NULL);
INSERT INTO `carts` VALUES (12, 7, '2026-01-12 23:17:04', '2026-01-12 23:59:21', 'ORDERED', 0, NULL);
INSERT INTO `carts` VALUES (13, 7, '2026-01-12 23:59:45', '2026-01-16 11:11:38', 'ORDERED', 0, NULL);
INSERT INTO `carts` VALUES (14, 7, '2026-01-16 11:11:38', '2026-01-16 11:11:38', 'ACTIVE', 1, 7);

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_featured` tinyint(1) NULL DEFAULT 0,
  `active` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `slug` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `parent_id` int NULL DEFAULT NULL,
  `display_order` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES (1, 'Giày chạy bộ', '/images/categories/running.jpg', '/category/running', 1, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33', NULL, NULL, 0);
INSERT INTO `categories` VALUES (2, 'Giày bóng đá', '/images/categories/football.jpg', '/category/football', 1, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33', NULL, NULL, 0);
INSERT INTO `categories` VALUES (3, 'Giày bóng rổ', '/images/categories/basket.jpg', '/category/basket', 1, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33', NULL, NULL, 0);
INSERT INTO `categories` VALUES (4, 'Sneaker lifestyle', '/images/categories/lifestyle.jpg', '/category/lifestyle', 1, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33', NULL, NULL, 0);
INSERT INTO `categories` VALUES (5, 'Dép & Sandal', '/images/categories/sandal.jpg', '/category/sandal', 0, 1, '2025-12-11 23:45:33', '2026-01-15 09:43:24', 'dep-sandal', NULL, 0);
INSERT INTO `categories` VALUES (6, 'Giày tennis', '/images/categories/tennis.jpg', '/category/tennis', 0, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33', NULL, NULL, 0);
INSERT INTO `categories` VALUES (7, 'Giày training / gym', '/images/categories/training.jpg', '/category/training', 0, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33', NULL, NULL, 0);
INSERT INTO `categories` VALUES (8, 'Phụ kiện chăm sóc giày', '/images/categories/access.jpg', '/category/access', 0, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33', NULL, NULL, 0);

-- ----------------------------
-- Table structure for contact_messages
-- ----------------------------
DROP TABLE IF EXISTS `contact_messages`;
CREATE TABLE `contact_messages`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'NEW',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_contact_messages_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_contact_messages_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of contact_messages
-- ----------------------------
INSERT INTO `contact_messages` VALUES (1, 3, 'Nguyễn Văn A', 'user1@example.com', '0909000001', 'Shop cho em hỏi size giày chạy Nike Pegasus 40.', 'NEW', '2025-12-11 23:45:59');
INSERT INTO `contact_messages` VALUES (2, NULL, 'Khách lạ', 'guest@example.com', '0909555666', 'Shop có ship về Bình Dương không ạ?', 'NEW', '2025-12-11 23:45:59');

-- ----------------------------
-- Table structure for news
-- ----------------------------
DROP TABLE IF EXISTS `news`;
CREATE TABLE `news`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `slug` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `summary` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `thumbnail_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `author` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `view_count` int NOT NULL DEFAULT 0,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PUBLISHED',
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_news_slug`(`slug` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of news
-- ----------------------------
INSERT INTO `news` VALUES (1, 'Cách chọn size giày (Nike/Adidas) chuẩn, tránh rộng – chật khi mua online', 'cach-chon-size-giay-nikeadidas-chuan-tranh-rong-chat-khi-mua-online', NULL, '<p>Mua giày online dễ “lệch size” vì mỗi hãng có form khác nhau. Dưới đây là cách đo nhanh và mẹo chọn size an toàn.</p>\r\n\r\n<h2>Bước 1: Đo chiều dài bàn chân</h2>\r\n<ul>\r\n  <li>Đặt chân lên tờ giấy, kẻ vạch gót và mũi dài nhất.</li>\r\n  <li>Đo khoảng cách (mm) và <b>cộng thêm 5–10mm</b> để có “khoảng thở”.</li>\r\n</ul>\r\n\r\n<h2>Bước 2: Hiểu form theo hãng</h2>\r\n<ul>\r\n  <li><b>Nike (nhiều mẫu form ôm):</b> chân bè nên cân nhắc +0.5 size.</li>\r\n  <li><b>Adidas (nhiều mẫu form thoải mái):</b> thường true-to-size, nhưng dòng knit dễ giãn.</li>\r\n</ul>\r\n\r\n<h2>Bước 3: Chọn theo nhu cầu</h2>\r\n<ul>\r\n  <li><b>Đi học/đi làm:</b> ưu tiên thoải mái, dư nhẹ 0.5cm.</li>\r\n  <li><b>Chạy bộ:</b> dư 0.5–1cm (chân trượt về trước khi chạy).</li>\r\n  <li><b>Bóng rổ/đổi hướng:</b> ôm gót chắc để giảm lật cổ chân.</li>\r\n</ul>\r\n\r\n<p><b>Mẹo:</b> Nếu bạn đang mang 1 đôi vừa chân, hãy đo <i>chiều dài insole</i> (lót giày) rồi đối chiếu.</p>', 'https://bizweb.dktcdn.net/thumb/large/100/347/092/articles/1043a024-100-sr-rt-glb.jpg?v=1756175361867', NULL, 9, 'PUBLISHED', 0, '2026-01-15 15:52:43', '2026-01-16 08:21:59');

-- ----------------------------
-- Table structure for news_categories
-- ----------------------------
DROP TABLE IF EXISTS `news_categories`;
CREATE TABLE `news_categories`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `slug` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_news_categories_slug`(`slug` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of news_categories
-- ----------------------------

-- ----------------------------
-- Table structure for news_category_map
-- ----------------------------
DROP TABLE IF EXISTS `news_category_map`;
CREATE TABLE `news_category_map`  (
  `news_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`news_id`, `category_id`) USING BTREE,
  INDEX `fk_ncm_cat`(`category_id` ASC) USING BTREE,
  CONSTRAINT `fk_ncm_cat` FOREIGN KEY (`category_id`) REFERENCES `news_categories` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ncm_news` FOREIGN KEY (`news_id`) REFERENCES `news` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of news_category_map
-- ----------------------------

-- ----------------------------
-- Table structure for order_items
-- ----------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `variant_id` int NULL DEFAULT NULL,
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `size` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `quantity` int NOT NULL,
  `unit_price` double NOT NULL,
  `subtotal` double NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_order_items_order`(`order_id` ASC) USING BTREE,
  INDEX `fk_order_items_product`(`product_id` ASC) USING BTREE,
  INDEX `fk_order_items_variant`(`variant_id` ASC) USING BTREE,
  CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_items_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order_items
-- ----------------------------
INSERT INTO `order_items` VALUES (1, 1, 1, NULL, NULL, NULL, 1, 2990000, 2990000);
INSERT INTO `order_items` VALUES (2, 1, 2, NULL, NULL, NULL, 2, 3590000, 7180000);
INSERT INTO `order_items` VALUES (3, 2, 7, NULL, NULL, NULL, 2, 1590000, 3180000);
INSERT INTO `order_items` VALUES (4, 3, 1, 1, 'Black', '40', 2, 2990000, 5980000);
INSERT INTO `order_items` VALUES (5, 4, 1, 1, 'Black', '40', 1, 2990000, 2990000);
INSERT INTO `order_items` VALUES (6, 5, 1, 1, 'Black', '40', 7, 2990000, 20930000);
INSERT INTO `order_items` VALUES (7, 6, 1, 2, 'Black', '41', 1, 2990000, 2990000);
INSERT INTO `order_items` VALUES (8, 7, 1, 2, 'Black', '41', 1, 2990000, 2990000);
INSERT INTO `order_items` VALUES (9, 8, 4, 238, 'Black', '40', 1, 4290000, 4290000);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `address_id` int NOT NULL,
  `total_amount` double NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_orders_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_orders_address`(`address_id` ASC) USING BTREE,
  CONSTRAINT `fk_orders_address` FOREIGN KEY (`address_id`) REFERENCES `user_addresses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 3, 1, 10170000, 'PENDING', '2025-12-11 23:45:59', '2025-12-11 23:45:59');
INSERT INTO `orders` VALUES (2, 4, 2, 3190000, 'PAID', '2025-12-11 23:45:59', '2025-12-11 23:45:59');
INSERT INTO `orders` VALUES (3, 7, 3, 5980000, 'SHIPPING', '2026-01-11 00:40:02', '2026-01-13 23:54:48');
INSERT INTO `orders` VALUES (4, 7, 5, 2990000, 'PENDING', '2026-01-12 20:05:37', '2026-01-12 20:05:37');
INSERT INTO `orders` VALUES (5, 7, 6, 20930000, 'CANCEL', '2026-01-12 23:15:45', '2026-01-13 10:56:25');
INSERT INTO `orders` VALUES (6, 7, 7, 2990000, 'CANCEL', '2026-01-12 23:16:51', '2026-01-13 10:56:21');
INSERT INTO `orders` VALUES (7, 7, 8, 2990000, 'PAID', '2026-01-12 23:59:21', '2026-01-15 19:35:59');
INSERT INTO `orders` VALUES (8, 7, 9, 4290000, 'PENDING', '2026-01-16 11:11:38', '2026-01-16 11:11:38');

-- ----------------------------
-- Table structure for password_reset_tokens
-- ----------------------------
DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token_hash` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime NULL DEFAULT NULL,
  `request_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_token_hash`(`token_hash`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of password_reset_tokens
-- ----------------------------
INSERT INTO `password_reset_tokens` VALUES (1, 7, '313cd1949f9751b488cc5689225970bf483b533edb39eb31043e2a60bf89c48d', '2026-01-03 00:43:27', NULL, '0:0:0:0:0:0:0:1', '2026-01-03 00:23:27');
INSERT INTO `password_reset_tokens` VALUES (2, 7, 'd42e951d1a6f2437e02c7eeca6c4920cb91ceed601b7e19e199de61bf72a981f', '2026-01-03 00:43:59', NULL, '0:0:0:0:0:0:0:1', '2026-01-03 00:23:59');
INSERT INTO `password_reset_tokens` VALUES (3, 7, '5f448eb563ee9382fe7b3aed8191e66d365f596c0190ac973486e118f7ce6099', '2026-01-04 01:14:21', NULL, '0:0:0:0:0:0:0:1', '2026-01-04 00:54:20');
INSERT INTO `password_reset_tokens` VALUES (4, 7, '6c870da3d71723c2948fc80bf216df5ca905424671ded76e4a498e28cefcd295', '2026-01-04 01:15:33', NULL, '0:0:0:0:0:0:0:1', '2026-01-04 00:55:32');
INSERT INTO `password_reset_tokens` VALUES (5, 7, '645e2ac767f9907506425b45bbd09360f5f3be5701d74e47e7bd2e0bd8039170', '2026-01-04 15:20:10', NULL, '0:0:0:0:0:0:0:1', '2026-01-04 14:50:09');
INSERT INTO `password_reset_tokens` VALUES (6, 7, '39643268f035f5b742f25b3aeaf4d284ad082dabe21d79f084912a9d192fb7c3', '2026-01-04 16:31:34', NULL, '0:0:0:0:0:0:0:1', '2026-01-04 16:01:34');
INSERT INTO `password_reset_tokens` VALUES (7, 7, 'da175edb653af5ca9652a1a727a7ea8004de6fdb4b28fd5a7b5caed1b9e4c963', '2026-01-10 15:26:40', NULL, '0:0:0:0:0:0:0:1', '2026-01-10 14:56:40');
INSERT INTO `password_reset_tokens` VALUES (8, 7, '6274003fd2ad6a87f6a40be015e79c29eb552d6d09dd9e4424600134da40cfb6', '2026-01-10 15:55:51', NULL, '0:0:0:0:0:0:0:1', '2026-01-10 15:25:50');
INSERT INTO `password_reset_tokens` VALUES (9, 7, '1125b8fd11a7167b0dc6fbdbbaee44de92c21acb268ed90a85af494b966968c3', '2026-01-10 16:06:54', NULL, '0:0:0:0:0:0:0:1', '2026-01-10 15:36:53');
INSERT INTO `password_reset_tokens` VALUES (10, 7, '317ba6120f12a35fb98d292bc52bd071a69867754ecd6187a5d3f7a99848794c', '2026-01-10 16:11:32', NULL, '0:0:0:0:0:0:0:1', '2026-01-10 15:41:32');
INSERT INTO `password_reset_tokens` VALUES (11, 7, 'd2387eebe95a2b082d134ef02db38a28d3a9625b39c872a820760960ae4747d3', '2026-01-10 16:41:58', NULL, '0:0:0:0:0:0:0:1', '2026-01-10 16:11:57');
INSERT INTO `password_reset_tokens` VALUES (12, 7, '644ce88743491c2d0900dcc7c2be4f4d66c744d940ca722a1372b5375c34d4f7', '2026-01-16 07:50:12', NULL, '0:0:0:0:0:0:0:1', '2026-01-16 07:20:11');
INSERT INTO `password_reset_tokens` VALUES (13, 7, '7cb8a87068192a8020992dc484f35bb20c0764846f43190ae5c2659f8f3ebf96', '2026-01-16 08:47:52', NULL, '0:0:0:0:0:0:0:1', '2026-01-16 08:17:52');
INSERT INTO `password_reset_tokens` VALUES (14, 7, '8b80fef3397feffa42d43133578ba3626dd83425071d50cb67e6796f6a8667c8', '2026-01-16 08:48:29', '2026-01-16 08:18:59', '0:0:0:0:0:0:0:1', '2026-01-16 08:18:28');

-- ----------------------------
-- Table structure for policies
-- ----------------------------
DROP TABLE IF EXISTS `policies`;
CREATE TABLE `policies`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `slug` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `policy_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GENERAL',
  `display_order` int NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_policies_slug`(`slug` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of policies
-- ----------------------------

-- ----------------------------
-- Table structure for product_images
-- ----------------------------
DROP TABLE IF EXISTS `product_images`;
CREATE TABLE `product_images`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `alt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_main` tinyint(1) NULL DEFAULT 0,
  `sort_order` int NULL DEFAULT 0,
  `active` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_product_images_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_product_images_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 634 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_images
-- ----------------------------
INSERT INTO `product_images` VALUES (1, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-womens-road-cw7358-002-01-2c8c3f6e-99ff-4997-8c71-3732c331e62d-ee1f7fdf-e631-416d-a15b-2e573bce5876.jpg?v=1712173686633', 'Nike Air Zoom Pegasus 40 - main', 1, 0, 1, '2025-12-11 23:45:49', 'Black');
INSERT INTO `product_images` VALUES (2, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-0-air-zoom-pegasus-38-cw7356-002-02-d5408a9e-3404-47e5-8cea-7f15e5620299.png?v=1712173686633', 'Nike Air Zoom Pegasus 40 - side', 0, 1, 1, '2025-12-11 23:45:49', 'Black');
INSERT INTO `product_images` VALUES (3, 2, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/z-f36199-02-35ee1fca-baf2-4bfc-86c1-5c0abfbf920f.jpg', 'Adidas Ultraboost Light - main', 1, 0, 1, '2025-12-11 23:45:49', 'Black');
INSERT INTO `product_images` VALUES (4, 2, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-05-eb36cd2e-804a-4b42-9efb-93137a65315a.jpg?v=1712215775217', 'Adidas Ultraboost Light - side', 0, 1, 1, '2025-12-11 23:45:49', 'Black');
INSERT INTO `product_images` VALUES (5, 3, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-air-force-1-gs-white-black-ct3839-100-01.jpg', 'Nike Mercurial Vapor 15 Elite - main', 1, 0, 1, '2025-12-11 23:45:49', 'White');
INSERT INTO `product_images` VALUES (6, 4, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/response-super-djen-fx4833-01.jpg', 'Adidas Predator Accuracy. - main', 1, 0, 1, '2025-12-11 23:45:49', 'Black');
INSERT INTO `product_images` VALUES (7, 5, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-air-jordan-1-low-553558-147-1.jpg', NULL, 1, 0, 1, '2025-12-11 23:45:49', 'Green');
INSERT INTO `product_images` VALUES (8, 6, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-puma-pounce-lite-sneakers-310778-14-1.jpg', 'Puma All Pro Nitro - main', 1, 0, 1, '2025-12-11 23:45:49', 'Black');
INSERT INTO `product_images` VALUES (9, 7, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-vans-vn0007nvfgn-01.jpg', 'Converse Chuck Taylor All Star - main', 1, 1, 1, '2025-12-11 23:45:49', 'Green');
INSERT INTO `product_images` VALUES (10, 8, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-superstar-fv3290-01.jpg', 'Vans Old Skool Classic - main', 1, 0, 1, '2025-12-11 23:45:49', 'Black');
INSERT INTO `product_images` VALUES (11, 9, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-ultraboost-20-eg0713-01.jpg', 'Asics Gel-Nimbus 26 - main', 1, 0, 1, '2025-12-11 23:45:49', 'White');
INSERT INTO `product_images` VALUES (12, 10, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/11271239-r1.jpg', 'Mizuno Wave Rider 27 - main', 1, 0, 1, '2025-12-11 23:45:49', 'White');
INSERT INTO `product_images` VALUES (13, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-0-air-zoom-pegasus-38-cw7356-002-03-d1812fdf-1a78-474f-a96a-5b57402e8438.png?v=1712173686633', NULL, 1, 1, 1, '2025-12-25 13:33:10', 'Black');
INSERT INTO `product_images` VALUES (14, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-0-air-zoom-pegasus-38-cw7356-002-04-7952d5a4-9b1b-4151-b5d5-3cdf33d7f008.png?v=1712173686633', NULL, 0, 2, 1, '2025-12-25 13:33:10', 'Black');
INSERT INTO `product_images` VALUES (15, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-0-air-zoom-pegasus-38-cw7356-002-05-7b3f4ce2-e4fe-4536-b8c1-677756d04596.png?v=1712173686633', NULL, 0, 3, 1, '2025-12-25 13:33:10', 'Black');
INSERT INTO `product_images` VALUES (16, 1, '/images/products/p1_blue_1.jpg', NULL, 1, 1, 1, '2025-12-25 13:33:10', 'Blue');
INSERT INTO `product_images` VALUES (17, 1, '/images/products/p1_blue_2.jpg', NULL, 0, 2, 1, '2025-12-25 13:33:10', 'Blue');
INSERT INTO `product_images` VALUES (18, 1, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/663c3749-e7a7-4a6d-8111-32398a36b1cf.jpg', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');
INSERT INTO `product_images` VALUES (19, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-37-bq9647-101-02.jpg?v=1679400171817', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');
INSERT INTO `product_images` VALUES (20, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-37-bq9647-101-03.jpg?v=1679400173177', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');
INSERT INTO `product_images` VALUES (21, 1, 'https://bizweb.dktcdn.net/100/347/092/products/95124a7c-371b-4c90-b0f3-e015c87f9f7a.jpg?v=1679400174423', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');
INSERT INTO `product_images` VALUES (22, 1, 'https://bizweb.dktcdn.net/100/347/092/products/83b45721-c27f-4e1b-ba1f-9756977196af.jpg?v=1679400175697', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');
INSERT INTO `product_images` VALUES (23, 1, 'https://bizweb.dktcdn.net/100/347/092/products/ee5a12bd-ad4a-45db-bff5-5adc4d2d0dc7.jpg?v=1679400181080', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');
INSERT INTO `product_images` VALUES (24, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-womens-road-cw7358-002-07.jpg?v=1643141108047', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');
INSERT INTO `product_images` VALUES (29, 11, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-01-33f41548-eee8-493c-b25a-0656a44d0665.jpg', 'Nike Road Sprint JI0 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Pink');
INSERT INTO `product_images` VALUES (30, 11, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-02-c539f141-482a-4177-8c3f-c9d6b366c1f3.jpg?v=1712173564713', 'Nike Road Sprint JI0 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Pink');
INSERT INTO `product_images` VALUES (31, 11, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-03-2ddd5784-2c26-4fb5-8581-e42521cb9fe7.jpg?v=1712173564713', 'Nike Road Sprint JI0 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Pink');
INSERT INTO `product_images` VALUES (32, 12, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/new-balance-fuelcell-996v6-wch996u6-3.jpg', 'New Balance Road Sprint A3Z - main', 1, 0, 1, '2026-01-15 22:00:00', 'Blue');
INSERT INTO `product_images` VALUES (33, 12, 'https://bizweb.dktcdn.net/100/347/092/products/new-balance-fuelcell-996v6-wch996u6-2.jpg?v=1757310423263', 'New Balance Road Sprint A3Z - side', 0, 1, 1, '2026-01-15 22:00:00', 'Blue');
INSERT INTO `product_images` VALUES (34, 12, 'https://bizweb.dktcdn.net/100/347/092/products/new-balance-fuelcell-996v6-wch996u6-4.jpg?v=1755979209347', 'New Balance Road Sprint A3Z - top', 0, 2, 1, '2026-01-15 22:00:00', 'Blue');
INSERT INTO `product_images` VALUES (35, 13, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/mch796n4-nb-02-1.jpg', 'New Balance Road Sprint W5U - main', 1, 0, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (36, 13, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-2.jpg?v=1766432453887', 'New Balance Road Sprint W5U - side', 0, 1, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (37, 13, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-4.jpg?v=1766432456203', 'New Balance Road Sprint W5U - top', 0, 2, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (38, 14, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/8bf013bf-6b92-4d4b-844c-cb2495024bfa.jpg', 'Nike Cloud Pace G0F - main', 1, 0, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (39, 14, 'https://bizweb.dktcdn.net/100/347/092/products/8ddf7247-21e0-4263-9836-671459e808fc.jpg?v=1768395629403', 'Nike Cloud Pace G0F - side', 0, 1, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (40, 14, 'https://bizweb.dktcdn.net/100/347/092/products/aa25ab72-9808-4aa2-a6ae-c4dddd610572.jpg?v=1768395631890', 'Nike Cloud Pace G0F - top', 0, 2, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (41, 15, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs.jpg', 'Asics Cloud Pace XFF - main', 1, 0, 1, '2026-01-15 22:00:00', 'Brown');
INSERT INTO `product_images` VALUES (42, 15, 'https://bizweb.dktcdn.net/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-1-af8cd553-7a73-4272-a465-3ec1eb4f346f.jpg?v=1740722670057', 'Asics Cloud Pace XFF - side', 0, 1, 1, '2026-01-15 22:00:00', 'Brown');
INSERT INTO `product_images` VALUES (43, 15, 'https://bizweb.dktcdn.net/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-2-1.jpg?v=1740722682260', 'Asics Cloud Pace XFF - top', 0, 2, 1, '2026-01-15 22:00:00', 'Brown');
INSERT INTO `product_images` VALUES (44, 16, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-tensor-eg4126-01.jpg', 'Asics Air Runner 9T8 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Pink');
INSERT INTO `product_images` VALUES (45, 16, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-tensor-eg4126-02.jpg?v=1609759580367', 'Asics Air Runner 9T8 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Pink');
INSERT INTO `product_images` VALUES (46, 16, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-tensor-eg4126-04.jpg?v=1609759581187', 'Asics Air Runner 9T8 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Pink');
INSERT INTO `product_images` VALUES (47, 17, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/x-plr-shoes-beige-by9255-01-standard-1.jpg', 'Under Armour Cloud Pace F1T - main', 1, 0, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (48, 17, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-02-standard-hover-1.jpg?v=1704620732170', 'Under Armour Cloud Pace F1T - side', 0, 1, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (49, 17, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-04-standard-1.jpg?v=1704620733120', 'Under Armour Cloud Pace F1T - top', 0, 2, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (50, 18, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-6e49cf5c-8ae7-4768-a8b4-0daff66afc34.jpg?v=1764234156987', 'Nike Cloud Pace TEX - main', 1, 0, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (51, 18, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-3-fc9888d5-ee6b-4eca-be8b-f92056908a2b.jpg?v=1764234156987', 'Nike Cloud Pace TEX - side', 0, 1, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (52, 18, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-6-97362965-d474-43ee-a5dc-3e2c0e1a43eb.jpg?v=1764234156987', 'Nike Cloud Pace TEX - top', 0, 2, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (53, 19, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-adidas-if8597-1.jpg', 'New Balance Air Runner TVA - main', 1, 0, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (54, 19, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-if8597-2.jpg?v=1720255593123', 'New Balance Air Runner TVA - side', 0, 1, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (55, 19, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-if8597-4.jpg?v=1720255594690', 'New Balance Air Runner TVA - top', 0, 2, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (56, 20, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-fv8351-05.jpg?v=1612083794767', 'Adidas Cloud Pace XMO - main', 1, 0, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (57, 20, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-fv8351-03.jpg?v=1612083794767', 'Adidas Cloud Pace XMO - side', 0, 1, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (58, 20, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-fv8351-04.jpg?v=1612083794767', 'Adidas Cloud Pace XMO - top', 0, 2, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (59, 21, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/9e9335f3c9def8b6c34da1fb735c13f4-472x497.jpg', 'Adidas Cloud Pace C34 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (60, 21, 'https://bizweb.dktcdn.net/100/347/092/products/94a4ef10be5c7bb3a0db85c10fa9b7f7-472x497-1.jpg?v=1705130111020', 'Adidas Cloud Pace C34 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (61, 21, 'https://bizweb.dktcdn.net/100/347/092/products/ef40c4c4664901acbba9cf9dd6bbe800-472x497.jpg?v=1705130007890', 'Adidas Cloud Pace C34 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (62, 22, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-new-balance-fresh-foam-roav-v1-uroavwm1-1.jpg', 'New Balance Cloud Pace 89U - main', 1, 0, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (63, 22, 'https://bizweb.dktcdn.net/100/347/092/products/giay-new-balance-fresh-foam-roav-v1-uroavwm1-3.jpg?v=1739045333737', 'New Balance Cloud Pace 89U - side', 0, 1, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (64, 22, 'https://bizweb.dktcdn.net/100/347/092/products/giay-new-balance-fresh-foam-roav-v1-uroavwm1-4.jpg?v=1739045334433', 'New Balance Cloud Pace 89U - top', 0, 2, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (65, 23, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs.jpg', 'Nike Pro Striker IE6 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Brown');
INSERT INTO `product_images` VALUES (66, 23, 'https://bizweb.dktcdn.net/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-1-af8cd553-7a73-4272-a465-3ec1eb4f346f.jpg?v=1740722670057', 'Nike Pro Striker IE6 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Brown');
INSERT INTO `product_images` VALUES (67, 23, 'https://bizweb.dktcdn.net/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-1-1.jpg?v=1740722672877', 'Nike Pro Striker IE6 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Brown');
INSERT INTO `product_images` VALUES (68, 24, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/edge-xt-shoes-white-fw0670-01.jpg', 'Puma Speed Phantom 77A - main', 1, 0, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (69, 24, 'https://bizweb.dktcdn.net/100/347/092/products/edge-xt-shoes-white-fw0670-06.jpg?v=1622028495823', 'Puma Speed Phantom 77A - side', 0, 1, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (70, 24, 'https://bizweb.dktcdn.net/100/347/092/products/edge-xt-shoes-white-fw0670-03.jpg?v=1622028495823', 'Puma Speed Phantom 77A - top', 0, 2, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (71, 25, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-3-11zon-4efaccd1-ef65-41c9-ae71-c315a9ef6ad0.jpg?v=1766476849523', 'Puma Speed Phantom 9XA - main', 1, 0, 1, '2026-01-15 22:00:00', 'Red');
INSERT INTO `product_images` VALUES (72, 25, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-11zon-be7aa8e7-029e-4c09-9d5b-e29fcc89c3be.jpg?v=1766476850843', 'Puma Speed Phantom 9XA - side', 0, 1, 1, '2026-01-15 22:00:00', 'Red');
INSERT INTO `product_images` VALUES (73, 25, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-4-11zon-4cd0d970-ac29-4337-8559-43707a7d650b.jpg?v=1766476850843', 'Puma Speed Phantom 9XA - top', 0, 2, 1, '2026-01-15 22:00:00', 'Red');
INSERT INTO `product_images` VALUES (74, 26, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/evoride-women-s-1012a677-020-01-9a37e53d-622b-4d5c-a4a6-37b1a8848b2b.jpg', 'Puma Control Master 4DP - main', 1, 0, 1, '2026-01-15 22:00:00', 'Grey');
INSERT INTO `product_images` VALUES (75, 26, 'https://bizweb.dktcdn.net/100/347/092/products/evoride-women-s-1012a677-020-06-1-f4a9b74a-96cc-4409-8b6b-313475594e07.jpg?v=1709892244470', 'Puma Control Master 4DP - side', 0, 1, 1, '2026-01-15 22:00:00', 'Grey');
INSERT INTO `product_images` VALUES (76, 26, 'https://bizweb.dktcdn.net/100/347/092/products/evoride-women-s-1012a677-020-02-28554c52-1c50-4704-bcd0-00f1e61a4e85.jpg?v=1709892244470', 'Puma Control Master 4DP - top', 0, 2, 1, '2026-01-15 22:00:00', 'Grey');
INSERT INTO `product_images` VALUES (77, 27, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-ultraboost-21-be-fy0391-01.jpg', 'Adidas Speed Phantom BN7 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Brown');
INSERT INTO `product_images` VALUES (78, 27, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-21-be-fy0391-06.jpg?v=1638709920027', 'Adidas Speed Phantom BN7 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Brown');
INSERT INTO `product_images` VALUES (79, 27, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-21-be-fy0391-02.jpg?v=1638709920027', 'Adidas Speed Phantom BN7 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Brown');
INSERT INTO `product_images` VALUES (80, 28, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-puma-velocity-nitro-3-black-silver-w-377749-01-01-1721029197148.jpg', 'Puma Pro Striker OY0 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (81, 28, 'https://bizweb.dktcdn.net/100/347/092/products/giay-puma-velocity-nitro-3-black-silver-w-377749-01-03-1721029200115.jpg?v=1721030684013', 'Puma Pro Striker OY0 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (82, 28, 'https://bizweb.dktcdn.net/100/347/092/products/giay-puma-velocity-nitro-3-black-silver-w-377749-01-04-1721029201106.jpg?v=1721030684717', 'Puma Pro Striker OY0 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (83, 29, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-nike-ebernon-low-aq1775-004-1.jpg', 'Nike Control Master KXO - main', 1, 0, 1, '2026-01-15 22:00:00', 'Red');
INSERT INTO `product_images` VALUES (84, 29, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-ebernon-low-aq1775-004-2.jpg?v=1736184992127', 'Nike Control Master KXO - side', 0, 1, 1, '2026-01-15 22:00:00', 'Red');
INSERT INTO `product_images` VALUES (85, 29, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-ebernon-low-aq1775-004-2-1.jpg?v=1736184992127', 'Nike Control Master KXO - top', 0, 2, 1, '2026-01-15 22:00:00', 'Red');
INSERT INTO `product_images` VALUES (86, 30, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-sl20.jpg?v=1649244897697', 'Adidas Speed Phantom ZA7 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Blue');
INSERT INTO `product_images` VALUES (87, 30, 'https://bizweb.dktcdn.net/100/347/092/products/sl20-2-shoes-blue-fz2492-02-standard-hover.jpg?v=1649244898153', 'Adidas Speed Phantom ZA7 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Blue');
INSERT INTO `product_images` VALUES (88, 30, 'https://bizweb.dktcdn.net/100/347/092/products/sl20-2-shoes-blue-fz2492-04-standard.jpg?v=1649244898920', 'Adidas Speed Phantom ZA7 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Blue');
INSERT INTO `product_images` VALUES (89, 31, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-01-standard.jpg', 'Reebok Street Baller GXN - main', 1, 0, 1, '2026-01-15 22:00:00', 'Green');
INSERT INTO `product_images` VALUES (90, 31, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-06-standard.jpg?v=1711029912980', 'Reebok Street Baller GXN - side', 0, 1, 1, '2026-01-15 22:00:00', 'Green');
INSERT INTO `product_images` VALUES (91, 31, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-02-standard-hover.jpg?v=1711029914233', 'Reebok Street Baller GXN - top', 0, 2, 1, '2026-01-15 22:00:00', 'Green');
INSERT INTO `product_images` VALUES (92, 32, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4d-fusio-h04509-01.jpg?v=1652519006187', 'Adidas Hoop Force KXW - main', 1, 0, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (93, 32, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4d-fusio-h04509-02.jpg?v=1652519006603', 'Adidas Hoop Force KXW - side', 0, 1, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (94, 32, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4d-fusio-h04509-04.jpg?v=1652519007353', 'Adidas Hoop Force KXW - top', 0, 2, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (95, 33, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-nike-air-max-2017-849559-005-1.jpg', 'Under Armour Street Baller IXA - main', 1, 0, 1, '2026-01-15 22:00:00', 'Grey');
INSERT INTO `product_images` VALUES (96, 33, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-nike-air-max-2017-849559-005-1.jpg', 'Under Armour Street Baller IXA - side', 0, 1, 1, '2026-01-15 22:00:00', 'Grey');
INSERT INTO `product_images` VALUES (97, 33, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-air-max-2017-849559-005-4.jpg?v=1765986963813', 'Under Armour Street Baller IXA - top', 0, 2, 1, '2026-01-15 22:00:00', 'Grey');
INSERT INTO `product_images` VALUES (98, 34, 'https://bizweb.dktcdn.net/100/347/092/products/471621429-911299884508655-6172145443203728554-n.jpg?v=1735550737220', 'Converse Street Baller 6QF - main', 1, 0, 1, '2026-01-15 22:00:00', 'Pink');
INSERT INTO `product_images` VALUES (99, 34, 'https://bizweb.dktcdn.net/100/347/092/products/470052997-1295826784786685-7708717018969972900-n.jpg?v=1735550739197', 'Converse Street Baller 6QF - side', 0, 1, 1, '2026-01-15 22:00:00', 'Pink');
INSERT INTO `product_images` VALUES (100, 34, 'https://bizweb.dktcdn.net/100/347/092/products/470051632-8974577475953435-8228811976925950282-n.jpg?v=1735550742837', 'Converse Street Baller 6QF - top', 0, 2, 1, '2026-01-15 22:00:00', 'Pink');
INSERT INTO `product_images` VALUES (101, 35, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-01-standard.jpg', 'Adidas Court Dunk NFH - main', 1, 0, 1, '2026-01-15 22:00:00', 'Green');
INSERT INTO `product_images` VALUES (102, 35, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-superstar-fv3290-01.jpg', 'Adidas Court Dunk NFH - side', 0, 1, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (103, 35, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-superstar-fv3290-02.jpg?v=1641020679570', 'Adidas Court Dunk NFH - top', 0, 2, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (104, 36, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-3.jpg', 'Under Armour Hoop Force 026 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (105, 36, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-2.jpg?v=1732001734280', 'Under Armour Hoop Force 026 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (106, 36, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/z-f36199-02-35ee1fca-baf2-4bfc-86c1-5c0abfbf920f.jpg', 'Under Armour Hoop Force 026 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (107, 37, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/7e33f5b842804ba48745d51160041600.jpg', 'Puma Daily Canvas XEQ - main', 1, 0, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (108, 37, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-3.jpg', 'Puma Daily Canvas XEQ - side', 0, 1, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (109, 37, 'https://bizweb.dktcdn.net/100/347/092/products/fdf215df7cd741a89238cb49510dfc3e.jpg?v=1761562697917', 'Puma Daily Canvas XEQ - top', 0, 2, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (110, 38, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-nike-vomero-18-hm6803-401-1.jpg', 'Nike Daily Canvas MX2 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (111, 38, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-vomero-18-hm6803-401-4.jpg?v=1765218661307', 'Nike Daily Canvas MX2 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (112, 38, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs.jpg', 'Nike Daily Canvas MX2 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Brown');
INSERT INTO `product_images` VALUES (113, 39, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-vans-vn0007nvfgn-01.jpg', 'Vans Daily Canvas Z2F - main', 1, 0, 1, '2026-01-15 22:00:00', 'Green');
INSERT INTO `product_images` VALUES (114, 39, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nvfgn-04.jpg?v=1715502722113', 'Vans Daily Canvas Z2F - side', 0, 1, 1, '2026-01-15 22:00:00', 'Green');
INSERT INTO `product_images` VALUES (115, 39, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-vans-vn0007nty52-01.jpg', 'Vans Daily Canvas Z2F - top', 0, 2, 1, '2026-01-15 22:00:00', 'Red');
INSERT INTO `product_images` VALUES (116, 40, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-nike-air-max-2017-849559-005-1.jpg', 'Converse Daily Canvas CXA - main', 1, 0, 1, '2026-01-15 22:00:00', 'Grey');
INSERT INTO `product_images` VALUES (117, 40, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-air-max-2017-849559-005-4.jpg?v=1765986963813', 'Converse Daily Canvas CXA - side', 0, 1, 1, '2026-01-15 22:00:00', 'Grey');
INSERT INTO `product_images` VALUES (118, 40, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/reebokdmxseries2kdv97240282a1e.jpg', 'Converse Daily Canvas CXA - top', 0, 2, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (119, 41, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/36f2d78a-70f8-4c79-9a07-3c8c0f6d913e.jpg', 'Nike Street Classic Q1U - main', 1, 0, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (120, 41, 'https://bizweb.dktcdn.net/100/347/092/products/27e94eb8-c159-446d-8b1d-250df462191f.jpg?v=1754363992803', 'Nike Street Classic Q1U - side', 0, 1, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (121, 41, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/pegasus-40-dv7480-401-01.jpg', 'Nike Street Classic Q1U - top', 0, 2, 1, '2026-01-15 22:00:00', 'Blue');
INSERT INTO `product_images` VALUES (122, 42, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-3.jpg', 'Puma Street Classic TIR - main', 1, 0, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (123, 42, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-ultraboost-20-eg0713-01.jpg', 'Puma Street Classic TIR - side', 0, 1, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (124, 42, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-eg0713-03.jpg?v=1611978277637', 'Puma Street Classic TIR - top', 0, 2, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (125, 43, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/766a31a1-e9a5-44b3-9981-48fe39f750bb.jpg', 'Converse Daily Canvas JEG - main', 1, 0, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (126, 43, 'https://bizweb.dktcdn.net/100/347/092/products/08809a9a-a814-4333-bcf3-79f1c8a69b95.jpg?v=1742966024350', 'Converse Daily Canvas JEG - side', 0, 1, 1, '2026-01-15 22:00:00', 'Navy');
INSERT INTO `product_images` VALUES (127, 43, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-duramo-sl-fy6680-04.jpg?v=1619060350057', 'Converse Daily Canvas JEG - top', 0, 2, 1, '2026-01-15 22:00:00', 'Grey');
INSERT INTO `product_images` VALUES (128, 44, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/x-plr-shoes-beige-by9255-01-standard-1.jpg', 'New Balance Street Classic TJ9 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (130, 44, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-4.jpg?v=1766432456203', 'New Balance Street Classic TJ9 - top', 0, 2, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (131, 45, 'https://bizweb.dktcdn.net/100/347/092/products/fixedratio-20221031112240-lacoste-comfort-2221-sma-andrika-sneakers-leyka-7-44sma005665t.jpg?v=1685277294677', 'Converse Street Classic UYF - main', 1, 0, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (132, 45, 'https://bizweb.dktcdn.net/100/347/092/products/fixedratio-20221031112240-4f4dadc4.jpg?v=1685277294677', 'Converse Street Classic UYF - side', 0, 1, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (133, 45, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/470785406-1357621918749865-7981689223900802324-n.jpg', 'Converse Street Classic UYF - top', 0, 2, 1, '2026-01-15 22:00:00', 'Pink');
INSERT INTO `product_images` VALUES (134, 46, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-01-standard-1.jpg?v=1704620731700', 'New Balance Urban Retro C8D - main', 1, 0, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (135, 46, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-02-standard-hover-1.jpg?v=1704620732170', 'New Balance Urban Retro C8D - side', 0, 1, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (136, 46, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/fixedratio-20221026120719-lacoste-active-4851-2221-sma-andrika-sneakers-leyka-7-44sma011821g-jpeg.jpg', 'New Balance Urban Retro C8D - top', 0, 2, 1, '2026-01-15 22:00:00', 'White');
INSERT INTO `product_images` VALUES (137, 47, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/eh2256-s1.jpg', 'Vans Comfort Slide ZQY - main', 1, 0, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (138, 47, 'https://bizweb.dktcdn.net/100/347/092/products/eh2256-s3.jpg?v=1700424509283', 'Vans Comfort Slide ZQY - side', 0, 1, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (139, 47, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/s-l1600-f9131f6e-837c-4344-8a32-ff5569763cdb.jpg', 'Vans Comfort Slide ZQY - top', 0, 2, 1, '2026-01-15 22:00:00', 'Lavender');
INSERT INTO `product_images` VALUES (140, 48, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/dep-adidas-adilette-22-id4925-01.jpg', 'Puma Beach Walker UKE - main', 1, 0, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (141, 48, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adidas-adilette-22-id4925-02.jpg?v=1723102731607', 'Puma Beach Walker UKE - side', 0, 1, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (142, 48, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/dep-adilette-22-be-if3673-01-standard.jpg', 'Puma Beach Walker UKE - top', 0, 2, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (143, 49, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/b8bfca5a-883a-44ec-a171-3e323ea07dd9.jpg', 'Puma Sport Sandal A13 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Grey');
INSERT INTO `product_images` VALUES (144, 49, 'https://bizweb.dktcdn.net/100/347/092/products/fa39a09f-b4a6-4a1d-b309-53ec7caca525.jpg?v=1735551872663', 'Puma Sport Sandal A13 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Grey');
INSERT INTO `product_images` VALUES (145, 49, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/a068a1a8-ed4e-4ba2-b69b-be6d8986da29.jpg', 'Puma Sport Sandal A13 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (146, 50, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/110339010959-18-2-1080x715-1.jpg', 'Nike Beach Walker LYK - main', 1, 0, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (147, 50, 'https://bizweb.dktcdn.net/100/347/092/products/dd0204-005-giay-chay-bo-nam-nike-quest-5-chinh-hang-gia-tot-den-king-shoes-3-1.jpg?v=1768472158150', 'Nike Beach Walker LYK - side', 0, 1, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (148, 50, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-01-33f41548-eee8-493c-b25a-0656a44d0665.jpg', 'Nike Beach Walker LYK - top', 0, 2, 1, '2026-01-15 22:00:00', 'Pink');
INSERT INTO `product_images` VALUES (149, 51, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/b8bfca5a-883a-44ec-a171-3e323ea07dd9.jpg', 'Vans Sport Sandal RPB - main', 1, 0, 1, '2026-01-15 22:00:00', 'Grey');
INSERT INTO `product_images` VALUES (150, 51, 'https://bizweb.dktcdn.net/100/347/092/products/fa39a09f-b4a6-4a1d-b309-53ec7caca525.jpg?v=1735551872663', 'Vans Sport Sandal RPB - side', 0, 1, 1, '2026-01-15 22:00:00', 'Grey');
INSERT INTO `product_images` VALUES (151, 51, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/s-l1600-f9131f6e-837c-4344-8a32-ff5569763cdb.jpg', 'Vans Sport Sandal RPB - top', 0, 2, 1, '2026-01-15 22:00:00', 'Lavender');
INSERT INTO `product_images` VALUES (152, 52, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/ci8797-301-a.jpg', 'Converse Comfort Slide XF7 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Green');
INSERT INTO `product_images` VALUES (153, 52, 'https://bizweb.dktcdn.net/100/347/092/products/ci8797-301-c-1.jpg?v=1749519612793', 'Converse Comfort Slide XF7 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Green');
INSERT INTO `product_images` VALUES (154, 52, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/dep-adilette-22-be-if3673-01-standard.jpg', 'Converse Comfort Slide XF7 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (155, 53, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-01-standard-1.jpg?v=1704620731700', 'Adidas Baseline Pro KV9 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (156, 53, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/470785406-1357621918749865-7981689223900802324-n.jpg', 'Adidas Baseline Pro KV9 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Pink');
INSERT INTO `product_images` VALUES (157, 53, 'https://bizweb.dktcdn.net/100/347/092/products/470056923-1318554229579825-8979052385952416786-n.jpg?v=1735550741353', 'Adidas Baseline Pro KV9 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Pink');
INSERT INTO `product_images` VALUES (158, 54, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/x-plr-shoes-beige-by9255-01-standard-1.jpg', 'Asics Baseline Pro OLR - main', 1, 0, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (159, 54, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/z-f36199-02-35ee1fca-baf2-4bfc-86c1-5c0abfbf920f.jpg', 'Asics Baseline Pro OLR - side', 0, 1, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (160, 54, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-04-standard-1.jpg?v=1704620733120', 'Asics Baseline Pro OLR - top', 0, 2, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (161, 55, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/z-f36199-02-35ee1fca-baf2-4bfc-86c1-5c0abfbf920f.jpg', 'Adidas Tennis Ace 8MY - main', 1, 0, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (162, 55, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-04-884ee4b9-78f1-44c5-b0ff-d7df728f6000.jpg?v=1712215775217', 'Adidas Tennis Ace 8MY - side', 0, 1, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (163, 55, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-adidas-supernova-mau-tim-fz2497-01-standard.jpg', 'Adidas Tennis Ace 8MY - top', 0, 2, 1, '2026-01-15 22:00:00', 'Lavender');
INSERT INTO `product_images` VALUES (164, 56, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-nike-metcon-dz2615-800-01.jpg', 'Nike Tennis Ace 1ZD - main', 1, 0, 1, '2026-01-15 22:00:00', 'Brown');
INSERT INTO `product_images` VALUES (165, 56, 'https://bizweb.dktcdn.net/100/347/092/products/nike-zoomx-invincible-run-3-black-white-dr2615-001-05.jpg?v=1701665006187', 'Nike Tennis Ace 1ZD - side', 0, 1, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (166, 56, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-metcon-dz2615-800-05.jpg?v=1716975215183', 'Nike Tennis Ace 1ZD - top', 0, 2, 1, '2026-01-15 22:00:00', 'Brown');
INSERT INTO `product_images` VALUES (167, 57, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/x-plr-shoes-beige-by9255-01-standard-1.jpg', 'Puma Gym Trainer WI6 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (168, 57, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-04-standard-1.jpg?v=1704620733120', 'Puma Gym Trainer WI6 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Beige');
INSERT INTO `product_images` VALUES (169, 57, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-4dfwd-pulse-2-hp7635-01.jpg', 'Puma Gym Trainer WI6 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Red');
INSERT INTO `product_images` VALUES (170, 58, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-ultraboost-21-be-fy0391-01.jpg', 'Adidas HIIT Flex K94 - main', 1, 0, 1, '2026-01-15 22:00:00', 'Brown');
INSERT INTO `product_images` VALUES (171, 58, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-4dfwd-pulse-2-hp7635-01.jpg', 'Adidas HIIT Flex K94 - side', 0, 1, 1, '2026-01-15 22:00:00', 'Red');
INSERT INTO `product_images` VALUES (172, 58, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4dfwd-pulse-2-hp7635-05.jpg?v=1693727409133', 'Adidas HIIT Flex K94 - top', 0, 2, 1, '2026-01-15 22:00:00', 'Red');
INSERT INTO `product_images` VALUES (173, 59, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-nike-ebernon-low-aq1775-004-1.jpg', 'Nike HIIT Flex WYZ - main', 1, 0, 1, '2026-01-15 22:00:00', 'Red');
INSERT INTO `product_images` VALUES (174, 59, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-ebernon-low-aq1775-004-2.jpg?v=1736184992127', 'Nike HIIT Flex WYZ - side', 0, 1, 1, '2026-01-15 22:00:00', 'Red');
INSERT INTO `product_images` VALUES (175, 59, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-air-max-excee-dq3993-001-01.jpg', 'Nike HIIT Flex WYZ - top', 0, 2, 1, '2026-01-15 22:00:00', 'Black');
INSERT INTO `product_images` VALUES (176, 60, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/bot-ve-sinh-giay-tien-loi-150ml-01.jpg?v=1694779868303', 'Puma Gym Trainer WI6', 1, 0, 1, '2026-01-15 22:00:00', NULL);
INSERT INTO `product_images` VALUES (177, 60, 'https://bizweb.dktcdn.net/100/347/092/products/bot-ve-sinh-giay-tien-loi-150ml-02.jpg?v=1694779869063', 'Mizuno Shoe Care Kit 5NS - side', 0, 1, 1, '2026-01-15 22:00:00', NULL);
INSERT INTO `product_images` VALUES (178, 60, 'https://bizweb.dktcdn.net/100/347/092/products/bot-ve-sinh-giay-tien-loi-150ml-02.jpg?v=1694779869063', 'Mizuno Shoe Care Kit 5NS - top', 0, 2, 1, '2026-01-15 22:00:00', NULL);
INSERT INTO `product_images` VALUES (179, 38, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-2-056be542-1123-4a17-8c7b-e8ea2ff82dbb.jpg?v=1764234156987', NULL, 0, 0, 1, '2026-01-16 02:05:51', 'Navy');
INSERT INTO `product_images` VALUES (180, 38, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-6e49cf5c-8ae7-4768-a8b4-0daff66afc34.jpg?v=1764234156987', 'Navy', 0, 0, 1, '2026-01-16 02:07:43', 'Navy');
INSERT INTO `product_images` VALUES (181, 36, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-1.jpg?v=1732001734280', NULL, 0, 0, 1, '2026-01-16 02:08:13', 'Beige');
INSERT INTO `product_images` VALUES (182, 36, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-4.jpg?v=1731826199520', NULL, 0, 0, 1, '2026-01-16 02:08:22', 'Beige');
INSERT INTO `product_images` VALUES (183, 36, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-5.jpg?v=1731826199827', 'Beige', 0, 0, 1, '2026-01-16 02:08:31', NULL);
INSERT INTO `product_images` VALUES (184, 36, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-6.jpg?v=1731826200563', NULL, 0, 0, 1, '2026-01-16 02:08:39', 'Beige');
INSERT INTO `product_images` VALUES (185, 36, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-04-884ee4b9-78f1-44c5-b0ff-d7df728f6000.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 02:09:02', 'Black');
INSERT INTO `product_images` VALUES (186, 36, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-05-eb36cd2e-804a-4b42-9efb-93137a65315a.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 02:09:10', 'Black');
INSERT INTO `product_images` VALUES (187, 36, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-06-7086956a-d5c0-4013-ae87-7c7d47699614.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 02:09:17', 'Black');
INSERT INTO `product_images` VALUES (188, 36, 'https://bizweb.dktcdn.net/thumb/small/100/347/092/products/z-f36199-03-70b40d8a-8bd0-469b-84e3-6a4ba0a5d6f9.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 02:09:35', 'Black');
INSERT INTO `product_images` VALUES (189, 37, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-1.jpg?v=1732001734280', NULL, 0, 0, 1, '2026-01-16 02:10:11', 'Beige');
INSERT INTO `product_images` VALUES (190, 37, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-2.jpg?v=1732001734280', NULL, 0, 0, 1, '2026-01-16 02:10:29', 'Beige');
INSERT INTO `product_images` VALUES (191, 37, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-4.jpg?v=1731826199520', NULL, 0, 0, 1, '2026-01-16 02:10:34', 'Beige');
INSERT INTO `product_images` VALUES (192, 37, 'https://bizweb.dktcdn.net/thumb/small/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-5.jpg?v=1731826199827', NULL, 0, 0, 1, '2026-01-16 02:10:43', 'Beige');
INSERT INTO `product_images` VALUES (193, 37, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-6.jpg?v=1731826200563', NULL, 0, 0, 1, '2026-01-16 02:10:50', 'Beige');
INSERT INTO `product_images` VALUES (194, 37, 'https://bizweb.dktcdn.net/100/347/092/products/840b3b6da0ec4ffcb3bdd41ae8a971eb.jpg?v=1761562697917', NULL, 0, 0, 1, '2026-01-16 02:11:52', 'Navy');
INSERT INTO `product_images` VALUES (195, 37, 'https://bizweb.dktcdn.net/100/347/092/products/016084ee470c408fb3dab444c587f110.jpg?v=1761562697917', NULL, 0, 0, 1, '2026-01-16 02:11:59', 'Navy');
INSERT INTO `product_images` VALUES (196, 37, 'https://bizweb.dktcdn.net/100/347/092/products/016084ee470c408fb3dab444c587f110.jpg?v=1761562697917', NULL, 0, 0, 1, '2026-01-16 02:12:07', 'Navy');
INSERT INTO `product_images` VALUES (197, 37, 'https://bizweb.dktcdn.net/100/347/092/products/b9ff17167be049c29594724432253c86.jpg?v=1761562697917', NULL, 0, 0, 1, '2026-01-16 02:12:14', 'Navy');
INSERT INTO `product_images` VALUES (198, 38, 'https://bizweb.dktcdn.net/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-1-af8cd553-7a73-4272-a465-3ec1eb4f346f.jpg?v=1740722670057', NULL, 0, 0, 1, '2026-01-16 02:12:42', 'Brown');
INSERT INTO `product_images` VALUES (199, 38, 'https://bizweb.dktcdn.net/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-1-1.jpg?v=1740722672877', NULL, 0, 0, 1, '2026-01-16 02:12:50', 'Brown');
INSERT INTO `product_images` VALUES (200, 38, 'https://bizweb.dktcdn.net/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-2-1.jpg?v=1740722682260', NULL, 0, 0, 1, '2026-01-16 02:12:56', 'Brown');
INSERT INTO `product_images` VALUES (201, 38, 'https://bizweb.dktcdn.net/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-3.jpg?v=1740722682260', NULL, 0, 0, 1, '2026-01-16 02:13:04', 'Brown');
INSERT INTO `product_images` VALUES (202, 38, 'https://bizweb.dktcdn.net/thumb/small/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-1.jpg?v=1740722682260', NULL, 0, 0, 1, '2026-01-16 02:13:14', 'Brown');
INSERT INTO `product_images` VALUES (203, 38, 'https://bizweb.dktcdn.net/thumb/small/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-4.jpg?v=1740722682260', NULL, 0, 0, 1, '2026-01-16 02:13:36', 'Brown');
INSERT INTO `product_images` VALUES (204, 38, 'https://bizweb.dktcdn.net/100/347/092/products/b9ff17167be049c29594724432253c86.jpg?v=1761562697917', NULL, 0, 0, 1, '2026-01-16 02:14:26', 'Navy');
INSERT INTO `product_images` VALUES (205, 39, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nvfgn-02.jpg?v=1715502720517', NULL, 0, 0, 1, '2026-01-16 02:15:49', 'Green');
INSERT INTO `product_images` VALUES (206, 39, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nvfgn-03.jpg?v=1715502721263', NULL, 0, 0, 1, '2026-01-16 02:15:56', 'Green');
INSERT INTO `product_images` VALUES (207, 39, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nvfgn-05.jpg?v=1715502723040', NULL, 0, 0, 1, '2026-01-16 02:16:13', 'Green');
INSERT INTO `product_images` VALUES (208, 39, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nvfgn-06.jpg?v=1715502723833', NULL, 0, 0, 1, '2026-01-16 02:16:24', 'Green');
INSERT INTO `product_images` VALUES (209, 39, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-vans-vn0007nty52-02.jpg?v=1715501860317', NULL, 0, 0, 1, '2026-01-16 02:17:23', 'Red');
INSERT INTO `product_images` VALUES (210, 39, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nty52-03.jpg?v=1715501861110', NULL, 0, 0, 1, '2026-01-16 02:17:30', 'Red');
INSERT INTO `product_images` VALUES (211, 39, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nty52-04.jpg?v=1715501861907', NULL, 0, 0, 1, '2026-01-16 02:17:37', 'Red');
INSERT INTO `product_images` VALUES (212, 39, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nty52-05.jpg?v=1715501862833', NULL, 0, 0, 1, '2026-01-16 02:17:45', 'Red');
INSERT INTO `product_images` VALUES (213, 39, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nty52-06.jpg?v=1715501863427', NULL, 0, 0, 1, '2026-01-16 02:17:53', 'Red');
INSERT INTO `product_images` VALUES (214, 40, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-air-max-2017-849559-005-2.jpg?v=1765986962263', NULL, 0, 0, 1, '2026-01-16 02:18:31', 'Grey');
INSERT INTO `product_images` VALUES (215, 40, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-air-max-2017-849559-005-3.jpg?v=1765986963077', NULL, 0, 0, 1, '2026-01-16 02:18:39', 'Grey');
INSERT INTO `product_images` VALUES (216, 40, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-air-max-2017-849559-005-5.jpg?v=1765986964307', NULL, 0, 0, 1, '2026-01-16 02:18:47', 'Grey');
INSERT INTO `product_images` VALUES (217, 40, 'https://bizweb.dktcdn.net/thumb/small/100/347/092/products/reebokdmxseries2kdv9724012043f.jpg?v=1733226697110', NULL, 0, 0, 1, '2026-01-16 02:19:19', 'White');
INSERT INTO `product_images` VALUES (218, 40, 'https://bizweb.dktcdn.net/100/347/092/products/reebokdmxseries2kdv97240370f63.jpg?v=1733226697110', NULL, 0, 0, 1, '2026-01-16 02:19:27', 'White');
INSERT INTO `product_images` VALUES (219, 40, 'https://bizweb.dktcdn.net/100/347/092/products/reebokdmxseries2kdv9724043cae2.jpg?v=1733226697110', NULL, 0, 0, 1, '2026-01-16 02:19:35', 'White');
INSERT INTO `product_images` VALUES (220, 40, 'https://bizweb.dktcdn.net/100/347/092/products/reebokdmxseries2kdv9724058ef1b.jpg?v=1733226697110', NULL, 0, 0, 1, '2026-01-16 02:19:42', 'White');
INSERT INTO `product_images` VALUES (221, 40, 'https://bizweb.dktcdn.net/100/347/092/products/reebokdmxseries2kdv97240689374.jpg?v=1733226697110', NULL, 0, 0, 1, '2026-01-16 02:19:50', 'White');
INSERT INTO `product_images` VALUES (222, 41, 'https://bizweb.dktcdn.net/100/347/092/products/112fbdf5-f864-499c-af0f-f4edc6ec9f3b.jpg?v=1754363988467', NULL, 0, 0, 1, '2026-01-16 02:20:15', 'Beige');
INSERT INTO `product_images` VALUES (223, 41, 'https://bizweb.dktcdn.net/100/347/092/products/916383b0-c084-456d-89c2-295d3ba6476d.jpg?v=1754363989300', NULL, 0, 0, 1, '2026-01-16 02:20:33', 'Beige');
INSERT INTO `product_images` VALUES (224, 41, 'https://bizweb.dktcdn.net/100/347/092/products/4f916e24-cbca-4f15-9d04-96692e9b66fd.jpg?v=1754363992803', NULL, 0, 0, 1, '2026-01-16 02:20:41', 'Beige');
INSERT INTO `product_images` VALUES (225, 41, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-vomero-18-hm6803-401-2.jpg?v=1765218658957', NULL, 0, 0, 1, '2026-01-16 02:21:21', 'Blue');
INSERT INTO `product_images` VALUES (226, 41, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-vomero-18-hm6803-401-3.jpg?v=1765218660170', NULL, 0, 0, 1, '2026-01-16 02:21:28', 'Blue');
INSERT INTO `product_images` VALUES (227, 41, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-vomero-18-hm6803-401-5.jpg?v=1765218662550', NULL, 0, 0, 1, '2026-01-16 02:21:35', 'Blue');
INSERT INTO `product_images` VALUES (228, 41, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-vomero-18-hm6803-401-6.jpg?v=1765218663397', NULL, 0, 0, 1, '2026-01-16 02:21:45', 'Blue');
INSERT INTO `product_images` VALUES (229, 42, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-1.jpg?v=1732001734280', NULL, 0, 0, 1, '2026-01-16 02:22:11', 'Beige');
INSERT INTO `product_images` VALUES (230, 42, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-2.jpg?v=1732001734280', NULL, 0, 0, 1, '2026-01-16 02:22:17', 'Beige');
INSERT INTO `product_images` VALUES (231, 42, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-4.jpg?v=1731826199520', NULL, 0, 0, 1, '2026-01-16 02:22:23', 'Beige');
INSERT INTO `product_images` VALUES (232, 42, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-5.jpg?v=1731826199827', NULL, 0, 0, 1, '2026-01-16 02:22:30', 'Beige');
INSERT INTO `product_images` VALUES (233, 42, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-eg0713-02.jpg?v=1611978277373', NULL, 0, 0, 1, '2026-01-16 02:22:50', 'White');
INSERT INTO `product_images` VALUES (234, 42, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-eg0713-05.jpg?v=1611978278390', NULL, 0, 0, 1, '2026-01-16 02:23:07', 'White');
INSERT INTO `product_images` VALUES (235, 42, 'https://bizweb.dktcdn.net/thumb/small/100/347/092/products/adidas-ultraboost-20-eg0713-06.jpg?v=1611978278663', NULL, 0, 0, 1, '2026-01-16 02:23:16', 'White');
INSERT INTO `product_images` VALUES (236, 43, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-duramo-sl-fy6680-01.jpg?v=1619060349090', NULL, 0, 0, 1, '2026-01-16 02:23:56', 'Grey');
INSERT INTO `product_images` VALUES (237, 43, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-duramo-sl-fy6680-02.jpg?v=1619060349410', NULL, 0, 0, 1, '2026-01-16 02:24:02', 'Grey');
INSERT INTO `product_images` VALUES (238, 43, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-duramo-sl-fy6680-05.jpg?v=1619060350390', NULL, 0, 0, 1, '2026-01-16 02:24:09', 'Grey');
INSERT INTO `product_images` VALUES (239, 43, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-duramo-sl-fy6680-07.jpg?v=1619060351380', NULL, 0, 0, 1, '2026-01-16 02:24:26', 'Grey');
INSERT INTO `product_images` VALUES (240, 43, 'https://bizweb.dktcdn.net/100/347/092/products/ef40c4c4664901acbba9cf9dd6bbe800-472x497.jpg?v=1705130007890', NULL, 0, 0, 1, '2026-01-16 02:25:01', 'Navy');
INSERT INTO `product_images` VALUES (241, 43, 'https://bizweb.dktcdn.net/100/347/092/products/a6f1722d435cf4875ca858980d8a69bf-472x497.jpg?v=1705130007890', NULL, 0, 0, 1, '2026-01-16 02:25:09', 'Navy');
INSERT INTO `product_images` VALUES (242, 43, 'https://bizweb.dktcdn.net/thumb/small/100/347/092/products/92ee6ac252270229f2d92874adc604d6-472x497.jpg?v=1705130011563', NULL, 0, 0, 1, '2026-01-16 02:25:17', 'Navy');
INSERT INTO `product_images` VALUES (243, 44, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-02-standard-hover-1.jpg?v=1704620732170', NULL, 0, 0, 1, '2026-01-16 02:27:36', 'Beige');
INSERT INTO `product_images` VALUES (244, 44, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-04-standard-1.jpg?v=1704620733120', NULL, 0, 0, 1, '2026-01-16 02:27:51', 'Beige');
INSERT INTO `product_images` VALUES (245, 44, 'https://bizweb.dktcdn.net/thumb/small/100/347/092/products/x-plr-shoes-beige-by9255-05-standard-1.jpg?v=1704620733373', NULL, 0, 0, 1, '2026-01-16 02:27:59', 'Beige');
INSERT INTO `product_images` VALUES (246, 44, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-41-detail-1.jpg?v=1704620734047', NULL, 0, 0, 1, '2026-01-16 02:28:06', 'Beige');
INSERT INTO `product_images` VALUES (247, 44, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-1.jpg?v=1766432452887', NULL, 0, 0, 1, '2026-01-16 02:28:45', 'White');
INSERT INTO `product_images` VALUES (248, 44, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-3.jpg?v=1766432455387', NULL, 0, 0, 1, '2026-01-16 02:28:52', 'White');
INSERT INTO `product_images` VALUES (249, 44, 'https://bizweb.dktcdn.net/thumb/small/100/347/092/products/mch796n4-nb-02-6.jpg?v=1766432458263', NULL, 0, 0, 1, '2026-01-16 02:29:03', 'White');
INSERT INTO `product_images` VALUES (250, 44, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-5.jpg?v=1766432457453', NULL, 0, 0, 1, '2026-01-16 02:29:17', 'White');
INSERT INTO `product_images` VALUES (251, 45, 'https://bizweb.dktcdn.net/100/347/092/products/471621429-911299884508655-6172145443203728554-n.jpg?v=1735550737220', NULL, 0, 0, 1, '2026-01-16 02:29:55', 'Pink');
INSERT INTO `product_images` VALUES (252, 45, 'https://bizweb.dktcdn.net/100/347/092/products/470052997-1295826784786685-7708717018969972900-n.jpg?v=1735550739197', NULL, 0, 0, 1, '2026-01-16 02:30:02', 'Pink');
INSERT INTO `product_images` VALUES (253, 45, 'https://bizweb.dktcdn.net/100/347/092/products/470056923-1318554229579825-8979052385952416786-n.jpg?v=1735550741353', NULL, 0, 0, 1, '2026-01-16 02:30:09', 'Pink');
INSERT INTO `product_images` VALUES (254, 45, 'https://bizweb.dktcdn.net/100/347/092/products/470051632-8974577475953435-8228811976925950282-n.jpg?v=1735550742837', NULL, 0, 0, 1, '2026-01-16 02:30:18', 'Pink');
INSERT INTO `product_images` VALUES (255, 45, 'https://bizweb.dktcdn.net/100/347/092/products/fixedratio-20221031112240-780021c0.jpg?v=1685277294677', NULL, 0, 0, 1, '2026-01-16 02:30:49', 'White');
INSERT INTO `product_images` VALUES (256, 45, 'https://bizweb.dktcdn.net/100/347/092/products/fixedratio-20221110111847-8910ca98.jpg?v=1685277290573', NULL, 0, 0, 1, '2026-01-16 02:31:25', 'White');
INSERT INTO `product_images` VALUES (257, 46, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-04-standard-1.jpg?v=1704620733120', NULL, 0, 0, 1, '2026-01-16 02:32:55', 'Beige');
INSERT INTO `product_images` VALUES (258, 46, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-05-standard-1.jpg?v=1704620733373', NULL, 0, 0, 1, '2026-01-16 02:33:02', 'Beige');
INSERT INTO `product_images` VALUES (259, 46, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-41-detail-1.jpg?v=1704620734047', NULL, 0, 0, 1, '2026-01-16 02:33:09', 'Beige');
INSERT INTO `product_images` VALUES (260, 46, 'https://bizweb.dktcdn.net/100/347/092/products/edge-xt-shoes-white-fw0670-06.jpg?v=1622028495823', NULL, 0, 0, 1, '2026-01-16 02:33:23', 'White');
INSERT INTO `product_images` VALUES (261, 46, 'https://bizweb.dktcdn.net/100/347/092/products/edge-xt-shoes-white-fw0670-02.jpg?v=1622028495823', NULL, 0, 0, 1, '2026-01-16 02:33:30', 'White');
INSERT INTO `product_images` VALUES (262, 46, 'https://bizweb.dktcdn.net/100/347/092/products/edge-xt-shoes-white-fw0670-03.jpg?v=1622028495823', NULL, 0, 0, 1, '2026-01-16 02:33:38', 'White');
INSERT INTO `product_images` VALUES (263, 46, 'https://bizweb.dktcdn.net/100/347/092/products/edge-xt-shoes-white-fw0670-04.jpg?v=1622028495823', NULL, 0, 0, 1, '2026-01-16 02:33:46', 'White');
INSERT INTO `product_images` VALUES (264, 47, 'https://bizweb.dktcdn.net/100/347/092/products/eh2256-s5.jpg?v=1700424510233', NULL, 0, 0, 1, '2026-01-16 02:34:37', 'Black');
INSERT INTO `product_images` VALUES (265, 47, 'https://bizweb.dktcdn.net/100/347/092/products/eh2256-s6.jpg?v=1700424510720', NULL, 0, 0, 1, '2026-01-16 02:34:45', 'Black');
INSERT INTO `product_images` VALUES (266, 47, 'https://bizweb.dktcdn.net/100/347/092/products/eh2256-s7.jpg?v=1700424511397', NULL, 0, 0, 1, '2026-01-16 02:34:53', 'Black');
INSERT INTO `product_images` VALUES (267, 47, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-4-b2a6d41f-8398-4b11-b3ec-8101f2383e02.jpg?v=1749530531953', NULL, 0, 0, 1, '2026-01-16 02:35:43', 'Lavender');
INSERT INTO `product_images` VALUES (268, 47, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-3-cffab5fa-a586-4191-8cca-2c90ed2347c3.jpg?v=1749530531953', NULL, 0, 0, 1, '2026-01-16 02:35:51', 'Lavender');
INSERT INTO `product_images` VALUES (269, 47, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-2-14c34011-0e46-4bce-b624-024f749663b4.jpg?v=1749530531953', NULL, 0, 0, 1, '2026-01-16 02:35:59', 'Lavender');
INSERT INTO `product_images` VALUES (270, 47, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-6-904c0497-d919-4033-b3ec-a04ce87ada28.jpg?v=1749530531953', NULL, 0, 0, 1, '2026-01-16 02:36:09', 'Lavender');
INSERT INTO `product_images` VALUES (271, 48, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adilette-22-be-if3673-02-standard-hover.jpg?v=1727687236933', NULL, 0, 0, 1, '2026-01-16 02:36:32', 'Beige');
INSERT INTO `product_images` VALUES (272, 48, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adilette-22-be-if3673-04-standard.jpg?v=1727687238063', NULL, 0, 0, 1, '2026-01-16 02:36:38', 'Beige');
INSERT INTO `product_images` VALUES (273, 48, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adilette-22-be-if3673-06-standard.jpg?v=1727687238617', NULL, 0, 0, 1, '2026-01-16 02:36:45', 'Beige');
INSERT INTO `product_images` VALUES (274, 48, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adilette-22-be-if3673-09-standard.jpg?v=1727687238957', NULL, 0, 0, 1, '2026-01-16 02:36:53', 'Beige');
INSERT INTO `product_images` VALUES (275, 48, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adilette-22-be-if3673-41-detail.jpg?v=1727687239540', NULL, 0, 0, 1, '2026-01-16 02:37:02', 'Beige');
INSERT INTO `product_images` VALUES (276, 48, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adidas-adilette-22-id4925-04.jpg?v=1723102732887', NULL, 0, 0, 1, '2026-01-16 02:37:18', 'Black');
INSERT INTO `product_images` VALUES (277, 48, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adidas-adilette-22-id4925-05.jpg?v=1723102734833', NULL, 0, 0, 1, '2026-01-16 02:37:28', 'Black');
INSERT INTO `product_images` VALUES (278, 48, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adidas-adilette-22-id4925-06.jpg?v=1723102735700', NULL, 0, 0, 1, '2026-01-16 02:37:37', 'Black');
INSERT INTO `product_images` VALUES (279, 48, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adidas-adilette-22-id4925-07.jpg?v=1723102736390', NULL, 0, 0, 1, '2026-01-16 02:37:45', 'Black');
INSERT INTO `product_images` VALUES (280, 49, 'https://bizweb.dktcdn.net/100/347/092/products/76997b4d-97c0-48fd-8f69-7d93c3ad7b38.jpg?v=1744518484150', NULL, 0, 0, 1, '2026-01-16 02:38:18', 'Black');
INSERT INTO `product_images` VALUES (281, 49, 'https://bizweb.dktcdn.net/100/347/092/products/e89e7a6b-29ca-41bd-bb79-9c01b4e4fdf5.jpg?v=1744518480870', NULL, 0, 0, 1, '2026-01-16 02:38:25', 'Black');
INSERT INTO `product_images` VALUES (282, 49, 'https://bizweb.dktcdn.net/100/347/092/products/1ab62016-12ff-4cf7-aeea-ef274f0035aa.jpg?v=1744518484150', NULL, 0, 0, 1, '2026-01-16 02:38:34', 'Black');
INSERT INTO `product_images` VALUES (283, 49, 'https://bizweb.dktcdn.net/100/347/092/products/62f28c4b-9bc7-4d37-bc68-dbb18f1afda1.jpg?v=1744518484150', NULL, 0, 0, 1, '2026-01-16 02:38:43', 'Black');
INSERT INTO `product_images` VALUES (284, 49, 'https://bizweb.dktcdn.net/100/347/092/products/c110661b-3658-40f1-8e21-2cd323ba55b0.jpg?v=1744518484150', NULL, 0, 0, 1, '2026-01-16 02:38:51', 'Black');
INSERT INTO `product_images` VALUES (285, 49, 'https://bizweb.dktcdn.net/100/347/092/products/eafcc7ab-dea8-470f-b1a8-90b8664f249c.jpg?v=1735551876543', NULL, 0, 0, 1, '2026-01-16 02:39:17', 'Grey');
INSERT INTO `product_images` VALUES (286, 49, 'https://bizweb.dktcdn.net/100/347/092/products/d7cf5879-ab26-469e-9f0d-f31dc30696e1.jpg?v=1735551873850', NULL, 0, 0, 1, '2026-01-16 02:39:25', 'Grey');
INSERT INTO `product_images` VALUES (287, 49, 'https://bizweb.dktcdn.net/100/347/092/products/4846d888-60b6-451e-88db-66887e2edb42.jpg?v=1735551876543', NULL, 0, 0, 1, '2026-01-16 02:39:35', 'Grey');
INSERT INTO `product_images` VALUES (288, 49, 'https://bizweb.dktcdn.net/100/347/092/products/4846d888-60b6-451e-88db-66887e2edb42.jpg?v=1735551876543', NULL, 0, 0, 1, '2026-01-16 02:39:41', 'Grey');
INSERT INTO `product_images` VALUES (289, 50, 'https://bizweb.dktcdn.net/100/347/092/products/dd0204-005-giay-chay-bo-nam-nike-quest-5-chinh-hang-gia-tot-den-king-shoes-9-1.jpg?v=1768472158150', NULL, 0, 0, 1, '2026-01-16 02:40:26', 'Black');
INSERT INTO `product_images` VALUES (290, 50, 'https://bizweb.dktcdn.net/100/347/092/products/dd0204-005-giay-chay-bo-nam-nike-quest-5-chinh-hang-gia-tot-den-king-shoes-5-1.jpg?v=1768472158150', NULL, 0, 0, 1, '2026-01-16 02:40:34', 'Black');
INSERT INTO `product_images` VALUES (291, 50, 'https://bizweb.dktcdn.net/100/347/092/products/dd0204-005-giay-chay-bo-nam-nike-quest-5-chinh-hang-gia-tot-den-king-shoes-6-1.jpg?v=1768472158150', NULL, 0, 0, 1, '2026-01-16 02:40:41', 'Black');
INSERT INTO `product_images` VALUES (292, 50, 'https://bizweb.dktcdn.net/thumb/small/100/347/092/products/dd0204-005-giay-chay-bo-nam-nike-quest-5-chinh-hang-gia-tot-den-king-shoes-3-1.jpg?v=1768472158150', NULL, 0, 0, 1, '2026-01-16 02:40:51', 'Black');
INSERT INTO `product_images` VALUES (293, 50, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-02-c539f141-482a-4177-8c3f-c9d6b366c1f3.jpg?v=1712173564713', NULL, 0, 0, 1, '2026-01-16 02:41:30', 'Pink');
INSERT INTO `product_images` VALUES (294, 50, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-03-2ddd5784-2c26-4fb5-8581-e42521cb9fe7.jpg?v=1712173564713', NULL, 0, 0, 1, '2026-01-16 02:41:36', 'Pink');
INSERT INTO `product_images` VALUES (295, 50, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-04-2667859c-5d1e-4369-acfd-fb128ba6ea12.jpg?v=1712173564713', NULL, 0, 0, 1, '2026-01-16 02:41:44', 'Pink');
INSERT INTO `product_images` VALUES (296, 50, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-05-958671e5-eb6a-4d78-a2f0-48f025927633.jpg?v=1712173564713', NULL, 0, 0, 1, '2026-01-16 02:41:52', 'Pink');
INSERT INTO `product_images` VALUES (297, 50, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-06-be06988c-29ac-416e-8b9a-038653c854c5.jpg?v=1712173564713', NULL, 0, 0, 1, '2026-01-16 02:41:58', 'Pink');
INSERT INTO `product_images` VALUES (298, 50, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-07-9786d752-1996-45a6-9197-b39f01db89d1.jpg?v=1712173564713', NULL, 0, 0, 1, '2026-01-16 02:42:10', 'Pink');
INSERT INTO `product_images` VALUES (299, 51, 'https://bizweb.dktcdn.net/100/347/092/products/eafcc7ab-dea8-470f-b1a8-90b8664f249c.jpg?v=1735551876543', NULL, 0, 0, 1, '2026-01-16 02:42:40', 'Grey');
INSERT INTO `product_images` VALUES (300, 51, 'https://bizweb.dktcdn.net/100/347/092/products/4846d888-60b6-451e-88db-66887e2edb42.jpg?v=1735551876543', NULL, 0, 0, 1, '2026-01-16 02:42:49', 'Grey');
INSERT INTO `product_images` VALUES (301, 51, 'https://bizweb.dktcdn.net/100/347/092/products/d7cf5879-ab26-469e-9f0d-f31dc30696e1.jpg?v=1735551873850', NULL, 0, 0, 1, '2026-01-16 02:43:01', 'Grey');
INSERT INTO `product_images` VALUES (302, 51, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-4-b2a6d41f-8398-4b11-b3ec-8101f2383e02.jpg?v=1749530531953', NULL, 0, 0, 1, '2026-01-16 02:44:04', 'Lavender');
INSERT INTO `product_images` VALUES (303, 51, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-2-14c34011-0e46-4bce-b624-024f749663b4.jpg?v=1749530531953', NULL, 0, 0, 1, '2026-01-16 02:44:12', 'Lavender');
INSERT INTO `product_images` VALUES (304, 51, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-6-904c0497-d919-4033-b3ec-a04ce87ada28.jpg?v=1749530531953', NULL, 0, 0, 1, '2026-01-16 02:44:26', 'Lavender');
INSERT INTO `product_images` VALUES (305, 51, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-7-50351e8c-bbc8-40fd-82da-b1502b7ddd52.jpg?v=1749530531953', NULL, 0, 0, 1, '2026-01-16 02:44:34', 'Lavender');
INSERT INTO `product_images` VALUES (306, 52, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adilette-22-be-if3673-02-standard-hover.jpg?v=1727687236933', NULL, 0, 0, 1, '2026-01-16 02:44:56', 'Beige');
INSERT INTO `product_images` VALUES (307, 52, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adilette-22-be-if3673-03-standard.jpg?v=1727687237483', NULL, 0, 0, 1, '2026-01-16 02:45:02', 'Beige');
INSERT INTO `product_images` VALUES (308, 52, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adilette-22-be-if3673-04-standard.jpg?v=1727687238063', NULL, 0, 0, 1, '2026-01-16 02:45:12', 'Beige');
INSERT INTO `product_images` VALUES (309, 52, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adilette-22-be-if3673-06-standard.jpg?v=1727687238617', NULL, 0, 0, 1, '2026-01-16 02:45:22', 'Beige');
INSERT INTO `product_images` VALUES (310, 52, 'https://bizweb.dktcdn.net/100/347/092/products/dep-adilette-22-be-if3673-09-standard.jpg?v=1727687238957', NULL, 0, 0, 1, '2026-01-16 02:45:31', 'Beige');
INSERT INTO `product_images` VALUES (311, 52, 'https://bizweb.dktcdn.net/100/347/092/products/ci8797-301-h.jpg?v=1749519616457', NULL, 0, 0, 1, '2026-01-16 02:46:12', 'Green');
INSERT INTO `product_images` VALUES (312, 52, 'https://bizweb.dktcdn.net/100/347/092/products/ci8797-301-g.jpg?v=1749519615703', NULL, 0, 0, 1, '2026-01-16 02:46:19', 'Green');
INSERT INTO `product_images` VALUES (313, 52, 'https://bizweb.dktcdn.net/100/347/092/products/ci8797-301-f-1.jpg?v=1749519614717', NULL, 0, 0, 1, '2026-01-16 02:46:26', 'Green');
INSERT INTO `product_images` VALUES (314, 52, 'https://bizweb.dktcdn.net/100/347/092/products/ci8797-301-e.jpg?v=1749519614013', NULL, 0, 0, 1, '2026-01-16 02:46:32', 'Green');
INSERT INTO `product_images` VALUES (315, 53, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-02-standard-hover-1.jpg?v=1704620732170', NULL, 0, 0, 1, '2026-01-16 02:46:48', 'Beige');
INSERT INTO `product_images` VALUES (316, 53, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-04-standard-1.jpg?v=1704620733120', NULL, 0, 0, 1, '2026-01-16 02:46:55', 'Beige');
INSERT INTO `product_images` VALUES (317, 53, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-05-standard-1.jpg?v=1704620733373', NULL, 0, 0, 1, '2026-01-16 02:47:02', 'Beige');
INSERT INTO `product_images` VALUES (318, 53, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-41-detail-1.jpg?v=1704620734047', NULL, 0, 0, 1, '2026-01-16 02:47:09', 'Beige');
INSERT INTO `product_images` VALUES (319, 53, 'https://bizweb.dktcdn.net/100/347/092/products/471621429-911299884508655-6172145443203728554-n.jpg?v=1735550737220', NULL, 0, 0, 1, '2026-01-16 02:47:25', 'Pink');
INSERT INTO `product_images` VALUES (320, 53, 'https://bizweb.dktcdn.net/100/347/092/products/470056923-1318554229579825-8979052385952416786-n.jpg?v=1735550741353', NULL, 0, 0, 1, '2026-01-16 02:47:33', 'Pink');
INSERT INTO `product_images` VALUES (321, 53, 'https://bizweb.dktcdn.net/100/347/092/products/470051632-8974577475953435-8228811976925950282-n.jpg?v=1735550742837', NULL, 0, 0, 1, '2026-01-16 02:47:40', 'Pink');
INSERT INTO `product_images` VALUES (322, 54, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-02-standard-hover-1.jpg?v=1704620732170', NULL, 0, 0, 1, '2026-01-16 02:47:57', 'Beige');
INSERT INTO `product_images` VALUES (323, 54, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-03-standard-1.jpg?v=1704620732637', NULL, 0, 0, 1, '2026-01-16 02:48:03', 'Beige');
INSERT INTO `product_images` VALUES (324, 54, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-05-standard-1.jpg?v=1704620733373', NULL, 0, 0, 1, '2026-01-16 02:48:09', 'Beige');
INSERT INTO `product_images` VALUES (325, 54, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-41-detail-1.jpg?v=1704620734047', NULL, 0, 0, 1, '2026-01-16 02:48:18', 'Beige');
INSERT INTO `product_images` VALUES (326, 54, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-04-884ee4b9-78f1-44c5-b0ff-d7df728f6000.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 02:48:29', 'Black');
INSERT INTO `product_images` VALUES (327, 54, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-02-35ee1fca-baf2-4bfc-86c1-5c0abfbf920f.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 02:48:38', 'Black');
INSERT INTO `product_images` VALUES (328, 54, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-06-7086956a-d5c0-4013-ae87-7c7d47699614.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 02:48:44', 'Black');
INSERT INTO `product_images` VALUES (329, 54, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-03-70b40d8a-8bd0-469b-84e3-6a4ba0a5d6f9.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 02:48:54', 'Black');
INSERT INTO `product_images` VALUES (330, 55, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-06-7086956a-d5c0-4013-ae87-7c7d47699614.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 02:49:08', 'Black');
INSERT INTO `product_images` VALUES (331, 55, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-03-70b40d8a-8bd0-469b-84e3-6a4ba0a5d6f9.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 02:49:17', 'Black');
INSERT INTO `product_images` VALUES (332, 55, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-05-eb36cd2e-804a-4b42-9efb-93137a65315a.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 02:49:30', 'Black');
INSERT INTO `product_images` VALUES (333, 55, 'https://bizweb.dktcdn.net/100/347/092/products/giay-supernova-mau-tim-fz2497-02-standard.jpg?v=1645303124573', NULL, 0, 0, 1, '2026-01-16 02:50:02', 'Lavender');
INSERT INTO `product_images` VALUES (334, 55, 'https://bizweb.dktcdn.net/100/347/092/products/giay-supernova-mau-tim-fz2497-03-standard.jpg?v=1645303124980', NULL, 0, 0, 1, '2026-01-16 02:50:12', 'Lavender');
INSERT INTO `product_images` VALUES (335, 55, 'https://bizweb.dktcdn.net/100/347/092/products/giay-supernova-mau-tim-fz2497-04-standard.jpg?v=1645303125297', NULL, 0, 0, 1, '2026-01-16 02:50:21', 'Lavender');
INSERT INTO `product_images` VALUES (336, 55, 'https://bizweb.dktcdn.net/100/347/092/products/giay-supernova-mau-tim-fz2497-05-standard.jpg?v=1645303125800', NULL, 0, 0, 1, '2026-01-16 02:50:32', 'Lavender');
INSERT INTO `product_images` VALUES (337, 59, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-max-excee-dq3993-001-02.jpg?v=1675319785390', NULL, 0, 0, 1, '2026-01-16 02:51:23', 'Black');
INSERT INTO `product_images` VALUES (338, 59, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-max-excee-dq3993-001-03.jpg?v=1675319786030', NULL, 0, 0, 1, '2026-01-16 02:51:29', 'Black');
INSERT INTO `product_images` VALUES (339, 59, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-max-excee-dq3993-001-04.jpg?v=1675319786727', NULL, 0, 0, 1, '2026-01-16 02:51:35', 'Black');
INSERT INTO `product_images` VALUES (340, 59, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-max-excee-dq3993-001-05.jpg?v=1675319787460', NULL, 0, 0, 1, '2026-01-16 02:51:42', 'Black');
INSERT INTO `product_images` VALUES (341, 59, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-max-excee-dq3993-001-06.jpg?v=1675319788030', NULL, 0, 0, 1, '2026-01-16 02:51:49', 'Black');
INSERT INTO `product_images` VALUES (342, 59, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-ebernon-low-aq1775-004-1-1.jpg?v=1736184992127', NULL, 0, 0, 1, '2026-01-16 02:52:02', 'Red');
INSERT INTO `product_images` VALUES (343, 59, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-ebernon-low-aq1775-004-2-1.jpg?v=1736184992127', NULL, 0, 0, 1, '2026-01-16 02:52:09', 'Red');
INSERT INTO `product_images` VALUES (344, 59, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-ebernon-low-aq1775-004-3.jpg?v=1736184992127', NULL, 0, 0, 1, '2026-01-16 02:52:15', 'Red');
INSERT INTO `product_images` VALUES (345, 59, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-ebernon-low-aq1775-004-3-1.jpg?v=1736184992127', NULL, 0, 0, 1, '2026-01-16 02:52:22', 'Red');
INSERT INTO `product_images` VALUES (346, 57, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-02-standard-hover-1.jpg?v=1704620732170', NULL, 0, 0, 1, '2026-01-16 02:52:46', 'Beige');
INSERT INTO `product_images` VALUES (347, 57, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-05-standard-1.jpg?v=1704620733373', NULL, 0, 0, 1, '2026-01-16 02:52:54', 'Beige');
INSERT INTO `product_images` VALUES (348, 57, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-41-detail-1.jpg?v=1704620734047', NULL, 0, 0, 1, '2026-01-16 02:53:00', 'Beige');
INSERT INTO `product_images` VALUES (349, 57, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-42-detail-1.jpg?v=1704620734553', NULL, 0, 0, 1, '2026-01-16 02:53:09', 'Beige');
INSERT INTO `product_images` VALUES (350, 57, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4dfwd-pulse-2-hp7635-02-1.jpg?v=1693727406177', NULL, 0, 0, 1, '2026-01-16 02:53:33', 'Red');
INSERT INTO `product_images` VALUES (351, 57, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4dfwd-pulse-2-hp7635-04-1.jpg?v=1693727408020', NULL, 0, 0, 1, '2026-01-16 02:53:39', 'Red');
INSERT INTO `product_images` VALUES (352, 57, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4dfwd-pulse-2-hp7635-05.jpg?v=1693727409133', NULL, 0, 0, 1, '2026-01-16 02:53:46', 'Red');
INSERT INTO `product_images` VALUES (353, 57, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4dfwd-pulse-2-hp7635-06.jpg?v=1693727410043', NULL, 0, 0, 1, '2026-01-16 02:53:52', 'Red');
INSERT INTO `product_images` VALUES (354, 57, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4dfwd-pulse-2-hp7635-07-1.jpg?v=1693727411017', NULL, 0, 0, 1, '2026-01-16 02:54:04', 'Red');
INSERT INTO `product_images` VALUES (355, 58, 'https://bizweb.dktcdn.net/thumb/small/100/347/092/products/adidas-4dfwd-pulse-2-hp7635-02-1.jpg?v=1693727406177', NULL, 0, 0, 1, '2026-01-16 02:54:21', 'Red');
INSERT INTO `product_images` VALUES (356, 58, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4dfwd-pulse-2-hp7635-04-1.jpg?v=1693727408020', NULL, 0, 0, 1, '2026-01-16 02:54:41', 'Red');
INSERT INTO `product_images` VALUES (357, 58, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4dfwd-pulse-2-hp7635-07-1.jpg?v=1693727411017', NULL, 0, 0, 1, '2026-01-16 02:54:49', 'Red');
INSERT INTO `product_images` VALUES (358, 58, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-21-be-fy0391-06.jpg?v=1638709920027', NULL, 0, 0, 1, '2026-01-16 02:55:45', 'Brown');
INSERT INTO `product_images` VALUES (359, 58, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-21-be-fy0391-02.jpg?v=1638709920027', NULL, 0, 0, 1, '2026-01-16 02:55:53', 'Brown');
INSERT INTO `product_images` VALUES (360, 58, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-21-be-fy0391-03.jpg?v=1638709920027', NULL, 0, 0, 1, '2026-01-16 02:56:04', 'Brown');
INSERT INTO `product_images` VALUES (361, 58, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-21-be-fy0391-04.jpg?v=1638709920027', NULL, 0, 0, 1, '2026-01-16 02:56:13', 'Brown');
INSERT INTO `product_images` VALUES (362, 56, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-zoomx-invincible-run-3-black-white-dr2615-001-01-1.jpg', NULL, 0, 0, 1, '2026-01-16 02:57:14', 'Black');
INSERT INTO `product_images` VALUES (363, 56, 'https://bizweb.dktcdn.net/100/347/092/products/nike-zoomx-invincible-run-3-black-white-dr2615-001-02.jpg?v=1701665003743', NULL, 0, 0, 1, '2026-01-16 02:57:21', 'Black');
INSERT INTO `product_images` VALUES (364, 56, 'https://bizweb.dktcdn.net/100/347/092/products/nike-zoomx-invincible-run-3-black-white-dr2615-001-03.jpg?v=1701665004403', NULL, 0, 0, 1, '2026-01-16 02:57:28', 'Black');
INSERT INTO `product_images` VALUES (365, 56, 'https://bizweb.dktcdn.net/100/347/092/products/nike-zoomx-invincible-run-3-black-white-dr2615-001-04-1.jpg?v=1701665005520', NULL, 0, 0, 1, '2026-01-16 02:57:35', 'Black');
INSERT INTO `product_images` VALUES (366, 56, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-metcon-dz2615-800-07.jpg?v=1716975215183', NULL, 0, 0, 1, '2026-01-16 02:58:12', 'Brown');
INSERT INTO `product_images` VALUES (367, 56, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-metcon-dz2615-800-04.jpg?v=1716975213043', NULL, 0, 0, 1, '2026-01-16 02:58:20', 'Brown');
INSERT INTO `product_images` VALUES (368, 56, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-metcon-dz2615-800-03.jpg?v=1716975208860', NULL, 0, 0, 1, '2026-01-16 02:58:28', 'Brown');
INSERT INTO `product_images` VALUES (369, 35, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-06-standard.jpg?v=1711029912980', NULL, 0, 0, 1, '2026-01-16 03:02:50', 'Green');
INSERT INTO `product_images` VALUES (370, 35, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-02-standard-hover.jpg?v=1711029914233', NULL, 0, 0, 1, '2026-01-16 03:02:58', 'Green');
INSERT INTO `product_images` VALUES (371, 35, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-41-detail.jpg?v=1711029916087', NULL, 0, 0, 1, '2026-01-16 03:03:04', 'Green');
INSERT INTO `product_images` VALUES (372, 35, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-04-standard.jpg?v=1711029917287', NULL, 0, 0, 1, '2026-01-16 03:03:11', 'Green');
INSERT INTO `product_images` VALUES (373, 35, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-05-standard.jpg?v=1711029917287', NULL, 0, 0, 1, '2026-01-16 03:03:17', 'Green');
INSERT INTO `product_images` VALUES (374, 35, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-superstar-fv3290-03.jpg?v=1641020680080', NULL, 0, 0, 1, '2026-01-16 03:03:49', 'Black');
INSERT INTO `product_images` VALUES (375, 35, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-superstar-fv3290-04.jpg?v=1641020680537', NULL, 0, 0, 1, '2026-01-16 03:03:55', 'Black');
INSERT INTO `product_images` VALUES (376, 35, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-superstar-fv3290-05.jpg?v=1641020681120', NULL, 0, 0, 1, '2026-01-16 03:04:02', 'Black');
INSERT INTO `product_images` VALUES (377, 34, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/470785406-1357621918749865-7981689223900802324-n.jpg', NULL, 0, 0, 1, '2026-01-16 03:04:55', 'Pink');
INSERT INTO `product_images` VALUES (378, 34, 'https://bizweb.dktcdn.net/100/347/092/products/470056923-1318554229579825-8979052385952416786-n.jpg?v=1735550741353', NULL, 0, 0, 1, '2026-01-16 03:05:23', 'Pink');
INSERT INTO `product_images` VALUES (379, 34, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/s-l1600-3-11zon-4efaccd1-ef65-41c9-ae71-c315a9ef6ad0.jpg', NULL, 0, 0, 1, '2026-01-16 03:05:59', 'Red');
INSERT INTO `product_images` VALUES (380, 34, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-11zon-be7aa8e7-029e-4c09-9d5b-e29fcc89c3be.jpg?v=1766476850843', NULL, 0, 0, 1, '2026-01-16 03:06:05', 'Red');
INSERT INTO `product_images` VALUES (381, 34, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-4-11zon-4cd0d970-ac29-4337-8559-43707a7d650b.jpg?v=1766476850843', NULL, 0, 0, 1, '2026-01-16 03:06:10', 'Red');
INSERT INTO `product_images` VALUES (382, 34, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-1-11zon-c3223d68-9d9b-4e52-99a2-b978ab564f9e.jpg?v=1766476853923', NULL, 0, 0, 1, '2026-01-16 03:06:20', 'Red');
INSERT INTO `product_images` VALUES (383, 34, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-2-11zon-128f0448-9bbc-4ad7-af84-16279804bfb9.jpg?v=1766476853923', NULL, 0, 0, 1, '2026-01-16 03:06:27', 'Red');
INSERT INTO `product_images` VALUES (384, 33, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-air-max-2017-849559-005-4.jpg?v=1765986963813', NULL, 0, 0, 1, '2026-01-16 03:07:28', 'Grey');
INSERT INTO `product_images` VALUES (385, 33, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-air-max-2017-849559-005-6.jpg?v=1765986965290', NULL, 0, 0, 1, '2026-01-16 03:07:44', 'Grey');
INSERT INTO `product_images` VALUES (386, 33, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-4d-fusio-h04509-01.jpg', NULL, 0, 0, 1, '2026-01-16 03:08:11', 'Navy');
INSERT INTO `product_images` VALUES (387, 33, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4d-fusio-h04509-02.jpg?v=1652519006603', NULL, 0, 0, 1, '2026-01-16 03:08:17', 'Navy');
INSERT INTO `product_images` VALUES (388, 33, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4d-fusio-h04509-04.jpg?v=1652519007353', NULL, 0, 0, 1, '2026-01-16 03:08:24', 'Navy');
INSERT INTO `product_images` VALUES (389, 33, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4d-fusio-h04509-05.jpg?v=1652519007747', NULL, 0, 0, 1, '2026-01-16 03:08:32', 'Navy');
INSERT INTO `product_images` VALUES (390, 33, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4d-fusio-h04509-06.jpg?v=1652519008110', NULL, 0, 0, 1, '2026-01-16 03:08:43', 'Navy');
INSERT INTO `product_images` VALUES (391, 33, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4d-fusio-h04509-07.jpg?v=1652519008537', NULL, 0, 0, 1, '2026-01-16 03:08:54', 'Navy');
INSERT INTO `product_images` VALUES (392, 32, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4d-fusio-h04509-05.jpg?v=1652519007747', NULL, 0, 0, 1, '2026-01-16 03:10:20', 'Navy');
INSERT INTO `product_images` VALUES (393, 32, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4d-fusio-h04509-07.jpg?v=1652519008537', NULL, 0, 0, 1, '2026-01-16 03:10:28', 'Navy');
INSERT INTO `product_images` VALUES (394, 32, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-ultraboost-22-x-marimekko-gz4794-01.jpg', NULL, 0, 0, 1, '2026-01-16 03:10:54', 'Red');
INSERT INTO `product_images` VALUES (395, 32, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-22-x-marimekko-gz4794-02-1.jpg?v=1668485840840', NULL, 0, 0, 1, '2026-01-16 03:11:00', 'Red');
INSERT INTO `product_images` VALUES (396, 32, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-22-x-marimekko-gz4794-03.jpg?v=1668485841457', NULL, 0, 0, 1, '2026-01-16 03:11:07', 'Red');
INSERT INTO `product_images` VALUES (397, 32, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-22-x-marimekko-gz4794-04.jpg?v=1668485842073', NULL, 0, 0, 1, '2026-01-16 03:11:13', 'Red');
INSERT INTO `product_images` VALUES (398, 32, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-22-x-marimekko-gz4794-05.jpg?v=1668485842563', NULL, 0, 0, 1, '2026-01-16 03:11:22', 'Red');
INSERT INTO `product_images` VALUES (399, 31, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-41-detail.jpg?v=1711029916087', NULL, 0, 0, 1, '2026-01-16 03:13:30', 'Green');
INSERT INTO `product_images` VALUES (400, 31, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-04-standard.jpg?v=1711029917287', NULL, 0, 0, 1, '2026-01-16 03:13:36', 'Green');
INSERT INTO `product_images` VALUES (401, 31, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-03-standard.jpg?v=1711029917287', NULL, 0, 0, 1, '2026-01-16 03:13:42', 'Green');
INSERT INTO `product_images` VALUES (402, 31, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/s-l1600-3-11zon-4efaccd1-ef65-41c9-ae71-c315a9ef6ad0.jpg', NULL, 0, 0, 1, '2026-01-16 03:14:21', 'Red');
INSERT INTO `product_images` VALUES (403, 31, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-11zon-be7aa8e7-029e-4c09-9d5b-e29fcc89c3be.jpg?v=1766476850843', NULL, 0, 0, 1, '2026-01-16 03:14:27', 'Red');
INSERT INTO `product_images` VALUES (404, 31, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-4-11zon-4cd0d970-ac29-4337-8559-43707a7d650b.jpg?v=1766476850843', NULL, 0, 0, 1, '2026-01-16 03:14:34', 'Red');
INSERT INTO `product_images` VALUES (405, 31, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-1-11zon-c3223d68-9d9b-4e52-99a2-b978ab564f9e.jpg?v=1766476853923', NULL, 0, 0, 1, '2026-01-16 03:14:40', 'Red');
INSERT INTO `product_images` VALUES (406, 31, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-2-11zon-128f0448-9bbc-4ad7-af84-16279804bfb9.jpg?v=1766476853923', NULL, 0, 0, 1, '2026-01-16 03:14:46', 'Red');
INSERT INTO `product_images` VALUES (407, 30, 'https://bizweb.dktcdn.net/100/347/092/products/sl20-2-shoes-blue-fz2492-05-standard.jpg?v=1649244899363', NULL, 0, 0, 1, '2026-01-16 03:16:00', 'Blue');
INSERT INTO `product_images` VALUES (408, 30, 'https://bizweb.dktcdn.net/100/347/092/products/sl20-2-shoes-blue-fz2492-06-standard.jpg?v=1649244899677', NULL, 0, 0, 1, '2026-01-16 03:16:06', 'Blue');
INSERT INTO `product_images` VALUES (409, 30, 'https://bizweb.dktcdn.net/100/347/092/products/sl20-2-shoes-blue-fz2492-09-standard.jpg?v=1649244900183', NULL, 0, 0, 1, '2026-01-16 03:16:12', 'Blue');
INSERT INTO `product_images` VALUES (410, 30, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/9e9335f3c9def8b6c34da1fb735c13f4-472x497.jpg', NULL, 0, 0, 1, '2026-01-16 03:16:36', 'Navy');
INSERT INTO `product_images` VALUES (411, 30, 'https://bizweb.dktcdn.net/100/347/092/products/94a4ef10be5c7bb3a0db85c10fa9b7f7-472x497-1.jpg?v=1705130111020', NULL, 0, 0, 1, '2026-01-16 03:16:46', 'Navy');
INSERT INTO `product_images` VALUES (412, 30, 'https://bizweb.dktcdn.net/100/347/092/products/ef40c4c4664901acbba9cf9dd6bbe800-472x497.jpg?v=1705130007890', NULL, 0, 0, 1, '2026-01-16 03:16:54', 'Navy');
INSERT INTO `product_images` VALUES (413, 30, 'https://bizweb.dktcdn.net/100/347/092/products/a6f1722d435cf4875ca858980d8a69bf-472x497.jpg?v=1705130007890', NULL, 0, 0, 1, '2026-01-16 03:17:02', 'Navy');
INSERT INTO `product_images` VALUES (414, 30, 'https://bizweb.dktcdn.net/100/347/092/products/6a86001a20a7c13491c5d69efd31bf74-472x497.jpg?v=1705130007890', NULL, 0, 0, 1, '2026-01-16 03:17:10', 'Navy');
INSERT INTO `product_images` VALUES (415, 29, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-ebernon-low-aq1775-004-3.jpg?v=1736184992127', NULL, 0, 0, 1, '2026-01-16 03:18:17', 'Red');
INSERT INTO `product_images` VALUES (416, 29, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-ebernon-low-aq1775-004-3-1.jpg?v=1736184992127', NULL, 0, 0, 1, '2026-01-16 03:18:28', 'Red');
INSERT INTO `product_images` VALUES (417, 29, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-air-force-1-gs-white-black-ct3839-100-01.jpg', NULL, 0, 0, 1, '2026-01-16 03:18:43', 'White');
INSERT INTO `product_images` VALUES (418, 29, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-force-1-gs-white-black-ct3839-100-02.jpg?v=1681810446247', NULL, 0, 0, 1, '2026-01-16 03:18:49', 'White');
INSERT INTO `product_images` VALUES (419, 29, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-force-1-gs-white-black-ct3839-100-03.jpg?v=1681810446873', NULL, 0, 0, 1, '2026-01-16 03:18:55', 'White');
INSERT INTO `product_images` VALUES (420, 29, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-force-1-gs-white-black-ct3839-100-04.jpg?v=1681810447663', NULL, 0, 0, 1, '2026-01-16 03:19:04', 'White');
INSERT INTO `product_images` VALUES (421, 29, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-force-1-gs-white-black-ct3839-100-07.jpg?v=1681810449797', NULL, 0, 0, 1, '2026-01-16 03:19:14', 'White');
INSERT INTO `product_images` VALUES (422, 29, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-force-1-gs-white-black-ct3839-100-06.jpg?v=1681810449097', NULL, 0, 0, 1, '2026-01-16 03:19:23', 'White');
INSERT INTO `product_images` VALUES (423, 28, 'https://bizweb.dktcdn.net/100/347/092/products/giay-puma-velocity-nitro-3-black-silver-w-377749-01-02-1721029199280.jpg?v=1721030683477', NULL, 0, 0, 1, '2026-01-16 03:20:10', 'Black');
INSERT INTO `product_images` VALUES (424, 28, 'https://bizweb.dktcdn.net/100/347/092/products/giay-puma-velocity-nitro-3-black-silver-w-377749-01-05-1721029201780.jpg?v=1721030685237', NULL, 0, 0, 1, '2026-01-16 03:20:36', 'Black');
INSERT INTO `product_images` VALUES (425, 28, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/350096396-1633607450486788-1381027105366073445-n.jpg', NULL, 0, 0, 1, '2026-01-16 03:21:05', 'Green');
INSERT INTO `product_images` VALUES (426, 28, 'https://bizweb.dktcdn.net/100/347/092/products/350127683-205449379098504-3596189180100011553-n.jpg?v=1685195888313', NULL, 0, 0, 1, '2026-01-16 03:21:13', 'Green');
INSERT INTO `product_images` VALUES (427, 28, 'https://bizweb.dktcdn.net/100/347/092/products/350177968-926058028448807-6485027340077058726-n.jpg?v=1685195888313', NULL, 0, 0, 1, '2026-01-16 03:21:18', 'Green');
INSERT INTO `product_images` VALUES (428, 28, 'https://bizweb.dktcdn.net/100/347/092/products/350357969-615405870550787-9162460886963680756-n.jpg?v=1685195888313', NULL, 0, 0, 1, '2026-01-16 03:21:25', 'Green');
INSERT INTO `product_images` VALUES (429, 28, 'https://bizweb.dktcdn.net/100/347/092/products/349639421-1427535004660762-9116071738012284326-n.jpg?v=1685195888313', NULL, 0, 0, 1, '2026-01-16 03:21:32', 'Green');
INSERT INTO `product_images` VALUES (430, 27, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-21-be-fy0391-03.jpg?v=1638709920027', NULL, 0, 0, 1, '2026-01-16 03:22:55', 'Brown');
INSERT INTO `product_images` VALUES (431, 27, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-21-be-fy0391-04.jpg?v=1638709920027', NULL, 0, 0, 1, '2026-01-16 03:23:02', 'Brown');
INSERT INTO `product_images` VALUES (432, 27, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/9e9335f3c9def8b6c34da1fb735c13f4-472x497.jpg', NULL, 0, 0, 1, '2026-01-16 03:23:20', 'Navy');
INSERT INTO `product_images` VALUES (433, 27, 'https://bizweb.dktcdn.net/100/347/092/products/94a4ef10be5c7bb3a0db85c10fa9b7f7-472x497-1.jpg?v=1705130111020', NULL, 0, 0, 1, '2026-01-16 03:23:27', 'Navy');
INSERT INTO `product_images` VALUES (434, 27, 'https://bizweb.dktcdn.net/100/347/092/products/ef40c4c4664901acbba9cf9dd6bbe800-472x497.jpg?v=1705130007890', NULL, 0, 0, 1, '2026-01-16 03:23:34', 'Navy');
INSERT INTO `product_images` VALUES (435, 27, 'https://bizweb.dktcdn.net/100/347/092/products/a6f1722d435cf4875ca858980d8a69bf-472x497.jpg?v=1705130007890', NULL, 0, 0, 1, '2026-01-16 03:23:41', 'Navy');
INSERT INTO `product_images` VALUES (436, 27, 'https://bizweb.dktcdn.net/100/347/092/products/6a86001a20a7c13491c5d69efd31bf74-472x497.jpg?v=1705130007890', NULL, 0, 0, 1, '2026-01-16 03:23:50', 'Navy');
INSERT INTO `product_images` VALUES (437, 26, 'https://bizweb.dktcdn.net/100/347/092/products/evoride-women-s-1012a677-020-03-f1ac8b4c-2422-456a-8bb7-3e606dca3c73.jpg?v=1709892240807', NULL, 0, 0, 1, '2026-01-16 03:25:45', 'Grey');
INSERT INTO `product_images` VALUES (438, 26, 'https://bizweb.dktcdn.net/100/347/092/products/evoride-women-s-1012a677-020-04-527f076c-6a1d-44e5-980c-e2221a569cd5.jpg?v=1709892240807', NULL, 0, 0, 1, '2026-01-16 03:25:53', 'Grey');
INSERT INTO `product_images` VALUES (439, 26, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/s-l1600-3-11zon-4efaccd1-ef65-41c9-ae71-c315a9ef6ad0.jpg', NULL, 0, 0, 1, '2026-01-16 03:26:31', 'Red');
INSERT INTO `product_images` VALUES (440, 26, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-11zon-be7aa8e7-029e-4c09-9d5b-e29fcc89c3be.jpg?v=1766476850843', NULL, 0, 0, 1, '2026-01-16 03:26:37', 'Red');
INSERT INTO `product_images` VALUES (441, 26, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-4-11zon-4cd0d970-ac29-4337-8559-43707a7d650b.jpg?v=1766476850843', NULL, 0, 0, 1, '2026-01-16 03:26:42', 'Red');
INSERT INTO `product_images` VALUES (442, 26, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-1-11zon-c3223d68-9d9b-4e52-99a2-b978ab564f9e.jpg?v=1766476853923', NULL, 0, 0, 1, '2026-01-16 03:26:48', 'Red');
INSERT INTO `product_images` VALUES (443, 26, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-2-11zon-128f0448-9bbc-4ad7-af84-16279804bfb9.jpg?v=1766476853923', NULL, 0, 0, 1, '2026-01-16 03:26:56', 'Red');
INSERT INTO `product_images` VALUES (444, 25, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-1-11zon-c3223d68-9d9b-4e52-99a2-b978ab564f9e.jpg?v=1766476853923', NULL, 0, 0, 1, '2026-01-16 03:27:49', 'Red');
INSERT INTO `product_images` VALUES (445, 25, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-2-11zon-128f0448-9bbc-4ad7-af84-16279804bfb9.jpg?v=1766476853923', NULL, 0, 0, 1, '2026-01-16 03:27:56', 'Red');
INSERT INTO `product_images` VALUES (446, 25, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-ultraboost-21-xam-fy0381-01-standard.jpg', NULL, 0, 0, 1, '2026-01-16 03:28:14', 'Grey');
INSERT INTO `product_images` VALUES (447, 25, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-21-xam-fy0381-02-standard-hover.jpg?v=1632388904097', NULL, 0, 0, 1, '2026-01-16 03:28:22', 'Grey');
INSERT INTO `product_images` VALUES (448, 25, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-21-xam-fy0381-03-standard.jpg?v=1632388904097', NULL, 0, 0, 1, '2026-01-16 03:28:28', 'Grey');
INSERT INTO `product_images` VALUES (449, 25, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-21-xam-fy0381-04-standard.jpg?v=1632388904097', NULL, 0, 0, 1, '2026-01-16 03:28:33', 'Grey');
INSERT INTO `product_images` VALUES (450, 25, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-21-xam-fy0381-05-standard.jpg?v=1632388904097', NULL, 0, 0, 1, '2026-01-16 03:28:42', 'Grey');
INSERT INTO `product_images` VALUES (451, 25, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-21-xam-fy0381-41-detail.jpg?v=1632388904097', NULL, 0, 0, 1, '2026-01-16 03:28:49', 'Grey');
INSERT INTO `product_images` VALUES (452, 24, 'https://bizweb.dktcdn.net/100/347/092/products/edge-xt-shoes-white-fw0670-02.jpg?v=1622028495823', NULL, 0, 0, 1, '2026-01-16 03:29:52', 'White');
INSERT INTO `product_images` VALUES (453, 24, 'https://bizweb.dktcdn.net/100/347/092/products/edge-xt-shoes-white-fw0670-05.jpg?v=1622028495823', NULL, 0, 0, 1, '2026-01-16 03:30:11', 'White');
INSERT INTO `product_images` VALUES (454, 24, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/9c49426d-c460-4eb5-b3a1-47ea6e93245b-1.jpg', NULL, 0, 0, 1, '2026-01-16 03:30:37', 'Brown');
INSERT INTO `product_images` VALUES (455, 24, 'https://bizweb.dktcdn.net/100/347/092/products/9c49426d-c460-4eb5-b3a1-47ea6e93245b.jpg?v=1749535907827', NULL, 0, 0, 1, '2026-01-16 03:30:43', 'Brown');
INSERT INTO `product_images` VALUES (456, 24, 'https://bizweb.dktcdn.net/100/347/092/products/dab787a4-813e-441c-b99c-930f8cb75d4e.jpg?v=1749535907827', NULL, 0, 0, 1, '2026-01-16 03:30:48', 'Brown');
INSERT INTO `product_images` VALUES (457, 24, 'https://bizweb.dktcdn.net/100/347/092/products/5982645c-99e1-4cbe-8b6b-5f9debbf828a.jpg?v=1749535907827', NULL, 0, 0, 1, '2026-01-16 03:30:54', 'Brown');
INSERT INTO `product_images` VALUES (458, 24, 'https://bizweb.dktcdn.net/100/347/092/products/17c0936d-e216-4d2f-963f-e31e9286d7d3.jpg?v=1749535907827', NULL, 0, 0, 1, '2026-01-16 03:30:59', 'Brown');
INSERT INTO `product_images` VALUES (459, 23, 'https://bizweb.dktcdn.net/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-2-1.jpg?v=1740722682260', NULL, 0, 0, 1, '2026-01-16 03:32:13', 'Brown');
INSERT INTO `product_images` VALUES (460, 23, 'https://bizweb.dktcdn.net/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-1.jpg?v=1740722682260', NULL, 0, 0, 1, '2026-01-16 03:32:18', 'Brown');
INSERT INTO `product_images` VALUES (461, 23, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/ac318f20-c991-457c-bc88-e119836ea0c6.jpg', NULL, 0, 0, 1, '2026-01-16 03:32:33', 'White');
INSERT INTO `product_images` VALUES (462, 23, 'https://bizweb.dktcdn.net/100/347/092/products/ccba7b2b-46e5-42d8-9638-7dedcb0f7654.jpg?v=1747107669433', NULL, 0, 0, 1, '2026-01-16 03:32:40', 'White');
INSERT INTO `product_images` VALUES (463, 23, 'https://bizweb.dktcdn.net/100/347/092/products/918e4dbe-c613-4937-b0dc-1099ee901f86.jpg?v=1747107678497', NULL, 0, 0, 1, '2026-01-16 03:32:47', 'White');
INSERT INTO `product_images` VALUES (464, 23, 'https://bizweb.dktcdn.net/100/347/092/products/bcf30f21-82c0-4fbb-9dd0-99187af4e339.jpg?v=1747107678497', NULL, 0, 0, 1, '2026-01-16 03:32:57', 'White');
INSERT INTO `product_images` VALUES (465, 23, 'https://bizweb.dktcdn.net/100/347/092/products/40cacb9d-c092-4e44-a0cd-c0870acfb283.jpg?v=1747107678497', NULL, 0, 0, 1, '2026-01-16 03:33:05', 'White');
INSERT INTO `product_images` VALUES (466, 22, 'https://bizweb.dktcdn.net/100/347/092/products/giay-new-balance-fresh-foam-roav-v1-uroavwm1-2.jpg?v=1739045332640', NULL, 0, 0, 1, '2026-01-16 03:34:31', 'Black');
INSERT INTO `product_images` VALUES (467, 22, 'https://bizweb.dktcdn.net/100/347/092/products/giay-new-balance-fresh-foam-roav-v1-uroavwm1-5.jpg?v=1739045335010', NULL, 0, 0, 1, '2026-01-16 03:34:39', 'Black');
INSERT INTO `product_images` VALUES (468, 22, 'https://bizweb.dktcdn.net/100/347/092/products/giay-new-balance-fresh-foam-roav-v1-uroavwm1-5.jpg?v=1739045335010', NULL, 0, 0, 1, '2026-01-16 03:35:10', 'Navy');
INSERT INTO `product_images` VALUES (469, 22, 'https://bizweb.dktcdn.net/100/347/092/products/wch996u6-1.jpg?v=1757310423263', NULL, 0, 0, 1, '2026-01-16 03:35:17', 'Navy');
INSERT INTO `product_images` VALUES (470, 22, 'https://bizweb.dktcdn.net/100/347/092/products/new-balance-fuelcell-996v6-wch996u6-2.jpg?v=1757310423263', NULL, 0, 0, 1, '2026-01-16 03:35:24', 'Navy');
INSERT INTO `product_images` VALUES (471, 22, 'https://bizweb.dktcdn.net/100/347/092/products/new-balance-fuelcell-996v6-wch996u6-4.jpg?v=1755979209347', NULL, 0, 0, 1, '2026-01-16 03:35:33', 'Navy');
INSERT INTO `product_images` VALUES (472, 22, 'https://bizweb.dktcdn.net/100/347/092/products/new-balance-fuelcell-996v6-wch996u6-5.jpg?v=1755979210567', NULL, 0, 0, 1, '2026-01-16 03:35:40', 'Navy');
INSERT INTO `product_images` VALUES (473, 21, 'https://bizweb.dktcdn.net/100/347/092/products/a6f1722d435cf4875ca858980d8a69bf-472x497.jpg?v=1705130007890', NULL, 0, 0, 1, '2026-01-16 03:36:36', 'Navy');
INSERT INTO `product_images` VALUES (474, 21, 'https://bizweb.dktcdn.net/100/347/092/products/6a86001a20a7c13491c5d69efd31bf74-472x497.jpg?v=1705130007890', NULL, 0, 0, 1, '2026-01-16 03:36:47', 'Navy');
INSERT INTO `product_images` VALUES (475, 21, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-ultraboost-20-fv8351-05.jpg', NULL, 0, 0, 1, '2026-01-16 03:37:01', 'White');
INSERT INTO `product_images` VALUES (476, 21, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-fv8351-03.jpg?v=1612083794767', NULL, 0, 0, 1, '2026-01-16 03:37:17', 'White');
INSERT INTO `product_images` VALUES (477, 21, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-fv8351-04.jpg?v=1612083794767', NULL, 0, 0, 1, '2026-01-16 03:37:23', 'White');
INSERT INTO `product_images` VALUES (478, 21, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-fv8351-07.jpg?v=1612083809993', NULL, 0, 0, 1, '2026-01-16 03:37:30', 'White');
INSERT INTO `product_images` VALUES (479, 21, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-fv8351-06.jpg?v=1612083809993', NULL, 0, 0, 1, '2026-01-16 03:37:36', 'White');
INSERT INTO `product_images` VALUES (480, 20, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-fv8351-07.jpg?v=1612083809993', NULL, 0, 0, 1, '2026-01-16 03:38:38', 'White');
INSERT INTO `product_images` VALUES (481, 20, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-fv8351-06.jpg?v=1612083809993', NULL, 0, 0, 1, '2026-01-16 03:38:46', 'White');
INSERT INTO `product_images` VALUES (482, 20, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/d3f4bdf1f3204db6ba2dab5000f6da2e-9366.jpg', NULL, 0, 0, 1, '2026-01-16 03:39:00', 'Black');
INSERT INTO `product_images` VALUES (483, 20, 'https://bizweb.dktcdn.net/100/347/092/products/giay-galaxy-5-djen-fw6125-02-standard-hover.jpg?v=1674216957357', NULL, 0, 0, 1, '2026-01-16 03:39:06', 'Black');
INSERT INTO `product_images` VALUES (484, 20, 'https://bizweb.dktcdn.net/100/347/092/products/78d27a22dc1e438fabf5ab5000f70927-9366.jpg?v=1674216957357', NULL, 0, 0, 1, '2026-01-16 03:39:12', 'Black');
INSERT INTO `product_images` VALUES (485, 20, 'https://bizweb.dktcdn.net/100/347/092/products/827a3173888347a9bc21ab5000f7001f-9366.jpg?v=1674216957357', NULL, 0, 0, 1, '2026-01-16 03:39:20', 'Black');
INSERT INTO `product_images` VALUES (486, 20, 'https://bizweb.dktcdn.net/100/347/092/products/b5c4d9d92bd64c0da3d2ab5000f6e2d7-9366.jpg?v=1674216957357', NULL, 0, 0, 1, '2026-01-16 03:39:26', 'Black');
INSERT INTO `product_images` VALUES (487, 19, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-if8597-5.jpg?v=1720255595240', NULL, 0, 0, 1, '2026-01-16 03:40:58', 'Navy');
INSERT INTO `product_images` VALUES (488, 19, 'https://bizweb.dktcdn.net/100/347/092/products/giay-adidas-if8597-6.jpg?v=1720255595850', NULL, 0, 0, 1, '2026-01-16 03:41:06', 'Navy');
INSERT INTO `product_images` VALUES (489, 19, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/mch796n4-nb-02-1.jpg', NULL, 1, 0, 1, '2026-01-16 03:41:22', 'White');
INSERT INTO `product_images` VALUES (490, 19, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-2.jpg?v=1766432453887', NULL, 0, 0, 1, '2026-01-16 03:42:13', 'White');
INSERT INTO `product_images` VALUES (491, 19, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-4.jpg?v=1766432456203', NULL, 0, 0, 1, '2026-01-16 03:42:18', 'White');
INSERT INTO `product_images` VALUES (492, 19, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-6.jpg?v=1766432458263', NULL, 0, 0, 1, '2026-01-16 03:42:24', 'White');
INSERT INTO `product_images` VALUES (493, 19, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-5.jpg?v=1766432457453', NULL, 0, 0, 1, '2026-01-16 03:42:32', 'White');
INSERT INTO `product_images` VALUES (494, 18, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/s-l1600-1-c8950e1d-0699-467c-8959-dbe15fc74b78.jpg', NULL, 0, 0, 1, '2026-01-16 03:44:06', 'Navy');
INSERT INTO `product_images` VALUES (495, 18, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-5-0cde6886-bad2-4c8f-bda5-f0c40e53a785.jpg?v=1764234156987', NULL, 0, 0, 1, '2026-01-16 03:44:31', 'Navy');
INSERT INTO `product_images` VALUES (496, 18, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-01-33f41548-eee8-493c-b25a-0656a44d0665.jpg', NULL, 0, 0, 1, '2026-01-16 03:44:58', 'Pink');
INSERT INTO `product_images` VALUES (497, 18, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-02-c539f141-482a-4177-8c3f-c9d6b366c1f3.jpg?v=1712173564713', NULL, 0, 0, 1, '2026-01-16 03:45:05', 'Pink');
INSERT INTO `product_images` VALUES (498, 18, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-04-2667859c-5d1e-4369-acfd-fb128ba6ea12.jpg?v=1712173564713', NULL, 0, 0, 1, '2026-01-16 03:45:14', 'Pink');
INSERT INTO `product_images` VALUES (499, 18, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-07-9786d752-1996-45a6-9197-b39f01db89d1.jpg?v=1712173564713', NULL, 0, 0, 1, '2026-01-16 03:45:21', 'Pink');
INSERT INTO `product_images` VALUES (500, 18, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-08-d05fec89-4d5a-4b00-8e75-b1012cea41a1.jpg?v=1712173564713', NULL, 0, 0, 1, '2026-01-16 03:45:30', 'Pink');
INSERT INTO `product_images` VALUES (501, 17, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-41-detail-1.jpg?v=1704620734047', NULL, 0, 0, 1, '2026-01-16 03:48:17', 'Beige');
INSERT INTO `product_images` VALUES (502, 17, 'https://bizweb.dktcdn.net/100/347/092/products/x-plr-shoes-beige-by9255-42-detail-1.jpg?v=1704620734553', NULL, 0, 0, 1, '2026-01-16 03:48:23', 'Beige');
INSERT INTO `product_images` VALUES (503, 17, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-falcon-w-ef4988-01.jpg', NULL, 0, 0, 1, '2026-01-16 03:48:45', 'Black');
INSERT INTO `product_images` VALUES (504, 17, 'https://bizweb.dktcdn.net/thumb/small/100/347/092/products/adidas-falcon-w-ef4988-02.jpg?v=1606793579687', NULL, 0, 0, 1, '2026-01-16 03:48:55', 'Black');
INSERT INTO `product_images` VALUES (505, 17, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-falcon-w-ef4988-03.jpg?v=1606793580247', NULL, 0, 0, 1, '2026-01-16 03:49:01', 'Black');
INSERT INTO `product_images` VALUES (506, 17, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-falcon-w-ef4988-04.jpg?v=1606793581247', NULL, 0, 0, 1, '2026-01-16 03:49:07', 'Black');
INSERT INTO `product_images` VALUES (507, 17, 'https://bizweb.dktcdn.net/thumb/small/100/347/092/products/adidas-falcon-w-ef4988-08.jpg?v=1606793584617', NULL, 0, 0, 1, '2026-01-16 03:49:17', 'Black');
INSERT INTO `product_images` VALUES (508, 17, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-falcon-w-ef4988-07.jpg?v=1606793583627', NULL, 0, 0, 1, '2026-01-16 03:49:23', 'Black');
INSERT INTO `product_images` VALUES (509, 16, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-tensor-eg4126-07.jpg?v=1609759582723', NULL, 0, 0, 1, '2026-01-16 03:50:36', 'Pink');
INSERT INTO `product_images` VALUES (510, 16, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-tensor-eg4126-05.jpg?v=1609759581727', NULL, 0, 0, 1, '2026-01-16 03:50:43', 'Pink');
INSERT INTO `product_images` VALUES (511, 16, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-tensor-eg4126-04.jpg?v=1609759581187', NULL, 0, 0, 1, '2026-01-16 03:50:51', 'Pink');
INSERT INTO `product_images` VALUES (512, 16, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/qt-racer-2-0-trang-fw7285-01-standard.jpg?v=1618601616107', NULL, 0, 0, 1, '2026-01-16 03:51:08', 'White');
INSERT INTO `product_images` VALUES (513, 16, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-qt-adiracer-2-0-fw7285-03.jpg?v=1618601618037', NULL, 0, 0, 1, '2026-01-16 03:51:13', 'White');
INSERT INTO `product_images` VALUES (514, 16, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-qt-adiracer-2-0-fw7285-04.jpg?v=1618601618037', NULL, 0, 0, 1, '2026-01-16 03:51:19', 'White');
INSERT INTO `product_images` VALUES (515, 16, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-qt-adiracer-2-0-fw7285-06.jpg?v=1618601618037', NULL, 0, 0, 1, '2026-01-16 03:51:25', 'White');
INSERT INTO `product_images` VALUES (516, 16, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-qt-adiracer-2-0-fw7285-05.jpg?v=1618601618037', NULL, 0, 0, 1, '2026-01-16 03:51:31', 'White');
INSERT INTO `product_images` VALUES (517, 15, 'https://bizweb.dktcdn.net/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-1-1.jpg?v=1740722672877', NULL, 0, 0, 1, '2026-01-16 03:52:32', 'Brown');
INSERT INTO `product_images` VALUES (518, 15, 'https://bizweb.dktcdn.net/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs-1.jpg?v=1740722682260', NULL, 0, 0, 1, '2026-01-16 03:52:38', 'Brown');
INSERT INTO `product_images` VALUES (519, 15, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-01-standard.jpg', NULL, 0, 0, 1, '2026-01-16 03:52:55', 'Green');
INSERT INTO `product_images` VALUES (520, 15, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-06-standard.jpg?v=1711029912980', NULL, 0, 0, 1, '2026-01-16 03:53:00', 'Green');
INSERT INTO `product_images` VALUES (521, 15, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-02-standard-hover.jpg?v=1711029914233', NULL, 0, 0, 1, '2026-01-16 03:53:05', 'Green');
INSERT INTO `product_images` VALUES (522, 15, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-41-detail.jpg?v=1711029916087', NULL, 0, 0, 1, '2026-01-16 03:53:13', 'Green');
INSERT INTO `product_images` VALUES (523, 15, 'https://bizweb.dktcdn.net/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-05-standard.jpg?v=1711029917287', NULL, 0, 0, 1, '2026-01-16 03:53:20', 'Green');
INSERT INTO `product_images` VALUES (524, 14, 'https://bizweb.dktcdn.net/100/347/092/products/d52df393-e3bb-4529-86d1-b5ac3bc441e6.jpg?v=1768395633240', NULL, 0, 0, 1, '2026-01-16 03:54:19', 'Beige');
INSERT INTO `product_images` VALUES (525, 14, 'https://bizweb.dktcdn.net/100/347/092/products/7a94b0f4-1903-41f8-b43f-0bdc9e7d5c55.jpg?v=1768395635320', NULL, 0, 0, 1, '2026-01-16 03:54:28', 'Beige');
INSERT INTO `product_images` VALUES (526, 14, 'https://bizweb.dktcdn.net/100/347/092/products/3c3bea06-f5c0-4466-857b-07d5e723813c.jpg?v=1768395635320', NULL, 0, 0, 1, '2026-01-16 03:54:35', 'Beige');
INSERT INTO `product_images` VALUES (527, 14, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-nike-dunk-low-retro-dd1391-103-1.jpg', NULL, 0, 0, 1, '2026-01-16 03:54:57', 'Lavender');
INSERT INTO `product_images` VALUES (528, 14, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-dunk-low-retro-dd1391-103-2.jpg?v=1734536249073', NULL, 0, 0, 1, '2026-01-16 03:55:05', 'Lavender');
INSERT INTO `product_images` VALUES (529, 14, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-dunk-low-retro-dd1391-103-3.jpg?v=1734536249823', NULL, 0, 0, 1, '2026-01-16 03:55:11', 'Lavender');
INSERT INTO `product_images` VALUES (530, 14, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-dunk-low-retro-dd1391-103-4.jpg?v=1734536250610', NULL, 0, 0, 1, '2026-01-16 03:55:17', 'Lavender');
INSERT INTO `product_images` VALUES (531, 14, 'https://bizweb.dktcdn.net/100/347/092/products/giay-nike-dunk-low-retro-dd1391-103-6.jpg?v=1734536251920', NULL, 0, 0, 1, '2026-01-16 03:55:23', 'Lavender');
INSERT INTO `product_images` VALUES (532, 13, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-6.jpg?v=1766432458263', NULL, 0, 0, 1, '2026-01-16 03:56:46', 'White');
INSERT INTO `product_images` VALUES (533, 13, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-5.jpg?v=1766432457453', NULL, 0, 0, 1, '2026-01-16 03:56:53', 'White');
INSERT INTO `product_images` VALUES (534, 13, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/s-l1600-3-11zon-4efaccd1-ef65-41c9-ae71-c315a9ef6ad0.jpg', NULL, 0, 0, 1, '2026-01-16 03:57:08', 'Red');
INSERT INTO `product_images` VALUES (535, 13, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-11zon-be7aa8e7-029e-4c09-9d5b-e29fcc89c3be.jpg?v=1766476850843', NULL, 0, 0, 1, '2026-01-16 03:57:14', 'Red');
INSERT INTO `product_images` VALUES (536, 13, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-4-11zon-4cd0d970-ac29-4337-8559-43707a7d650b.jpg?v=1766476850843', NULL, 0, 0, 1, '2026-01-16 03:57:22', 'Red');
INSERT INTO `product_images` VALUES (537, 13, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-1-11zon-c3223d68-9d9b-4e52-99a2-b978ab564f9e.jpg?v=1766476853923', NULL, 0, 0, 1, '2026-01-16 03:57:28', 'Red');
INSERT INTO `product_images` VALUES (538, 13, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-2-11zon-128f0448-9bbc-4ad7-af84-16279804bfb9.jpg?v=1766476853923', NULL, 0, 0, 1, '2026-01-16 03:57:35', 'Red');
INSERT INTO `product_images` VALUES (539, 12, 'https://bizweb.dktcdn.net/100/347/092/products/wch996u6-1.jpg?v=1757310423263', NULL, 0, 0, 1, '2026-01-16 03:58:29', 'Blue');
INSERT INTO `product_images` VALUES (540, 12, 'https://bizweb.dktcdn.net/100/347/092/products/new-balance-fuelcell-996v6-wch996u6-6.jpg?v=1755979211553', NULL, 0, 0, 1, '2026-01-16 03:58:50', 'Blue');
INSERT INTO `product_images` VALUES (541, 12, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/mch796n4-nb-02-1.jpg', NULL, 0, 0, 1, '2026-01-16 03:59:10', 'White');
INSERT INTO `product_images` VALUES (542, 12, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-2.jpg?v=1766432453887', NULL, 0, 0, 1, '2026-01-16 03:59:15', 'White');
INSERT INTO `product_images` VALUES (543, 12, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-3.jpg?v=1766432455387', NULL, 0, 0, 1, '2026-01-16 03:59:21', 'White');
INSERT INTO `product_images` VALUES (544, 12, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-4.jpg?v=1766432456203', NULL, 0, 0, 1, '2026-01-16 03:59:26', 'White');
INSERT INTO `product_images` VALUES (545, 12, 'https://bizweb.dktcdn.net/100/347/092/products/mch796n4-nb-02-6.jpg?v=1766432458263', NULL, 0, 0, 1, '2026-01-16 03:59:32', 'White');
INSERT INTO `product_images` VALUES (546, 11, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-04-2667859c-5d1e-4369-acfd-fb128ba6ea12.jpg?v=1712173564713', NULL, 0, 0, 1, '2026-01-16 04:00:39', 'Pink');
INSERT INTO `product_images` VALUES (547, 11, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-05-958671e5-eb6a-4d78-a2f0-48f025927633.jpg?v=1712173564713', NULL, 0, 0, 1, '2026-01-16 04:00:47', 'Pink');
INSERT INTO `product_images` VALUES (548, 11, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-revolution-5-womens-running-shoe-bq3204-103-01.jpg', NULL, 0, 0, 1, '2026-01-16 04:00:58', 'White');
INSERT INTO `product_images` VALUES (549, 11, 'https://bizweb.dktcdn.net/100/347/092/products/nike-revolution-5-womens-running-shoe-bq3204-103-02.jpg?v=1679252003140', NULL, 0, 0, 1, '2026-01-16 04:01:02', 'White');
INSERT INTO `product_images` VALUES (550, 11, 'https://bizweb.dktcdn.net/100/347/092/products/nike-revolution-5-womens-running-shoe-bq3204-103-03.jpg?v=1679252003787', NULL, 0, 0, 1, '2026-01-16 04:01:10', 'White');
INSERT INTO `product_images` VALUES (551, 11, 'https://bizweb.dktcdn.net/100/347/092/products/nike-revolution-5-womens-running-shoe-bq3204-103-04.jpg?v=1679252004367', NULL, 0, 0, 1, '2026-01-16 04:01:16', 'White');
INSERT INTO `product_images` VALUES (552, 11, 'https://bizweb.dktcdn.net/100/347/092/products/nike-revolution-5-womens-running-shoe-bq3204-103-05.jpg?v=1679252004840', NULL, 0, 0, 1, '2026-01-16 04:01:23', 'White');
INSERT INTO `product_images` VALUES (553, 10, 'https://bizweb.dktcdn.net/100/347/092/products/k1ga214401.jpg?v=1731244819500', NULL, 0, 0, 1, '2026-01-16 04:06:01', 'White');
INSERT INTO `product_images` VALUES (554, 10, 'https://bizweb.dktcdn.net/100/347/092/products/k1ga214401-2.jpg?v=1731244818317', NULL, 0, 0, 1, '2026-01-16 04:06:09', 'White');
INSERT INTO `product_images` VALUES (555, 10, 'https://bizweb.dktcdn.net/100/347/092/products/k1ga214401-1.jpg?v=1731244778880', NULL, 0, 0, 1, '2026-01-16 04:12:09', 'White');
INSERT INTO `product_images` VALUES (557, 10, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/ultraboost-light-shoes-black-id2932-hm1.jpg', NULL, 0, 0, 1, '2026-01-16 04:12:37', 'Black');
INSERT INTO `product_images` VALUES (558, 10, 'https://bizweb.dktcdn.net/100/347/092/products/ultraboost-light-shoes-black-id2932-hm3-hover.jpg?v=1704539346687', NULL, 0, 0, 1, '2026-01-16 04:12:43', 'Black');
INSERT INTO `product_images` VALUES (559, 10, 'https://bizweb.dktcdn.net/100/347/092/products/ultraboost-light-shoes-black-id2932-hm5.jpg?v=1704539348100', NULL, 0, 0, 1, '2026-01-16 04:12:47', 'Black');
INSERT INTO `product_images` VALUES (560, 10, 'https://bizweb.dktcdn.net/100/347/092/products/ultraboost-light-shoes-black-id2932-hm6.jpg?v=1704539348757', NULL, 0, 0, 1, '2026-01-16 04:12:55', 'Black');
INSERT INTO `product_images` VALUES (561, 10, 'https://bizweb.dktcdn.net/100/347/092/products/ultraboost-light-shoes-black-id2932-hm8.jpg?v=1704539349717', NULL, 0, 0, 1, '2026-01-16 04:13:05', 'Black');
INSERT INTO `product_images` VALUES (562, 2, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-04-884ee4b9-78f1-44c5-b0ff-d7df728f6000.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 04:14:13', 'Black');
INSERT INTO `product_images` VALUES (563, 2, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-03-70b40d8a-8bd0-469b-84e3-6a4ba0a5d6f9.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 04:14:20', 'Black');
INSERT INTO `product_images` VALUES (564, 2, 'https://bizweb.dktcdn.net/100/347/092/products/z-f36199-05-eb36cd2e-804a-4b42-9efb-93137a65315a.jpg?v=1712215775217', NULL, 0, 0, 1, '2026-01-16 04:14:34', 'Black');
INSERT INTO `product_images` VALUES (565, 2, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-sl20.jpg?v=1649244897697', NULL, 0, 0, 1, '2026-01-16 04:14:46', 'Blue');
INSERT INTO `product_images` VALUES (566, 2, 'https://bizweb.dktcdn.net/100/347/092/products/sl20-2-shoes-blue-fz2492-02-standard-hover.jpg?v=1649244898153', NULL, 0, 0, 1, '2026-01-16 04:14:53', 'Blue');
INSERT INTO `product_images` VALUES (567, 2, 'https://bizweb.dktcdn.net/100/347/092/products/sl20-2-shoes-blue-fz2492-03-standard.jpg?v=1649244898617', NULL, 0, 0, 1, '2026-01-16 04:14:58', 'Blue');
INSERT INTO `product_images` VALUES (568, 2, 'https://bizweb.dktcdn.net/100/347/092/products/sl20-2-shoes-blue-fz2492-04-standard.jpg?v=1649244898920', NULL, 0, 0, 1, '2026-01-16 04:15:04', 'Blue');
INSERT INTO `product_images` VALUES (569, 2, 'https://bizweb.dktcdn.net/100/347/092/products/sl20-2-shoes-blue-fz2492-06-standard.jpg?v=1649244899677', NULL, 0, 0, 1, '2026-01-16 04:15:13', 'Blue');
INSERT INTO `product_images` VALUES (570, 3, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-force-1-gs-white-black-ct3839-100-02.jpg?v=1681810446247', NULL, 0, 0, 1, '2026-01-16 04:17:34', 'White');
INSERT INTO `product_images` VALUES (571, 3, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-force-1-gs-white-black-ct3839-100-03.jpg?v=1681810446873', NULL, 0, 0, 1, '2026-01-16 04:17:41', 'White');
INSERT INTO `product_images` VALUES (572, 3, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-force-1-gs-white-black-ct3839-100-04.jpg?v=1681810447663', NULL, 0, 0, 1, '2026-01-16 04:17:46', 'White');
INSERT INTO `product_images` VALUES (573, 3, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-force-1-gs-white-black-ct3839-100-05.jpg?v=1681810448473', NULL, 0, 0, 1, '2026-01-16 04:18:00', 'White');
INSERT INTO `product_images` VALUES (574, 3, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-air-zoom-pegasus-37-running-bq9646-004-01.jpg', NULL, 0, 0, 1, '2026-01-16 04:18:16', 'Black');
INSERT INTO `product_images` VALUES (575, 3, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-37-running-bq9646-004-02.jpg?v=1679254204573', NULL, 0, 0, 1, '2026-01-16 04:18:22', 'Black');
INSERT INTO `product_images` VALUES (576, 3, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-37-running-bq9646-004-03.jpg?v=1679254204573', NULL, 0, 0, 1, '2026-01-16 04:18:28', 'Black');
INSERT INTO `product_images` VALUES (577, 3, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-37-running-bq9646-004-04.jpg?v=1679254204573', NULL, 0, 0, 1, '2026-01-16 04:18:33', 'Black');
INSERT INTO `product_images` VALUES (578, 3, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-37-running-bq9646-004-05.jpg?v=1679254204573', NULL, 0, 0, 1, '2026-01-16 04:18:40', 'Black');
INSERT INTO `product_images` VALUES (579, 9, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-eg0713-03.jpg?v=1611978277637', NULL, 0, 0, 1, '2026-01-16 04:21:26', 'White');
INSERT INTO `product_images` VALUES (580, 9, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-eg0713-05.jpg?v=1611978278390', NULL, 0, 0, 1, '2026-01-16 04:21:33', 'White');
INSERT INTO `product_images` VALUES (581, 9, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-eg0713-06.jpg?v=1611978278663', NULL, 0, 0, 1, '2026-01-16 04:21:38', 'White');
INSERT INTO `product_images` VALUES (582, 9, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-eg0713-07.jpg?v=1611978278937', NULL, 0, 0, 1, '2026-01-16 04:21:44', 'White');
INSERT INTO `product_images` VALUES (583, 9, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/8bf013bf-6b92-4d4b-844c-cb2495024bfa.jpg', NULL, 0, 0, 1, '2026-01-16 04:21:57', 'Beige');
INSERT INTO `product_images` VALUES (584, 9, 'https://bizweb.dktcdn.net/100/347/092/products/8ddf7247-21e0-4263-9836-671459e808fc.jpg?v=1768395629403', NULL, 0, 0, 1, '2026-01-16 04:22:02', 'Beige');
INSERT INTO `product_images` VALUES (585, 9, 'https://bizweb.dktcdn.net/100/347/092/products/aa25ab72-9808-4aa2-a6ae-c4dddd610572.jpg?v=1768395631890', NULL, 0, 0, 1, '2026-01-16 04:22:06', 'Beige');
INSERT INTO `product_images` VALUES (586, 9, 'https://bizweb.dktcdn.net/100/347/092/products/d52df393-e3bb-4529-86d1-b5ac3bc441e6.jpg?v=1768395633240', NULL, 0, 0, 1, '2026-01-16 04:22:11', 'Beige');
INSERT INTO `product_images` VALUES (587, 9, 'https://bizweb.dktcdn.net/100/347/092/products/3c3bea06-f5c0-4466-857b-07d5e723813c.jpg?v=1768395635320', NULL, 0, 0, 1, '2026-01-16 04:22:16', 'Beige');
INSERT INTO `product_images` VALUES (588, 8, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-superstar-fv3290-03.jpg?v=1641020680080', NULL, 0, 0, 1, '2026-01-16 04:24:04', 'Black');
INSERT INTO `product_images` VALUES (589, 8, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-superstar-fv3290-04.jpg?v=1641020680537', NULL, 0, 0, 1, '2026-01-16 04:24:10', 'Black');
INSERT INTO `product_images` VALUES (590, 8, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-superstar-fv3290-05.jpg?v=1641020681120', NULL, 0, 0, 1, '2026-01-16 04:24:17', 'Black');
INSERT INTO `product_images` VALUES (591, 8, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-superstar-fv3290-06.jpg?v=1641020681633', NULL, 0, 0, 1, '2026-01-16 04:24:24', 'Black');
INSERT INTO `product_images` VALUES (592, 8, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/zz-ef0213-01.jpg', NULL, 0, 0, 1, '2026-01-16 04:24:42', 'White');
INSERT INTO `product_images` VALUES (593, 8, 'https://bizweb.dktcdn.net/100/347/092/products/zz-ef0213-02.jpg?v=1581248816070', NULL, 0, 0, 1, '2026-01-16 04:24:48', 'White');
INSERT INTO `product_images` VALUES (594, 8, 'https://bizweb.dktcdn.net/100/347/092/products/zz-ef0213-03.jpg?v=1581248816543', NULL, 0, 0, 1, '2026-01-16 04:24:54', 'White');
INSERT INTO `product_images` VALUES (595, 8, 'https://bizweb.dktcdn.net/100/347/092/products/zz-ef0213-04.jpg?v=1581248816907', NULL, 0, 0, 1, '2026-01-16 04:25:01', 'White');
INSERT INTO `product_images` VALUES (596, 8, 'https://bizweb.dktcdn.net/100/347/092/products/zz-ef0213-05.jpg?v=1581248817227', NULL, 0, 0, 1, '2026-01-16 04:25:09', 'White');
INSERT INTO `product_images` VALUES (597, 7, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nvfgn-02.jpg?v=1715502720517', NULL, 0, 0, 1, '2026-01-16 04:27:33', 'Green');
INSERT INTO `product_images` VALUES (598, 7, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nvfgn-03.jpg?v=1715502721263', NULL, 0, 0, 1, '2026-01-16 04:27:38', 'Green');
INSERT INTO `product_images` VALUES (599, 7, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nvfgn-04.jpg?v=1715502722113', NULL, 0, 0, 1, '2026-01-16 04:27:44', 'Green');
INSERT INTO `product_images` VALUES (600, 7, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nvfgn-05.jpg?v=1715502723040', NULL, 0, 0, 1, '2026-01-16 04:27:50', 'Green');
INSERT INTO `product_images` VALUES (601, 7, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nvfgn-06.jpg?v=1715502723833', NULL, 0, 0, 1, '2026-01-16 04:27:56', 'Green');
INSERT INTO `product_images` VALUES (602, 7, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-vans-vn0007nty52-01.jpg', NULL, 0, 0, 1, '2026-01-16 04:28:05', 'Red');
INSERT INTO `product_images` VALUES (603, 7, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nty52-02.jpg?v=1715501860317', NULL, 0, 0, 1, '2026-01-16 04:28:10', 'Red');
INSERT INTO `product_images` VALUES (604, 7, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nty52-03.jpg?v=1715501861110', NULL, 0, 0, 1, '2026-01-16 04:28:15', 'Red');
INSERT INTO `product_images` VALUES (605, 7, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nty52-04.jpg?v=1715501861907', NULL, 0, 0, 1, '2026-01-16 04:28:20', 'Red');
INSERT INTO `product_images` VALUES (606, 7, 'https://bizweb.dktcdn.net/100/347/092/products/giay-vans-vn0007nty52-05.jpg?v=1715501862833', NULL, 0, 0, 1, '2026-01-16 04:28:26', 'Red');
INSERT INTO `product_images` VALUES (607, 6, 'https://bizweb.dktcdn.net/100/347/092/products/giay-puma-pounce-lite-sneakers-310778-14-2.jpg?v=1738945330490', NULL, 0, 0, 1, '2026-01-16 04:30:25', 'Black');
INSERT INTO `product_images` VALUES (608, 6, 'https://bizweb.dktcdn.net/100/347/092/products/giay-puma-pounce-lite-sneakers-310778-14-3.jpg?v=1738945332317', NULL, 0, 0, 1, '2026-01-16 04:30:30', 'Black');
INSERT INTO `product_images` VALUES (609, 6, 'https://bizweb.dktcdn.net/100/347/092/products/giay-puma-pounce-lite-sneakers-310778-14-4.jpg?v=1738945334350', NULL, 0, 0, 1, '2026-01-16 04:30:35', 'Black');
INSERT INTO `product_images` VALUES (610, 6, 'https://bizweb.dktcdn.net/100/347/092/products/giay-puma-pounce-lite-sneakers-310778-14-5.jpg?v=1738945336210', NULL, 0, 0, 1, '2026-01-16 04:30:44', 'Black');
INSERT INTO `product_images` VALUES (611, 6, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/s-l1600-3-11zon-4efaccd1-ef65-41c9-ae71-c315a9ef6ad0.jpg', NULL, 0, 0, 1, '2026-01-16 04:31:09', 'Red');
INSERT INTO `product_images` VALUES (612, 6, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-11zon-be7aa8e7-029e-4c09-9d5b-e29fcc89c3be.jpg?v=1766476850843', NULL, 0, 0, 1, '2026-01-16 04:31:13', 'Red');
INSERT INTO `product_images` VALUES (613, 6, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-4-11zon-4cd0d970-ac29-4337-8559-43707a7d650b.jpg?v=1766476850843', NULL, 0, 0, 1, '2026-01-16 04:31:19', 'Red');
INSERT INTO `product_images` VALUES (614, 6, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-1-11zon-c3223d68-9d9b-4e52-99a2-b978ab564f9e.jpg?v=1766476853923', NULL, 0, 0, 1, '2026-01-16 04:31:26', 'Red');
INSERT INTO `product_images` VALUES (615, 6, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-2-11zon-128f0448-9bbc-4ad7-af84-16279804bfb9.jpg?v=1766476853923', NULL, 0, 0, 1, '2026-01-16 04:31:32', 'Red');
INSERT INTO `product_images` VALUES (616, 5, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-jordan-1-low-553558-147-2.jpg?v=1768322978887', NULL, 0, 0, 1, '2026-01-16 04:33:32', 'Green');
INSERT INTO `product_images` VALUES (617, 5, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-jordan-1-low-553558-147-3.jpg?v=1768322979953', NULL, 0, 0, 1, '2026-01-16 04:33:37', 'Green');
INSERT INTO `product_images` VALUES (618, 5, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-jordan-1-low-553558-147-4.jpg?v=1768322980867', NULL, 0, 0, 1, '2026-01-16 04:33:42', 'Green');
INSERT INTO `product_images` VALUES (619, 5, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-jordan-1-low-553558-147-5.jpg?v=1768322981807', NULL, 0, 0, 1, '2026-01-16 04:33:49', 'Green');
INSERT INTO `product_images` VALUES (620, 5, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/fb2598-101-01.jpg', NULL, 0, 0, 1, '2026-01-16 04:34:03', 'White');
INSERT INTO `product_images` VALUES (621, 5, 'https://bizweb.dktcdn.net/100/347/092/products/fb2598-101-02.jpg?v=1710061265467', NULL, 0, 0, 1, '2026-01-16 04:34:11', 'White');
INSERT INTO `product_images` VALUES (622, 5, 'https://bizweb.dktcdn.net/100/347/092/products/fb2598-101-03.jpg?v=1710061266370', NULL, 0, 0, 1, '2026-01-16 04:34:16', 'White');
INSERT INTO `product_images` VALUES (623, 5, 'https://bizweb.dktcdn.net/100/347/092/products/fb2598-101-04.jpg?v=1710061267553', NULL, 0, 0, 1, '2026-01-16 04:34:22', 'White');
INSERT INTO `product_images` VALUES (624, 5, 'https://bizweb.dktcdn.net/100/347/092/products/fb2598-101-05.jpg?v=1710061268690', NULL, 0, 0, 1, '2026-01-16 04:34:29', 'White');
INSERT INTO `product_images` VALUES (625, 4, 'https://bizweb.dktcdn.net/100/347/092/products/response-super-djen-fx4833-06.jpg?v=1622030220267', NULL, 0, 0, 1, '2026-01-16 04:35:51', 'Black');
INSERT INTO `product_images` VALUES (626, 4, 'https://bizweb.dktcdn.net/100/347/092/products/response-super-djen-fx4833-02.jpg?v=1622030220267', NULL, 0, 0, 1, '2026-01-16 04:35:56', 'Black');
INSERT INTO `product_images` VALUES (627, 4, 'https://bizweb.dktcdn.net/100/347/092/products/response-super-djen-fx4833-03.jpg?v=1622030220267', NULL, 0, 0, 1, '2026-01-16 04:36:01', 'Black');
INSERT INTO `product_images` VALUES (628, 4, 'https://bizweb.dktcdn.net/100/347/092/products/response-super-djen-fx4833-04.jpg?v=1622030220267', NULL, 0, 0, 1, '2026-01-16 04:36:08', 'Black');
INSERT INTO `product_images` VALUES (629, 4, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/9e9335f3c9def8b6c34da1fb735c13f4-472x497.jpg', NULL, 0, 0, 1, '2026-01-16 04:36:24', 'Navy');
INSERT INTO `product_images` VALUES (630, 4, 'https://bizweb.dktcdn.net/100/347/092/products/94a4ef10be5c7bb3a0db85c10fa9b7f7-472x497-1.jpg?v=1705130111020', NULL, 0, 0, 1, '2026-01-16 04:36:30', 'Navy');
INSERT INTO `product_images` VALUES (631, 4, 'https://bizweb.dktcdn.net/100/347/092/products/ef40c4c4664901acbba9cf9dd6bbe800-472x497.jpg?v=1705130007890', NULL, 0, 0, 1, '2026-01-16 04:36:35', 'Navy');
INSERT INTO `product_images` VALUES (632, 4, 'https://bizweb.dktcdn.net/100/347/092/products/a6f1722d435cf4875ca858980d8a69bf-472x497.jpg?v=1705130007890', NULL, 0, 0, 1, '2026-01-16 04:36:40', 'Navy');
INSERT INTO `product_images` VALUES (633, 4, 'https://bizweb.dktcdn.net/100/347/092/products/6a86001a20a7c13491c5d69efd31bf74-472x497.jpg?v=1705130007890', NULL, 0, 0, 1, '2026-01-16 04:36:48', 'Navy');

-- ----------------------------
-- Table structure for product_specs
-- ----------------------------
DROP TABLE IF EXISTS `product_specs`;
CREATE TABLE `product_specs`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `spec_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `spec_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sort_order` int NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product_specs_product`(`product_id` ASC, `sort_order` ASC) USING BTREE,
  CONSTRAINT `fk_product_specs_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 305 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_specs
-- ----------------------------
INSERT INTO `product_specs` VALUES (1, 1, 'Chất liệu Upper', 'Mesh thoáng khí', 1, '2025-12-21 22:18:01', '2025-12-21 22:18:01');
INSERT INTO `product_specs` VALUES (2, 1, 'Đế ngoài', 'Cao su chống trượt', 2, '2025-12-21 22:18:01', '2025-12-21 22:18:01');
INSERT INTO `product_specs` VALUES (3, 1, 'Công nghệ đệm', 'Air Zoom', 3, '2025-12-21 22:18:01', '2025-12-21 22:18:01');
INSERT INTO `product_specs` VALUES (4, 1, 'Mục đích', 'Chạy bộ đường trường', 4, '2025-12-21 22:18:01', '2025-12-21 22:18:01');
INSERT INTO `product_specs` VALUES (5, 11, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (6, 11, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (7, 11, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (8, 11, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (9, 11, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (10, 11, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (11, 12, 'Chất liệu upper', 'Da tổng hợp', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (12, 12, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (13, 12, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (14, 12, 'Form', 'True to size (chuẩn size)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (15, 12, 'Xuất xứ', 'Thái Lan', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (16, 12, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (17, 13, 'Chất liệu upper', 'Da tổng hợp', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (18, 13, 'Đế ngoài', 'EVA + Rubber', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (19, 13, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (20, 13, 'Form', 'Rộng nhẹ', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (21, 13, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (22, 13, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (23, 14, 'Chất liệu upper', 'Da tổng hợp', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (24, 14, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (25, 14, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (26, 14, 'Form', 'Rộng nhẹ', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (27, 14, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (28, 14, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (29, 15, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (30, 15, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (31, 15, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (32, 15, 'Form', 'Ôm chân', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (33, 15, 'Xuất xứ', 'Thái Lan', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (34, 15, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (35, 16, 'Chất liệu upper', 'Canvas (vải bố)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (36, 16, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (37, 16, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (38, 16, 'Form', 'Ôm chân', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (39, 16, 'Xuất xứ', 'Việt Nam', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (40, 16, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (41, 17, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (42, 17, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (43, 17, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (44, 17, 'Form', 'True to size (chuẩn size)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (45, 17, 'Xuất xứ', 'Việt Nam', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (46, 17, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (47, 18, 'Chất liệu upper', 'Da tổng hợp', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (48, 18, 'Đế ngoài', 'Phylon nhẹ', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (49, 18, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (50, 18, 'Form', 'True to size (chuẩn size)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (51, 18, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (52, 18, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (53, 19, 'Chất liệu upper', 'Canvas (vải bố)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (54, 19, 'Đế ngoài', 'EVA + Rubber', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (55, 19, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (56, 19, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (57, 19, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (58, 19, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (59, 20, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (60, 20, 'Đế ngoài', 'Phylon nhẹ', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (61, 20, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (62, 20, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (63, 20, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (64, 20, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (65, 21, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (66, 21, 'Đế ngoài', 'EVA + Rubber', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (67, 21, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (68, 21, 'Form', 'True to size (chuẩn size)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (69, 21, 'Xuất xứ', 'Thái Lan', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (70, 21, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (71, 22, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (72, 22, 'Đế ngoài', 'Phylon nhẹ', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (73, 22, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (74, 22, 'Form', 'True to size (chuẩn size)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (75, 22, 'Xuất xứ', 'Việt Nam', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (76, 22, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (77, 23, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (78, 23, 'Đế ngoài', 'TPU ổn định', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (79, 23, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (80, 23, 'Form', 'Rộng nhẹ', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (81, 23, 'Xuất xứ', 'Thái Lan', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (82, 23, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (83, 24, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (84, 24, 'Đế ngoài', 'EVA + Rubber', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (85, 24, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (86, 24, 'Form', 'Rộng nhẹ', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (87, 24, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (88, 24, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (89, 25, 'Chất liệu upper', 'Da tổng hợp', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (90, 25, 'Đế ngoài', 'EVA + Rubber', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (91, 25, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (92, 25, 'Form', 'Ôm chân', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (93, 25, 'Xuất xứ', 'Trung Quốc', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (94, 25, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (95, 26, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (96, 26, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (97, 26, 'Công nghệ đệm', 'Foam êm', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (98, 26, 'Form', 'Ôm chân', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (99, 26, 'Xuất xứ', 'Việt Nam', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (100, 26, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (101, 27, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (102, 27, 'Đế ngoài', 'EVA + Rubber', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (103, 27, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (104, 27, 'Form', 'Ôm chân', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (105, 27, 'Xuất xứ', 'Thái Lan', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (106, 27, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (107, 28, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (108, 28, 'Đế ngoài', 'EVA + Rubber', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (109, 28, 'Công nghệ đệm', 'Foam êm', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (110, 28, 'Form', 'Ôm chân', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (111, 28, 'Xuất xứ', 'Thái Lan', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (112, 28, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (113, 29, 'Chất liệu upper', 'Canvas (vải bố)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (114, 29, 'Đế ngoài', 'TPU ổn định', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (115, 29, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (116, 29, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (117, 29, 'Xuất xứ', 'Việt Nam', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (118, 29, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (119, 30, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (120, 30, 'Đế ngoài', 'TPU ổn định', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (121, 30, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (122, 30, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (123, 30, 'Xuất xứ', 'Trung Quốc', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (124, 30, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (125, 31, 'Chất liệu upper', 'Da tổng hợp', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (126, 31, 'Đế ngoài', 'Phylon nhẹ', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (127, 31, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (128, 31, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (129, 31, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (130, 31, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (131, 32, 'Chất liệu upper', 'Canvas (vải bố)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (132, 32, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (133, 32, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (134, 32, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (135, 32, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (136, 32, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (137, 33, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (138, 33, 'Đế ngoài', 'Phylon nhẹ', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (139, 33, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (140, 33, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (141, 33, 'Xuất xứ', 'Trung Quốc', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (142, 33, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (143, 34, 'Chất liệu upper', 'Da tổng hợp', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (144, 34, 'Đế ngoài', 'EVA + Rubber', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (145, 34, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (146, 34, 'Form', 'Rộng nhẹ', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (147, 34, 'Xuất xứ', 'Trung Quốc', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (148, 34, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (149, 35, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (150, 35, 'Đế ngoài', 'Phylon nhẹ', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (151, 35, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (152, 35, 'Form', 'True to size (chuẩn size)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (153, 35, 'Xuất xứ', 'Trung Quốc', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (154, 35, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (155, 36, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (156, 36, 'Đế ngoài', 'Phylon nhẹ', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (157, 36, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (158, 36, 'Form', 'True to size (chuẩn size)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (159, 36, 'Xuất xứ', 'Thái Lan', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (160, 36, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (161, 37, 'Chất liệu upper', 'Canvas (vải bố)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (162, 37, 'Đế ngoài', 'TPU ổn định', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (163, 37, 'Công nghệ đệm', 'Foam êm', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (164, 37, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (165, 37, 'Xuất xứ', 'Việt Nam', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (166, 37, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (167, 38, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (168, 38, 'Đế ngoài', 'EVA + Rubber', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (169, 38, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (170, 38, 'Form', 'Rộng nhẹ', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (171, 38, 'Xuất xứ', 'Trung Quốc', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (172, 38, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (173, 39, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (174, 39, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (175, 39, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (176, 39, 'Form', 'True to size (chuẩn size)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (177, 39, 'Xuất xứ', 'Việt Nam', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (178, 39, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (179, 40, 'Chất liệu upper', 'Da tổng hợp', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (180, 40, 'Đế ngoài', 'Phylon nhẹ', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (181, 40, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (182, 40, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (183, 40, 'Xuất xứ', 'Trung Quốc', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (184, 40, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (185, 41, 'Chất liệu upper', 'Da tổng hợp', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (186, 41, 'Đế ngoài', 'TPU ổn định', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (187, 41, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (188, 41, 'Form', 'True to size (chuẩn size)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (189, 41, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (190, 41, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (191, 42, 'Chất liệu upper', 'Da tổng hợp', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (192, 42, 'Đế ngoài', 'Phylon nhẹ', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (193, 42, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (194, 42, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (195, 42, 'Xuất xứ', 'Trung Quốc', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (196, 42, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (197, 43, 'Chất liệu upper', 'Da tổng hợp', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (198, 43, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (199, 43, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (200, 43, 'Form', 'Rộng nhẹ', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (201, 43, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (202, 43, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (203, 44, 'Chất liệu upper', 'Da tổng hợp', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (204, 44, 'Đế ngoài', 'EVA + Rubber', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (205, 44, 'Công nghệ đệm', 'Foam êm', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (206, 44, 'Form', 'Rộng nhẹ', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (207, 44, 'Xuất xứ', 'Thái Lan', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (208, 44, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (209, 45, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (210, 45, 'Đế ngoài', 'Phylon nhẹ', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (211, 45, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (212, 45, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (213, 45, 'Xuất xứ', 'Trung Quốc', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (214, 45, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (215, 46, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (216, 46, 'Đế ngoài', 'Phylon nhẹ', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (217, 46, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (218, 46, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (219, 46, 'Xuất xứ', 'Trung Quốc', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (220, 46, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (221, 47, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (222, 47, 'Đế ngoài', 'TPU ổn định', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (223, 47, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (224, 47, 'Form', 'True to size (chuẩn size)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (225, 47, 'Xuất xứ', 'Việt Nam', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (226, 47, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (227, 48, 'Chất liệu upper', 'Canvas (vải bố)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (228, 48, 'Đế ngoài', 'TPU ổn định', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (229, 48, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (230, 48, 'Form', 'True to size (chuẩn size)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (231, 48, 'Xuất xứ', 'Việt Nam', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (232, 48, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (233, 49, 'Chất liệu upper', 'Canvas (vải bố)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (234, 49, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (235, 49, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (236, 49, 'Form', 'Rộng nhẹ', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (237, 49, 'Xuất xứ', 'Thái Lan', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (238, 49, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (239, 50, 'Chất liệu upper', 'Canvas (vải bố)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (240, 50, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (241, 50, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (242, 50, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (243, 50, 'Xuất xứ', 'Việt Nam', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (244, 50, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (245, 51, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (246, 51, 'Đế ngoài', 'TPU ổn định', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (247, 51, 'Công nghệ đệm', 'Foam êm', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (248, 51, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (249, 51, 'Xuất xứ', 'Việt Nam', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (250, 51, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (251, 52, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (252, 52, 'Đế ngoài', 'EVA + Rubber', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (253, 52, 'Công nghệ đệm', 'Foam êm', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (254, 52, 'Form', 'Rộng nhẹ', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (255, 52, 'Xuất xứ', 'Thái Lan', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (256, 52, 'Bảo hành', '6 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (257, 53, 'Chất liệu upper', 'Canvas (vải bố)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (258, 53, 'Đế ngoài', 'Phylon nhẹ', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (259, 53, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (260, 53, 'Form', 'Ôm chân', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (261, 53, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (262, 53, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (263, 54, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (264, 54, 'Đế ngoài', 'Phylon nhẹ', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (265, 54, 'Công nghệ đệm', 'Foam êm', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (266, 54, 'Form', 'Ôm chân', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (267, 54, 'Xuất xứ', 'Thái Lan', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (268, 54, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (269, 55, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (270, 55, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (271, 55, 'Công nghệ đệm', 'Boost-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (272, 55, 'Form', 'Rộng nhẹ', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (273, 55, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (274, 55, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (275, 56, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (276, 56, 'Đế ngoài', 'EVA + Rubber', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (277, 56, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (278, 56, 'Form', 'Ôm chân', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (279, 56, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (280, 56, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (281, 57, 'Chất liệu upper', 'Knit (dệt)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (282, 57, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (283, 57, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (284, 57, 'Form', 'Rộng nhẹ', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (285, 57, 'Xuất xứ', 'Trung Quốc', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (286, 57, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (287, 58, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (288, 58, 'Đế ngoài', 'Cao su chống mài mòn', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (289, 58, 'Công nghệ đệm', 'Air-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (290, 58, 'Form', 'Rộng nhẹ', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (291, 58, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (292, 58, 'Bảo hành', '12 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (293, 59, 'Chất liệu upper', 'Mesh (vải lưới)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (294, 59, 'Đế ngoài', 'TPU ổn định', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (295, 59, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (296, 59, 'Form', 'Slim fit (thon)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (297, 59, 'Xuất xứ', 'Indonesia', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (298, 59, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (299, 60, 'Chất liệu upper', 'Canvas (vải bố)', 0, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (300, 60, 'Đế ngoài', 'TPU ổn định', 1, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (301, 60, 'Công nghệ đệm', 'Gel-like', 2, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (302, 60, 'Form', 'True to size (chuẩn size)', 3, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (303, 60, 'Xuất xứ', 'Thái Lan', 4, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_specs` VALUES (304, 60, 'Bảo hành', '3 tháng', 5, '2026-01-15 22:00:00', '2026-01-15 22:00:00');

-- ----------------------------
-- Table structure for product_variants
-- ----------------------------
DROP TABLE IF EXISTS `product_variants`;
CREATE TABLE `product_variants`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `size` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `stock_qty` int NOT NULL DEFAULT 0,
  `sku` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `price` double NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_product_color_size`(`product_id` ASC, `color` ASC, `size` ASC) USING BTREE,
  INDEX `idx_variant_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_variant_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 240 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_variants
-- ----------------------------
INSERT INTO `product_variants` VALUES (1, 1, 'Black', '40', 7, 'P1-BLK-40', NULL, '2025-12-19 21:41:01', '2026-01-13 10:56:25');
INSERT INTO `product_variants` VALUES (2, 1, 'Black', '41', 5, 'P1-BLK-41', NULL, '2025-12-19 21:41:01', '2026-01-13 10:56:21');
INSERT INTO `product_variants` VALUES (3, 1, 'White', '40', 3, 'P1-WHT-40', NULL, '2025-12-19 21:41:01', '2025-12-19 21:41:01');
INSERT INTO `product_variants` VALUES (4, 2, 'Black', '42', 8, 'P2-BLK-42', NULL, '2025-12-19 21:41:01', '2025-12-19 21:41:01');
INSERT INTO `product_variants` VALUES (5, 2, 'Blue', '41', 0, 'P2-BLU-41', NULL, '2025-12-19 21:41:01', '2025-12-19 21:41:01');
INSERT INTO `product_variants` VALUES (6, 1, 'BLUE', '39', 5, 'P1-BLU-39', NULL, '2025-12-20 21:52:22', '2025-12-20 21:52:22');
INSERT INTO `product_variants` VALUES (7, 1, 'BLUE', '42', 7, 'P1-BLU-42', NULL, '2025-12-20 21:52:22', '2025-12-20 21:52:22');
INSERT INTO `product_variants` VALUES (8, 1, 'RED', '39', 4, 'P1-RED-39', NULL, '2025-12-20 21:52:22', '2025-12-20 21:52:22');
INSERT INTO `product_variants` VALUES (9, 1, 'RED', '42', 0, 'P1-RED-42', NULL, '2025-12-20 21:52:22', '2025-12-20 21:52:22');
INSERT INTO `product_variants` VALUES (10, 1, 'GREEN', '40', 1, 'P1-GR-40', 350, '2026-01-15 18:52:48', '2026-01-15 18:52:48');
INSERT INTO `product_variants` VALUES (11, 11, 'Pink', '43', 1, 'P11-PIN-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (12, 11, 'Pink', '42', 0, 'P11-PIN-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (13, 11, 'White', '43', 2, 'P11-WHI-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (14, 11, 'White', '42', 6, 'P11-WHI-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (15, 12, 'Blue', '39', 3, 'P12-BLU-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (16, 12, 'Blue', '42', 11, 'P12-BLU-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (17, 12, 'White', '39', 11, 'P12-WHI-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (18, 12, 'White', '42', 19, 'P12-WHI-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (19, 13, 'Red', '40', 12, 'P13-RED-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (20, 13, 'Red', '39', 8, 'P13-RED-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (21, 13, 'White', '40', 14, 'P13-WHI-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (22, 13, 'White', '39', 20, 'P13-WHI-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (23, 14, 'Lavender', '36', 1, 'P14-LAV-36', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (24, 14, 'Lavender', '37', 25, 'P14-LAV-37', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (25, 14, 'Beige', '36', 10, 'P14-BEI-36', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (26, 14, 'Beige', '37', 12, 'P14-BEI-37', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (27, 15, 'Brown', '41', 4, 'P15-BRO-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (28, 15, 'Brown', '40', 16, 'P15-BRO-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (29, 15, 'Green', '41', 15, 'P15-GRE-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (30, 15, 'Green', '40', 2, 'P15-GRE-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (31, 16, 'White', '41', 3, 'P16-WHI-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (32, 16, 'White', '44', 9, 'P16-WHI-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (33, 16, 'Pink', '41', 13, 'P16-PIN-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (34, 16, 'Pink', '44', 5, 'P16-PIN-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (35, 17, 'Black', '39', 3, 'P17-BLA-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (36, 17, 'Black', '36', 11, 'P17-BLA-36', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (37, 17, 'Beige', '39', 25, 'P17-BEI-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (38, 17, 'Beige', '36', 9, 'P17-BEI-36', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (39, 18, 'Navy', '44', 22, 'P18-NAV-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (40, 18, 'Navy', '40', 9, 'P18-NAV-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (41, 18, 'Pink', '44', 12, 'P18-PIN-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (42, 18, 'Pink', '40', 21, 'P18-PIN-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (43, 19, 'Navy', '39', 2, 'P19-NAV-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (44, 19, 'Navy', '41', 16, 'P19-NAV-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (45, 19, 'White', '39', 7, 'P19-WHI-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (46, 19, 'White', '41', 8, 'P19-WHI-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (47, 20, 'White', '42', 25, 'P20-WHI-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (48, 20, 'White', '41', 3, 'P20-WHI-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (49, 20, 'Black', '42', 7, 'P20-BLA-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (50, 20, 'Black', '41', 6, 'P20-BLA-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (51, 21, 'White', '40', 15, 'P21-WHI-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (52, 21, 'White', '42', 15, 'P21-WHI-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (53, 21, 'Navy', '40', 6, 'P21-NAV-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (54, 21, 'Navy', '42', 12, 'P21-NAV-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (55, 22, 'Navy', '43', 1, 'P22-NAV-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (56, 22, 'Navy', '44', 23, 'P22-NAV-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (57, 22, 'Black', '43', 10, 'P22-BLA-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (58, 22, 'Black', '44', 1, 'P22-BLA-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (59, 23, 'Brown', '42', 18, 'P23-BRO-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (60, 23, 'Brown', '43', 16, 'P23-BRO-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (61, 23, 'White', '42', 10, 'P23-WHI-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (62, 23, 'White', '43', 8, 'P23-WHI-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (63, 24, 'White', '43', 16, 'P24-WHI-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (64, 24, 'White', '40', 8, 'P24-WHI-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (65, 24, 'Brown', '43', 4, 'P24-BRO-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (66, 24, 'Brown', '40', 11, 'P24-BRO-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (67, 25, 'Grey', '39', 23, 'P25-GRE-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (68, 25, 'Grey', '44', 17, 'P25-GRE-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (69, 25, 'Red', '39', 4, 'P25-RED-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (70, 25, 'Red', '44', 8, 'P25-RED-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (71, 26, 'Grey', '40', 17, 'P26-GRE-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (72, 26, 'Grey', '42', 22, 'P26-GRE-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (73, 26, 'Red', '40', 13, 'P26-RED-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (74, 26, 'Red', '42', 17, 'P26-RED-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (75, 27, 'Navy', '44', 11, 'P27-NAV-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (76, 27, 'Navy', '39', 24, 'P27-NAV-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (77, 27, 'Brown', '44', 17, 'P27-BRO-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (78, 27, 'Brown', '39', 13, 'P27-BRO-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (79, 28, 'Green', '42', 6, 'P28-GRE-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (80, 28, 'Green', '40', 14, 'P28-GRE-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (81, 28, 'Black', '42', 11, 'P28-BLA-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (82, 28, 'Black', '40', 9, 'P28-BLA-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (83, 29, 'White', '40', 8, 'P29-WHI-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (84, 29, 'White', '43', 1, 'P29-WHI-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (85, 29, 'Red', '40', 3, 'P29-RED-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (86, 29, 'Red', '43', 19, 'P29-RED-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (87, 30, 'Navy', '42', 21, 'P30-NAV-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (88, 30, 'Navy', '39', 10, 'P30-NAV-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (89, 30, 'Blue', '42', 19, 'P30-BLU-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (90, 30, 'Blue', '39', 10, 'P30-BLU-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (91, 31, 'Red', '43', 9, 'P31-RED-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (92, 31, 'Red', '39', 9, 'P31-RED-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (93, 31, 'Green', '43', 6, 'P31-GRE-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (94, 31, 'Green', '39', 13, 'P31-GRE-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (95, 32, 'Navy', '40', 4, 'P32-NAV-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (96, 32, 'Navy', '44', 0, 'P32-NAV-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (97, 32, 'Red', '40', 1, 'P32-RED-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (98, 32, 'Red', '44', 7, 'P32-RED-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (99, 33, 'Navy', '44', 14, 'P33-NAV-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (100, 33, 'Navy', '43', 1, 'P33-NAV-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (101, 33, 'Grey', '44', 17, 'P33-GRE-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (102, 33, 'Grey', '43', 7, 'P33-GRE-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (103, 34, 'Red', '42', 8, 'P34-RED-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (104, 34, 'Red', '40', 14, 'P34-RED-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (105, 34, 'Pink', '42', 2, 'P34-PIN-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (106, 34, 'Pink', '40', 22, 'P34-PIN-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (107, 35, 'Green', '40', 12, 'P35-GRE-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (108, 35, 'Green', '42', 24, 'P35-GRE-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (109, 35, 'Black', '40', 18, 'P35-BLA-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (110, 35, 'Black', '42', 22, 'P35-BLA-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (111, 36, 'Beige', '42', 21, 'P36-BEI-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (112, 36, 'Beige', '41', 21, 'P36-BEI-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (113, 36, 'Black', '42', 25, 'P36-BLA-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (114, 36, 'Black', '41', 12, 'P36-BLA-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (115, 37, 'Navy', '41', 24, 'P37-NAV-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (116, 37, 'Navy', '44', 12, 'P37-NAV-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (117, 37, 'Beige', '41', 8, 'P37-BEI-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (118, 37, 'Beige', '44', 24, 'P37-BEI-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (119, 38, 'Navy', '39', 4, 'P38-NAV-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (120, 38, 'Navy', '43', 7, 'P38-NAV-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (121, 38, 'Brown', '39', 4, 'P38-BRO-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (122, 38, 'Brown', '43', 15, 'P38-BRO-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (123, 39, 'Red', '42', 2, 'P39-RED-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (124, 39, 'Red', '40', 18, 'P39-RED-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (125, 39, 'Green', '42', 22, 'P39-GRE-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (126, 39, 'Green', '40', 20, 'P39-GRE-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (127, 40, 'White', '38', 22, 'P40-WHI-38', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (128, 40, 'White', '39', 4, 'P40-WHI-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (129, 40, 'Grey', '38', 13, 'P40-GRE-38', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (130, 40, 'Grey', '39', 5, 'P40-GRE-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (131, 41, 'Beige', '40', 6, 'P41-BEI-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (132, 41, 'Beige', '42', 11, 'P41-BEI-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (133, 41, 'Blue', '40', 25, 'P41-BLU-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (134, 41, 'Blue', '42', 8, 'P41-BLU-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (135, 42, 'White', '37', 22, 'P42-WHI-37', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (136, 42, 'White', '39', 7, 'P42-WHI-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (137, 42, 'Beige', '37', 9, 'P42-BEI-37', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (138, 42, 'Beige', '39', 21, 'P42-BEI-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (139, 43, 'Grey', '40', 8, 'P43-GRE-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (140, 43, 'Grey', '42', 23, 'P43-GRE-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (141, 43, 'Navy', '40', 18, 'P43-NAV-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (142, 43, 'Navy', '42', 24, 'P43-NAV-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (143, 44, 'Beige', '39', 9, 'P44-BEI-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (144, 44, 'Beige', '43', 15, 'P44-BEI-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (145, 44, 'White', '39', 15, 'P44-WHI-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (146, 44, 'White', '43', 14, 'P44-WHI-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (147, 45, 'White', '36', 19, 'P45-WHI-36', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (148, 45, 'White', '39', 19, 'P45-WHI-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (149, 45, 'Pink', '36', 25, 'P45-PIN-36', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (150, 45, 'Pink', '39', 19, 'P45-PIN-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (151, 46, 'Beige', '37', 5, 'P46-BEI-37', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (152, 46, 'Beige', '40', 17, 'P46-BEI-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (153, 46, 'White', '37', 2, 'P46-WHI-37', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (154, 46, 'White', '40', 5, 'P46-WHI-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (155, 47, 'Lavender', '37', 3, 'P47-LAV-37', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (156, 47, 'Lavender', '39', 17, 'P47-LAV-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (157, 47, 'Black', '37', 7, 'P47-BLA-37', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (158, 47, 'Black', '39', 20, 'P47-BLA-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (159, 48, 'Beige', '40', 14, 'P48-BEI-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (160, 48, 'Beige', '39', 2, 'P48-BEI-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (161, 48, 'Black', '40', 19, 'P48-BLA-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (162, 48, 'Black', '39', 1, 'P48-BLA-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (163, 49, 'Grey', '39', 5, 'P49-GRE-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (164, 49, 'Grey', '38', 18, 'P49-GRE-38', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (165, 49, 'Black', '39', 13, 'P49-BLA-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (166, 49, 'Black', '38', 20, 'P49-BLA-38', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (167, 50, 'Pink', '42', 10, 'P50-PIN-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (168, 50, 'Pink', '39', 8, 'P50-PIN-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (169, 50, 'Black', '42', 10, 'P50-BLA-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (170, 50, 'Black', '39', 3, 'P50-BLA-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (171, 51, 'Grey', '36', 20, 'P51-GRE-36', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (172, 51, 'Grey', '40', 19, 'P51-GRE-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (173, 51, 'Lavender', '36', 25, 'P51-LAV-36', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (174, 51, 'Lavender', '40', 7, 'P51-LAV-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (175, 52, 'Green', '42', 14, 'P52-GRE-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (176, 52, 'Green', '40', 17, 'P52-GRE-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (177, 52, 'Beige', '42', 4, 'P52-BEI-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (178, 52, 'Beige', '40', 12, 'P52-BEI-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (179, 53, 'Beige', '42', 10, 'P53-BEI-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (180, 53, 'Beige', '41', 17, 'P53-BEI-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (181, 53, 'Pink', '42', 24, 'P53-PIN-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (182, 53, 'Pink', '41', 17, 'P53-PIN-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (183, 54, 'Beige', '40', 18, 'P54-BEI-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (184, 54, 'Beige', '43', 10, 'P54-BEI-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (185, 54, 'Black', '40', 3, 'P54-BLA-40', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (186, 54, 'Black', '43', 14, 'P54-BLA-43', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (187, 55, 'Lavender', '39', 20, 'P55-LAV-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (188, 55, 'Lavender', '38', 22, 'P55-LAV-38', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (189, 55, 'Black', '39', 24, 'P55-BLA-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (190, 55, 'Black', '38', 15, 'P55-BLA-38', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (191, 56, 'Black', '41', 9, 'P56-BLA-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (192, 56, 'Black', '39', 11, 'P56-BLA-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (193, 56, 'Brown', '41', 11, 'P56-BRO-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (194, 56, 'Brown', '39', 13, 'P56-BRO-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (195, 57, 'Beige', '44', 25, 'P57-BEI-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (196, 57, 'Beige', '39', 14, 'P57-BEI-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (197, 57, 'Red', '44', 9, 'P57-RED-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (198, 57, 'Red', '39', 21, 'P57-RED-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (199, 58, 'Brown', '44', 0, 'P58-BRO-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (200, 58, 'Brown', '41', 21, 'P58-BRO-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (201, 58, 'Red', '44', 12, 'P58-RED-44', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (202, 58, 'Red', '41', 8, 'P58-RED-41', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (203, 59, 'Black', '42', 18, 'P59-BLA-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (204, 59, 'Black', '39', 11, 'P59-BLA-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (205, 59, 'Red', '42', 23, 'P59-RED-42', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (206, 59, 'Red', '39', 4, 'P59-RED-39', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (207, 60, 'Default', 'One Size', 8, 'P60-DEF-ONESIZE', NULL, '2026-01-15 22:00:00', '2026-01-15 22:00:00');
INSERT INTO `product_variants` VALUES (208, 10, 'White', '40', 8, 'P13-WHI-40', NULL, '2026-01-16 04:03:11', '2026-01-16 04:04:46');
INSERT INTO `product_variants` VALUES (209, 10, 'Black', '40', 5, 'P13-BLK-40', NULL, '2026-01-16 04:04:06', '2026-01-16 04:04:35');
INSERT INTO `product_variants` VALUES (210, 10, 'Black', '42', 6, 'P13-BLK-42', NULL, '2026-01-16 04:05:12', '2026-01-16 04:05:12');
INSERT INTO `product_variants` VALUES (211, 10, 'White', '42', 7, 'P13-WHI-42', NULL, '2026-01-16 04:05:32', '2026-01-16 04:05:32');
INSERT INTO `product_variants` VALUES (212, 3, 'Black', '40', 7, 'P13-BLK-40', NULL, '2026-01-16 04:16:22', '2026-01-16 04:16:22');
INSERT INTO `product_variants` VALUES (213, 3, 'Black', '41', 6, 'P13-BLK-41', NULL, '2026-01-16 04:16:38', '2026-01-16 04:16:38');
INSERT INTO `product_variants` VALUES (214, 3, 'White', '40', 9, 'P13-WHI-40', NULL, '2026-01-16 04:16:54', '2026-01-16 04:16:54');
INSERT INTO `product_variants` VALUES (215, 3, 'White', '41', 9, 'P13-WHI-41', NULL, '2026-01-16 04:17:13', '2026-01-16 04:17:13');
INSERT INTO `product_variants` VALUES (216, 9, 'White', '40', 9, 'P13-WHI-40', NULL, '2026-01-16 04:19:42', '2026-01-16 04:20:03');
INSERT INTO `product_variants` VALUES (217, 9, 'White', '42', 6, 'P13-WHI-42', NULL, '2026-01-16 04:19:58', '2026-01-16 04:19:58');
INSERT INTO `product_variants` VALUES (218, 9, 'Beige', '40', 6, 'P13-BEI-40', NULL, '2026-01-16 04:20:34', '2026-01-16 04:20:34');
INSERT INTO `product_variants` VALUES (219, 9, 'Beige', '42', 9, 'P13-BEI-41', NULL, '2026-01-16 04:20:50', '2026-01-16 04:21:02');
INSERT INTO `product_variants` VALUES (220, 8, 'Black', '40', 8, 'P13-BLK-40', NULL, '2026-01-16 04:22:55', '2026-01-16 04:22:55');
INSERT INTO `product_variants` VALUES (221, 8, 'Black', '42', 9, 'P13-BLK-42', NULL, '2026-01-16 04:23:08', '2026-01-16 04:23:08');
INSERT INTO `product_variants` VALUES (222, 8, 'White', '40', 8, 'P13-WHI-40', NULL, '2026-01-16 04:23:21', '2026-01-16 04:23:21');
INSERT INTO `product_variants` VALUES (223, 8, 'White', '42', 9, 'P13-WHI-42', NULL, '2026-01-16 04:23:39', '2026-01-16 04:23:39');
INSERT INTO `product_variants` VALUES (224, 7, 'Red', '40', 5, 'P13-RED-40', NULL, '2026-01-16 04:26:42', '2026-01-16 04:26:42');
INSERT INTO `product_variants` VALUES (225, 7, 'Red', '41', 8, 'P13-RED-41', NULL, '2026-01-16 04:26:53', '2026-01-16 04:26:53');
INSERT INTO `product_variants` VALUES (226, 7, 'Green', '40', 9, 'P13-GRE-40', NULL, '2026-01-16 04:27:03', '2026-01-16 04:27:03');
INSERT INTO `product_variants` VALUES (227, 7, 'Green', '41', 4, 'P13-GRE-41', NULL, '2026-01-16 04:27:18', '2026-01-16 04:27:18');
INSERT INTO `product_variants` VALUES (228, 6, 'Black', '40', 5, 'P13-BLK-40', NULL, '2026-01-16 04:29:17', '2026-01-16 04:29:24');
INSERT INTO `product_variants` VALUES (229, 6, 'Black', '42', 5, 'P13-BLK-42', NULL, '2026-01-16 04:29:34', '2026-01-16 04:29:34');
INSERT INTO `product_variants` VALUES (230, 6, 'Red', '40', 6, 'P13-RED-40', NULL, '2026-01-16 04:29:45', '2026-01-16 04:29:45');
INSERT INTO `product_variants` VALUES (231, 6, 'Red', '42', 4, 'P13-RED-42', NULL, '2026-01-16 04:29:55', '2026-01-16 04:29:55');
INSERT INTO `product_variants` VALUES (232, 5, 'Green', '40', 5, 'P13-GRE-40', NULL, '2026-01-16 04:32:04', '2026-01-16 04:32:04');
INSERT INTO `product_variants` VALUES (233, 5, 'Green', '41', 5, 'P13-GRE-41', NULL, '2026-01-16 04:32:17', '2026-01-16 04:32:17');
INSERT INTO `product_variants` VALUES (234, 5, 'White', '40', 5, 'P13-WHI-40', NULL, '2026-01-16 04:32:42', '2026-01-16 04:32:42');
INSERT INTO `product_variants` VALUES (235, 5, 'White', '41', 7, 'P13-WHI-41', NULL, '2026-01-16 04:33:01', '2026-01-16 04:33:01');
INSERT INTO `product_variants` VALUES (236, 4, 'Navy', '40', 5, 'P13-NAV-40', NULL, '2026-01-16 04:34:59', '2026-01-16 04:34:59');
INSERT INTO `product_variants` VALUES (237, 4, 'Navy', '41', 8, 'P13-NAV-41', NULL, '2026-01-16 04:35:08', '2026-01-16 04:35:08');
INSERT INTO `product_variants` VALUES (238, 4, 'Black', '40', 4, 'P13-BLK-40', NULL, '2026-01-16 04:35:20', '2026-01-16 11:11:38');
INSERT INTO `product_variants` VALUES (239, 4, 'Black', '41', 8, 'P13-BLK-41', NULL, '2026-01-16 04:35:31', '2026-01-16 04:35:31');

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `price` double NOT NULL,
  `old_price` double NULL DEFAULT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `category_id` int NOT NULL,
  `brand_id` int NOT NULL,
  `active` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_products_category`(`category_id` ASC) USING BTREE,
  INDEX `fk_products_brand`(`brand_id` ASC) USING BTREE,
  CONSTRAINT `fk_products_brand` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES (1, 'Nike Air Zoom Pegasus 40', 'Giày chạy bộ Nike Air Zoom Pegasus 40 êm ái, phù hợp chạy bộ hằng ngày.', 2990000, 3490000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/air-zoom-pegasus-40-older-road-running-shoes-jqwr5f.jpg', 'men', 1, 1, 1, '2025-12-11 23:45:43', '2026-01-15 00:02:02');
INSERT INTO `products` VALUES (2, 'Adidas Ultraboost Light', 'Giày chạy bộ Adidas Ultraboost Light đệm Boost nhẹ và đàn hồi.', 3590000, 3990000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/z-f36199-02-35ee1fca-baf2-4bfc-86c1-5c0abfbf920f.jpg', 'men', 1, 2, 1, '2025-12-11 23:45:43', '2026-01-16 04:16:01');
INSERT INTO `products` VALUES (3, 'Nike Mercurial Vapor 15 Elite', 'Giày đá bóng Nike Mercurial Vapor 15 Elite cho sân cỏ nhân tạo.', 4290000, 5490000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-air-force-1-gs-white-black-ct3839-100-01.jpg', 'men', 2, 1, 1, '2025-12-11 23:45:43', '2026-01-16 04:18:58');
INSERT INTO `products` VALUES (4, 'Adidas Predator Accuracy.', 'Giày đá bóng Adidas Predator Accuracy. kiểm soát bóng tốt.', 4290000, 4690000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/response-super-djen-fx4833-01.jpg', 'men', 2, 2, 1, '2025-12-11 23:45:43', '2026-01-16 04:37:04');
INSERT INTO `products` VALUES (5, 'Nike Lebron Witness 8', 'Giày bóng rổ Nike Lebron Witness 8 hỗ trợ cổ chân và bật nhảy.', 3290000, 3990000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-air-jordan-1-low-553558-147-1.jpg', 'men', 3, 1, 1, '2025-12-11 23:45:43', '2026-01-16 04:34:45');
INSERT INTO `products` VALUES (6, 'Puma All Pro Nitro', 'Giày bóng rổ Puma All Pro Nitro nhẹ, bám sân tốt.', 2690000, 3290000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-puma-pounce-lite-sneakers-310778-14-1.jpg', 'men', 3, 3, 1, '2025-12-11 23:45:43', '2026-01-16 04:31:45');
INSERT INTO `products` VALUES (7, 'Converse Chuck Taylor All Star', 'Giày sneaker Converse Chuck Taylor All Star cổ điển.', 1590000, 1990000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-vans-vn0007nvfgn-01.jpg', 'unisex', 4, 5, 1, '2025-12-11 23:45:43', '2026-01-16 04:29:04');
INSERT INTO `products` VALUES (8, 'Vans Old Skool Classic', 'Giày sneaker Vans Old Skool Classic cho phong cách streetwear.', 1690000, 1990000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-superstar-fv3290-01.jpg', 'unisex', 4, 6, 1, '2025-12-11 23:45:43', '2026-01-16 04:25:18');
INSERT INTO `products` VALUES (9, 'Asics Gel-Nimbus 26', 'Giày chạy bộ Asics Gel-Nimbus 26 hỗ trợ long run.', 4490000, 4990000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-ultraboost-20-eg0713-01.jpg', 'women', 1, 7, 1, '2025-12-11 23:45:43', '2026-01-16 04:22:33');
INSERT INTO `products` VALUES (10, 'Mizuno Wave Rider 27', 'Giày chạy bộ Mizuno Wave Rider 27 cân bằng giữa êm và phản hồi lực.', 2990000, 3490000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/11271239-r1.jpg', 'men', 1, 10, 1, '2025-12-11 23:45:43', '2026-01-16 04:07:28');
INSERT INTO `products` VALUES (11, 'Nike Road Sprint JI0', 'Form ôm chân, bám đường tốt, tối ưu chạy tốc độ. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 4461000, 4895000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-air-zoom-pegasus-38-cw7358-601-01-33f41548-eee8-493c-b25a-0656a44d0665.jpg', 'men', 1, 1, 1, '2026-01-15 22:00:00', '2026-01-16 04:01:47');
INSERT INTO `products` VALUES (12, 'New Balance Road Sprint A3Z', 'Form ôm chân, bám đường tốt, tối ưu chạy tốc độ. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3083000, 3391300, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/new-balance-fuelcell-996v6-wch996u6-3.jpg', 'unisex', 1, 4, 1, '2026-01-15 22:00:00', '2026-01-16 03:59:45');
INSERT INTO `products` VALUES (13, 'New Balance Road Sprint W5U', 'Form ôm chân, bám đường tốt, tối ưu chạy tốc độ. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 4575000, 5032500, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/mch796n4-nb-02-1.jpg', 'unisex', 1, 4, 1, '2026-01-15 22:00:00', '2026-01-16 03:57:52');
INSERT INTO `products` VALUES (14, 'Nike Cloud Pace G0F', 'Đệm êm, hoàn trả lực tốt, upper thoáng khí. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3244000, 3568400, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/8bf013bf-6b92-4d4b-844c-cb2495024bfa.jpg', 'women', 1, 1, 1, '2026-01-15 22:00:00', '2026-01-16 03:55:39');
INSERT INTO `products` VALUES (15, 'Asics Cloud Pace XFF', 'Đệm êm, hoàn trả lực tốt, upper thoáng khí. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3989000, 4786800, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs.jpg', 'unisex', 1, 7, 1, '2026-01-15 22:00:00', '2026-01-16 03:53:33');
INSERT INTO `products` VALUES (16, 'Asics Air Runner 9T8', 'Giày chạy bộ nhẹ, êm, phù hợp chạy hằng ngày. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 1737000, 2250000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-tensor-eg4126-01.jpg', 'men', 1, 7, 1, '2026-01-15 22:00:00', '2026-01-16 03:51:53');
INSERT INTO `products` VALUES (17, 'Under Armour Cloud Pace F1T', 'Đệm êm, hoàn trả lực tốt, upper thoáng khí. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3862000, 4200000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/x-plr-shoes-beige-by9255-01-standard-1.jpg', 'women', 1, 9, 1, '2026-01-15 22:00:00', '2026-01-16 03:49:45');
INSERT INTO `products` VALUES (18, 'Nike Cloud Pace TEX', 'Đệm êm, hoàn trả lực tốt, upper thoáng khí. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3941000, 4729200, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-6e49cf5c-8ae7-4768-a8b4-0daff66afc34.jpg?v=1764234156987', 'unisex', 1, 1, 1, '2026-01-15 22:00:00', '2026-01-16 03:46:43');
INSERT INTO `products` VALUES (19, 'New Balance Air Runner TVA', 'Giày chạy bộ nhẹ, êm, phù hợp chạy hằng ngày. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 4589000, 5995000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/mch796n4-nb-02-1.jpg', 'men', 1, 4, 1, '2026-01-15 22:00:00', '2026-01-16 03:43:07');
INSERT INTO `products` VALUES (20, 'Adidas Cloud Pace XMO', 'Đệm êm, hoàn trả lực tốt, upper thoáng khí. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 1911000, 2300000, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-fv8351-05.jpg?v=1612083794767', 'men', 1, 2, 1, '2026-01-15 22:00:00', '2026-01-16 03:39:48');
INSERT INTO `products` VALUES (21, 'Adidas Cloud Pace C34', 'Đệm êm, hoàn trả lực tốt, upper thoáng khí. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 2091000, 2195550, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-ultraboost-20-fv8351-06.jpg?v=1612083809993', 'unisex', 1, 2, 1, '2026-01-15 22:00:00', '2026-01-16 03:37:59');
INSERT INTO `products` VALUES (22, 'New Balance Cloud Pace 89U', 'Đệm êm, hoàn trả lực tốt, upper thoáng khí. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3683000, 4235450, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-new-balance-fresh-foam-roav-v1-uroavwm1-1.jpg', 'men', 1, 4, 1, '2026-01-15 22:00:00', '2026-01-16 03:35:58');
INSERT INTO `products` VALUES (23, 'Nike Pro Striker IE6', 'Giày bóng đá sân cỏ nhân tạo, bám sân tốt. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 2898000, 3042900, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/nike-plus-pegasus-plus-trail-plus-5-plus-gs.jpg', 'men', 2, 1, 1, '2026-01-15 22:00:00', '2026-01-16 03:33:22');
INSERT INTO `products` VALUES (24, 'Puma Speed Phantom 77A', 'Tối ưu tăng tốc, upper mỏng nhẹ. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 4434000, 4997000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/edge-xt-shoes-white-fw0670-01.jpg', 'men', 2, 3, 1, '2026-01-15 22:00:00', '2026-01-16 03:31:22');
INSERT INTO `products` VALUES (25, 'Puma Speed Phantom 9XA', 'Tối ưu tăng tốc, upper mỏng nhẹ. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 5236000, 5497800, 'https://bizweb.dktcdn.net/100/347/092/products/s-l1600-3-11zon-4efaccd1-ef65-41c9-ae71-c315a9ef6ad0.jpg?v=1766476849523', 'men', 2, 3, 1, '2026-01-15 22:00:00', '2026-01-16 03:29:08');
INSERT INTO `products` VALUES (26, 'Puma Control Master 4DP', 'Kiểm soát bóng ổn định, đế đinh TF. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3023000, 3476449, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/evoride-women-s-1012a677-020-01-9a37e53d-622b-4d5c-a4a6-37b1a8848b2b.jpg', 'unisex', 2, 3, 1, '2026-01-15 22:00:00', '2026-01-16 03:27:13');
INSERT INTO `products` VALUES (27, 'Adidas Speed Phantom BN7', 'Tối ưu tăng tốc, upper mỏng nhẹ. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 2053000, 2560000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-ultraboost-21-be-fy0391-01.jpg', 'men', 2, 2, 1, '2026-01-15 22:00:00', '2026-01-16 03:24:12');
INSERT INTO `products` VALUES (28, 'Puma Pro Striker OY0', 'Giày bóng đá sân cỏ nhân tạo, bám sân tốt. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 2906000, 3051300, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-puma-velocity-nitro-3-black-silver-w-377749-01-01-1721029197148.jpg', 'unisex', 2, 3, 1, '2026-01-15 22:00:00', '2026-01-16 03:21:57');
INSERT INTO `products` VALUES (29, 'Nike Control Master KXO', 'Kiểm soát bóng ổn định, đế đinh TF. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 4086000, 4290300, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-nike-ebernon-low-aq1775-004-1.jpg', 'unisex', 2, 1, 1, '2026-01-15 22:00:00', '2026-01-16 03:19:42');
INSERT INTO `products` VALUES (30, 'Adidas Speed Phantom ZA7', 'Tối ưu tăng tốc, upper mỏng nhẹ. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 4095000, 5580000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-sl20.jpg?v=1649244897697', 'men', 2, 2, 1, '2026-01-15 22:00:00', '2026-01-16 03:17:37');
INSERT INTO `products` VALUES (31, 'Reebok Street Baller GXN', 'Thiết kế street, phù hợp tập luyện và thi đấu. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 2702000, 3000000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-01-standard.jpg', 'men', 3, 8, 1, '2026-01-15 22:00:00', '2026-01-16 03:15:09');
INSERT INTO `products` VALUES (32, 'Adidas Hoop Force KXW', 'Hỗ trợ bật nhảy, ổn định cổ chân. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 2372000, 2680000, 'https://bizweb.dktcdn.net/100/347/092/products/adidas-4d-fusio-h04509-01.jpg?v=1652519006187', 'men', 3, 2, 1, '2026-01-15 22:00:00', '2026-01-16 03:11:40');
INSERT INTO `products` VALUES (33, 'Under Armour Street Baller IXA', 'Thiết kế street, phù hợp tập luyện và thi đấu. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 2426000, 2900000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-nike-air-max-2017-849559-005-1.jpg', 'men', 3, 9, 1, '2026-01-15 22:00:00', '2026-01-16 03:09:20');
INSERT INTO `products` VALUES (34, 'Converse Street Baller 6QF', 'Thiết kế street, phù hợp tập luyện và thi đấu. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3934000, 4327400, 'https://bizweb.dktcdn.net/100/347/092/products/471621429-911299884508655-6172145443203728554-n.jpg?v=1735550737220', 'men', 3, 5, 1, '2026-01-15 22:00:00', '2026-01-16 03:06:37');
INSERT INTO `products` VALUES (35, 'Adidas Court Dunk NFH', 'Giày bóng rổ cổ thấp, đệm êm, bám sân. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3689000, 4426800, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-ultraboost-1-0-mau-xanh-la-if5258-01-standard.jpg', 'men', 3, 2, 1, '2026-01-15 22:00:00', '2026-01-16 03:04:36');
INSERT INTO `products` VALUES (36, 'Under Armour Hoop Force 026', 'Hỗ trợ bật nhảy, ổn định cổ chân. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3989000, 4786800, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-3.jpg', 'men', 3, 9, 1, '2026-01-15 22:00:00', '2026-01-16 02:00:23');
INSERT INTO `products` VALUES (37, 'Puma Daily Canvas XEQ', 'Upper canvas thoáng, phù hợp đi học/đi chơi. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 1195000, 1374250, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/7e33f5b842804ba48745d51160041600.jpg', 'men', 4, 3, 1, '2026-01-15 22:00:00', '2026-01-16 01:59:21');
INSERT INTO `products` VALUES (38, 'Nike Daily Canvas MX2', 'Upper canvas thoáng, phù hợp đi học/đi chơi. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3659000, 3841950, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-nike-vomero-18-hm6803-401-1.jpg', 'unisex', 4, 1, 1, '2026-01-15 22:00:00', '2026-01-16 01:58:02');
INSERT INTO `products` VALUES (39, 'Vans Daily Canvas Z2F', 'Upper canvas thoáng, phù hợp đi học/đi chơi. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 2264000, 2377200, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-vans-vn0007nvfgn-01.jpg', 'unisex', 4, 6, 1, '2026-01-15 22:00:00', '2026-01-16 01:56:32');
INSERT INTO `products` VALUES (40, 'Converse Daily Canvas CXA', 'Upper canvas thoáng, phù hợp đi học/đi chơi. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 2710000, 3000000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-nike-air-max-2017-849559-005-1.jpg', 'women', 4, 5, 1, '2026-01-15 22:00:00', '2026-01-16 01:54:36');
INSERT INTO `products` VALUES (41, 'Nike Street Classic Q1U', 'Sneaker lifestyle dễ phối đồ, đi êm. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3726000, 3912300, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/36f2d78a-70f8-4c79-9a07-3c8c0f6d913e.jpg', 'men', 4, 1, 1, '2026-01-15 22:00:00', '2026-01-16 01:53:14');
INSERT INTO `products` VALUES (42, 'Puma Street Classic TIR', 'Sneaker lifestyle dễ phối đồ, đi êm. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3905000, 4100250, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-adidas-supernova-rise-move-for-the-planet-ig8328-01-3.jpg', 'women', 4, 3, 1, '2026-01-15 22:00:00', '2026-01-16 01:51:42');
INSERT INTO `products` VALUES (43, 'Converse Daily Canvas JEG', 'Upper canvas thoáng, phù hợp đi học/đi chơi. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 1479000, 1850000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/766a31a1-e9a5-44b3-9981-48fe39f750bb.jpg', 'men', 4, 5, 1, '2026-01-15 22:00:00', '2026-01-16 01:47:11');
INSERT INTO `products` VALUES (44, 'New Balance Street Classic TJ9', 'Sneaker lifestyle dễ phối đồ, đi êm. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3256000, 3581600, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/x-plr-shoes-beige-by9255-01-standard-1.jpg', 'men', 4, 4, 1, '2026-01-15 22:00:00', '2026-01-16 01:45:38');
INSERT INTO `products` VALUES (45, 'Converse Street Classic UYF', 'Sneaker lifestyle dễ phối đồ, đi êm. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3295000, 4000000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/45sma0110042-1.jpg', 'women', 4, 5, 1, '2026-01-15 22:00:00', '2026-01-16 01:43:54');
INSERT INTO `products` VALUES (46, 'New Balance Urban Retro C8D', 'Phong cách retro, chất liệu bền đẹp. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 1841000, 2500000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/46sma0117-6d2-01.jpg', 'women', 4, 4, 1, '2026-01-15 22:00:00', '2026-01-16 01:42:17');
INSERT INTO `products` VALUES (47, 'Vans Comfort Slide ZQY', 'Dép/sandal êm, chống trơn trượt. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 740000, 860000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/adidas-gy9416-01.jpg', 'women', 5, 6, 1, '2026-01-15 22:00:00', '2026-01-16 01:41:02');
INSERT INTO `products` VALUES (48, 'Puma Beach Walker UKE', 'Sandal nhẹ, nhanh khô, phù hợp đi biển. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 821000, 900000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/dep-adilette-22-be-if3673-01-standard.jpg', 'women', 5, 3, 1, '2026-01-15 22:00:00', '2026-01-16 01:39:15');
INSERT INTO `products` VALUES (49, 'Puma Sport Sandal A13', 'Quai chắc chắn, đế bám tốt. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 1379000, 1516900, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/a068a1a8-ed4e-4ba2-b69b-be6d8986da29.jpg', 'women', 5, 3, 1, '2026-01-15 22:00:00', '2026-01-16 01:36:46');
INSERT INTO `products` VALUES (50, 'Nike Beach Walker LYK', 'Sandal nhẹ, nhanh khô, phù hợp đi biển. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 1019000, 1600000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/110339010959-18-2-1080x715-1.jpg', 'unisex', 5, 1, 1, '2026-01-15 22:00:00', '2026-01-16 01:34:13');
INSERT INTO `products` VALUES (51, 'Vans Sport Sandal RPB', 'Quai chắc chắn, đế bám tốt. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 745000, 856749, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/b8bfca5a-883a-44ec-a171-3e323ea07dd9.jpg', 'women', 5, 6, 1, '2026-01-15 22:00:00', '2026-01-16 01:32:38');
INSERT INTO `products` VALUES (52, 'Converse Comfort Slide XF7', 'Dép/sandal êm, chống trơn trượt. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 796000, 915399, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/dep-adilette-22-be-if3673-01-standard.jpg', 'unisex', 5, 5, 1, '2026-01-15 22:00:00', '2026-01-16 01:30:04');
INSERT INTO `products` VALUES (53, 'Adidas Baseline Pro KV9', 'Đệm ổn định, bảo vệ cổ chân tốt. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3895000, 4000000, 'https://bizweb.dktcdn.net/100/347/092/products/470056923-1318554229579825-8979052385952416786-n.jpg?v=1735550741353', 'men', 6, 2, 1, '2026-01-15 22:00:00', '2026-01-16 01:27:41');
INSERT INTO `products` VALUES (54, 'Asics Baseline Pro OLR', 'Đệm ổn định, bảo vệ cổ chân tốt. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 3451000, 3796100, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/x-plr-shoes-beige-by9255-01-standard-1.jpg', 'unisex', 6, 7, 1, '2026-01-15 22:00:00', '2026-01-16 01:26:16');
INSERT INTO `products` VALUES (55, 'Adidas Tennis Ace 8MY', 'Giày tennis hỗ trợ di chuyển ngang, bám sân. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 4551000, 5233650, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/z-f36199-02-35ee1fca-baf2-4bfc-86c1-5c0abfbf920f.jpg', 'women', 6, 2, 1, '2026-01-15 22:00:00', '2026-01-16 01:24:57');
INSERT INTO `products` VALUES (56, 'Nike Tennis Ace 1ZD', 'Giày tennis hỗ trợ di chuyển ngang, bám sân. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 2571000, 2990000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/m-plus-zoom-plus-gp-plus-challenge-plus-pro-plus-hc.jpg', 'unisex', 6, 1, 1, '2026-01-15 22:00:00', '2026-01-16 00:45:22');
INSERT INTO `products` VALUES (57, 'Puma Gym Trainer WI6', 'Giày tập gym ổn định, đế phẳng dễ squat. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 2076000, 2387400, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/x-plr-shoes-beige-by9255-01-standard-1.jpg', 'unisex', 7, 3, 1, '2026-01-15 22:00:00', '2026-01-16 01:21:50');
INSERT INTO `products` VALUES (58, 'Adidas HIIT Flex K94', 'Linh hoạt, phù hợp bài tập cường độ cao. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 1926000, 2214900, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-ultraboost-21-be-fy0391-01.jpg', 'men', 7, 2, 1, '2026-01-15 22:00:00', '2026-01-16 02:56:40');
INSERT INTO `products` VALUES (59, 'Nike HIIT Flex WYZ', 'Linh hoạt, phù hợp bài tập cường độ cao. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 2050000, 1500000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/giay-nike-ebernon-low-aq1775-004-1.jpg', 'men', 7, 1, 1, '2026-01-15 22:00:00', '2026-01-16 01:22:11');
INSERT INTO `products` VALUES (60, 'Mizuno Shoe Care Kit 5NS', 'Bộ vệ sinh giày gồm bàn chải, dung dịch, khăn. Thiết kế hiện đại, phù hợp đi học, đi làm và vận động. Cam kết hàng chính hãng.', 129000, 135000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/bot-ve-sinh-giay-tien-loi-150ml-01.jpg?v=1694779868303', 'unisex', 8, 10, 1, '2026-01-15 22:00:00', '2026-01-16 01:49:55');

-- ----------------------------
-- Table structure for reviews
-- ----------------------------
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rating` int NOT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_reviews_product`(`product_id` ASC) USING BTREE,
  INDEX `fk_reviews_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_reviews_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of reviews
-- ----------------------------
INSERT INTO `reviews` VALUES (1, 1, 3, 5, 'Giày chạy rất êm, form đúng size.', 'APPROVED', '2025-12-11 23:45:59');
INSERT INTO `reviews` VALUES (2, 2, 4, 4, 'Đệm êm nhưng hơi nóng chân khi chạy dài.', 'APPROVED', '2025-12-11 23:45:59');
INSERT INTO `reviews` VALUES (3, 1, 2, 4, 'giày oke đó, đáng tiền mua', 'APPROVED', '2025-12-24 11:02:00');

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES (1, 'ADMIN', 'Quản trị hệ thống', 'Toàn quyền quản lý hệ thống');
INSERT INTO `roles` VALUES (2, 'STAFF', 'Nhân viên', 'Quản lý đơn hàng, sản phẩm, khách hàng');
INSERT INTO `roles` VALUES (3, 'USER', 'Khách hàng', 'Người mua hàng trên website');

-- ----------------------------
-- Table structure for user_addresses
-- ----------------------------
DROP TABLE IF EXISTS `user_addresses`;
CREATE TABLE `user_addresses`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `full_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address_line` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `district` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ward` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_default` tinyint(1) NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_addresses_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_user_addresses_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_addresses
-- ----------------------------
INSERT INTO `user_addresses` VALUES (1, 3, 'Nguyễn Văn A', '0909000001', '123 Lê Lợi', 'TP.HCM', 'Quận 1', 'Bến Thành', 1, '2025-12-11 23:45:59');
INSERT INTO `user_addresses` VALUES (2, 4, 'Trần Thị B', '0909000002', '89 Phan Xích Long', 'TP.HCM', 'Phú Nhuận', 'Phường 3', 1, '2025-12-11 23:45:59');
INSERT INTO `user_addresses` VALUES (3, 7, 'linh trọng', '0342406654', '123, ', 'TP. Hồ Chí Minh', 'thuan an', 'binh hoa', 0, '2026-01-11 00:40:02');
INSERT INTO `user_addresses` VALUES (4, 7, 'linh trọng', '0342406654', '123,', 'TP. Hồ Chí Minh', 'thuan an', 'binh hoa', 0, '2026-01-12 20:01:22');
INSERT INTO `user_addresses` VALUES (5, 7, 'linh trọng', '0342406654', '123,', 'TP. Hồ Chí Minh', 'thuan an', 'binh hoa', 0, '2026-01-12 20:05:37');
INSERT INTO `user_addresses` VALUES (6, 7, 'linh trọng', '0342406654', '123,', 'TP. Hồ Chí Minh', 'thuan an', 'binh hoa', 0, '2026-01-12 23:15:45');
INSERT INTO `user_addresses` VALUES (7, 7, 'linh trọng', '0342406654', '123,', 'TP. Hồ Chí Minh', 'thuan an', 'binh hoa', 0, '2026-01-12 23:16:51');
INSERT INTO `user_addresses` VALUES (8, 7, 'linh trọng', '0342406654', '123,', 'TP. Hồ Chí Minh', 'thuan an', 'binh hoa', 0, '2026-01-12 23:59:21');
INSERT INTO `user_addresses` VALUES (9, 7, 'linh trọng', '0342406654', '123,', 'TP. Hồ Chí Minh', 'thuan an', 'binh hoa', 1, '2026-01-16 11:11:38');

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles`  (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE,
  INDEX `fk_user_roles_role`(`role_id` ASC) USING BTREE,
  CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_roles
-- ----------------------------
INSERT INTO `user_roles` VALUES (1, 1);
INSERT INTO `user_roles` VALUES (2, 1);
INSERT INTO `user_roles` VALUES (3, 3);
INSERT INTO `user_roles` VALUES (4, 3);
INSERT INTO `user_roles` VALUES (5, 3);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `birthday` date NULL DEFAULT NULL,
  `active` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin@japansport.com', 'admin123', 'NLU', NULL, NULL, NULL, NULL, 1, '2025-12-11 23:44:51', '2026-01-02 23:34:39');
INSERT INTO `users` VALUES (2, 'staff1@japansport.com', 'staff123', 'Nhân viên kho', NULL, NULL, NULL, NULL, 1, '2025-12-11 23:44:51', '2026-01-14 00:38:03');
INSERT INTO `users` VALUES (3, 'user1@example.com', 'user123', 'Nguyễn Văn A', NULL, NULL, NULL, NULL, 1, '2025-12-11 23:44:51', '2025-12-11 23:44:51');
INSERT INTO `users` VALUES (4, 'user2@example.com', 'user123', 'Trần Thị B', NULL, NULL, NULL, NULL, 1, '2025-12-11 23:44:51', '2025-12-11 23:44:51');
INSERT INTO `users` VALUES (5, 'user3@example.com', 'user123', 'Lê C', NULL, NULL, NULL, NULL, 1, '2025-12-11 23:44:51', '2026-01-15 16:21:44');
INSERT INTO `users` VALUES (6, 'tronglinh2708@...', 'pbkdf2$...', 'linh', NULL, NULL, NULL, NULL, 1, '2025-12-30 01:38:48', '2025-12-30 01:38:48');
INSERT INTO `users` VALUES (7, 'tronglinh2708@gmail.com', 'pbkdf2$120000$S7E3T34QEDn0CEtTnCQC_w$1OdEJrDwCldbgHMRuxSC0TpTlM3HxPhrdmeJ5jZvFTU', 'linh trọng', '', 'uploads/avatars/u7_622cc253-28f6-4672-b56e-b704b77e0db6.jpg', NULL, NULL, 1, '2026-01-03 00:22:49', '2026-01-16 08:18:59');

SET FOREIGN_KEY_CHECKS = 1;
