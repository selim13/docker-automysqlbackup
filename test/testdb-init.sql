CREATE DATABASE testdb;

USE testdb;

CREATE TABLE test_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
) ENGINE=INNODB;

INSERT INTO test_table(name) VALUES ('Hello world!');
INSERT INTO test_table(name) VALUES ('Hello world!');
INSERT INTO test_table(name) VALUES ('Hello world!');