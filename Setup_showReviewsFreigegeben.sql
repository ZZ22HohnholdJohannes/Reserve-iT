USE reserve_it;

DELIMITER //
CREATE PROCEDURE showReviewsFreigegeben()
BEGIN 
	
	SELECT *
	FROM bewertung
	WHERE istFreigegeben = 'true';
	
END//
DELIMITER ;