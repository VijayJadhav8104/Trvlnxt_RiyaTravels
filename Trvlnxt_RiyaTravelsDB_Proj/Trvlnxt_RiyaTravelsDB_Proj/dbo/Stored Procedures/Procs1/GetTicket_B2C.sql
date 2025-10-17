CREATE PROCEDURE [dbo].[GetTicket_B2C] -- [dbo].[GetTicket] 'RT20231007195547944',null
@OrderId			varchar(20) = NULL,
@RiyaPNR			varchar(20) = NULL
AS BEGIN

IF(@OrderId IS NULL)
BEGIN
SELECT @OrderId = orderId FROM tblBookMaster WHERE riyaPNR = @RiyaPNR




END
--  Other Info

SELECT TOP 1  
			B.emailId, 
			B.mobileNo,
			isnull(P.paxFName,'') +' '+ P.paxLName AS Name, 
			P.inserteddate AS BookingDate, 
			B.CounterCloseTime, 
			--B.totalFare+ isnull(b.TotalMarkup,0)+ISNULL((Select SUM(SSR_Amount) from tblSSRDetails as ssr WITH(NOLOCK)
			--	Where ssr.fkBookMaster IN (Select pkid From tblBookMaster WITH(NOLOCK) where pkId = B.pkId)),0) as totalFare, 
			pm.mer_amount as totalFare, 
			B.totalTax, 
			B.basicFare, 
			B.deptTime, 
			b.fromTerminal,
			B.frmSector+'/'+B.toSector as SectorName,
			B.airCode +'-'+B.flightNo as	FlightNo,
			isnull(B.TotalMarkup,0) as ServiceCharge,
			B.basicFare as Base, 
			B.deptTime as DateofTravel, 
			B.riyaPNR as PNR
			--ADDED BY BHAVIKA
			,ISNULL((Select SUM(SSR_Amount) from tblSSRDetails as ssr WITH(NOLOCK)
				Where ssr.fkBookMaster IN (Select pkid From tblBookMaster WITH(NOLOCK) where pkId = B.pkId) and ssr.SSR_Type='Baggage'),0) as 'BaggageTotal'
			,ISNULL((Select SUM(SSR_Amount) from tblSSRDetails as ssr WITH(NOLOCK) 
			Where ssr.fkBookMaster IN (Select pkid From tblBookMaster WITH(NOLOCK) where pkId = B.pkId) and ssr.SSR_Type='Meals') ,0) as 'MealTotal'



			,B.taxDesc as taxDesc,
			SUBSTRING(T.cabin,1,1) as Class,
			b.totalTax as totalTax,
			P.ticketNum as ticketNum,
			b.fromAirport, 
			P.baggage,
			p.airPNR as airlinePNR ,
			--B1.totalFare + isnull(B1.TotalMarkup,0)+ISNULL((Select SUM(SSR_Amount) from tblSSRDetails as ssr WITH(NOLOCK)
			--	Where ssr.fkBookMaster IN (Select pkid From tblBookMaster WITH(NOLOCK) where pkId = B1.pkId)),0) AS totalFareR, 
			pm1.mer_amount AS totalFareR,
			B1.totalTax AS 
			totalTaxR, 
			B1.basicFare AS basicFareR,
			B1.deptTime AS deptTimeR,
			P1.baggage AS baggageR, 
			B1.fromTerminal as fromTerminalR, 
			B1.fromAirport fromAirportR,b.orderId,
			isnull((b.FlatDiscount + b.IATACommission + b.PLBCommission + b.PromoDiscount),0) as 'Discount',
			isnull((B1.FlatDiscount + B1.IATACommission + B1.PLBCommission + b1.PromoDiscount),0) as 'DiscountR',
			B.RegistrationNumber,isnull(B.TotalMarkup,0) AS ServiceCharge,b.Country,B.ROE
			,isnull(b.MCOAmount,0) as 'MCOAmount'
			,isnull(b.TotalEarning,0) as 'TotalEarning'
			,isnull(b1.TotalEarning,0) AS TotalEarningR
			,Isnull(B.AgentROE,1) as AgentROE
			,isnull(B.AgentMarkup,0) as AgentMarkup
			,isnull(B11.B2BMarkup,0) as B2BMarkup
			,isnull(B11.B2bFareType,0) as B2bFareType
			,ISNULL(b.BFC,0) BFCAmount,ISNULL(b.GST,0) GST,ISNULL(b.ServiceFee,0) ServiceFee
			--ADDED BY BHAVIKA
			,ISNULL((Select SUM(SSR_Amount) from tblSSRDetails as ssr WITH(NOLOCK)
				Where ssr.fkBookMaster IN (Select pkid From tblBookMaster WITH(NOLOCK) where pkId = B1.pkId) and ssr.SSR_Type='Baggage'),0) as 'BaggageTotalR'
			,ISNULL((Select SUM(SSR_Amount) from tblSSRDetails as ssr WITH(NOLOCK) 
			Where ssr.fkBookMaster IN (Select pkid From tblBookMaster WITH(NOLOCK) where pkId = B1.pkId) and ssr.SSR_Type='Meals') ,0) as 'MealTotalR'

			FROM tblBookItenary T WITH(NOLOCK),tblBookMaster B WITH(NOLOCK)
				LEFT OUTER JOIN tblBookMaster B1 WITH(NOLOCK) ON B.orderId = B1.orderId AND B1.returnFlag = 1
				LEFT OUTER JOIN tblBookMaster B11 WITH(NOLOCK) ON B.orderId = B11.orderId AND B11.returnFlag 
= 0
				
				JOIN tblPassengerBookDetails P WITH(NOLOCK) ON P.fkBookMaster = B.pkId 
				LEFT OUTER JOIN tblPassengerBookDetails P1 WITH(NOLOCK) ON P1.fkBookMaster = B1.pkId

				JOIN Paymentmaster Pm WITH(NOLOCK)  ON Pm.order_id = B.orderId 
				LEFT OUTER JOIN  Paymentmaster Pm1 WITH(NOLOCK)  ON Pm1.order_id = B1.orderId
				
			WHERE B.orderId = @OrderId  --and i.airlinePNR is not null--AND B.IsBooked = 1



-- Passanger info
SELECT DISTINCT  isnull(P.paxFName,'') +' '+ P.paxLName AS Name
,
 P.ticketNum, I.airlinePNR, B.riyaPNR, P.isReturn, p.Iscancelled,
 DATEDIFF(hour,p.[dateOfBirth],GETDATE())/8766 AS Age, 
 isnull(p.B2BMarkup,0) as B2BMarkup ,isnull(p.Markup,0) as Markup
			 
 ,isnull(B.B2bFareType,0) as B2bFareType , -- added by 
p.paxType,(SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=b.pkId) as'GDSPNR'

--added by bhavika
, isnull((STUFF((SELECT '/ ' + SSR_Name from tblSSRDetails as ssr WITH(NOLOCK) Where ssr.fkPassengerid=p.pid and ssr.SSR_Type='Baggage' FOR XML PATH('')), 1, 1, '')),'') as 'BaggageDesc'
, isnull((STUFF((SELECT '/ ' + SSR_Name from tblSSRDetails as ssr WITH(NOLOCK) Where ssr.fkPassengerid=p.pid and ssr.SSR_Type='Meals' FOR XML PATH('')), 1, 1, '')),'') as 'MealDesc'
,p.BarCode
FROM tblPassengerBookDetails P WITH(NOLOCK) 
JOIN tblBookMaster B WITH(NOLOCK)  ON B.pkId = P.fkBookMaster
JOIN tblBookItenary I WITH(NOLOCK)  ON B.pkId = I.fkBookMaster
WHERE B.orderId = @OrderId 
and i.airlinePNR is not null--AND B.IsBooked = 1 
order by p.paxType,ticketNum

--SINGLE GET ITENENARY INFO
SELECT DISTINCT I.pkId, I.airCode, I.frmSector, I.toSector, I.fromAirport, I.toAirport,I.airName, I.isReturnJourney,I.insertedOn
,I.cabin,I.deptTime, I.arrivalTime, I.fromTerminal, i.toTerminal, i.flightNo,I.airlinePNR,I.riyaPNR as PNR
FROM tblBookItenary I WITH(NOLOCK) 
JOIN tblBookMaster B WITH(NOLOCK)  ON B.pkId = I.fkBookMaster
WHERE I.orderId =
 @OrderId	AND I.isReturnJourney = 0  and i.airlinePNR is not null --AND B.IsBooked = 1



--Return GET ITENENARY INFO

SELECT DISTINCT I.pkId, I.airCode, I.frmSector, I.toSector, I.fromAirport, I.toAirport,I.airName
,I.cabin,I.deptTime, I.arrivalTime, I.fromTerminal, i.toTerminal, i.flightNo,I.airlinePNR
FROM tblBookItenary I  WITH(NOLOCK) 
JOIN tblBookMaster B WITH(NOLOCK) ON B.pkId = I.fkBookMaster
WHERE I.orderId = @OrderId	AND I.isReturnJourney = 1  and i.airlinePNR is not null --



AND B.IsBooked = 1


select amount from Paymentmaster WITH(NOLOCK) where order_id=@OrderId



END
