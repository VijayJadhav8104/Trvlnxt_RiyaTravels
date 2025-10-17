


CREATE procEDURE [dbo].[sp_ManagerBooking] -- '191GYD'-- [dbo].[sp_ManagerBooking] 'YGQE2E'  DQ13S2  110Z2F
	@RiyaPNR varchar(500)
AS
BEGIN
	BEGIN
		with cte as
			(
			
			SELECT a.pkId , a.airName as owairName,a.frmSector as owfrmSector,a.toSector as owtoSector,a.deptTime as owdepDate,a.arrivalDate as owarrivalDate,a.fromAirport as owfromAirport,
				a.deptTime as owdeptTime,a.fromTerminal as owfromTerminal,a.toTerminal as owtoTerminal,a.GDSPNR as owGDSPNR,a.arrivalTime as owarrivalTime,a.TotalMarkup as confee,
				a.flightNo as owflightNo,a.riyaPNR as owriyaPNR,a.isReturnJourney,a.emailId,a.mobileNo,a.returnFlag,a.basicFare as owbasicFare,
				a.totalTax as owtotalTax,a.totalFare as owtotalFare,a.TotalTime as owTotalTime,a.airCode as owCarrier,a.CounterCloseTime as owCounterCloseTime,
				b.airName as rtairName,b.frmSector as rtfrmSector,b.toSector as rttoSector,b.depDate as rtdepDate,b.arrivalDate as rtarrivalDate,
				b.deptTime as rtdeptTime,b.arrivalTime as rtarrivalTime,b.flightNo as rtflightNo,b.riyaPNR as rtriyaPNR,b.basicFare as rtbasicFare,
				b.totalTax as rttotalTax,b.totalFare as rttotalFare,b.fromTerminal as rtfromTerminal,b.toTerminal as rttoTerminal,b.CounterCloseTime as rtCounterCloseTime,
				b.TotalTime as rtTotalTime,b.GDSPNR as rtGDSPNR,b.airCode as rtCarrier,b.fromAirport as rtFromAirport,b.toAirport as rtoAirport,
				--(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled=0 and a.pkid=pax.fkBookMaster) as CancelFlag
			case when a.canceledDate is null then 0 else 1 end as CancelFlag
				,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE a.pkid=pax2.fkBookMaster) as baggage
				,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  a.pkid=pax3.fkBookMaster) as BookingDate
				--,p.baggage as baggage,p.inserteddate as BookingDate
				,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as BookingBy,a.IsBooked as owIsBooked,b.IsBooked as rtIsBooked
				,(select top 1 airlinePNR from tblBookItenary bItnry where a.pkid=bItnry.fkBookMaster AND a.operatingCarrier=bItnry.operatingCarrier) as AirlinePNR,a.toAirport,a.orderId,
				isnull((a.FlatDiscount + a.IATACommission + a.PLBCommission),0) as 'DiscountS',(a.totalFare + a.ServiceCharge) as TFS,
				isnull((b.FlatDiscount + b.IATACommission + b.PLBCommission),0) as 'DiscountR',(b.totalFare + b.ServiceCharge) as TFR
				,(SELECT TOP 1(IsRefunded) FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as RefundFlag,a.Country
			FROM tblBookMaster a
				left JOIN tblBookMaster b on a.orderId=b.orderId and a.GDSPNR=b.GDSPNR and b.returnFlag=1
	
			 where a.riyaPNR=@RiyaPNR and a.returnFlag=0 and a.IsBooked=1 and  a.depDate >= GETDATE() 

			Union ALL

			
			SELECT b.pkId , b.airName as owairName,b.frmSector as owfrmSector,b.toSector as owtoSector,b.deptTime as owdepDate,b.arrivalDate as owarrivalDate,b.fromAirport as owfromAirport,
				b.deptTime as owdeptTime,b.fromTerminal as owfromTerminal,b.toTerminal as owtoTerminal,b.GDSPNR as owGDSPNR,b.arrivalTime as owarrivalTime,b.TotalMarkup as confee,
				b.flightNo as owflightNo,b.riyaPNR as owriyaPNR,b.isReturnJourney,b.emailId,b.mobileNo,b.returnFlag,b.basicFare as owbasicFare,
				b.totalTax as owtotalTax,b.totalFare as owtotalFare,b.TotalTime as owTotalTime,b.airCode as owCarrier,b.CounterCloseTime as owCounterCloseTime,
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
				b.IsBooked as owIsBooked,b.IsBooked as rtIsBooked
				,(select top 1 airlinePNR from tblBookItenary bItnry where b.pkid=bItnry.fkBookMaster AND b.operatingCarrier=bItnry.operatingCarrier) as AirlinePNR,b.toAirport,a.orderId,
				isnull((b.FlatDiscount + b.IATACommission + b.PLBCommission),0) as 'DiscountS',(b.totalFare + b.ServiceCharge) as TFS,0 AS DiscountR, 0 AS TFR
				,(SELECT TOP 1(IsRefunded) FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as RefundFlag,a.Country
			FROM tblBookMaster a
				inner JOIN tblBookMaster b on a.orderId=b.orderId and a.GDSPNR!=b.GDSPNR 
            where  b.returnFlag=1 and b.IsBooked=1 and  b.depDate >= GETDATE() and 
			b.riyaPNR=@RiyaPNR
		)
		SELECT c.* INTO #TripUpcomingTempTable
             FROM cte c 

        select * from #TripUpcomingTempTable;

		SELECT c.paxFName,c.paxLName,c.pid,c.fkBookMaster,c.title,temp.AirlinePNR as GDSPNR,case when LEN(c.ticketNum)>20 
		then lTRIM(REPLACE(replace(SUBSTRING(c.ticketNum, 1, CHARINDEX('/', c.ticketNum)), 'PAX', ''),'/','')) Else c.ticketNum END as 'ticketNum'
		FROM tblPassengerBookDetails c
	    inner join #TripUpcomingTempTable temp
		on c.fkBookMaster=temp.pkId

		drop table #TripUpcomingTempTable; 

	END
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_ManagerBooking] TO [rt_read]
    AS [dbo];

