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
