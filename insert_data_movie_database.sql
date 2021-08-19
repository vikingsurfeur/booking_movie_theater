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