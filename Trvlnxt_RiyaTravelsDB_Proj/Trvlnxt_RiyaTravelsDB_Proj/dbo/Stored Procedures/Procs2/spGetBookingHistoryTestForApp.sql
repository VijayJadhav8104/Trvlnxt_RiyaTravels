CREATE procEDURE [dbo].[spGetBookingHistoryTestForApp]  -- spGetBookingHistoryTestForApp 'developers@riya.travel',null
@EmailID varchar(500)=null,
@RiyaPNR varchar(10)=null
AS
BEGIN
with cte as
(

SELECT a.pkId , a.airName as owairName,a.frmSector as owfrmSector,a.toSector as owtoSector,CONVERT(date,a.deptTime) as owdepDate,a.arrivalDate as owarrivalDate,a.fromAirport as owfromAirport,
a.deptTime as owdeptTime,a.fromTerminal as owfromTerminal,a.toTerminal as owtoTerminal,a.GDSPNR as owGDSPNR,a.arrivalTime as owarrivalTime,
a.flightNo as owflightNo,a.riyaPNR as owriyaPNR,a.isReturnJourney,a.emailId,a.mobileNo,a.returnFlag,
CASE WHEN a.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), a.basicFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),a.basicFare * a.ROE)) END as owbasicFare,--a.basicFare as owbasicFare,
CASE WHEN a.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), a.totalTax * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),a.totalTax * a.ROE)) END as owtotalTax,--a.totalTax as owtotalTax,
CASE WHEN a.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), a.totalFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),a.totalFare * a.ROE)) END as owtotalFare,--a.totalFare as owtotalFare,
a.TotalTime as owTotalTime,a.airCode as owCarrier,a.CounterCloseTime as owCounterCloseTime,a.TotalDiscount as owTotalDiscount,
b.airName as rtairName,b.frmSector as rtfrmSector,b.toSector as rttoSector,CONVERT(date,b.deptTime) as rtdepDate,b.arrivalDate as rtarrivalDate,
b.deptTime as rtdeptTime,b.arrivalTime as rtarrivalTime,b.flightNo as rtflightNo,b.riyaPNR as rtriyaPNR,
CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.basicFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.basicFare * a.ROE)) END as rtbasicFare,--b.basicFare as rtbasicFare,
CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalTax * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalTax * a.ROE)) END as rttotalTax,--b.totalTax as rttotalTax, 
CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalFare * a.ROE)) END as rttotalFare,--b.totalFare as rttotalFare,
b.fromTerminal as rtfromTerminal,b.toTerminal as rttoTerminal,b.CounterCloseTime as rtCounterCloseTime,b.TotalDiscount as rtTotalDiscount,
b.TotalTime as rtTotalTime,b.GDSPNR as rtGDSPNR,b.airCode as rtCarrier,b.fromAirport as rtFromAirport,b.toAirport as rtoAirport,

case when a.canceledDate is null then 0 else 1 end as CancelFlag

,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE a.pkid=pax2.fkBookMaster) as baggage
,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  a.pkid=pax3.fkBookMaster) as BookingDate

,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE a.pkid=pax.fkBookMaster) as BookingBy,a.IsBooked as owIsBooked,b.IsBooked as rtIsBooked,
a.toAirport,a.orderId,a.ROE,a.Country,a.OfficeID,a.TotalMarkup as confee
, case when  CONVERT(date,a.deptTime)  >= GETDATE() then 'Upcoming'
		when CONVERT(date,a.deptTime) <= GETDATE() Then 'Completed'
		when a.canceledDate is not null then 'Cancelled'
 end as 'BookingState'
FROM tblBookMaster a
left JOIN tblBookMaster b on a.orderId=b.orderId and a.GDSPNR=b.GDSPNR and b.returnFlag=1
inner Join UserLogin u on a.LoginEmailID=u.UserID and u.UserName=@EmailID
where a.returnFlag=0 and a.IsBooked=1 

Union ALL


SELECT b.pkId , b.airName as owairName,b.frmSector as owfrmSector,b.toSector as owtoSector,CONVERT(date,b.deptTime) as owdepDate,b.arrivalDate as owarrivalDate,b.fromAirport as owfromAirport,
b.deptTime as owdeptTime,b.fromTerminal as owfromTerminal,b.toTerminal as owtoTerminal,b.GDSPNR as owGDSPNR,b.arrivalTime as owarrivalTime,
b.flightNo as owflightNo,b.riyaPNR as owriyaPNR,b.isReturnJourney,b.emailId,b.mobileNo,b.returnFlag,
CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.basicFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.basicFare * a.ROE)) END as owbasicFare,--b.basicFare as owbasicFare,
CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalTax * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalTax * a.ROE)) END as owtotalTax,--b.totalTax as owtotalTax,
CASE WHEN b.Country = 'IN' THEN CONVERT(VARCHAR(20),CONVERT(decimal(18,0), b.totalFare * a.ROE))ELSE CONVERT(VARCHAR(20),CONVERT(decimal(18,2),b.totalFare * a.ROE)) END as owtotalFare,--b.totalFare as owtotalFare,
b.TotalTime as owTotalTime,b.airCode as owCarrier,b.CounterCloseTime as owCounterCloseTime,b.TotalDiscount as owTotalDiscount,

null as rtairName,null as rtfrmSector,null as rttoSector ,null as rtdepDate,null as rtarrivalDate,
null as rtdeptTime,null as rtarrivalTime,null as rtflightNo,null as rtriyaPNR,null as rtbasicFare,
null as rttotalTax,null as rttotalFare,null as rtfromTerminal,null as rttoTerminal,null as rtCounterCloseTime,null as rtTotalDiscount,
null as rtTotalTime,null as rtGDSPNR,null as rtCarrier,b.fromAirport as rtFromAirport,b.toAirport as rtoAirport,
case when a.canceledDate is null then 0 else 1 end as CancelFlag

,(SELECT Top 1 baggage FROM tblPassengerBookDetails pax2 WHERE b.pkid=pax2.fkBookMaster) as baggage
,(SELECT Top 1 inserteddate FROM tblPassengerBookDetails pax3 WHERE  b.pkid=pax3.fkBookMaster) as BookingDate
,(SELECT TOP 1 pax.paxFName + ' '+pax.paxLName FROM tblPassengerBookDetails pax WHERE b.pkid=pax.fkBookMaster) as BookingBy,
b.IsBooked as owIsBooked,b.IsBooked as rtIsBooked,b.toAirport,a.orderId,a.ROE,a.Country,a.OfficeID,a.TotalMarkup as confee
, case when  CONVERT(date,a.deptTime)  >= GETDATE() then 'Upcoming'
  when CONVERT(date,a.deptTime) <= GETDATE() Then 'Completed'
 end as 'BookingState'

FROM tblBookMaster a
inner JOIN tblBookMaster b on a.orderId=b.orderId and a.GDSPNR!=b.GDSPNR 
inner Join UserLogin u on b.LoginEmailID=u.UserID and u.UserName=@EmailID
            where  b.returnFlag=1 and b.IsBooked=1 
)

SELECT c.* INTO #TripUpcomingTempTable
             FROM cte c WHERE  (owriyaPNR=@RiyaPNR or @RiyaPNR is null);

 select * from #TripUpcomingTempTable;

SELECT c.paxFName,c.paxLName,c.pid,c.fkBookMaster,c.title,temp.owGDSPNR as GDSPNR,lTRIM(REPLACE(replace(SUBSTRING(c.ticketNum, 1, CHARINDEX('/', c.ticketNum)), 'PAX', ''),'/',''))as ticketNum,paxType as PaxType
FROM tblPassengerBookDetails c
   inner join #TripUpcomingTempTable temp
on c.fkBookMaster=temp.pkId

SELECT HB.book_Id,HB.CheckInDate,DATEDIFF (DAY ,HB.CheckInDate ,HB.CheckOutDate ) as Night,HotelName,HB.inserteddate as BookedOn,(UL.FirstName+' '+UL.LastName )as BookedBy,


  case when HB.IsCancelled is null then 0 else 1 end as CancelFlag,
  case when HB.CheckInDate >= GETDATE() then 'Upcoming'
 
  when HB.CheckInDate <= GETDATE() Then 'Completed'  end as 'BookingState'
 
  from Hotel_BookMaster HB
JOIN 
UserLogin UL 
ON UL.UserName=HB.PassengerEmail
WHERE HB.PassengerEmail=@EmailID
 and  HB.book_message='Success' and HB.IsBooked=1    

drop table #TripUpcomingTempTable; 

END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetBookingHistoryTestForApp] TO [rt_read]
    AS [dbo];

