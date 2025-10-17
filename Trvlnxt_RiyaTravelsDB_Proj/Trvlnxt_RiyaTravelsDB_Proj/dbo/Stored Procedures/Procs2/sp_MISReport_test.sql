CREATE procedure [dbo].[sp_MISReport_test]      
@FromDate Datetime,      
@Todate Datetime,      
@AgentID varchar(50)      
as      
begin      
select      
IssueDate    as 'Issue Date'
,Icast AS 'Customer Number'
,LocationCode as 'Location Code'
,B.riyaPNR AS 'MoBooking Number'
,B.GDSPNR AS 'GDS PNR'
,P.TicketNumber   AS 'Ticket Number' 
,STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'AIRLINE PNR'
,CASE WHEN B.BookingStatus=1 THEN 'TKTT' ELSE 'RFND' END AS 'Transaction Type',      
'RBT' AS [Customer-Id]    
,B.airCode AS 'Supplier Code'       
,P.paxType AS 'Pax Type'    
,P.paxFName AS 'First Name'   
,P.paxLName AS 'Last Name'
,C.CurrencyCode AS 'Currency Type'
,P.basicFare AS 'Basic Fare'
, P.YRTax    
,P.YQ AS YQTax    
, P.INTax    
,P.JNTax    
,P.OCTax    
,P.YMTax    
,P.WOTax    
,P.OBTax    
,P.RFTax    
,P.ExtraTax as XTTax     
,P.totalTax as 'Total Tax'
,(select sum(SSR_Amount) from tblSSRDetails s  
inner join tblPassengerBookDetails p1 on p1.pid=s.fkPassengerid  
inner join tblBookMaster b1 on b1.pkId=p1.fkBookMaster  
where (b.orderId=b1.orderId) and  SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0 and  
paxFName + isnull(paxLName,'') in (select paxFName + isnull(paxLName,'')  
from tblPassengerBookDetails where pid=p1.pid)  
group by paxFName + isnull(paxLName,''))    
as [Extra Baggage Amount],      
(select sum(SSR_Amount) from tblSSRDetails s  
inner join tblPassengerBookDetails p1 on p1.pid=s.fkPassengerid  
inner join tblBookMaster b1 on b1.pkId=p1.fkBookMaster  
where (b.orderId=b1.orderId) and  SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0 and  
paxFName + isnull(paxLName,'') in (select paxFName + isnull(paxLName,'')  
from tblPassengerBookDetails where pid=p1.pid)  
group by paxFName + isnull(paxLName,''))   
as [Seat Preference Charge],      
(select sum(SSR_Amount) from tblSSRDetails s  
inner join tblPassengerBookDetails p1 on p1.pid=s.fkPassengerid  
inner join tblBookMaster b1 on b1.pkId=p1.fkBookMaster  
where (b.orderId=b1.orderId) and  SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0 and  
paxFName + isnull(paxLName,'') in (select paxFName + isnull(paxLName,'')  
from tblPassengerBookDetails where pid=p1.pid)  
group by paxFName + isnull(paxLName,''))   
 as [Meal Charges],   
isnull(p.IATACommission,0) + isnull(p.PLBCommission,0) +  isnull(p.DropnetCommission,0) AS Discount    
,p.totalFare AS 'Total Fare'      
,STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WHERE I.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'Fare Basis'      
,STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'Sector'      
,STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'Flight Number'      
,STUFF((SELECT '/' +  substring(I.cabin,0,2) FROM tblBookItenary I WHERE I.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'RBD'      
,STUFF((SELECT ',' + convert(varchar(11),s.depDate,103) FROM tblBookItenary s WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'Date of Travel'      
,STUFF((SELECT ',' + convert(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS [Travel End Date]      
,(case when counterclosetime=1 then 'Air-domestic' else 'Air-Int'end) AS 'Product Type'      
,B.frmSector AS 'From City'
,B.toSector AS 'To City'    
,P.CancellationPenalty AS [Penalty Amount]      
,A.TR_POName [TR/PO No.]    
,'Travel Next' AS [Booking Source Type]      
,B.fromAirport AS [Departure Terminal]      
,B.toAirport AS [Arrival Terminal]      
,B.FareType as 'Fare Type'       
,CASE WHEN P.isReturn=0 THEN 'One Way' ELSE 'Return' END AS [Trip Type]     
,A.CostCenter AS [Cost Center]    
,A.Traveltype AS [Travel Type]    
,A.EmpDimession AS [Employee Code]     
,A.Changedcostno AS [Changed Cost Centre]    
, A.Travelduration AS [Travel Duration]    
,A.TASreqno AS [TAS Request Number]    
,A.Companycodecc AS [Company code CC/entity name]      
,A.Projectcode AS [Project Code]    
,A.DEVIATION_APPROVER_NAME_AND_EMPCODE AS [DEVIATION APPROVER NAME AND EMP CODE]      
,A.LOWEST_LOGICAL_FARE_1 AS [LOWEST LOGICAL FARE1]    
,A.LOWEST_LOGICAL_FARE_2 AS [LOWEST LOGICAL FARE2]     
,A.LOWEST_LOGICAL_FARE_3 AS [LOWEST LOGICAL FARE3]      
from tblBookMaster B      
INNER JOIN B2BRegistration R ON R.FKUserID=B.AgentID      
INNER JOIN tblPassengerBookDetails P ON P.fkBookMaster=B.pkId      
INNER JOIN mcountrycurrency C ON C.CountryCode=B.Country      
INNER JOIN mAttrributesDetails A ON A.OrderID=B.orderId      
WHERE B.AgentID!='B2C' AND IsBooked=1 AND B.BookingStatus IN (1,4,11)      
and b.IssueDate >= @FromDate and b.IssueDate <= @Todate and  b.AgentID =@AgentID      
ORDER BY B.inserteddate DESC      
      
end      
      
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_MISReport_test] TO [rt_read]
    AS [dbo];

