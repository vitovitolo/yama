DROP DATABASE `yama`;

CREATE DATABASE `yama`;

CREATE TABLE `yama`.`url_s0` ( 
	  `id` int(1) NOT NULL AUTO_INCREMENT,
	  `hostname` varchar(255) NOT NULL,
	  `port` smallint(1) unsigned NOT NULL DEFAULT 80,
	  `path` varchar(2048) NOT NULL,
	  `is_malware` boolean NOT NULL DEFAULT TRUE,
	  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 ; 

CREATE TABLE `yama`.`url_s1` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s2` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s3` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s4` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s5` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s6` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s7` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s8` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s9` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s10` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s11` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s12` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s13` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s14` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s15` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s16` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s17` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s18` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s19` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s20` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s21` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s22` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s23` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s24` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s25` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s26` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s27` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s28` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s29` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s30` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s31` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s32` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s33` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s34` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s35` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s36` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s37` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s38` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s39` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s40` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s41` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s42` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s43` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s44` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s45` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s46` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s47` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s48` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s49` LIKE `yama`.`url_s0` ;
CREATE TABLE `yama`.`url_s50` LIKE `yama`.`url_s0` ;

CREATE TABLE `yama`.`shards` (
	`shard` int(1) NOT NULL,
	`hostname` varchar(255) NOT NULL,
	`table_name` varchar(255) NOT NULL,
	PRIMARY KEY (`shard`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 ;

INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (0,'localhost','url_s0');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (1,'localhost','url_s1');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (2,'localhost','url_s2');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (3,'localhost','url_s3');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (4,'localhost','url_s4');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (5,'localhost','url_s5');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (6,'localhost','url_s6');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (7,'localhost','url_s7');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (8,'localhost','url_s8');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (9,'localhost','url_s9');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (10,'localhost','url_s10');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (11,'localhost','url_s11');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (12,'localhost','url_s12');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (13,'localhost','url_s13');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (14,'localhost','url_s14');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (15,'localhost','url_s15');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (16,'localhost','url_s16');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (17,'localhost','url_s17');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (18,'localhost','url_s18');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (19,'localhost','url_s19');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (20,'localhost','url_s20');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (21,'localhost','url_s21');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (22,'localhost','url_s22');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (23,'localhost','url_s23');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (24,'localhost','url_s24');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (25,'localhost','url_s25');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (26,'localhost','url_s26');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (27,'localhost','url_s27');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (28,'localhost','url_s28');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (29,'localhost','url_s29');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (30,'localhost','url_s30');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (31,'localhost','url_s31');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (32,'localhost','url_s32');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (33,'localhost','url_s33');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (34,'localhost','url_s34');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (35,'localhost','url_s35');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (36,'localhost','url_s36');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (37,'localhost','url_s37');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (38,'localhost','url_s38');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (39,'localhost','url_s39');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (40,'localhost','url_s40');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (41,'localhost','url_s41');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (42,'localhost','url_s42');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (43,'localhost','url_s43');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (44,'localhost','url_s44');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (45,'localhost','url_s45');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (46,'localhost','url_s46');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (47,'localhost','url_s47');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (48,'localhost','url_s48');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (49,'localhost','url_s49');
INSERT INTO `yama`.`shards` (shard,hostname,table_name) values (50,'localhost','url_s50');

GRANT ALL PRIVILEGES ON yama.* TO `yama`@`%` IDENTIFIED BY 'yama';

FLUSH PRIVILEGES;
