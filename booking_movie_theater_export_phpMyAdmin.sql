-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 19 août 2021 à 14:36
-- Version du serveur :  10.4.17-MariaDB
-- Version de PHP : 8.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `booking_movie_theater`
--

-- --------------------------------------------------------

--
-- Structure de la table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`) VALUES
(1, 'benoit.para', '499bba3ce005a678dae7e1e3e231668dd0ace669ce99ed26467c6e495d62cae1e7aeda2078dbae5e136b67e14c5189629c0f499f1cb46115679ec4d7d65ef49e');

-- --------------------------------------------------------

--
-- Structure de la table `diffusion`
--

CREATE TABLE `diffusion` (
  `id` int(11) NOT NULL,
  `movie_id` int(11) NOT NULL,
  `theater_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `diffusion_start` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `diffusion`
--

INSERT INTO `diffusion` (`id`, `movie_id`, `theater_id`, `employee_id`, `diffusion_start`) VALUES
(1, 1, 1, 1, '2022-01-01 17:00:00');

-- --------------------------------------------------------

--
-- Structure de la table `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `admin_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `employees`
--

INSERT INTO `employees` (`id`, `username`, `password`, `admin_id`) VALUES
(1, 'lionel.para', '6ad3ef9af4fcda696725e4af42acdc2af8f4d1a7362428e2c29f0f5e36ad97d37eab1682ae1b2346f5bc7f7ba9d1d3f6b2cedd820e3ff4c311429c15373fce49', 1);

-- --------------------------------------------------------

--
-- Structure de la table `movie`
--

CREATE TABLE `movie` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `director` varchar(255) NOT NULL,
  `casting` text NOT NULL,
  `description` text NOT NULL,
  `duration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `movie`
--

INSERT INTO `movie` (`id`, `title`, `director`, `casting`, `description`, `duration`) VALUES
(1, 'The Godfather', 'Francis Ford Coppola', 'John Depp, Al Pacino, Robert DeNiro', 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.', 150);

-- --------------------------------------------------------

--
-- Structure de la table `reservation`
--

CREATE TABLE `reservation` (
  `id` int(11) NOT NULL,
  `diffusion_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `employee_paid_id` int(11) NOT NULL,
  `reservation_type_id` int(11) NOT NULL,
  `reservation_contact` varchar(255) NOT NULL,
  `paid` tinyint(1) NOT NULL,
  `reservation_valid` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `reservation`
--

INSERT INTO `reservation` (`id`, `diffusion_id`, `employee_id`, `employee_paid_id`, `reservation_type_id`, `reservation_contact`, `paid`, `reservation_valid`) VALUES
(1, 1, 1, 1, 1, '+33165324898', 1, 1),
(7, 1, 1, 1, 3, '+33625365985', 1, 1);

--
-- Déclencheurs `reservation`
--
DELIMITER $$
CREATE TRIGGER `after_insert_reservation_def_price` AFTER INSERT ON `reservation` FOR EACH ROW BEGIN
    UPDATE `booking_movie_theater`.`reservation_type`
    SET `price` = (
        CASE
          WHEN `age` > 14 AND `is_student` = 1 THEN 7.60
          WHEN `age` <= 14 THEN 5.90
          ELSE 9.90
        END
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_seat_capacity` BEFORE INSERT ON `reservation` FOR EACH ROW BEGIN
    SELECT COUNT(*) INTO @seat_reserved
    FROM `booking_movie_theater`.`seat_reserved`
    WHERE `seat_reserved`.`diffusion_id` = `diffusion_id`;

    SELECT `theater`.`seats_capacity` INTO @seats_capacity
    FROM `booking_movie_theater`.`theater`
    WHERE `theater`.`id` = `id`;

    IF @seat_reserved >= @seats_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The seat capacity is full';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `reservation_type`
--

CREATE TABLE `reservation_type` (
  `id` int(11) NOT NULL,
  `reservation_type` varchar(255) NOT NULL,
  `age` int(11) NOT NULL,
  `is_student` tinyint(1) NOT NULL,
  `price` float NOT NULL DEFAULT 9.9
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `reservation_type`
--

INSERT INTO `reservation_type` (`id`, `reservation_type`, `age`, `is_student`, `price`) VALUES
(1, 'paypal', 41, 0, 9.9),
(3, 'Visa', 13, 0, 5.9);

-- --------------------------------------------------------

--
-- Structure de la table `seat`
--

CREATE TABLE `seat` (
  `id` int(11) NOT NULL,
  `row` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  `theater_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `seat`
--

INSERT INTO `seat` (`id`, `row`, `number`, `theater_id`) VALUES
(1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `seat_reserved`
--

CREATE TABLE `seat_reserved` (
  `id` int(11) NOT NULL,
  `seat_id` int(11) NOT NULL,
  `reservation_id` int(11) NOT NULL,
  `diffusion_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `seat_reserved`
--

INSERT INTO `seat_reserved` (`id`, `seat_id`, `reservation_id`, `diffusion_id`) VALUES
(3, 1, 1, 1),
(4, 1, 1, 1);

--
-- Déclencheurs `seat_reserved`
--
DELIMITER $$
CREATE TRIGGER `after_delete_seat_reserved` AFTER DELETE ON `seat_reserved` FOR EACH ROW BEGIN
    DELETE FROM `booking_movie_theater`.`reservation`
    WHERE `id` = `id`;

    DELETE FROM `booking_movie_theater`.`reservation_type`
    WHERE `id` = `id`;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `theater`
--

CREATE TABLE `theater` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `number` int(11) NOT NULL,
  `seats_capacity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `theater`
--

INSERT INTO `theater` (`id`, `name`, `address`, `phone_number`, `number`, `seats_capacity`) VALUES
(1, 'Cinema 1', '1 rue de la Paix', '+33165324898', 1, 50);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `password` (`password`);

--
-- Index pour la table `diffusion`
--
ALTER TABLE `diffusion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `movie_id` (`movie_id`),
  ADD KEY `theater_id` (`theater_id`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Index pour la table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `password` (`password`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Index pour la table `movie`
--
ALTER TABLE `movie`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `diffusion_id` (`diffusion_id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `employee_paid_id` (`employee_paid_id`),
  ADD KEY `reservation_type_id` (`reservation_type_id`);

--
-- Index pour la table `reservation_type`
--
ALTER TABLE `reservation_type`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `seat`
--
ALTER TABLE `seat`
  ADD PRIMARY KEY (`id`),
  ADD KEY `theater_id` (`theater_id`);

--
-- Index pour la table `seat_reserved`
--
ALTER TABLE `seat_reserved`
  ADD PRIMARY KEY (`id`),
  ADD KEY `seat_id` (`seat_id`),
  ADD KEY `reservation_id` (`reservation_id`),
  ADD KEY `diffusion_id` (`diffusion_id`);

--
-- Index pour la table `theater`
--
ALTER TABLE `theater`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `diffusion`
--
ALTER TABLE `diffusion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `movie`
--
ALTER TABLE `movie`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `reservation_type`
--
ALTER TABLE `reservation_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `seat`
--
ALTER TABLE `seat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `seat_reserved`
--
ALTER TABLE `seat_reserved`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `theater`
--
ALTER TABLE `theater`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `diffusion`
--
ALTER TABLE `diffusion`
  ADD CONSTRAINT `diffusion_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`),
  ADD CONSTRAINT `diffusion_ibfk_2` FOREIGN KEY (`theater_id`) REFERENCES `theater` (`id`),
  ADD CONSTRAINT `diffusion_ibfk_3` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Contraintes pour la table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`);

--
-- Contraintes pour la table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`diffusion_id`) REFERENCES `diffusion` (`id`),
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `reservation_ibfk_3` FOREIGN KEY (`employee_paid_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `reservation_ibfk_4` FOREIGN KEY (`reservation_type_id`) REFERENCES `reservation_type` (`id`);

--
-- Contraintes pour la table `seat`
--
ALTER TABLE `seat`
  ADD CONSTRAINT `seat_ibfk_1` FOREIGN KEY (`theater_id`) REFERENCES `theater` (`id`);

--
-- Contraintes pour la table `seat_reserved`
--
ALTER TABLE `seat_reserved`
  ADD CONSTRAINT `seat_reserved_ibfk_1` FOREIGN KEY (`seat_id`) REFERENCES `seat` (`id`),
  ADD CONSTRAINT `seat_reserved_ibfk_2` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`id`),
  ADD CONSTRAINT `seat_reserved_ibfk_3` FOREIGN KEY (`diffusion_id`) REFERENCES `diffusion` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
