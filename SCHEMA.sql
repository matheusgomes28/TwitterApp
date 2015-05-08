CREATE TABLE users(
username VARCHAR(20) PRIMARY KEY NOT NULL,
password VARCHAR(20) NOT NULL,
email VARCHAR(40) NOT NULL,
twitter VARCHAR(30) NOT NULL,
UNIQUE(username),
UNIQUE(twitter)
);
CREATE TABLE settings(
username VARCHAR(20) PRIMARY KEY NOT NULL,
consumer_key VARCHAR(70) NOT NULL,
consumer_secret VARCHAR(70) NOT NULL,
access_token VARCHAR(70) NOT NULL,
access_token_secret VARCHAR(70) NOT NULL
);
CREATE TABLE campaigns(
id INTEGER PRIMARY KEY NOT NULL,
name VARCHAR(20) NOT NULL
,
desc VARCHAR(120) NOT NULL,
keyword VARCHAR(20) NOT NULL,
username VARCHAR(20) NOT NULL,
FOREIGN KEY(username) REFERENCES users(username)
);
CREATE TABLE searches (
id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
username VARCHAR(20) NOT NULL,
search VARCHAR(30) NOT NULL,
date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
FOREIGN KEY(username) REFERENCES users(username)
);
CREATE TABLE sessions (
id INTEGER PRIMARY KEY AUTOINCREMENT,
username VARCHAR(20) NOT NULL,
date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
FOREIGN KEY(username) REFERENCES user(username)
);