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