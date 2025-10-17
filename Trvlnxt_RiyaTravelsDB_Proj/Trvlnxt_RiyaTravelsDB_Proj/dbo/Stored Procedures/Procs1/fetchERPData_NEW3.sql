CREATE procedure [dbo].[fetchERPData_NEW3] --fetchERPData_NEW3 '22-dec-2022','22-dec-2022',1,2,'ae','2',''
@frmDate datetime=null,
@toDate datetime=null,
@status tinyint,
@Userid int=null,
@country varchar(2)=null,
@usertype varchar(5)=null,
@agentid  varchar(50)
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
, t.PreviousAirlinePNR
FROM tblBookItenary AS t GROUP BY t.orderId, t.PreviousAirlinePNR) X
select pid, 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'BOMRC' LocationCode,
'TKTT' TransactionType,'B2C' AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,
(select TOP 1 currencycode from mcountrycurrency where countrycode=@country) AS CurrencyType,
p.BasicFare,p.YQTax,p.OCTax as [OC tax],p.TaxTotal,p.QTaxBase,
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
isnull(REPLACE((CASE WHEN p.airCode='SG' THEN 'SG' 
WHEN p.airCode='G8' THEN 'G8' 
WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6E' END) 
ELSE ( case when p.VendorName='Amadeus' AND Len(p.ticket1)=12  then(
SELECT  _CODE FROM AirlinesName WHERE [AWB Prefix] in (  cast (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 3) as VARCHAR(100)) ))
 when p.VendorName='Amadeus' AND Len(p.ticket1)!=12 then (
SELECT  _CODE FROM AirlinesName WHERE [AWB Prefix] in (  cast (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 4) as VARCHAR(100)) )) 
else p.airCode   end) END),'?',''),p.airCode)as supplierCode,

PaxType, '' FromCity,'' ToCity,airlinePNR,rbd,
'' AS 'CRS',
 p.fromAirport,p.toAirport,p.equipment,'' as baggage,FlyingHour,ProductType,'PRD100101' AS ProductCode,
 'BOMRC' BranchCode,'' [Emp Code],
 RegistrationNumber,CompanyName,CAddress,CState,CContactNo,CEmailID
 ,JobCodeBookingGivenBy, VesselName, ReasonofTravel, TravelRequestNumber, CostCenter, BudgetCode, EmpDimession, SwonNo, TravelerType, Location, Department, Grade, ma.Bookedby, Designation, Chargeability, NameofApprover, ReferenceNo, TR_POName, RankNo, AType, BookingReceivedDate,
 P.ROE,P.AgentROE,VendorNo,CustomerNumber, promodiscount,'' as 'MCO number', '' as 'MCO amount',cardtype as crdtype,cardnumber as crdno
  , reScheduleCharge As RescheduleCharges, SupplierPenalty,  RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR, convert(varchar(11),p.IssueDate,103) as RescheduleDate,
  [Extra Baggage Amount],	[Seat Preference Charge],	[Meal Charges],	[Wheel Chair Charges],	[SSR Comb Amount],p.YMTax,p.WOTax,p.OBTax,p.RFTax,'' as OBTC
  ,Traveltype,Changedcostno,Travelduration,TASreqno,Companycodecc,Projectcode,
   AuthCode as [Card Approval Code],ExpiryDate as [Card expiry],MCOMerchantfee as [MCO Merchant fee]
FROM

(select book.VendorName,  pax.pid, book.riyaPNR,book.GDSPNR,book.inserteddate IssueDate, book.GDSPNR as PNR, book.airCode,
(ticketNum) ticket1,(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,

cast((pax.basicFare * book.ROE) as decimal(18,2)) as	BasicFare	,
cast((PAX.totalTax * book.ROE)as decimal(18,2)) as TaxTotal,
cast(((pax.totalFare-pax.serviceCharge) * book.ROE)as decimal(18,2))  as TotalFare,
cast((convert(float,[YQ]* book.ROE))as decimal(18,2)) as YQTax,
cast((isnull(pax.[YRTax]* book.ROE,0))as decimal(18,2)) as YrTax,
cast((isnull(pax.[INTax]* book.ROE,0))as decimal(18,2)) as INTax,
cast((isnull(pax.[JNTax]* book.ROE,0) )as decimal(18,2)) as JNTax,
cast((isnull(pax.[OCTax]* book.ROE,0))as decimal(18,2)) as OCTax,
cast((isnull(pax.[YMTax]* book.ROE,0))as decimal(18,2)) as YMTax,
cast((isnull(pax.[WOTax]* book.ROE,0))as decimal(18,2)) as WOTax,
cast((isnull(pax.[OBTax]* book.ROE,0))as decimal(18,2)) as OBTax,
cast((isnull(pax.[RFTax]* book.ROE,0))as decimal(18,2)) as RFTax,
cast((isnull((pax.ExtraTax * book.ROE),0) )as decimal(18,2))as XTTax,


0	QTaxBase	,([CounterCloseTime]) as bookType,
(#temp.Sector)  as sector,(book.airCode) as code,
(pmt.payment_mode) as mode,(flightNo) as filght,
(#temp.AIRPNR) as air, (#temp.Class) as class, 
(#temp.flight) as Flight,(#temp.farebasis) as farebasis,

isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
(#temp.travel) as travelDate, (isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2))) as PlbC, 
pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,promoCode,
#temp.airlinePNR,#temp.rbd,book.fromAirport,book.toAirport,book.equipment,
datediff(hour,book.deptTime,book.arrivalTime) as 'FlyingHour',
(case when counterclosetime=1 then 'Air-domestic' else 'Air-Int'end) AS 'ProductType',
'' as [Employee Dimension Code],
(case when OfficeID ='DFW1S212A' THEN '45828661' when OfficeID ='YWGC4211G' THEN '62500082' when OfficeID ='BOMVS34AD' THEN '14369644' when OfficeID ='BOMI228DS' THEN '14360102'
when OfficeID ='DXBAD3359' THEN '86215290' when OfficeID ='NYC1S21E9' THEN '33750021' when OfficeID ='BOMI228DS' THEN '14360102'  ELSE '' END) AS [IATA Code],ROE,AgentROE,
(SELECT VendorCode FROM tblERPDetails E WHERE E.OwnerID=book.OfficeID and AgentCountry=book.Country and ERPCountry= @country) AS VendorNo,

(SELECT (case when CustomerCode='AgentCustID' then 'ICUST35086'
 when CustomerCode='ICUST35086' then 'ICUST35086' 
 when CustomerCode='UCUST00027' then 'UCUST00373' 
 when CustomerCode='CCUST00002' then 'CCUST00091' 
 else CustomerCode end) as CustomerNumber  FROM tblERPDetails E 
WHERE E.OwnerID=book.OfficeID and AgentCountry=book.Country and ERPCountry= @country) AS CustomerNumber,
book.RegistrationNumber,book.CompanyName,book.CAddress,book.CState,book.CContactNo,book.CEmailID,(isnull(pax.FlatDiscount,0) + isnull(pax.DropnetCommission,0)) as promodiscount
,pmt.cardtype,pmt.MaskCardNumber AS cardnumber
, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp.PreviousAirlinePNR,
ssr.SSR_Amount as [Extra Baggage Amount],	0 as [Seat Preference Charge],	0 as [Meal Charges],	0 as [Wheel Chair Charges],	0 as [SSR Comb Amount],
pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join UserLogin ul on ul.UserID=book.LoginEmailID
left join  #temp on pmt.order_id=#temp.orderId
left join tblSSRDetails SSR on ssr.fkPassengerid=pax.pid and SSR_Type='Baggage' and SSR_Status=1
	where (book.IsBooked=1 or book.BookingStatus=1) AND book.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,book.inserteddate) >=convert(date,@frmDate) and convert(date,book.inserteddate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) AND book.Agentid='B2C' and book.Country=@country

)p 
left join mAttrributesDetails MA ON MA.GDSPNR=p.GDSPNR and ma.GDSPNR is not null


union 


select pid, 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'BOMRC' LocationCode,
'TKTT' TransactionType,'B2C' AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,
(select TOP 1 currencycode from mcountrycurrency where countrycode=@country) AS CurrencyType,
p.BasicFare,p.YQTax,p.OCTax as [OC tax],p.TaxTotal,p.QTaxBase,
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
isnull(REPLACE((CASE WHEN p.airCode='SG' THEN 'SG' 
WHEN p.airCode='G8' THEN 'G8' 
WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6E' END) 
ELSE ( case when p.VendorName='Amadeus' AND Len(p.ticket1)=12  then(
SELECT  _CODE FROM AirlinesName WHERE [AWB Prefix] in (  cast (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 3) as float) ))
 when p.VendorName='Amadeus' AND Len(p.ticket1)!=12 then (
SELECT  _CODE FROM AirlinesName WHERE [AWB Prefix] in (  cast (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 4) as float) )) 
else p.airCode   end) END),'?',''),p.airCode) as supplierCode,

PaxType, '' FromCity,'' ToCity,airlinePNR,rbd,
'' AS 'CRS',
 p.fromAirport,p.toAirport,p.equipment,'' as baggage,FlyingHour,ProductType,'PRD100101' AS ProductCode,
 'BOMRC' BranchCode,'' [Emp Code],
 RegistrationNumber,CompanyName,CAddress,CState,CContactNo,CEmailID
 ,JobCodeBookingGivenBy, VesselName, ReasonofTravel, TravelRequestNumber, CostCenter, BudgetCode, EmpDimession, SwonNo, TravelerType, Location, Department, Grade, ma.Bookedby, Designation, Chargeability, NameofApprover, ReferenceNo, TR_POName, RankNo, AType, BookingReceivedDate,
 P.ROE,P.AgentROE,VendorNo,CustomerNumber, promodiscount,'' as 'MCO number', '' as 'MCO amount',cardtype as crdtype,cardnumber as crdno
  , reScheduleCharge As RescheduleCharges, SupplierPenalty,  RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR, convert(varchar(11),p.IssueDate,103) as RescheduleDate 
 ,[Extra Baggage Amount],	 [Seat Preference Charge], [Meal Charges], [Wheel Chair Charges],	[SSR Comb Amount],p.YMTax,p.WOTax,p.OBTax,p.RFTax,'' as OBTC
 ,Traveltype,Changedcostno,Travelduration,TASreqno,Companycodecc,Projectcode,
  AuthCode as [Card Approval Code],ExpiryDate as [Card expiry],MCOMerchantfee as [MCO Merchant fee]
FROM

(select book.VendorName,  pax.pid, book.riyaPNR,book.GDSPNR,book.inserteddate IssueDate, book.GDSPNR as PNR, book.airCode,
(ticketNum) ticket1,(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,

(pax.basicFare )  as	BasicFare	,
(PAX.totalTax ) as TaxTotal,
(pax.totalFare-pax.serviceCharge)  as TotalFare,
(convert(float,[YQ])) as YQTax,
(isnull(pax.[YRTax],0)) as YrTax,
(isnull(pax.[INTax],0)) as INTax,
(isnull(pax.[JNTax],0)) as JNTax,
(isnull(pax.[OCTax],0)) as OCTax,
(isnull(pax.[YMTax],0)) as YMTax,
(isnull(pax.[WOTax],0)) as WOTax,
(isnull(pax.[OBTax],0)) as OBTax,
(isnull(pax.[RFTax],0)) as RFTax,
(isnull((pax.ExtraTax),0) )as XTTax,


0	QTaxBase	,([CounterCloseTime]) as bookType,
(#temp.Sector)  as sector,(book.airCode) as code,
(pmt.payment_mode) as mode,(flightNo) as filght,
(#temp.AIRPNR) as air, (#temp.Class) as class, 
(#temp.flight) as Flight,(#temp.farebasis) as farebasis,

isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
(#temp.travel) as travelDate, (isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2))) as PlbC, 
pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,promoCode,
#temp.airlinePNR,#temp.rbd,book.fromAirport,book.toAirport,book.equipment,
datediff(hour,book.deptTime,book.arrivalTime) as 'FlyingHour',
(case when counterclosetime=1 then 'Air-domestic' else 'Air-Int'end) AS 'ProductType',
'' as [Employee Dimension Code],
(case when OfficeID ='DFW1S212A' THEN '45828661' when OfficeID ='YWGC4211G' THEN '62500082' when OfficeID ='BOMVS34AD' THEN '14369644' when OfficeID ='BOMI228DS' THEN '14360102'
when OfficeID ='DXBAD3359' THEN '86215290' when OfficeID ='NYC1S21E9' THEN '33750021' when OfficeID ='BOMI228DS' THEN '14360102'  ELSE '' END) AS [IATA Code],ROE,AgentROE,

(SELECT VendorCode FROM tblERPDetails E WHERE E.OwnerID=book.OfficeID and AgentCountry=book.Country and ERPCountry= @country) AS VendorNo,

(SELECT (case when CustomerCode='AgentCustID' then 'ICUST35086'
 when CustomerCode='ICUST35086' then 'ICUST35086' 
 when CustomerCode='UCUST00027' then 'UCUST00373' 
 when CustomerCode='CCUST00002' then 'CCUST00091' 
 else CustomerCode end) as CustomerNumber  FROM tblERPDetails E 
WHERE E.OwnerID=book.OfficeID and AgentCountry=book.Country and ERPCountry= @country) AS CustomerNumber,
book.RegistrationNumber,book.CompanyName,book.CAddress,book.CState,book.CContactNo,book.CEmailID,(isnull(pax.FlatDiscount,0) + isnull(pax.DropnetCommission,0)) as promodiscount
,pmt.cardtype,pmt.MaskCardNumber AS cardnumber
, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp.PreviousAirlinePNR,
ssr.SSR_Amount  as [Extra Baggage Amount],	0 as [Seat Preference Charge],	0 as [Meal Charges],	0 as [Wheel Chair Charges],	0 as [SSR Comb Amount],
pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee

from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join UserLogin ul on ul.UserID=book.LoginEmailID
left join  #temp on pmt.order_id=#temp.orderId
left join tblSSRDetails SSR on ssr.fkPassengerid=pax.pid and SSR_Type='Baggage' and SSR_Status=1 and ssr.SSR_Amount>0
	where (book.IsBooked=1 or book.BookingStatus=1) AND book.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,book.inserteddate) >=convert(date,@frmDate) and convert(date,book.inserteddate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) AND book.Agentid='B2C'and
 (BOOK.OfficeID IN ( SELECT OwnerID FROM tblERPDetails WHERE OwnerID= book.OfficeID AND ERPCountry=@country AND AgentCountry='IN' 
 and OwnerCountry=@country ))



)p 
left join mAttrributesDetails MA ON MA.GDSPNR=p.GDSPNR and ma.GDSPNR is not null




--order by book.inserteddate
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
, t.PreviousAirlinePNR
FROM tblBookItenary AS t GROUP BY t.orderId, t.PreviousAirlinePNR) X
select 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
'RFND' TransactionType,'B2C' AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,(case WHEN p.OfficeID='DFW1S212A' THEN 'USD' WHEN p.OfficeID='YWGC4211G' THEN 'CAD' else 'INR' END) AS CurrencyType,(0-p.BasicFare) as BasicFare,(0-p.YQTax) as YQTax ,p.OCTax as [OC tax],
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
 ,P.ROE,P.AgentROE,'' as 'MCO number', '' as 'MCO amount',cardtype as crdtype,cardnumber as crdno
  , reScheduleCharge As RescheduleCharges, SupplierPenalty, RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR , convert(varchar(11),p.IssueDate,103) as RescheduleDate,
  AuthCode as [Card Approval Code],ExpiryDate as [Card expiry],MCOMerchantfee as [MCO Merchant fee]
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
(isnull(pax.[YMTax],0)) as YMTax,
(isnull(pax.[WOTax],0)) as WOTax,
(isnull(pax.[OBTax],0)) as OBTax,
(isnull(pax.[RFTax],0)) as RFTax,
sum(isnull(pax.[ExtraTax],0) )as XTTax,isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
max(#temp1.travel) as travelDate,ch.Panelty as Penalty,ch.CancellationCharge as 'MarkupOnCancellation',
book.orderId,pax.isReturn,(0-(isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2)))) as PlbC, 
pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,PromoCode,
#temp1.airlinePNR,#temp1.rbd,book.fromAirport,book.toAirport,book.equipment,
datediff(hour,book.deptTime,book.arrivalTime) as 'FlyingHour',
(case when counterclosetime=1 then 'Air-domestic' else 'Air-Int'end) AS 'ProductType',
'' as [Employee Dimension Code],ROE,AgentROE,
pmt.cardtype,pmt.MaskCardNumber AS cardnumber
, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp1.PreviousAirlinePNR ,
pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join UserLogin ul on ul.UserID=book.LoginEmailID
left join  #temp1 on pmt.order_id=#temp1.orderId	
inner join CancellationHistory Ch on ch.OrderId=book.orderId and FlagType=2
where pax.IsRefunded=1 and (book.IsBooked=1 or book.BookingStatus=1)  AND book.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,pax.RefundedDate) >=convert(date,@frmDate) and convert(date,pax.RefundedDate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) AND book.Agentid='B2C' and book.Country=@country
group by book.riyaPNR,book.GDSPNR,pax.CancelledDate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,ch.RefundAmount,ch.CancellationCharge,
book.orderId,isReturn,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge, ch.Panelty,pax.Markup
,book.SupplierCode,book.Vendor_No,book.Country,OfficeID,ROE,PromoCode,airlinePNR,rbd, book.fromAirport,book.toAirport,book.equipment,book.deptTime,book.arrivalTime,book.frmSector,book.toSector,book.counterclosetime,ul.UserName
,ROE,AgentROE)p 
left join mAttrributesDetails MA ON MA.GDSPNR=p.GDSPNR and ma.GDSPNR is not null
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
, t.PreviousAirlinePNR 
FROM tblBookItenary AS t GROUP BY t.orderId, t.PreviousAirlinePNR) X
select 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
'RFND' TransactionType,'B2C' AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,(case WHEN p.OfficeID='DFW1S212A' THEN 'USD' WHEN p.OfficeID='YWGC4211G' THEN 'CAD' else 'INR' END) AS CurrencyType,(0-p.BasicFare) as BasicFare,(0-p.YQTax) as YQTax ,p.OCTax as [OC tax],
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
 ,P.ROE,P.AgentROE,'' as 'MCO number', '' as 'MCO amount',cardtype as crdtype,cardnumber as crdno
 , reScheduleCharge As RescheduleCharges, SupplierPenalty,  RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR , convert(varchar(11),p.IssueDate,103) as RescheduleDate,
  AuthCode as [Card Approval Code],ExpiryDate as [Card expiry],MCOMerchantfee as [MCO Merchant fee]
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
(isnull(pax.[YMTax],0)) as YMTax,
(isnull(pax.[WOTax],0)) as WOTax,
(isnull(pax.[OBTax],0)) as OBTax,
(isnull(pax.[RFTax],0)) as RFTax,
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
,ROE,AgentROE,pmt.cardtype,pmt.MaskCardNumber AS cardnumber
, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp2.PreviousAirlinePNR 
 ,pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
 from tblPassengerBookDetails pax
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
left join mAttrributesDetails MA ON MA.GDSPNR=p.GDSPNR and ma.GDSPNR is not null
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
, t.PreviousAirlinePNR 
FROM tblBookItenary AS t GROUP BY t.orderId, t.PreviousAirlinePNR) X
select pid, 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
'TKTT' TransactionType,'B2C' AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,(case WHEN OfficeID='DFW1S212A' THEN 'USD' WHEN OfficeID='YWGC4211G' THEN 'CAD' else 'INR' END) AS CurrencyType,p.BasicFare,p.YQTax,p.OCTax as [OC tax],p.TaxTotal,p.QTaxBase,
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
PaxType, '' FromCity,'' ToCity,promoCode,P.ROE,P.AgentROE,'' as 'MCO number', '' as 'MCO amount',cardtype as crdtype,cardnumber as crdno
, reScheduleCharge As RescheduleCharges, SupplierPenalty,  RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR , convert(varchar(11),p.IssueDate,103) as RescheduleDate
, [Extra Baggage Amount],	 [Seat Preference Charge], [Meal Charges], [Wheel Chair Charges],	[SSR Comb Amount],p.YMTax,p.WOTax,p.OBTax,p.RFTax
,'' as Traveltype,'' as Changedcostno,'' as Travelduration,''as TASreqno,'' as Companycodecc,'' as Projectcode,
AuthCode as [Card Approval Code],ExpiryDate as [Card expiry],MCOMerchantfee as [MCO Merchant fee]
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
(isnull(pax.[YMTax],0)) as YMTax,
(isnull(pax.[WOTax],0)) as WOTax,
(isnull(pax.[OBTax],0)) as OBTax,
(isnull(pax.[RFTax],0)) as RFTax,
sum(isnull(pax.[ExtraTax],0) )as XTTax,--sum(isnull(pax.serviceCharge,0) )as ServiceCharge,
isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
max(#temp4.travel) as travelDate, (isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2))) as PlbC, 
pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.promoCode,book.Country,book.OfficeID as OfficeID,pmt.cardtype,pmt.MaskCardNumber AS cardnumber
, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp4.PreviousAirlinePNR ,
ssr.SSR_Amount as  [Extra Baggage Amount],	0 as [Seat Preference Charge],	0 as [Meal Charges],	0 as [Wheel Chair Charges],	0 as [SSR Comb Amount],
pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join  #temp4 on pmt.order_id=#temp4.orderId
left join tblSSRDetails SSR on ssr.fkPassengerid=pax.pid and SSR_Type='Baggage' and SSR_Status=1 and ssr.SSR_Amount>0
	where (book.IsBooked=1 or book.BookingStatus=1) AND book.Country in (select C.CountryCode  from mUserCountryMapping UM
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
STUFF((SELECT '/' +  substring(I.cabin,0,2) FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS rbd,
STUFF((SELECT '/' + I.airlinePNR FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS airlinePNR
, t.PreviousAirlinePNR 
FROM tblBookItenary AS t GROUP BY t.orderId, t.PreviousAirlinePNR) X
select pid, 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate, LocationCode,
'TKTT' TransactionType, (SELECT VALUE FROM mCommon M WHERE M.ID= P.userTypeID ) AS  AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,
(select TOP 1 currencycode from mcountrycurrency where countrycode=@country) AS CurrencyType,
p.BasicFare,p.YQTax,p.OCTax as [OC tax],p.TaxTotal,p.QTaxBase,
p.TotalFare,	IataCommissionC,''	AdditionalCommissionC, PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare, FormofPayment,
	MarkupOnFare,	MarkupOnTax, p.ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

''	Penalty ,''  as	[MarkupOnCancellation],''	as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
	[Employee Dimension Code],p.promoCode as [TR/PO No.],''	[Card Type],[IATA Code],''	[Contact No.],''[Cancellation Type],
'Travel Next' as [Booking Source Type],''[BTA Sales],VesselName AS	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,p.YrTax,p.XTTax,p.JNTax,p.OCTax,p.INTax ,p.airCode	,
isnull(REPLACE((CASE WHEN p.airCode='SG' THEN 'SG' 
WHEN p.airCode='G8' THEN 'G8' 
WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6E' END) 
ELSE ( case when p.VendorName='Amadeus' AND LEN(P.ticket1)>6 then(
SELECT TOP 1 _CODE FROM AirlinesName WHERE [AWB Prefix] in (  cast (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 4) as VARCHAR(100)) ))
 else p.airCode   end) END),'?',''),p.airCode) as supplierCode,
VendorNo,CustomerNumber,
PaxType, '' FromCity,'' ToCity,airlinePNR,rbd,
'' AS 'CRS',p.fromAirport,p.toAirport,p.equipment,'' as baggage,FlyingHour,
ProductType,'PRD100101' AS ProductCode,BranchCode,'' as [Emp Code],
p.RegistrationNumber,p.CompanyName,p.CAddress,p.CState,p.CContactNo,p.CEmailID,
JobCodeBookingGivenBy,VesselName, ReasonofTravel, TravelRequestNumber, CostCenter, BudgetCode, EmpDimession, SwonNo, TravelerType, Location, Department, Grade, 
 ma.Bookedby, Designation, Chargeability, NameofApprover, ReferenceNo, TR_POName, p.RankNo, AType, BookingReceivedDate,P.ROE,P.AgentROE,
 promodiscount,p.[MCO amount],p.[MCO number],OfficeID,cardtype as crdtype,cardnumber as crdno
 , reScheduleCharge As RescheduleCharges, SupplierPenalty,  RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR  , convert(varchar(11),p.IssueDate,103) as RescheduleDate,
 [Extra Baggage Amount],	 [Seat Preference Charge], [Meal Charges], [Wheel Chair Charges],	[SSR Comb Amount],p.YMTax,p.WOTax,p.OBTax,p.RFTax,ma.OBTCno as OBTC 
 ,Traveltype,Changedcostno,Travelduration,TASreqno,Companycodecc,Projectcode,
 AuthCode as [Card Approval Code],ExpiryDate as [Card expiry],MCOMerchantfee as [MCO Merchant fee]
FROM

(select distinct (pax.pid), book.riyaPNR,book.GDSPNR,isnull(book.inserteddate_old,book.inserteddate) as IssueDate, book.GDSPNR as PNR, book.airCode,
(ticketNum) ticket1,(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
cast(((pax.basicFare+isnull(pax.Markup,0)) * book.ROE) as decimal(18,2)) as	BasicFare	,
cast(((PAX.totalTax ) * book.ROE)as decimal(18,2)) as TaxTotal,

cast((((pax.totalFare +isnull(pax.Markup,0))  -pax.serviceCharge) * book.ROE)as decimal(18,2))  as TotalFare,

cast((isnull((CASE WHEN ((BOOK.B2bFareType=2 or book.B2bFareType=3) AND book.BookingSource!='ManualTicketing') THEN  ((pax.B2BMarkup+pax.HupAmount)/isnull(book.AgentROE,0)) 
when book.BookingSource='ManualTicketing' then pax.Markup ELSE pax.HupAmount END),0))as decimal(18,2)) as MarkupOnTax,
(cast((isnull((CASE WHEN BOOK.B2bFareType=1 THEN  (pax.B2BMarkup/isnull(book.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PAX.BFC) as MarkupOnFare,

cast((isnull(pax.[YQ] * book.ROE,0))as decimal(18,2)) as YQTax,
cast((isnull(pax.[YRTax]* book.ROE,0))as decimal(18,2)) as YrTax,
cast((isnull(pax.[INTax]* book.ROE,0))as decimal(18,2)) as INTax,
cast((isnull(pax.[JNTax]* book.ROE,0) )as decimal(18,2)) as JNTax,
cast((isnull(pax.[OCTax]* book.ROE,0))as decimal(18,2)) as OCTax,

cast((isnull(pax.[YMTax]* book.ROE,0))as decimal(18,2)) as YMTax,
cast((isnull(pax.[WOTax]* book.ROE,0))as decimal(18,2)) as WOTax,
cast((isnull(pax.[OBTax]* book.ROE,0))as decimal(18,2)) as OBTax,
cast((isnull(pax.[RFTax]* book.ROE,0))as decimal(18,2)) as RFTax,
cast((isnull((pax.ExtraTax * book.ROE),0) )as decimal(18,2))as XTTax,
0	QTaxBase,	
([CounterCloseTime]) as bookType,
(#temp9.Sector)  as sector,(book.airCode) as code,
(pmt.payment_mode) as mode,(book.flightNo) as filght,
(#temp9.airlinePNR) as airlinePNR, (#temp9.Class) as class, 
(#temp9.flight) as Flight,(#temp9.farebasis) as farebasis,

--sum(isnull(pax.serviceCharge,0) )as ServiceCharge,
case when book.ServiceFee>0 then isnull(pax.ServiceFee,0) else 0 end as ServiceCharge,
 --isnull(pax.ServiceFee,0) as ServiceCharge,
(#temp9.travel) as travelDate, (isnull(book.FlatDiscount,0) + isnull(pax.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2))) as PlbC, 
pax.IATACommission AS IataCommissionC, (case when book.BookingSource!='ManualTicketing' then pax.Markup else 0 end) as IataCommissionV
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,promoCode,#temp9.rbd,book.fromAirport,book.toAirport,book.equipment,
datediff(hour,book.deptTime,book.arrivalTime) as 'FlyingHour',
(ISNULL((select top 1 (case when(count(Code)>1) then 'Air-domestic' else 'Air-Int'end) as sector from sectors  
where ((ltrim(rtrim(Code)) = book.frmSector  or	ltrim(rtrim(Code)) = book.toSector)  AND [Country code]=A.BookingCountry)group by [Country Code]),'Air-Int')) AS 'ProductType',

(case 
WHEN @usertype=2 AND A.UserTypeid=4 THEN 'ADH'
else ISNULL(r.LocationCode,R1.LocationCode)  end) 
AS LocationCode,

(case 
WHEN @usertype=2 AND A.UserTypeid=4 THEN 'BRH103102'
else ISNULL(r.BranchCode,R1.BranchCode) end) 
AS BranchCode,


(case when pmt.payment_mode='passThrough' then 'CUSTOMER' when pmt.payment_mode='Credit' then 'CORPORATE' else 'CASH' end)as FormofPayment,
(case when a.UserTypeID=3 and r.empcodemandate=0 then '' else  m.UserName end)  as [Employee Dimension Code],
case when book.VendorName='TravelFusion' then 'BOMVEND007913' else (SELECT VendorCode FROM tblERPDetails E WHERE E.OwnerID=book.OfficeID and AgentCountry=book.Country and ERPCountry= @country) end AS VendorNo,

(SELECT (case 
WHEN @usertype=2 AND A.UserTypeid=4 THEN 'ICUST28536'
when CustomerCode='AgentCustID'  then ISNULL(r.Icast,R1.Icast) 
else CustomerCode end) as CustomerNumber  FROM tblERPDetails E 
WHERE E.OwnerID=book.OfficeID and AgentCountry=book.Country and ERPCountry= @country) AS CustomerNumber,
O.IATA AS [IATA Code],VendorName,A.userTypeID,book.orderId,book.ROE,book.AgentROE,book.RegistrationNumber,book.CompanyName,book.CAddress,book.CState,book.CContactNo,book.CEmailID
,(isnull(pax.FlatDiscount,0) + isnull(pax.DropnetCommission,0)) as promodiscount,pax.MCOAmount as [MCO amount],pax.MCOTicketNo as  [MCO number]
,pmt.cardtype,pmt.MaskCardNumber AS cardnumber,pax.profession as 'Rankno'
, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp9.PreviousAirlinePNR,
(select sum(SSR_Amount) from tblSSRDetails s
inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid and p.pid=pax.pid
inner join tblBookMaster b on b.pkId=p.fkBookMaster
where (b.orderId=book.orderId) and  SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0 
group by p.pid)  
as [Extra Baggage Amount],    
(select sum(SSR_Amount) from tblSSRDetails s
inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid and p.pid=pax.pid
inner join tblBookMaster b on b.pkId=p.fkBookMaster
where (b.orderId=book.orderId) and  SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0 
group by p.pid)
as [Seat Preference Charge],    
(select sum(SSR_Amount) from tblSSRDetails s
inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid and p.pid=pax.pid
inner join tblBookMaster b on b.pkId=p.fkBookMaster
where (b.orderId=book.orderId) and  SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0 
group by p.pid)
 as [Meal Charges]
,	0 as [Wheel Chair Charges],	0 as [SSR Comb Amount],
 pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId AND AgentID !='B2C' and book.totalFare>0 and pax.totalFare>0
left join mUser m on m.id=book.mainagentid
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join B2BRegistration r on r.FKUserID=book.AgentID
left join agentLogin A on A.UserID=book.AgentID
left join B2BRegistration r1 on r1.FKUserID=A.ParentAgentID
left join PNRRetriveDetails p on p.OrderID=book.orderId
left join  #temp9 on pmt.order_id=#temp9.orderId	
left join tblOwnerCurrency O on O.OfficeID=book.OfficeID
--left join tblSSRDetails SSR on ssr.fkPassengerid=pax.pid and ssr.SSR_Type='Baggage' and ssr.SSR_Status=1 and ssr.SSR_Amount >0
--left join tblSSRDetails SSRMeal on SSRMeal.fkPassengerid=pax.pid and SSRMeal.SSR_Type='Meals' and SSRMeal.SSR_Status=1 and SSRMeal.SSR_Amount>0

where (book.IsBooked=1) AND book.Country in (select C.CountryCode  from mUserCountryMapping UM

INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,book.inserteddate) >=convert(date,@frmDate) and convert(date,book.inserteddate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) 
and (A.UserTypeid=@usertype OR(@usertype=2 AND A.UserTypeid=4))

and book.Country=@country 
and AgentID =(CASE @agentid WHEN '' then agentid else @agentid end) and book.totalFare>0 
and ((BOOK.VendorName!='Amadeus' AND pax.totalFare>0)
OR (BOOK.VendorName='Amadeus' AND PAX.isReturn=0 AND book.BookingSource!='Web') OR  book.BookingSource='Web')


)p 
left join mAttrributesDetails MA ON MA.OrderID=p.OrderID  and ma.ID in
(select top 1 id from mAttrributesDetails where OrderID=p.OrderID order by id desc)

union 

select pid, 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate, LocationCode,
'TKTT' TransactionType, (SELECT VALUE FROM mCommon M WHERE M.ID= P.userTypeID ) AS  AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,
(select TOP 1 currencycode from mcountrycurrency where countrycode=@country) AS CurrencyType,
p.BasicFare,p.YQTax,p.OCTax as [OC tax],p.TaxTotal,p.QTaxBase,
p.TotalFare,	IataCommissionC,''	AdditionalCommissionC, PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare, FormofPayment,
	MarkupOnFare,	MarkupOnTax, p.ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

''	Penalty ,''  as	[MarkupOnCancellation],''	as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
	[Employee Dimension Code],p.promoCode as [TR/PO No.],''	[Card Type],[IATA Code],''	[Contact No.],''[Cancellation Type],
'Travel Next' as [Booking Source Type],''[BTA Sales],VesselName AS	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,p.YrTax,p.XTTax,p.JNTax,p.OCTax,p.INTax ,p.airCode	,
isnull(REPLACE((CASE WHEN p.airCode='SG' THEN 'SG' 
WHEN p.airCode='G8' THEN 'G8' 
WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6E' END) 
ELSE ( case when p.VendorName='Amadeus' AND LEN(P.ticket1)>6 then(
SELECT  _CODE FROM AirlinesName WHERE [AWB Prefix] in (  cast (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 4) as VARCHAR(100)) ))
 else p.airCode   end) END),'?',''),p.airCode) as supplierCode,
VendorNo,CustomerNumber, 
PaxType, '' FromCity,'' ToCity,airlinePNR,rbd,
'' AS 'CRS',p.fromAirport,p.toAirport,p.equipment,'' as baggage,FlyingHour,
ProductType,'PRD100101' AS ProductCode,BranchCode,'' as [Emp Code],
p.RegistrationNumber,p.CompanyName,p.CAddress,p.CState,p.CContactNo,p.CEmailID,
JobCodeBookingGivenBy,VesselName, ReasonofTravel, TravelRequestNumber, CostCenter, BudgetCode, EmpDimession, SwonNo, TravelerType, Location, Department, Grade, 
 ma.Bookedby, Designation, Chargeability, NameofApprover, ReferenceNo, TR_POName, p.RankNo, AType, BookingReceivedDate,P.ROE,P.AgentROE
, promodiscount,p.[MCO amount],p.[MCO number],OfficeID,cardtype as crdtype,cardnumber as crdno
, reScheduleCharge As RescheduleCharges, SupplierPenalty,  RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR  , convert(varchar(11),p.IssueDate,103) as RescheduleDate
, [Extra Baggage Amount],	 [Seat Preference Charge], [Meal Charges], [Wheel Chair Charges],	[SSR Comb Amount],p.YMTax,p.WOTax,p.OBTax,p.RFTax,ma.OBTCno as OBTC
,Traveltype,Changedcostno,Travelduration,TASreqno,Companycodecc,Projectcode,
 AuthCode as [Card Approval Code],ExpiryDate as [Card expiry],MCOMerchantfee as [MCO Merchant fee]
FROM

(select (pax.pid), book.riyaPNR,book.GDSPNR,isnull(book.inserteddate_old,book.inserteddate) as IssueDate, book.GDSPNR as PNR, book.airCode,
(ticketNum) ticket1,(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,

--(pax.basicFare +isnull(pax.Markup,0))  as	BasicFare	,
--(PAX.totalTax) as TaxTotal,
--((pax.totalFare +isnull(pax.Markup,0))-pax.serviceCharge)  as TotalFare,
--cast((CASE WHEN BOOK.B2bFareType=2 or book.B2bFareType=3 THEN (pax.B2BMarkup/isnull(book.AgentROE,0)) ELSE 0 END) as decimal(18,2)) as MarkupOnTax,
--cast(((CASE WHEN BOOK.B2bFareType=1 THEN (pax.B2BMarkup/isnull(book.AgentROE,0)) ELSE 0 END)+PAX.BFC) as decimal(18,2)) as MarkupOnFare,
--(isnull(pax.[YQ],0)) as YQTax,
--(isnull(pax.[YRTax],0)) as YrTax,
--(isnull(pax.[INTax],0)) as INTax,
--(isnull(pax.[JNTax],0)) as JNTax,
--(isnull(pax.[OCTax],0)) as OCTax,

--(isnull(pax.[YMTax],0)) as YMTax,
--(isnull(pax.[WOTax],0)) as WOTax,
--(isnull(pax.[OBTax],0)) as OBTax,
--(isnull(pax.[RFTax],0)) as RFTax,

--(isnull((pax.ExtraTax),0) )as XTTax,
--0	QTaxBase,	


cast(((pax.basicFare+isnull(pax.Markup,0)) * (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end )) as decimal(18,2)) as	BasicFare	,
cast(((PAX.totalTax ) * (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end ))as decimal(18,2)) as TaxTotal,

cast((((pax.totalFare +isnull(pax.Markup,0))  -pax.serviceCharge) * (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end ))as decimal(18,2))  as TotalFare,

cast((isnull((CASE WHEN ((BOOK.B2bFareType=2 or book.B2bFareType=3)and book.BookingSource!='ManualTicketing') THEN  (((pax.B2BMarkup+pax.HupAmount)/isnull(book.AgentROE,0)) * (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end )) when book.BookingSource='ManualTicketing' then pax.Markup ELSE pax.HupAmount END),0))as decimal(18,2)) as MarkupOnTax,
((cast((isnull((CASE WHEN BOOK.B2bFareType=1 THEN  (pax.B2BMarkup/isnull(book.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PAX.BFC)*(select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end )) as MarkupOnFare,
cast((isnull(pax.[YQ] * (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end ),0))as decimal(18,2)) as YQTax,
cast((isnull(pax.[YRTax]* (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end ),0))as decimal(18,2)) as YrTax,
cast((isnull(pax.[INTax]* (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end ),0))as decimal(18,2)) as INTax,
cast((isnull(pax.[JNTax]* (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end ),0) )as decimal(18,2)) as JNTax,
cast((isnull(pax.[OCTax]* (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end ),0))as decimal(18,2)) as OCTax,

cast((isnull(pax.[YMTax]* (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end ),0))as decimal(18,2)) as YMTax,
cast((isnull(pax.[WOTax]* (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end ),0))as decimal(18,2)) as WOTax,
cast((isnull(pax.[OBTax]* (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end ),0))as decimal(18,2)) as OBTax,
cast((isnull(pax.[RFTax]* (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end ),0))as decimal(18,2)) as RFTax,
cast((isnull((pax.ExtraTax * (select case when (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency'and IsActive=1)!=
(select Currency from mCountry where CountryCode=@country) then (SELECT ROE FROM mROEUpdation R
WHERE ISACTIVE=1  AND FLAG=1 AND 
OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) 
AND BaseCurrencyId in (SELECT ID FROM mCommon where Value in (select top 1 Value from mVendorCredential where OfficeId=book.OfficeID and FieldName='Currency' and IsActive=1) )
AND ToCurrencyId in (SELECT ID FROM mCommon where Value in (select Currency from mCountry where CountryCode=@country ))
AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) else 1 end )),0) )as decimal(18,2))as XTTax,
0	QTaxBase,	





([CounterCloseTime]) as bookType,
(#temp9.Sector)  as sector,(book.airCode) as code,
(pmt.payment_mode) as mode,(book.flightNo) as filght,
(#temp9.airlinePNR) as airlinePNR, (#temp9.Class) as class, 
(#temp9.flight) as Flight,(#temp9.farebasis) as farebasis,

--sum(isnull(pax.serviceCharge,0) )as ServiceCharge,
case when book.ServiceFee>0 then isnull(pax.ServiceFee,0) else 0 end as ServiceCharge,
(#temp9.travel) as travelDate, (isnull(book.FlatDiscount,0) + isnull(pax.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2))) as PlbC, 
pax.IATACommission AS IataCommissionC, (case when book.BookingSource!='ManualTicketing' then pax.Markup else 0 end) as IataCommissionV
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,promoCode,#temp9.rbd,book.fromAirport,book.toAirport,book.equipment,
datediff(hour,book.deptTime,book.arrivalTime) as 'FlyingHour',
(ISNULL((select top 1 (case when(count(Code)>1) then 'Air-domestic' else 'Air-Int'end) as sector from sectors  
where ((ltrim(rtrim(Code)) = book.frmSector  or	ltrim(rtrim(Code)) = book.toSector)  AND [Country code]=A.BookingCountry)group by [Country Code]),'Air-Int')) AS 'ProductType',
ISNULL(r.LocationCode,R1.LocationCode) AS LocationCode,ISNULL(r.BranchCode,R1.BranchCode) AS BranchCode,(case when pmt.payment_mode='passThrough' then 'CUSTOMER' when pmt.payment_mode='Credit' then 'CORPORATE' else 'CASH' end)as FormofPayment,
(case when a.UserTypeID=3 and r.empcodemandate=0 then '' else  m.UserName end)as [Employee Dimension Code],
case when book.VendorName='TravelFusion' then 'BOMVEND007913' else (SELECT VendorCode FROM tblERPDetails E WHERE E.OwnerID=book.OfficeID and AgentCountry=book.Country and ERPCountry= @country) end AS VendorNo,

(SELECT (case when CustomerCode='AgentCustID' then ISNULL(r.Icast,R1.Icast) else CustomerCode end) as CustomerNumber  FROM tblERPDetails E 
WHERE E.OwnerID=book.OfficeID and AgentCountry=book.Country and ERPCountry= @country) AS CustomerNumber,
O.IATA AS [IATA Code],VendorName,A.userTypeID,book.orderId,book.ROE,book.AgentROE,book.RegistrationNumber,book.CompanyName,book.CAddress,book.CState,book.CContactNo,book.CEmailID
,(isnull(pax.FlatDiscount,0) + isnull(pax.DropnetCommission,0)) as promodiscount,pax.MCOAmount as [MCO amount],pax.MCOTicketNo as  [MCO number]
,pmt.cardtype,pmt.MaskCardNumber AS cardnumber,pax.profession as 'Rankno'
, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp9.PreviousAirlinePNR,
(select sum(SSR_Amount) from tblSSRDetails s
inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid and p.pid=pax.pid
inner join tblBookMaster b on b.pkId=p.fkBookMaster
where (b.orderId=book.orderId) and  SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0 
group by p.pid)  
as [Extra Baggage Amount],    
(select sum(SSR_Amount) from tblSSRDetails s
inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid and p.pid=pax.pid
inner join tblBookMaster b on b.pkId=p.fkBookMaster
where (b.orderId=book.orderId) and  SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0 
group by p.pid)
as [Seat Preference Charge],    
(select sum(SSR_Amount) from tblSSRDetails s
inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid and p.pid=pax.pid
inner join tblBookMaster b on b.pkId=p.fkBookMaster
where (b.orderId=book.orderId) and  SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0 
group by p.pid)
 as [Meal Charges],	0 as [Wheel Chair Charges],	0 as [SSR Comb Amount],
 pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId AND AgentID !='B2C' and book.totalFare>0 and pax.totalFare>0
left join mUser m on m.id=book.mainagentid
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join B2BRegistration r on r.FKUserID=book.AgentID
left join agentLogin A on A.UserID=book.AgentID
left join B2BRegistration r1 on r1.FKUserID=A.ParentAgentID
left join PNRRetriveDetails p on p.OrderID=book.orderId
left join  #temp9 on pmt.order_id=#temp9.orderId	
left join tblOwnerCurrency O on O.OfficeID=book.OfficeID
--left join tblSSRDetails SSR on ssr.fkPassengerid=pax.pid and SSR_Type='Baggage' and SSR_Status=1 and ssr.SSR_Amount>0
--left join tblSSRDetails SSRMeal on SSRMeal.fkPassengerid=pax.pid and SSRMeal.SSR_Type='Meals' and SSRMeal.SSR_Status=1 and SSRMeal.SSR_Amount>0

where (book.IsBooked=1) AND book.Country in (select C.CountryCode  from mUserCountryMapping UM

INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,book.inserteddate) >=convert(date,@frmDate) and convert(date,book.inserteddate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) and A.UserTypeid=@usertype and 

(BOOK.OfficeID IN ( SELECT OwnerID FROM tblERPDetails WHERE OwnerID= book.OfficeID AND ERPCountry=@country AND AgentCountry=book.Country and OwnerCountry=@country ))

and AgentID =(CASE @agentid WHEN '' then agentid else @agentid end) and book.totalFare>0  
and ((BOOK.VendorName!='Amadeus' AND pax.totalFare>0)
OR (BOOK.VendorName='Amadeus' AND PAX.isReturn=0 AND book.BookingSource!='Web') OR  book.BookingSource='Web')


)p 
left join mAttrributesDetails MA ON MA.OrderID=p.OrderID and ma.ID in
(select top 1 id from mAttrributesDetails where OrderID=p.OrderID order by id desc)

--order by p.IssueDate asc

drop table #temp9






END

ELSE IF(@status=2)--status-refunded
BEGIN
select * into #temp91 from
(
SELECT t.orderId, 
STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
STUFF((SELECT ',' + convert(varchar(11),s.depDate,103)+','+convert(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis,
STUFF((SELECT '/' +  substring(I.cabin,0,2) FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS rbd,
STUFF((SELECT '/' + I.airlinePNR FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS airlinePNR
, t.PreviousAirlinePNR 
FROM tblBookItenary AS t GROUP BY t.orderId, t.PreviousAirlinePNR) X
select pid, 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate, LocationCode,
p.TransactionType, (SELECT VALUE FROM mCommon M WHERE M.ID= P.userTypeID ) AS  AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,
(select TOP 1 currencycode from mcountrycurrency where countrycode=@country) AS CurrencyType,
p.BasicFare,p.YQTax,p.OCTax as [OC tax],p.TaxTotal,p.QTaxBase,
p.TotalFare,	IataCommissionC,''	AdditionalCommissionC, PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare, FormofPayment,
	MarkupOnFare,	MarkupOnTax, p.ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

	Penalty ,[MarkupOnCancellation],CancellationServiceFee	as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
	[Employee Dimension Code],p.promoCode as [TR/PO No.],''	[Card Type],[IATA Code],''	[Contact No.],''[Cancellation Type],
'Travel Next' as [Booking Source Type],''[BTA Sales],VesselName AS	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,p.YrTax,p.XTTax,p.JNTax,p.OCTax,p.INTax ,p.airCode	,
isnull(REPLACE((CASE WHEN p.airCode='SG' THEN 'SG' 
WHEN p.airCode='G8' THEN 'G8' 
WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6E' END) 
ELSE ( case when p.VendorName='Amadeus' then(
SELECT  _CODE FROM AirlinesName WHERE [AWB Prefix] in (  cast (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 4) as float) ))
 else p.airCode   end) END),'?',''),p.airCode)as supplierCode,
VendorNo,CustomerNumber,
PaxType, '' FromCity,'' ToCity,airlinePNR,rbd,
'' AS 'CRS',p.fromAirport,p.toAirport,p.equipment,'' as baggage,FlyingHour,
ProductType,'PRD100101' AS ProductCode,BranchCode,'' as [Emp Code],
p.RegistrationNumber,p.CompanyName,p.CAddress,p.CState,p.CContactNo,p.CEmailID,
JobCodeBookingGivenBy,VesselName, ReasonofTravel, TravelRequestNumber, CostCenter, BudgetCode, EmpDimession, SwonNo, TravelerType, Location, Department, Grade, 
 ma.Bookedby, Designation, Chargeability, NameofApprover, ReferenceNo, TR_POName, p.RankNo, AType, BookingReceivedDate,P.ROE,P.AgentROE,
 promodiscount,p.[MCO amount],p.[MCO number],OfficeID,cardtype as crdtype,cardnumber as crdno
 , reScheduleCharge As RescheduleCharges, SupplierPenalty,  RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR,convert(varchar(11),p.IssueDate,103) as RescheduleDate,
  [Extra Baggage Amount],	 [Seat Preference Charge], [Meal Charges], [Wheel Chair Charges],	[SSR Comb Amount] ,p.YMTax,p.WOTax,p.OBTax,p.RFTax,ma.OBTCno as OBTC
  ,Traveltype,Changedcostno,Travelduration,TASreqno,Companycodecc,Projectcode,
   AuthCode as [Card Approval Code],ExpiryDate as [Card expiry],MCOMerchantfee as [MCO Merchant fee]
FROM

(select distinct (pax.pid), book.riyaPNR,book.GDSPNR,pax.CancelledDate as IssueDate, book.GDSPNR as PNR, book.airCode,
(ticketNum) ticket1,(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
-cast(((pax.basicFare + isnull(pax.Markup,0)) * book.ROE) as decimal(18,2)) as	BasicFare	,
-cast(((PAX.totalTax) * book.ROE)as decimal(18,2)) as TaxTotal,

-cast((((pax.totalFare  + isnull(pax.Markup,0))  -pax.serviceCharge) * book.ROE)as decimal(18,2))  as TotalFare,
-cast((isnull((CASE WHEN ((BOOK.B2bFareType=2 or book.B2bFareType=3) AND book.BookingSource!='ManualTicketing') THEN  ((pax.B2BMarkup+pax.HupAmount + pax.MarkupOnTaxFare)/isnull(book.AgentROE,0)) when book.BookingSource='ManualTicketing' then pax.Markup ELSE pax.HupAmount END),0))as decimal(18,2)) as MarkupOnTax,
-(cast((isnull((CASE WHEN BOOK.B2bFareType=1 THEN  (pax.B2BMarkup/isnull(book.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PAX.BFC + isnull(pax.CancellationMarkup,0)) as MarkupOnFare,
-cast((convert(float,[YQ]* book.ROE))as decimal(18,2)) as YQTax,
-cast((isnull(pax.[YRTax]* book.ROE,0))as decimal(18,2)) as YrTax,
-cast((isnull(pax.[INTax]* book.ROE,0))as decimal(18,2)) as INTax,
-cast((isnull(pax.[JNTax]* book.ROE,0) )as decimal(18,2)) as JNTax,
-cast((isnull(pax.[OCTax]* book.ROE,0))as decimal(18,2)) as OCTax,
-cast((isnull(pax.[YMTax]* book.ROE,0))as decimal(18,2)) as YMTax,
-cast((isnull(pax.[WOTax]* book.ROE,0))as decimal(18,2)) as WOTax,
-cast((isnull(pax.[OBTax]* book.ROE,0))as decimal(18,2)) as OBTax,
-cast((isnull(pax.[RFTax]* book.ROE,0))as decimal(18,2)) as RFTax,
-cast((isnull((pax.ExtraTax * book.ROE),0) )as decimal(18,2))as XTTax,
0	QTaxBase,	
([CounterCloseTime]) as bookType,
(#temp91.Sector)  as sector,(book.airCode) as code,
(pmt.payment_mode) as mode,(book.flightNo) as filght,
(#temp91.airlinePNR) as airlinePNR, (#temp91.Class) as class, 
(#temp91.flight) as Flight,(#temp91.farebasis) as farebasis,

--sum(isnull(pax.serviceCharge,0) )as ServiceCharge,
case when book.ServiceFee>0 then isnull(-pax.ServiceFee,0) else 0 end as ServiceCharge,
(#temp91.travel) as travelDate, 
-(isnull(book.FlatDiscount,0) + isnull(pax.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2))) as PlbC, 
-pax.IATACommission AS IataCommissionC, 
(case when book.BookingSource!='ManualTicketing' then -pax.Markup else 0 end) as IataCommissionV
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,promoCode,#temp91.rbd,book.fromAirport,book.toAirport,book.equipment,
datediff(hour,book.deptTime,book.arrivalTime) as 'FlyingHour',
(ISNULL((select top 1 (case when(count(Code)>1) then 'Air-domestic' else 'Air-Int'end) as sector from sectors  
where ((ltrim(rtrim(Code)) = book.frmSector  or	ltrim(rtrim(Code)) = book.toSector)  AND [Country code]=A.BookingCountry)group by [Country Code]),'Air-Int')) AS 'ProductType',
ISNULL(r.LocationCode,R1.LocationCode) AS LocationCode,ISNULL(r.BranchCode,R1.BranchCode) AS BranchCode,(case when pmt.payment_mode='passThrough' then 'CUSTOMER' when pmt.payment_mode='Credit' then 'CORPORATE' else 'CASH' end)as FormofPayment,
(case when a.UserTypeID=3 and r.empcodemandate=0 then '' else  m.UserName end) as [Employee Dimension Code],
case when book.VendorName='TravelFusion' then 'BOMVEND007913' else (SELECT VendorCode FROM tblERPDetails E WHERE E.OwnerID=book.OfficeID and AgentCountry=book.Country and ERPCountry= @country) end AS VendorNo,

(SELECT (case when CustomerCode='AgentCustID' then ISNULL(r.Icast,R1.Icast) else CustomerCode end) as CustomerNumber  FROM tblERPDetails E 
WHERE E.OwnerID=book.OfficeID and AgentCountry=book.Country and ERPCountry= @country) AS CustomerNumber,
O.IATA  AS [IATA Code],VendorName,A.userTypeID,book.orderId,book.ROE,book.AgentROE,book.RegistrationNumber,book.CompanyName,book.CAddress,book.CState,book.CContactNo,book.CEmailID
,-(isnull(pax.FlatDiscount,0) + isnull(pax.DropnetCommission,0)) as promodiscount,
-pax.MCOAmount as [MCO amount],pax.MCOTicketNo as  [MCO number],pax.CancellationPenalty as Penalty ,pax.CancellationMarkup as [MarkupOnCancellation],
pax.CancellationServiceFee,
pmt.cardtype,pmt.MaskCardNumber AS cardnumber,case when CheckboxVoid=1 then 'VOID' ELSE 'RFND' END  as TransactionType,pax.profession as 'Rankno'
, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp91.PreviousAirlinePNR ,
-(select sum(SSR_Amount) from tblSSRDetails s
inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid and p.pid=pax.pid
inner join tblBookMaster b on b.pkId=p.fkBookMaster
where (b.orderId=book.orderId) and  SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0 
group by p.pid)  
as [Extra Baggage Amount],    
-(select sum(SSR_Amount) from tblSSRDetails s
inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid and p.pid=pax.pid
inner join tblBookMaster b on b.pkId=p.fkBookMaster
where (b.orderId=book.orderId) and  SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0 
group by p.pid)
as [Seat Preference Charge],    
-(select sum(SSR_Amount) from tblSSRDetails s
inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid and p.pid=pax.pid
inner join tblBookMaster b on b.pkId=p.fkBookMaster
where (b.orderId=book.orderId) and  SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0 
group by p.pid)
 as [Meal Charges],	0 as [Wheel Chair Charges],	0 as [SSR Comb Amount],
 pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId AND AgentID !='B2C' and book.totalFare>0 and pax.totalFare>0
left join mUser m on m.id=book.mainagentid
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join B2BRegistration r on r.FKUserID=book.AgentID
left join agentLogin A on A.UserID=book.AgentID
left join B2BRegistration r1 on r1.FKUserID=A.ParentAgentID
left join PNRRetriveDetails p on p.OrderID=book.orderId
left join  #temp91 on pmt.order_id=#temp91.orderId	
left join tblOwnerCurrency O on O.OfficeID=book.OfficeID

--left join tblSSRDetails SSR on ssr.fkPassengerid=pax.pid and SSR_Type='Baggage' and SSR_Status=1 and ssr.SSR_Amount>0
where book.BookingStatus in (4,11) AND book.Country in (select C.CountryCode  from mUserCountryMapping UM

INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,pax.CancelledDate) >=convert(date,@frmDate) and convert(date,pax.CancelledDate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) and A.UserTypeid=@usertype and book.Country=@country 
and AgentID =(CASE @agentid WHEN '' then agentid else @agentid end) and book.totalFare>0 
and ((BOOK.VendorName!='Amadeus' AND pax.totalFare>0)
OR (BOOK.VendorName='Amadeus' AND PAX.isReturn=0 AND book.BookingSource!='Web') OR  book.BookingSource='Web')

)p 
left join mAttrributesDetails MA ON MA.OrderID=p.OrderID 

union 

select pid, 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate, LocationCode,
p.TransactionType, (SELECT VALUE FROM mCommon M WHERE M.ID= P.userTypeID ) AS  AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,
(select TOP 1 currencycode from mcountrycurrency where countrycode=@country) AS CurrencyType,
p.BasicFare,p.YQTax,p.OCTax as [OC tax],p.TaxTotal,p.QTaxBase,
p.TotalFare,	IataCommissionC,''	AdditionalCommissionC, PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare, FormofPayment,
	MarkupOnFare,	MarkupOnTax, p.ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

	Penalty ,	[MarkupOnCancellation],CancellationServiceFee	as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
	[Employee Dimension Code],p.promoCode as [TR/PO No.],''	[Card Type],[IATA Code],''	[Contact No.],''[Cancellation Type],
'Travel Next' as [Booking Source Type],''[BTA Sales],VesselName AS	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,p.YrTax,p.XTTax,p.JNTax,p.OCTax,p.INTax ,p.airCode	,
isnull(REPLACE((CASE WHEN p.airCode='SG' THEN 'SG' 
WHEN p.airCode='G8' THEN 'G8' 
WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6E' END) 
ELSE ( case when p.VendorName='Amadeus' then(
SELECT  _CODE FROM AirlinesName WHERE [AWB Prefix] in (  cast (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 4) as float) ))
 else p.airCode   end) END),'?',''),p.airCode) as supplierCode,
VendorNo,CustomerNumber,
PaxType, '' FromCity,'' ToCity,airlinePNR,rbd,
'' AS 'CRS',p.fromAirport,p.toAirport,p.equipment,'' as baggage,FlyingHour,
ProductType,'PRD100101' AS ProductCode,BranchCode,'' as [Emp Code],
p.RegistrationNumber,p.CompanyName,p.CAddress,p.CState,p.CContactNo,p.CEmailID,
JobCodeBookingGivenBy,VesselName, ReasonofTravel, TravelRequestNumber, CostCenter, BudgetCode, EmpDimession, SwonNo, TravelerType, Location, Department, Grade, 
 ma.Bookedby, Designation, Chargeability, NameofApprover, ReferenceNo, TR_POName, p.RankNo, AType, BookingReceivedDate,P.ROE,P.AgentROE
, promodiscount,p.[MCO amount],p.[MCO number],OfficeID,cardtype as crdtype,cardnumber as crdno
, reScheduleCharge As RescheduleCharges, SupplierPenalty,  RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR ,convert(varchar(11),p.IssueDate,103) as RescheduleDate,

 [Extra Baggage Amount],	 [Seat Preference Charge], [Meal Charges], [Wheel Chair Charges],	[SSR Comb Amount],p.YMTax,p.WOTax,p.OBTax,p.RFTax,ma.OBTCno as OBTC
 ,Traveltype,Changedcostno,Travelduration,TASreqno,Companycodecc,Projectcode,
  AuthCode as [Card Approval Code],ExpiryDate as [Card expiry],MCOMerchantfee as [MCO Merchant fee]
FROM

(select (pax.pid), book.riyaPNR,book.GDSPNR,pax.CancelledDate IssueDate, book.GDSPNR as PNR, book.airCode,
(ticketNum) ticket1,(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
-(pax.basicFare + isnull(pax.Markup,0))  as	BasicFare	,
-(PAX.totalTax) as TaxTotal,
-((pax.totalFare  + isnull(pax.Markup,0))-pax.serviceCharge)  as TotalFare,
-cast((isnull((CASE WHEN ((BOOK.B2bFareType=2 or book.B2bFareType=3) AND book.BookingSource!='ManualTicketing') THEN  ((pax.B2BMarkup+pax.HupAmount+isnull(pax.MarkupOnTaxFare,0))/isnull(book.AgentROE,0)) when book.BookingSource='ManualTicketing' then pax.Markup ELSE pax.HupAmount END),0))as decimal(18,2)) as MarkupOnTax,
-cast(((CASE WHEN BOOK.B2bFareType=1 THEN (pax.B2BMarkup/isnull(book.AgentROE,0)) ELSE 0 END)+PAX.BFC + pax.CancellationMarkup) as decimal(18,2)) as MarkupOnFare,
-(convert(float,[YQ])) as YQTax,
-(isnull(pax.[YRTax],0)) as YrTax,
-(isnull(pax.[INTax],0)) as INTax,
-(isnull(pax.[JNTax],0)) as JNTax,
-(isnull(pax.[OCTax],0)) as OCTax,

-(isnull(pax.[YMTax],0)) as YMTax,
-(isnull(pax.[WOTax],0)) as WOTax,
-(isnull(pax.[OBTax],0)) as OBTax,
-(isnull(pax.[RFTax],0)) as RFTax,
-(isnull((pax.ExtraTax),0) )as XTTax,
0	QTaxBase,	
([CounterCloseTime]) as bookType,
(#temp91.Sector)  as sector,(book.airCode) as code,
(pmt.payment_mode) as mode,(book.flightNo) as filght,
(#temp91.airlinePNR) as airlinePNR, (#temp91.Class) as class, 
(#temp91.flight) as Flight,(#temp91.farebasis) as farebasis,

--sum(isnull(pax.serviceCharge,0) )as ServiceCharge,
case when book.ServiceFee>0 then isnull(-pax.ServiceFee,0) else 0 end as ServiceCharge,
(#temp91.travel) as travelDate, 
-(isnull(book.FlatDiscount,0) + isnull(pax.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2))) as PlbC, 
-pax.IATACommission AS IataCommissionC, 
(case when book.BookingSource!='ManualTicketing' then -pax.Markup else 0 end) as IataCommissionV
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,promoCode,#temp91.rbd,book.fromAirport,book.toAirport,book.equipment,
datediff(hour,book.deptTime,book.arrivalTime) as 'FlyingHour',
(ISNULL((select top 1 (case when(count(Code)>1) then 'Air-domestic' else 'Air-Int'end) as sector from sectors  
where ((ltrim(rtrim(Code)) = book.frmSector  or	ltrim(rtrim(Code)) = book.toSector)  AND [Country code]=A.BookingCountry)group by [Country Code]),'Air-Int')) AS 'ProductType',
ISNULL(r.LocationCode,R1.LocationCode) AS LocationCode,ISNULL(r.BranchCode,R1.BranchCode) AS BranchCode,(case when pmt.payment_mode='passThrough' then 'CUSTOMER' when pmt.payment_mode='Credit' then 'CORPORATE' else 'CASH' end)as FormofPayment,
(case when a.UserTypeID=3 and r.empcodemandate=0 then '' else  m.UserName end)  as [Employee Dimension Code],
case when book.VendorName='TravelFusion' then 'BOMVEND007913' else (SELECT VendorCode FROM tblERPDetails E WHERE E.OwnerID=book.OfficeID and AgentCountry=book.Country and ERPCountry= @country) end AS VendorNo,

(SELECT (case when CustomerCode='AgentCustID' then ISNULL(r.Icast,R1.Icast) else CustomerCode end) as CustomerNumber  FROM tblERPDetails E 
WHERE E.OwnerID=book.OfficeID and AgentCountry=book.Country and ERPCountry= @country) AS CustomerNumber,
O.IATA AS [IATA Code],VendorName,A.userTypeID,book.orderId,book.ROE,book.AgentROE,book.RegistrationNumber,book.CompanyName,book.CAddress,book.CState,book.CContactNo,book.CEmailID
,-(isnull(pax.FlatDiscount,0) + isnull(pax.DropnetCommission,0)) as promodiscount,
-pax.MCOAmount as [MCO amount],pax.MCOTicketNo as  [MCO number],pax.CancellationPenalty as Penalty ,pax.CancellationMarkup as [MarkupOnCancellation]
,pax.CancellationServiceFee,
pmt.cardtype,pmt.MaskCardNumber AS  cardnumber,case when CheckboxVoid=1 then 'VOID' ELSE 'RFND' END  as TransactionType,pax.profession as 'Rankno'
, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp91.PreviousAirlinePNR,
-(select sum(SSR_Amount) from tblSSRDetails s
inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid and p.pid=pax.pid
inner join tblBookMaster b on b.pkId=p.fkBookMaster
where (b.orderId=book.orderId) and  SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0 
group by p.pid)  
as [Extra Baggage Amount],    
-(select sum(SSR_Amount) from tblSSRDetails s
inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid and p.pid=pax.pid
inner join tblBookMaster b on b.pkId=p.fkBookMaster
where (b.orderId=book.orderId) and  SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0 
group by p.pid)
as [Seat Preference Charge],    
-(select sum(SSR_Amount) from tblSSRDetails s
inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid and p.pid=pax.pid
inner join tblBookMaster b on b.pkId=p.fkBookMaster
where (b.orderId=book.orderId) and  SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0 
group by p.pid)
 as [Meal Charges],	0 as [Wheel Chair Charges],	0 as [SSR Comb Amount],
 pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId AND AgentID !='B2C' and book.totalFare>0 and pax.totalFare>0
left join mUser m on m.id=book.mainagentid
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join B2BRegistration r on r.FKUserID=book.AgentID
left join agentLogin A on A.UserID=book.AgentID
left join B2BRegistration r1 on r1.FKUserID=A.ParentAgentID
left join PNRRetriveDetails p on p.OrderID=book.orderId
left join  #temp91 on pmt.order_id=#temp91.orderId	
left join tblOwnerCurrency O on O.OfficeID=book.OfficeID
--left join tblSSRDetails SSR on ssr.fkPassengerid=pax.pid and SSR_Type='Baggage' and SSR_Status=1 and ssr.SSR_Amount>0
where book.BookingStatus in (4,11) AND book.Country in (select C.CountryCode  from mUserCountryMapping UM

INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,pax.CancelledDate) >=convert(date,@frmDate) and convert(date,pax.CancelledDate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) and A.UserTypeid=@usertype and 

(BOOK.OfficeID IN ( SELECT OwnerID FROM tblERPDetails WHERE OwnerID= book.OfficeID AND ERPCountry=@country AND AgentCountry=book.Country and OwnerCountry=@country ))

and AgentID =(CASE @agentid WHEN '' then agentid else @agentid end) and book.totalFare>0 and ((BOOK.VendorName!='Amadeus' AND pax.totalFare>0)
OR (BOOK.VendorName='Amadeus' AND PAX.isReturn=0 AND book.BookingSource!='Web') OR  book.BookingSource='Web')

)p 
left join mAttrributesDetails MA ON MA.OrderID=p.OrderID

--order by p.IssueDate asc

drop table #temp91






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
, t.PreviousAirlinePNR 
FROM tblBookItenary AS t GROUP BY t.orderId, t.PreviousAirlinePNR) X
select 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
'RFND' TransactionType,'B2B' AS  AgentId ,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,(case WHEN OfficeID='DFW1S212A' THEN 'USD' WHEN OfficeID='YWGC4211G' THEN 'CAD' else 'INR' END) AS CurrencyType,(0-p.BasicFare) as BasicFare,(0-p.YQTax) as YQTax ,p.OCTax as [OC tax],
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
'B2C' as [Booking Source Type],''[BTA Sales],VesselName AS	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,(0-p.YrTax) as YrTax,(0-p.XTTax) as XTTax,(0-p.JNTax) as JNTax,(0-p.OCTax) as OCTax,(0-p.INTax) as INTax ,p.airCode	,
--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) as supplierCode,
--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) as VendorNo,
REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') as supplierCode,
--REPLACE((CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) 
-- WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' ELSE 'VEND000180' END),'?','') as VendorNo,
case when Vendor_No is not null then LEFT(Vendor_No, CHARINDEX('-', Vendor_No)-1) else(case WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' 
WHEN P.airCode  in (SELECT AirlineCode1 FROM TblSTSAirLineMaster) then 'RABOM0300004' ELSE '' END) end  as VendorNo,
PaxType, '' FromCity,'' ToCity,orderId,isReturn
,cardtype as crdtype,cardnumber as crdno
, reScheduleCharge As RescheduleCharges, SupplierPenalty,  RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR,

 [Extra Baggage Amount],	 [Seat Preference Charge], [Meal Charges], [Wheel Chair Charges],	[SSR Comb Amount],p.YMTax,p.WOTax,p.OBTax,p.RFTax
 ,Traveltype,Changedcostno,Travelduration,TASreqno,Companycodecc,Projectcode,
  AuthCode as [Card Approval Code],ExpiryDate as [Card expiry],MCOMerchantfee as [MCO Merchant fee]
FROM

(select book.riyaPNR,book.GDSPNR,pax.CancelledDate IssueDate, book.GDSPNR as PNR, book.airCode,
max(ticketNum) ticket1,min(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
(pax.basicFare) as	BasicFare	,(pax.totalTax) TaxTotal,
0	QTaxBase	,((pax.totalFare)-pax.serviceCharge)  as TotalFare,
(convert(float,[YQ])) as YQTax,max([CounterCloseTime]) as bookType,
max(#temp6.Sector)  as sector,max(book.airCode) as code,
max(pmt.payment_mode) as mode,max(flightNo) as filght,
max(#temp6.AIRPNR) as air, max(#temp6.Class) as class, 
max(#temp6.flight) as Flight,max(#temp6.farebasis) as farebasis,
(isnull(pax.[YRTax],0)) as YrTax,(isnull(pax.[INTax],0)) as INTax,
(isnull(pax.[JNTax],0) )as JNTax,(isnull(pax.[OCTax],0)) as OCTax,

(isnull(pax.[YMTax],0)) as YMTax,
(isnull(pax.[WOTax],0)) as WOTax,
(isnull(pax.[OBTax],0)) as OBTax,
(isnull(pax.[RFTax],0)) as RFTax,
(isnull(pax.[ExtraTax],0) )as XTTax,isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
max(#temp6.travel) as travelDate,ch.Panelty as Penalty,ch.CancellationCharge as 'MarkupOnCancellation',
book.orderId,pax.isReturn,(0-(isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2)))) as PlbC, 
pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID as OfficeID,pmt.cardtype,pmt.MaskCardNumber AS cardnumber
, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp6.PreviousAirlinePNR,
ssr.SSR_Amount as [Extra Baggage Amount],	0 as [Seat Preference Charge],	0 as [Meal Charges],	0 as [Wheel Chair Charges],	0 as [SSR Comb Amount],
pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
 
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join  #temp6 on pmt.order_id=#temp6.orderId	
inner join CancellationHistory Ch on ch.OrderId=book.orderId and FlagType=1
left join tblSSRDetails SSR on ssr.fkPassengerid=pax.pid and SSR_Type='Baggage' and SSR_Status=1 and ssr.SSR_Amount>0
--where pax.IsRefunded=1 and book.IsBooked=1
where pax.IsCancelled=0 and pax.isProcessRefund=1 AND  book.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,ch.UpdateDate) >=convert(date,@frmDate) and convert(date,ch.UpdateDate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null )  and A.UserTypeid=@usertype and book.Country=@country
and AgentID =(CASE @agentid WHEN '' then agentid else @agentid end)
group by book.riyaPNR,book.GDSPNR,pax.CancelledDate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,ch.RefundAmount,ch.CancellationCharge,
book.orderId,isReturn,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge, ch.Panelty,pax.Markup
,book.SupplierCode,book.Vendor_No,pax.basicFare,pax.totalTax,pax.totalFare,pax.YQ,pax.YRTax,pax.INTax,pax.JNTax,pax.OCTax,pax.ExtraTax,book.Country,OfficeID,ROE
)p order by mobookingnumber, plbc desc
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
, t.PreviousAirlinePNR 
FROM tblBookItenary AS t GROUP BY t.orderId, t.PreviousAirlinePNR) X
select pid, 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
'TKTT' TransactionType,(SELECT VALUE FROM mCommon M WHERE M.ID= P.userTypeID ) AS  AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

p.FirstName,p.LastName,(case WHEN OfficeID='DFW1S212A' THEN 'USD' WHEN OfficeID='YWGC4211G' THEN 'CAD' else 'INR' END) AS CurrencyType,p.BasicFare,p.YQTax,p.OCTax as [OC tax],p.TaxTotal,p.QTaxBase,
p.TotalFare,	IataCommissionC,''	AdditionalCommissionC, PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare,'CASH' as FormofPayment,
''	MarkupOnFare,	MarkupOnTax, ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

''	Penalty ,''  as	[MarkupOnCancellation],''	as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
''	[Employee Dimension Code],''[TR/PO No.],''	[Card Type],''	[IATA Code],''	[Contact No.],''[Cancellation Type],
'B2C' as [Booking Source Type],''[BTA Sales],VesselName AS	[Vessel Name],''[Narration 1],''[Narration 2],
''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
,p.YrTax,p.XTTax,p.JNTax,p.OCTax,p.INTax ,p.airCode	,
--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) as supplierCode,
--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) as VendorNo,
REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') as supplierCode,
--REPLACE((CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) 
 --WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' ELSE 'VEND000180' END),'?','') as VendorNo,
case when Vendor_No is not null then LEFT(Vendor_No, CHARINDEX('-', Vendor_No)-1) else(case WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) then 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode1 FROM TblSTSAirLineMaster) then 'RAB
OM0300004' ELSE '' END) end  as VendorNo,
PaxType, '' FromCity,'' ToCity,promoCode
, reScheduleCharge As RescheduleCharges, SupplierPenalty,  RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR ,
 AuthCode as [Card Approval Code],ExpiryDate as [Card expiry],MCOMerchantfee as [MCO Merchant fee]
FROM

(select pax.pid, book.riyaPNR,book.GDSPNR,book.inserteddate IssueDate, book.GDSPNR as PNR, book.airCode,
max(ticketNum) ticket1,min(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
sum(pax.basicFare) as	BasicFare	,sum(pax.totalTax) TaxTotal,
0	QTaxBase	,sum((pax.totalFare)-pax.serviceCharge)  as TotalFare,
sum(convert(float,[YQ])) as YQTax,max([CounterCloseTime]) as bookType,
max(#temp7.Sector)  as sector,max(book.airCode) as code,
max(pmt.payment_mode) as mode,max(flightNo) as filght,
max(#temp7.AIRPNR) as air, max(#temp7.Class) as class, 
max(#temp7.flight) as Flight,max(#temp7.farebasis) as farebasis,
sum(isnull(pax.[YRTax],0)) as YrTax,sum(isnull(pax.[INTax],0)) as INTax,
sum(isnull(pax.[JNTax],0) )as JNTax,sum(isnull(pax.[OCTax],0)) as OCTax,

(isnull(pax.[YMTax],0)) as YMTax,
(isnull(pax.[WOTax],0)) as WOTax,
(isnull(pax.[OBTax],0)) as OBTax,
(isnull(pax.[RFTax],0)) as RFTax,
sum(isnull(pax.[ExtraTax],0) )as XTTax,--sum(isnull(pax.serviceCharge,0) )as ServiceCharge,
isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
max(#temp7.travel) as travelDate, (isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + cast(isnull(book.PromoDiscount/BOOK.ROE,0) as decimal(16,2))) as PlbC, 
pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
,book.SupplierCode,book.Vendor_No,book.promoCode,book.Country,book.OfficeID as OfficeID
, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp7.PreviousAirlinePNR,
pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
from tblPassengerBookDetails pax
left join tblBookMaster book on pax.fkBookMaster=book.pkId
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join  #temp7 on pmt.order_id=#temp7.orderId	where (book.IsBooked=1 or book.BookingStatus=1) AND book.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,book.inserteddate) >=convert(date,@frmDate) and convert(date,book.inserteddate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) and PromoDiscount >0  and A.UserTypeid=@usertype and book.Country=@country
and AgentID =(CASE @agentid WHEN '' then agentid else @agentid end)
group by book.riyaPNR,book.GDSPNR,book.inserteddate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,pid,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge





,pax.Markup,book.promoCode
,book.SupplierCode,book.Vendor_No,book.Country,OfficeID,ROE

)p order by mobookingnumber, plbc desc
drop table #temp7
END
END


END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchERPData_NEW3] TO [rt_read]
    AS [dbo];

