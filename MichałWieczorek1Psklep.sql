DROP DATABASE IF EXISTS `sklepik`;
CREATE DATABASE `sklepik`;
USE `sklepik`;

CREATE TABLE `Producent`
(
    ProducentID INT(11) AUTO_INCREMENT PRIMARY KEY,
    Nazwa VARCHAR(50),
    Adres VARCHAR(50),
    Numer_kontaktowy VARCHAR(11),
    NIP VARCHAR(10),
    Opis VARCHAR(1000)
);

CREATE TABLE `Produkt`
(
    ProduktID INT(11) AUTO_INCREMENT PRIMARY KEY,
    ProducentID INT(11),
    Nazwa VARCHAR(50),
    Cena DECIMAL(5),   /*w złotówkach*/
    Waga DECIMAL(5), /*w gramach*/
    Opis TEXT(1000)
);

CREATE TABLE `Klient`
(
    KlientID INT(11) AUTO_INCREMENT PRIMARY KEY,
    Imie VARCHAR(50),
    Nazwisko VARCHAR(50),
    Data_urodzenia DATE,
    Numer_kontaktowy VARCHAR(11),
    Adres VARCHAR(50)
);

CREATE TABLE `Zamowienie`
(
    ZamowienieID INT(11) AUTO_INCREMENT PRIMARY KEY,
    KlientID INT(11),
    Data_zamowienia DATE,
    Data_dostarczenia DATE
    /*zakładam że jeśli zamówinie zostanie zrealizowane to przeniesie się do tabeli z zarchiwiozowanymi zamówieniami*/
);

CREATE TABLE `Koszyk`
(
    KoszykID INT(11) AUTO_INCREMENT PRIMARY KEY,
    ZamowienieID INT(11),
    Ilosc INT(6),
    ProduktID INT(11)
);

ALTER TABLE `Zamowienie`
ADD FOREIGN KEY(KlientID)
REFERENCES Klient(KlientID);

ALTER TABLE `Produkt`
ADD FOREIGN KEY(ProducentID)
REFERENCES Producent(ProducentID);

ALTER TABLE `Koszyk`
ADD FOREIGN KEY(ZamowienieID)
REFERENCES Zamowienie(ZamowienieID);

ALTER TABLE `Koszyk`
ADD FOREIGN KEY(ProduktID)
REFERENCES Produkt(ProduktID);

/*views*/
CREATE OR REPLACE VIEW ProduktView AS
SELECT Produkt.Nazwa, Produkt.Cena, Producent.Nazwa AS "Producent" FROM Produkt
JOIN Producent ON Producent.ProducentID = Produkt.ProduktID;

CREATE OR REPLACE VIEW ZamowienieView AS
SELECT CONCAT(Klient.Imie, ' ', Klient.Nazwisko) AS "Klient", Klient.Data_urodzenia, Klient.Adres FROM Zamowienie
JOIN Klient ON Klient.KlientID = zamowienie.KlientID;

CREATE OR REPLACE VIEW KoszykView AS
SELECT Koszyk.KoszykID, Zamowienie.ZamowienieID AS "Numer zamowienia", Produkt.Nazwa AS "Nazwa produktu", Koszyk.Ilosc FROM Koszyk
JOIN produkt ON produkt.produktID = Koszyk.produktID
JOIN Zamowienie ON Zamowienie.ZamowienieID = Koszyk.ZamowienieID;

/*Inserts*/
INSERT INTO `klient` (`KlientID`, `Imie`, `Nazwisko`, `Data_urodzenia`, `Numer_kontaktowy`, `Adres`)
VALUES (NULL, 'Michał', 'Wieczorek', '2022-02-03', '999 999 999', 'CzęstOwOa');
INSERT INTO `klient` (`KlientID`, `Imie`, `Nazwisko`, `Data_urodzenia`, `Numer_kontaktowy`, `Adres`)
VALUES (NULL, 'Mikołaj', 'Koper', '2022-02-03', '999 999 999', 'WejcherOwO');

INSERT INTO `producent` (`ProducentID`, `Nazwa`, `Adres`, `Numer_kontaktowy`, `NIP`, `Opis`)
VALUES (NULL, 'xkom', 'CzęstOwOa', '999 999 999', '1234567890', 'ajsodjaoiifgjdojfaklmjsdlkfnalkfjasodjwioajsdkldanmlsdk');
INSERT INTO `producent` (`ProducentID`, `Nazwa`, `Adres`, `Numer_kontaktowy`, `NIP`, `Opis`)
VALUES (NULL, 'morele', 'Kraków', '666 662 137', '0987654321', 'morele net');

INSERT INTO `produkt` (`ProduktID`, `ProducentID`, `Nazwa`, `Cena`, `Waga`, `Opis`)
VALUES (NULL, '2', 'niemiecka klawiatura', '275', '750', 'klawiatura mechaniczna');
INSERT INTO `produkt` (`ProduktID`, `ProducentID`, `Nazwa`, `Cena`, `Waga`, `Opis`) 
VALUES (NULL, '2', 'morela', '5', '100', 'd o b r e p o m a r a ń c z o w e');
INSERT INTO `produkt` (`ProduktID`, `ProducentID`, `Nazwa`, `Cena`, `Waga`, `Opis`)
VALUES (NULL, '1', 'monitor', '999', '2500', 'monitor LED, VA 144hz');
INSERT INTO `produkt` (`ProduktID`, `ProducentID`, `Nazwa`, `Cena`, `Waga`, `Opis`)
VALUES (NULL, '1', 'pendrive ', '19,99', '75', 'pendrive 16GB');

INSERT INTO `zamowienie` (`ZamowienieID`, `KlientID`, `Data_zamowienia`, `Data_dostarczenia`)
VALUES (NULL, '1', '2022-02-03', '2022-02-07');
INSERT INTO `zamowienie` (`ZamowienieID`, `KlientID`, `Data_zamowienia`, `Data_dostarczenia`)
VALUES (NULL, '1', '2022-02-02', '2022-02-05');
INSERT INTO `zamowienie` (`ZamowienieID`, `KlientID`, `Data_zamowienia`, `Data_dostarczenia`)
VALUES (NULL, '2', '2022-02-03', '2022-02-04');


INSERT INTO `koszyk` (`KoszykID`, `ZamowienieID`, `Ilosc`, `ProduktID`)
VALUES (NULL, '1', '20', '1');
INSERT INTO `koszyk` (`KoszykID`, `ZamowienieID`, `Ilosc`, `ProduktID`)
VALUES (NULL, '2', '1', '3');
INSERT INTO `koszyk` (`KoszykID`, `ZamowienieID`, `Ilosc`, `ProduktID`)
VALUES (NULL, '3', '1', '4');

DELIMITER //
CREATE OR REPLACE PROCEDURE koszykpr (IN KoszykID INT, ZamowienieID INT, ProduktID INT, Ilosc INT)
BEGIN
IF EXISTS 
    (SELECT koszyk.koszykID from Koszyk 
     WHERE koszyk.ProduktID = ProduktID 
     AND koszyk.ZamowienieID = ZamowienieID) THEN
UPDATE koszyk SET koszyk.Ilosc= koszyk.Ilosc + Ilosc WHERE koszyk.ProduktID = ProduktID AND koszyk.ZamowienieID = ZamowienieID;
    ELSE
    INSERT INTO Koszyk VALUES (null, ProduktID, ZamowienieID, Ilosc);
    END IF;
END//
DELIMITER ;
/*CALL koszykpr(1, 1, 1, 1)*/