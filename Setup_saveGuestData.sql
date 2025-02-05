USE reserve_it;

DELIMITER //
create PROCEDURE saveGuestData(IN geschlecht_in NVARCHAR(1)
										,IN vorname_in NVARCHAR(200)
										,IN nachname_in NVARCHAR(200)
										,IN geburtsdatum_in date
										,IN straße_in NVARCHAR(200)
										,IN hausnumer_in NVARCHAR(200)
										,IN plz_in NVARCHAR(5)
										,IN ort_in NVARCHAR(200)
										,IN land_in NVARCHAR(200))
BEGIN
	
    DECLARE person_id INT;
    DECLARE anschrift_id INT;
    DECLARE gast_count INT;

    -- 1 Prüfen, ob Person existiert
    SELECT person_ID INTO person_id
    FROM person 
    WHERE vorname = vorname_in 
      AND nachname = nachname_in 
      AND geburtsdatum = geburtsdatum_in;
    
    -- Falls Person nicht existiert, einfügen
    IF person_id IS NULL THEN
        INSERT INTO person (vorname, nachname, geburtsdatum, iststammgast)
        VALUES (vorname_in, nachname_in, geburtsdatum_in, 0);
        SET person_id = LAST_INSERT_ID();
    ELSE
        -- Falls Person existiert, Stammgast setzen
        UPDATE person 
        SET istStammgast = 1 
        WHERE person_ID = person_id;
    END IF;

    -- 2️Prüfen, ob Anschrift existiert
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

    -- 3️Prüfen, ob der Gast bereits existiert
    SELECT COUNT(*) INTO gast_count 
    FROM gast 
    WHERE person_ID = person_id 
      AND anschrift_ID = anschrift_id;

    -- Falls der Gast nicht existiert, einfügen
    IF gast_count = 0 THEN
        INSERT INTO gast (person_ID, anschrift_ID)
        VALUES (person_id, anschrift_id);
    END IF;

END //

DELIMITER ;


	
	
	
	
	
	