-- CREATE the DATABASE
DROP DATABASE IF EXISTS MovieDemo;
CREATE DATABASE MovieDemo;

-- select the DATABASE
USE MovieDemo;

/* Delete the TABLEs if they already exist */
DROP TABLE IF EXISTS movie;

/* CREATE the schema for our TABLEs */
CREATE TABLE movie(
	mID INT, 
	title VARCHAR(100), 
	movieYear INT, 
	director VARCHAR(100),
	PRIMARY KEY(mID),
	CONSTRAINT uq_title UNIQUE(title)
	);

/* Populate the TABLEs with our data */
INSERT INTO Movie VALUES(101, 'Gone with the Wind', 1939, 'Victor Fleming');
INSERT INTO Movie VALUES(102, 'Star Wars', 1977, 'George Lucas');
INSERT INTO Movie VALUES(103, 'The Sound of Music', 1965, 'Robert Wise');
INSERT INTO Movie VALUES(104, 'E.T.', 1982, 'Steven Spielberg');
INSERT INTO Movie VALUES(105, 'Titanic', 1997, 'James Cameron');
INSERT INTO Movie VALUES(106, 'Snow White', 1937, null);
INSERT INTO Movie VALUES(107, 'Avatar', 2009, 'James Cameron');
INSERT INTO Movie VALUES(108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg');

