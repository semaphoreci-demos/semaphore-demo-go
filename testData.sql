CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  first_name TEXT,
  last_name TEXT
);

INSERT INTO users (first_name, last_name)
VALUES ('Mihalis', 'Tsoukalos');
INSERT INTO users (first_name, last_name)
VALUES ('Darko', 'Fabijan');
INSERT INTO users (first_name, last_name)
VALUES ('Marko', 'Anastasov');

