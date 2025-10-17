

CREATE PROCEDURE [dbo].[spGetBookingHistory]  --'spGetBookingHistory 'manasvee@riya.travel',1
	@EmailID varchar(500),
	@opr int 
AS
BEGIN
	IF(@opr=1)--Upcoming Trip
	BEGIN
	
		with cte as
			(
			
			SELECT a.pkId , a.airName as owairName,a.frmSector as owfrmSector,a.toSector as owtoSector,CONVERT(date,a.deptTime) as owdepDate,a.arrivalDate as owarrivalDate,a.fromAirport as owfromAirport,
				a.deptTime as owdeptTime,a.fromTerminal as owfromTerminal,a.toTerminal as owtoTerminal,a.GDSPNR as owGDSPNR,a.arrivalTime as owarrivalTime,
				a.flightNo as owflightNo,a.riyaPNR as owriyaPNR,a.isReturnJourney,a.emailId,a.mobileNo,a.returnFlag,
				CASE WHEN a.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), a.basicFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),a.basicFare * a.ROE)) END as owbasicFare,--a.basicFare as owbasicFare,
				CASE WHEN a.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), a.totalTax * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),a.totalTax * a.ROE)) END as owtotalTax,--a.totalTax as owtotalTax,
				CASE WHEN a.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), a.totalFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),a.totalFare * a.ROE)) END as owtotalFare,--a.totalFare as owtotalFare,
				a.TotalTime as owTotalTime,a.airCode as owCarrier,a.CounterCloseTime as owCounterCloseTime,
				b.airName as rtairName,b.frmSector as rtfrmSector,b.toSector as rttoSector,CONVERT(date,b.deptTime) as rtdepDate,b.arrivalDate as rtarrivalDate,
				b.deptTime as rtdeptTime,b.arrivalTime as rtarrivalTime,b.flightNo as rtflightNo,b.riyaPNR as rtriyaPNR,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.basicFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.basicFare * a.ROE)) END as rtbasicFare,--b.basicFare as rtbasicFare,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalTax * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalTax * a.ROE)) END as rttotalTax,--b.totalTax as rttotalTax, 
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalFare * a.ROE)) END as rttotalFare,--b.totalFare as rttotalFare,
				b.fromTerminal as rtfromTerminal,b.toTerminal as rttoTerminal,b.CounterCloseTime as rtCounterCloseTime,
				b.TotalTime as rtTotalTime,b.GDSPNR as rtGDSPNR,b.airCode as rtCarrier,b.fromAirport as rtFromAirport,b.toAirport as rtoAirport,
				--(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled=0 and a.pkid=pax.fkBookMaster) as CancelFlag
				case when a.canceledDate is null then 0 else 1 end as CancelFlag
				,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE a.pkid=pax2.fkBookMaster) as baggage
				,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  a.pkid=pax3.fkBookMaster) as BookingDate
				--,p.baggage as baggage,p.inserteddate as BookingDate
				,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as BookingBy,a.IsBooked as owIsBooked,b.IsBooked as rtIsBooked,
				a.toAirport,a.orderId,a.ROE,a.Country
			FROM tblBookMaster a
				left JOIN tblBookMaster b on a.orderId=b.orderId and a.GDSPNR=b.GDSPNR and b.returnFlag=1
				inner Join UserLogin u on a.LoginEmailID=u.UserID and u.UserName=@EmailID
			 where a.returnFlag=0 and a.IsBooked=1 and  CONVERT(date,a.deptTime) >= GETDATE() 

			Union ALL

			
			SELECT b.pkId , b.airName as owairName,b.frmSector as owfrmSector,b.toSector as owtoSector,CONVERT(date,b.deptTime) as owdepDate,b.arrivalDate as owarrivalDate,b.fromAirport as owfromAirport,
				b.deptTime as owdeptTime,b.fromTerminal as owfromTerminal,b.toTerminal as owtoTerminal,b.GDSPNR as owGDSPNR,b.arrivalTime as owarrivalTime,
				b.flightNo as owflightNo,b.riyaPNR as owriyaPNR,b.isReturnJourney,b.emailId,b.mobileNo,b.returnFlag,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.basicFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.
basicFare * a.ROE)) END as owbasicFare,--b.basicFare as owbasicFare,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalTax * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalTax * a.ROE)) END as owtotalTax,--b.totalTax as owtotalTax,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalFare * a.ROE)) END as owtotalFare,--b.totalFare as owtotalFare,
				b.TotalTime as owTotalTime,b.airCode as owCarrier,b.CounterCloseTime as owCounterCloseTime,
				
				null as rtairName,null as rtfrmSector,null as rttoSector ,null as rtdepDate,null as rtarrivalDate,
				null as rtdeptTime,null as rtarrivalTime,null as rtflightNo,null as rtriyaPNR,null as rtbasicFare,
				null as rttotalTax,null as rttotalFare,null as rtfromTerminal,null as rttoTerminal,null as rtCounterCloseTime,
				null as rtTotalTime,null as rtGDSPNR,null as rtCarrier,b.fromAirport as rtFromAirport,b.toAirport as rtoAirport,
				--(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled=0 and b.pkid=pax.fkBookMaster) as CancelFlag
				case when a.canceledDate is null then 0 else 1 end as CancelFlag
				,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE b.pkid=pax2.fkBookMaster) as baggage
				,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  b.pkid=pax3.fkBookMaster) as BookingDate
				--,p.baggage as baggage,p.inserteddate as BookingDate
				,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE b.pkid=pax.fkBookMaster) as BookingBy,
				b.IsBooked as owIsBooked,b.IsBooked as rtIsBooked,b.toAirport,a.orderId,a.ROE,a.Country
			FROM tblBookMaster a
				inner JOIN tblBookMaster b on a.orderId=b.orderId and a.GDSPNR!=b.GDSPNR 
				inner Join UserLogin u on b.LoginEmailID=u.UserID and u.UserName=@EmailID
            where  b.returnFlag=1 and b.IsBooked=1 and  CONVERT(date,b.deptTime) >= GETDATE()
		)
		SELECT c.* INTO #TripUpcomingTempTable
             FROM cte c WHERE  CancelFlag=0;

        select * from #TripUpcomingTempTable;

		SELECT c.paxFName,c.paxLName,c.pid,c.fkBookMaster,c.title,temp.owGDSPNR as GDSPNR,c.ticketNum
		FROM tblPassengerBookDetails c
	    inner join #TripUpcomingTempTable temp
		on c.fkBookMaster=temp.pkId

		drop table #TripUpcomingTempTable; 

	END
	else If(@opr=2) --Completed Trip
	begin
	   
	   
	  	with cte as
			(
			
			SELECT a.pkId , a.airName as owairName,a.frmSector as owfrmSector,a.toSector as owtoSector,CONVERT(date,a.deptTime) as owdepDate,a.arrivalDate as owarrivalDate,a.fromAirport as owfromAirport,
				a.deptTime as owdeptTime,a.fromTerminal as owfromTerminal,a.toTerminal as owtoTerminal,a.GDSPNR as owGDSPNR,a.arrivalTime as owarrivalTime,
				a.flightNo as owflightNo,a.riyaPNR as owriyaPNR,a.isReturnJourney,a.emailId,a.mobileNo,a.returnFlag,
				CASE WHEN a.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), a.basicFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),a.basicFare * a.ROE)) END as owbasicFare,--a.basicFare as owbasicFare,
				CASE WHEN a.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), a.totalTax * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),a.totalTax * a.ROE)) END as owtotalTax,--a.totalTax as owtotalTax,
				CASE WHEN a.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), a.totalFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),a.totalFare * a.ROE)) END as owtotalFare,--a.totalFare as owtotalFare,
				a.TotalTime as owTotalTime,a.airCode as owCarrier,a.CounterCloseTime as owCounterCloseTime,
				b.airName as rtairName,b.frmSector as rtfrmSector,b.toSector as rttoSector,CONVERT(date,b.deptTime) as rtdepDate,b.arrivalDate as rtarrivalDate,
				b.deptTime as rtdeptTime,b.arrivalTime as rtarrivalTime,b.flightNo as rtflightNo,b.riyaPNR as rtriyaPNR,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.basicFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.basicFare * a.ROE)) END as rtbasicFare,--b.basicFare as rtbasicFare,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalTax * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalTax * a.ROE)) END as rttotalTax,--b.totalTax as rttotalTax, 
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalFare * a.ROE)) END as rttotalFare,--b.totalFare as rttotalFare,
				b.fromTerminal as rtfromTerminal,b.toTerminal as rttoTerminal,b.CounterCloseTime as rtCounterCloseTime,
				b.TotalTime as rtTotalTime,b.GDSPNR as rtGDSPNR,b.airCode as rtCarrier,b.fromAirport as rtFromAirport,b.toAirport as rtoAirport,
				--(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled=0 and a.pkid=pax.fkBookMaster) as CancelFlag
				case when a.canceledDate is null then 0 else 1 end as CancelFlag
				,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE a.pkid=pax2.fkBookMaster) as baggage
				,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  a.pkid=pax3.fkBookMaster) as BookingDate
				--,p.baggage as baggage,p.inserteddate as BookingDate
				,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as BookingBy,a.IsBooked as owIsBooked,b.IsBooked as rtIsBooked,
				a.toAirport,a.orderId,a.ROE,a.Country
			FROM tblBookMaster a
				left JOIN tblBookMaster b on a.orderId=b.orderId and a.GDSPNR=b.GDSPNR and b.returnFlag=1
				inner Join UserLogin u on a.LoginEmailID=u.UserID and u.UserName=@EmailID
			 where a.returnFlag=0 and a.IsBooked=1 and  CONVERT(date,a.deptTime) <= GETDATE() 

			Union ALL

			
			SELECT b.pkId , b.airName as owairName,b.frmSector as owfrmSector,b.toSector as owtoSector,CONVERT(date,b.deptTime) as owdepDate,b.arrivalDate as owarrivalDate,b.fromAirport as owfromAirport,
				b.deptTime as owdeptTime,b.fromTerminal as owfromTerminal,b.toTerminal as owtoTerminal,b.GDSPNR as owGDSPNR,b.arrivalTime as owarrivalTime,
				b.flightNo as owflightNo,b.riyaPNR as owriyaPNR,b.isReturnJourney,b.emailId,b.mobileNo,b.returnFlag,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.basicFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.basicFare * a.ROE)) END as owbasicFare,--b.basicFare as owbasicFare,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalTax * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalTax * a.ROE)) END as owtotalTax,--b.totalTax as owtotalTax,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalFare * a.ROE)) END as owtotalFare,--b.totalFare as owtotalFare,
				b.TotalTime as owTotalTime,b.airCode as owCarrier,b.CounterCloseTime as owCounterCloseTime,
				
				null as rtairName,null as rtfrmSector,null as rttoSector ,null as rtdepDate,null as rtarrivalDate,
				null as rtdeptTime,null as rtarrivalTime,null as rtflightNo,null as rtriyaPNR,null as rtbasicFare,
				null as rttotalTax,null as rttotalFare,null as rtfromTerminal,null as rttoTerminal,null as rtCounterCloseTime,
				null as rtTotalTime,null as rtGDSPNR,null as rtCarrier,b.fromAirport as rtFromAirport,b.toAirport as rtoAirport,
				--(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled=0 and b.pkid=pax.fkBookMaster) as CancelFlag
				case when a.canceledDate is null then 0 else 1 end as CancelFlag
				,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE b.pkid=pax2.fkBookMaster) as baggage
				,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  b.pkid=pax3.fkBookMaster) as BookingDate
				--,p.baggage as baggage,p.inserteddate as BookingDate
				,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE b.pkid=pax.fkBookMaster) as BookingBy,
				b.IsBooked as owIsBooked,b.IsBooked as rtIsBooked,b.toAirport,a.orderId,a.ROE,a.Country
			FROM tblBookMaster a
				inner JOIN tblBookMaster b on a.orderId=b.orderId and a.GDSPNR!=b.GDSPNR
				inner Join UserLogin u on b.LoginEmailID=u.UserID and u.UserName=@EmailID 
            where  b.returnFlag=1 and b.IsBooked=1 and  CONVERT(date,b.deptTime) <= GETDATE()
		)
		SELECT c.* INTO #TripCompleteTempTable
             FROM cte c WHERE  CancelFlag=0;

        select * from #TripCompleteTempTable;

		SELECT c.paxFName,c.paxLName,c.pid,c.fkBookMaster,c.title,temp.owGDSPNR as GDSPNR,c.ticketNum
		FROM tblPassengerBookDetails c
	    inner join #TripCompleteTempTable temp
		on c.fkBookMaster=temp.pkId

		drop table #TripCompleteTempTable; 

	end
	else if(@opr=3)  -- Canceled Trip
	begin
	 	  	with cte as
			(
			
			SELECT a.pkId , a.airName as owairName,a.frmSector as owfrmSector,a.toSector as owtoSector,CONVERT(date,a.deptTime) as owdepDate,a.arrivalDate as owarrivalDate,a.fromAirport as owfromAirport,
				a.deptTime as owdeptTime,a.fromTerminal as owfromTerminal,a.toTerminal as owtoTerminal,a.GDSPNR as owGDSPNR,a.arrivalTime as owarrivalTime,
				a.flightNo as owflightNo,a.riyaPNR as owriyaPNR,a.isReturnJourney,a.emailId,a.mobileNo,a.returnFlag,
				CASE WHEN a.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), a.basicFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),a.basicFare * a.ROE)) END as owbasicFare,--a.basicFare as owbasicFare,
				CASE WHEN a.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), a.totalTax * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),a.totalTax * a.ROE)) END as owtotalTax,--a.totalTax as owtotalTax,
				CASE WHEN a.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), a.totalFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),a.totalFare * a.ROE)) END as owtotalFare,--a.totalFare as owtotalFare,
				a.TotalTime as owTotalTime,a.airCode as owCarrier,a.CounterCloseTime as owCounterCloseTime,
				b.airName as rtairName,b.frmSector as rtfrmSector,b.toSector as rttoSector,CONVERT(date,b.deptTime) as rtdepDate,b.arrivalDate as rtarrivalDate,
				b.deptTime as rtdeptTime,b.arrivalTime as rtarrivalTime,b.flightNo as rtflightNo,b.riyaPNR as rtriyaPNR,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.basicFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.basicFare * a.ROE)) END as rtbasicFare,--b.basicFare as rtbasicFare,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalTax * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalTax * a.ROE)) END as rttotalTax,--b.totalTax as rttotalTax, 
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalFare * a.ROE)) END as rttotalFare,--b.totalFare as rttotalFare,
				b.fromTerminal as rtfromTerminal,b.toTerminal as rttoTerminal,b.CounterCloseTime as rtCounterCloseTime,
				b.TotalTime as rtTotalTime,b.GDSPNR as rtGDSPNR,b.airCode as rtCarrier,b.fromAirport as rtFromAirport,b.toAirport as rtoAirport,
				--(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled=0 and a.pkid=pax.fkBookMaster) as CancelFlag
				case when a.canceledDate is null then 0 else 1 end as CancelFlag
				,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE a.pkid=pax2.fkBookMaster) as baggage
				,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  a.pkid=pax3.fkBookMaster) as BookingDate
				--,p.baggage as baggage,p.inserteddate as BookingDate
				,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as BookingBy,a.IsBooked as owIsBooked,b.IsBooked as rtIsBooked,a.toAirport,a.orderId,a.ROE,a.Country
			FROM tblBookMaster a
				left JOIN tblBookMaster b on a.orderId=b.orderId and a.GDSPNR=b.GDSPNR and b.returnFlag=1
				inner Join UserLogin u on a.LoginEmailID=u.UserID and u.UserName=@EmailID
			 where  a.returnFlag=0 and a.IsBooked=1

			Union ALL

			
			SELECT b.pkId , b.airName as owairName,b.frmSector as owfrmSector,b.toSector as owtoSector,CONVERT(date,b.deptTime) as owdepDate,b.arrivalDate as owarrivalDate,b.fromAirport as owfromAirport,
				b.deptTime as owdeptTime,b.fromTerminal as owfromTerminal,b.toTerminal as owtoTerminal,b.GDSPNR as owGDSPNR,b.arrivalTime as owarrivalTime,
				b.flightNo as owflightNo,b.riyaPNR as owriyaPNR,b.isReturnJourney,b.emailId,b.mobileNo,b.returnFlag,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.basicFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.basicFare * a.ROE)) END as owbasicFare,--b.basicFare as owbasicFare,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalTax * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalTax * a.ROE)) END as owtotalTax,--b.totalTax as owtotalTax,
				CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalFare * a.ROE)) END as owtotalFare,--b.totalFare as owtotalFare,
				b.TotalTime as owTotalTime,b.airCode as owCarrier,b.CounterCloseTime as owCounterCloseTime,
				
				null as rtairName,null as rtfrmSector,null as rttoSector ,null as rtdepDate,null as rtarrivalDate,
				null as rtdeptTime,null as rtarrivalTime,null as rtflightNo,null as rtriyaPNR,null as rtbasicFare,
				null as rttotalTax,null as rttotalFare,null as rtfromTerminal,null as rttoTerminal,null as rtCounterCloseTime,
				null as rtTotalTime,null as rtGDSPNR,null as rtCarrier,b.fromAirport as rtFromAirport,b.toAirport as rtoAirport,
				--(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled=0 and b.pkid=pax.fkBookMaster) as CancelFlag
				case when a.canceledDate is null then 0 else 1 end as CancelFlag
				,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE b.pkid=pax2.fkBookMaster) as baggage
				,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  b.pkid=pax3.fkBookMaster) as BookingDate
				--,p.baggage as baggage,p.inserteddate as BookingDate
				,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE b.pkid=pax.fkBookMaster) as BookingBy,
				b.IsBooked as owIsBooked,b.IsBooked as rtIsBooked,b.toAirport,a.orderId,a.ROE,a.Country
			FROM tblBookMaster a
				inner JOIN tblBookMaster b on a.orderId=b.orderId and a.GDSPNR!=b.GDSPNR 
				inner Join UserLogin u on b.LoginEmailID=u.UserID and u.UserName=@EmailID
            where  b.returnFlag=1 and b.IsBooked=1
		)
		SELECT c.* INTO #TripCancelTempTable
             FROM cte c WHERE  CancelFlag=1;

        select * from #TripCancelTempTable;

		SELECT c.paxFName,c.paxLName,c.pid,c.fkBookMaster,c.title,temp.owGDSPNR as GDSPNR,c.ticketNum
		FROM tblPassengerBookDetails c
	    inner join #TripCancelTempTable temp
		on c.fkBookMaster=temp.pkId

		drop table #TripCancelTempTable; 
	end
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetBookingHistory] TO [rt_read]
    AS [dbo];

