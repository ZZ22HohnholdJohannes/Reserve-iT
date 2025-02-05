CREATE DATABASE reserve_it;
USE reserve_it;

CREATE TABLE person
(
	person_ID INT PRIMARY KEY
,	vorname NVARCHAR(200)
,	nachname NVARCHAR(200)
,	geburtsdatum DATE 
,	istStammgast BOOL
);

CREATE TABLE anschrift
(
	anschrift_ID INT PRIMARY KEY 
,	strasse NVARCHAR(200)
,	hausnummer NVARCHAR(10)
,	ort NVARCHAR(200)
,	postleitzahl NVARCHAR(5)
,	land NVARCHAR(200)
);

CREATE TABLE gast
(
	gast_ID INT PRIMARY KEY
,  anschrift_ID INT
,  person_ID int
, 	FOREIGN KEY (anschrift_ID) REFERENCES anschrift(anschrift_ID)
, 	FOREIGN KEY (person_ID) REFERENCES person(person_ID)
);

CREATE TABLE auftrag
(
	auftrag_ID INT PRIMARY KEY 
,  gast_ID int
, 	FOREIGN KEY (gast_ID) REFERENCES gast(gast_ID)
, 	startdatum DATE
, 	enddatum DATE 
);

CREATE TABLE hotel
(
	hotel_ID INT PRIMARY KEY
,  anschrift_ID int
,	FOREIGN KEY (anschrift_ID) REFERENCES anschrift(anschrift_ID)
);

CREATE TABLE bewertung
(
	bewertung_ID INT PRIMARY KEY 
,  auftrag_ID INT 
, 	FOREIGN KEY (auftrag_ID) REFERENCES auftrag(auftrag_ID)
, 	istFreigegeben BOOL
, 	sternebewertung INT
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
,	preis INT
);

CREATE TABLE hotelzimmer
(
	hotelzimmer_ID INT PRIMARY KEY 
,  art_ID INT
,  preis_ID INT
,  hotel_ID INT
, 	FOREIGN KEY (art_ID) REFERENCES art(art_ID)
,  FOREIGN KEY (preis_ID) REFERENCES preis(preis_ID)
,  FOREIGN KEY (hotel_ID) REFERENCES hotel(hotel_ID)
,  zimmernummer INT
);



CREATE TABLE buchung
(
	buchung_ID INT PRIMARY KEY 
,  auftrag_ID INT
,  hotelzimmer_ID INT
,	FOREIGN KEY (auftrag_ID) REFERENCES auftrag(auftrag_ID)
,	FOREIGN KEY (hotelzimmer_ID) REFERENCES hotelzimmer(hotelzimmer_ID)
);













