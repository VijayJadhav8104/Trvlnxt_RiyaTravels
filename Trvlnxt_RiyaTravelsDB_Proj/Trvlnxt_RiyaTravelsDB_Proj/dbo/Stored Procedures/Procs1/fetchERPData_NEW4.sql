CREATE procedure [dbo].[fetchERPData_NEW4] --[fetchERPData_NEW4]'22-DEC-2020','22-DEC-2020',1,3,'us','2',''
@frmDate datetime=null,
@toDate datetime=null,
@status tinyint,
@Userid int=null,
@country varchar(2)=null,
@usertype varchar(5)=null,
@agentid  varchar(50)
as
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
REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') as supplierCode,
VendorNo,
PaxType, '' FromCity,'' ToCity,airlinePNR,rbd,
'' AS 'CRS',p.fromAirport,p.toAirport,p.equipment,'' as baggage,FlyingHour,
ProductType,'PRD100101' AS ProductCode,BranchCode,'' as [Emp Code],
b.RegistrationNumber,b.CompanyName,b.CAddress,b.CState,b.CContactNo,b.CEmailID,
JobCodeBookingGivenBy,VesselName, ReasonofTravel, TravelRequestNumber, CostCenter, BudgetCode, EmpDimession, SwonNo, TravelerType, Location, Department, Grade, Bookedby, Designation, Chargeability, NameofApprover, ReferenceNo, TR_POName, RankNo, AType, BookingReceivedDate
 
FROM

(select pax.pid, book.riyaPNR,book.GDSPNR,book.inserteddate IssueDate, book.GDSPNR as PNR, book.airCode,
(ticketNum) ticket1,(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
(pax.basicFare) as	BasicFare	,(pax.YRTax + PAX.ExtraTax+ pax.JNTax + pax.OCTax+pax.INTax + pax.YQ) as TaxTotal,
0	QTaxBase	,(pax.totalFare-pax.serviceCharge)  as TotalFare,
(convert(float,[YQ])) as YQTax,([CounterCloseTime]) as bookType,
(#temp9.Sector)  as sector,(book.airCode) as code,
(pmt.payment_mode) as mode,(book.flightNo) as filght,
(#temp9.airlinePNR) as airlinePNR, (#temp9.Class) as class, 
(#temp9.flight) as Flight,(#temp9.farebasis) as farebasis,
(isnull(pax.[YRTax],0)) as YrTax,(isnull(pax.[INTax],0)) as INTax,
(isnull(pax.[JNTax],0) )as JNTax,(isnull(pax.[OCTax],0)) as OCTax,
(isnull(pax.[ExtraTax],0) )as XTTax,--sum(isnull(pax.serviceCharge,0) )as ServiceCharge,
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
(case when book.OfficeID ='DFW1S212A' THEN '45828661' when book.OfficeID ='YWGC4211G' THEN '62500082' when book.OfficeID ='BOMVS34AD' THEN '14369644' when book.OfficeID ='BOMI228DS' THEN '14360102'
when book.OfficeID ='DXBAD3359' THEN '86215290' when book.OfficeID ='NYC1S21E9' THEN '33750021' ELSE '' END) AS [IATA Code],VendorName,A.userTypeID

from tblPassengerBookDetails pax
left join tblBookMaster book on  pax.fkBookMaster=book.pkId AND  AgentID !='B2C'  and book.totalFare>0
left join mUser m on m.id=book.mainagentid
left join Paymentmaster pmt on book.orderId=pmt.order_id
left join B2BRegistration r on r.FKUserID=book.AgentID
left join agentLogin A on A.UserID=book.AgentID
left join B2BRegistration r1 on r1.FKUserID=A.ParentAgentID
left join PNRRetriveDetails p on p.OrderID=book.orderId
left join  #temp9 on pmt.order_id=#temp9.orderId	
where book.IsBooked=1 AND book.Country in (select C.CountryCode  from mUserCountryMapping UM

INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
and (convert(date,book.inserteddate) >=convert(date,@frmDate) and convert(date,book.inserteddate) <=convert(date,@toDate)
or @frmDate is null and @toDate is null ) and A.UserTypeid=@usertype and book.Country=@country 
and AgentID =(CASE @agentid WHEN '' then agentid else @agentid end)


)p 
left join mAttrributesDetails MA ON MA.GDSPNR=p.GDSPNR
inner join tblBookMaster B on b.GDSPNR=p.GDSPNR and b.totalFare>0

order by mobookingnumber, plbc desc
	drop table #temp9
END

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchERPData_NEW4] TO [rt_read]
    AS [dbo];

