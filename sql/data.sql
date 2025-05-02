-- Insert data into Airline table
INSERT INTO Airline(airline_id, airline_name) VALUES
(1, 'Air India'),
(2, 'American Airlines'),
(3, 'Air France'),
(4, 'Southwest Airlines'),
(5, 'IndiGo');

-- Insert data into Flight table (total number of flight_id is equal to the number of planes we have)
INSERT INTO Flight(flight_id, total_seats, airline_id) VALUES
(1, 150, 1),
(2, 200, 2),
(3, 180, 3),
(4, 120, 4),
(5, 160, 5),
(6, 250, 5),
(7, 300, 1),
(8, 300, 2),
(9, 150, 3),
(10, 280, 4),
(11, 350, 2),
(12, 350, 4);

-- Insert data into Route table
INSERT INTO Route(route_id, source, destination, route_name, distance) VALUES
(1, 'Mumbai', 'Delhi', 'BOM-DEL', 1150),
(2, 'Delhi', 'Mumbai', 'DEL-BOM', 1150),
(3, 'Mumbai', 'Chennai', 'BOM-MAA', 1038),
(4, 'Chennai','Mumbai', 'MAA-BOM', 1038),
(5, 'Mumbai', 'Hyderabad', 'BOM-HYD', 740),
(6, 'Hyderabad', 'Mumbai', 'HYD-BOM', 740),
(7, 'Hyderabad', 'Chennai', 'HYD-MAA', 625),
(8, 'Chennai', 'Hyderabad', 'MAA-HYD', 625),
(9, 'Hyderabad', 'Patna', 'HYD-PAT', 1515),
(10, 'Patna', 'Hyderabad', 'PAT-HYD', 1515),
(11, 'Hyderabad', 'Goa', 'HYD-GOI', 530),
(12, 'Goa', 'Hyderabad', 'GOI-HYD', 530),
(13, 'Delhi', 'Kolkata', 'DEL-CCU', 1304),
(14, 'Kolkata', 'Delhi', 'CCU-DEL', 1304),
(15, 'Bengaluru', 'Kolkata', 'BLR-CCU', 1433),
(16, 'Kolkata', 'Bengaluru', 'CCU-BLR', 1433),
(17, 'Mumbai', 'New York', 'BOM-JFK', 12067),
(18, 'New York', 'Mumbai', 'JFK-BOM', 12067),
(19, 'Mumbai', 'London', 'BOM-LHR', 7190),
(20, 'London', 'Mumbai','LHR-BOM', 7190),
(21, 'Bengaluru', 'Dubai', 'BLR-DXB', 2274),
(22, 'Dubai', 'Bengaluru', 'DXB-BLR', 2274),
(23, 'Hyderabad', 'Abu Dhabi', 'HYD-AUH', 2874),
(24, 'Abu Dhabi', 'Hyderabad', 'AUH-HYD', 2874),
(25, 'Hyderabad', 'Paris', 'HYD-CDG', 6653),
(26, 'Paris', 'Hyderabad', 'CDG-HYD', 6653),
(27, 'Delhi', 'Singapore', 'DEL-SIN', 4159),
(28, 'Singapore', 'Delhi', 'SIN-DEL', 4159),
(29, 'Delhi', 'Kathmandu', 'DEL-KTM', 848),
(30, 'Kathmandu', 'Delhi', 'KTM-DEL', 848),
(31, 'Chennai', 'Colombo', 'MAA-CMB', 1716),
(32, 'Colombo', 'Chennai', 'CMB-MAA', 1716),
(33, 'Thiruvananthapuram', 'Male', 'TRV-MLV', 900),
(34, 'Male', 'Thiruvananthapuram', 'MLV-TRV', 900),
(35, 'New York', 'Los Angeles', 'JFK-LAX', 2475),
(36, 'Los Angeles', 'New York', 'LAX-JFX', 2475),
(37, 'New York', 'Perth', 'JFK-FER', 12338),
(38, 'Perth', 'New York', 'FER-JFK', 12338),
(39, 'Chicago', 'Houston', 'ORD-IAH', 940),
(40, 'Houston', 'Chicago', 'IAH-ORD', 940),
(41, 'Houston', 'Miami', 'IAH-MIA', 965),
(42, 'Miami', 'Houston', 'MIA-IAH', 965),
(43, 'Seattle', 'Denver', 'SEA-DEN', 1024),
(44, 'Denver', 'Seattle', 'DEN-SEA', 1024),
(45, 'Dubai', 'Sydney', 'DXB-SYD', 12073),
(46, 'Sydney', 'Dubai', 'SYD-DXB', 12073),
(47, 'Paris', 'Tokyo', 'CDG-HND', 9715),
(48, 'Tokyo', 'Paris', 'HND-CDG', 9715),
(49, 'Bangkok', 'Kolkata', 'CCU-BKK', 1765),
(50, 'Kolkata', 'Bangkok', 'BKK-CCU', 1765);


-- Insert data into Schedule table
INSERT INTO Schedule (schedule_id, arrival_time, departure_time, price, flight_id, route_id) VALUES
(1, '03:00:00', '05:00:00', 4090, 1, 1),
(2, '07:00:00', '09:00:00', 4090, 1, 2),


(3, '10:00:00', '15:35:00', 54090, 1, 17),
(4, '17:00:00', '22:35:00', 54090, 1, 18),


(5, '23:15:00', '00:50:00', 6593, 1, 3),
(6, '01:15:00', '02:50:00', 6593, 1, 4),


(7, '00:10:00', '02:15:00', 7832, 2, 11),
(8, '02:45:00', '04:50:00', 7832, 2, 12),


(9, '05:15:00', '22:45:00', 75963, 2, 25),
(10, '20:15:00', '10:45:00', 75963, 3, 26),


(11, '11:15:00', '12:00:00', 3256, 3, 7),
(12, '12:15:00', '13:00:00', 3256, 3, 8),


(13, '14:15:00', '16:15:00', 6573, 3, 9),
(14, '17:15:00', '19:15:00', 6573, 3, 10),


(15, '01:25:00', '19:40:00', 56321, 4, 47),
(16, '20:25:00', '14:40:00', 56321, 5, 48),


(17, '20:25:00', '21:40:00', 3919, 4, 5),
(18, '22:25:00', '23:40:00', 3919, 4, 6),


(19, '15:40:00', '17:50:00', 6209, 5, 13),
(20, '18:00:00', '20:10:00', 6209, 5, 14),


(21, '07:10:00', '17:10:00', 33352, 6, 19),
(22, '17:45:00', '03:00:00', 33352, 6, 20),


(23, '00:34:00', '02:54:00', 13491, 7, 40),
(24, '03:34:00', '05:54:00', 13491, 7, 39),


(25, '06:40:00', '08:15:00', 12674, 7, 41),
(26, '08:40:00', '10:15:00', 12674, 7, 42),


(27, '12:40:00', '17:45:00', 14400, 7, 28),
(28, '18:40:00', '23:45:00', 14400, 7, 27),


(29, '06:00:00', '08:35:00', 6593, 8, 15),
(30, '09:00:00', '11:35:00', 6593, 8, 16),


(31, '12:00:00', '15:40:00', 21417, 8, 21),
(32, '16:00:00', '19:40:00', 21417, 8, 22),


(33, '20:00:00', '21:45:00', 5096, 8, 29),
(34, '22:00:00', '23:45:00', 5096, 8, 30),


(35, '00:30:00', '01:45:00', 6735, 8, 31),
(36, '02:30:00', '03:45:00', 6735, 8, 32),


(37, '06:30:00', '12:30:00', 15686, 9, 33),
(38, '13:30:00', '19:30:00', 15686, 9, 34),


(39, '21:30:00', '00:10:00', 10965, 9, 50),
(40, '01:30:00', '03:10:00', 10965, 9, 49),


(41, '20:30:00', '23:18:00', 14555, 10, 35),
(42, '00:30:00', '03:18:00', 14555, 10, 36),


(43, '04:00:00', '10:30:00', 817435, 10, 37),
(44, '11:00:00', '17:30:00', 817435, 10, 38),


(45, '18:30:00', '22:15:00', 10454, 11, 43),
(46, '23:30:00', '03:15:00', 10454, 11, 44),


(47, '04:00:00', '10:15:00', 43753, 11, 45),
(48, '11:00:00', '17:15:00', 43753, 11, 46),


(49, '04:20:00', '06:25:00', 22507, 12, 23),
(50, '07:20:00', '09:25:00', 22507, 12, 24);