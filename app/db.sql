DROP DATABASE IF EXISTS quiz;

CREATE DATABASE IF NOT EXISTS quiz default charset utf8 COLLATE utf8_bin;

GRANT ALL PRIVILEGES ON *.* TO 'quiz'@'localhost' IDENTIFIED BY 'quiz' WITH GRANT OPTION;

use quiz;

CREATE TABLE TB_QUESTION (
  id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  title VARCHAR(255) NOT NULL COMMENT '标题',
  content TEXT COMMENT '内容',
  answer VARCHAR(1) NOT NULL DEFAULT 'A' COMMENT '答案:A B C D',
  note TEXT COMMENT '题目分析',
  c_time TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '状态:0:启用 1：弃用',
  PRIMARY KEY (id)
) ENGINE InnoDB DEFAULT CHARSET=utf8 COMMENT '题库';

CREATE TABLE TB_CORRECTION_ITEM (
  id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  qsid INT(11) NOT NULL COMMENT '题目id',
  userid VARCHAR(255) NOT NULL COMMENT '用户id',
  c_time TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  PRIMARY KEY (id)
) ENGINE InnoDB DEFAULT CHARSET=utf8 COMMENT '错题库';

CREATE TABLE TB_SCORE (
  id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  userid VARCHAR(255) NOT NULL COMMENT '用户id',
  expended_time INT(11) NOT NULL COMMENT '答题时间',
  right_count INT(11) NOT NULL COMMENT '对题数量',
  c_time TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  PRIMARY KEY (id)
) ENGINE InnoDB DEFAULT CHARSET=utf8 COMMENT '成绩';

CREATE TABLE TB_USER (
  id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  openid VARCHAR(255) NOT NULL COMMENT '微信用户openid',
  headimgurl VARCHAR(255) NOT NULL COMMENT '微信用户头像地址',
  unionid VARCHAR(255) NOT NULL COMMENT '微信用户unionid',
  nickname VARCHAR(255) NOT NULL COMMENT '微信用户昵称',
  c_time TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  PRIMARY KEY (id)
) ENGINE InnoDB DEFAULT CHARSET=utf8 COMMENT '用户';