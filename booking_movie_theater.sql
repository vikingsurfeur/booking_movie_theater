/* Create the DataBase */
CREATE DATABASE IF NOT EXISTS `booking_movie_theater` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

/* Create admin table */
CREATE TABLE IF NOT EXISTS `booking_movie_theater`.`admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `password` (`password`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Create employees table */
CREATE TABLE IF NOT EXISTS `booking_movie_theater`.`employees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `admin_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`admin_id`) REFERENCES `booking_movie_theater`.`admin` (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `password` (`password`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Create reservation_type table */
CREATE TABLE IF NOT EXISTS `booking_movie_theater`.`reservation_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reservation_type` varchar(255) NOT NULL,
  `age` int(11) NOT NULL,
  `is_student` tinyint(1) NOT NULL,
  `price` float NOT NULL DEFAULT 9.90,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


/* Create movie table */
CREATE TABLE IF NOT EXISTS `booking_movie_theater`.`movie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `director` varchar(255) NOT NULL,
  `casting` text NOT NULL,
  `description` text NOT NULL,
  `duration` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Create theater table */
CREATE TABLE IF NOT EXISTS `booking_movie_theater`.`theater` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `number` int(11) NOT NULL,
  `seats_capacity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `address` (`address`),
  UNIQUE KEY `phone_number` (`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Create diffusion table */
CREATE TABLE IF NOT EXISTS `booking_movie_theater`.`diffusion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `movie_id` int(11) NOT NULL,
  `theater_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `diffusion_start` datetime NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`movie_id`) REFERENCES `booking_movie_theater`.`movie` (`id`),
  FOREIGN KEY (`theater_id`) REFERENCES `booking_movie_theater`.`theater` (`id`),
  FOREIGN KEY (`employee_id`) REFERENCES `booking_movie_theater`.`employees` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Create a reservation table */
CREATE TABLE IF NOT EXISTS `booking_movie_theater`.`reservation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diffusion_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `employee_paid_id` int(11) NOT NULL,
  `reservation_type_id` int(11) NOT NULL,
  `reservation_contact` varchar(255) NOT NULL,
  `paid` tinyint(1) NOT NULL,
  `reservation_valid` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`diffusion_id`) REFERENCES `booking_movie_theater`.`diffusion` (`id`),
  FOREIGN KEY (`employee_id`) REFERENCES `booking_movie_theater`.`employees` (`id`),
  FOREIGN KEY (`employee_paid_id`) REFERENCES `booking_movie_theater`.`employees` (`id`),
  FOREIGN KEY (`reservation_type_id`) REFERENCES `booking_movie_theater`.`reservation_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Create seat table */
CREATE TABLE IF NOT EXISTS `booking_movie_theater`.`seat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `row` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  `theater_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`theater_id`) REFERENCES `booking_movie_theater`.`theater` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Create a seat_reserved table */
CREATE TABLE IF NOT EXISTS `booking_movie_theater`.`seat_reserved` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `seat_id` int(11) NOT NULL,
  `reservation_id` int(11) NOT NULL,
  `diffusion_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`seat_id`) REFERENCES `booking_movie_theater`.`seat` (`id`),
  FOREIGN KEY (`reservation_id`) REFERENCES `booking_movie_theater`.`reservation` (`id`),
  FOREIGN KEY (`diffusion_id`) REFERENCES `booking_movie_theater`.`diffusion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Insert datas into admin table */
INSERT INTO `booking_movie_theater`.`admin`(`username`, `password`)
VALUES(
    'benoit.para',
    SHA2('@imBenoitPara', 512)
);

/* Insert datas into employees table */
INSERT INTO `booking_movie_theater`.`employees`(`username`, `password`, `admin_id`)
VALUES(
    'lionel.para',
    SHA2('@imLionelPara', 512),
    1
);

/* Insert datas into reservation_type table */
INSERT INTO `booking_movie_theater`.`reservation_type`(
    `reservation_type`,
    `age`,
    `is_student`
)
VALUES(
    'paypal',
    41,
    0
);

/* Insert datas into movie table */
INSERT INTO `booking_movie_theater`.`movie`(
    `title`,
    `director`,
    `casting`,
    `description`,
    `duration`
)
VALUES(
    'The Godfather',
    'Francis Ford Coppola',
    'John Depp, Al Pacino, Robert DeNiro',
    'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
    150
);

/* Insert datas into theater table */
INSERT INTO `booking_movie_theater`.`theater`(
    `name`,
    `address`,
    `phone_number`,
    `number`,
    `seats_capacity`
)
VALUES(
    'Cinema 1',
    '1 rue de la Paix',
    '+33165324898',
    1,
    50
);

/* Insert datas into diffusion table */
INSERT INTO `booking_movie_theater`.`diffusion`(
    `movie_id`,
    `theater_id`,
    `employee_id`,
    `diffusion_start`
)
VALUES(
    1,
    1,
    1,
    '2022-01-01 17:00:00'
);

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

/* Insert datas into reservation table */
INSERT INTO `booking_movie_theater`.`reservation`(
    `diffusion_id`,
    `employee_id`,
    `employee_paid_id`,
    `reservation_type_id`,
    `reservation_contact`,
    `paid`,
    `reservation_valid`
)
VALUES(
    1,
    1,
    1,
    1,
    '+33165324898',
    1,
    1
);

/* Insert datas into seat table */
INSERT INTO `booking_movie_theater`.`seat`(
    `row`,
    `number`,
    `theater_id`
)
VALUES(
    1,
    1,
    1
);

/* Insert datas into seat_reserved table */
INSERT INTO `booking_movie_theater`.`seat_reserved`(
    `seat_id`,
    `reservation_id`,
    `diffusion_id`
)
VALUES(
    1,
    1,
    1
);

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
