
CREATE PROCEDURE [dbo].[GetTicketTest]
@OrderId			varchar(20) = NULL,
@RiyaPNR			varchar(20) = NULL
AS BEGIN
	IF(@OrderId IS NULL)
	BEGIN
		SELECT @OrderId = orderId FROM tblBookMaster WHERE riyaPNR = @RiyaPNR
	END
--  Other Info

	;with cte as
			(
			
			SELECT a.pkId , a.airName as owairName,a.frmSector as owfrmSector,a.toSector as owtoSector,a.depDate as owdepDate,a.arrivalDate as owarrivalDate,a.fromAirport as owfromAirport,
				a.deptTime as owdeptTime,a.fromTerminal as owfromTerminal,a.toTerminal as owtoTerminal,a.GDSPNR as owGDSPNR,a.arrivalTime as owarrivalTime,
				a.flightNo as owflightNo,a.riyaPNR as owriyaPNR,a.isReturnJourney,a.emailId,a.mobileNo,a.returnFlag,a.basicFare as owbasicFare,
				a.totalTax as owtotalTax,a.totalFare as owtotalFare,a.TotalTime as owTotalTime,a.airCode as owCarrier,a.CounterCloseTime as owCounterCloseTime,
				b.airName as rtairName,b.frmSector as rtfrmSector,b.toSector as rttoSector,b.depDate as rtdepDate,b.arrivalDate as rtarrivalDate,
				b.deptTime as rtdeptTime,b.arrivalTime as rtarrivalTime,b.flightNo as rtflightNo,b.riyaPNR as rtriyaPNR,b.basicFare as rtbasicFare,
				b.totalTax as rttotalTax,b.totalFare as rttotalFare,b.fromTerminal as rtfromTerminal,b.toTerminal as rttoTerminal,b.CounterCloseTime as rtCounterCloseTime,
				b.TotalTime as rtTotalTime,b.GDSPNR as rtGDSPNR,b.airCode as rtCarrier,b.fromAirport as rtFromAirport,
				(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled=0 and a.pkid=pax.fkBookMaster) as CancelFlag
				,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE a.pkid=pax2.fkBookMaster) as baggage
				,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  a.pkid=pax3.fkBookMaster) as BookingDate
				--,p.baggage as baggage,p.inserteddate as BookingDate
				,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as BookingBy,a.IsBooked as owIsBooked,b.IsBooked as rtIsBooked
			FROM tblBookMaster a
				left JOIN tblBookMaster b on a.orderId=b.orderId and a.GDSPNR=b.GDSPNR and b.returnFlag=1
			 where a.orderId=@OrderId and a.returnFlag=0 and a.IsBooked=1 

			Union ALL

			
			SELECT b.pkId , b.airName as owairName,b.frmSector as owfrmSector,b.toSector as owtoSector,b.depDate as owdepDate,b.arrivalDate as owarrivalDate,b.fromAirport as owfromAirport,
				b.deptTime as owdeptTime,b.fromTerminal as owfromTerminal,b.toTerminal as owtoTerminal,b.GDSPNR as owGDSPNR,b.arrivalTime as owarrivalTime,
				b.flightNo as owflightNo,b.riyaPNR as owriyaPNR,b.isReturnJourney,b.emailId,b.mobileNo,b.returnFlag,b.basicFare as owbasicFare,
				b.totalTax as owtotalTax,b.totalFare as owtotalFare,b.TotalTime as owTotalTime,b.airCode as owCarrier,b.CounterCloseTime as owCounterCloseTime,
				
				null as rtairName,null as rtfrmSector,null as rttoSector ,null as rtdepDate,null as rtarrivalDate,
				null as rtdeptTime,null as rtarrivalTime,null as rtflightNo,null as rtriyaPNR,null as rtbasicFare,
				null as rttotalTax,null as rttotalFare,null as rtfromTerminal,null as rttoTerminal,null as rtCounterCloseTime,
				null as rtTotalTime,null as rtGDSPNR,null as rtCarrier,b.fromAirport as rtFromAirport,
				(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled=0 and b.pkid=pax.fkBookMaster) as CancelFlag
				,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE b.pkid=pax2.fkBookMaster) as baggage
				,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  b.pkid=pax3.fkBookMaster) as BookingDate
				--,p.baggage as baggage,p.inserteddate as BookingDate
				,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE b.pkid=pax.fkBookMaster) as BookingBy,
				b.IsBooked as owIsBooked,b.IsBooked as rtIsBooked
			FROM tblBookMaster a
				inner JOIN tblBookMaster b on a.orderId=b.orderId and a.GDSPNR!=b.GDSPNR 
            where  b.returnFlag=1 and b.IsBooked=1 and b.orderId=@OrderId
		)
		SELECT c.* INTO #TripUpcomingTempTable
             FROM cte c WHERE  CancelFlag=0;

    select * from #TripUpcomingTempTable;

	SELECT c.paxFName,c.paxLName,c.pid,c.fkBookMaster,c.title,temp.owGDSPNR as GDSPNR,c.ticketNum,c.isReturn,c.Iscancelled
	FROM tblPassengerBookDetails c
	inner join #TripUpcomingTempTable temp
	on c.fkBookMaster=temp.pkId

	drop table #TripUpcomingTempTable; 

END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetTicketTest] TO [rt_read]
    AS [dbo];

