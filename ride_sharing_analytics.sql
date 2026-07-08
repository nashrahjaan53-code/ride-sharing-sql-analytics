CREATE DATABASE ride_sharing_analytics;
USE ride_sharing_analytics;
CREATE TABLE drivers (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    vehicle_type ENUM('Economy', 'Comfort', 'Premium', 'SUV', 'Van') NOT NULL,
    vehicle_year YEAR NOT NULL,
    license_plate VARCHAR(15) UNIQUE NOT NULL,
    rating DECIMAL(3,2) DEFAULT 5.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (rating BETWEEN 1.00 AND 5.00)
);

CREATE TABLE riders (
    rider_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    preferred_payment ENUM('Credit Card', 'Debit Card', 'PayPal', 'Cash') DEFAULT 'Credit Card',
    loyalty_points INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    location_name VARCHAR(100) NOT NULL,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    city VARCHAR(50) NOT NULL,
    zone ENUM('Downtown', 'Suburban', 'Airport', 'University', 'Business District', 'Residential') NOT NULL,
    UNIQUE KEY unique_coords (latitude, longitude),
    CHECK (latitude BETWEEN -90 AND 90),
    CHECK (longitude BETWEEN -180 AND 180)
);

CREATE TABLE rides (
    ride_id INT PRIMARY KEY AUTO_INCREMENT,
    rider_id INT NOT NULL,
    driver_id INT NOT NULL,
    pickup_location_id INT NOT NULL,
    dropoff_location_id INT NOT NULL,
    ride_status ENUM('Requested', 'Accepted', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Requested',
    distance_km DECIMAL(5,2) NOT NULL,
    duration_minutes INT NOT NULL,
    fare_amount DECIMAL(7,2) NOT NULL,
    surge_multiplier DECIMAL(3,2) DEFAULT 1.00,
    payment_method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Cash') NOT NULL,
    ride_request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ride_start_time TIMESTAMP NULL,
    ride_end_time TIMESTAMP NULL,
    FOREIGN KEY (rider_id) REFERENCES riders(rider_id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE,
    FOREIGN KEY (pickup_location_id) REFERENCES locations(location_id),
    FOREIGN KEY (dropoff_location_id) REFERENCES locations(location_id),
    CHECK (distance_km > 0),
    CHECK (duration_minutes > 0),
    CHECK (fare_amount > 0)
);

CREATE TABLE ride_ratings (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT UNIQUE NOT NULL,
    driver_rating DECIMAL(2,1),
    rider_rating DECIMAL(2,1),
    driver_feedback TEXT,
    rider_feedback TEXT,
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ride_id) REFERENCES rides(ride_id) ON DELETE CASCADE,
    CHECK (driver_rating BETWEEN 1.0 AND 5.0),
    CHECK (rider_rating BETWEEN 1.0 AND 5.0)
);

INSERT INTO drivers (first_name, last_name, email, phone, vehicle_type, vehicle_year, license_plate, rating) VALUES
('John', 'Smith', 'john.smith@email.com', '+12345678901', 'Economy', 2020, 'ABC123', 4.85),
('Maria', 'Garcia', 'maria.g@email.com', '+12345678902', 'Comfort', 2022, 'XYZ789', 4.92),
('David', 'Lee', 'david.lee@email.com', '+12345678903', 'Premium', 2023, 'DEF456', 4.78),
('Sarah', 'Johnson', 'sarah.j@email.com', '+12345678904', 'SUV', 2021, 'GHI789', 4.65),
('Mike', 'Brown', 'mike.b@email.com', '+12345678905', 'Van', 2020, 'JKL012', 4.90);

INSERT INTO riders (first_name, last_name, email, phone, preferred_payment, loyalty_points) VALUES
('Emma', 'Wilson', 'emma.w@email.com', '+12345678911', 'Credit Card', 150),
('James', 'Taylor', 'james.t@email.com', '+12345678912', 'PayPal', 320),
('Sophia', 'Martinez', 'sophia.m@email.com', '+12345678913', 'Debit Card', 85),
('Robert', 'Davis', 'robert.d@email.com', '+12345678914', 'Credit Card', 540),
('Olivia', 'Anderson', 'olivia.a@email.com', '+12345678915', 'Cash', 210);

INSERT INTO locations (location_name, latitude, longitude, city, zone) VALUES
('Downtown Central', 40.712776, -74.005974, 'New York', 'Downtown'),
('JFK Airport', 40.641766, -73.780968, 'New York', 'Airport'),
('NYU Campus', 40.729513, -73.996461, 'New York', 'University'),
('Upper East Side', 40.773564, -73.956555, 'New York', 'Residential'),
('Wall Street', 40.707491, -74.011276, 'New York', 'Business District'),
('Brooklyn Bridge', 40.706086, -73.996864, 'New York', 'Downtown'),
('Central Park', 40.781219, -73.966515, 'New York', 'Suburban'),
('Times Square', 40.758895, -73.985131, 'New York', 'Downtown'),
('LaGuardia Airport', 40.776927, -73.873966, 'New York', 'Airport'),
('Columbia University', 40.807536, -73.962573, 'New York', 'University');

INSERT INTO rides (rider_id, driver_id, pickup_location_id, dropoff_location_id, 
                   ride_status, distance_km, duration_minutes, fare_amount, 
                   surge_multiplier, payment_method, ride_request_time, 
                   ride_start_time, ride_end_time) VALUES
(1, 1, 1, 3, 'Completed', 8.5, 25, 28.50, 1.2, 'Credit Card', 
 '2024-01-15 08:30:00', '2024-01-15 08:32:00', '2024-01-15 08:57:00'),
(2, 2, 2, 1, 'Completed', 24.3, 45, 67.80, 1.0, 'PayPal',
 '2024-01-15 09:15:00', '2024-01-15 09:18:00', '2024-01-15 10:03:00'),
(3, 3, 4, 2, 'Completed', 18.7, 38, 52.40, 1.5, 'Debit Card',
 '2024-01-15 17:45:00', '2024-01-15 17:48:00', '2024-01-15 18:26:00'),
(4, 4, 3, 5, 'Completed', 5.2, 15, 18.90, 1.0, 'Credit Card',
 '2024-01-15 12:20:00', '2024-01-15 12:22:00', '2024-01-15 12:37:00'),
(5, 5, 5, 4, 'Completed', 12.8, 30, 35.60, 1.3, 'Cash',
 '2024-01-15 20:10:00', '2024-01-15 20:13:00', '2024-01-15 20:43:00'),
(1, 2, 6, 7, 'Completed', 6.3, 20, 22.10, 1.0, 'Credit Card',
 '2024-01-16 07:45:00', '2024-01-16 07:47:00', '2024-01-16 08:07:00'),
(2, 3, 7, 8, 'Completed', 9.1, 28, 31.50, 1.4, 'PayPal',
 '2024-01-16 18:30:00', '2024-01-16 18:33:00', '2024-01-16 19:01:00'),
(3, 4, 8, 9, 'Completed', 15.4, 35, 48.20, 1.0, 'Debit Card',
 '2024-01-17 10:15:00', '2024-01-17 10:17:00', '2024-01-17 10:52:00'),
(4, 5, 9, 10, 'Completed', 22.6, 42, 63.80, 1.2, 'Credit Card',
 '2024-01-17 16:45:00', '2024-01-17 16:48:00', '2024-01-17 17:30:00'),
(5, 1, 10, 6, 'Completed', 11.2, 32, 39.40, 1.0, 'Cash',
 '2024-01-18 14:20:00', '2024-01-18 14:23:00', '2024-01-18 14:55:00');

INSERT INTO ride_ratings (ride_id, driver_rating, rider_rating, driver_feedback, rider_feedback) VALUES
(1, 4.5, 5.0, 'Good passenger, polite', 'Great driver, smooth ride'),
(2, 5.0, 4.5, 'Excellent rider', 'Driver was punctual'),
(3, 4.0, 4.0, 'Average ride', 'Driver was okay'),
(4, 4.5, 5.0, 'Very good', 'Excellent service'),
(5, 5.0, 4.5, 'Perfect ride', 'Good driver, clean car'),
(6, 4.0, 4.0, 'On time', 'Satisfactory'),
(7, 4.5, 4.5, 'Good conversation', 'Nice driver'),
(8, 5.0, 5.0, 'Excellent', 'Perfect ride'),
(9, 4.0, 4.5, 'Smooth ride', 'Very professional'),
(10, 4.5, 4.0, 'Good passenger', 'Driver was fine');

SELECT 'OVERALL RIDE ANALYTICS' AS report_title;
SELECT 
    COUNT(*) AS total_rides,
    SUM(fare_amount) AS total_revenue,
    AVG(fare_amount) AS avg_fare_per_ride,
    AVG(distance_km) AS avg_distance_km,
    AVG(duration_minutes) AS avg_duration_minutes,
    AVG(fare_amount / distance_km) AS avg_fare_per_km
FROM rides
WHERE ride_status = 'Completed';

SELECT 'DAILY RIDE PATTERNS' AS report_title;
SELECT 
    DATE(ride_request_time) AS ride_date,
    COUNT(*) AS rides_count,
    SUM(fare_amount) AS daily_revenue,
    AVG(distance_km) AS avg_daily_distance,
    HOUR(ride_request_time) AS hour_of_day,
    COUNT(*) AS rides_per_hour
FROM rides
WHERE ride_status = 'Completed'
GROUP BY DATE(ride_request_time), HOUR(ride_request_time)
ORDER BY ride_date, hour_of_day;

SELECT 'DRIVER PERFORMANCE ANALYSIS' AS report_title;
SELECT 
    d.driver_id,
    CONCAT(d.first_name, ' ', d.last_name) AS driver_name,
    d.vehicle_type,
    d.rating AS driver_rating,
    COUNT(r.ride_id) AS total_rides,
    SUM(r.fare_amount) AS total_earnings,
    AVG(r.fare_amount) AS avg_earnings_per_ride,
    AVG(r.distance_km) AS avg_ride_distance,
    AVG(rr.driver_rating) AS avg_received_rating
FROM drivers d
LEFT JOIN rides r ON d.driver_id = r.driver_id AND r.ride_status = 'Completed'
LEFT JOIN ride_ratings rr ON r.ride_id = rr.ride_id
GROUP BY d.driver_id, d.first_name, d.last_name, d.vehicle_type, d.rating
ORDER BY total_earnings DESC;

SELECT 'SPATIAL ANALYSIS - ZONE ACTIVITY' AS report_title;
SELECT 
    'Pickup' AS location_type,
    l.zone,
    COUNT(r.ride_id) AS ride_count,
    AVG(r.fare_amount) AS avg_fare,
    AVG(r.distance_km) AS avg_distance
FROM locations l
JOIN rides r ON l.location_id = r.pickup_location_id
WHERE r.ride_status = 'Completed'
GROUP BY l.zone
UNION ALL
SELECT 
    'Dropoff' AS location_type,
    l.zone,
    COUNT(r.ride_id) AS ride_count,
    AVG(r.fare_amount) AS avg_fare,
    AVG(r.distance_km) AS avg_distance
FROM locations l
JOIN rides r ON l.location_id = r.dropoff_location_id
WHERE r.ride_status = 'Completed'
GROUP BY l.zone
ORDER BY location_type, ride_count DESC;

SELECT 'RIDER LOYALTY ANALYSIS' AS report_title;
SELECT 
    rd.rider_id,
    CONCAT(rd.first_name, ' ', rd.last_name) AS rider_name,
    COUNT(r.ride_id) AS total_rides_taken,
    SUM(r.fare_amount) AS total_spent,
    AVG(r.fare_amount) AS avg_spent_per_ride,
    rd.loyalty_points,
    AVG(rr.rider_rating) AS avg_rider_rating
FROM riders rd
LEFT JOIN rides r ON rd.rider_id = r.rider_id AND r.ride_status = 'Completed'
LEFT JOIN ride_ratings rr ON r.ride_id = rr.ride_id
GROUP BY rd.rider_id, rd.first_name, rd.last_name, rd.loyalty_points
ORDER BY total_spent DESC;

SELECT 'SURGE PRICING ANALYSIS' AS report_title;
SELECT 
    CASE 
        WHEN HOUR(ride_request_time) BETWEEN 7 AND 9 THEN 'Morning Peak (7-9)'
        WHEN HOUR(ride_request_time) BETWEEN 16 AND 19 THEN 'Evening Peak (16-19)'
        WHEN HOUR(ride_request_time) BETWEEN 20 AND 23 THEN 'Night (20-23)'
        WHEN HOUR(ride_request_time) BETWEEN 0 AND 6 THEN 'Late Night (0-6)'
        ELSE 'Off-Peak'
    END AS time_period,
    COUNT(*) AS total_rides,
    AVG(surge_multiplier) AS avg_surge_multiplier,
    AVG(fare_amount) AS avg_fare,
    SUM(fare_amount) AS total_revenue
FROM rides
WHERE ride_status = 'Completed'
GROUP BY time_period
ORDER BY avg_surge_multiplier DESC;

SELECT 'VEHICLE TYPE PERFORMANCE' AS report_title;
SELECT 
    d.vehicle_type,
    COUNT(r.ride_id) AS total_rides,
    AVG(r.fare_amount) AS avg_fare,
    AVG(r.distance_km) AS avg_distance,
    AVG(r.duration_minutes) AS avg_duration,
    AVG(rr.driver_rating) AS avg_driver_rating,
    SUM(r.fare_amount) AS total_revenue
FROM drivers d
JOIN rides r ON d.driver_id = r.driver_id AND r.ride_status = 'Completed'
LEFT JOIN ride_ratings rr ON r.ride_id = rr.ride_id
GROUP BY d.vehicle_type
ORDER BY total_revenue DESC;

SELECT 'RIDE EFFICIENCY METRICS' AS report_title;
SELECT 
    ride_id,
    TIMESTAMPDIFF(MINUTE, ride_request_time, ride_start_time) AS wait_time_minutes,
    TIMESTAMPDIFF(MINUTE, ride_start_time, ride_end_time) AS actual_ride_duration,
    duration_minutes AS estimated_duration,
    distance_km,
    fare_amount,
    fare_amount / distance_km AS fare_per_km,
    (fare_amount / distance_km) * 100 AS fare_per_100km
FROM rides
WHERE ride_status = 'Completed'
ORDER BY wait_time_minutes;

SELECT 'TOP 5 POPULAR ROUTES' AS report_title;
SELECT 
    pl.location_name AS pickup_location,
    dl.location_name AS dropoff_location,
    COUNT(*) AS ride_count,
    AVG(r.distance_km) AS avg_distance,
    AVG(r.fare_amount) AS avg_fare,
    AVG(r.duration_minutes) AS avg_duration
FROM rides r
JOIN locations pl ON r.pickup_location_id = pl.location_id
JOIN locations dl ON r.dropoff_location_id = dl.location_id
WHERE r.ride_status = 'Completed'
GROUP BY pl.location_name, dl.location_name
ORDER BY ride_count DESC
LIMIT 5;

SELECT 'PAYMENT METHOD ANALYSIS' AS report_title;
SELECT 
    payment_method,
    COUNT(*) AS transaction_count,
    SUM(fare_amount) AS total_amount,
    AVG(fare_amount) AS avg_transaction_value,
    COUNT(DISTINCT rider_id) AS unique_users
FROM rides
WHERE ride_status = 'Completed'
GROUP BY payment_method
ORDER BY total_amount DESC;

CREATE VIEW daily_performance_dashboard AS
SELECT 
    DATE(ride_request_time) AS performance_date,
    COUNT(*) AS total_rides,
    SUM(fare_amount) AS daily_revenue,
    AVG(fare_amount) AS avg_fare,
    COUNT(DISTINCT driver_id) AS active_drivers,
    COUNT(DISTINCT rider_id) AS active_riders,
    AVG(TIMESTAMPDIFF(MINUTE, ride_request_time, ride_start_time)) AS avg_wait_time
FROM rides
WHERE ride_status = 'Completed'
GROUP BY DATE(ride_request_time);
SELECT * FROM daily_performance_dashboard ORDER BY performance_date DESC;
SELECT 
    performance_date,
    total_rides,
    CONCAT('$', FORMAT(daily_revenue, 2)) AS daily_revenue,
    CONCAT('$', FORMAT(avg_fare, 2)) AS avg_fare,
    active_drivers,
    active_riders,
    CONCAT(FORMAT(avg_wait_time, 1), ' mins') AS avg_wait_time
FROM daily_performance_dashboard 
ORDER BY performance_date DESC;
CREATE OR REPLACE VIEW driver_earning_summary AS
SELECT 
    d.driver_id,
    CONCAT(d.first_name, ' ', d.last_name) AS driver_name,
    d.vehicle_type,
    COUNT(DISTINCT r.ride_id) AS completed_rides,
    COALESCE(SUM(r.fare_amount), 0) AS total_earnings,
    COALESCE(AVG(r.fare_amount), 0) AS avg_ride_earnings,
    COALESCE(AVG(rr.driver_rating), 0) AS avg_rating
FROM drivers d
LEFT JOIN rides r ON d.driver_id = r.driver_id AND r.ride_status = 'Completed'
LEFT JOIN ride_ratings rr ON r.ride_id = rr.ride_id
GROUP BY d.driver_id, d.first_name, d.last_name, d.vehicle_type;
SELECT * FROM driver_earning_summary ORDER BY total_earnings DESC;

CREATE VIEW hotspot_locations AS
SELECT 
    l.location_id,
    l.location_name,
    l.zone,
    l.city,
    COUNT(CASE WHEN r.pickup_location_id = l.location_id THEN 1 END) AS pickup_count,
    COUNT(CASE WHEN r.dropoff_location_id = l.location_id THEN 1 END) AS dropoff_count,
    COUNT(CASE WHEN r.pickup_location_id = l.location_id OR r.dropoff_location_id = l.location_id THEN 1 END) AS total_activity
FROM locations l
LEFT JOIN rides r ON l.location_id IN (r.pickup_location_id, r.dropoff_location_id) 
    AND r.ride_status = 'Completed'
GROUP BY l.location_id, l.location_name, l.zone, l.city
ORDER BY total_activity DESC;
SELECT * FROM hotspot_locations;
DELIMITER $$
CREATE PROCEDURE GetRiderHistory(IN rider_id_param INT)
BEGIN
    SELECT 
        r.ride_id,
        CONCAT(d.first_name, ' ', d.last_name) AS driver_name,
        pl.location_name AS pickup_location,
        dl.location_name AS dropoff_location,
        r.distance_km,
        r.duration_minutes,
        r.fare_amount,
        r.ride_request_time,
        rr.driver_rating,
        rr.rider_rating
    FROM rides r
    JOIN drivers d ON r.driver_id = d.driver_id
    JOIN locations pl ON r.pickup_location_id = pl.location_id
    JOIN locations dl ON r.dropoff_location_id = dl.location_id
    LEFT JOIN ride_ratings rr ON r.ride_id = rr.ride_id
    WHERE r.rider_id = rider_id_param
    AND r.ride_status = 'Completed'
    ORDER BY r.ride_request_time DESC;
END$$
DELIMITER ;
CALL GetRiderHistory(1);
CALL GetRiderHistory(2);
CALL GetRiderHistory(3);
CALL GetRiderHistory(4);
CALL GetRiderHistory(5);


DELIMITER $$
CREATE PROCEDURE CalculateDriverEarnings(
    IN driver_id_param INT,
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT 
        d.driver_id,
        CONCAT(d.first_name, ' ', d.last_name) AS driver_name,
        COUNT(r.ride_id) AS rides_completed,
        SUM(r.fare_amount) AS total_earnings,
        AVG(r.fare_amount) AS avg_earning_per_ride,
        MIN(r.fare_amount) AS min_earning,
        MAX(r.fare_amount) AS max_earning
    FROM drivers d
    LEFT JOIN rides r ON d.driver_id = r.driver_id
        AND r.ride_status = 'Completed'
        AND DATE(r.ride_request_time) BETWEEN start_date AND end_date
    WHERE d.driver_id = driver_id_param
    GROUP BY d.driver_id, d.first_name, d.last_name;
END$$
DELIMITER ;
CALL CalculateDriverEarnings(2, '2024-01-01', '2024-01-31');
CALL CalculateDriverEarnings(1, '2024-01-15', '2024-01-18');
CALL CalculateDriverEarnings(2, '2024-01-15', '2024-01-18');
CALL CalculateDriverEarnings(3, '2024-01-15', '2024-01-18');
CALL CalculateDriverEarnings(4, '2024-01-15', '2024-01-18');
CALL CalculateDriverEarnings(5, '2024-01-15', '2024-01-18');

SELECT * FROM daily_performance_dashboard ORDER BY performance_date DESC;
SELECT * FROM driver_earnings_summary ORDER BY total_earnings DESC LIMIT 5;

SELECT * FROM hotspot_locations LIMIT 10;
CALL GetRiderHistory(1);

CALL CalculateDriverEarnings(1, '2024-01-15', '2024-01-18');

SELECT 
    HOUR(ride_request_time) AS hour,
    COUNT(*) AS ride_count,
    RPAD('■', COUNT(*)/2, '■') AS visual_chart
FROM rides
WHERE ride_status = 'Completed'
GROUP BY HOUR(ride_request_time)
ORDER BY hour;

SELECT 
    pickup.zone AS from_zone,
    dropoff.zone AS to_zone,
    COUNT(*) AS ride_count,
    AVG(rides.distance_km) AS avg_distance,
    AVG(rides.fare_amount) AS avg_fare
FROM rides
JOIN locations pickup ON rides.pickup_location_id = pickup.location_id
JOIN locations dropoff ON rides.dropoff_location_id = dropoff.location_id
WHERE rides.ride_status = 'Completed'
GROUP BY pickup.zone, dropoff.zone
ORDER BY ride_count DESC;

SELECT 
    'Data Quality Check' AS check_type,
    COUNT(*) AS total_rides,
    SUM(CASE WHEN ride_end_time < ride_start_time THEN 1 ELSE 0 END) AS invalid_time_rides,
    SUM(CASE WHEN fare_amount <= 0 THEN 1 ELSE 0 END) AS invalid_fare_rides,
    SUM(CASE WHEN distance_km <= 0 THEN 1 ELSE 0 END) AS invalid_distance_rides
FROM rides;

SELECT 
    'Ratings Coverage' AS metric,
    COUNT(DISTINCT r.ride_id) AS completed_rides,
    COUNT(DISTINCT rr.ride_id) AS rated_rides,
    ROUND(COUNT(DISTINCT rr.ride_id) * 100.0 / COUNT(DISTINCT r.ride_id), 2) AS rating_coverage_percent
FROM rides r
LEFT JOIN ride_ratings rr ON r.ride_id = rr.ride_id
WHERE r.ride_status = 'Completed';

SELECT 'Ride-Sharing Analytics Project Setup Complete!' AS completion_message;