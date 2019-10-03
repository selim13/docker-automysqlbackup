CREATE DATABASE testdb;

USE testdb;

CREATE TABLE sometable (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
) ENGINE=INNODB;

INSERT INTO sometable(name) VALUES ('Hello world!');