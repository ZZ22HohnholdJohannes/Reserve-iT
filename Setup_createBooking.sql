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
  	JOIN art a ON hz.art_ID = a.art_ID
  	JOIN preis p ON hz.preis_ID = p.preis_ID
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
   
   
   
   
   
   
   
   
	