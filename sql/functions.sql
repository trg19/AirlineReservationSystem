--Function for Schedule table
--manage prices with respect to dates for regular passengers

CREATE OR REPLACE FUNCTION get_flight_cost_regular(schedule_date DATE, regular_price FLOAT)
RETURNS FLOAT
AS $$
DECLARE
    current_date DATE;
    days_until_flight INT;
    cost_multiplier FLOAT;
BEGIN
    days_until_flight := schedule_date - current_date;
    
    IF days_until_flight <= 3 THEN
        cost_multiplier := 1.5;
    ELSIF days_until_flight <= 7 THEN
        cost_multiplier := 1.3;
    ELSIF days_until_flight <= 14 THEN
        cost_multiplier := 1.2;
    ELSIF days_until_flight <= 30 THEN
        cost_multiplier := 1.1;
    ELSE
        cost_multiplier := 1.0;
    END IF;
    
    RETURN regular_price * cost_multiplier ;
END;
$$ LANGUAGE plpgsql;


--Function for Schedule table
--manage prices with respect to dates for senior citizens

CREATE OR REPLACE FUNCTION get_flight_cost_senior(schedule_date DATE, regular_price FLOAT)
RETURNS FLOAT
AS $$
DECLARE
    current_date DATE;
    days_until_flight INT;
    cost_multiplier FLOAT;
    senior_citizen_price FLOAT;
BEGIN
    days_until_flight := schedule_date - current_date;
    senior_citizen_price := regular_price * 0.7;
    
    IF days_until_flight <= 3 THEN
        cost_multiplier := 1.5;
    ELSIF days_until_flight <= 7 THEN
        cost_multiplier := 1.3;
    ELSIF days_until_flight <= 14 THEN
        cost_multiplier := 1.2;
    ELSIF days_until_flight <= 30 THEN
        cost_multiplier := 1.1;
    ELSE
        cost_multiplier := 1.0;
    END IF;
    
    RETURN senior_citizen_price * cost_multiplier ;
END;
$$ LANGUAGE plpgsql;


--Function for Schedule table
--manage prices with respect to dates for armed forces

CREATE OR REPLACE FUNCTION get_flight_cost_armed(schedule_date DATE, regular_price FLOAT)
RETURNS FLOAT
AS $$
DECLARE
    current_date DATE;
    days_until_flight INT;
    cost_multiplier FLOAT;
    armed_forces_price FLOAT;
BEGIN
    days_until_flight := schedule_date - current_date;
    armed_forces_price := regular_price * 0.65;
    
    IF days_until_flight <= 3 THEN
        cost_multiplier := 1.5;
    ELSIF days_until_flight <= 7 THEN
        cost_multiplier := 1.3;
    ELSIF days_until_flight <= 14 THEN
        cost_multiplier := 1.2;
    ELSIF days_until_flight <= 30 THEN
        cost_multiplier := 1.1;
    ELSE
        cost_multiplier := 1.0;
    END IF;
    
    RETURN armed_forces_price * cost_multiplier ;
END;
$$ LANGUAGE plpgsql;



--Function for Schedule table
--manage prices with respect to dates for students

CREATE OR REPLACE FUNCTION get_flight_cost_student(schedule_date DATE, regular_price FLOAT)
RETURNS FLOAT
AS $$
DECLARE
    current_date DATE;
    days_until_flight INT;
    cost_multiplier FLOAT;
    student_price FLOAT;
BEGIN
    days_until_flight := schedule_date - current_date;
    student_price := regular_price * 0.8;
    
    IF days_until_flight <= 3 THEN
        cost_multiplier := 1.5;
    ELSIF days_until_flight <= 7 THEN
        cost_multiplier := 1.3;
    ELSIF days_until_flight <= 14 THEN
        cost_multiplier := 1.2;
    ELSIF days_until_flight <= 30 THEN
        cost_multiplier := 1.1;
    ELSE
        cost_multiplier := 1.0;
    END IF;
    
    RETURN student_price * cost_multiplier ;
END;
$$ LANGUAGE plpgsql;


--function to find out the time duration of any given flight by providing its id
CREATE OR REPLACE FUNCTION get_flight_duration(fid int, rid int)
RETURNS INTERVAL AS $$
DECLARE
    duration INTERVAL;
	dep_time time;
	arr_time time;
BEGIN
    SELECT s.departure_time, s.arrival_time
	INTO dep_time, arr_time
    FROM Schedule s
    WHERE s.flight_id = fid AND s.route_id = rid;
	
	IF NOT FOUND THEN
		RAISE EXCEPTION 'Flight ID % on Route ID % not found', fid, rid;
	END IF;
	
	duration := dep_time - arr_time;
	
    RETURN duration;
END;
$$ LANGUAGE plpgsql;


--function to get available number of seats 
CREATE OR REPLACE FUNCTION get_available_seats(f_id INT, r_id INT, f_date DATE) 
RETURNS INT AS $$
DECLARE
	tot_seats INT;
	booked_seats INT;
BEGIN

    -- Get total number of seats for the flight
    SELECT total_seats INTO tot_seats
    FROM Flight
    WHERE f_id = flight_id;

    -- Get number of booked seats for the flight on the given date
    SELECT COUNT(*) INTO booked_seats
    FROM Booking b
    JOIN Schedule s ON b.schedule_id = s.schedule_id
    JOIN Flight f ON s.flight_id = f.flight_id
    JOIN Route r ON s.route_id = r.route_id
    WHERE s.flight_id = f_id
    AND s.route_id = r_id
    AND b.flight_date = f_date;

    -- Calculate available seats
    RETURN tot_seats - booked_seats;
END;
$$ LANGUAGE plpgsql;




------------FUNCTIONS FOR ADMIN-----------------
--function to view bookings 
CREATE OR REPLACE FUNCTION view_bookings_by_flight(f_id INT) 
RETURNS TABLE (
    booking_id INT,
    passenger_name VARCHAR(100),
    schedule_date DATE,
    seat_no INT
) AS $$
BEGIN
    RETURN QUERY
        SELECT b.booking_id, CONCAT(p.first_name, ' ', p.last_name)::VARCHAR(100) AS passenger_name, b.flight_date AS schedule_date, b.seat_no
        FROM Booking b
        JOIN Passenger p ON b.passenger_id = p.passenger_id
        JOIN Schedule s ON b.schedule_id = s.schedule_id
        WHERE s.flight_id = f_id;
END;
$$ LANGUAGE plpgsql;


--edit flight schedule
CREATE OR REPLACE FUNCTION edit_flight_schedule(
    p_schedule_id int,
    p_arrival_time time,
    p_departure_time time,
    p_price int
) RETURNS void AS $$
BEGIN
    UPDATE Schedule
    SET arrival_time = p_arrival_time, departure_time = p_departure_time, price = p_price
    WHERE schedule_id = p_schedule_id;
END;
$$ LANGUAGE plpgsql;



--view airline revenue
CREATE OR REPLACE FUNCTION view_airline_revenue(
    p_airline_id int,
    p_start_date date,
    p_end_date date
) RETURNS int AS $$
DECLARE
    revenue int;
BEGIN
    SELECT SUM(t.transaction_amount) INTO revenue
    FROM Transaction_Table t
    JOIN Booking b ON t.booking_id = b.booking_id
    JOIN Schedule s ON b.schedule_id = s.schedule_id
    JOIN Flight f ON s.flight_id = f.flight_id
    WHERE f.airline_id = p_airline_id AND t.transaction_date BETWEEN p_start_date AND p_end_date;
    
    RETURN COALESCE(revenue, 0);
END;
$$ LANGUAGE plpgsql;


----------------------FUNCTIONS WHICH ARE USED FOR TRIGGERS----------------------------------
-- function to update the total seats in Flight table after a new Schedule is added(use in trigger)
CREATE OR REPLACE FUNCTION update_total_seats()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Flight SET total_seats = NEW.total_seats WHERE flight_id = 
    (SELECT flight_id FROM Schedule WHERE schedule_id = NEW.schedule_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--function to auto decrement seat status(use in trigger)
CREATE OR REPLACE FUNCTION decrement_seat_status()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Schedule 
    SET seat_status = seat_status - 1 
    WHERE schedule_id = NEW.schedule_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--function to check conflicting flights to use in trigger
CREATE OR REPLACE FUNCTION check_conflicting_bookings() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT * FROM Booking
               WHERE passenger_id = NEW.passenger_id
               AND flight_date = NEW.flight_date
               AND schedule_id IN (SELECT schedule_id FROM Schedule
                                   WHERE (arrival_time <= NEW.departure_time AND NEW.departure_time <= departure_time)
                                   OR (arrival_time <= NEW.arrival_time AND NEW.arrival_time <= departure_time))) THEN
        RAISE EXCEPTION 'Passenger already has a booking at the same date and time';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--function to only update the seat status when a booking is cancelled:(use in trigger)
CREATE OR REPLACE FUNCTION update_seat_status()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.transaction_type = 'Cancellation' THEN
        UPDATE Schedule SET seat_status = seat_status + 1 WHERE schedule_id = OLD.schedule_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;






