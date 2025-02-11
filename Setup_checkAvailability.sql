USE reserve_it;

#DROP PROCEDURE checkAvailability;
DELIMITER //
CREATE PROCEDURE checkAvailability(IN startDate date, IN endDate DATE, IN kategorieZimmer INT, IN artZimmer INT) 
BEGIN

# Gebe alle Zimmer aus, die die angegebene Kategorie und Art haben und deren gebuchter Zeitraum nicht mit dem angegebenen Zeitraum überschneidet

	SELECT k.kategorie_beschreibung AS kategorie
		  , a.art_beschreibung AS zimmerart
		  , p.preis AS preis_pro_nacht
		FROM hotelzimmer hz
  		left JOIN buchung b ON hz.hotelzimmer_ID = b.hotelzimmer_ID
  		left JOIN auftrag auf ON b.auftrag_ID = auf.auftrag_ID
  		left JOIN preis p ON hz.preis_ID = p.preis_ID
  		left JOIN art a ON p.art_ID = a.art_ID
  		left JOIN kategorie k ON k.kategorie_ID = p.kategorie_ID
  		WHERE (b.buchung_ID is null or auf.enddatum < startDate OR endDate < auf.startdatum) 
      		AND k.kategorie_ID = kategorieZimmer 
      		AND a.art_ID = artZimmer
		LIMIT 1;     
	       
END //
DELIMITER ;
