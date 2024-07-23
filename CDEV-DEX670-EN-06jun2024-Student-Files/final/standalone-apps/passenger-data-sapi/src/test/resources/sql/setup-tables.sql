CREATE TABLE IF NOT EXISTS passenger_accounts (
    loyalty_no varchar(255),
    lastname varchar(255),
    passport_id varchar(255)
);
INSERT INTO passenger_accounts (loyalty_no, lastname, passport_id) VALUES ('LNO123', 'LN', 'P123456MANY');
INSERT INTO passenger_accounts (loyalty_no, lastname, passport_id) VALUES ('LN2', 'LN2', 'P123456MANY');
INSERT INTO passenger_accounts (loyalty_no, lastname, passport_id) VALUES ('LN3', 'LN2', 'P123456MANY');
INSERT INTO passenger_accounts (loyalty_no, lastname, passport_id) VALUES ('LNO123', 'LN', 'P123456');

CREATE TABLE IF NOT EXISTS passenger_flights_checkin (
    loyalty_no varchar(255),
    flight_date varchar(255),
    flight_no varchar(255),
    flight_origin varchar(255),
    flight_destination varchar(255),
    checkin_utc varchar(255)
);