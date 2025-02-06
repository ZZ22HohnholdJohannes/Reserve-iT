USE reserve_it;

DELIMITER //
CREATE PROCEDURE reviewFreigeben (IN bewertung_id_in INT)
BEGIN

	UPDATE bewertung
	SET istFreigegeben = 'true'
	WHERE bewertung_ID = bewertung_id_int;
	
END//
DELIMITER ;