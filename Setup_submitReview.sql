USE reserve_it;

DELIMITER //
CREATE PROCEDURE submitReview(IN bewertung_in NVARCHAR(500), IN sternebewertung_in INT, IN auftrag_id_in int)
BEGIN

	DECLARE auftrag_id_vorhanden int;
	
	SELECT COUNT(*) INTO auftrag_id_vorhanden
	FROM bewertung
	WHERE auftrag_ID = auftrag_id_in;
	
	if auftrag_id_vorhanden = 0 THEN
	
		INSERT INTO bewertung(auftrag_ID, istFreigegeben, sternebewertung, rezension)
		values
		(auftrag_id_in, 'false', sternebewertung_in, bewertung_in);
		
	END if;
	
END//
DELIMITER ;