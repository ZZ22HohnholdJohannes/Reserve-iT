USE reserve_it;

DELIMITER //
CREATE PROCEDURE showReviewsNichtFreigegeben()
BEGIN 
	
	SELECT *
	FROM bewertung
	WHERE istFreigegeben = 'false';
	
END//
DELIMITER ;