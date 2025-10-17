CREATE proc [dbo].[sp_ManagerBooking_new] --[dbo].[sp_ManagerBooking_new] 'Z7E7Y2'

	@RiyaPNR varchar(500)

As
Begin
with cte as
			(SELECT a.pkId , a.airName as owairName,a.frmSector as owfrmSector,a.toSector as owtoSector,a.deptTime as owdepDate,a.arrivalDate as owarrivalDate,a.fromAirport as owfromAirport,
				a.deptTime as owdeptTime,a.fromTerminal as owfromTerminal,a.toTerminal as owtoTerminal,a.GDSPNR as owGDSPNR,a.arrivalTime as owarrivalTime,a.TotalMarkup as confee,
				a.flightNo as owflightNo,a.riyaPNR as owriyaPNR,a.isReturnJourney,a.emailId,a.mobileNo,a.returnFlag,a.basicFare as owbasicFare,a.totalTax as owtotalTax
				
				--added by bhavika
				,p.mer_amount as owtotalFare
				--,a.totalFare as owtotalFare

				,a.TotalTime as owTotalTime,a.airCode as owCarrier,a.CounterCloseTime as owCounterCloseTime,
				b.airName as rtairName,b.frmSector as rtfrmSector,b.toSector as rttoSector,b.depDate as rtdepDate,b.arrivalDate as rtarrivalDate,
				b.deptTime as rtdeptTime,b.arrivalTime as rtarrivalTime,b.flightNo as rtflightNo,b.riyaPNR as rtriyaPNR,b.basicFare as rtbasicFare,
				b.totalTax as rttotalTax

				--added by bhavika
				,p1.mer_amount as rttotalFare
				--,b.totalFare as rttotalFare

				,b.fromTerminal as rtfromTerminal,b.toTerminal as rttoTerminal,b.CounterCloseTime as rtCounterCloseTime,
				b.TotalTime as rtTotalTime,b.GDSPNR as rtGDSPNR,b.airCode as rtCarrier,b.fromAirport as rtFromAirport,b.toAirport as rtoAirport,
				--(SELECT (case when count(pax.pid) != 0 then 0 else 1 end) as df FROM tblPassengerBookDetails pax WHERE pax.Iscancelled=0 and a.pkid=pax.fkBookMaster) as CancelFlag
			case when a.canceledDate is null then 0 else 1 end as CancelFlag
				,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE a.pkid=pax2.fkBookMaster) as baggage
				,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  a.pkid=pax3.fkBookMaster) as BookingDate
				--,p.baggage as baggage,p.inserteddate as BookingDate
				,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as BookingBy,a.IsBooked as owIsBooked,b.IsBooked as rtIsBooked
				,(select top 1 airlinePNR from tblBookItenary bItnry where a.pkid=bItnry.fkBookMaster AND a.operatingCarrier=bItnry.operatingCarrier) as AirlinePNR,a.toAirport,a.orderId,
				isnull((a.FlatDiscount + a.IATACommission + a.PLBCommission + a.PromoDiscount),0) as 'DiscountS',(a.totalFare + a.ServiceCharge) as TFS,
				isnull((b.FlatDiscount + b.IATACommission + b.PLBCommission+b.PromoDiscount),0) as 'DiscountR',(b.totalFare + b.ServiceCharge) as TFR
				,(SELECT TOP 1(IsRefunded) FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as RefundFlag,a.Country
			FROM tblBookMaster a
				left JOIN tblBookMaster b on a.orderId=b.orderId and a.GDSPNR=b.GDSPNR and b.returnFlag=1
				left join Paymentmaster p on p.order_id=a.orderId
				left join Paymentmaster p1 on p.order_id=b.orderId
	
			 where a.riyaPNR=@RiyaPNR  and a.IsBooked=1
			 )
			 SELECT c.* INTO #TripUpcomingTempTable
             FROM cte c 
			 select * from #TripUpcomingTempTable;

		SELECT c.paxFName,c.paxLName,c.pid,c.fkBookMaster,c.title,temp.AirlinePNR as GDSPNR,case when LEN(c.ticketNum)>20 
		then lTRIM(REPLACE(replace(SUBSTRING(c.ticketNum, 1, CHARINDEX('/', c.ticketNum)), 'PAX', ''),'/','')) Else c.ticketNum END as 'ticketNum'
		--added by bhavika
		
		, isnull((STUFF((SELECT '/ ' + SSR_Name from tblSSRDetails as ssr WITH(NOLOCK) Where ssr.fkPassengerid=c.pid and ssr.SSR_Type='Baggage' FOR XML PATH('')), 1, 1, '')),'') as 'BaggageDesc'
		, isnull((STUFF((SELECT '/ ' + SSR_Name from tblSSRDetails as ssr WITH(NOLOCK) Where ssr.fkPassengerid=c.pid and ssr.SSR_Type='Meals' FOR XML PATH('')), 1, 1, '')),'') as 'MealDesc'

		FROM tblPassengerBookDetails c
	    inner join #TripUpcomingTempTable temp
		on c.fkBookMaster=temp.pkId

		drop table #TripUpcomingTempTable; 
End


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_ManagerBooking_new] TO [rt_read]
    AS [dbo];

