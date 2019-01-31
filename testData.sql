CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  first_name TEXT,
  last_name TEXT
);

INSERT INTO users (first_name, last_name)
VALUES ('Jonathan', 'Calhoun');
INSERT INTO users (first_name, last_name)
VALUES ('Bob', 'Smith');
INSERT INTO users (first_name, last_name)
VALUES ('Jerry', 'Seinfeld');

