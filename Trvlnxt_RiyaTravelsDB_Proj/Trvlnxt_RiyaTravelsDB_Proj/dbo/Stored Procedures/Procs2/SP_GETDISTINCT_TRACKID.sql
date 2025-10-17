CREATE PROCEDURE [dbo].[SP_GETDISTINCT_TRACKID]         
@FromInsertedDate datetime,        
@ToInsertedDate datetime        
AS        
BEGIN        
        
SELECT TrackID,Environment--,CONVERT(DateTime,InsertedDate,120) as InsertedDate
,CONVERT(DateTime,ServerInsertedDate,120) as InsertedDate
,FlightKey FROM APIBookingAuthentication WHERE (FlightKey IS NULL or FlightKey='') and Environment='Production' and  
LOWER(RequestType) ='avaibility'  and 
CONVERT(Date,InsertedDate,120)>=convert(Date,@FromInsertedDate, 120) and        
CONVERT(Date,InsertedDate,120)<=convert(Date,@ToInsertedDate, 120)        
        
UNION ALL        
        
SELECT  TrackID,Environment --,CONVERT(DateTime,InsertedDate,120) as InsertedDate
,CONVERT(DateTime,ServerInsertedDate,120) as InsertedDate
,FlightKey FROM APIBookingAuthentication WHERE Environment='Development'  and  
LOWER(RequestType) ='avaibility'  and 
CONVERT(Date,InsertedDate,120)>=convert(Date,@FromInsertedDate, 120) and        
CONVERT(Date,InsertedDate,120)<=convert(Date,@ToInsertedDate, 120)      
      
END