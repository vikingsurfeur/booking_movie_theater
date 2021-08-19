/* Command to select the reservation_type where the is_student is 1 */
SELECT
    *
FROM
    `booking_movie_theater`.`reservation_type`
WHERE
    `is_student` = 1;

/* Command to see the number of seats are reserved for the diffusion */
SELECT
    COUNT(*)
FROM
    `booking_movie_theater`.`seat_reserved`
WHERE
    `diffusion_id` = 1;

/* Command to see all movies are displayed in the theater */
SELECT
    *
FROM
    `booking_movie_theater`.`diffusion`
INNER JOIN `booking_movie_theater`.`movie` ON
    `diffusion`.`movie_id` = `movie`.`id`
INNER JOIN `booking_movie_theater`.`theater` ON
    `diffusion`.`theater_id` = `theater`.`id`
WHERE
    `diffusion`.`diffusion_start` > NOW();