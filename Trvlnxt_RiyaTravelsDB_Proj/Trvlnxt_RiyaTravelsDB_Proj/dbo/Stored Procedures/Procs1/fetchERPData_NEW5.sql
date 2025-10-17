create procedure [dbo].[fetchERPData_NEW5] --fetchERPData_NEW2 '31-dec-2020','31-dec-2020',1,3,'ae','2',''
@frmDate datetime=null,
@toDate datetime=null,
@status tinyint,
@Userid int=null,
@country varchar(2)=null,
@usertype varchar(5)=null,
@agentid  varchar(50)
as
BEGIN

if(@usertype='1')
BEGIN
IF(@status=1)--status-Ticketed
BEGIN
select * into #temp from
(
SELECT t.orderId, 
STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS AIRPNR,
STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
STUFF((SELECT ',' + convert(varchar(11),s.depDate,103)+','+convert(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis,
STUFF((SELECT '/' + I.airlinePNR FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS airlinePNR,
STUFF((SELECT '/' +  substring(I.cabin,0,2) FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS rbd

FROM tblBookItenary AS t GROUP BY t.orderId) X
select pid, 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'ICUST35086' AS CustomerNumber,'BOMRC' LocationCode,
'TKTT' TransactionType,'B2C' AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,
(case WHEN p.OfficeID='DFW1S212A' THEN 'USD' WHEN p.OfficeID='YWGC4211G' THEN 'CAD' else 'INR' END) AS CurrencyType,
p.BasicFare,p.YQTax,0 as [OC tax],p.TaxTotal,p.QTaxBase,
p.TotalFare,	IataCommissionC,''	AdditionalCommissionC, PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare,'CASH' as FormofPayment,
''	MarkupOnFare,	MarkupOnTax, p.ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

''	Penalty ,''  as	[MarkupOnCancellation],''	as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
[Employee Dimension Code],p.promoCode as [TR/PO No.],''	[Card Type],	[IATA Code],''	[Contact No.],''[Cancellation Type],
'B2C' as [Booking Source Type],''[BTA Sales],''	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,p.YrTax,p.XTTax,p.JNTax,p.OCTax,p.INTax ,p.airCode	,
--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) as supplierCode,
--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) as VendorNo,
REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') as supplierCode,
case when p.Vendor_No is not null then LEFT(p.Vendor_No, CHARINDEX('-', p.Vendor_No)-1) else(case WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode1 FROM TblSTSAirLineMaster) then 'RABO
M0300004' ELSE '' END) end  as VendorNo,
PaxType, '' FromCity,'' ToCity,airlinePNR,rbd,
'' AS 'CRS',
 p.fromAirport,p.toAirport,p.equipment,'' as baggage,FlyingHour,ProductType,'PRD100101' AS ProductCode,
 'BOMRC' BranchCode,'' [Emp Code],
 b.RegistrationNumber,b.CompanyName,b.CAddress,b.CState,b.CContactNo,b.CEmailID
 ,JobCodeBookingGivenBy, VesselName, ReasonofTravel, TravelRequestNumber, CostCenter, BudgetCode, EmpDimession, SwonNo, TravelerType, Location, Department, Grade, ma.Bookedby, Designation, Chargeability, NameofApprover, ReferenceNo, TR_POName, RankNo, AType, BookingReceivedDate,
 P.ROE,P.AgentROE

FROM

(select pax.pid, book.riyaPNR,book.GDSPNR,book.inserteddate IssueDate, book.GDSPNR as PNR, book.airCode,
max(ticketNum) ticket1,min(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
sum(pax.basicFare) as	BasicFare	,sum(pax.totalTax) TaxTotal,
0	QTaxBase	,sum(pax.totalFare-pax.serviceCharge)  as TotalFare,
sum(convert(float,[YQ])) as YQTax,max([CounterCloseTime]) as bookType,
max(#temp.Sector)  as sector,max(book.airCode) as code,
max(pmt.payment_mode) as mode,max(flightNo) as filght,
max(#temp.AIRPNR) as air, max(#temp.Class) as class, 
max(#temp.flight) as Flight,max(#temp.farebasis) as farebasis,
sum(isnull(pax.[YRTax],0)) as YrTax,sum(isnull(pax.[INTax],0)) as INTax,
sum(isnull(pax.[JNTax],0) )as JNTax,sum(isnull(pax.[OCTax],0)) as OCTax,
sum(isnull(pax.[ExtraTax],0) )as XTTax,--sum(isnull(pax.serviceCharge,0) )as ServiceCharge,
isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
max(#temp.travel) as travelDate, (isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2))) as PlbC, 
pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,promoCode,
#temp.airlinePNR,#temp.rbd,book.fromAirport,book.toAirport,book.equipment,
datediff(hour,book.deptTime,book.arrivalTime) as 'FlyingHour',
(case when counterclosetime=1 then 'Air-domestic' else 'Air-Int'end) AS 'ProductType',
'' as [Employee Dimension Code],
(case when OfficeID ='DFW1S212A' THEN '45828661' when OfficeID ='YWGC4211G' THEN '62500082' when OfficeID ='BOMVS34AD' THEN '14369644' when OfficeID ='BOMI228DS' THEN '14360102'
when OfficeID ='DXBAD3359' THEN '86215290' when OfficeID ='NYC1S21E9' THEN '33750021' ELSE '' END) AS [IATA Code],ROE,AgentROE
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId
--left join tblBookItenary bi on bi.orderId=book.orderId
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join UserLogin ul on ul.UserID=book.LoginEmailID
left join  #temp on pmt.order_id=#temp.orderId	where book.IsBooked=1 AND book.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,book.inserteddate) >=convert(date,@frmDate) and convert(date,book.inserteddate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) AND book.Agentid='B2C' and book.Country=@country
group by book.riyaPNR,book.GDSPNR,book.inserteddate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,pid,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge,
OfficeID,ROE,promoCode,pax.Markup,book.SupplierCode,book.Vendor_No,book.Country,
airlinePNR,rbd,book.airCode,book.fromAirport,book.toAirport,book.equipment,book.deptTime,book.arrivalTime,book.frmSector,book.toSector,book.counterclosetime,ul.UserName
,ROE,AgentROE
)p 
left join mAttrributesDetails MA ON MA.GDSPNR=p.GDSPNR
inner join tblBookMaster B on b.GDSPNR=p.GDSPNR
order by inserteddate
drop table #temp
END

ELSE IF(@status=2)--status-REFUNDED
BEGIN
select * into #temp1 from
(
SELECT t.orderId, 
STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS AIRPNR,
STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
STUFF((SELECT ',' + convert(varchar(11),s.depDate,103)+','+convert(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis,
STUFF((SELECT '/' + I.airlinePNR FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS airlinePNR,
STUFF((SELECT '/' +  substring(I.cabin,0,2) FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS rbd
FROM tblBookItenary AS t GROUP BY t.orderId) X
select 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
'RFND' TransactionType,'B2C' AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,(case WHEN p.OfficeID='DFW1S212A' THEN 'USD' WHEN p.OfficeID='YWGC4211G' THEN 'CAD' else 'INR' END) AS CurrencyType,(0-p.BasicFare) as BasicFare,(0-p.YQTax) as YQTax ,0 as [OC tax],
(0-p.TaxTotal) as TaxTotal,(0-p.QTaxBase) as QTaxBase,(0-p.TotalFare) as TotalFare,
IataCommissionC,''	AdditionalCommissionC,PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare,'CASH' as FormofPayment,
''	MarkupOnFare, (0-p.ServiceCharge)	MarkupOnTax, 0 as ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

Penalty ,MarkupOnCancellation,''	as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
''	[Employee Dimension Code],p.PromoCode as [TR/PO No.],''	[Card Type],''	[IATA Code],''	[Contact No.],''[Cancellation Type],
'B2C' as [Booking Source Type],''[BTA Sales],''	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,(0-p.YrTax) as YrTax,(0-p.XTTax) as XTTax,(0-p.JNTax) as JNTax,(0-p.OCTax) as OCTax,(0-p.INTax) as INTax ,p.airCode	,
--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) as supplierCode,
--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) as VendorNo,
REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') as supplierCode,
case when p.Vendor_No is not null then LEFT(p.Vendor_No, CHARINDEX('-', p.Vendor_No)-1) 
else(case WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode1 FROM TblSTSAirLineMaster) then 'RABOM0300004' ELSE '' END) end  as VendorNo,
--REPLACE((CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) 
 --WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' ELSE 'VEND000180' END),'?','') as VendorNo,
PaxType, '' FromCity,'' ToCity,p.orderId,isReturn,'' AS 'CRS',p.fromAirport,p.toAirport,p.equipment,'' as baggage,FlyingHour,ProductType,'PRD100101' AS ProductCode,
 '' BranchCode,'' [Emp Code],
 b.RegistrationNumber,b.CompanyName,b.CAddress,b.CState,b.CContactNo,b.CEmailID
 ,JobCodeBookingGivenBy, VesselName, ReasonofTravel, TravelRequestNumber, CostCenter, BudgetCode, EmpDimession, SwonNo, TravelerType, Location, Department, Grade, ma.Bookedby, Designation, Chargeability, NameofApprover, ReferenceNo, TR_POName, RankNo, AType, BookingReceivedDate
 ,P.ROE,P.AgentROE
FROM

(select book.riyaPNR,book.GDSPNR,pax.CancelledDate IssueDate, book.GDSPNR as PNR, book.airCode,
max(ticketNum) ticket1,min(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
sum(pax.basicFare) as	BasicFare	,sum(pax.totalTax) TaxTotal,
0	QTaxBase	,sum(pax.totalFare-pax.serviceCharge)  as TotalFare,
sum(convert(float,[YQ])) as YQTax,max([CounterCloseTime]) as bookType,
max(#temp1.Sector)  as sector,max(book.airCode) as code,
max(pmt.payment_mode) as mode,max(flightNo) as filght,
max(#temp1.AIRPNR) as air, max(#temp1.Class) as class, 
max(#temp1.flight) as Flight,max(#temp1.farebasis) as farebasis,
sum(isnull(pax.[YRTax],0)) as YrTax,sum(isnull(pax.[INTax],0)) as INTax,
sum(isnull(pax.[JNTax],0) )as JNTax,sum(isnull(pax.[OCTax],0)) as OCTax,
sum(isnull(pax.[ExtraTax],0) )as XTTax,isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
max(#temp1.travel) as travelDate,ch.Panelty as Penalty,ch.CancellationCharge as 'MarkupOnCancellation',
book.orderId,pax.isReturn,(0-(isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2)))) as PlbC, 
pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,PromoCode,
#temp1.airlinePNR,#temp1.rbd,book.fromAirport,book.toAirport,book.equipment,
datediff(hour,book.deptTime,book.arrivalTime) as 'FlyingHour',
(case when counterclosetime=1 then 'Air-domestic' else 'Air-Int'end) AS 'ProductType',
'' as [Employee Dimension Code],ROE,AgentROE
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join UserLogin ul on ul.UserID=book.LoginEmailID
left join  #temp1 on pmt.order_id=#temp1.orderId	
inner join CancellationHistory Ch on ch.OrderId=book.orderId and FlagType=2
where pax.IsRefunded=1 and book.IsBooked=1  AND book.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,pax.RefundedDate) >=convert(date,@frmDate) and convert(date,pax.RefundedDate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) AND book.Agentid='B2C' and book.Country=@country
group by book.riyaPNR,book.GDSPNR,pax.CancelledDate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,ch.RefundAmount,ch.CancellationCharge,
book.orderId,isReturn,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge, ch.Panelty,pax.Markup
,book.SupplierCode,book.Vendor_No,book.Country,OfficeID,ROE,PromoCode,airlinePNR,rbd, book.fromAirport,book.toAirport,book.equipment,book.deptTime,book.arrivalTime,book.frmSector,book.toSector,book.counterclosetime,ul.UserName
,ROE,AgentROE)p 
left join mAttrributesDetails MA ON MA.GDSPNR=p.GDSPNR
inner join tblBookMaster B on b.GDSPNR=p.GDSPNR
order by inserteddate
drop table #temp1
END

--status 3 Pre refund

ELSE IF(@status=3)--Pre refund
BEGIN
select * into #temp2 from
(
SELECT t.orderId, 
STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS AIRPNR,
STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
STUFF((SELECT ',' + convert(varchar(11),s.depDate,103)+','+convert(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis,
STUFF((SELECT '/' + I.airlinePNR FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS airlinePNR,
STUFF((SELECT '/' +  substring(I.cabin,0,2) FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS rbd
FROM tblBookItenary AS t GROUP BY t.orderId) X
select 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
'RFND' TransactionType,'B2C' AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,(case WHEN p.OfficeID='DFW1S212A' THEN 'USD' WHEN p.OfficeID='YWGC4211G' THEN 'CAD' else 'INR' END) AS CurrencyType,(0-p.BasicFare) as BasicFare,(0-p.YQTax) as YQTax ,0 as [OC tax],
(0-p.TaxTotal) as TaxTotal,(0-p.QTaxBase) as QTaxBase,(0-p.TotalFare) as TotalFare,
IataCommissionC,''	AdditionalCommissionC,PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare,'CASH' as FormofPayment,
''	MarkupOnFare, (0-p.ServiceCharge)	MarkupOnTax, 0 as ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

Penalty ,MarkupOnCancellation,''	as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
''	[Employee Dimension Code],''[TR/PO No.],''	[Card Type],''	[IATA Code],''	[Contact No.],''[Cancellation Type],
'B2C' as [Booking Source Type],''[BTA Sales],''	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,(0-p.YrTax) as YrTax,(0-p.XTTax) as XTTax,(0-p.JNTax) as JNTax,(0-p.OCTax) as OCTax,(0-p.INTax) as INTax ,p.airCode	,
--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) as supplierCode,
--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) as VendorNo,
REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') as supplierCode,
--REPLACE((CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) 
-- WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' ELSE 'VEND000180' END),'?','') as VendorNo,
case when p.Vendor_No is not null then LEFT(p.Vendor_No, CHARINDEX('-', p.Vendor_No)-1) else(case WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' 
WHEN P.airCode  in (SELECT AirlineCode1 FROM TblSTSAirLineMaster) then 'RABOM0300004' ELSE '' END) end  as VendorNo,
PaxType, '' FromCity,'' ToCity,p.orderId,isReturn,airlinePNR,rbd,
'' AS 'CRS',
 p.fromAirport,p.toAirport,p.equipment,'' as baggage,FlyingHour,ProductType,'PRD100101' AS ProductCode,
 'BOMRC' BranchCode,'' [Emp Code],
 b.RegistrationNumber,b.CompanyName,b.CAddress,b.CState,b.CContactNo,b.CEmailID
 ,JobCodeBookingGivenBy, VesselName, ReasonofTravel, TravelRequestNumber, CostCenter, BudgetCode, EmpDimession, SwonNo, TravelerType, Location, Department, Grade, ma.Bookedby, Designation, Chargeability, NameofApprover, ReferenceNo, TR_POName, RankNo, AType, BookingReceivedDate
 ,P.ROE,P.AgentROE
FROM

(select book.riyaPNR,book.GDSPNR,pax.CancelledDate IssueDate, book.GDSPNR as PNR, book.airCode,
max(ticketNum) ticket1,min(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
(pax.basicFare) as	BasicFare	,(pax.totalTax) TaxTotal,
0	QTaxBase	,(pax.totalFare-pax.serviceCharge)  as TotalFare,
(convert(float,[YQ])) as YQTax,max([CounterCloseTime]) as bookType,
max(#temp2.Sector)  as sector,max(book.airCode) as code,
max(pmt.payment_mode) as mode,max(flightNo) as filght,
max(#temp2.AIRPNR) as air, max(#temp2.Class) as class, 
max(#temp2.flight) as Flight,max(#temp2.farebasis) as farebasis,
(isnull(pax.[YRTax],0)) as YrTax,(isnull(pax.[INTax],0)) as INTax,
(isnull(pax.[JNTax],0) )as JNTax,(isnull(pax.[OCTax],0)) as OCTax,
(isnull(pax.[ExtraTax],0) )as XTTax,isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
max(#temp2.travel) as travelDate,ch.Panelty as Penalty,ch.CancellationCharge as 'MarkupOnCancellation',
book.orderId,pax.isReturn,(0-(isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2)))) as PlbC, 
pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,
#temp2.airlinePNR,#temp2.rbd,book.fromAirport,book.toAirport,book.equipment,
datediff(hour,book.deptTime,book.arrivalTime) as 'FlyingHour',
(case when counterclosetime=1 then 'Air-domestic' else 'Air-Int'end) AS 'ProductType',
'' as [Employee Dimension Code],
(case when OfficeID ='DFW1S212A' THEN '45828661' when OfficeID ='YWGC4211G' THEN '62500082' when OfficeID ='BOMVS34AD' THEN '14369644' when OfficeID ='BOMI228DS' THEN '14360102'
when OfficeID ='DXBAD3359' THEN '86215290' when OfficeID ='NYC1S21E9' THEN '33750021' ELSE '' END) AS [IATA Code]
,ROE,AgentROE from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join UserLogin ul on ul.UserID=book.LoginEmailID
left join  #temp2 on pmt.order_id=#temp2.orderId	
inner join CancellationHistory Ch on ch.OrderId=book.orderId and FlagType=1
--where pax.IsRefunded=1 and book.IsBooked=1
where pax.IsCancelled=0 and pax.isProcessRefund=1 AND  book.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,ch.UpdateDate) >=convert(date,@frmDate) and convert(date,ch.UpdateDate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) AND book.Agentid='B2C' and book.Country=@country
group by book.riyaPNR,book.GDSPNR,pax.CancelledDate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,ch.RefundAmount,ch.CancellationCharge,
book.orderId,isReturn,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge, ch.Panelty,pax.Markup
,book.SupplierCode,book.Vendor_No,pax.basicFare,pax.totalTax,pax.totalFare,pax.YQ,pax.YRTax,pax.INTax,pax.JNTax,pax.OCTax,pax.ExtraTax,book.Country,OfficeID,ROE,
airlinePNR,rbd,book.airCode,book.fromAirport,book.toAirport,book.equipment,book.deptTime,book.arrivalTime,book.frmSector,book.toSector,book.counterclosetime,ul.UserName
,ROE,AgentROE)p 
left join mAttrributesDetails MA ON MA.GDSPNR=p.GDSPNR
inner join tblBookMaster B on b.GDSPNR=p.GDSPNR
order by inserteddate
drop table #temp2
  END

  else IF(@status=4)--status-PromoCode
BEGIN
select * into #temp4 from
(
SELECT t.orderId, 
STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS AIRPNR,
STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
STUFF((SELECT ',' + convert(varchar(11),s.depDate,103)+','+convert(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis
FROM tblBookItenary AS t GROUP BY t.orderId) X
select pid, 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
'TKTT' TransactionType,'B2C' AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,(case WHEN OfficeID='DFW1S212A' THEN 'USD' WHEN OfficeID='YWGC4211G' THEN 'CAD' else 'INR' END) AS CurrencyType,p.BasicFare,p.YQTax,0 as [OC tax],p.TaxTotal,p.QTaxBase,
p.TotalFare,	IataCommissionC,''	AdditionalCommissionC, PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare,'CASH' as FormofPayment,
''	MarkupOnFare,	MarkupOnTax, ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

''	Penalty ,''  as	[MarkupOnCancellation],''	as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
''	[Employee Dimension Code],''[TR/PO No.],''	[Card Type],''	[IATA Code],''	[Contact No.],''[Cancellation Type],
'B2C' as [Booking Source Type],''[BTA Sales],''	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,p.YrTax,p.XTTax,p.JNTax,p.OCTax,p.INTax ,p.airCode	,
--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) as supplierCode,
--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) as VendorNo,
REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') as supplierCode,
--REPLACE((CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) 
 --WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' ELSE 'VEND000180' END),'?','') as VendorNo,
case when Vendor_No is not null then LEFT(Vendor_No, CHARINDEX('-', Vendor_No)-1) else(case WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode1 FROM TblSTSAirLineMaster) then 'RAB
OM0300004' ELSE '' END) end  as VendorNo,
PaxType, '' FromCity,'' ToCity,promoCode,P.ROE,P.AgentROE

FROM

(select pax.pid, book.riyaPNR,book.GDSPNR,book.inserteddate IssueDate, book.GDSPNR as PNR, book.airCode,
max(ticketNum) ticket1,min(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
sum(pax.basicFare) as	BasicFare	,sum(pax.totalTax) TaxTotal,
0	QTaxBase	,sum(pax.totalFare-pax.serviceCharge)  as TotalFare,
sum(convert(float,[YQ])) as YQTax,max([CounterCloseTime]) as bookType,
max(#temp4.Sector)  as sector,max(book.airCode) as code,
max(pmt.payment_mode) as mode,max(flightNo) as filght,
max(#temp4.AIRPNR) as air, max(#temp4.Class) as class, 
max(#temp4.flight) as Flight,max(#temp4.farebasis) as farebasis,
sum(isnull(pax.[YRTax],0)) as YrTax,sum(isnull(pax.[INTax],0)) as INTax,
sum(isnull(pax.[JNTax],0) )as JNTax,sum(isnull(pax.[OCTax],0)) as OCTax,
sum(isnull(pax.[ExtraTax],0) )as XTTax,--sum(isnull(pax.serviceCharge,0) )as ServiceCharge,
isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
max(#temp4.travel) as travelDate, (isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2))) as PlbC, 
pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.promoCode,book.Country,book.OfficeID as OfficeID
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join  #temp4 on pmt.order_id=#temp4.orderId	where book.IsBooked=1 AND book.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,book.inserteddate) >=convert(date,@frmDate) and convert(date,book.inserteddate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) and PromoDiscount >0 AND book.Agentid='B2C' and book.Country=@country
group by book.riyaPNR,book.GDSPNR,book.inserteddate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,pid,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge





,pax.Markup,book.promoCode
,book.SupplierCode,book.Vendor_No,book.Country,OfficeID

,ROE,AgentROE)p 

order by inserteddate
drop table #temp4
END
END
ELSE
BEGIN
IF(@status=1)--status-Ticketed
BEGIN
select * into #temp9 from
(
SELECT t.orderId, 
STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
STUFF((SELECT ',' + convert(varchar(11),s.depDate,103)+','+convert(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis,
STUFF((SELECT '/' +  substring(I.cabin,0,2) FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS rbd,
STUFF((SELECT '/' + I.airlinePNR FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS airlinePNR
FROM tblBookItenary AS t GROUP BY t.orderId) X
select pid, 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate, CustomerNumber, LocationCode,
'TKTT' TransactionType, (SELECT VALUE FROM mCommon M WHERE M.ID= P.userTypeID ) AS  AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,
(case WHEN @country='IN' THEN 'INR' WHEN @country='US' THEN 'USD' WHEN @country='CA' THEN 'CAD' WHEN @country='AE' THEN 'AED'  else 'INR' END) AS CurrencyType,

p.BasicFare,p.YQTax,0 as [OC tax],p.TaxTotal,p.QTaxBase,
p.TotalFare,	IataCommissionC,''	AdditionalCommissionC, PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare, FormofPayment,
''	MarkupOnFare,	MarkupOnTax, p.ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

''	Penalty ,''  as	[MarkupOnCancellation],''	as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
	[Employee Dimension Code],p.promoCode as [TR/PO No.],''	[Card Type],[IATA Code],''	[Contact No.],''[Cancellation Type],
'Travel Next' as [Booking Source Type],''[BTA Sales],''	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,p.YrTax,p.XTTax,p.JNTax,p.OCTax,p.INTax ,p.airCode	,
--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) as supplierCode,
--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) as VendorNo,
REPLACE((CASE WHEN p.airCode='SG' THEN 'SG' WHEN p.airCode='G8' THEN 'G8' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6E' END) ELSE p.airCode END),'?','') as supplierCode,
VendorNo,
PaxType, '' FromCity,'' ToCity,airlinePNR,rbd,
'' AS 'CRS',p.fromAirport,p.toAirport,p.equipment,'' as baggage,FlyingHour,
ProductType,'PRD100101' AS ProductCode,BranchCode,'' as [Emp Code],
p.RegistrationNumber,p.CompanyName,p.CAddress,p.CState,p.CContactNo,p.CEmailID,
JobCodeBookingGivenBy,VesselName, ReasonofTravel, TravelRequestNumber, CostCenter, BudgetCode, EmpDimession, SwonNo, TravelerType, Location, Department, Grade, 
 ma.Bookedby, Designation, Chargeability, NameofApprover, ReferenceNo, TR_POName, RankNo, AType, BookingReceivedDate,P.ROE,P.AgentROE

FROM

(select distinct (pax.pid), book.riyaPNR,book.GDSPNR,book.inserteddate IssueDate, book.GDSPNR as PNR, book.airCode,
(ticketNum) ticket1,(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
(pax.basicFare) as	BasicFare	,
(PAX.totalTax) as TaxTotal,
0	QTaxBase	,(pax.totalFare-pax.serviceCharge)  as TotalFare,
(convert(float,[YQ])) as YQTax,([CounterCloseTime]) as bookType,
(#temp9.Sector)  as sector,(book.airCode) as code,
(pmt.payment_mode) as mode,(book.flightNo) as filght,
(#temp9.airlinePNR) as airlinePNR, (#temp9.Class) as class, 
(#temp9.flight) as Flight,(#temp9.farebasis) as farebasis,
(isnull(pax.[YRTax],0)) as YrTax,(isnull(pax.[INTax],0)) as INTax,
(isnull(pax.[JNTax],0) )as JNTax,(isnull(pax.[OCTax],0)) as OCTax,
(isnull((PAX.totalTax-(PAX.YRTax + PAX.INTax +PAX.JNTax +PAX.OCTax +PAX.YQ)),0) )as XTTax,--sum(isnull(pax.serviceCharge,0) )as ServiceCharge,
isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
(#temp9.travel) as travelDate, (isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2))) as PlbC, 
pax.IATACommission AS IataCommissionC, pax.Markup as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,promoCode,#temp9.rbd,book.fromAirport,book.toAirport,book.equipment,
datediff(hour,book.deptTime,book.arrivalTime) as 'FlyingHour',ISNULL(r.Icast,R1.Icast) AS CustomerNumber,
(ISNULL((select top 1 (case when(count(Code)>1) then 'Air-domestic' else 'Air-Int'end) as sector from sectors  
where ((ltrim(rtrim(Code)) = book.frmSector  or	ltrim(rtrim(Code)) = book.toSector)  AND [Country code]=A.BookingCountry)group by [Country Code]),'Air-Int')) AS 'ProductType',
ISNULL(r.LocationCode,R1.LocationCode) AS LocationCode,ISNULL(r.BranchCode,R1.BranchCode) AS BranchCode,(case when pmt.payment_mode='passThrough' then 'CREDIT CARD' else 'CASH' end)as FormofPayment,
m.UserName as [Employee Dimension Code],
(case when book.OfficeID ='DFW1S212A' THEN 'UVEND00066' 
when  book.OfficeID ='YWGC4211G' THEN 'CVEND00041' 
when  book.OfficeID ='DXBAD3359' THEN 'VEND00102' 
when  book.OfficeID ='DTW1S21B1' THEN 'UVEND00086' 
when  book.OfficeID ='RIYAAPI' THEN 'VEND00295' 
when  book.OfficeID ='FAE0828' THEN 'VEND00233' 
when  book.OfficeID ='INTDXBA122' THEN 'VEND00020' 
when  book.OfficeID ='GSADBRIY' THEN 'VEND003484' 
when  book.OfficeID ='AERIYA' THEN 'VEND003313' 
when  book.OfficeID ='OTA.RIYAUAE' THEN 'VEND00314' 
when  book.OfficeID ='NP177DXB' THEN 'VEND00018' 
when  book.OfficeID ='apiriyab2buae' THEN 'VEND00273' 
when  book.OfficeID ='DXBDN3110' THEN 'VEND00312' 
when  book.OfficeID ='UAE1018' THEN 'VEND00307' 
when  book.OfficeID ='86OJ' THEN 'VEND00102' 
when  book.OfficeID ='A1FH' THEN 'UVEND00066' 
when  book.OfficeID ='C0KH' THEN 'CVEND00041' 

ELSE '' END) AS VendorNo,
(case when book.OfficeID ='DFW1S212A' THEN '45828661' 
when book.OfficeID ='YWGC4211G' THEN '62500082' 
when book.OfficeID ='BOMVS34AD' THEN '14369644'
 when book.OfficeID ='BOMI228DS' THEN '14360102'
when book.OfficeID ='DXBAD3359' THEN '86215290' 
when book.OfficeID ='NYC1S21E9' THEN '33750021'
when book.OfficeID ='DXBDN3110' THEN '86255606'
when book.OfficeID ='TYOJA28EK' THEN '16307001'
when book.OfficeID ='LONB934RT' THEN '91228222'
when book.OfficeID ='YTOC4211Z' THEN '67754013'
when book.OfficeID ='YVRC4215M' THEN '61708102'
when book.OfficeID ='LAX1S21CV' THEN '05606731'
when book.OfficeID ='SFO1S215Q' THEN '05922022'
when book.OfficeID ='CHI1S213T' THEN '14635574'
when book.OfficeID ='NYC1S219Z' THEN '45684295'
when book.OfficeID ='BOMI22114' THEN '14338855'
when book.OfficeID ='BOMVS34OA' THEN '14360102'
when book.OfficeID ='DFWRB2100' THEN '00909672'
when book.OfficeID ='DCA1S21EN' THEN '21721243'
when book.OfficeID ='YWGC4211Q' THEN '00088653'
when book.OfficeID ='YWGC4211W' THEN '62500082'
when book.OfficeID ='YWGC4212B' THEN '62500082'
when book.OfficeID ='86OJ' THEN '86215290'
when book.OfficeID ='A1FH' THEN '45828661'
when book.OfficeID ='C0KH' THEN '62500082'
when book.OfficeID ='DTW1S21B1' THEN '23854526'
 ELSE '' END) AS [IATA Code],VendorName,A.userTypeID,book.orderId
 ,BOOK.ROE,AgentROE,book.RegistrationNumber,book.CompanyName,book.CAddress,book.CState,book.CContactNo,book.CEmailID
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId AND AgentID !='B2C' and book.totalFare>0 and pax.totalFare>0
left join mUser m on m.id=book.mainagentid
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join B2BRegistration r on r.FKUserID=book.AgentID
left join agentLogin A on A.UserID=book.AgentID
left join B2BRegistration r1 on r1.FKUserID=A.ParentAgentID
left join PNRRetriveDetails p on p.OrderID=book.orderId
left join  #temp9 on pmt.order_id=#temp9.orderId	
where book.IsBooked=1 AND book.Country in (select C.CountryCode  from mUserCountryMapping UM

INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,isnull(book.inserteddate_old,book.inserteddate)) >=convert(date,@frmDate) 
and convert(date,isnull(book.inserteddate_old,book.inserteddate)) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) and A.UserTypeid=@usertype and book.Country=@country 
and AgentID =(CASE @agentid WHEN '' then agentid else @agentid end) and pax.totalFare>0 


)p 
left join mAttrributesDetails MA ON MA.OrderID=p.OrderID


order by p.IssueDate asc
drop table #temp9
END

ELSE IF(@status=2)--status-REFUNDED
BEGIN
select * into #temp5 from
(
SELECT t.orderId, 
STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS AIRPNR,
STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
STUFF((SELECT ',' + convert(varchar(11),s.depDate,103)+','+convert(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis
FROM tblBookItenary AS t GROUP BY t.orderId) X
select 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
'RFND' TransactionType,(SELECT VALUE FROM mCommon M WHERE M.ID= P.userTypeID ) AS  AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,(case WHEN OfficeID='DFW1S212A' THEN 'USD' WHEN OfficeID='YWGC4211G' THEN 'CAD' else 'INR' END) AS CurrencyType,(0-p.BasicFare) as BasicFare,(0-p.YQTax) as YQTax ,0 as [OC tax],
(0-p.TaxTotal) as TaxTotal,(0-p.QTaxBase) as QTaxBase,(0-p.TotalFare) as TotalFare,
IataCommissionC,''	AdditionalCommissionC,PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare,'CASH' as FormofPayment,
''	MarkupOnFare, (0-ServiceCharge)	MarkupOnTax, 0 as ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

Penalty ,MarkupOnCancellation,''	as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
''	[Employee Dimension Code],PromoCode as [TR/PO No.],''	[Card Type],''	[IATA Code],''	[Contact No.],''[Cancellation Type],
'B2C' as [Booking Source Type],''[BTA Sales],''	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,(0-p.YrTax) as YrTax,(0-p.XTTax) as XTTax,(0-p.JNTax) as JNTax,(0-p.OCTax) as OCTax,(0-p.INTax) as INTax ,p.airCode	,
--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) as supplierCode,
--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) as VendorNo,
REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') as supplierCode,
case when Vendor_No is not null then LEFT(Vendor_No, CHARINDEX('-', Vendor_No)-1) 
else(case WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode1 FROM TblSTSAirLineMaster) then 'RABOM0300004' ELSE '' END) end  as VendorNo,
--REPLACE((CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) 
 --WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' ELSE 'VEND000180' END),'?','') as VendorNo,
PaxType, '' FromCity,'' ToCity,orderId,isReturn,P.ROE,P.AgentROE

FROM

(select book.riyaPNR,book.GDSPNR,pax.CancelledDate IssueDate, book.GDSPNR as PNR, book.airCode,
max(ticketNum) ticket1,min(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
sum(pax.basicFare) as	BasicFare	,sum(pax.totalTax) TaxTotal,
0	QTaxBase	,sum(pax.totalFare-pax.serviceCharge)  as TotalFare,
sum(convert(float,[YQ])) as YQTax,max([CounterCloseTime]) as bookType,
max(#temp5.Sector)  as sector,max(book.airCode) as code,
max(pmt.payment_mode) as mode,max(flightNo) as filght,
max(#temp5.AIRPNR) as air, max(#temp5.Class) as class, 
max(#temp5.flight) as Flight,max(#temp5.farebasis) as farebasis,
sum(isnull(pax.[YRTax],0)) as YrTax,sum(isnull(pax.[INTax],0)) as INTax,
sum(isnull(pax.[JNTax],0) )as JNTax,sum(isnull(pax.[OCTax],0)) as OCTax,
sum(isnull(pax.[ExtraTax],0) )as XTTax,isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
max(#temp5.travel) as travelDate,ch.Panelty as Penalty,ch.CancellationCharge as 'MarkupOnCancellation',
book.orderId,pax.isReturn,(0-(isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2)))) as PlbC, 
pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,PromoCode,ROE,AgentROE
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join  #temp5 on pmt.order_id=#temp5.orderId	
inner join CancellationHistory Ch on ch.OrderId=book.orderId and FlagType=2
where pax.IsRefunded=1 and book.IsBooked=1  AND book.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,pax.RefundedDate) >=convert(date,@frmDate) and convert(date,pax.RefundedDate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) AND   A.UserTypeid=@usertype and book.Country=@country
and AgentID =(CASE @agentid WHEN '' then agentid else @agentid end)
group by book.riyaPNR,book.GDSPNR,pax.CancelledDate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,ch.RefundAmount,ch.CancellationCharge,
book.orderId,isReturn,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge, ch.Panelty,pax.Markup
,book.SupplierCode,book.Vendor_No,book.Country,OfficeID,ROE,PromoCode,ROE,AgentROE
)p order by mobookingnumber, plbc desc
drop table #temp1
END

--status 3 Pre refund

ELSE IF(@status=3)--Pre refund
BEGIN
select * into #temp6 from
(
SELECT t.orderId, 
STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS AIRPNR,
STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
STUFF((SELECT ',' + convert(varchar(11),s.depDate,103)+','+convert(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis
FROM tblBookItenary AS t GROUP BY t.orderId) X
select 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
'RFND' TransactionType,'B2B' AS  AgentId ,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,(case WHEN OfficeID='DFW1S212A' THEN 'USD' WHEN OfficeID='YWGC4211G' THEN 'CAD' else 'INR' END) AS CurrencyType,(0-p.BasicFare) as BasicFare,(0-p.YQTax) as YQTax ,0 as [OC tax],
(0-p.TaxTotal) as TaxTotal,(0-p.QTaxBase) as QTaxBase,(0-p.TotalFare) as TotalFare,
IataCommissionC,''	AdditionalCommissionC,PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare,'CASH' as FormofPayment,
''	MarkupOnFare, (0-ServiceCharge)	MarkupOnTax, 0 as ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

Penalty ,MarkupOnCancellation,''	as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
''	[Employee Dimension Code],''[TR/PO No.],''	[Card Type],''	[IATA Code],''	[Contact No.],''[Cancellation Type],
'B2C' as [Booking Source Type],''[BTA Sales],''	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,(0-p.YrTax) as YrTax,(0-p.XTTax) as XTTax,(0-p.JNTax) as JNTax,(0-p.OCTax) as OCTax,(0-p.INTax) as INTax ,p.airCode	,
--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) as supplierCode,
--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) as VendorNo,
REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') as supplierCode,
--REPLACE((CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) 
-- WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' ELSE 'VEND000180' END),'?','') as VendorNo,
case when Vendor_No is not null then LEFT(Vendor_No, CHARINDEX('-', Vendor_No)-1) else(case WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' 
WHEN P.airCode  in (SELECT AirlineCode1 FROM TblSTSAirLineMaster) then 'RABOM0300004' ELSE '' END) end  as VendorNo,
PaxType, '' FromCity,'' ToCity,orderId,isReturn,P.ROE,P.AgentROE

FROM

(select book.riyaPNR,book.GDSPNR,pax.CancelledDate IssueDate, book.GDSPNR as PNR, book.airCode,
max(ticketNum) ticket1,min(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
(pax.basicFare) as	BasicFare	,(pax.totalTax) TaxTotal,
0	QTaxBase	,(pax.totalFare-pax.serviceCharge)  as TotalFare,
(convert(float,[YQ])) as YQTax,max([CounterCloseTime]) as bookType,
max(#temp6.Sector)  as sector,max(book.airCode) as code,
max(pmt.payment_mode) as mode,max(flightNo) as filght,
max(#temp6.AIRPNR) as air, max(#temp6.Class) as class, 
max(#temp6.flight) as Flight,max(#temp6.farebasis) as farebasis,
(isnull(pax.[YRTax],0)) as YrTax,(isnull(pax.[INTax],0)) as INTax,
(isnull(pax.[JNTax],0) )as JNTax,(isnull(pax.[OCTax],0)) as OCTax,
(isnull(pax.[ExtraTax],0) )as XTTax,isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
max(#temp6.travel) as travelDate,ch.Panelty as Penalty,ch.CancellationCharge as 'MarkupOnCancellation',
book.orderId,pax.isReturn,(0-(isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2)))) as PlbC, 
pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,ROE,AgentROE
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join  #temp6 on pmt.order_id=#temp6.orderId	
inner join CancellationHistory Ch on ch.OrderId=book.orderId and FlagType=1
--where pax.IsRefunded=1 and book.IsBooked=1
where pax.IsCancelled=0 and pax.isProcessRefund=1 AND  book.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,ch.UpdateDate) >=convert(date,@frmDate) and convert(date,ch.UpdateDate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null )  and A.UserTypeid=@usertype and book.Country=@country
and AgentID =(CASE @agentid WHEN '' then agentid else @agentid end)
group by book.riyaPNR,book.GDSPNR,pax.CancelledDate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,ch.RefundAmount,ch.CancellationCharge,
book.orderId,isReturn,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge, ch.Panelty,pax.Markup
,book.SupplierCode,book.Vendor_No,pax.basicFare,pax.totalTax,pax.totalFare,pax.YQ,pax.YRTax,pax.INTax,pax.JNTax,pax.OCTax,pax.ExtraTax,book.Country,OfficeID,ROE
,ROE,AgentROE)p order by mobookingnumber, plbc desc
drop table #temp2
  END

  else IF(@status=4)--status-PromoCode
BEGIN
select * into #temp7 from
(
SELECT t.orderId, 
STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS AIRPNR,
STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
STUFF((SELECT ',' + convert(varchar(11),s.depDate,103)+','+convert(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis
FROM tblBookItenary AS t GROUP BY t.orderId) X
select pid, 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
'TKTT' TransactionType,(SELECT VALUE FROM mCommon M WHERE M.ID= P.userTypeID ) AS  AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,(case WHEN OfficeID='DFW1S212A' THEN 'USD' WHEN OfficeID='YWGC4211G' THEN 'CAD' else 'INR' END) AS CurrencyType,p.BasicFare,p.YQTax,0 as [OC tax],p.TaxTotal,p.QTaxBase,
p.TotalFare,	IataCommissionC,''	AdditionalCommissionC, PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare,'CASH' as FormofPayment,
''	MarkupOnFare,	MarkupOnTax, ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

''	Penalty ,''  as	[MarkupOnCancellation],''	as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
''	[Employee Dimension Code],''[TR/PO No.],''	[Card Type],''	[IATA Code],''	[Contact No.],''[Cancellation Type],
'B2C' as [Booking Source Type],''[BTA Sales],''	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,p.YrTax,p.XTTax,p.JNTax,p.OCTax,p.INTax ,p.airCode	,
--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) as supplierCode,
--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) as VendorNo,
REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') as supplierCode,
--REPLACE((CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) 
 --WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' ELSE 'VEND000180' END),'?','') as VendorNo,
case when Vendor_No is not null then LEFT(Vendor_No, CHARINDEX('-', Vendor_No)-1) else(case WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode1 FROM TblSTSAirLineMaster) then 'RAB
OM0300004' ELSE '' END) end  as VendorNo,
PaxType, '' FromCity,'' ToCity,promoCode,P.ROE,P.AgentROE

FROM

(select pax.pid, book.riyaPNR,book.GDSPNR,book.inserteddate IssueDate, book.GDSPNR as PNR, book.airCode,
max(ticketNum) ticket1,min(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
sum(pax.basicFare) as	BasicFare	,sum(pax.totalTax) TaxTotal,
0	QTaxBase	,sum(pax.totalFare-pax.serviceCharge)  as TotalFare,
sum(convert(float,[YQ])) as YQTax,max([CounterCloseTime]) as bookType,
max(#temp7.Sector)  as sector,max(book.airCode) as code,
max(pmt.payment_mode) as mode,max(flightNo) as filght,
max(#temp7.AIRPNR) as air, max(#temp7.Class) as class, 
max(#temp7.flight) as Flight,max(#temp7.farebasis) as farebasis,
sum(isnull(pax.[YRTax],0)) as YrTax,sum(isnull(pax.[INTax],0)) as INTax,
sum(isnull(pax.[JNTax],0) )as JNTax,sum(isnull(pax.[OCTax],0)) as OCTax,
sum(isnull(pax.[ExtraTax],0) )as XTTax,--sum(isnull(pax.serviceCharge,0) )as ServiceCharge,
isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
max(#temp7.travel) as travelDate, (isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2))) as PlbC, 
pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.promoCode,book.Country,book.OfficeID as OfficeID,ROE,AgentROE
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join  #temp7 on pmt.order_id=#temp7.orderId	where book.IsBooked=1 AND book.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,book.inserteddate) >=convert(date,@frmDate) and convert(date,book.inserteddate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) and PromoDiscount >0  and A.UserTypeid=@usertype and book.Country=@country
and AgentID =(CASE @agentid WHEN '' then agentid else @agentid end)
group by book.riyaPNR,book.GDSPNR,book.inserteddate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,pid,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge





,pax.Markup,book.promoCode
,book.SupplierCode,book.Vendor_No,book.Country,OfficeID,ROE

,ROE,AgentROE)p order by mobookingnumber, plbc desc
drop table #temp7
END
END


END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchERPData_NEW5] TO [rt_read]
    AS [dbo];

