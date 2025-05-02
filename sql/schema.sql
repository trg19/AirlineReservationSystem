CREATE TABLE Airline(
    airline_id int PRIMARY KEY,
    airline_name varchar(50) NOT NULL
);

CREATE TABLE Flight(
    flight_id int PRIMARY KEY,
    total_seats int NOT NULL,
    airline_id int NOT NULL,
    FOREIGN KEY(airline_id) REFERENCES Airline(airline_id) ON DELETE CASCADE
);

CREATE TABLE Route(
    route_id int PRIMARY KEY,
    source varchar(50) NOT NULL,
    destination varchar(50) NOT NULL,
    route_name varchar(50) NOT NULL,
    distance int NOT NULL
);

CREATE TABLE Schedule(
    schedule_id int NOT NULL,
    arrival_time time NOT NULL,
    departure_time time NOT NULL,
    price int NOT NULL,
    flight_id int NOT NULL,
    route_id int NOT NULL,
    PRIMARY KEY(schedule_id),
    FOREIGN KEY(flight_id) REFERENCES Flight(flight_id) ON DELETE CASCADE,
    FOREIGN KEY(route_id) REFERENCES Route(route_id) ON DELETE CASCADE
);

CREATE TABLE Passenger(
    passenger_id int PRIMARY KEY,
    FOREIGN KEY(user_id) REFERENCES User_Table(user_id) ON DELETE CASCADE,
    title varchar(5) NOT NULL,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    gender varchar(10) NOT NULL,
    email varchar(50) NOT NULL,
    dob date NOT NULL,
    identity_card_id int UNIQUE NOT NULL,
    contact_number varchar(15) NOT NULL,
    age varchar(25) NOT NULL,
    passenger_type varchar(30) NOT NULL
);

CREATE TABLE Booking(
    booking_id int PRIMARY KEY,
    passenger_id int NOT NULL,
    schedule_id int NOT NULL,
    seat_no int NOT NULL,
    flight_date date NOT NULL,
    FOREIGN KEY(passenger_id) REFERENCES Passenger(passenger_id) ON DELETE CASCADE,
    FOREIGN KEY(schedule_id) REFERENCES Schedule(schedule_id) ON DELETE CASCADE
);

CREATE TABLE User_Table(
    user_id int PRIMARY KEY,
    first_name varchar(30) NOT NULL,
    last_name varchar(30) NOT NULL,
    password varchar(50) NOT NULL,
    contact_number varchar(15) NOT NULL,
    email varchar(50) NOT NULL
);

CREATE TABLE Books_for(
    passenger_id int NOT NULL,
    user_id int NOT NULL,
    PRIMARY KEY(passenger_id, user_id),
    FOREIGN KEY(passenger_id) REFERENCES Passenger(passenger_id) ON DELETE CASCADE,
    FOREIGN KEY(user_id) REFERENCES User_Table(user_id) ON DELETE CASCADE
);

CREATE TABLE Transaction_Table(
    transaction_id int PRIMARY KEY,
    booking_id int NOT NULL,
    passenger_id int NOT NULL,
    discount_code varchar(50) NULL,
    discount_amount int NOT NULL,
    discount_conditions varchar(50) NOT NULL,
    transaction_amount int NOT NULL,
    transaction_date date NOT NULL,
    transaction_time TIMESTAMP NOT NULL,
    transaction_type varchar(20) NOT NULL,
    FOREIGN KEY(passenger_id) REFERENCES Passenger(passenger_id) ON DELETE CASCADE,
    FOREIGN KEY(transaction_id) REFERENCES Booking(booking_id) ON DELETE CASCADE
);