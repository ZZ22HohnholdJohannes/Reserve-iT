USE reserve_it;

-- Gast-Person-Anschrift Daten
INSERT INTO person (person_ID, vorname, nachname, geburtsdatum, iststammgast)
VALUES
(1, 'Max', 'Mustermann', '1985-06-15', 1),
(2, 'Erika', 'Musterfrau', '1990-09-20', 0);

INSERT INTO anschrift (anschrift_ID, straße, hausnummer, ort, postleitzahl, land)
VALUES
(1, 'Hauptstraße', '10', 'Berlin', '10115', 'Deutschland'),
(2, 'Musterweg', '5', 'Hamburg', '20095', 'Deutschland');

INSERT INTO gast (gast_ID, anschrift_ID, person_ID)
VALUES
(1, 1, 1),
(2, 2, 2);

-- Hotel Daten
INSERT INTO hotel (hotel_ID, anschrift_ID)
VALUES
(1, 1),
(2, 2);

-- Kategorie Daten
INSERT INTO kategorie (kategorie_ID, kategorie_beschreibung)
VALUES
(1, 'Standard'),
(2, 'Premium'),
(3, 'Luxus');

-- Art (Zimmertyp) Daten
INSERT INTO art (art_ID, art_beschreibung)
VALUES
(1, 'Einzelzimmer'),
(2, 'Doppelzimmer');

-- Preis Daten
INSERT INTO preis (preis_ID, kategorie_ID, art_ID, preis)
VALUES
(1, 1, 1, 80.00),
(2, 1, 2, 120.00);

-- Hotelzimmer Daten (ohne kategorie_ID)
INSERT INTO hotelzimmer (hotelzimmer_ID, art_ID, preis_ID, hotel_ID, zimmernummer)
VALUES
(1, 1, 1, 1, '101'),
(2, 2, 2, 1, '102');

-- Auftrag Daten
INSERT INTO auftrag (auftrag_ID, gast_ID, startdatum, enddatum)
VALUES
(1, 1, '2024-03-01', '2024-03-05'),
(2, 2, '2024-03-10', '2024-03-15');

-- Buchung Daten
INSERT INTO buchung (buchung_ID, auftrag_ID, hotelzimmer_ID)
VALUES
(1, 1, 1),
(2, 2, 2);

-- Bewertung Daten
INSERT INTO bewertung (bewertung_ID, auftrag_ID, istfreigegeben, sternebwertung, rezension)
VALUES
(1, 1, 1, 5, 'Super Aufenthalt!'),
(2, 2, 0, 4, 'Sehr gut, aber kleines Bad.');

