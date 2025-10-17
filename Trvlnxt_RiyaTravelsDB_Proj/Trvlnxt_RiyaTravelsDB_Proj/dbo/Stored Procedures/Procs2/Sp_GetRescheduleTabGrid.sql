--sp_helptext Sp_GetRescheduleTabGrid '8O5D4T', 'USD', ''


CREATE procedure [dbo].[Sp_GetRescheduleTabGrid]
@RiyaPNR nvarchar(50)=null,
@Currency nvarchar(20)=null,
@AgentID nvarchar(20)=null

as

begin

--Existing Ticket details
select 
tbi.frmSector 
,tbi.toSector 
,Format(cast(tbi.deptTime as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us') deptTime
,Format(cast(tbi.arrivalTime as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us') arrivalTime
,tbi.flightNo 
,tbi.cabin 
,tbi.farebasis 
,tbi.fromTerminal
,tbi.toTerminal
,CAST((tbi.arrivalTime-tbi.deptTime) as time(0)) FlightDifftime
,tb.OfficeID
,tb.AgentROE
,tb.ROE
,tb.operatingCarrier
,FORMAT(ag.AgentBalance,'N2') AgentBalance
--New Added
,tb.FareType, tb.AgentID, ag.UserTypeID, ISNULL(ag.NewCurrency,C.Currency) as Currency, tb.Country, tbi.pkId as fkItenary, tbi.fkBookMaster 
from tblBookMaster tb
left join AgentLogin ag on ag.UserID=tb.AgentID
left join tblBookItenary tbi on tbi.fkBookMaster=tb.pkId
INNER JOIN mCountry(nolock) C  ON C.CountryCode = ag.BookingCountry 
 where tb.RiyaPNR=@RiyaPNR order by tb.pkId asc

--New Ticket details
--select DISTINCT 
--Origin,
--Destination,
--Format(cast(DepartureDate as datetime),'dd/MM/yyyy hh:mm:s tt') DepartureDate
--,Format(cast(RescheduleDate as datetime),'dd/MM/yyyy hh:mm:s tt') RescheduleDate
--,rs.FlightNo,
--RescheduleClass 
--,tbi.farebasis
--,CAST((tbi.arrivalTime-tbi.deptTime) as time(0)) FlightDifftime
--from RescheduleData rs 
--left join tblBookItenary tbi on tbi.fkBookMaster=rs.pkId
--where rs.RiyaPNR=@RiyaPNR

--Reschedule Passenger List
select DISTINCT tp.title +'.'+' '+ tp.paxFName +' '+tp.paxLName +' '+'('+tp.paxType +')' as PassengerName, tp.YQ as YQ, tp.ExtraTax as OT, tp.JNTax as K3, tp.totalFare,
tp.basicFare , tp.totalTax, tp.paxFName, tp.paxLName, tp.title, tp.gender , tp.DiscriptionTax, tp.passportNum, tp.passportIssueCountry, tp.PassIssue,  
tp.passexp, tp.paxType, tp.nationality , tp.bfc, tp.MCOAmount, tp.ExtraTax,tp.OCTax, tp.InTax, tp.YrTax, tp.PLBPercent, tp.IATAPercent, tp.IsPLBOnBasic, tp.IsIATAOnBasic, 
tp.GovtTaxPercent ,tp.ServiceCharge, tp.CancellationCharge ,tp.dateOfBirth, tp.baggage, tp.isReturn as isReturn, --case when rs.IsReturnJourney=1 then 'True' else 'False' end as isReturn
(CASE WHEN CHARINDEX('/',ticketNum)>0 THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)))) 
ELSE ticketNum END )as 'TicketNumber'
from tblPassengerBookDetails tp  
left join RescheduleData rs on tp.pid=rs.pid
where rs.RiyaPNR=@RiyaPNR and rs.Status=7


--Reschedule Flight list 

select DISTINCT rs.NewPKid,rs.Status,
Origin, Destination, RescheduleFlightNo as FlightNo, --CONVERT(nvarchar(16), RescheduleDate, 103) DepartureDate, CONVERT(nvarchar(16), RescheduleDate, 103) ArrivalDate,--
 RescheduleDate as DepartureDate, RescheduleDate as ArrivalDate,
 Origin+'-'+Destination as Sector,
ta.NAME as FromAirport, ta1.NAME as ToAirport, rs.Class, tbm.returnFlag as IsReturnJourney, --rs.IsReturnJourney,
tbi.airName, tbi.operatingCarrier, tbi.airCode , tbi.equipment , tbi.farebasis,
cast(CONVERT(date, RescheduleDate, 103) as datetime) DepartureDatetime, cast(CONVERT(date, RescheduleDate, 103) as datetime) ArrivalDatetime
-- ,CAST((tbi.arrivalTime-tbi.deptTime) as time(0)) FlightDifftime
From RescheduleData rs 
left join tblBookItenary tbi on tbi.fkBookMaster=rs.pkId
LEFT JOIN tblAirportCity ta on ta.code=rs.Origin
LEFT JOIN tblAirportCity ta1 on ta1.code=rs.Destination
INNER JOIN tblBookMaster tbm on tbm.pkId=rs.pkId
where rs.RiyaPNR=@RiyaPNR  and rs.Status=7  order by rs.RescheduleDate asc-- rs.NewPKid asc


--ORDER ID
Select top 1 rs.orderId as OrderId,rs.riyaPNR,rs.ContactNo as passengerContactNo,
rs.Email as passengerEmailId,ISNULL(RescheduleBackEnduser,0) as MainAgentId,ISNULL(ReschedulebyAgency,0) as AgencyId
 
 from  RescheduleData rs
 where rs.riyapnr=@RiyaPNR order by rs.CreatedDate desc

 --Passenger list information all
 select distinct tp.paxType,tp.isReturn,tp.paxFName,tp.paxLName,tp.title,tp.gender,
 tp.bfc,tp.MCOAmount,tp.DiscriptionTax,tp.ExtraTax,tp.OCTax,tp.JnTax,tp.InTax,tp.YrTax,tp.PLBPercent,tp.IATAPercent,tp.IsPLBOnBasic,tp.IsIATAOnBasic,tp.GovtTaxPercent
 ,tp.ServiceCharge,tp.CancellationCharge,tp.TotalFare,tp.BasicFare,tp.TotalTax,tp.YQ,tp.nationality as Nationalty,tp.DateOfBirth,tp.PassIssue as  PassportIssue,tp.PassExp,tp.PassportIssueCountry,tp.passportNum
from RescheduleData rs 
left join tblPassengerBookDetails tp on tp.pid=rs.pid
where rs.RiyaPNR=@RiyaPNR


--SSR Details
Select SSR.SSR_Type,SSR.SSR_Name,SSR.SSR_Code,SSR.SSR_Amount,SSR.SSR_Status,SSR.fkBookMaster,SSR.fkItenary,
tbi.frmSector, tbi.toSector, tpbd.paxFName from tblSSRDetails SSR 
inner join  tblBookMaster tbm on tbm.pkid=SSR.fkBookMaster 
inner join tblPassengerBookDetails tpbd on SSR.fkPassengerid=tpbd.pid
inner join tblBookItenary tbi on SSR.fkItenary=tbi.pkId
where tbm.riyaPNR=@RiyaPNR
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetRescheduleTabGrid] TO [rt_read]
    AS [dbo];

