CREATE DATABASE reserve_it;
USE reserve_it;

-- CREATE TABLES --

CREATE TABLE anschrift
(
	anschrift_ID INT auto_increment PRIMARY KEY 
,	strasse NVARCHAR(200)
,	hausnummer NVARCHAR(10)
,	ort NVARCHAR(200)
,	postleitzahl NVARCHAR(5)
,	land NVARCHAR(200)
);

CREATE TABLE gast
(
	gast_ID INT auto_increment PRIMARY KEY
,  anschrift_ID INT
,	vorname NVARCHAR(200)
,	nachname NVARCHAR(200)
,	geburtsdatum DATE 
,	istStammgast BOOL
,  geschlecht NVARCHAR(1) 
, 	FOREIGN KEY (anschrift_ID) REFERENCES anschrift(anschrift_ID)
);

CREATE TABLE auftrag
(
	auftrag_ID INT auto_increment PRIMARY KEY 
,  gast_ID int
, 	FOREIGN KEY (gast_ID) REFERENCES gast(gast_ID)
, 	startdatum DATE
, 	enddatum DATE 
);

CREATE TABLE hotel
(
	hotel_ID INT auto_increment PRIMARY KEY
,  anschrift_ID int
,	FOREIGN KEY (anschrift_ID) REFERENCES anschrift(anschrift_ID)
);

CREATE TABLE bewertung
(
	bewertung_ID INT auto_increment PRIMARY KEY 
,  auftrag_ID INT 
, 	FOREIGN KEY (auftrag_ID) REFERENCES auftrag(auftrag_ID)
, 	istFreigegeben BOOL
,  rezension NVARCHAR(500)
);

CREATE TABLE art
(
	art_ID INT PRIMARY KEY
,	art_beschreibung NVARCHAR(200)
);

CREATE TABLE kategorie
(
	kategorie_ID INT PRIMARY KEY 
,	kategorie_beschreibung NVARCHAR(200)
);

CREATE TABLE preis
(
	preis_ID INT PRIMARY KEY 
,  kategorie_ID INT
,  art_ID INT 
,	FOREIGN KEY (kategorie_ID) REFERENCES kategorie(kategorie_ID)
,	FOREIGN KEY (art_ID) REFERENCES art(art_ID)
,	preis_num INT
);

CREATE TABLE hotelzimmer
(
	hotelzimmer_ID INT auto_increment PRIMARY KEY 
,  preis_ID INT
,  hotel_ID INT
,  FOREIGN KEY (preis_ID) REFERENCES preis(preis_ID)
,  FOREIGN KEY (hotel_ID) REFERENCES hotel(hotel_ID)
,  zimmernummer INT
);



CREATE TABLE buchung
(
	buchung_ID INT auto_increment PRIMARY KEY 
,  auftrag_ID INT
,  hotelzimmer_ID INT
,	FOREIGN KEY (auftrag_ID) REFERENCES auftrag(auftrag_ID)
,	FOREIGN KEY (hotelzimmer_ID) REFERENCES hotelzimmer(hotelzimmer_ID)
);

-- CREATE SPs --

# Setup_checkAvailability

USE reserve_it;

#DROP PROCEDURE checkAvailability;
DELIMITER //
CREATE PROCEDURE checkAvailability(IN startDate date, IN endDate DATE, IN kategorieZimmer INT, IN artZimmer INT) 
BEGIN

# Gebe alle Zimmer aus, die die angegebene Kategorie und Art haben und deren gebuchter Zeitraum nicht mit dem angegebenen Zeitraum überschneidet

	SELECT k.kategorie_beschreibung AS kategorie
		  , a.art_beschreibung AS zimmerart
		  , p.preis_num AS preis_pro_nacht
		FROM hotelzimmer hz
  		left JOIN buchung b ON hz.hotelzimmer_ID = b.hotelzimmer_ID
  		left JOIN auftrag auf ON b.auftrag_ID = auf.auftrag_ID
  		left JOIN preis p ON hz.preis_ID = p.preis_ID
  		left JOIN art a ON p.art_ID = a.art_ID
  		left JOIN kategorie k ON k.kategorie_ID = p.kategorie_ID
  		WHERE (b.buchung_ID IS NULL OR  (auf.enddatum < startDate OR endDate < auf.startdatum)) 
      		AND k.kategorie_ID = kategorieZimmer 
      		AND a.art_ID = artZimmer
		LIMIT 1;     
	       
END //
DELIMITER ;

USE reserve_it;

DELIMITER //
CREATE PROCEDURE createBooking(IN geschlecht_in NVARCHAR(1)
									 	,IN vorname_in NVARCHAR(200)
									 	,IN nachname_in NVARCHAR(200)
									 	,IN geburtsdatum_in date
									 	,IN straße_in NVARCHAR(200)
									 	,IN hausnumer_in NVARCHAR(200)
									 	,IN plz_in NVARCHAR(5)
									 	,IN ort_in NVARCHAR(200)
									 	,IN land_in NVARCHAR(200)
									 	,IN startdatum_in date
									 	,IN enddatum_in date
									 	,IN kategorie_in int
									 	,IN art_in int)
BEGIN
	DECLARE gast_id INT;
	DECLARE anschrift_id INT;
	DECLARE hotelzimmer_id INT;
	DECLARE auftrag_id INT;
	
	SELECT a.anschrift_id INTO anschrift_id						# ID von der Anschrift der Person die die Buchung gemacht hat holen und in Variable speichern
	FROM anschrift a
	WHERE a.strasse = straße_in
	AND a.hausnummer = hausnummer_in
	AND a.ort = ort_in
	AND a.postleitzahl = plz_in
	AND a.land = land_in;
	
	SELECT g.gast_id INTO gast_id										# Aus beiden IDs kann jetzt die Gast ID herausgefunden werden
	FROM gast g
	WHERE g.anschrift_ID = anschrift_id
	AND g.vorname = vorname_in
	AND g.nachname = nachname_in
	AND g.geschlecht = geschlecht_in;
	
	SELECT hz.hotelzimmer_ID INTO hotelzimmer_id					# Für die Tabelle Buchung ist die Hotelzimmer ID noch wichtig, deswegen den Code aus Setup_checkAvailability verwenden
	FROM hotelzimmer hz
  	JOIN buchung b ON hz.hotelzimmer_ID = b.hotelzimmer_ID
  	JOIN auftrag auf ON b.auftrag_ID = auf.auftrag_ID
  	JOIN preis p ON hz.preis_ID = p.preis_ID
  	JOIN art a ON p.art_ID = a.art_ID
  	JOIN kategorie k ON k.kategorie_ID = p.kategorie_ID
  	WHERE (auf.enddatum < startdatum_in OR enddatum_in < auf.startdatum) 
     		AND k.kategorie_ID = kategorie_in
     		AND a.art_ID = art_in
   LIMIT 1;
   
   INSERT INTO auftrag (gast_ID, startdatum, enddatum)		# Neuen Auftrag in Tabelle Auftrag anlegen
   values
   (gast_id, startdatum_in, enddatum_in);
   
   SELECT auf.auftrag_id INTO auftrag_id							# ID von dem gerade angelegten Auftrag in eine Variable speichern
   FROM auftrag auf
   WHERE auf.gast_ID = gast_id
   AND auf.startdatum = startdatum_in
   AND auf.enddatum = enddatum_in;
   
   INSERT INTO buchung (auftrag_ID, hotelzimmer_ID)			# Mit der Hotelzimmer ID und der neuen Auftrag ID kann eine Buchung erstellt werden
   values
   (auftrag_id, hotelzimmer_id);

END//

DELIMITER ;


# Setup_deleteBooking

USE reserve_it;

DELIMITER //

CREATE PROCEDURE deleteBooking(IN auftrag_id_in INT)
BEGIN
	
	DELETE FROM buchung 
	WHERE auftrag_ID = auftrag_id_in;
	
	DELETE FROM bewertung 
	WHERE auftrag_ID = auftrag_id_in;
	
	DELETE FROM auftrag 
	WHERE auftrag_ID = auftrag_id_in;
	
END//
DELIMITER ;


# Setup_dummyDataTables

USE reserve_it;

-- Anschrift-Daten (Die IDs werden automatisch vergeben)
INSERT INTO anschrift (strasse, hausnummer, ort, postleitzahl, land)
VALUES
('Hauptstraße', '10', 'Berlin', '10115', 'Deutschland'),
('Musterweg', '5', 'Hamburg', '20095', 'Deutschland'),
('Parkstraße', '14', 'München', '80331', 'Deutschland'),
('Bergstraße', '7', 'Köln', '50733', 'Deutschland'),
('Seestraße', '21', 'Berlin', '13407', 'Deutschland');

-- Gast-Daten (Die IDs werden automatisch vergeben)
INSERT INTO gast (vorname, nachname, geburtsdatum, geschlecht, anschrift_ID, iststammgast)
VALUES
('Max', 'Mustermann', '1985-06-15', 'M', 1, 1),
('Erika', 'Musterfrau', '1990-09-20', 'W', 2, 0),
('Luca', 'Müller', '1995-03-25', 'M', 3, 0),
('Anna', 'Schmidt', '1988-07-30', 'W', 4, 1),
('Paul', 'Weber', '1992-11-12', 'M', 5, 0);

-- Hotel-Daten (Die IDs werden automatisch vergeben)
INSERT INTO hotel (anschrift_ID)
VALUES
(1),
(2),
(3),
(4),
(5);

-- Kategorie-Daten (Die IDs werden automatisch vergeben)
INSERT INTO kategorie (kategorie_ID, kategorie_beschreibung)
VALUES
(1, 'Standard'),
(2, 'Premium'),
(3, 'Luxus');

-- Art (Zimmertyp) Daten (Die IDs werden automatisch vergeben)
INSERT INTO art (art_ID, art_beschreibung)
VALUES
(1, 'Einzelzimmer'),
(2, 'Doppelzimmer');

-- Preis-Daten (Die IDs werden automatisch vergeben)
INSERT INTO preis (preis_ID, kategorie_ID, art_ID, preis_num)
VALUES
(1, 1, 1, 80.00),
(2, 1, 2, 120.00),
(3, 2, 1, 250.00),
(4, 2, 2, 180.00),
(5, 3, 1, 500.00),
(6, 3, 2, 600.00);

-- Hotelzimmer-Daten (Die IDs werden automatisch vergeben)
INSERT INTO hotelzimmer (preis_ID, hotel_ID, zimmernummer)
VALUES
(1, 1, '101'),
(2, 1, '102'),
(3, 2, '201'),
(4, 3, '301'),
(5, 4, '401'),
(6, 4, '403');

-- Auftrag-Daten (Die IDs werden automatisch vergeben)
INSERT INTO auftrag (gast_ID, startdatum, enddatum)
VALUES
(1, '2024-03-01', '2024-03-05'),
(2, '2024-03-10', '2024-03-15'),
(3, '2024-04-01', '2024-04-07'),
(4, '2024-05-01', '2024-05-05'),
(5, '2024-06-01', '2024-06-05');

-- Buchung-Daten (Die IDs werden automatisch vergeben)
INSERT INTO buchung (auftrag_ID, hotelzimmer_ID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Bewertung-Daten (Die IDs werden automatisch vergeben)
INSERT INTO bewertung (auftrag_ID, istfreigegeben, rezension)
VALUES
(1, 1, 'Super Aufenthalt!'),
(2, 0, 'Sehr gut, aber kleines Bad.'),
(3, 1, 'Alles war perfekt, sehr zufrieden!'),
(4, 1, 'Gutes Hotel, jedoch etwas zu teuer.'),
(5, 0, 'Nett, aber die Lage ist nicht ideal.');


# Setup_reviewFreigeben

USE reserve_it;

DELIMITER //
CREATE PROCEDURE reviewFreigeben (IN bewertung_id_in INT)
BEGIN

	UPDATE bewertung
	SET istFreigegeben = 'true'
	WHERE bewertung_ID = bewertung_id_int;
	
END//
DELIMITER ;


# Setup_reviewLoeschen

USE reserve_it;

DELIMITER //
CREATE PROCEDURE reviewLoeschen (IN bewertung_id_in INT)
BEGIN

	DELETE
	FROM bewertung
	WHERE bewerung_ID = bewertung_id_in;

END//
DELIMITER ;


# Setup_saveGuestData

USE reserve_it;

DELIMITER //
CREATE PROCEDURE saveGuestData(
    IN geschlecht_in NVARCHAR(1),
    IN vorname_in NVARCHAR(200),
    IN nachname_in NVARCHAR(200),
    IN geburtsdatum_in DATE,
    IN straße_in NVARCHAR(200),
    IN hausnummer_in NVARCHAR(200),
    IN plz_in NVARCHAR(5),
    IN ort_in NVARCHAR(200),
    IN land_in NVARCHAR(200)
)
BEGIN

    DECLARE gast_id INT;
    DECLARE anschrift_id INT;
    DECLARE gast_count INT;

    -- 1 Prüfen, ob Gast existiert
    SELECT gast_ID INTO gast_id
    FROM gast
    WHERE vorname = vorname_in
      AND nachname = nachname_in
      AND geburtsdatum = geburtsdatum_in;
    
    -- Falls Gast nicht existiert, einfügen
    IF gast_id IS NULL THEN
        INSERT INTO gast (vorname, nachname, geburtsdatum, geschlecht)
        VALUES (vorname_in, nachname_in, geburtsdatum_in, geschlecht_in);
        SET gast_id = LAST_INSERT_ID();
    END IF;

    -- 2 Prüfen, ob Anschrift existiert
    SELECT anschrift_ID INTO anschrift_id
    FROM anschrift
    WHERE strasse = straße_in
      AND hausnummer = hausnummer_in
      AND ort = ort_in
      AND postleitzahl = plz_in
      AND land = land_in;
    
    -- Falls Adresse nicht existiert, einfügen
    IF anschrift_id IS NULL THEN
        INSERT INTO anschrift (strasse, hausnummer, ort, postleitzahl, land)
        VALUES (straße_in, hausnummer_in, ort_in, plz_in, land_in);
        SET anschrift_id = LAST_INSERT_ID();
    END IF;

    -- 3 Prüfen, ob der Gast bereits mit der gleichen Anschrift existiert
    SELECT COUNT(*) INTO gast_count
    FROM gast
    WHERE gast_ID = gast_id
      AND anschrift_ID = anschrift_id;

    -- Falls der Gast nicht existiert, Adresse zu Gast zuordnen
    IF gast_count = 0 THEN
        UPDATE gast
        SET anschrift_ID = anschrift_id
        WHERE gast_ID = gast_id;
    END IF;

END //

DELIMITER ;


# Setup_showBookings

USE reserve_it

DELIMITER //

CREATE PROCEDURE showBookings(IN auftrag_id_in INT)
BEGIN 
	
	SELECT *
	FROM buchung b
	JOIN auftrag a ON b.auftrag_ID = a.auftrag_ID
	WHERE a.auftrag_ID = auftrag_id_in;
	
END//
DELIMITER ;


# Setup_showReviewsFreigegeben

USE reserve_it;

DELIMITER //
CREATE PROCEDURE showReviewsFreigegeben()
BEGIN 
	
	SELECT *
	FROM bewertung
	WHERE istFreigegeben = 'true';
	
END//
DELIMITER ;


# Setup_showReviewsNichtFreigegeben

USE reserve_it;

DELIMITER //
CREATE PROCEDURE showReviewsNichtFreigegeben()
BEGIN 
	
	SELECT *
	FROM bewertung
	WHERE istFreigegeben = 'false';
	
END//
DELIMITER ;


# Setup_submitReview

USE reserve_it;

DELIMITER //
CREATE PROCEDURE submitReview(IN auftrag_id_in int)
BEGIN

	DECLARE auftrag_id_vorhanden int;
	
	SELECT COUNT(*) INTO auftrag_id_vorhanden
	FROM bewertung
	WHERE auftrag_ID = auftrag_id_in;
	
	if auftrag_id_vorhanden = 0 THEN
	
		INSERT INTO bewertung(auftrag_ID, istFreigegeben, rezension)
		values
		(auftrag_id_in, 'false', bewertung_in);
		
	END if;
	
END//
DELIMITER ;