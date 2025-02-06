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