
CREATE procedure [dbo].[fetchERPData_test] --'06/21/2018','06/21/2018',1
@frmDate datetime=null,
@toDate datetime=null,
@status tinyint
as
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
		STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis
		FROM tblBookItenary AS t GROUP BY t.orderId) X
		select pid, 'CREDIT' as [TYPE] ,convert(varchar(11),p.IssueDate,103) as IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
		'TKTT' TransactionType,'B2C' AgentId,p.GDSPNR as PNR, p.riyaPNR MoBookingNumber,

		CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END as TicketNumber,

		p.FirstName,p.LastName,'INR' CurrencyType,p.BasicFare,p.YQTax,0 as [OC tax],p.TaxTotal,p.QTaxBase,
		p.TotalFare,	IataCommissionC,''	AdditionalCommissionC, PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
			IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare,'CASH' as FormofPayment,
		''	MarkupOnFare,	MarkupOnTax, ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
		''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
		p.sector as Sector,Flight as FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

		CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END as BookingType,

		''	Penalty ,''  as	[MarkupOnCancellation],''	 as[Service Fee On Cancellation],''	[Mgmt Fee On Cancellation],
		''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
		''	[Employee Dimension Code],''[TR/PO No.],''	[Card Type],''	[IATA Code],''	[Contact No.],''[Cancellation Type],
		'RIYACONNECT' as [Booking Source Type],''[BTA Sales],''	[Vessel Name],''[Narration 1],''[Narration 2],
		''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
		,p.YrTax,p.XTTax,p.JNTax,p.OCTax,p.INTax ,p.airCode	,
		(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ​' END) ELSE p.airCode END) as supplierCode,
		(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272​' END) ELSE 'VEND000180' END) as VendorNo,
		 PaxType, '' FromCity,'' ToCity

		FROM

			(select pax.pid, book.riyaPNR,book.GDSPNR,book.inserteddate IssueDate, book.GDSPNR as PNR, book.airCode,
			max(ticketNum) ticket1,min(ticketNum) as ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
			sum(pax.basicFare) as	BasicFare	,sum(pax.totalTax) TaxTotal,
			0	QTaxBase	,sum(pax.totalFare-pax.serviceCharge)  as TotalFare,
			sum(convert(float,[YQ])) as YQTax,max([CounterCloseTime]) as bookType,
			max(#temp.Sector)  as sector,max(book.airCode) as code,
			max(pmt.payment_mode) as mode,max(flightNo) as filght,
			max(#temp.AIRPNR) as air, max(#temp.Class) as class, 
			max(#temp.flight) as Flight,max(#temp.farebasis) as farebasis,
			sum(isnull(pax.[YRTax],0)) as YrTax,sum(isnull(pax.[INTax],0)) as INTax,
			sum(isnull(pax.[JNTax],0) )as JNTax,sum(isnull(pax.[OCTax],0)) as OCTax,
			sum(isnull(pax.[ExtraTax],0) )as XTTax,--sum(isnull(pax.serviceCharge,0) )as ServiceCharge,
			isnull(round((pax.Markup / 118 * 100),2),0) as ServiceCharge,
			max(#temp.travel) as travelDate, (isnull(book.FlatDiscount,0) + isnull(book.PLBCommission,0) + isnull(book.PromoDiscount,0)) as PlbC, 
			pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	as IataCommissionV,pax.serviceCharge as MarkupOnTax
			,book.SupplierCode,book.VendorCode
			from tblPassengerBookDetails pax
			left join tblBookMaster book on pax.fkBookMaster=book.pkId
			left join Paymentmaster pmt on book.orderId=pmt.order_id
			left join  #temp on pmt.order_id=#temp.orderId	where book.IsBooked=1 
			and (convert(date,book.inserteddate) >=convert(date,@frmDate) and convert(date,book.inserteddate) <=convert(date,@toDate)
			or @frmDate is null and @toDate is null )
			group by book.riyaPNR,book.GDSPNR,book.inserteddate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,pid,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge,pax.Markup
			,book.SupplierCode,book.VendorCode

			)p order by mobookingnumber, plbc desc
		drop table #temp
	END
	
	
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchERPData_test] TO [rt_read]
    AS [dbo];

