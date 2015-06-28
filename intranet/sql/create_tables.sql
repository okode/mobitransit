DROP DATABASE IF EXISTS sus_0_1;
CREATE DATABASE sus_0_1  DEFAULT CHARACTER SET utf8;
USE sus_0_1;

CREATE TABLE `t_user` (
	`c_id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
	`c_lastupdate` TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	`c_email` VARCHAR( 255 ) NOT NULL ,
	
	UNIQUE (
		`c_email`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `t_userconfig` (
  `c_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `c_lastupdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `c_userid` bigint(20) NOT NULL,
  `c_url_gtf` varchar(511) NOT NULL,
  `c_manage_layer` tinyint(1) NOT NULL DEFAULT '0',
  `c_share_data` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`c_id`),
  KEY `c_userid` (`c_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

ALTER TABLE `t_userconfig`
  ADD CONSTRAINT `t_userconfig_ibfk_1` FOREIGN KEY (`c_userid`) REFERENCES `t_user` (`c_id`) ON DELETE CASCADE ON UPDATE CASCADE;
