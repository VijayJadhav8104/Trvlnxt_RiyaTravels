
CREATE PROCEDURE [dbo].[sp_BookingHistory]--'sohan.salunke@riya.travel',3
	@EmailID varchar(500),
	@opr int 
AS
BEGIN
	IF(@opr=1)--Upcoming Trip
	BEGIN
		--with cte as
		--	(SELECT a.pkId, a.airName as owairName,a.frmSector as owfrmSector,a.toSector as owtoSector,a.depDate as owdepDate,a.arrivalDate as owarrivalDate,a.deptTime as owdeptTime,a.fromTerminal as owfromTerminal,a.toTerminal as owtoTerminal,a.GDSPNR as owGDSPNR,
		--	a.arrivalTime as owarrivalTime,a.flightNo as owflightNo,a.riyaPNR as owriyaPNR,a.isReturnJourney,a.emailId,a.mobileNo,a.returnFlag,a.basicFare as owbasicFare,a.totalTax as owtotalTax,a.totalFare as owtotalFare,a.TotalTime as owTotalTime,a.airCode as owCarrier,
		--		b.airName as rtairName,b.frmSector as rtfrmSector,b.toSector as rttoSector,b.depDate as rtdepDate,b.arrivalDate as rtarrivalDate,b.deptTime as rtdeptTime,
		--		b.arrivalTime as rtarrivalTime,b.flightNo as rtflightNo,b.riyaPNR as rtriyaPNR,b.basicFare as rtbasicFare,b.totalTax as rttotalTax,b.totalFare as rttotalFare,b.fromTerminal as rtfromTerminal,b.toTerminal as rttoTerminal,b.TotalTime as rtTotalTime,b.GDSPNR as rtGDSPNR,b.airCode as rtCarrier,
		--	(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled IS NULL and a.pkid=pax.fkBookMaster) as CancelFlag
		--	,(SELECT TOP 1 baggage FROM tblPassengerBookDetails pax WHERE pax.Iscancelled IS NULL and a.pkid=pax.fkBookMaster) as baggage
		--	,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as BookingBy
		--	,(SELECT TOP 1 pax.inserteddate FROM tblPassengerBookDetails pax WHERE pax.Iscancelled IS NULL and a.pkid=pax.fkBookMaster) as BookingDate
		--		,(DENSE_RANK() over (partition by a.orderId order by a.pkId)) as dd
		--	FROM tblBookMaster a
		--		LEFT JOIN tblBookMaster b on a.orderId=b.orderId and b.returnFlag=1
		--)
		--SELECT * FROM cte
		--WHERE returnFlag=0 AND emailId='sohan.salunke@riya.travel' AND owdepDate >= GETDATE() AND CancelFlag=0
		
		with cte as
			(SELECT a.pkId , a.airName as owairName,a.frmSector as owfrmSector,a.toSector as owtoSector,a.depDate as owdepDate,a.arrivalDate as owarrivalDate,
				a.deptTime as owdeptTime,a.fromTerminal as owfromTerminal,a.toTerminal as owtoTerminal,a.GDSPNR as owGDSPNR,a.arrivalTime as owarrivalTime,
				a.flightNo as owflightNo,a.riyaPNR as owriyaPNR,a.isReturnJourney,a.emailId,a.mobileNo,a.returnFlag,a.basicFare as owbasicFare,
				a.totalTax as owtotalTax,a.totalFare as owtotalFare,a.TotalTime as owTotalTime,a.airCode as owCarrier,a.CounterCloseTime as owCounterCloseTime,
				b.airName as rtairName,b.frmSector as rtfrmSector,b.toSector as rttoSector,b.depDate as rtdepDate,b.arrivalDate as rtarrivalDate,
				b.deptTime as rtdeptTime,b.arrivalTime as rtarrivalTime,b.flightNo as rtflightNo,b.riyaPNR as rtriyaPNR,b.basicFare as rtbasicFare,
				b.totalTax as rttotalTax,b.totalFare as rttotalFare,b.fromTerminal as rtfromTerminal,b.toTerminal as rttoTerminal,b.CounterCloseTime as rtCounterCloseTime,
				b.TotalTime as rtTotalTime,b.GDSPNR as rtGDSPNR,b.airCode as rtCarrier,
				(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled IS NULL and a.pkid=pax.fkBookMaster) as CancelFlag
				,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE a.pkid=pax2.fkBookMaster) as baggage
				,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  a.pkid=pax3.fkBookMaster) as BookingDate
				--,p.baggage as baggage,p.inserteddate as BookingDate
				,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as BookingBy,a.IsBooked as owIsBooked,b.IsBooked as rtIsBooked
			FROM tblBookMaster a
				LEFT JOIN tblBookMaster b on a.orderId=b.orderId and b.returnFlag=1
			--	LEFT JOIN tblPassengerBookDetails p on  a.pkid=p.fkBookMaster
		)
		SELECT * FROM cte
		WHERE returnFlag=0 AND emailId=@EmailID AND owdepDate >= GETDATE() AND CancelFlag=0 AND owIsBooked=1 

		--	with cte as
		--	(SELECT a.pkId , a.airName as owairName,a.frmSector as owfrmSector,a.toSector as owtoSector,a.depDate as owdepDate,a.arrivalDate as owarrivalDate,
		--		a.deptTime as owdeptTime,a.fromTerminal as owfromTerminal,a.toTerminal as owtoTerminal,a.GDSPNR as owGDSPNR,a.arrivalTime as owarrivalTime,
		--		a.flightNo as owflightNo,a.riyaPNR as owriyaPNR,a.isReturnJourney,a.emailId,a.mobileNo,a.returnFlag,a.basicFare as owbasicFare,
		--		a.totalTax as owtotalTax,a.totalFare as owtotalFare,a.TotalTime as owTotalTime,a.airCode as owCarrier,a.CounterCloseTime as owCounterCloseTime,
		--		b.airName as rtairName,b.frmSector as rtfrmSector,b.toSector as rttoSector,b.depDate as rtdepDate,b.arrivalDate as rtarrivalDate,
		--		b.deptTime as rtdeptTime,b.arrivalTime as rtarrivalTime,b.flightNo as rtflightNo,b.riyaPNR as rtriyaPNR,b.basicFare as rtbasicFare,
		--		b.totalTax as rttotalTax,b.totalFare as rttotalFare,b.fromTerminal as rtfromTerminal,b.toTerminal as rttoTerminal,b.CounterCloseTime as rtCounterCloseTime,
		--		b.TotalTime as rtTotalTime,b.GDSPNR as rtGDSPNR,b.airCode as rtCarrier,
		--		(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled IS NULL and a.pkid=pax.fkBookMaster) as CancelFlag
		--		,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE a.pkid=pax2.fkBookMaster) as baggage
		--		,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  a.pkid=pax3.fkBookMaster) as BookingDate
		--		--,p.baggage as baggage,p.inserteddate as BookingDate
		--		,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as BookingBy,a.IsBooked as owIsBooked,b.IsBooked as rtIsBooked
		--	FROM tblBookMaster a
		--		LEFT JOIN tblBookMaster b on a.GDSPNR=b.GDSPNR and b.returnFlag=1
		--	--	LEFT JOIN tblPassengerBookDetails p on  a.pkid=p.fkBookMaster
		--)
		--SELECT * FROM cte
		--WHERE  emailId='sohan.salunke@riya.travel' AND owdepDate >= GETDATE() AND CancelFlag=0 AND owIsBooked=1 


		SELECT c.paxFName,c.paxLName,c.pid,c.fkBookMaster,c.title,a.GDSPNR,c.ticketNum
		FROM tblPassengerBookDetails c
			LEFT JOIN tblBookMaster a  on  a.pkId=c.fkBookMaster
		WHERE a.returnFlag=0 AND a.emailId=@EmailID AND c.Iscancelled IS NULL AND a.depDate >= GETDATE() 

	END

	IF(@opr=2)--Completed Trip
	BEGIN
		with cte as
			(SELECT Distinct a.pkId, a.airName as owairName,a.frmSector as owfrmSector,a.toSector as owtoSector,a.depDate as owdepDate,a.arrivalDate as owarrivalDate,a.deptTime as owdeptTime,a.fromTerminal as owfromTerminal,a.toTerminal as owtoTerminal,a.GDSPNR as owGDSPNR,
			a.arrivalTime as owarrivalTime,a.flightNo as owflightNo,a.riyaPNR as owriyaPNR,a.isReturnJourney,a.emailId,a.mobileNo,a.returnFlag,a.basicFare as owbasicFare,a.totalTax as owtotalTax,a.totalFare as owtotalFare,a.TotalTime as owTotalTime,a.airCode as owCarrier,
				b.airName as rtairName,b.frmSector as rtfrmSector,b.toSector as rttoSector,b.depDate as rtdepDate,b.arrivalDate as rtarrivalDate,b.deptTime as rtdeptTime,
				b.arrivalTime as rtarrivalTime,b.flightNo as rtflightNo,b.riyaPNR as rtriyaPNR,b.basicFare as rtbasicFare,b.totalTax as rttotalTax,b.totalFare as rttotalFare,b.fromTerminal as rtfromTerminal,b.toTerminal as rttoTerminal,b.TotalTime as rtTotalTime,b.GDSPNR as rtGDSPNR,b.airCode as rtCarrier,
			(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled IS NULL and a.pkid=pax.fkBookMaster) as CancelFlag
			,p.baggage as baggage,p.inserteddate as BookingDate
			,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as BookingBy
			FROM tblBookMaster a
				LEFT JOIN tblBookMaster b on a.orderId=b.orderId and b.returnFlag=1
				LEFT JOIN tblPassengerBookDetails p on  a.pkid=p.fkBookMaster
		)
		SELECT * FROM cte
		WHERE returnFlag=0 AND emailId=@EmailID AND owdepDate  <= GETDATE() AND CancelFlag=0

		
		SELECT c.paxFName,c.paxLName,c.pid,c.fkBookMaster,c.title,a.GDSPNR,c.ticketNum
		FROM tblPassengerBookDetails c
			LEFT JOIN tblBookMaster a  on  a.pkId=c.fkBookMaster
		WHERE a.returnFlag=0 AND a.emailId=@EmailID AND c.Iscancelled IS NULL AND a.depDate <= GETDATE()

	END

	IF(@opr=3)--Cancelled Trip
	BEGIN
		with cte as
			(SELECT Distinct a.pkId, a.airName as owairName,a.frmSector as owfrmSector,a.toSector as owtoSector,a.depDate as owdepDate,a.arrivalDate as owarrivalDate,a.deptTime as owdeptTime,a.fromTerminal as owfromTerminal,a.toTerminal as owtoTerminal,a.GDSPNR as owGDSPNR,
			a.arrivalTime as owarrivalTime,a.flightNo as owflightNo,a.riyaPNR as owriyaPNR,a.isReturnJourney,a.emailId,a.mobileNo,a.returnFlag,a.basicFare as owbasicFare,a.totalTax as owtotalTax,a.totalFare as owtotalFare,a.TotalTime as owTotalTime,a.airCode as owCarrier,
				b.airName as rtairName,b.frmSector as rtfrmSector,b.toSector as rttoSector,b.depDate as rtdepDate,b.arrivalDate as rtarrivalDate,b.deptTime as rtdeptTime,
				b.arrivalTime as rtarrivalTime,b.flightNo as rtflightNo,b.riyaPNR as rtriyaPNR,b.basicFare as rtbasicFare,b.totalTax as rttotalTax,b.totalFare as rttotalFare,b.fromTerminal as rtfromTerminal,b.toTerminal as rttoTerminal,b.TotalTime as rtTotalTime,b.GDSPNR as rtGDSPNR,b.airCode as rtCarrier,
			(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled IS NULL and a.pkid=pax.fkBookMaster) as CancelFlag
			,p.baggage as baggage,p.inserteddate as BookingDate
			,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as BookingBy
			FROM tblBookMaster a
				LEFT JOIN tblBookMaster b on a.orderId=b.orderId and b.returnFlag=1
				LEFT JOIN tblPassengerBookDetails p on  a.pkid=p.fkBookMaster
		)
		SELECT * FROM cte
		WHERE returnFlag=0 AND emailId=@EmailID AND CancelFlag=1
		

		SELECT c.paxFName,c.paxLName,c.pid,c.fkBookMaster,c.title,a.GDSPNR,c.ticketNum
		FROM tblPassengerBookDetails c
			LEFT JOIN tblBookMaster a  on  a.pkId=c.fkBookMaster
		WHERE a.returnFlag=0 AND a.emailId=@EmailID AND c.Iscancelled=1
	END
END
	





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_BookingHistory] TO [rt_read]
    AS [dbo];

