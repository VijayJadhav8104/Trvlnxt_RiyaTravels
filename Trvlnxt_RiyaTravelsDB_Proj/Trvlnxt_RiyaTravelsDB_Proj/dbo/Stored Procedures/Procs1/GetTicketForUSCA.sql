  
--------------------------------------------------------------  
  
  
CREATE PROCEDURE [dbo].[GetTicketForUSCA]  
@OrderId   varchar(30) = NULL,  
@RiyaPNR   varchar(20) = NULL  
AS BEGIN  
  
IF(@OrderId IS NULL)  
BEGIN  
SELECT @OrderId = orderId FROM tblBookMaster with (nolock) WHERE riyaPNR = @RiyaPNR  
END  
--  Other Info  
  
SELECT TOP 1    
   b.emailId AS emailId,   
   B.mobileNo,  
   isnull(P.paxFName,'') +' '+ P.paxLName AS Name,   
   P.inserteddate AS BookingDate,   
   B.CounterCloseTime,   
   B.totalFare+ isnull(b.TotalMarkup,0) as totalFare,   
   B.totalTax,   
   B.basicFare,   
   B.deptTime,   
   b.fromTerminal,  
   B.frmSector+'/'+B.toSector as SectorName,  
   B.airCode +'-'+B.flightNo as FlightNo,  
   isnull(B.TotalMarkup,0) as ServiceCharge,  
   B.basicFare as Base,   
   B.deptTime as DateofTravel,   
   B.riyaPNR as PNR,   
   B.taxDesc as taxDesc,  
   SUBSTRING(T.cabin,1,1) as Class,  
   b.totalTax as totalTax,  
   P.ticketNum as ticketNum,  
   b.fromAirport,   
   P.baggage,  
   B1.totalFare + isnull(B1.TotalMarkup,0) AS totalFareR,   
   B1.totalTax AS totalTaxR,   
   B1.basicFare AS basicFareR,  
   B1.deptTime AS deptTimeR,  
   P1.baggage AS baggageR,   
   B1.fromTerminal as fromTerminalR,   
   B1.fromAirport fromAirportR,b.orderId,  
   isnull((b.FlatDiscount + b.IATACommission + b.PLBCommission + b.PromoDiscount),0) as 'Discount',  
   isnull((B1.FlatDiscount + B1.IATACommission + B1.PLBCommission),0) as 'DiscountR',  
   B.RegistrationNumber,isnull(B.TotalMarkup,0) AS ServiceCharge,b.Country,B.ROE,b.MCOAmount,b.TotalEarning,b1.TotalEarning AS TotalEarningR  
    ,Isnull(B.AgentROE,1) as AgentROE  
     ,isnull(B.AgentMarkup,0) as AgentMarkup  
     
    ,isnull(B11.B2BMarkup,0) as B2BMarkup  
    ,isnull(B11.B2bFareType,0) as B2bFareType  
   ,ISNULL(b.BFC,0) BFCAmount,ISNULL(b.GST,0) GST,ISNULL(b.ServiceFee,0) ServiceFee       
   FROM tblBookItenary T with (nolock),tblBookMaster B with (nolock)  
    LEFT OUTER JOIN tblBookMaster B1 with (nolock) ON B.orderId = B1.orderId AND B1.returnFlag = 1  
    LEFT OUTER JOIN tblBookMaster B11 with (nolock) ON B.orderId = B11.orderId AND B11.returnFlag = 0  
      
    JOIN tblPassengerBookDetails P with (nolock) ON P.fkBookMaster = B.pkId   
    LEFT OUTER JOIN tblPassengerBookDetails P1 with (nolock) ON P1.fkBookMaster = B1.pkId  
    left join agentLogin AL with (nolock) ON CAST(AL.UserID AS VARCHAR)=B.AgentID  
   WHERE B.orderId = @OrderId   
-- Passanger info  
SELECT DISTINCT  isnull(P.paxFName,'') +' '+ P.paxLName AS Name, P.ticketNum, I.airlinePNR, B.riyaPNR, P.isReturn,   
p.Iscancelled,  
 DATEDIFF(hour,p.[dateOfBirth],GETDATE())/8766 AS Age,   -- added by ashvini  
p.paxType,b.GDSPNR ,isnull(P.B2BMarkup,0) as B2BMarkup,isnull(B.B2bFareType,0) as B2bFareType,  
 isnull(p.Markup,0) as Markup  ,p.BarCode
FROM tblPassengerBookDetails P with (nolock) 
JOIN tblBookMaster B with (nolock)ON B.pkId = P.fkBookMaster  
JOIN tblBookItenary I with (nolock) ON B.pkId = I.fkBookMaster  
WHERE B.orderId = @OrderId  
order by p.paxType  
  
--SINGLE GET ITENENARY INFO  
SELECT DISTINCT I.pkId, I.airCode, I.frmSector, I.toSector, I.fromAirport, I.toAirport,I.airName, I.isReturnJourney,I.insertedOn  
,I.cabin,I.deptTime, I.arrivalTime, I.fromTerminal, i.toTerminal, i.flightNo,I.airlinePNR  
FROM tblBookItenary I with (nolock) 
JOIN tblBookMaster B with (nolock) ON B.pkId = I.fkBookMaster  
WHERE I.orderId = @OrderId AND I.isReturnJourney = 0   
  
  
  
--Return GET ITENENARY INFO  
  
SELECT DISTINCT I.pkId, I.airCode, I.frmSector, I.toSector, I.fromAirport, I.toAirport,I.airName  
,I.cabin,I.deptTime, I.arrivalTime, I.fromTerminal, i.toTerminal, i.flightNo,I.airlinePNR  
FROM tblBookItenary I with (nolock)  
JOIN tblBookMaster B with (nolock) ON B.pkId = I.fkBookMaster  
WHERE I.orderId = @OrderId AND I.isReturnJourney = 1   
  
  
select amount from Paymentmaster with (nolock) where order_id=@OrderId
  
  
  
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetTicketForUSCA] TO [rt_read]
    AS [dbo];

