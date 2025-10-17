        
        
CREATE proc [dbo].[API_GetBookingDetails] --[API_GetBookingDetails] '20240620204135229100_627f200b-c8e9-4c96-953e-5f2f36f516b3'          
          
@TrackID nvarchar(MAX)          
          
As        
Begin          
declare @bookingId TABLE  (PkId nvarchar(10))          
          
INSERT INTO @bookingId (pkid) SELECT pkid FROM  tblbookmaster WHERE APITrackID = @TrackID           
          
SELECT book.APITrackID AS Trackid,        
book.IsBooked,        
book.BookingStatus,        
book.orderid,          
book.GDSPNR,        
book.riyaPNR,  
book.OfficeID,  
(Select top 1 itenary.airlinePNR from tblBookItenary as itenary where itenary.orderId = book.orderId) as AirlinePNR,      
pass.title,           
pass.paxfname +' '+ pass.paxlname AS Name,          
pass.ticketnum as TicketNumber,        
pass.basicFare,       
pass.totalTax,       
pass.TotalFare,       
book.frmsector as Departure,           
book.tosector as Arrival,           
book.airname as AirlineName,        
book.flightNo as FlightNumber,      
(case when book.returnFlag = 0 then 'oneway' else 'return' end) as tripType,
pass.pid

FROM tblbookmaster as book inner join tblpassengerbookdetails as pass on book.pkId = pass.fkBookMaster       
      
WHERE book.APITrackID = @TrackID           
          
End 