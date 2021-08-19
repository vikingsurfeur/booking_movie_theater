/* Create a trigger after insert into reservation table to modify and define the price column into reservation_type */
DELIMITER $$

CREATE TRIGGER `booking_movie_theater`.`after_insert_reservation`
AFTER INSERT ON `booking_movie_theater`.`reservation`
FOR EACH ROW
BEGIN
    UPDATE `booking_movie_theater`.`reservation_type`
    SET `price` = (
        CASE
          WHEN `age` > 14 AND `is_student` = 1 THEN 7.60
          WHEN `age` <= 14 THEN 5.90
          ELSE 9.90
        END
    );
END $$

/* Create a trigger to check the seat_capacity into the theater table and we can not insert a reservation if the seat_capacity is full */
DELIMITER $$

CREATE TRIGGER `booking_movie_theater`.`check_seat_capacity`
BEFORE INSERT ON `booking_movie_theater`.`reservation`
FOR EACH ROW
BEGIN
    SELECT COUNT(*) INTO @seat_reserved
    FROM `booking_movie_theater`.`seat_reserved`
    WHERE `seat_reserved`.`diffusion_id` = `diffusion_id`;

    SELECT `theater`.`seats_capacity` INTO @seats_capacity
    FROM `booking_movie_theater`.`theater`
    WHERE `theater`.`id` = `theater_id`;

    IF @seat_reserved >= @seats_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The seat capacity is full';
    END IF;
END $$

/*  Create a trigger after delete a seat_reserved, delete the reservation and delete the reservation_type too */
DELIMITER $$

CREATE TRIGGER `booking_movie_theater`.`after_delete_seat_reserved`
AFTER DELETE ON `booking_movie_theater`.`seat_reserved`
FOR EACH ROW
BEGIN
    DELETE FROM `booking_movie_theater`.`reservation`
    WHERE `id` = `id`;

    DELETE FROM `booking_movie_theater`.`reservation_type`
    WHERE `id` = `id`;
END $$