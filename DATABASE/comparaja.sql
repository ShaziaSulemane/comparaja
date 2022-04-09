-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema COMPARAJA
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `COMPARAJA` ;

-- -----------------------------------------------------
-- Schema COMPARAJA
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `COMPARAJA` DEFAULT CHARACTER SET utf8 ;
USE `COMPARAJA` ;

-- -----------------------------------------------------
-- Table `COMPARAJA`.`providers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `COMPARAJA`.`providers` ;

CREATE TABLE IF NOT EXISTS `COMPARAJA`.`providers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `summary` VARCHAR(500) NOT NULL DEFAULT 'CHARACTER SET utf8mb4',
  `is_active` TINYINT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

CREATE UNIQUE INDEX `id_UNIQUE` ON `COMPARAJA`.`providers` (`id` ASC) ;


-- -----------------------------------------------------
-- Table `COMPARAJA`.`verticals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `COMPARAJA`.`verticals` ;

CREATE TABLE IF NOT EXISTS `COMPARAJA`.`verticals` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

CREATE UNIQUE INDEX `code_UNIQUE` ON `COMPARAJA`.`verticals` (`code` ASC) ;

CREATE UNIQUE INDEX `id_UNIQUE` ON `COMPARAJA`.`verticals` (`id` ASC) ;


-- -----------------------------------------------------
-- Table `COMPARAJA`.`products`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `COMPARAJA`.`products` ;

CREATE TABLE IF NOT EXISTS `COMPARAJA`.`products` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `vertical_id` INT NOT NULL,
  `provider_id` INT NOT NULL,
  `is_sponsored` TINYINT NOT NULL,
  `data` VARCHAR(300) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `provider_id_fk`
    FOREIGN KEY (`provider_id`)
    REFERENCES `COMPARAJA`.`providers` (`id`),
  CONSTRAINT `vertical_id_fk`
    FOREIGN KEY (`vertical_id`)
    REFERENCES `COMPARAJA`.`verticals` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

CREATE UNIQUE INDEX `id_UNIQUE` ON `COMPARAJA`.`products` (`id` ASC) ;

CREATE INDEX `vertical_id_fk_idx` ON `COMPARAJA`.`products` (`vertical_id` ASC) ;

CREATE INDEX `provider_id_fk_idx` ON `COMPARAJA`.`products` (`provider_id` ASC) ;

USE `COMPARAJA` ;

-- -----------------------------------------------------
-- procedure Filter
-- -----------------------------------------------------

USE `COMPARAJA`;
DROP procedure IF EXISTS `COMPARAJA`.`Filter`;

DELIMITER $$
USE `COMPARAJA`$$
CREATE PROCEDURE Filter (
	in column_to_test varchar(255),
    in val int,
    in operation varchar(255)
)
BEGIN
	drop table if exists products;
	create temporary table products (SELECT comparaja.products.id, 
		substring_index(substring_index(substring_index (comparaja.products.data, ',', 1), ' ', -1), ':', '-1') as p,
		substring_index(substring_index(substring_index (comparaja.products.data, ',', 2), ' ', -1), ':', '-1') as internet_download_speed_in_mbs, 
		substring_index(substring_index(substring_index (comparaja.products.data, ',', 3), ' ', -1), ':', '-1') as internet_upload_speed_in_mbs, 
		substring_index(substring_index(substring_index (comparaja.products.data, ',', 4), ' ', -1), ':', '-1') as tv_channels, 
		substring_index(substring_index(substring_index (comparaja.products.data, ',', 5), ' ', -1), ':', '-1') as mobile_phone_count, 
		substring_index(substring_index(substring_index (comparaja.products.data, ',', 6), ' ', -1), ':', '-1') as mobile_phone_data_in_gbps, 
		substring_index(replace(substring_index(substring_index (comparaja.products.data, ',', 7), ' ', -1), '\n}', ''), ':', -1) as price
	from comparaja.products inner join comparaja.verticals on comparaja.products.vertical_id = comparaja.verticals.id
	inner join comparaja.providers on comparaja.providers.id = comparaja.products.provider_id
	where comparaja.verticals.code = 'BB' and comparaja.providers.is_active = TRUE);

	select * from products where 
	case column_to_test
		when 'internet_download_speed_in_mbs' then 
			(select case operation
				when '=' then products.internet_download_speed_in_mbs = val
                when '<' then products.internet_download_speed_in_mbs < val
                when '>' then products.internet_download_speed_in_mbs > val
			end)
		when 'mobile_phone_count' then
			(select case operation
				when '=' then products.mobile_phone_count = val
                when '<' then products.mobile_phone_count < val
                when '>' then products.mobile_phone_count > val
			end)
		when 'price' then
			(select case operation
				when '=' then products.price = val
                when '<' then products.price < val
                when '>' then products.price > val
			end)
	end;
    
    
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `COMPARAJA`.`providers`
-- -----------------------------------------------------
START TRANSACTION;
USE `COMPARAJA`;
INSERT INTO `COMPARAJA`.`providers` (`id`, `code`, `name`, `summary`, `is_active`) VALUES (1, 'WZK', 'WiZink', 'O WiZink, que opera em Portugal desde novembro de 2016, é um banco espanhol especializado em cartões de crédito e soluções de poupança simples para ir ao encontro das necessidades do dia-a-dia dos seus clientes. Atualmente, só em território nacional, o WiZink conta com mais de 700.000 clientes.', TRUE);
INSERT INTO `COMPARAJA`.`providers` (`id`, `code`, `name`, `summary`, `is_active`) VALUES (2, 'UNB', 'Unibanco', 'O Unibanco é uma empresa pertencente à entidade financeira Unicre. Atualmente, os valores do Unibanco estão patentes na assinatura “pelo sim, pelo sim”, que evoca a proximidade, utilidade e disponibilidade dos serviços oferecidos, assim como a necessidade de utilizar um cartão de crédito Unibanco para resolver os imprevistos do dia a dia. ', TRUE);
INSERT INTO `COMPARAJA`.`providers` (`id`, `code`, `name`, `summary`, `is_active`) VALUES (3, 'ACB', 'ActivoBank', 'A Cofidis surgiu em Portugal em 1996, onde hoje em dia acompanha mais de 300 mil clientes numa relação sustentável e personalizada, tendo vindo a conquistar uma posição de referência na venda e gestão de crédito a particulares.', FALSE);
INSERT INTO `COMPARAJA`.`providers` (`id`, `code`, `name`, `summary`, `is_active`) VALUES (4, 'MEO', 'MEO', 'A MEO - Serviços de Comunicações e Multimédia S.A. – marca que integra o grupo PT - surgiu em 2007 através do lançamento de um novo formato de pacotes de telecomunicações: o triple play, que engloba os serviços de Televisão, Internet e Voz.', TRUE);
INSERT INTO `COMPARAJA`.`providers` (`id`, `code`, `name`, `summary`, `is_active`) VALUES (5, 'VDF', 'Vodafone', 'O Grupo Vodafone foi fundado no Reino Unido, em 1985, fruto de uma joint venture entre a empresa Racal Strategic Radio Ltd e a Millicom. Originalmente sob o nome de Racal-Millicom, o nome Vodafone surge como junção das palavras “VOice-DAta-FONE” (telecomunicações de voz e de dados).', TRUE);
INSERT INTO `COMPARAJA`.`providers` (`id`, `code`, `name`, `summary`, `is_active`) VALUES (6, 'NOS', 'NOS', 'A operadora NOS nasceu em 2013 sob o nome de ZON/Optimus, resultado de uma fusão entre duas das maiores empresas de pacotes de telecomunicações do país: a ZON Multimédia e a Optimus Telecomunicações.', TRUE);
INSERT INTO `COMPARAJA`.`providers` (`id`, `code`, `name`, `summary`, `is_active`) VALUES (7, 'NOW', 'NOWO', 'A NOWO surgiu com uma forte aposta numa nova abordagem para romper com o oligopólio da MEO, da NOS e da Vodafone no mercado português das telecomunicações.', TRUE);
INSERT INTO `COMPARAJA`.`providers` (`id`, `code`, `name`, `summary`, `is_active`) VALUES (8, 'ZON', 'ZON', 'A ZON Multimédia é um grupo empresarial que integra o principal índice bolsista nacional, o PSI-20. É lider no mercado de pay TV em Portugal e é o segundo maior Internet provider.', FALSE);
INSERT INTO `COMPARAJA`.`providers` (`id`, `code`, `name`, `summary`, `is_active`) VALUES (9, 'STD', 'Santander', 'Tendo entrado em Portugal em 1988, o Santander é o segundo maior banco privado no país e um dos maiores da União Europeia, estando localizado entre os 10 maiores grupos financeiros do Mundo.', TRUE);
INSERT INTO `COMPARAJA`.`providers` (`id`, `code`, `name`, `summary`, `is_active`) VALUES (10, 'CGD', 'Caixa Geral de Depósitos', 'A Caixa Geral de Depósitos é uma referência no mercado financeiro português e internacional, uma vez que marca a sua presença pela Europa, América e Ásia.', TRUE);
INSERT INTO `COMPARAJA`.`providers` (`id`, `code`, `name`, `summary`, `is_active`) VALUES (11, 'BKI', 'Bankinter', 'O Bankinter é reconhecido no mercado espanhol como uma das entidades financeiras mais solventes e rentáveis. É uma referência na área da inovação e na qualidade de serviço que presta.', TRUE);

COMMIT;


-- -----------------------------------------------------
-- Data for table `COMPARAJA`.`verticals`
-- -----------------------------------------------------
START TRANSACTION;
USE `COMPARAJA`;
INSERT INTO `COMPARAJA`.`verticals` (`id`, `code`, `name`) VALUES (1, 'BB', 'Broadband');
INSERT INTO `COMPARAJA`.`verticals` (`id`, `code`, `name`) VALUES (2, 'CC', 'Credit Cards');
INSERT INTO `COMPARAJA`.`verticals` (`id`, `code`, `name`) VALUES (3, 'HL', 'Home loans');

COMMIT;


-- -----------------------------------------------------
-- Data for table `COMPARAJA`.`products`
-- -----------------------------------------------------
START TRANSACTION;
USE `COMPARAJA`;
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (1, 1, 4, TRUE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":100,\n        \"internet_upload_speed_in_mbs\":40,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":1,\n        \"mobile_phone_data_in_gbps\":5,\n        \"price\":29.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (2, 1, 4, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":200,\n        \"internet_upload_speed_in_mbs\":100,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":1,\n        \"mobile_phone_data_in_gbps\":5,\n        \"price\":39.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (3, 1, 4, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":1,\n        \"mobile_phone_data_in_gbps\":10,\n        \"price\":69.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (4, 1, 4, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":2,\n        \"mobile_phone_data_in_gbps\":10,\n        \"price\":59.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (5, 1, 4, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":4,\n        \"mobile_phone_data_in_gbps\":5,\n        \"price\":89.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (6, 1, 4, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":1000,\n        \"internet_upload_speed_in_mbs\":400,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":1,\n        \"mobile_phone_data_in_gbps\":2,\n        \"price\":59.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (7, 1, 4, FALSE, '{\n        \"p\":3,\n        \"internet_download_speed_in_mbs\":1000,\n        \"internet_upload_speed_in_mbs\":400,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":0,\n        \"mobile_phone_data_in_gbps\":null,\n        \"price\":39.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (8, 1, 4, FALSE, '{\n        \"p\":3,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":0,\n        \"mobile_phone_data_in_gbps\":null,\n        \"price\":29.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (9, 1, 6, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":100,\n        \"internet_upload_speed_in_mbs\":40,\n        \"tv_channels\":130,        \n        \"mobile_phone_count\":1,\n        \"mobile_phone_data_in_gbps\":7,\n        \"price\":29.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (10, 1, 6, TRUE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":200,\n        \"internet_upload_speed_in_mbs\":100,\n        \"tv_channels\":130,        \n        \"mobile_phone_count\":1,\n        \"mobile_phone_data_in_gbps\":7,\n        \"price\":39.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (11, 1, 6, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":130,        \n        \"mobile_phone_count\":1,\n        \"mobile_phone_data_in_gbps\":10,\n        \"price\":69.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (12, 1, 6, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":130,        \n        \"mobile_phone_count\":2,\n        \"mobile_phone_data_in_gbps\":10,\n        \"price\":59.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (13, 1, 6, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":130,        \n        \"mobile_phone_count\":4,\n        \"mobile_phone_data_in_gbps\":7,\n        \"price\":89.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (14, 1, 6, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":1000,\n        \"internet_upload_speed_in_mbs\":400,\n        \"tv_channels\":130,        \n        \"mobile_phone_count\":1,\n        \"mobile_phone_data_in_gbps\":3,\n        \"price\":59.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (15, 1, 6, FALSE, '{\n        \"p\":3,\n        \"internet_download_speed_in_mbs\":1000,\n        \"internet_upload_speed_in_mbs\":400,\n        \"tv_channels\":130,        \n        \"mobile_phone_count\":0,\n        \"mobile_phone_data_in_gbps\":null,\n        \"price\":39.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (16, 1, 5, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":2,\n        \"mobile_phone_data_in_gbps\":10,\n        \"price\":59.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (17, 1, 5, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":4,\n        \"mobile_phone_data_in_gbps\":5,\n        \"price\":89.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (18, 1, 5, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":1000,\n        \"internet_upload_speed_in_mbs\":400,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":1,\n        \"mobile_phone_data_in_gbps\":2,\n        \"price\":59.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (19, 1, 5, FALSE, '{\n        \"p\":3,\n        \"internet_download_speed_in_mbs\":1000,\n        \"internet_upload_speed_in_mbs\":400,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":0,\n        \"mobile_phone_data_in_gbps\":null,\n        \"price\":39.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (20, 1, 5, FALSE, '{\n        \"p\":3,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":0,\n        \"mobile_phone_data_in_gbps\":null,\n        \"price\":29.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (21, 1, 7, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":2,\n        \"mobile_phone_data_in_gbps\":10,\n        \"price\":49.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (22, 1, 7, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":4,\n        \"mobile_phone_data_in_gbps\":5,\n        \"price\":79.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (23, 1, 7, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":1000,\n        \"internet_upload_speed_in_mbs\":400,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":1,\n        \"mobile_phone_data_in_gbps\":2,\n        \"price\":49.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (24, 1, 7, FALSE, '{\n        \"p\":3,\n        \"internet_download_speed_in_mbs\":1000,\n        \"internet_upload_speed_in_mbs\":400,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":0,\n        \"mobile_phone_data_in_gbps\":null,\n        \"price\":29.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (25, 1, 7, FALSE, '{\n        \"p\":3,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":120,        \n        \"mobile_phone_count\":0,\n        \"mobile_phone_data_in_gbps\":null,\n        \"price\":19.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (26, 1, 8, TRUE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":200,\n        \"internet_upload_speed_in_mbs\":100,\n        \"tv_channels\":130,        \n        \"mobile_phone_count\":1,\n        \"mobile_phone_data_in_gbps\":7,\n        \"price\":39.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (27, 1, 8, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":130,        \n        \"mobile_phone_count\":1,\n        \"mobile_phone_data_in_gbps\":10,\n        \"price\":69.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (28, 1, 8, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":130,        \n        \"mobile_phone_count\":2,\n        \"mobile_phone_data_in_gbps\":10,\n        \"price\":59.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (29, 1, 8, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":500,\n        \"internet_upload_speed_in_mbs\":200,\n        \"tv_channels\":130,        \n        \"mobile_phone_count\":4,\n        \"mobile_phone_data_in_gbps\":7,\n        \"price\":89.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (30, 1, 8, FALSE, '{\n        \"p\":4,\n        \"internet_download_speed_in_mbs\":1000,\n        \"internet_upload_speed_in_mbs\":400,\n        \"tv_channels\":130,        \n        \"mobile_phone_count\":1,\n        \"mobile_phone_data_in_gbps\":3,\n        \"price\":59.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (31, 1, 8, FALSE, '{\n        \"p\":3,\n        \"internet_download_speed_in_mbs\":1000,\n        \"internet_upload_speed_in_mbs\":400,\n        \"tv_channels\":130,        \n        \"mobile_phone_count\":0,\n        \"mobile_phone_data_in_gbps\":null,\n        \"price\":39.99\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (32, 2, 1, FALSE, '{\n       \"spread_percentage\":1.2,\n       \"min_loan_amount\":5000,\n       \"max_loan_amount\":20000,\n       \"min_term_in_months\":24,\n       \"max_term_in_months\":80,\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (33, 2, 1, FALSE, '{\n      \"taeg_percentage\":6.0,\n      \"min_loan_amount\":5000,\n      \"max_loan_amount\":25000,\n      \"min_term_in_months\":24,\n      \"max_term_in_months\":80,\n      \"min_income\":2000\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (34, 2, 2, TRUE, '{\n      \"taeg_percentage\":8.2,\n      \"min_loan_amount\":5000,\n      \"max_loan_amount\":20000,\n      \"min_term_in_months\":24,\n      \"max_term_in_months\":80,\n      \"min_income\":1000\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (35, 2, 2, FALSE, '{\n      \"taeg_percentage\":6.0,\n      \"min_loan_amount\":5000,\n      \"max_loan_amount\":25000,\n      \"min_term_in_months\":24,\n      \"max_term_in_months\":80,\n      \"min_income\":2000\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (36, 2, 3, FALSE, '{\n      \"taeg_percentage\":8.2,\n      \"min_loan_amount\":5000,\n      \"max_loan_amount\":20000,\n      \"min_term_in_months\":24,\n      \"max_term_in_months\":80,\n      \"min_income\":1000\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (37, 2, 3, FALSE, '{\n      \"taeg_percentage\":6.0,\n      \"min_loan_amount\":5000,\n      \"max_loan_amount\":25000,\n      \"min_term_in_months\":24,\n      \"max_term_in_months\":80,\n      \"min_income\":2000\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (38, 3, 9, TRUE, '{\n      \"taeg_percentage\":2.2,\n      \"min_loan_amount\":40000,\n      \"max_loan_amount\":1000000,\n      \"min_term_in_months\":120,\n      \"max_term_in_months\":480,\n      \"min_income\":1000\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (39, 3, 9, FALSE, '{\n      \"taeg_percentage\":1.8,\n      \"min_loan_amount\":40000,\n      \"max_loan_amount\":1000000,\n      \"min_term_in_months\":120,\n      \"max_term_in_months\":480,\n      \"min_income\":2000\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (40, 3, 10, FALSE, '{\n      \"taeg_percentage\":2.2,\n      \"min_loan_amount\":40000,\n      \"max_loan_amount\":1000000,\n      \"min_term_in_months\":120,\n      \"max_term_in_months\":480,\n      \"min_income\":1000\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (41, 3, 10, FALSE, '{\n      \"taeg_percentage\":1.8,\n      \"min_loan_amount\":40000,\n      \"max_loan_amount\":1000000,\n      \"min_term_in_months\":120,\n      \"max_term_in_months\":480,\n      \"min_income\":2000\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (42, 3, 11, FALSE, '{\n      \"taeg_percentage\":2.2,\n      \"min_loan_amount\":40000,\n      \"max_loan_amount\":1000000,\n      \"min_term_in_months\":120,\n      \"max_term_in_months\":480,\n      \"min_income\":1000\n}');
INSERT INTO `COMPARAJA`.`products` (`id`, `vertical_id`, `provider_id`, `is_sponsored`, `data`) VALUES (43, 3, 11, FALSE, '{\n      \"taeg_percentage\":1.8,\n      \"min_loan_amount\":40000,\n      \"max_loan_amount\":1000000,\n      \"min_term_in_months\":120,\n      \"max_term_in_months\":480,\n      \"min_income\":2000\n}');

COMMIT;

