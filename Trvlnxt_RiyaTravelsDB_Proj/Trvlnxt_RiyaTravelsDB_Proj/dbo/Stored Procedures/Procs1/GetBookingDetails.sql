CREATE proc [dbo].[GetBookingDetails] --GetBookingDetails 'M15WJ5'

@RiyaPNR nvarchar(10)

As
Begin
declare @bookingId TABLE  (PkId nvarchar(10))

INSERT INTO @bookingId (pkid) SELECT pkid FROM  tblbookmaster WHERE riyapnr = @RiyaPNR 

SELECT pkid                AS pkid, 
      orderid, 
      frmsector, 
      tosector, 
      airname + flightno  AS airlineName, 
      totalfare, 
      gdspnr, 
      ticketissuanceerror AS TicketingError 
FROM   tblbookmaster 
WHERE  riyapnr = @RiyaPNR 

SELECT pid                 AS pkid, 
      title, 
      paxfname + paxlname AS NAME,
      ticketnum 
FROM   tblpassengerbookdetails 
WHERE  fkbookmaster IN (SELECT * 
                       FROM   @bookingId) 

SELECT pkid               AS pkid, 
      orderid, 
      frmsector, 
      tosector, 
      airname + flightno AS airlineName, 
      airlinepnr 
FROM   tblbookitenary 
WHERE  fkbookmaster IN (SELECT * 
                       FROM   @bookingId) 

End


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetBookingDetails] TO [rt_read]
    AS [dbo];

