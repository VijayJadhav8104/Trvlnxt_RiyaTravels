CREATE procedure [dbo].[RPT_RBTGroupWiseTransaction]                          
@FromDate Datetime,                                                
@Todate Datetime,                                                
@GroupId varchar(50)                            
as                                                
begin                                                
select        
inserteddate_old AS 'Booking Date'           
,IssueDate    as 'Issue Date'                                          
,Icast AS 'Customer Number'                             
,R.AgencyName as'Customer Name'                          
,LocationCode as 'Location Code'                                          
,B.riyaPNR AS 'MoBooking Number'                          
,CASE WHEN B.BookingStatus=1 THEN 'TKTT' ELSE 'RFND' END AS 'Transaction Type',                                                
'RBT' AS 'User type'                           
,B.GDSPNR AS 'GDS PNR'                          
,B.airCode AS 'Supplier Code'                        
,(select top 1 VendorCode from mVendorInterCompany where OfficeId = b.OfficeID and IsActive = 1 and AgencyCountry = (select CountryName from CountryMaster where CountryCode = b.Country)) as 'VendorNo'                        
--,b.Vendor_No AS 'VendorNo'                    
                    
,(Case when b.VendorName = 'Amadeus' and b.VendorName = 'Sabre' and b.VendorName = 'Galileo'                    
  then (Case when (LEN(Convert(varchar(3), AN.[AWB Prefix])) = 1)                         
  then '00' + ((Convert(varchar(3), AN.[AWB Prefix]))+'-'+ P.TicketNumber)                        
  when (LEN(Convert(varchar(3), AN.[AWB Prefix])) = 2)                         
  then '0' + ((Convert(varchar(3), AN.[AWB Prefix]))+'-'+ P.TicketNumber)                        
  else ((Convert(varchar(3), AN.[AWB Prefix]))+'-'+ P.TicketNumber) end) else P.TicketNumber end ) as 'Ticket Number'                          
                           
,P.paxType AS 'Pax Type'                                              
,P.paxFName AS 'First Name'                                             
,P.paxLName AS 'Last Name'                          
,b.AgentCurrency AS 'Currency Type'        
,(SELECT vc.Value FROM mVendorCredential vc WHERE vc.OfficeId=B.OfficeID and IsActive=1 and         
FieldName='currency' and VendorId=(SELECT ID FROM mVendor v WHERE v.VendorName=B.VendorName and IsActive=1 and IsDeleted=0)) AS 'Currency'    
,ROUND(cast(B.ROE AS decimal(18,5)),5) AS 'ROE'     
,ROUND( CAST(((P.basicFare+ISNULL(P.Markup,0)) * B.ROE) AS decimal(18,2)),2) AS BasicFare                          
,ROUND(Cast((P.YRTax * B.ROE) AS decimal(18,2)),2) AS YRTax                               
,ROUND(Cast((P.YQ * B.ROE) AS decimal(18,2)),2) AS YQTax                               
,ROUND(Cast((P.INTax * B.ROE) AS decimal(18,2)),2) AS INTax                               
,ROUND(Cast((P.JNTax * B.ROE) AS decimal(18,2)),2) AS JNTax                               
,ROUND(Cast((P.OCTax * B.ROE) AS decimal(18,2)),2) AS OCTax                               
,ROUND(Cast((P.YMTax * B.ROE) AS decimal(18,2)),2) AS YMTax                            
,ROUND(Cast((P.WOTax * B.ROE) AS decimal(18,2)),2) AS WOTax                               
,ROUND(Cast((P.OBTax * B.ROE) AS decimal(18,2)),2) AS OBTax                               
,ROUND(Cast((P.RFTax * B.ROE) AS decimal(18,2)),2) AS RFTax                               
,ROUND(Cast((P.ExtraTax * B.ROE) AS decimal(18,2)),2) AS XTTax                            
,ROUND( CAST(((P.totalTax) * B.ROE) AS decimal(18,2)),2) AS TaxTotal                          
--,0 as QTaxBase                          
,ROUND( CAST((((p.totalFare +ISNULL(p.Markup,0)) -p.serviceCharge) * b.ROE) AS decimal(18,2)),2) AS TotalFare                          
,(select sum(SSR_Amount) from tblSSRDetails s                                            
inner join tblPassengerBookDetails p1 on p1.pid=s.fkPassengerid                                            
inner join tblBookMaster b1 on b1.pkId=p1.fkBookMaster                                            
where (b.orderId=b1.orderId) and  SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0 and                  
paxFName + isnull(paxLName,'') in (select paxFName + isnull(paxLName,'')                          
from tblPassengerBookDetails where pid=p1.pid and pid = P.pid)                                            
group by paxFName + isnull(paxLName,''))                                              
as [Extra Baggage Amount],                           
(select sum(SSR_Amount) from tblSSRDetails s                                            
inner join tblPassengerBookDetails p1 on p1.pid=s.fkPassengerid                          
inner join tblBookMaster b1 on b1.pkId=p1.fkBookMaster                                            
where (b.orderId=b1.orderId) and  SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0 and                     
paxFName + isnull(paxLName,'') in (select paxFName + isnull(paxLName,'')                                            
from tblPassengerBookDetails where pid=p1.pid and pid = P.pid)                                            
group by paxFName + isnull(paxLName,''))                                             
as [Seat Preference Charge],                           
(select sum(SSR_Amount) from tblSSRDetails s                                         
inner join tblPassengerBookDetails p1 on p1.pid=s.fkPassengerid                                            
inner join tblBookMaster b1 on b1.pkId=p1.fkBookMaster                                            
where (b.orderId=b1.orderId) and  SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0 and                                            
paxFName + isnull(paxLName,'') in (select paxFName + isnull(paxLName,'')                                            
from tblPassengerBookDetails where pid=p1.pid and pid = P.pid)                        group by paxFName + isnull(paxLName,''))                                             
 as [Meal Charges]                          
,0 as [Wheel Chair Charges]                          
,0 as [SSR Comb Amount]                          
--,ROUND( CAST(( ((p.totalFare +ISNULL(p.Markup,0)) * b.ROE) + (p.GST +p.ServiceFee +p.B2bMarkup+p.BFC) - ((p.PLBCommission+p.IATACommission+p.DropnetCommission) * b.ROE)) AS decimal(18,2)),2) AS NetFare                          
, pm.payment_mode as FormofPayment                          
--,(CAST((ISNULL((CASE WHEN b.B2bFareType=1 THEN (p.B2BMarkup/ISNULL(b.AgentROE,0)) ELSE 0 END),0))AS decimal(18,2)) +p.BFC) AS MarkupOnFare                          
--, CAST((ISNULL((CASE WHEN ((b.B2bFareType=2 OR b.B2bFareType=3)) THEN ((p.B2BMarkup+p.HupAmount)/ISNULL(b.AgentROE,0)) ELSE p.HupAmount END),0))AS decimal(18,2)) AS MarkupOnTax                          
,CASE WHEN b.ServiceFee>0 THEN ISNULL(p.ServiceFee,0) ELSE 0 END AS ServiceCharge                          
--,0 as VendorServiceFee                          
--,0 as ManagementFee                          
,b.TourCode as TourCode                          
,STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WHERE I.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'Fare Basis'                          
,STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'Sector'                                                
,STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'Flight Number'                                                
,STUFF((SELECT '/' +  substring(I.cabin,0,2) FROM tblBookItenary I WHERE I.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'RBD'                                                
,STUFF((SELECT ',' + convert(varchar(11),s.depDate,103) FROM tblBookItenary s WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'Date of Travel'                                 
, CASE WHEN b.CounterCloseTime =1 THEN 'D' ELSE 'I' END AS BookingType      
,B.frmSector AS 'From City'                                          
,B.toSector AS 'To City'                          
--,P.CancellationPenalty AS [Penalty Amount]                    
--,p.CancellationMarkup as [Markup On Cancellation]                          
--,p.CancellationServiceFee as [Service Fee On Cancellation]                          
--,'' as [No Show Charge]                          
,'' as [No Show Airline]                          
--,A.EmpDimession AS [Employee Dimension Code]                            
,(select TR_POName From mAttrributesDetails A where A.fkPassengerid = p.pid) as [TR/PO No.]                          
,b.IATA AS [IATA Code]                           
,'' AS [Cancellation Type]                           
,(case when (select top 1 CLIQCID from PNRRetrivalFromAudit where GDSPNR = B.GDSPNR                           
and IsBookMasterInserted = '1' and OfficeID = B.OfficeID and R.Icast = ICust and TicketNumber = P.TicketNumber) = '228934' OR (select A.CLIQCID From mAttrributesDetails A where A.fkPassengerid = p.pid and A.CLIQCID ='228934') ='228934'                   
  
    
      
        
 then 'Concur' else 'Travel Next' end) AS [Booking Source Type]                          
                          
,'' AS [Tax YM]                           
,'' AS [Tax WO]                          
,STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'AIRLINE PNR'                           
,B.fromAirport AS [Departure Terminal]                                                
,B.toAirport AS [Arrival Terminal]                          
                          
,(case when counterclosetime=1 then 'Air-domestic' else 'Air-Int'end) AS 'Product Type'                          
                          
,(select top 1 UserName from mUser where ID = b.MainAgentId) as [User Name]                          
                          
, pm.payment_mode  as [Booking Mode]                          
                          
,r.BranchCode as BranchCode                          
--,b.ROE as AirlineROE                          
,(ISNULL(p.FlatDiscount,0) + ISNULL(p.DropnetCommission,0)) AS [Promo Discount Amount]                          
,p.MCOAmount as [MCO amount]                          
,p.MCOTicketNo as [MCO number]                          
,pm.CardType as [Card Type]                          
--,a.OBTCno as [OBTC No]                          
,(select A.Traveltype From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Travel Type]          
,(select A.Changedcostno From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Changed Cost Centre]           
,(select A.Travelduration From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Travel Duration]           
,(select A.RequestID From mAttrributesDetails A where A.fkPassengerid = p.pid) as[TAS Request Number]           
,(select A.Companycodecc From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Company code CC]          
,(select A.Projectcode From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Project Code]           
,(select A.EmpDimession From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Employee Number]           
,(select A.SwonNo From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Swon no]            
,(select A.Grade From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Grade]          
,(select A.TravelOfficer From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Travel Officer]           
,(select A.TravelRequestNumber From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Travel request number]          
,(select A.GDS From mAttrributesDetails A where A.fkPassengerid = p.pid) as[GDS]          
,(select A.TripType From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Trip Type]          
,(select A.OUNameIDF From mAttrributesDetails A where A.fkPassengerid = p.pid) as[OU Name]          
,(select A.CostCenter From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Cost Center]          
,(select A.BTANO From mAttrributesDetails A where A.fkPassengerid = p.pid) as[BTA NO]          
,(select A.FareType From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Fare Type]          
,(select A.FareRule From mAttrributesDetails A where A.fkPassengerid = p.pid) as[Fare Rule]   

-- CITIUSTECH INC
,(select A.ConcurID From mAttrributesDetails A where A.fkPassengerid = p.pid) as [Concur ID]    
,(select A.DEVIATIONAPPROVER From mAttrributesDetails A where A.fkPassengerid = p.pid) as [DEVIATION APPROVER] 
,(select A.EMPLOYEESPOSITION From mAttrributesDetails A where A.fkPassengerid = p.pid) as [EMPLOYEES POSITION BILLIABLE TO CLIENT] 
,(select A.TRAVELCOSTREIMBURSABLE From mAttrributesDetails A where A.fkPassengerid = p.pid) as [TRAVEL COST REIMBURSABLE BY CLIENT] 

--Mastek Inc
,(select A.CostCentre From mAttrributesDetails A where A.fkPassengerid = p.pid) as [Cost Centre] 

--HEXAWARE TECHNOLOGIES UK LTD , Hexaware Technologies Inc
,(select A.Vertical From mAttrributesDetails A where A.fkPassengerid = p.pid) as [Vertical] 

--TATA America International Corporation
,(select A.GESSRECEIVEDDATE From mAttrributesDetails A where A.fkPassengerid = p.pid) as [GESS-RECEIVED-DATE]
,(select A.TicketType From mAttrributesDetails A where A.fkPassengerid = p.pid) as [TicketType] 
,(select A.EmpIDTRAVELOFFICER From mAttrributesDetails A where A.fkPassengerid = p.pid) as [EmpID-TRAVEL-OFFICER] 

,pm.AuthCode as [Card Approval Code]                          
--,p.MCOMerchantfee as [MCO Merchant fee]                          
,p.DropnetCommission as [Dropnet Commission]                   
,R.country                  
                          
from tblBookMaster B                          
INNER JOIN tblPassengerBookDetails P ON P.fkBookMaster=B.pkId                        
INNER JOIN B2BRegistration R ON R.FKUserID=B.AgentID                        
inner join Paymentmaster pm on pm.order_id=b.orderId                         
--INNER JOIN mcountrycurrency C ON C.CountryCode=B.Country                                                
--left join mAttrributesDetails A ON A.OrderID=B.orderId                                      
left join agentLogin AL ON AL.UserID=b.AgentID                        
left join AirlinesName as AN with (NOLOCK) on _CODE = B.ValidatingCarrier                        
                         
WHERE B.AgentID!='B2C'                           
AND IsBooked=1                           
AND B.BookingStatus IN (1,4,11)                                                
--and CONVERT(date,b.IssueDate)=CONVERT(date, @FromDate)                       
--and AL.userTypeID = 5 and B.Country = 'IN' --RBT IN Data                    
and CONVERT(date,b.IssueDate) >= CONVERT(date, @FromDate) and CONVERT(date,b.IssueDate) <= CONVERT(date, @Todate)            
and B.totalFare > 0                
and  AL.GroupId =@GroupId                         
                    
ORDER BY B.inserteddate DESC                                                
                                                
end 