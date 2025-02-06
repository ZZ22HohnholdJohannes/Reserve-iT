USE reserve_it;

DELIMITER //
CREATE PROCEDURE reviewLoeschen (IN bewertung_id_in INT)
BEGIN

	DELETE
	FROM bewertung
	WHERE bewerung_ID = bewertung_id_in;

END//
DELIMITER ;