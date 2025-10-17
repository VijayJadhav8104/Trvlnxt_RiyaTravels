CREATE PROCEDURE SP_GETDISTINCT_TRACKID_Test          
@FromInsertedDate datetime,          
@ToInsertedDate datetime          
AS          
BEGIN          
          
	SELECT TrackID,Environment--,CONVERT(DateTime,InsertedDate,120) as InsertedDate  
	,CONVERT(DateTime,ServerInsertedDate,120) as InsertedDate  
	,FlightKey FROM APIBookingAuthentication WHERE (FlightKey IS NULL or FlightKey='') and Environment='Production' and          
	CONVERT(Date,InsertedDate,120)>=convert(Date,@FromInsertedDate, 120) and          
	CONVERT(Date,InsertedDate,120)<=convert(Date,@ToInsertedDate, 120)   and TrackID='20240408053302408146_766d2769-60df-429d-932a-a9fe84d99550'       
          
--UNION ALL          
          
--SELECT  TrackID,Environment --,CONVERT(DateTime,InsertedDate,120) as InsertedDate  
--,CONVERT(DateTime,ServerInsertedDate,120) as InsertedDate  
--,FlightKey FROM APIBookingAuthentication WHERE Environment='Development'  and          
--CONVERT(Date,InsertedDate,120)>=convert(Date,@FromInsertedDate, 120) and          
--CONVERT(Date,InsertedDate,120)<=convert(Date,@ToInsertedDate, 120)        
        
END