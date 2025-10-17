
CREATE VIEW  [dbo].[GetBookItenaryDetails] AS
(
	SELECT t.orderId, 
		STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
		STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
		STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
		STUFF((SELECT ',' + CONVERT(VARCHAR(11),s.depDate,103)+','+CONVERT(VARCHAR(11),s.arrivalDate,103) FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
		STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis,
		STUFF((SELECT '/' +  substring(I.cabin,0,2) FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS rbd,
		STUFF((SELECT '/' + I.airlinePNR FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS airlinePNR
		, t.PreviousAirlinePNR 
		FROM tblBookItenary AS t GROUP BY t.orderId, t.PreviousAirlinePNR
);