DROP DATABASE `yama`;

CREATE DATABASE `yama`;

CREATE TABLE `yama`.`url` (
	  `id` int(1) NOT NULL AUTO_INCREMENT,
	  `hostname` varchar(255) NOT NULL,
	  `port` smallint(1) unsigned NOT NULL DEFAULT 80,
	  `path` varchar(2048) NOT NULL,
	  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 ; 

GRANT ALL PRIVILEGES ON yama.* TO `yama`@`%` IDENTIFIED BY 'yama';

FLUSH PRIVILEGES;
