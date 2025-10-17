

CREATE PROCEDURE [dbo].[fetchERPData_NEW2] @frmDate datetime=null,
	@toDate datetime=null,
	@status tinyint,
	@Userid int=null,
	@country varchar(2)=null,
	@usertype varchar(5)=null,
	@agentid  varchar(50)
AS
BEGIN
	IF(@usertype='1')
	BEGIN
		IF(@status=1)--status-Ticketed
		BEGIN
			SELECT * into #temp FROM(
				SELECT t.orderId
				, STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector
				, STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight
				, STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS AIRPNR
				, STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class
				, STUFF((SELECT ',' + CONVERT(varchar(11),s.depDate,103)+','+CONVERT(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel
				, STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis
				, STUFF((SELECT '/' + I.airlinePNR FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS airlinePNR
				, STUFF((SELECT '/' + substring(I.cabin,0,2) FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS rbd
				, t.PreviousAirlinePNR
				FROM tblBookItenary AS t WITH(NOLOCK)
				GROUP BY t.orderId, t.PreviousAirlinePNR
			) X

			SELECT 
			p.pid
			, 'CREDIT' AS [TYPE]
			, CONVERT(varchar(11),p.IssueDate,103) AS IssueDate
			, 'BOMRC' LocationCode
			, 'TKTT' TransactionType
			, 'B2C' AgentId
			, p.airlinePNR AS PNR
			, p.riyaPNR MoBookingNumber
			, CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END AS TicketNumber
			, p.FirstName
			, p.LastName
			, (SELECT TOP 1 currencycode FROM mcountrycurrency WITH(NOLOCK) WHERE countrycode=@country) AS CurrencyType
			, p.BasicFare
			, p.YQTax
			, p.OCTax AS [OC tax]
			, p.TaxTotal
			, p.QTaxBase
			, p.TotalFare
			, IataCommissionC
			, '' AdditionalCommissionC
			, PlbC
			, '' FlownIncentiveC
			, '' BoardingIncentiveC
			, IataCommissionV
			, '' AdditionalCommissionV
			, '' PlbV
			, '' FlownIncentiveV
			, '' BoardingIncentiveV
			, '' NetFare
			, 'CASH' AS FormofPayment
			, '' MarkupOnFare
			, MarkupOnTax
			, p.ServiceCharge
			, '' VendorServiceFee
			, '' ManagementFee
			, '' IssuedInExchange
			, '' TourCode
			, '' EqualFareCurrency
			, '' EqulantFare
			, '' FC_STRING
			, p.sector AS Sector
			, Flight AS FlightNumber
			, p.class
			, p.travelDate DateofTravel
			, p.farebasis
			, CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END AS BookingType
			, '' Penalty
			, '' AS [MarkupOnCancellation]
			, '' AS [Service Fee ON Cancellation]
			, '' [Mgmt Fee ON Cancellation]
			, '' [No Show Charge]
			, '' [No Show Airline]
			, '' AdditionalCxlBase
			, '' AdditionalCxlTax
			, '' [VMPD/Exo No.]
			, [Employee Dimension Code]
			, p.promoCode AS [TR/PO No.]
			, '' [Card Type]
			, [IATA Code]
			, '' [Contact No.]
			, '' [Cancellation Type]
			, 'B2C' AS [Booking Source Type]
			, ''[BTA Sales]
			, '' [Vessel Name]
			, '' [Narration 1]
			, '' [Narration 2]
			, '' [EMD Ticket Type]
			, '' [Tax YM]
			, '' [Tax WO]
			, '' [Cust Info1]
			, '' [Cust Info2]
			, '' [Cust Info3]
			, '' [Cust Info4]
			, '' [Cust Info5]
			, p.YrTax
			, p.XTTax
			, p.JNTax
			, p.OCTax
			, p.INTax
			, p.airCode
			, ISNULL(REPLACE((CASE WHEN p.airCode='SG' THEN 'SG' WHEN p.airCode='G8' THEN 'G8' 
					WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6E' END) 
					ELSE ( CASE WHEN p.VendorName='Amadeus' AND Len(p.ticket1)=12 THEN(
					SELECT top 1 _CODE FROM AirlinesName WITH(NOLOCK) WHERE [AWB Prefix] IN (CAST (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 3) AS VARCHAR(100)) ))
					WHEN p.VendorName='Amadeus' AND Len(p.ticket1)!=12 THEN (
					SELECT top 1 _CODE FROM AirlinesName WITH(NOLOCK) WHERE [AWB Prefix] IN (CAST (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 4) AS VARCHAR(100)) )) 
					ELSE p.airCode END) END),'?',''),p.airCode)AS supplierCode
			, PaxType
			, '' FROMCity
			, '' ToCity
			, airlinePNR
			, rbd
			, '' AS 'CRS'
			, p.FROMAirport
			, p.toAirport
			, p.equipment
			, '' AS baggage
			, FlyingHour
			, ProductType
			, 'PRD100101' AS ProductCode
			, 'BOMRC' BranchCode
			, '' [Emp Code]
			, RegistrationNumber
			, CompanyName
			, CAddress
			, CState
			, CContactNo
			, CEmailID
			, JobCodeBookingGivenBy
			, VesselName
			, ReasonofTravel
			, TravelRequestNumber
			, CostCenter
			, BudgetCode
			, EmpDimession
			, SwonNo
			, TravelerType
			, Location
			, Department
			, Grade
			, ma.Bookedby
			, Designation
			, Chargeability
			, NameofApprover
			, ReferenceNo
			, TR_POName
			, RankNo
			, AType
			, BookingReceivedDate
			, P.ROE
			, P.AgentROE
			, VendorNo
			, CustomerNumber
			, promodiscount
			, '' AS 'MCO number'
			, '' AS 'MCO amount'
			, cardtype AS crdtype
			, cardnumber AS crdno
			, reScheduleCharge AS RescheduleCharges
			, SupplierPenalty
			, RescheduleMarkup
			, PreviousRiyaPNR
			, PreviousAirlinePNR
			, CONVERT(varchar(11),p.IssueDate,103) AS RescheduleDate
			, [Extra Baggage Amount]
			, [Seat Preference Charge]
			, [Meal Charges]
			, [Wheel Chair Charges]
			, [SSR Comb Amount]
			, p.YMTax
			, p.WOTax
			, p.OBTax
			, p.RFTax
			, '' AS OBTC
			, Traveltype
			, Changedcostno
			, Travelduration
			, TASreqno
			, Companycodecc
			, Projectcode
			, AuthCode AS [Card Approval Code]
			, ExpiryDate AS [Card expiry]
			, MCOMerchantfee AS [MCO Merchant fee]
			,DropnetCommission
			FROM (
				SELECT 
				book.VendorName
				, pax.pid
				, book.riyaPNR
				, book.GDSPNR
				, book.inserteddate IssueDate
				, book.GDSPNR AS PNR
				, book.airCode
				, (ticketNum) ticket1
				, (ticketNum) AS ticket2
				, pax.paxType PaxType
				, pax.title +' '+ pax.paxFName FirstName
				, pax.paxLName LastName
				, CAST((pax.basicFare * book.ROE) AS decimal(18,2)) AS BasicFare
				, CAST((PAX.totalTax * book.ROE)AS decimal(18,2)) AS TaxTotal
				, CAST(((pax.totalFare-pax.serviceCharge) * book.ROE)AS decimal(18,2))  as TotalFare
				, CAST((CONVERT(float,[YQ]* book.ROE))AS decimal(18,2)) AS YQTax
				, CAST((ISNULL(pax.[YRTax]* book.ROE,0))AS decimal(18,2)) AS YrTax
				, CAST((ISNULL(pax.[INTax]* book.ROE,0))AS decimal(18,2)) AS INTax
				, CAST((ISNULL(pax.[JNTax]* book.ROE,0) )AS decimal(18,2)) AS JNTax
				, CAST((ISNULL(pax.[OCTax]* book.ROE,0))AS decimal(18,2)) AS OCTax
				, CAST((ISNULL(pax.[YMTax]* book.ROE,0))AS decimal(18,2)) AS YMTax
				, CAST((ISNULL(pax.[WOTax]* book.ROE,0))AS decimal(18,2)) AS WOTax
				, CAST((ISNULL(pax.[OBTax]* book.ROE,0))AS decimal(18,2)) AS OBTax
				, CAST((ISNULL(pax.[RFTax]* book.ROE,0))AS decimal(18,2)) AS RFTax
				, CAST((ISNULL((pax.ExtraTax * book.ROE),0) )AS decimal(18,2))AS XTTax
				, 0	QTaxBase
				, ([CounterCloseTime]) AS bookType
				, (#temp.Sector) AS sector
				, (book.airCode) AS code
				, (pmt.payment_mode) AS mode
				, (flightNo) AS filght
				, (#temp.AIRPNR) AS air
				, (#temp.Class) AS class
				, (#temp.flight) AS Flight
				, (#temp.farebasis) AS farebasis
				, ISNULL(ROUND((pax.Markup / 118 * 100),2),0) AS ServiceCharge
				, (#temp.travel) AS travelDate
				, (ISNULL(book.FlatDiscount,0) + ISNULL(book.PLBCommission,0) + CAST(ISNULL(book.PromoDiscount/BOOK.ROE,0) AS decimal(16,2))) AS PlbC
				, pax.IATACommission AS IataCommissionC
				, book.VendorCommissionPercent	AS IataCommissionV
				, pax.serviceCharge AS MarkupOnTax
				, book.SupplierCode
				, book.Vendor_No
				, book.Country
				, book.OfficeID AS OfficeID
				, promoCode
				, #temp.airlinePNR
				, #temp.rbd
				, book.FROMAirport
				, book.toAirport
				, book.equipment
				, DATEDIFF(HOUR,book.deptTime,book.arrivalTime) AS 'FlyingHour'
				, (CASE WHEN counterclosetime=1 THEN 'Air-domestic' ELSE 'Air-Int'END) AS 'ProductType'
				, '' AS [Employee Dimension Code]
				, (CASE WHEN book.OfficeID ='DFW1S212A' THEN '45828661' WHEN book.OfficeID ='YWGC4211G' THEN '62500082' WHEN book.OfficeID ='BOMVS34AD' THEN '14369644' WHEN book.OfficeID ='BOMI228DS' THEN '14360102'
				WHEN book.OfficeID ='DXBAD3359' THEN '86215290' WHEN book.OfficeID ='NYC1S21E9' THEN '33750021' WHEN book.OfficeID ='BOMI228DS' THEN '14360102' ELSE '' END) AS [IATA Code]
				, ROE
				, AgentROE
				--, (SELECT top 1 (case when 
				--	book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'BOMVEND007913'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then 'VEND000178'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then 'VEND00102'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then 'UVEND00066'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then 'CVEND00041'       
				--	else E.VendorCode end) FROM tblERPDetails E WITH(NOLOCK) WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country ) AS VendorNo
				,(Case WHEN book.Country='US' AND book.OfficeID='00FK' THEN 'UVEND01206' 
					when EV.VendorCode is null then					
					  (SELECT top 1 (case when 
					book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'BOMVEND007913'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then 'VEND000178'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then 'VEND00102'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then 'UVEND00066'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then 'CVEND00041'       
					else E.VendorCode end) FROM tblERPDetails E WITH(NOLOCK) WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country )
					ELSE EV.VendorCode end) as VendorNo
				, (SELECT top 1 (CASE WHEN CustomerCode='AgentCustID' THEN 'ICUST35086'
						WHEN CustomerCode='ICUST35086' THEN 'ICUST35086' 
						WHEN CustomerCode='UCUST00027' THEN 'UCUST00373' 
						WHEN CustomerCode='CCUST00002' THEN 'CCUST00091' 
						ELSE CustomerCode END) AS CustomerNumber FROM tblERPDetails E WITH(NOLOCK)
						WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country) AS CustomerNumber
				, book.RegistrationNumber
				, book.CompanyName
				, book.CAddress
				, book.CState
				, book.CContactNo
				, book.CEmailID
				, (ISNULL(pax.FlatDiscount,0) + ISNULL(pax.DropnetCommission,0)) AS promodiscount
				
				, pmt.cardtype
				, pmt.MaskCardNumber AS cardnumber
				, pax.SupplierPenalty
				, pax.reScheduleCharge
				, pax.RescheduleMarkup
				, book.PreviousRiyaPNR
				, #temp.PreviousAirlinePNR
				, ssr.SSR_Amount AS [Extra Baggage Amount]
				, 0 AS [Seat Preference Charge]
				, 0 AS [Meal Charges]
				, 0 AS [Wheel Chair Charges]
				, 0 AS [SSR Comb Amount]
				, pmt.AuthCode
				, pmt.ExpiryDate
				, pax.MCOMerchantfee
				,ISNULL(pax.DropnetCommission,0) AS DropnetCommission
				FROM tblPassengerBookDetails pax WITH(NOLOCK)
				LEFT JOIN tblBookMaster book WITH(NOLOCK) ON pax.fkBookMaster=book.pkId
				LEFT JOIN Paymentmaster pmt WITH(NOLOCK) ON book.orderId=pmt.order_id
				LEFT JOIN UserLogin ul WITH(NOLOCK) ON ul.UserID=book.LoginEmailID
				LEFT JOIN  #temp ON pmt.order_id=#temp.orderId
				LEFT JOIN tblSSRDetails SSR WITH(NOLOCK) ON ssr.fkPassengerid=pax.pid AND SSR_Type='Baggage' AND SSR_Status=1
				LEFT JOIN TblErpVendorCode EV WITH (NOLOCK) on book.OfficeID = EV.OfficeID and book.Country in ('AE')
				WHERE (book.IsBooked=1 OR book.BookingStatus=1)
				AND book.Country IN (SELECT C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
						INNER JOIN mCountry C ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1) 
				AND (CONVERT(date,book.inserteddate) >=CONVERT(date,@frmDate) 
					AND CONVERT(date,book.inserteddate) <=CONVERT(date,@toDate)
					OR @frmDate is null AND @toDate is null)
				AND book.Agentid='B2C' AND book.Country=@country
			) p 
			LEFT JOIN mAttrributesDetails MA ON MA.GDSPNR=p.GDSPNR AND ma.GDSPNR IS NOT NULL

			UNION 

			SELECT 
			p.pid
			, 'CREDIT' AS [TYPE]
			, CONVERT(varchar(11),p.IssueDate,103) AS IssueDate
			, 'BOMRC' LocationCode
			, 'TKTT' TransactionType
			, 'B2C' AgentId
			, p.airlinePNR AS PNR
			, p.riyaPNR MoBookingNumber
			, CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END AS TicketNumber
			, p.FirstName
			, p.LastName
			, (SELECT TOP 1 currencycode FROM mcountrycurrency WITH(NOLOCK) WHERE countrycode=@country) AS CurrencyType
			, p.BasicFare
			, p.YQTax
			, p.OCTax AS [OC tax]
			, p.TaxTotal
			, p.QTaxBase
			, p.TotalFare
			, IataCommissionC
			, '' AdditionalCommissionC
			, PlbC
			, '' FlownIncentiveC
			, '' BoardingIncentiveC
			, IataCommissionV
			, '' AdditionalCommissionV
			, '' PlbV
			, '' FlownIncentiveV
			, '' BoardingIncentiveV
			, '' NetFare
			, 'CASH' AS FormofPayment
			, '' MarkupOnFare
			, MarkupOnTax
			, p.ServiceCharge
			, '' VendorServiceFee
			, '' ManagementFee
			, '' IssuedInExchange
			, '' TourCode
			, '' EqualFareCurrency
			, '' EqulantFare
			, '' FC_STRING
			, p.sector AS Sector
			, Flight AS FlightNumber
			, p.class
			, p.travelDate DateofTravel
			, p.farebasis
			, CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END AS BookingType
			, '' Penalty
			, '' AS	[MarkupOnCancellation]
			, '' AS [Service Fee ON Cancellation]
			, '' [Mgmt Fee ON Cancellation]
			, '' [No Show Charge]
			, '' [No Show Airline]
			, '' AdditionalCxlBase
			, '' AdditionalCxlTax
			, '' [VMPD/Exo No.]
			, [Employee Dimension Code]
			, p.promoCode AS [TR/PO No.]
			, '' [Card Type]
			, [IATA Code]
			, '' [Contact No.]
			, '' [Cancellation Type]
			, 'B2C' AS [Booking Source Type]
			, '' [BTA Sales]
			, '' [Vessel Name]
			, '' [Narration 1]
			, '' [Narration 2]
			, '' [EMD Ticket Type]
			, '' [Tax YM]
			, '' [Tax WO]
			, '' [Cust Info1]
			, '' [Cust Info2]
			, '' [Cust Info3]
			, '' [Cust Info4]
			, '' [Cust Info5]
			, p.YrTax
			, p.XTTax
			, p.JNTax
			, p.OCTax
			, p.INTax
			, p.airCode
			, ISNULL(REPLACE((CASE WHEN p.airCode='SG' THEN 'SG' WHEN p.airCode='G8' THEN 'G8' 
					WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6E' END) 
					ELSE ( CASE WHEN p.VendorName='Amadeus' AND Len(p.ticket1)=12 THEN(
					SELECT top 1 _CODE FROM AirlinesName WITH(NOLOCK) WHERE [AWB Prefix] IN ( CAST (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 3) AS float) ))
					WHEN p.VendorName='Amadeus' AND Len(p.ticket1)!=12 THEN (
					SELECT top 1 _CODE FROM AirlinesName WITH(NOLOCK) WHERE [AWB Prefix] IN ( CAST (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 4) AS float) )) 
					ELSE p.airCode END) END),'?',''),p.airCode) AS supplierCode
			, PaxType
			, '' FROMCity
			, '' ToCity
			, airlinePNR
			, rbd
			, '' AS 'CRS'
			, p.FROMAirport
			, p.toAirport
			, p.equipment
			, '' AS baggage
			, FlyingHour
			, ProductType
			, 'PRD100101' AS ProductCode
			, 'BOMRC' BranchCode
			, '' [Emp Code]
			, RegistrationNumber
			, CompanyName
			, CAddress
			, CState
			, CContactNo
			, CEmailID
			, JobCodeBookingGivenBy
			, VesselName
			, ReasonofTravel
			, TravelRequestNumber
			, CostCenter
			, BudgetCode
			, EmpDimession
			, SwonNo
			, TravelerType
			, Location
			, Department
			, Grade
			, ma.Bookedby
			, Designation
			, Chargeability
			, NameofApprover
			, ReferenceNo
			, TR_POName
			, RankNo
			, AType
			, BookingReceivedDate
			, P.ROE
			, P.AgentROE
			, VendorNo
			, CustomerNumber
			, promodiscount
			, '' AS 'MCO number'
			, '' AS 'MCO amount'
			, cardtype AS crdtype
			, cardnumber AS crdno
			, reScheduleCharge AS RescheduleCharges
			, SupplierPenalty
			, RescheduleMarkup
			, PreviousRiyaPNR
			, PreviousAirlinePNR
			, CONVERT(varchar(11),p.IssueDate,103) AS RescheduleDate 
			, [Extra Baggage Amount]
			, [Seat Preference Charge]
			, [Meal Charges]
			, [Wheel Chair Charges]
			, [SSR Comb Amount]
			, p.YMTax
			, p.WOTax
			, p.OBTax
			, p.RFTax
			, '' AS OBTC
			, Traveltype
			, Changedcostno
			, Travelduration
			, TASreqno
			, Companycodecc
			, Projectcode
			, AuthCode AS [Card Approval Code]
			, ExpiryDate AS [Card expiry]
			, MCOMerchantfee AS [MCO Merchant fee]
			,DropnetCommission
			FROM (
				SELECT 
				book.VendorName
				, pax.pid
				, book.riyaPNR
				, book.GDSPNR
				, book.inserteddate IssueDate
				, book.GDSPNR AS PNR
				, book.airCode
				, (ticketNum) ticket1,(ticketNum) AS ticket2
				, pax.paxType PaxType
				, pax.title +' '+ pax.paxFName FirstName
				, pax.paxLName LastName
				, (pax.basicFare) AS BasicFare
				, (PAX.totalTax) AS TaxTotal
				, (pax.totalFare-pax.serviceCharge) AS TotalFare
				, (CONVERT(float,[YQ])) AS YQTax
				, (ISNULL(pax.[YRTax],0)) AS YrTax
				, (ISNULL(pax.[INTax],0)) AS INTax
				, (ISNULL(pax.[JNTax],0)) AS JNTax
				, (ISNULL(pax.[OCTax],0)) AS OCTax
				, (ISNULL(pax.[YMTax],0)) AS YMTax
				, (ISNULL(pax.[WOTax],0)) AS WOTax
				, (ISNULL(pax.[OBTax],0)) AS OBTax
				, (ISNULL(pax.[RFTax],0)) AS RFTax
				, (ISNULL((pax.ExtraTax),0))AS XTTax
				, 0	QTaxBase
				, ([CounterCloseTime]) AS bookType
				, (#temp.Sector) AS sector
				, (book.airCode) AS code
				, (pmt.payment_mode) AS mode
				, (flightNo) AS filght
				, (#temp.AIRPNR) AS air
				, (#temp.Class) AS class
				, (#temp.flight) AS Flight
				, (#temp.farebasis) AS farebasis
				, ISNULL(ROUND((pax.Markup / 118 * 100),2),0) AS ServiceCharge
				, (#temp.travel) AS travelDate
				, (ISNULL(book.FlatDiscount,0) + ISNULL(book.PLBCommission,0) + CAST(ISNULL(book.PromoDiscount/BOOK.ROE,0) AS decimal(16,2))) AS PlbC
				, pax.IATACommission AS IataCommissionC
				, book.VendorCommissionPercent AS IataCommissionV
				, pax.serviceCharge AS MarkupOnTax
				, book.SupplierCode
				, book.Vendor_No
				, book.Country
				, book.OfficeID AS OfficeID
				, promoCode
				, #temp.airlinePNR
				, #temp.rbd
				, book.FROMAirport
				, book.toAirport
				, book.equipment
				, DATEDIFF(HOUR,book.deptTime,book.arrivalTime) AS 'FlyingHour'
				, (CASE WHEN counterclosetime=1 THEN 'Air-domestic' ELSE 'Air-Int'END) AS 'ProductType'
				, '' AS [Employee Dimension Code]
				, (CASE WHEN book.OfficeID ='DFW1S212A' THEN '45828661' WHEN book.OfficeID ='YWGC4211G' THEN '62500082' WHEN book.OfficeID ='BOMVS34AD' THEN '14369644' WHEN book.OfficeID ='BOMI228DS' THEN '14360102'
						WHEN book.OfficeID ='DXBAD3359' THEN '86215290' WHEN book.OfficeID ='NYC1S21E9' THEN '33750021' WHEN book.OfficeID ='BOMI228DS' THEN '14360102' ELSE '' END) AS [IATA Code]
				, ROE
				, AgentROE
				--, (SELECT top 1 (case when 
				--	book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'BOMVEND007913'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then 'VEND000178'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then 'VEND00102'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then 'UVEND00066'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then 'CVEND00041'       
				--	else E.VendorCode end) FROM tblERPDetails E WITH(NOLOCK) WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country ) AS VendorNo
				,(Case WHEN book.Country='US' AND book.OfficeID='00FK' THEN 'UVEND01206' 
					when EV.VendorCode is null then					
					  (SELECT top 1 (case when 
					book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'BOMVEND007913'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then 'VEND000178'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then 'VEND00102'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then 'UVEND00066'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then 'CVEND00041'       
					else E.VendorCode end) FROM tblERPDetails E WITH(NOLOCK) WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country )
					ELSE EV.VendorCode end) as VendorNo
				, (SELECT top 1 (CASE WHEN CustomerCode='AgentCustID' THEN 'ICUST35086'
						WHEN CustomerCode='ICUST35086' THEN 'ICUST35086' 
						WHEN CustomerCode='UCUST00027' THEN 'UCUST00373' 
						WHEN CustomerCode='CCUST00002' THEN 'CCUST00091' 
						ELSE CustomerCode END) AS CustomerNumber  FROM tblERPDetails E WITH(NOLOCK) 
						WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country) AS CustomerNumber
				, book.RegistrationNumber
				, book.CompanyName
				, book.CAddress
				, book.CState
				, book.CContactNo
				, book.CEmailID
				, (ISNULL(pax.FlatDiscount,0) + ISNULL(pax.DropnetCommission,0)) AS promodiscount				
				, pmt.cardtype
				, pmt.MaskCardNumber AS cardnumber
				, pax.SupplierPenalty
				, pax.reScheduleCharge
				, pax.RescheduleMarkup
				, book.PreviousRiyaPNR
				, #temp.PreviousAirlinePNR
				, ssr.SSR_Amount AS [Extra Baggage Amount]
				, 0 AS [Seat Preference Charge]
				, 0 AS [Meal Charges]
				, 0 AS [Wheel Chair Charges]
				, 0 AS [SSR Comb Amount]
				, pmt.AuthCode
				, pmt.ExpiryDate
				, pax.MCOMerchantfee
				,ISNULL(pax.DropnetCommission,0) AS DropnetCommission
				FROM tblPassengerBookDetails pax WITH(NOLOCK)
				LEFT JOIN tblBookMaster book WITH(NOLOCK) ON pax.fkBookMaster=book.pkId
				LEFT JOIN Paymentmaster pmt WITH(NOLOCK) ON book.orderId=pmt.order_id
				LEFT JOIN UserLogin ul WITH(NOLOCK) ON ul.UserID=book.LoginEmailID
				LEFT JOIN  #temp ON pmt.order_id=#temp.orderId
				LEFT JOIN tblSSRDetails SSR WITH(NOLOCK) ON ssr.fkPassengerid=pax.pid AND SSR_Type='Baggage' AND SSR_Status=1 AND ssr.SSR_Amount>0
				LEFT JOIN TblErpVendorCode EV WITH (NOLOCK) on book.OfficeID = EV.OfficeID and book.Country in ('AE')
				WHERE (book.IsBooked=1 OR book.BookingStatus=1) 
				AND book.Country IN (SELECT C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
						INNER JOIN mCountry C ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1) 
				AND (CONVERT(date,book.inserteddate) >=CONVERT(date,@frmDate) AND CONVERT(date,book.inserteddate) <=CONVERT(date,@toDate)
						OR @frmDate is null AND @toDate is null)
				AND book.Agentid='B2C'
				AND (('RiyaapiTF' IN ( SELECT OwnerID FROM tblERPDetails WITH(NOLOCK) WHERE book.VendorName='TravelFusion' AND OwnerID= 'RiyaapiTF' AND ERPCountry=@country AND AgentCountry=book.Country AND OwnerCountry=@country))
				OR (BOOK.OfficeID IN ( SELECT OwnerID FROM tblERPDetails WITH(NOLOCK) WHERE book.VendorName!='TravelFusion' AND OwnerID= book.OfficeID AND ERPCountry=@country AND AgentCountry=book.Country AND OwnerCountry=@country)))
				--AND (BOOK.OfficeID IN ( SELECT OwnerID FROM tblERPDetails WITH(NOLOCK) WHERE OwnerID= book.OfficeID AND ERPCountry=@country AND AgentCountry='IN' 
				--		AND OwnerCountry=@country AND book.VendorName!='TravelFusion' ))
			) p 
			LEFT JOIN mAttrributesDetails MA ON MA.GDSPNR=p.GDSPNR AND ma.GDSPNR IS NOT NULL
			--order by book.inserteddate
			drop table #temp
		END

		ELSE IF(@status=2)--status-REFUNDED
		BEGIN
			SELECT * into #temp1 FROM
			(
				SELECT t.orderId, 
				STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
				STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
				STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS AIRPNR,
				STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
				STUFF((SELECT ',' + CONVERT(varchar(11),s.depDate,103)+','+CONVERT(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
				STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis,
				STUFF((SELECT '/' + I.airlinePNR FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS airlinePNR,
				STUFF((SELECT '/' + substring(I.cabin,0,2) FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS rbd
				, t.PreviousAirlinePNR
				FROM tblBookItenary AS t WITH(NOLOCK) GROUP BY t.orderId, t.PreviousAirlinePNR
			) X

			SELECT 
			'CREDIT' AS [TYPE]
			, CONVERT(varchar(11),p.IssueDate,103) AS IssueDate
			, 'ICUST35086' CustomerNumber
			, 'BOMRC' LocationCode
			, p.riyaPNR MoBookingNumber
			, 'RFND' TransactionType
			, 'B2C' AgentId,p.airlinePNR AS PNR
			, CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END AS TicketNumber
			, p.FirstName
			, p.LastName
			, (CASE WHEN p.OfficeID='DFW1S212A' THEN 'USD' WHEN p.OfficeID='YWGC4211G' THEN 'CAD' ELSE 'INR' END) AS CurrencyType
			, (0-p.BasicFare) AS BasicFare
			, (0-p.YQTax) AS YQTax
			, p.OCTax AS [OC tax]
			, (0-p.TaxTotal) AS TaxTotal
			, (0-p.QTaxBase) AS QTaxBase
			, (0-p.TotalFare) AS TotalFare
			, IataCommissionC
			, '' AdditionalCommissionC
			, PlbC
			, '' FlownIncentiveC
			, '' BoardingIncentiveC
			, IataCommissionV
			, '' AdditionalCommissionV
			, '' PlbV
			, '' FlownIncentiveV
			, '' BoardingIncentiveV
			, '' NetFare
			, 'CASH' AS FormofPayment
			, '' MarkupOnFare
			, (0-p.ServiceCharge) MarkupOnTax
			, 0 AS ServiceCharge
			, '' VendorServiceFee
			, '' ManagementFee
			, '' IssuedInExchange
			, '' TourCode
			, '' EqualFareCurrency
			, '' EqulantFare
			, '' FC_STRING
			, p.sector AS Sector
			, Flight AS FlightNumber
			, p.class
			, p.travelDate DateofTravel
			, p.farebasis
			, CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END AS BookingType
			, Penalty
			, MarkupOnCancellation
			, '' AS [Service Fee ON Cancellation]
			, '' [Mgmt Fee ON Cancellation]
			, '' [No Show Charge]
			, '' [No Show Airline]
			, '' AdditionalCxlBase
			, '' AdditionalCxlTax
			, '' [VMPD/Exo No.]
			, '' [Employee Dimension Code]
			, p.PromoCode AS [TR/PO No.]
			, '' [Card Type]
			, '' [IATA Code]
			, '' [Contact No.]
			, '' [Cancellation Type]
			, 'B2C' AS [Booking Source Type]
			, '' [BTA Sales]
			, '' [Vessel Name]
			, '' [Narration 1]
			, '' [Narration 2]
			, '' [EMD Ticket Type]
			, '' [Tax YM]
			, '' [Tax WO]
			, '' [Cust Info1]
			, '' [Cust Info2]
			, '' [Cust Info3]
			, '' [Cust Info4]
			, '' [Cust Info5]
			, (0-p.YrTax) AS YrTax
			, (0-p.XTTax) AS XTTax
			, (0-p.JNTax) AS JNTax
			, (0-p.OCTax) AS OCTax
			, (0-p.INTax) AS INTax
			, p.airCode
			--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) AS supplierCode,
			--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) AS VendorNo,
			, REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') AS supplierCode
			, CASE WHEN p.Vendor_No IS NOT NULL THEN LEFT(p.Vendor_No, CHARINDEX('-', p.Vendor_No)-1) 
					ELSE (CASE WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster WITH(NOLOCK)) THEN 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode1 FROM TblSTSAirLineMaster WITH(NOLOCK)) THEN 'RABOM0300004' ELSE '' END) END  as VendorNo
			--REPLACE((CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) 
 			 --WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) THEN 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) THEN 'RABOM0300004' ELSE 'VEND000180' END),'?','') AS VendorNo,
			, PaxType
			, '' FROMCity
			, '' ToCity
			, p.orderId
			, isReturn
			, '' AS 'CRS'
			, p.FROMAirport
			, p.toAirport
			, p.equipment
			, '' AS baggage
			, FlyingHour
			, ProductType
			, 'PRD100101' AS ProductCode
			, '' BranchCode
			, '' [Emp Code]
			, b.RegistrationNumber
			, b.CompanyName
			, b.CAddress
			, b.CState
			, b.CContactNo
			, b.CEmailID
			, JobCodeBookingGivenBy
			, VesselName
			, ReasonofTravel
			, TravelRequestNumber
			, CostCenter
			, BudgetCode
			, EmpDimession
			, SwonNo
			, TravelerType
			, Location
			, Department
			, Grade
			, ma.Bookedby
			, Designation
			, Chargeability
			, NameofApprover
			, ReferenceNo
			, TR_POName
			, RankNo
			, AType
			, BookingReceivedDate
			, P.ROE
			, P.AgentROE
			, '' AS 'MCO number'
			, '' AS 'MCO amount'
			, cardtype AS crdtype
			, cardnumber AS crdno
			, reScheduleCharge AS RescheduleCharges
			, SupplierPenalty
			, RescheduleMarkup
			, p.PreviousRiyaPNR
			, PreviousAirlinePNR
			, CONVERT(varchar(11),p.IssueDate,103) AS RescheduleDate
			, AuthCode AS [Card Approval Code]
			, ExpiryDate AS [Card expiry]
			, MCOMerchantfee AS [MCO Merchant fee]
			, p.YMTax
			, p.WOTax
			, p.OBTax
			, p.RFTax
			, 0 AS [Extra Baggage Amount]
			, 0 AS [Seat Preference Charge]
			, 0 [Meal Charges]
			, 0 AS [Wheel Chair Charges]
			, 0 AS [SSR Comb Amount]
			, p.rbd
			, p.airlinePNR
			, p.PromoDiscount
			, MA.OBTCno AS OBTC
			, Traveltype
			, Changedcostno
			, Travelduration
			, TASreqno
			, Companycodecc
			, Projectcode
			,DropnetCommission
			FROM (
				SELECT book.riyaPNR
				, book.GDSPNR
				, pax.CancelledDate IssueDate
				, book.GDSPNR AS PNR
				, book.airCode
				, MAX(ticketNum) ticket1
				, min(ticketNum) AS ticket2
				, pax.paxType PaxType
				, pax.title +' '+ pax.paxFName FirstName
				, pax.paxLName LastName
				, sum(pax.basicFare) AS	BasicFare
				, sum(pax.totalTax) TaxTotal
				, 0	QTaxBase
				, sum(pax.totalFare-pax.serviceCharge) AS TotalFare
				, sum(CONVERT(float,[YQ])) AS YQTax
				, MAX([CounterCloseTime]) AS bookType
				, MAX(#temp1.Sector) AS sector
				, MAX(book.airCode) AS code
				, MAX(pmt.payment_mode) AS mode
				, MAX(flightNo) AS filght
				, MAX(#temp1.AIRPNR) AS air
				, MAX(#temp1.Class) AS class
				, MAX(#temp1.flight) AS Flight
				, MAX(#temp1.farebasis) AS farebasis
				, sum(ISNULL(pax.[YRTax],0)) AS YrTax
				, sum(ISNULL(pax.[INTax],0)) AS INTax
				, sum(ISNULL(pax.[JNTax],0)) AS JNTax
				, sum(ISNULL(pax.[OCTax],0)) AS OCTax
				, (ISNULL(pax.[YMTax],0)) AS YMTax
				, (ISNULL(pax.[WOTax],0)) AS WOTax
				, (ISNULL(pax.[OBTax],0)) AS OBTax
				, (ISNULL(pax.[RFTax],0)) AS RFTax
				, sum(ISNULL(pax.[ExtraTax],0)) AS XTTax
				, ISNULL(ROUND((pax.Markup / 118 * 100),2),0) AS ServiceCharge
				, MAX(#temp1.travel) AS travelDate
				, ch.Panelty AS Penalty
				, ch.CancellationCharge AS 'MarkupOnCancellation'
				, book.orderId
				, pax.isReturn
				, (0-(ISNULL(book.FlatDiscount,0) + ISNULL(book.PLBCommission,0) + CAST(ISNULL(book.PromoDiscount/BOOK.ROE,0) AS decimal(16,2)))) AS PlbC
				, pax.IATACommission AS IataCommissionC
				, book.VendorCommissionPercent	AS IataCommissionV
				, pax.serviceCharge AS MarkupOnTax
				, book.SupplierCode
				, book.Vendor_No
				, book.Country
				, book.OfficeID AS OfficeID
				, PromoCode
				, #temp1.airlinePNR
				, #temp1.rbd
				, book.FROMAirport
				, book.toAirport
				, book.equipment
				, DATEDIFF(HOUR,book.deptTime,book.arrivalTime) AS 'FlyingHour'
				, (CASE WHEN counterclosetime=1 THEN 'Air-domestic' ELSE 'Air-Int'END) AS 'ProductType'
				, '' AS [Employee Dimension Code]
				, ROE,AgentROE
				, pmt.cardtype
				, pmt.MaskCardNumber AS cardnumber
				, pax.SupplierPenalty
				, pax.reScheduleCharge
				, pax.RescheduleMarkup
				, book.PreviousRiyaPNR
				, #temp1.PreviousAirlinePNR
				, pmt.AuthCode
				, pmt.ExpiryDate
				, pax.MCOMerchantfee
				, book.PromoDiscount
				,ISNULL(pax.DropnetCommission,0) AS DropnetCommission
				FROM tblPassengerBookDetails pax WITH(NOLOCK)
				LEFT JOIN tblBookMaster book WITH(NOLOCK) ON pax.fkBookMaster=book.pkId
				LEFT JOIN Paymentmaster pmt WITH(NOLOCK) ON book.orderId=pmt.order_id
				LEFT JOIN UserLogin ul WITH(NOLOCK) ON ul.UserID=book.LoginEmailID
				LEFT JOIN  #temp1 ON pmt.order_id=#temp1.orderId	
				INNER JOIN CancellationHistory Ch WITH(NOLOCK) ON ch.OrderId=book.orderId AND FlagType=2
				WHERE pax.IsRefunded=1 
				AND (book.IsBooked=1 OR book.BookingStatus=1)  
				AND book.Country IN (SELECT C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
							INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1)
				AND (CONVERT(date,pax.RefundedDate) >=CONVERT(date,@frmDate) AND CONVERT(date,pax.RefundedDate) <=CONVERT(date,@toDate)
					OR @frmDate IS NULL AND @toDate IS NULL) 
				AND book.Agentid='B2C' AND book.Country=@country
				group by book.riyaPNR,book.GDSPNR,pax.CancelledDate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,ch.RefundAmount,ch.CancellationCharge
				, book.orderId,isReturn,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge, ch.Panelty,pax.Markup
				, book.SupplierCode,book.Vendor_No,book.Country,OfficeID,ROE,PromoCode,airlinePNR,rbd, book.FROMAirport,book.toAirport,book.equipment,book.deptTime,book.arrivalTime,book.frmSector,book.toSector,book.counterclosetime,ul.UserName
				, ROE,AgentROE
				, pax.YMTax,pax.[WOTax],pax.[OBTax],pax.[RFTax],pmt.cardtype,pmt.MaskCardNumber,pax.SupplierPenalty,pax.reScheduleCharge, pax.RescheduleMarkup
				, book.PreviousRiyaPNR,#temp1.PreviousAirlinePNR,pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee,pax.DropnetCommission
			) p 
			LEFT JOIN mAttrributesDetails MA WITH(NOLOCK) ON MA.GDSPNR=p.GDSPNR AND ma.GDSPNR IS NOT NULL
			INNER JOIN tblBookMaster B WITH(NOLOCK) ON b.GDSPNR=p.GDSPNR
			order by inserteddate

			drop table #temp1
		END

		--status 3 Pre refund
		ELSE IF(@status=3)--Pre refund
		BEGIN
			SELECT * into #temp2 FROM(
				SELECT t.orderId, 
				STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
				STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
				STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS AIRPNR,
				STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
				STUFF((SELECT ',' + CONVERT(varchar(11),s.depDate,103)+','+CONVERT(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
				STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis,
				STUFF((SELECT '/' + I.airlinePNR FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS airlinePNR,
				STUFF((SELECT '/' + substring(I.cabin,0,2) FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS rbd
				, t.PreviousAirlinePNR 
				FROM tblBookItenary AS t WITH(NOLOCK) GROUP BY t.orderId, t.PreviousAirlinePNR
			) X

			SELECT 
			'CREDIT' AS [TYPE]
			, CONVERT(varchar(11),p.IssueDate,103) AS IssueDate
			, 'ICUST35086' CustomerNumber
			, 'BOMRC' LocationCode
			, 'RFND' TransactionType
			, 'B2C' AgentId
			, p.airlinePNR AS PNR
			, p.riyaPNR MoBookingNumber
			, CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END AS TicketNumber
			, p.FirstName
			, p.LastName
			, (CASE WHEN p.OfficeID='DFW1S212A' THEN 'USD' WHEN p.OfficeID='YWGC4211G' THEN 'CAD' ELSE 'INR' END) AS CurrencyType
			, (0-p.BasicFare) AS BasicFare
			, (0-p.YQTax) AS YQTax
			, p.OCTax AS [OC tax]
			, (0-p.TaxTotal) AS TaxTotal
			, (0-p.QTaxBase) AS QTaxBase
			, (0-p.TotalFare) AS TotalFare
			, IataCommissionC
			, '' AdditionalCommissionC
			, PlbC
			, '' FlownIncentiveC
			, '' BoardingIncentiveC
			, IataCommissionV
			, '' AdditionalCommissionV
			, '' PlbV
			, '' FlownIncentiveV
			, '' BoardingIncentiveV
			, '' NetFare
			, 'CASH' AS FormofPayment
			, '' MarkupOnFare
			, (0-p.ServiceCharge) MarkupOnTax
			, 0 AS ServiceCharge
			, '' VendorServiceFee
			, '' ManagementFee
			, '' IssuedInExchange
			, '' TourCode
			, '' EqualFareCurrency
			, '' EqulantFare
			, '' FC_STRING
			, p.sector AS Sector
			, Flight AS FlightNumber
			, p.class
			, p.travelDate DateofTravel
			, p.farebasis
			, CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END AS BookingType
			, Penalty
			, MarkupOnCancellation
			, '' AS [Service Fee ON Cancellation]
			, '' [Mgmt Fee ON Cancellation]
			, '' [No Show Charge]
			, '' [No Show Airline]
			, '' AdditionalCxlBase
			, '' AdditionalCxlTax
			, '' [VMPD/Exo No.]
			, '' [Employee Dimension Code]
			, '' [TR/PO No.]
			, '' [Card Type]
			, '' [IATA Code]
			, '' [Contact No.]
			, '' [Cancellation Type]
			, 'B2C' AS [Booking Source Type]
			, '' [BTA Sales]
			, '' [Vessel Name]
			, '' [Narration 1]
			, '' [Narration 2]
			, '' [EMD Ticket Type]
			, '' [Tax YM]
			, '' [Tax WO]
			, '' [Cust Info1]
			, '' [Cust Info2]
			, '' [Cust Info3]
			, '' [Cust Info4]
			, '' [Cust Info5]
			, (0-p.YrTax) AS YrTax
			, (0-p.XTTax) AS XTTax
			, (0-p.JNTax) AS JNTax
			, (0-p.OCTax) AS OCTax
			, (0-p.INTax) AS INTax
			, p.airCode
			--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) AS supplierCode,
			--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) AS VendorNo,
			, REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') AS supplierCode
			--REPLACE((CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) 
			-- WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) THEN 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) THEN 'RABOM0300004' ELSE 'VEND000180' END),'?','') AS VendorNo,
			, CASE WHEN p.Vendor_No IS NOT NULL THEN LEFT(p.Vendor_No, CHARINDEX('-', p.Vendor_No)-1) ELSE(CASE WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster WITH(NOLOCK)) THEN 'RABOM0300004' 
				WHEN P.airCode IN (SELECT AirlineCode1 FROM TblSTSAirLineMaster WITH(NOLOCK)) THEN 'RABOM0300004' ELSE '' END) END  as VendorNo
			, PaxType
			, '' FROMCity
			, '' ToCity
			, p.orderId
			, isReturn
			, airlinePNR
			, rbd
			, '' AS 'CRS'
			, p.FROMAirport
			, p.toAirport
			, p.equipment
			, '' AS baggage
			, FlyingHour
			, ProductType
			, 'PRD100101' AS ProductCode
			, 'BOMRC' BranchCode
			, '' [Emp Code]
			, b.RegistrationNumber
			, b.CompanyName
			, b.CAddress
			, b.CState
			, b.CContactNo
			, b.CEmailID
			, JobCodeBookingGivenBy
			, VesselName
			, ReasonofTravel
			, TravelRequestNumber
			, CostCenter
			, BudgetCode
			, EmpDimession
			, SwonNo
			, TravelerType
			, Location
			, Department
			, Grade
			, ma.Bookedby
			, Designation
			, Chargeability
			, NameofApprover
			, ReferenceNo
			, TR_POName
			, RankNo
			, AType
			, BookingReceivedDate
			, P.ROE
			, P.AgentROE
			, '' AS 'MCO number'
			, '' AS 'MCO amount'
			, cardtype AS crdtype
			, cardnumber AS crdno
			, reScheduleCharge AS RescheduleCharges
			, SupplierPenalty
			, RescheduleMarkup
			, p.PreviousRiyaPNR
			, PreviousAirlinePNR
			, CONVERT(varchar(11),p.IssueDate,103) AS RescheduleDate
			, AuthCode AS [Card Approval Code]
			, ExpiryDate AS [Card expiry]
			, MCOMerchantfee AS [MCO Merchant fee]
			,DropnetCommission
			FROM (
				SELECT 
				book.riyaPNR
				, book.GDSPNR
				, pax.CancelledDate IssueDate
				, book.GDSPNR AS PNR
				, book.airCode
				, MAX(ticketNum) ticket1,min(ticketNum) AS ticket2
				, pax.paxType PaxType
				, pax.title +' '+ pax.paxFName FirstName
				, pax.paxLName LastName
				, (pax.basicFare) AS BasicFare
				, (pax.totalTax) TaxTotal
				, 0	QTaxBase
				, (pax.totalFare-pax.serviceCharge) AS TotalFare
				, (CONVERT(float,[YQ])) AS YQTax
				, MAX([CounterCloseTime]) AS bookType
				, MAX(#temp2.Sector) AS sector
				, MAX(book.airCode) AS code
				, MAX(pmt.payment_mode) AS mode
				, MAX(flightNo) AS filght
				, MAX(#temp2.AIRPNR) AS air
				, MAX(#temp2.Class) AS class
				, MAX(#temp2.flight) AS Flight
				, MAX(#temp2.farebasis) AS farebasis
				, (ISNULL(pax.[YRTax],0)) AS YrTax
				, (ISNULL(pax.[INTax],0)) AS INTax
				, (ISNULL(pax.[JNTax],0))AS JNTax
				, (ISNULL(pax.[OCTax],0)) AS OCTax
				, (ISNULL(pax.[YMTax],0)) AS YMTax
				, (ISNULL(pax.[WOTax],0)) AS WOTax
				, (ISNULL(pax.[OBTax],0)) AS OBTax
				, (ISNULL(pax.[RFTax],0)) AS RFTax
				, (ISNULL(pax.[ExtraTax],0)) AS XTTax
				, ISNULL(ROUND((pax.Markup / 118 * 100),2),0) AS ServiceCharge
				, MAX(#temp2.travel) AS travelDate
				, ch.Panelty AS Penalty
				, ch.CancellationCharge AS 'MarkupOnCancellation'
				, book.orderId
				, pax.isReturn
				, (0-(ISNULL(book.FlatDiscount,0) + ISNULL(book.PLBCommission,0) + CAST(ISNULL(book.PromoDiscount/BOOK.ROE,0) AS decimal(16,2)))) AS PlbC
				, pax.IATACommission AS IataCommissionC
				, book.VendorCommissionPercent AS IataCommissionV
				, pax.serviceCharge AS MarkupOnTax
				, book.SupplierCode
				, book.Vendor_No
				, book.Country
				, book.OfficeID AS OfficeID
				, #temp2.airlinePNR
				, #temp2.rbd
				, book.FROMAirport
				, book.toAirport
				, book.equipment
				, DATEDIFF(HOUR,book.deptTime,book.arrivalTime) AS 'FlyingHour'
				, (CASE WHEN counterclosetime=1 THEN 'Air-domestic' ELSE 'Air-Int'END) AS 'ProductType'
				, '' AS [Employee Dimension Code]
				, (CASE WHEN OfficeID ='DFW1S212A' THEN '45828661' WHEN OfficeID ='YWGC4211G' THEN '62500082' WHEN OfficeID ='BOMVS34AD' THEN '14369644' WHEN OfficeID ='BOMI228DS' THEN '14360102'
						WHEN OfficeID ='DXBAD3359' THEN '86215290' WHEN OfficeID ='NYC1S21E9' THEN '33750021' ELSE '' END) AS [IATA Code]
				, ROE
				, AgentROE
				, pmt.cardtype
				, pmt.MaskCardNumber AS cardnumber
				, pax.SupplierPenalty
				, pax.reScheduleCharge
				, pax.RescheduleMarkup
				, book.PreviousRiyaPNR
				, #temp2.PreviousAirlinePNR 
				, pmt.AuthCode
				, pmt.ExpiryDate
				, pax.MCOMerchantfee
				,ISNULL(pax.DropnetCommission,0) AS DropnetCommission
				FROM tblPassengerBookDetails pax WITH(NOLOCK)
				LEFT JOIN tblBookMaster book WITH(NOLOCK) ON pax.fkBookMaster=book.pkId
				LEFT JOIN Paymentmaster pmt WITH(NOLOCK) ON book.orderId=pmt.order_id
				LEFT JOIN UserLogin ul WITH(NOLOCK) ON ul.UserID=book.LoginEmailID
				LEFT JOIN  #temp2 ON pmt.order_id=#temp2.orderId	
				INNER JOIN CancellationHistory Ch WITH(NOLOCK) ON ch.OrderId=book.orderId AND FlagType=1
				--WHERE pax.IsRefunded=1 AND book.IsBooked=1
				WHERE pax.IsCancelled=0
				AND pax.isProcessRefund=1
				AND book.Country IN (SELECT C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
						INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1) 
				AND (CONVERT(date,ch.UpdateDate) >=CONVERT(date,@frmDate) AND CONVERT(date,ch.UpdateDate) <=CONVERT(date,@toDate)
						OR @frmDate is null AND @toDate is null)
				AND book.Agentid='B2C' AND book.Country=@country
				group by book.riyaPNR,book.GDSPNR,pax.CancelledDate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,ch.RefundAmount,ch.CancellationCharge,
					book.orderId,isReturn,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge, ch.Panelty,pax.Markup
					,book.SupplierCode,book.Vendor_No,pax.basicFare,pax.totalTax,pax.totalFare,pax.YQ,pax.YRTax,pax.INTax,pax.JNTax,pax.OCTax,pax.ExtraTax,book.Country,OfficeID,ROE,
					airlinePNR,rbd,book.airCode,book.FROMAirport,book.toAirport,book.equipment,book.deptTime,book.arrivalTime,book.frmSector,book.toSector,book.counterclosetime,ul.UserName
					,ROE,AgentROE
			) p 
			LEFT JOIN mAttrributesDetails MA ON MA.GDSPNR=p.GDSPNR AND ma.GDSPNR IS NOT NULL
			INNER JOIN tblBookMaster B ON b.GDSPNR=p.GDSPNR
			order by inserteddate

			drop table #temp2
 		END

 		ELSE IF(@status=4)--status-PromoCode
		BEGIN
			SELECT * into #temp4 FROM
			(
				SELECT t.orderId, 
				STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
				STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
				STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS AIRPNR,
				STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
				STUFF((SELECT ',' + CONVERT(varchar(11),s.depDate,103)+','+CONVERT(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
				STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis
				, t.PreviousAirlinePNR 
				FROM tblBookItenary AS t WITH(NOLOCK) GROUP BY t.orderId, t.PreviousAirlinePNR
			) X

			SELECT 
			p.pid
			, 'CREDIT' AS [TYPE]
			, CONVERT(varchar(11),p.IssueDate,103) AS IssueDate
			, 'ICUST35086' CustomerNumber
			, 'BOMRC' LocationCode
			, 'TKTT' TransactionType
			, 'B2C' AgentId
			, p.air AS PNR
			, p.riyaPNR MoBookingNumber
			, CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END AS TicketNumber
			, p.FirstName
			, p.LastName
			, (CASE WHEN OfficeID='DFW1S212A' THEN 'USD' WHEN OfficeID='YWGC4211G' THEN 'CAD' ELSE 'INR' END) AS CurrencyType
			, p.BasicFare
			, p.YQTax
			, p.OCTax AS [OC tax]
			, p.TaxTotal
			, p.QTaxBase
			, p.TotalFare
			, IataCommissionC
			, '' AdditionalCommissionC
			, PlbC
			, '' FlownIncentiveC
			, '' BoardingIncentiveC
			, IataCommissionV
			, '' AdditionalCommissionV
			, '' PlbV
			, '' FlownIncentiveV
			, '' BoardingIncentiveV
			, '' NetFare
			, 'CASH' AS FormofPayment
			, '' MarkupOnFare
			, MarkupOnTax
			, ServiceCharge
			, '' VendorServiceFee
			, '' ManagementFee
			, '' IssuedInExchange
			, '' TourCode
			, '' EqualFareCurrency
			, '' EqulantFare
			, '' FC_STRING
			, p.sector AS Sector
			, Flight AS FlightNumber
			, p.class
			, p.travelDate DateofTravel
			, p.farebasis
			, CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END AS BookingType
			, '' Penalty
			, '' AS [MarkupOnCancellation]
			, '' AS [Service Fee ON Cancellation]
			, '' [Mgmt Fee ON Cancellation]
			, '' [No Show Charge]
			, '' [No Show Airline]
			, '' AdditionalCxlBase
			, '' AdditionalCxlTax
			, '' [VMPD/Exo No.]
			, '' [Employee Dimension Code]
			, '' [TR/PO No.]
			, '' [Card Type]
			, '' [IATA Code]
			, '' [Contact No.]
			, '' [Cancellation Type]
			, 'B2C' AS [Booking Source Type]
			, '' [BTA Sales]
			, '' [Vessel Name]
			, '' [Narration 1]
			, '' [Narration 2]
			, '' [EMD Ticket Type]
			, '' [Tax YM]
			, '' [Tax WO]
			, '' [Cust Info1]
			, '' [Cust Info2]
			, '' [Cust Info3]
			, '' [Cust Info4]
			, '' [Cust Info5]
			, p.YrTax
			, p.XTTax
			, p.JNTax
			, p.OCTax
			, p.INTax
			, p.airCode
			--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) AS supplierCode,
			--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) AS VendorNo,
			, REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') AS supplierCode
			--REPLACE((CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) 
 			 --WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) THEN 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) THEN 'RABOM0300004' ELSE 'VEND000180' END),'?','') AS VendorNo,
			, CASE WHEN Vendor_No IS NOT NULL THEN LEFT(Vendor_No, CHARINDEX('-', Vendor_No)-1) 
					ELSE(CASE WHEN P.airCode IN (SELECT AirlineCode FROM TblSTSAirLineMaster WITH(NOLOCK)) THEN 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode1 FROM TblSTSAirLineMaster WITH(NOLOCK)) THEN 'RAB
					OM0300004' ELSE '' END) END AS VendorNo
			, PaxType
			, '' FROMCity
			, '' ToCity
			, promoCode
			, p.ROE
			, p.AgentROE
			, '' AS 'MCO number'
			, '' AS 'MCO amount'
			, cardtype AS crdtype
			, cardnumber AS crdno
			, reScheduleCharge AS RescheduleCharges
			, SupplierPenalty
			, RescheduleMarkup
			, PreviousRiyaPNR
			, PreviousAirlinePNR
			, CONVERT(varchar(11),p.IssueDate,103) AS RescheduleDate
			, [Extra Baggage Amount]
			, [Seat Preference Charge]
			, [Meal Charges]
			, [Wheel Chair Charges]
			, [SSR Comb Amount]
			, p.YMTax
			, p.WOTax
			, p.OBTax
			, p.RFTax
			, '' AS Traveltype
			, '' AS Changedcostno
			, '' AS Travelduration
			, '' AS TASreqno
			, '' AS Companycodecc
			, '' AS Projectcode
			, AuthCode AS [Card Approval Code]
			, ExpiryDate AS [Card expiry]
			, MCOMerchantfee AS [MCO Merchant fee]
			,DropnetCommission
			FROM (
				SELECT 
				pax.pid
				, book.riyaPNR
				, book.GDSPNR
				, book.inserteddate IssueDate
				, book.GDSPNR AS PNR
				, book.airCode
				, MAX(ticketNum) ticket1
				, min(ticketNum) AS ticket2
				, pax.paxType PaxType
				, pax.title +' '+ pax.paxFName FirstName
				, pax.paxLName LastName
				, sum(pax.basicFare) AS	BasicFare
				, sum(pax.totalTax) TaxTotal
				, 0	QTaxBase
				, sum(pax.totalFare-pax.serviceCharge) AS TotalFare
				, sum(CONVERT(float,[YQ])) AS YQTax
				, MAX([CounterCloseTime]) AS bookType
				, MAX(#temp4.Sector) AS sector
				, MAX(book.airCode) AS code
				, MAX(pmt.payment_mode) AS mode
				, MAX(flightNo) AS filght
				, MAX(#temp4.AIRPNR) AS air
				, MAX(#temp4.Class) AS class
				, MAX(#temp4.flight) AS Flight
				, MAX(#temp4.farebasis) AS farebasis
				, sum(ISNULL(pax.[YRTax],0)) AS YrTax
				, sum(ISNULL(pax.[INTax],0)) AS INTax
				, sum(ISNULL(pax.[JNTax],0)) AS JNTax
				, sum(ISNULL(pax.[OCTax],0)) AS OCTax
				, (ISNULL(pax.[YMTax],0)) AS YMTax
				, (ISNULL(pax.[WOTax],0)) AS WOTax
				, (ISNULL(pax.[OBTax],0)) AS OBTax
				, (ISNULL(pax.[RFTax],0)) AS RFTax
				, sum(ISNULL(pax.[ExtraTax],0)) AS XTTax
				--sum(ISNULL(pax.serviceCharge,0) )AS ServiceCharge,
				, ISNULL(ROUND((pax.Markup / 118 * 100),2),0) AS ServiceCharge
				, MAX(#temp4.travel) AS travelDate
				, (ISNULL(book.FlatDiscount,0) + ISNULL(book.PLBCommission,0) + CAST(ISNULL(book.PromoDiscount/BOOK.ROE,0) AS decimal(16,2))) AS PlbC
				, pax.IATACommission AS IataCommissionC
				, book.VendorCommissionPercent AS IataCommissionV
				, pax.serviceCharge AS MarkupOnTax
				, book.SupplierCode
				, book.Vendor_No
				, book.promoCode
				, book.Country
				, book.OfficeID AS OfficeID
				, pmt.cardtype
				, pmt.MaskCardNumber AS cardnumber
				, pax.SupplierPenalty
				, pax.reScheduleCharge
				, pax.RescheduleMarkup
				, book.PreviousRiyaPNR
				, #temp4.PreviousAirlinePNR
				, ssr.SSR_Amount AS [Extra Baggage Amount]
				, 0 AS [Seat Preference Charge]
				, 0 AS [Meal Charges]
				, 0 AS [Wheel Chair Charges]
				, 0 AS [SSR Comb Amount]
				, pmt.AuthCode
				, pmt.ExpiryDate
				, pax.MCOMerchantfee
				,ISNULL(pax.DropnetCommission,0) AS DropnetCommission
				FROM tblPassengerBookDetails pax WITH(NOLOCK)
				LEFT JOIN tblBookMaster book WITH(NOLOCK) ON pax.fkBookMaster=book.pkId
				LEFT JOIN Paymentmaster pmt WITH(NOLOCK) ON book.orderId=pmt.order_id
				LEFT JOIN  #temp4 ON pmt.order_id=#temp4.orderId
				LEFT JOIN tblSSRDetails SSR WITH(NOLOCK) ON ssr.fkPassengerid=pax.pid AND SSR_Type='Baggage' AND SSR_Status=1 AND ssr.SSR_Amount>0
				WHERE (book.IsBooked=1 OR book.BookingStatus=1)
				AND book.Country IN (SELECT C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
						INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1) 
				AND (CONVERT(date,book.inserteddate) >=CONVERT(date,@frmDate) AND CONVERT(date,book.inserteddate) <=CONVERT(date,@toDate)
						OR @frmDate is null AND @toDate is null)
				AND PromoDiscount > 0 
				AND book.Agentid='B2C'
				AND book.Country=@country
				group by book.riyaPNR,book.GDSPNR,book.inserteddate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,pid,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge
				,pax.Markup,book.promoCode,book.SupplierCode,book.Vendor_No,book.Country,OfficeID,ROE,AgentROE
			) p 
			order by inserteddate
			drop table #temp4
		END
	END
	ELSE
	BEGIN
		IF(@status=1)--status-Ticketed
		BEGIN
			SELECT * into #temp9 FROM(
				SELECT t.orderId, 
				STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
				STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
				STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
				STUFF((SELECT ',' + CONVERT(varchar(11),s.depDate,103)+','+CONVERT(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
				STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis,
				STUFF((SELECT '/' +  substring(I.cabin,0,2) FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS rbd,
				STUFF((SELECT '/' + I.airlinePNR FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS airlinePNR
				, t.PreviousAirlinePNR 
				FROM tblBookItenary AS t WITH(NOLOCK) GROUP BY t.orderId, t.PreviousAirlinePNR
			) X

			SELECT 
			p.pid
			, 'CREDIT' AS [TYPE]
			, CONVERT(varchar(11),p.IssueDate,103) AS IssueDate
			, LocationCode
			, 'TKTT' TransactionType
			, (SELECT VALUE FROM mCommon M WITH(NOLOCK) WHERE M.ID= P.userTypeID) AS AgentId
			, p.airlinePNR AS PNR
			, p.riyaPNR MoBookingNumber
			, CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END AS TicketNumber
			, p.FirstName
			, p.LastName
			, (SELECT TOP 1 currencycode FROM mcountrycurrency WITH(NOLOCK) WHERE countrycode=@country) AS CurrencyType
			, p.BasicFare
			, p.YQTax
			, p.OCTax AS [OC tax]
			, p.TaxTotal
			, p.QTaxBase
			, p.TotalFare
			, IataCommissionC
			, '' AdditionalCommissionC
			, PlbC
			, '' FlownIncentiveC
			, '' BoardingIncentiveC
			, IataCommissionV
			, '' AdditionalCommissionV
			, '' PlbV
			, '' FlownIncentiveV
			, '' BoardingIncentiveV
			, '' NetFare
			, FormofPayment
			, MarkupOnFare
			, MarkupOnTax
			, p.ServiceCharge
			, '' VendorServiceFee
			, '' ManagementFee
			, '' IssuedInExchange
			, '' TourCode
			, '' EqualFareCurrency
			, '' EqulantFare
			, '' FC_STRING
			, p.sector AS Sector
			, Flight AS FlightNumber
			, p.class
			, p.travelDate DateofTravel
			, p.farebasis
			, CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END AS BookingType
			, '' Penalty
			, '' AS [MarkupOnCancellation]
			, '' AS [Service Fee ON Cancellation]
			, '' [Mgmt Fee ON Cancellation]
			, '' [No Show Charge]
			, '' [No Show Airline]
			, '' AdditionalCxlBase
			, '' AdditionalCxlTax
			, '' [VMPD/Exo No.]
			, [Employee Dimension Code]
			, p.promoCode AS [TR/PO No.]
			, '' [Card Type]
			, [IATA Code]
			, '' [Contact No.]
			, '' [Cancellation Type]
			, 'Travel Next' AS [Booking Source Type]
			, '' [BTA Sales]
			, VesselName AS	[Vessel Name]
			, '' [Narration 1]
			, '' [Narration 2]
			, '' [EMD Ticket Type]
			, '' [Tax YM]
			, '' [Tax WO]
			, '' [Cust Info1]
			, '' [Cust Info2]
			, '' [Cust Info3]
			, '' [Cust Info4]
			, '' [Cust Info5]
			, p.YrTax
			, p.XTTax
			, p.JNTax
			, p.OCTax
			, p.INTax
			, p.airCode
			, ISNULL(REPLACE((CASE WHEN p.airCode='SG' THEN 'SG' WHEN p.airCode='G8' THEN 'G8' 
					WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6E' END) 
					ELSE (CASE WHEN p.VendorName='Amadeus' AND LEN(P.ticket1)>6 THEN 
					(SELECT TOP 1 _CODE FROM AirlinesName WITH(NOLOCK) WHERE [AWB Prefix] IN (CAST(SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 4) AS VARCHAR(100))))
					ELSE p.airCode END) END),'?',''),p.airCode) AS supplierCode
			, VendorNo
			, CustomerNumber
			, PaxType
			, '' FROMCity
			, '' ToCity
			, airlinePNR
			, rbd
			, '' AS 'CRS'
			, p.FROMAirport
			, p.toAirport
			, p.equipment
			, '' AS baggage
			, FlyingHour
			, ProductType
			, 'PRD100101' AS ProductCode
			, BranchCode
			, '' AS [Emp Code]
			, p.RegistrationNumber
			, p.CompanyName
			, p.CAddress
			, p.CState
			, p.CContactNo
			, p.CEmailID
			, JobCodeBookingGivenBy
			, VesselName
			, ReasonofTravel
			, TravelRequestNumber
			, CostCenter
			, BudgetCode
			, EmpDimession
			, SwonNo
			, TravelerType
			, Location
			, Department
			, Grade
			, ma.Bookedby
			, Designation
			, Chargeability
			, NameofApprover
			, ReferenceNo
			, TR_POName
			, p.RankNo
			, AType
			, BookingReceivedDate
			, P.ROE
			, P.AgentROE
			, promodiscount
			, p.[MCO amount]
			, p.[MCO number]
			, OfficeID
			, cardtype AS crdtype
			, cardnumber AS crdno
			, reScheduleCharge AS RescheduleCharges
			, SupplierPenalty
			, RescheduleMarkup
			, PreviousRiyaPNR
			, PreviousAirlinePNR
			, CONVERT(varchar(11),p.IssueDate,103) AS RescheduleDate
			, [Extra Baggage Amount]
			, [Seat Preference Charge]
			, [Meal Charges]
			, [Wheel Chair Charges]
			, [SSR Comb Amount]
			, p.YMTax
			, p.WOTax
			, p.OBTax
			, p.RFTax
			, ma.OBTCno AS OBTC 
			, Traveltype
			, Changedcostno
			, Travelduration
			, TASreqno
			, Companycodecc
			, Projectcode
			, AuthCode AS [Card Approval Code]
			, ExpiryDate AS [Card expiry]
			, MCOMerchantfee AS [MCO Merchant fee]
			,DropnetCommission
			FROM (
				SELECT distinct 
				(pax.pid)
				, book.riyaPNR
				, book.GDSPNR
				, ISNULL(book.IssueDate,ISNULL(book.inserteddate_old,book.inserteddate)) AS IssueDate
				, book.GDSPNR AS PNR
				, book.airCode
				, (ticketNum) ticket1
				, (ticketNum) AS ticket2
				, pax.paxType PaxType
				, pax.title +' '+ pax.paxFName FirstName
				, pax.paxLName LastName
				, CAST(((pax.basicFare+ISNULL(pax.Markup,0)) * book.ROE) AS decimal(18,2)) AS BasicFare
				, CAST(((PAX.totalTax) * book.ROE) AS decimal(18,2)) AS TaxTotal
				, CAST((((pax.totalFare +ISNULL(pax.Markup,0)) -pax.serviceCharge) * book.ROE) AS decimal(18,2)) AS TotalFare
				, CAST((ISNULL((CASE WHEN ((BOOK.B2bFareType=2 OR book.B2bFareType=3)) THEN ((pax.B2BMarkup+pax.HupAmount)/ISNULL(book.AgentROE,0)) 
						ELSE pax.HupAmount END),0))AS decimal(18,2)) AS MarkupOnTax
				, (CAST((ISNULL((CASE WHEN BOOK.B2bFareType=1 THEN (pax.B2BMarkup/ISNULL(book.AgentROE,0)) ELSE 0 END),0))AS decimal(18,2)) +PAX.BFC) AS MarkupOnFare
				, CAST((ISNULL(pax.[YQ] * book.ROE,0))AS decimal(18,2)) AS YQTax
				, CAST((ISNULL(pax.[YRTax]* book.ROE,0))AS decimal(18,2)) AS YrTax
				, CAST((ISNULL(pax.[INTax]* book.ROE,0))AS decimal(18,2)) AS INTax
				, CAST((ISNULL(pax.[JNTax]* book.ROE,0) )AS decimal(18,2)) AS JNTax
				, CAST((ISNULL(pax.[OCTax]* book.ROE,0))AS decimal(18,2)) AS OCTax
				, CAST((ISNULL(pax.[YMTax]* book.ROE,0))AS decimal(18,2)) AS YMTax
				, CAST((ISNULL(pax.[WOTax]* book.ROE,0))AS decimal(18,2)) AS WOTax
				, CAST((ISNULL(pax.[OBTax]* book.ROE,0))AS decimal(18,2)) AS OBTax
				, CAST((ISNULL(pax.[RFTax]* book.ROE,0))AS decimal(18,2)) AS RFTax
				, CAST((ISNULL((pax.ExtraTax * book.ROE),0) )AS decimal(18,2))AS XTTax
				, 0	QTaxBase
				, ([CounterCloseTime]) AS bookType
				, (#temp9.Sector) AS sector
				, (book.airCode) AS code
				, (pmt.payment_mode) AS mode,(book.flightNo) AS filght,
				(#temp9.airlinePNR) AS airlinePNR, (#temp9.Class) AS class, 
				(#temp9.flight) AS Flight,(#temp9.farebasis) AS farebasis,

				--sum(ISNULL(pax.serviceCharge,0) )AS ServiceCharge,
				CASE WHEN book.ServiceFee>0 THEN ISNULL(pax.ServiceFee,0) ELSE 0 END AS ServiceCharge,
				 --ISNULL(pax.ServiceFee,0) AS ServiceCharge,
				(#temp9.travel) AS travelDate, (ISNULL(book.FlatDiscount,0) + ISNULL(pax.PLBCommission,0) + CAST(ISNULL(book.PromoDiscount/BOOK.ROE,0) AS decimal(16,2))) AS PlbC, 
				pax.IATACommission AS IataCommissionC, (pax.Markup) AS IataCommissionV
				,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID AS OfficeID,promoCode,#temp9.rbd,book.FROMAirport,book.toAirport,book.equipment,
				DATEDIFF(HOUR,book.deptTime,book.arrivalTime) AS 'FlyingHour',
				(ISNULL((SELECT top 1 (CASE WHEN(count(Code)>1) THEN 'Air-domestic' ELSE 'Air-Int'END) AS sector FROM sectors WITH(NOLOCK) 
				WHERE ((ltrim(rtrim(Code)) = book.frmSector  or	ltrim(rtrim(Code)) = book.toSector)  AND [Country code]=A.BookingCountry)group by [Country Code]),'Air-Int')) AS 'ProductType',

				(CASE 
				WHEN @usertype=2 AND A.UserTypeid=4 THEN 'ADH'
				ELSE ISNULL(r.LocationCode,R1.LocationCode) END) 
				AS LocationCode,

				(CASE 
				WHEN @usertype=2 AND A.UserTypeid=4 THEN 'BRH103102'
				ELSE ISNULL(r.BranchCode,R1.BranchCode) END) 
				AS BranchCode,


				(CASE WHEN pmt.payment_mode='passThrough' THEN 'CUSTOMER' WHEN pmt.payment_mode='Credit' THEN 'CORPORATE' ELSE 'CASH' END)AS FormofPayment,
				(CASE WHEN a.UserTypeID=3 AND r.empcodemandate=0 THEN '' ELSE m.UserName END) AS [Employee Dimension Code],
				--(SELECT top 1 (case when 
				--	book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'BOMVEND007913'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then 'VEND000178'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then 'VEND00102'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then 'UVEND00066'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then 'CVEND00041'       
				--	else E.VendorCode end) FROM tblERPDetails E WITH(NOLOCK) WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country ) AS VendorNo,
				(Case WHEN book.Country='US' AND book.OfficeID='00FK' THEN 'UVEND01206' 
					when EV.VendorCode is null then					
					  (SELECT top 1 (case when 
					book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'BOMVEND007913'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then 'VEND000178'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then 'VEND00102'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then 'UVEND00066'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then 'CVEND00041'       
					else E.VendorCode end) FROM tblERPDetails E WITH(NOLOCK) WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country )
					ELSE EV.VendorCode end) as VendorNo,
				(SELECT top 1 (CASE 
				WHEN @usertype=2 AND A.UserTypeid=4 THEN 'ICUST28536'
				WHEN CustomerCode='AgentCustID' THEN ISNULL(r.Icast,R1.Icast) 
				ELSE CustomerCode END) AS CustomerNumber  FROM tblERPDetails E WITH(NOLOCK) 
				WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country) AS CustomerNumber,
				--O.IATA AS [IATA Code]
				(case when book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'RIYAAPITF'       
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then '14338855'      
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then '86215290'      
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then '45828661'      
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then '62500082'      
					   else O.IATA end) as [IATA Code]
				,VendorName,A.userTypeID,book.orderId,book.ROE,book.AgentROE,book.RegistrationNumber,book.CompanyName,book.CAddress,book.CState,book.CContactNo,book.CEmailID
				,(ISNULL(pax.FlatDiscount,0) + ISNULL(pax.DropnetCommission,0)) AS promodiscount
				,pax.MCOAmount AS [MCO amount],pax.MCOTicketNo AS [MCO number]
				,pmt.cardtype,pmt.MaskCardNumber AS cardnumber,pax.profession AS 'Rankno'
				, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp9.PreviousAirlinePNR,

				--(SELECT sum(SSR_Amount) FROM tblSSRDetails s
				--INNER JOIN tblPassengerBookDetails p ON p.pid=s.fkPassengerid AND p.pid=pax.pid
				--INNER JOIN tblBookMaster b ON b.pkId=p.fkBookMaster
				--WHERE (b.orderId=book.orderId) AND SSR_Type='Baggage' AND s.SSR_Status=1 AND SSR_Amount>0 
				--group by p.pid) AS [Extra Baggage Amount], 
				--(SELECT sum(SSR_Amount) FROM tblSSRDetails s
				--INNER JOIN tblPassengerBookDetails p ON p.pid=s.fkPassengerid AND p.pid=pax.pid
				--INNER JOIN tblBookMaster b ON b.pkId=p.fkBookMaster
				--WHERE (b.orderId=book.orderId) AND SSR_Type='Seat' AND s.SSR_Status=1 AND SSR_Amount>0 
				--group by p.pid) AS [Seat Preference Charge], 
				--(SELECT sum(SSR_Amount) FROM tblSSRDetails s
				--INNER JOIN tblPassengerBookDetails p ON p.pid=s.fkPassengerid AND p.pid=pax.pid
				--INNER JOIN tblBookMaster b ON b.pkId=p.fkBookMaster
				--WHERE (b.orderId=book.orderId) AND SSR_Type='Meals' AND s.SSR_Status=1 AND SSR_Amount>0 
				--group by p.pid) AS [Meal Charges]

				--Jitendra Nakum 30.12-2022 find Baggage,Seat AND Meal Amount through Function
				CAST((dbo.Get_SSR_Amount_By_SSR_Type (book.riyaPNR,'Baggage',pax.totalFare,pax.paxType,pax.paxFName,paxLName,TicketNumber)) 
						* (SELECT broe.ROE FROM tblBookMaster broe WITH(NOLOCK) WHERE broe.pkId=book.pkId) AS decimal(18,2)) AS [Extra Baggage Amount],
				CAST((dbo.Get_SSR_Amount_By_SSR_Type (book.riyaPNR,'Seat',pax.totalFare,pax.paxType,pax.paxFName,paxLName,TicketNumber)) 
						* (SELECT broe.ROE FROM tblBookMaster broe WITH(NOLOCK) WHERE broe.pkId=book.pkId) AS decimal(18,2)) AS [Seat Preference Charge],
				CAST((dbo.Get_SSR_Amount_By_SSR_Type (book.riyaPNR,'Meals',pax.totalFare,pax.paxType,pax.paxFName,paxLName,TicketNumber)) 
						* (SELECT broe.ROE FROM tblBookMaster broe WITH(NOLOCK) WHERE broe.pkId=book.pkId) AS decimal(18,2)) AS [Meal Charges],
				0 AS [Wheel Chair Charges],	0 AS [SSR Comb Amount],
				 pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
				 ,ISNULL(pax.DropnetCommission,0) AS DropnetCommission
				FROM tblPassengerBookDetails pax WITH(NOLOCK)
				LEFT JOIN tblBookMaster book WITH(NOLOCK) ON pax.fkBookMaster=book.pkId AND AgentID !='B2C' AND book.totalFare>0 AND (pax.paxType='INFANT' OR pax.totalFare>0)
				LEFT JOIN mUser m WITH(NOLOCK) ON m.id=book.mainagentid
				LEFT JOIN Paymentmaster pmt WITH(NOLOCK) ON book.orderId=pmt.order_id
				--LEFT JOIN B2BRegistration r ON r.FKUserID=book.AgentID
				LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= Book.AgentID)
				LEFT JOIN agentLogin A WITH(NOLOCK) ON A.UserID=book.AgentID
				--LEFT JOIN B2BRegistration r1 ON r1.FKUserID=A.ParentAgentID
				LEFT JOIN B2BRegistration r1 WITH(NOLOCK) ON CAST(r1.FKUserID AS VARCHAR(50))=book.AgentID
				LEFT JOIN PNRRetriveDetails p WITH(NOLOCK) ON p.OrderID=book.orderId
				LEFT JOIN  #temp9 ON pmt.order_id=#temp9.orderId	
				LEFT JOIN tblOwnerCurrency O WITH(NOLOCK) ON O.OfficeID=book.OfficeID
				LEFT JOIN TblErpVendorCode EV WITH (NOLOCK) on book.OfficeID = EV.OfficeID and book.Country in ('AE')
				--LEFT JOIN tblSSRDetails SSR ON ssr.fkPassengerid=pax.pid AND ssr.SSR_Type='Baggage' AND ssr.SSR_Status=1 AND ssr.SSR_Amount >0
				--LEFT JOIN tblSSRDetails SSRMeal ON SSRMeal.fkPassengerid=pax.pid AND SSRMeal.SSR_Type='Meals' AND SSRMeal.SSR_Status=1 AND SSRMeal.SSR_Amount>0
				WHERE (book.IsBooked=1) AND book.Country IN (SELECT C.CountryCode  FROM mUserCountryMapping UM WITH(NOLOCK)
				INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid  AND IsActive=1) 
				--AND (CONVERT(date,book.inserteddate) >=CONVERT(date,@frmDate) AND CONVERT(date,book.inserteddate) <=CONVERT(date,@toDate)
				AND ((CONVERT(date,ISNULL(book.IssueDate,ISNULL(book.inserteddate_old,book.inserteddate))) >= CONVERT(date,@frmDate) 
				AND CONVERT(date,ISNULL(book.IssueDate,ISNULL(book.inserteddate_old,book.inserteddate))) <= CONVERT(date,@toDate))
				OR @frmDate is null AND @toDate is null ) 
				AND (A.UserTypeid=@usertype OR(@usertype=2 AND A.UserTypeid=4))

				AND book.Country=@country 
				--AND AgentID =(CASE @agentid WHEN '' THEN agentid else @agentid END) 
				AND ((@AgentId = '') OR (book.AgentID =CAST(@AgentId AS varchar(50))
									OR (book.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WITH(NOLOCK) WHERE ParentAgentID =CAST(@AgentId AS varchar(50) )))))
				AND book.totalFare>0 
				AND ((BOOK.VendorName!='Amadeus' AND (pax.paxType='INFANT' OR pax.totalFare>0))
				OR (BOOK.VendorName='Amadeus' AND PAX.isReturn=0 AND book.BookingSource!='Web') OR book.BookingSource='Web')
			)p 
			LEFT JOIN mAttrributesDetails MA WITH(NOLOCK) ON MA.OrderID=p.OrderID AND ma.ID IN
			(SELECT top 1 id FROM mAttrributesDetails WITH(NOLOCK) WHERE OrderID=p.OrderID order by id desc)

			UNION 

			SELECT
			p.pid
			, 'CREDIT' AS [TYPE]
			, CONVERT(varchar(11),p.IssueDate,103) AS IssueDate
			, LocationCode
			, 'TKTT' TransactionType
			, (SELECT VALUE FROM mCommon M WITH(NOLOCK) WHERE M.ID= P.userTypeID ) AS AgentId
			, p.airlinePNR AS PNR
			, p.riyaPNR MoBookingNumber
			, CASE WHEN p.ticket1 = p.ticket2 THEN p.ticket1 ELSE p.ticket1 + ',' + p.ticket2 END AS TicketNumber
			, p.FirstName
			, p.LastName
			, (SELECT TOP 1 currencycode FROM mcountrycurrency WITH(NOLOCK) WHERE countrycode=@country) AS CurrencyType
			, p.BasicFare
			, p.YQTax
			, p.OCTax AS [OC tax]
			, p.TaxTotal
			, p.QTaxBase
			, p.TotalFare
			, IataCommissionC
			, '' AdditionalCommissionC
			, PlbC
			, '' FlownIncentiveC
			, '' BoardingIncentiveC
			, IataCommissionV
			, '' AdditionalCommissionV
			, '' PlbV
			, '' FlownIncentiveV
			, '' BoardingIncentiveV
			, '' NetFare
			, FormofPayment
			, MarkupOnFare
			, MarkupOnTax
			, p.ServiceCharge
			, '' VendorServiceFee
			, '' ManagementFee
			, '' IssuedInExchange
			, '' TourCode
			, '' EqualFareCurrency
			, '' EqulantFare
			, '' FC_STRING
			, p.sector AS Sector
			, Flight AS FlightNumber
			, p.class
			, p.travelDate DateofTravel
			, p.farebasis
			, CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END AS BookingType
			, '' Penalty
			, '' as	[MarkupOnCancellation]
			, '' AS [Service Fee ON Cancellation]
			, '' [Mgmt Fee ON Cancellation]
			, '' [No Show Charge]
			, '' [No Show Airline]
			, '' AdditionalCxlBase
			, '' AdditionalCxlTax
			, '' [VMPD/Exo No.]
			, [Employee Dimension Code]
			, p.promoCode AS [TR/PO No.]
			, '' [Card Type]
			, [IATA Code]
			, '' [Contact No.]
			, '' [Cancellation Type]
			, 'Travel Next' AS [Booking Source Type]
			, '' [BTA Sales]
			, VesselName AS	[Vessel Name]
			, '' [Narration 1]
			, '' [Narration 2]
			, '' [EMD Ticket Type]
			, '' [Tax YM]
			, '' [Tax WO]
			, '' [Cust Info1]
			, '' [Cust Info2]
			, '' [Cust Info3]
			, '' [Cust Info4]
			, '' [Cust Info5]
			, p.YrTax
			, p.XTTax
			, p.JNTax
			, p.OCTax
			, p.INTax
			, p.airCode
			, ISNULL(REPLACE((CASE WHEN p.airCode='SG' THEN 'SG' WHEN p.airCode='G8' THEN 'G8' 
					WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6E' END) 
					ELSE(CASE WHEN p.VendorName='Amadeus' AND LEN(P.ticket1) > 6 THEN (SELECT top 1 _CODE FROM AirlinesName WITH(NOLOCK)
					WHERE [AWB Prefix] IN (CAST(SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 4) AS VARCHAR(100))))
					ELSE p.airCode END) END),'?',''),p.airCode) AS supplierCode
			, VendorNo
			, CustomerNumber
			, PaxType
			, '' FROMCity
			, '' ToCity
			, airlinePNR
			, rbd
			, '' AS 'CRS'
			, p.FROMAirport
			, p.toAirport
			, p.equipment
			, '' AS baggage
			, FlyingHour
			, ProductType
			, 'PRD100101' AS ProductCode
			, BranchCode
			, '' AS [Emp Code]
			, p.RegistrationNumber
			, p.CompanyName
			, p.CAddress
			, p.CState
			, p.CContactNo
			, p.CEmailID
			, JobCodeBookingGivenBy
			, VesselName
			, ReasonofTravel
			, TravelRequestNumber
			, CostCenter
			, BudgetCode
			, EmpDimession
			, SwonNo
			, TravelerType
			, Location
			, Department
			, Grade
			, ma.Bookedby
			, Designation
			, Chargeability
			, NameofApprover
			, ReferenceNo
			, TR_POName
			, p.RankNo
			, AType
			, BookingReceivedDate
			, P.ROE
			, P.AgentROE
			, promodiscount
			, p.[MCO amount]
			, p.[MCO number]
			, OfficeID
			, cardtype AS crdtype
			, cardnumber AS crdno
			, reScheduleCharge AS RescheduleCharges
			, SupplierPenalty
			, RescheduleMarkup
			, PreviousRiyaPNR
			, PreviousAirlinePNR
			, CONVERT(varchar(11),p.IssueDate,103) AS RescheduleDate
			, [Extra Baggage Amount]
			, [Seat Preference Charge]
			, [Meal Charges]
			, [Wheel Chair Charges]
			, [SSR Comb Amount]
			, p.YMTax
			, p.WOTax
			, p.OBTax
			, p.RFTax
			, ma.OBTCno AS OBTC
			, Traveltype
			, Changedcostno
			, Travelduration
			, TASreqno
			, Companycodecc
			, Projectcode
			, AuthCode AS [Card Approval Code]
			, ExpiryDate AS [Card expiry]
			, MCOMerchantfee AS [MCO Merchant fee]
			,DropnetCommission
			FROM(
				SELECT
				pax.pid
				, book.riyaPNR
				, book.GDSPNR
				, ISNULL(book.IssueDate,ISNULL(book.inserteddate_old,book.inserteddate)) AS IssueDate
				, book.GDSPNR AS PNR
				, book.airCode
				, (ticketNum) ticket1
				, (ticketNum) AS ticket2
				, pax.paxType PaxType
				, pax.title +' '+ pax.paxFName FirstName
				, pax.paxLName LastName
				--(pax.basicFare +ISNULL(pax.Markup,0))  as	BasicFare	,
				--(PAX.totalTax) AS TaxTotal,
				--((pax.totalFare +ISNULL(pax.Markup,0))-pax.serviceCharge)  as TotalFare,
				--CAST((CASE WHEN BOOK.B2bFareType=2 OR book.B2bFareType=3 THEN (pax.B2BMarkup/ISNULL(book.AgentROE,0)) ELSE 0 END) AS decimal(18,2)) AS MarkupOnTax,
				--CAST(((CASE WHEN BOOK.B2bFareType=1 THEN (pax.B2BMarkup/ISNULL(book.AgentROE,0)) ELSE 0 END)+PAX.BFC) AS decimal(18,2)) AS MarkupOnFare,
				--(ISNULL(pax.[YQ],0)) AS YQTax,
				--(ISNULL(pax.[YRTax],0)) AS YrTax,
				--(ISNULL(pax.[INTax],0)) AS INTax,
				--(ISNULL(pax.[JNTax],0)) AS JNTax,
				--(ISNULL(pax.[OCTax],0)) AS OCTax,

				--(ISNULL(pax.[YMTax],0)) AS YMTax,
				--(ISNULL(pax.[WOTax],0)) AS WOTax,
				--(ISNULL(pax.[OBTax],0)) AS OBTax,
				--(ISNULL(pax.[RFTax],0)) AS RFTax,
				--(ISNULL((pax.ExtraTax),0) )AS XTTax,
				--0	QTaxBase,	
				, CAST(((pax.basicFare+ISNULL(pax.Markup,0)) * (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END )) AS decimal(18,2)) AS	BasicFare
				, CAST(((PAX.totalTax ) * (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END ))AS decimal(18,2)) AS TaxTotal
				, CAST((((pax.totalFare +ISNULL(pax.Markup,0)) -pax.serviceCharge) * (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END ))AS decimal(18,2))  as TotalFare
				, CAST((ISNULL((CASE WHEN ((BOOK.B2bFareType=2 OR book.B2bFareType=3)) THEN (((pax.B2BMarkup+pax.HupAmount)/ISNULL(book.AgentROE,0)) * (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END )) 
						ELSE pax.HupAmount END),0))AS decimal(18,2)) AS MarkupOnTax
				, ((CAST((ISNULL((CASE WHEN BOOK.B2bFareType=1 THEN (pax.B2BMarkup/ISNULL(book.AgentROE,0)) ELSE 0 END),0))AS decimal(18,2)) +PAX.BFC)) AS MarkupOnFare
				, CAST((ISNULL(pax.[YQ] * (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END ),0)) AS decimal(18,2)) AS YQTax
				, CAST((ISNULL(pax.[YRTax]* (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END ),0))AS decimal(18,2)) AS YrTax
				, CAST((ISNULL(pax.[INTax]* (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END ),0))AS decimal(18,2)) AS INTax
				, CAST((ISNULL(pax.[JNTax]* (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END ),0) )AS decimal(18,2)) AS JNTax
				, CAST((ISNULL(pax.[OCTax]* (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END ),0))AS decimal(18,2)) AS OCTax
				, CAST((ISNULL(pax.[YMTax]* (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END ),0))AS decimal(18,2)) AS YMTax
				, CAST((ISNULL(pax.[WOTax]* (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END ),0))AS decimal(18,2)) AS WOTax
				, CAST((ISNULL(pax.[OBTax]* (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END ),0))AS decimal(18,2)) AS OBTax
				, CAST((ISNULL(pax.[RFTax]* (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END ),0))AS decimal(18,2)) AS RFTax
				, CAST((ISNULL((pax.ExtraTax * (SELECT CASE WHEN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1)!=
						(SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country) THEN (SELECT ROE FROM mROEUpdation R WITH(NOLOCK)
						WHERE ISACTIVE=1 AND FLAG=1 AND 
						OfficeID IN (SELECT pkid FROM tbl_commonmaster WITH(NOLOCK) WHERE CategoryValue=book.OfficeID) 
						AND BaseCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT top 1 Value FROM mVendorCredential WITH(NOLOCK) WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) )
						AND ToCurrencyId IN (SELECT ID FROM mCommon WITH(NOLOCK) WHERE Value IN (SELECT Currency FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country ))
						AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WITH(NOLOCK) WHERE CountryCode=@country)) ELSE 1 END )),0) )AS decimal(18,2)) AS XTTax
				, 0	QTaxBase
				, [CounterCloseTime] AS bookType
				, #temp9.Sector  as sector
				, book.airCode AS code
				, pmt.payment_mode AS mode
				, book.flightNo AS filght
				, #temp9.airlinePNR AS airlinePNR
				, #temp9.Class AS class
				, #temp9.flight AS Flight
				, #temp9.farebasis AS farebasis
				--sum(ISNULL(pax.serviceCharge,0) )AS ServiceCharge,
				, CASE WHEN book.ServiceFee > 0 THEN ISNULL(pax.ServiceFee,0) ELSE 0 END AS ServiceCharge
				, #temp9.travel AS travelDate
				, (ISNULL(book.FlatDiscount,0) + ISNULL(pax.PLBCommission,0) + CAST(ISNULL(book.PromoDiscount/BOOK.ROE,0) AS decimal(16,2))) AS PlbC
				, pax.IATACommission AS IataCommissionC
				, pax.Markup AS IataCommissionV
				, book.SupplierCode
				, book.Vendor_No
				, book.Country
				, book.OfficeID AS OfficeID
				, promoCode
				, #temp9.rbd
				, book.FROMAirport
				, book.toAirport
				, book.equipment
				, DATEDIFF(HOUR,book.deptTime,book.arrivalTime) AS 'FlyingHour'
				, (ISNULL((SELECT top 1 (CASE WHEN(count(Code)>1) THEN 'Air-domestic' ELSE 'Air-Int'END) AS sector
						FROM sectors WITH(NOLOCK) WHERE ((ltrim(rtrim(Code)) = book.frmSector or ltrim(rtrim(Code)) = book.toSector) 
						AND [Country code]=A.BookingCountry)group by [Country Code]),'Air-Int')) AS 'ProductType'
				, ISNULL(r.LocationCode,R1.LocationCode) AS LocationCode
				, ISNULL(r.BranchCode,R1.BranchCode) AS BranchCode
				, (CASE WHEN pmt.payment_mode='passThrough' THEN 'CUSTOMER' WHEN pmt.payment_mode='Credit' THEN 'CORPORATE' ELSE 'CASH' END) AS FormofPayment
				, (CASE WHEN a.UserTypeID=3 AND r.empcodemandate=0 THEN '' ELSE m.UserName END) AS [Employee Dimension Code]
				--, (SELECT top 1 (case when 
				--	book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'BOMVEND007913'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then 'VEND000178'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then 'VEND00102'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then 'UVEND00066'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then 'CVEND00041'       
				--	else E.VendorCode end) FROM tblERPDetails E WITH(NOLOCK) WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country ) AS VendorNo
				,(Case WHEN book.Country='US' AND book.OfficeID='00FK' THEN 'UVEND01206' 
					when EV.VendorCode is null then					
					  (SELECT top 1 (case when 
					book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'BOMVEND007913'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then 'VEND000178'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then 'VEND00102'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then 'UVEND00066'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then 'CVEND00041'       
					else E.VendorCode end) FROM tblERPDetails E WITH(NOLOCK) WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country )
					ELSE EV.VendorCode end) as VendorNo
				, (SELECT top 1 (CASE WHEN CustomerCode='AgentCustID' THEN ISNULL(r.Icast,R1.Icast) ELSE CustomerCode END) AS CustomerNumber  FROM tblERPDetails E WITH(NOLOCK)
						WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country) AS CustomerNumber
				--, O.IATA AS [IATA Code]
				,(case when book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'RIYAAPITF'       
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then '14338855'      
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then '86215290'      
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then '45828661'      
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then '62500082'      
					   else O.IATA end) as [IATA Code]
				, VendorName
				, A.userTypeID
				, book.orderId
				, book.ROE
				, book.AgentROE
				, book.RegistrationNumber
				, book.CompanyName
				, book.CAddress
				, book.CState
				, book.CContactNo
				, book.CEmailID
				, (ISNULL(pax.FlatDiscount,0) + ISNULL(pax.DropnetCommission,0)) AS promodiscount
				
				, pax.MCOAmount AS [MCO amount]
				, pax.MCOTicketNo AS [MCO number]
				, pmt.cardtype
				, pmt.MaskCardNumber AS cardnumber
				, pax.profession AS 'Rankno'
				, pax.SupplierPenalty
				, pax.reScheduleCharge
				, pax.RescheduleMarkup
				, book.PreviousRiyaPNR
				, #temp9.PreviousAirlinePNR
				--(SELECT sum(SSR_Amount) FROM tblSSRDetails s
				--INNER JOIN tblPassengerBookDetails p ON p.pid=s.fkPassengerid AND p.pid=pax.pid
				--INNER JOIN tblBookMaster b ON b.pkId=p.fkBookMaster
				--WHERE (b.orderId=book.orderId) AND SSR_Type='Baggage' AND s.SSR_Status=1 AND SSR_Amount>0 
				--group by p.pid) AS [Extra Baggage Amount], 
				--(SELECT sum(SSR_Amount) FROM tblSSRDetails s
				--INNER JOIN tblPassengerBookDetails p ON p.pid=s.fkPassengerid AND p.pid=pax.pid
				--INNER JOIN tblBookMaster b ON b.pkId=p.fkBookMaster
				--WHERE (b.orderId=book.orderId) AND SSR_Type='Seat' AND s.SSR_Status=1 AND SSR_Amount>0 
				--group by p.pid) AS [Seat Preference Charge], 
				--(SELECT sum(SSR_Amount) FROM tblSSRDetails s
				--INNER JOIN tblPassengerBookDetails p ON p.pid=s.fkPassengerid AND p.pid=pax.pid
				--INNER JOIN tblBookMaster b ON b.pkId=p.fkBookMaster
				--WHERE (b.orderId=book.orderId) AND SSR_Type='Meals' AND s.SSR_Status=1 AND SSR_Amount>0 
				--group by p.pid) AS [Meal Charges],	

				--Jitendra Nakum 30.12-2022 find Baggage,Seat AND Meal Amount through Function
				, CAST((dbo.Get_SSR_Amount_By_SSR_Type (book.riyaPNR,'Baggage',pax.totalFare,pax.paxType,pax.paxFName,paxLName,TicketNumber)) 
						* (SELECT broe.ROE FROM tblBookMaster broe WITH(NOLOCK) WHERE broe.pkId=book.pkId) AS decimal(18,2)) AS [Extra Baggage Amount]
				, CAST((dbo.Get_SSR_Amount_By_SSR_Type (book.riyaPNR,'Seat',pax.totalFare,pax.paxType,pax.paxFName,paxLName,TicketNumber))
						* (SELECT broe.ROE FROM tblBookMaster broe WITH(NOLOCK) WHERE broe.pkId=book.pkId) AS decimal(18,2)) AS [Seat Preference Charge]
				, CAST((dbo.Get_SSR_Amount_By_SSR_Type (book.riyaPNR,'Meals',pax.totalFare,pax.paxType,pax.paxFName,paxLName,TicketNumber))
						* (SELECT broe.ROE FROM tblBookMaster broe WITH(NOLOCK) WHERE broe.pkId=book.pkId) AS decimal(18,2)) AS [Meal Charges]
				, 0 AS [Wheel Chair Charges]
				, 0 AS [SSR Comb Amount]
				, pmt.AuthCode
				, pmt.ExpiryDate
				, pax.MCOMerchantfee	
				,ISNULL(pax.DropnetCommission,0) AS DropnetCommission
				FROM tblPassengerBookDetails pax WITH(NOLOCK)
				LEFT JOIN tblBookMaster book WITH(NOLOCK) ON pax.fkBookMaster=book.pkId AND AgentID !='B2C' AND book.totalFare>0 AND (pax.paxType='INFANT' OR pax.totalFare>0)
				LEFT JOIN mUser m WITH(NOLOCK) ON m.id=book.mainagentid
				LEFT JOIN Paymentmaster pmt WITH(NOLOCK) ON book.orderId=pmt.order_id
				--LEFT JOIN B2BRegistration r ON r.FKUserID=book.AgentID
				LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= Book.AgentID)
				LEFT JOIN agentLogin A WITH(NOLOCK) ON A.UserID=book.AgentID
				--LEFT JOIN B2BRegistration r1 ON r1.FKUserID=A.ParentAgentID
				LEFT JOIN B2BRegistration r1 WITH(NOLOCK) ON CAST(r1.FKUserID AS VARCHAR(50))=book.AgentID
				LEFT JOIN PNRRetriveDetails p WITH(NOLOCK) ON p.OrderID=book.orderId
				LEFT JOIN  #temp9 ON pmt.order_id=#temp9.orderId	
				LEFT JOIN tblOwnerCurrency O WITH(NOLOCK) ON O.OfficeID=book.OfficeID
				LEFT JOIN TblErpVendorCode EV WITH (NOLOCK) on book.OfficeID = EV.OfficeID and book.Country in ('AE')
				--LEFT JOIN tblSSRDetails SSR ON ssr.fkPassengerid=pax.pid AND SSR_Type='Baggage' AND SSR_Status=1 AND ssr.SSR_Amount>0
				--LEFT JOIN tblSSRDetails SSRMeal ON SSRMeal.fkPassengerid=pax.pid AND SSRMeal.SSR_Type='Meals' AND SSRMeal.SSR_Status=1 AND SSRMeal.SSR_Amount>0
				WHERE (book.IsBooked=1) AND book.Country IN (SELECT C.CountryCode  FROM mUserCountryMapping UM WITH(NOLOCK)
				INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid  AND IsActive=1) 
				AND ((CONVERT(date,ISNULL(book.IssueDate, ISNULL(book.inserteddate_old,book.inserteddate))) >=CONVERT(date,@frmDate)
				AND CONVERT(date,ISNULL(book.IssueDate, ISNULL(book.inserteddate_old,book.inserteddate))) <=CONVERT(date,@toDate))
				OR @frmDate is null AND @toDate is null ) AND A.UserTypeid=@usertype 
				AND (('RiyaapiTF' IN ( SELECT OwnerID FROM tblERPDetails WITH(NOLOCK) WHERE book.VendorName='TravelFusion' AND OwnerID= 'RiyaapiTF' AND ERPCountry=@country AND AgentCountry=book.Country AND OwnerCountry=@country))
				OR (BOOK.OfficeID IN ( SELECT OwnerID FROM tblERPDetails WITH(NOLOCK) WHERE book.VendorName!='TravelFusion' AND OwnerID= book.OfficeID AND ERPCountry=@country AND AgentCountry=book.Country AND OwnerCountry=@country)))
				--AND (BOOK.OfficeID IN ( SELECT OwnerID FROM tblERPDetails WITH(NOLOCK) WHERE OwnerID= book.OfficeID AND ERPCountry=@country AND AgentCountry=book.Country AND OwnerCountry=@country AND book.VendorName!='TravelFusion' ))
				--AND AgentID =(CASE @agentid WHEN '' THEN agentid else @agentid END) 
				AND ((@AgentId = '') OR (book.AgentID =CAST(@AgentId AS varchar(50))
									OR (book.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WITH(NOLOCK) WHERE ParentAgentID =CAST(@AgentId AS varchar(50) )))))
				AND book.totalFare>0 
				AND ((BOOK.VendorName!='Amadeus' AND (pax.paxType='INFANT' OR pax.totalFare>0))
				OR (BOOK.VendorName='Amadeus' AND PAX.isReturn=0 AND book.BookingSource!='Web') OR book.BookingSource='Web')
			)p 
			LEFT JOIN mAttrributesDetails MA WITH(NOLOCK) ON MA.OrderID=p.OrderID AND ma.ID IN
			(SELECT top 1 id FROM mAttrributesDetails WITH(NOLOCK) WHERE OrderID=p.OrderID order by id desc)
			--order by p.IssueDate asc
			drop table #temp9
		END

		ELSE IF(@status=2)--status-refunded
		BEGIN
			SELECT * into #temp91 FROM(
				SELECT t.orderId, 
				STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
				STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
				STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
				STUFF((SELECT ',' + CONVERT(varchar(11),s.depDate,103)+','+CONVERT(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
				STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis,
				STUFF((SELECT '/' +  substring(I.cabin,0,2) FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS rbd,
				STUFF((SELECT '/' + I.airlinePNR FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS airlinePNR
				, t.PreviousAirlinePNR 
				FROM tblBookItenary AS t WITH(NOLOCK) GROUP BY t.orderId, t.PreviousAirlinePNR
			) X

			SELECT
			p.pid
			, 'CREDIT' AS [TYPE]
			, CONVERT(varchar(11),p.IssueDate,103) AS IssueDate
			, LocationCode
			, p.TransactionType
			, (SELECT VALUE FROM mCommon M WITH(NOLOCK) WHERE M.ID= P.userTypeID) AS AgentId
			, p.airlinePNR AS PNR
			, p.riyaPNR MoBookingNumber
			, CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END AS TicketNumber
			, p.FirstName
			, p.LastName
			, (SELECT TOP 1 currencycode FROM mcountrycurrency WITH(NOLOCK) WHERE countrycode=@country) AS CurrencyType
			, p.BasicFare
			, p.YQTax
			, p.OCTax AS [OC tax]
			, p.TaxTotal
			, p.QTaxBase
			, p.TotalFare
			, IataCommissionC
			, '' AdditionalCommissionC
			, PlbC
			, '' FlownIncentiveC
			, '' BoardingIncentiveC
			, IataCommissionV
			, '' AdditionalCommissionV
			, '' PlbV
			, '' FlownIncentiveV
			, '' BoardingIncentiveV
			, '' NetFare
			, FormofPayment
			, MarkupOnFare
			, MarkupOnTax
			, p.ServiceCharge
			, '' VendorServiceFee
			, '' ManagementFee
			, '' IssuedInExchange
			, '' TourCode
			, '' EqualFareCurrency
			, '' EqulantFare
			, '' FC_STRING
			, p.sector AS Sector
			, Flight AS FlightNumber
			, p.class
			, p.travelDate DateofTravel
			, p.farebasis
			, CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END AS BookingType
			, Penalty
			, [MarkupOnCancellation]
			, CancellationServiceFee AS [Service Fee ON Cancellation]
			, '' [Mgmt Fee ON Cancellation]
			, '' [No Show Charge]
			, '' [No Show Airline]
			, '' AdditionalCxlBase
			, '' AdditionalCxlTax
			, '' [VMPD/Exo No.]
			, [Employee Dimension Code]
			, p.promoCode AS [TR/PO No.]
			, '' [Card Type]
			, [IATA Code]
			, '' [Contact No.]
			, '' [Cancellation Type]
			, 'Travel Next' AS [Booking Source Type]
			, '' [BTA Sales]
			, VesselName AS	[Vessel Name]
			, '' [Narration 1]
			, '' [Narration 2]
			, '' [EMD Ticket Type]
			, '' [Tax YM]
			, '' [Tax WO]
			, '' [Cust Info1]
			, '' [Cust Info2]
			, '' [Cust Info3]
			, '' [Cust Info4]
			, '' [Cust Info5]
			, p.YrTax
			, p.XTTax
			, p.JNTax
			, p.OCTax
			, p.INTax
			, p.airCode
			, ISNULL(REPLACE((CASE WHEN p.airCode='SG' THEN 'SG' WHEN p.airCode='G8' THEN 'G8' 
				WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6E' END) 
				ELSE ( CASE WHEN p.VendorName='Amadeus' THEN(
				SELECT top 1 _CODE FROM AirlinesName WITH(NOLOCK) WHERE [AWB Prefix] IN ( CAST (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 4) AS float) ))
				ELSE p.airCode END) END),'?',''),p.airCode) AS supplierCode
			, VendorNo
			, CustomerNumber
			, PaxType
			, '' FROMCity
			, '' ToCity
			, airlinePNR
			, rbd
			, '' AS 'CRS'
			, p.FROMAirport
			, p.toAirport
			, p.equipment
			, '' AS baggage
			, FlyingHour
			, ProductType
			, 'PRD100101' AS ProductCode
			, BranchCode
			, '' AS [Emp Code]
			, p.RegistrationNumber
			, p.CompanyName
			, p.CAddress
			, p.CState
			, p.CContactNo
			, p.CEmailID
			, JobCodeBookingGivenBy
			, VesselName
			, ReasonofTravel
			, TravelRequestNumber
			, CostCenter
			, BudgetCode
			, EmpDimession
			, SwonNo
			, TravelerType
			, Location
			, Department
			, Grade
			, ma.Bookedby
			, Designation
			, Chargeability
			, NameofApprover
			, ReferenceNo
			, TR_POName
			, p.RankNo
			, AType
			, BookingReceivedDate
			, P.ROE
			, P.AgentROE
			, promodiscount
			, p.[MCO amount]
			, p.[MCO number]
			, OfficeID
			, cardtype AS crdtype
			, cardnumber AS crdno
			, reScheduleCharge AS RescheduleCharges
			, SupplierPenalty
			, RescheduleMarkup
			, PreviousRiyaPNR
			, PreviousAirlinePNR
			, CONVERT(varchar(11),p.IssueDate,103) AS RescheduleDate
			, [Extra Baggage Amount]
			, [Seat Preference Charge]
			, [Meal Charges]
			, [Wheel Chair Charges]
			, [SSR Comb Amount]
			, p.YMTax
			, p.WOTax
			, p.OBTax
			, p.RFTax
			, ma.OBTCno AS OBTC
			, Traveltype
			, Changedcostno
			, Travelduration
			, TASreqno
			, Companycodecc
			, Projectcode
			, AuthCode AS [Card Approval Code]
			, ExpiryDate AS [Card expiry]
			, MCOMerchantfee AS [MCO Merchant fee]
			,DropnetCommission
			FROM(
				SELECT distinct
				pax.pid
				, book.riyaPNR
				, book.GDSPNR
				, pax.CancelledDate AS IssueDate
				, book.GDSPNR AS PNR
				, book.airCode
				, (ticketNum) ticket1
				, (ticketNum) AS ticket2
				, pax.paxType PaxType
				, pax.title +' '+ pax.paxFName FirstName
				, pax.paxLName LastName
				, -CAST(((pax.basicFare + ISNULL(pax.Markup,0)) * book.ROE) AS decimal(18,2)) AS BasicFare
				, -CAST(((PAX.totalTax) * book.ROE)AS decimal(18,2)) AS TaxTotal
				, -CAST((((pax.totalFare + ISNULL(pax.Markup,0)) -pax.serviceCharge) * book.ROE) AS decimal(18,2)) as TotalFare
				, -CAST((ISNULL((CASE WHEN ((BOOK.B2bFareType=2 OR book.B2bFareType=3) ) THEN ((pax.B2BMarkup+pax.HupAmount + pax.MarkupOnTaxFare)/ISNULL(book.AgentROE,0)) ELSE pax.HupAmount END),0)) AS decimal(18,2)) AS MarkupOnTax
				, -(CAST((ISNULL((CASE WHEN BOOK.B2bFareType=1 THEN (pax.B2BMarkup/ISNULL(book.AgentROE,0)) ELSE 0 END),0))AS decimal(18,2)) +PAX.BFC + ISNULL(pax.CancellationMarkup,0)) AS MarkupOnFare
				, -CAST((CONVERT(float,[YQ]* book.ROE))AS decimal(18,2)) AS YQTax
				, -CAST((ISNULL(pax.[YRTax]* book.ROE,0))AS decimal(18,2)) AS YrTax
				, -CAST((ISNULL(pax.[INTax]* book.ROE,0))AS decimal(18,2)) AS INTax
				, -CAST((ISNULL(pax.[JNTax]* book.ROE,0) )AS decimal(18,2)) AS JNTax,
				-CAST((ISNULL(pax.[OCTax]* book.ROE,0))AS decimal(18,2)) AS OCTax,
				-CAST((ISNULL(pax.[YMTax]* book.ROE,0))AS decimal(18,2)) AS YMTax,
				-CAST((ISNULL(pax.[WOTax]* book.ROE,0))AS decimal(18,2)) AS WOTax,
				-CAST((ISNULL(pax.[OBTax]* book.ROE,0))AS decimal(18,2)) AS OBTax,
				-CAST((ISNULL(pax.[RFTax]* book.ROE,0))AS decimal(18,2)) AS RFTax,
				-CAST((ISNULL((pax.ExtraTax * book.ROE),0) )AS decimal(18,2))AS XTTax,
				0	QTaxBase,	
				([CounterCloseTime]) AS bookType,
				(#temp91.Sector)  as sector,(book.airCode) AS code,
				(pmt.payment_mode) AS mode,(book.flightNo) AS filght,
				(#temp91.airlinePNR) AS airlinePNR, (#temp91.Class) AS class, 
				(#temp91.flight) AS Flight,(#temp91.farebasis) AS farebasis,

				--sum(ISNULL(pax.serviceCharge,0) )AS ServiceCharge,
				CASE WHEN book.ServiceFee>0 THEN ISNULL(-pax.ServiceFee,0) ELSE 0 END AS ServiceCharge,
				(#temp91.travel) AS travelDate, 
				-(ISNULL(book.FlatDiscount,0) + ISNULL(pax.PLBCommission,0) + CAST(ISNULL(book.PromoDiscount/BOOK.ROE,0) AS decimal(16,2))) AS PlbC, 
				-pax.IATACommission AS IataCommissionC, 
				( -pax.Markup ) AS IataCommissionV
				,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID AS OfficeID,promoCode,#temp91.rbd,book.FROMAirport,book.toAirport,book.equipment,
				DATEDIFF(HOUR,book.deptTime,book.arrivalTime) AS 'FlyingHour',
				(ISNULL((SELECT top 1 (CASE WHEN(count(Code)>1) THEN 'Air-domestic' ELSE 'Air-Int'END) AS sector FROM sectors WITH(NOLOCK) 
				WHERE ((ltrim(rtrim(Code)) = book.frmSector  or	ltrim(rtrim(Code)) = book.toSector)  AND [Country code]=A.BookingCountry)group by [Country Code]),'Air-Int')) AS 'ProductType',
				ISNULL(r.LocationCode,R1.LocationCode) AS LocationCode,ISNULL(r.BranchCode,R1.BranchCode) AS BranchCode,(CASE WHEN pmt.payment_mode='passThrough' THEN 'CUSTOMER' WHEN pmt.payment_mode='Credit' THEN 'CORPORATE' ELSE 'CASH' END)AS FormofPayment,
				(CASE WHEN a.UserTypeID=3 AND r.empcodemandate=0 THEN '' ELSE m.UserName END) AS [Employee Dimension Code],
				--(SELECT top 1 (case when 
				--	book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'BOMVEND007913'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then 'VEND000178'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then 'VEND00102'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then 'UVEND00066'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then 'CVEND00041'       
				--	else E.VendorCode end) FROM tblERPDetails E WITH(NOLOCK) WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country ) AS VendorNo,
				(Case WHEN book.Country='US' AND book.OfficeID='00FK' THEN 'UVEND01206' 
					when EV.VendorCode is null then					
					  (SELECT top 1 (case when 
					book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'BOMVEND007913'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then 'VEND000178'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then 'VEND00102'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then 'UVEND00066'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then 'CVEND00041'       
					else E.VendorCode end) FROM tblERPDetails E WITH(NOLOCK) WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country )
					ELSE EV.VendorCode end) as VendorNo,
				(SELECT top 1 (CASE WHEN CustomerCode='AgentCustID' THEN ISNULL(r.Icast,R1.Icast) ELSE CustomerCode END) AS CustomerNumber  FROM tblERPDetails E WITH(NOLOCK)
				WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country) AS CustomerNumber,
				--O.IATA AS [IATA Code]
				(case when book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'RIYAAPITF'       
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then '14338855'      
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then '86215290'      
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then '45828661'      
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then '62500082'      
					   else O.IATA end) as [IATA Code]
				,VendorName,A.userTypeID,book.orderId,book.ROE,book.AgentROE,book.RegistrationNumber,book.CompanyName,book.CAddress,book.CState,book.CContactNo,book.CEmailID
				
				,-(ISNULL(pax.FlatDiscount,0) + ISNULL(pax.DropnetCommission,0)) AS promodiscount,
				-pax.MCOAmount AS [MCO amount],pax.MCOTicketNo AS [MCO number],pax.CancellationPenalty AS Penalty ,pax.CancellationMarkup AS [MarkupOnCancellation],
				pax.CancellationServiceFee,
				pmt.cardtype,pmt.MaskCardNumber AS cardnumber,CASE WHEN CheckboxVoid=1 THEN 'VOID' ELSE 'RFND' END AS TransactionType,pax.profession AS 'Rankno'
				, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp91.PreviousAirlinePNR ,

				---(SELECT sum(SSR_Amount) FROM tblSSRDetails s
				--INNER JOIN tblPassengerBookDetails p ON p.pid=s.fkPassengerid AND p.pid=pax.pid
				--INNER JOIN tblBookMaster b ON b.pkId=p.fkBookMaster
				--WHERE (b.orderId=book.orderId) AND SSR_Type='Baggage' AND s.SSR_Status=1 AND SSR_Amount>0 
				--group by p.pid) AS [Extra Baggage Amount], 
				---(SELECT sum(SSR_Amount) FROM tblSSRDetails s
				--INNER JOIN tblPassengerBookDetails p ON p.pid=s.fkPassengerid AND p.pid=pax.pid
				--INNER JOIN tblBookMaster b ON b.pkId=p.fkBookMaster
				--WHERE (b.orderId=book.orderId) AND SSR_Type='Seat' AND s.SSR_Status=1 AND SSR_Amount>0 
				--group by p.pid) AS [Seat Preference Charge], 
				---(SELECT sum(SSR_Amount) FROM tblSSRDetails s
				--INNER JOIN tblPassengerBookDetails p ON p.pid=s.fkPassengerid AND p.pid=pax.pid
				--INNER JOIN tblBookMaster b ON b.pkId=p.fkBookMaster
				--WHERE (b.orderId=book.orderId) AND SSR_Type='Meals' AND s.SSR_Status=1 AND SSR_Amount>0 
				--group by p.pid) AS [Meal Charges],	

				--Jitendra Nakum 30.12-2022 find Baggage,Seat AND Meal Amount through Function
				-(dbo.Get_SSR_Amount_By_SSR_Type (book.riyaPNR,'Baggage',pax.totalFare,pax.paxType,pax.paxFName,paxLName,TicketNumber)) AS [Extra Baggage Amount],
				-(dbo.Get_SSR_Amount_By_SSR_Type (book.riyaPNR,'Seat',pax.totalFare,pax.paxType,pax.paxFName,paxLName,TicketNumber)) AS [Seat Preference Charge],
				-(dbo.Get_SSR_Amount_By_SSR_Type (book.riyaPNR,'Meals',pax.totalFare,pax.paxType,pax.paxFName,paxLName,TicketNumber)) AS [Meal Charges],
				0 AS [Wheel Chair Charges],	0 AS [SSR Comb Amount],
				 pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
				 ,ISNULL(pax.DropnetCommission,0) AS DropnetCommission
				FROM tblPassengerBookDetails pax WITH(NOLOCK)
				LEFT JOIN tblBookMaster book WITH(NOLOCK) ON pax.fkBookMaster=book.pkId AND AgentID !='B2C' AND book.totalFare>0 AND (pax.paxType='INFANT' OR pax.totalFare>0)
				LEFT JOIN mUser m WITH(NOLOCK) ON m.id=book.mainagentid
				LEFT JOIN Paymentmaster pmt WITH(NOLOCK) ON book.orderId=pmt.order_id
				LEFT JOIN B2BRegistration r WITH(NOLOCK) ON r.FKUserID=book.AgentID
				LEFT JOIN agentLogin A WITH(NOLOCK) ON A.UserID=book.AgentID
				LEFT JOIN B2BRegistration r1 WITH(NOLOCK) ON r1.FKUserID=A.ParentAgentID
				LEFT JOIN PNRRetriveDetails p WITH(NOLOCK) ON p.OrderID=book.orderId
				LEFT JOIN  #temp91 ON pmt.order_id=#temp91.orderId	
				LEFT JOIN tblOwnerCurrency O WITH(NOLOCK) ON O.OfficeID=book.OfficeID
				LEFT JOIN TblErpVendorCode EV WITH (NOLOCK) on book.OfficeID = EV.OfficeID and book.Country in ('AE')
				--LEFT JOIN tblSSRDetails SSR ON ssr.fkPassengerid=pax.pid AND SSR_Type='Baggage' AND SSR_Status=1 AND ssr.SSR_Amount>0
				WHERE book.BookingStatus IN (4,11) AND book.Country IN (SELECT C.CountryCode  FROM mUserCountryMapping UM WITH(NOLOCK)
				INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid  AND IsActive=1) 
				AND (CONVERT(date,pax.CancelledDate) >=CONVERT(date,@frmDate) AND CONVERT(date,pax.CancelledDate) <=CONVERT(date,@toDate)
				OR @frmDate is null AND @toDate is null ) AND A.UserTypeid=@usertype AND book.Country=@country 
				AND AgentID =(CASE @agentid WHEN '' THEN agentid else @agentid END) AND book.totalFare>0 
				AND ((BOOK.VendorName!='Amadeus' AND (pax.paxType='INFANT' OR pax.totalFare>0))
				OR (BOOK.VendorName='Amadeus' AND PAX.isReturn=0 AND book.BookingSource!='Web') OR book.BookingSource='Web')
			)p 
			LEFT JOIN mAttrributesDetails MA WITH(NOLOCK) ON MA.OrderID=p.OrderID 

			UNION 

			SELECT p.pid, 'CREDIT' AS [TYPE] ,CONVERT(varchar(11),p.IssueDate,103) AS IssueDate, LocationCode,
			p.TransactionType, (SELECT VALUE FROM mCommon M WITH(NOLOCK) WHERE M.ID= P.userTypeID ) AS  AgentId,p.airlinePNR AS PNR, p.riyaPNR MoBookingNumber,
			CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END AS TicketNumber,
			p.FirstName,p.LastName,
			(SELECT TOP 1 currencycode FROM mcountrycurrency WITH(NOLOCK) WHERE countrycode=@country) AS CurrencyType,
			p.BasicFare,p.YQTax,p.OCTax AS [OC tax],p.TaxTotal,p.QTaxBase,
			p.TotalFare,	IataCommissionC,''	AdditionalCommissionC, PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
			IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare, FormofPayment,
			MarkupOnFare,	MarkupOnTax, p.ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
			''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
			p.sector AS Sector,Flight AS FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 
			CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END AS BookingType,
			Penalty ,	[MarkupOnCancellation],CancellationServiceFee	AS[Service Fee ON Cancellation],''	[Mgmt Fee ON Cancellation],
			''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
			[Employee Dimension Code],p.promoCode AS [TR/PO No.],''	[Card Type],[IATA Code],''	[Contact No.],''[Cancellation Type],
			'Travel Next' AS [Booking Source Type],''[BTA Sales],VesselName AS	[Vessel Name],''[Narration 1],''[Narration 2],
			''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
			,p.YrTax,p.XTTax,p.JNTax,p.OCTax,p.INTax ,p.airCode	,
			ISNULL(REPLACE((CASE WHEN p.airCode='SG' THEN 'SG' 
			WHEN p.airCode='G8' THEN 'G8' 
			WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6E' END) 
			ELSE ( CASE WHEN p.VendorName='Amadeus' THEN(
			SELECT top 1 _CODE FROM AirlinesName WITH(NOLOCK) WHERE [AWB Prefix] IN ( CAST (SUBSTRING(p.ticket1, CHARINDEX(' ', p.ticket1), 4) AS float) ))
				ELSE p.airCode END) END),'?',''),p.airCode) AS supplierCode,
			VendorNo,CustomerNumber,
			PaxType, '' FROMCity,'' ToCity,airlinePNR,rbd,
			'' AS 'CRS',p.FROMAirport,p.toAirport,p.equipment,'' AS baggage,FlyingHour,
			ProductType,'PRD100101' AS ProductCode,BranchCode,'' AS [Emp Code],
			p.RegistrationNumber,p.CompanyName,p.CAddress,p.CState,p.CContactNo,p.CEmailID,
			JobCodeBookingGivenBy,VesselName, ReasonofTravel, TravelRequestNumber, CostCenter, BudgetCode, EmpDimession, SwonNo, TravelerType, Location, Department, Grade, 
 				ma.Bookedby, Designation, Chargeability, NameofApprover, ReferenceNo, TR_POName, p.RankNo, AType, BookingReceivedDate,P.ROE,P.AgentROE
			, promodiscount,p.[MCO amount],p.[MCO number],OfficeID,cardtype AS crdtype,cardnumber AS crdno
			, reScheduleCharge AS RescheduleCharges, SupplierPenalty, RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR ,CONVERT(varchar(11),p.IssueDate,103) AS RescheduleDate,
			[Extra Baggage Amount],	 [Seat Preference Charge], [Meal Charges], [Wheel Chair Charges],	[SSR Comb Amount],p.YMTax,p.WOTax,p.OBTax,p.RFTax,ma.OBTCno AS OBTC
			,Traveltype,Changedcostno,Travelduration,TASreqno,Companycodecc,Projectcode,
			AuthCode AS [Card Approval Code],ExpiryDate AS [Card expiry],MCOMerchantfee AS [MCO Merchant fee],DropnetCommission
			FROM(
				SELECT (pax.pid), book.riyaPNR,book.GDSPNR,pax.CancelledDate IssueDate, book.GDSPNR AS PNR, book.airCode,
				(ticketNum) ticket1,(ticketNum) AS ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
				-(pax.basicFare + ISNULL(pax.Markup,0))  as	BasicFare	,
				-(PAX.totalTax) AS TaxTotal,
				-((pax.totalFare + ISNULL(pax.Markup,0))-pax.serviceCharge)  as TotalFare,
				-CAST((ISNULL((CASE WHEN ((BOOK.B2bFareType=2 OR book.B2bFareType=3)) THEN ((pax.B2BMarkup+pax.HupAmount+ISNULL(pax.MarkupOnTaxFare,0))/ISNULL(book.AgentROE,0)) ELSE pax.HupAmount END),0))AS decimal(18,2)) AS MarkupOnTax,
				-CAST(((CASE WHEN BOOK.B2bFareType=1 THEN (pax.B2BMarkup/ISNULL(book.AgentROE,0)) ELSE 0 END)+PAX.BFC + pax.CancellationMarkup) AS decimal(18,2)) AS MarkupOnFare,
				-(CONVERT(float,[YQ])) AS YQTax,
				-(ISNULL(pax.[YRTax],0)) AS YrTax,
				-(ISNULL(pax.[INTax],0)) AS INTax,
				-(ISNULL(pax.[JNTax],0)) AS JNTax,
				-(ISNULL(pax.[OCTax],0)) AS OCTax,
				-(ISNULL(pax.[YMTax],0)) AS YMTax,
				-(ISNULL(pax.[WOTax],0)) AS WOTax,
				-(ISNULL(pax.[OBTax],0)) AS OBTax,
				-(ISNULL(pax.[RFTax],0)) AS RFTax,
				-(ISNULL((pax.ExtraTax),0) )AS XTTax,
				0	QTaxBase,	
				([CounterCloseTime]) AS bookType,
				(#temp91.Sector)  as sector,(book.airCode) AS code,
				(pmt.payment_mode) AS mode,(book.flightNo) AS filght,
				(#temp91.airlinePNR) AS airlinePNR, (#temp91.Class) AS class, 
				(#temp91.flight) AS Flight,(#temp91.farebasis) AS farebasis,
				--sum(ISNULL(pax.serviceCharge,0) )AS ServiceCharge,
				CASE WHEN book.ServiceFee>0 THEN ISNULL(-pax.ServiceFee,0) ELSE 0 END AS ServiceCharge,
				(#temp91.travel) AS travelDate, 
				-(ISNULL(book.FlatDiscount,0) + ISNULL(pax.PLBCommission,0) + CAST(ISNULL(book.PromoDiscount/BOOK.ROE,0) AS decimal(16,2))) AS PlbC, 
				-pax.IATACommission AS IataCommissionC, 
				( -pax.Markup ) AS IataCommissionV
				,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID AS OfficeID,promoCode,#temp91.rbd,book.FROMAirport,book.toAirport,book.equipment,
				DATEDIFF(HOUR,book.deptTime,book.arrivalTime) AS 'FlyingHour',
				(ISNULL((SELECT top 1 (CASE WHEN(count(Code)>1) THEN 'Air-domestic' ELSE 'Air-Int'END) AS sector FROM sectors WITH(NOLOCK)
				WHERE ((ltrim(rtrim(Code)) = book.frmSector  or	ltrim(rtrim(Code)) = book.toSector)  AND [Country code]=A.BookingCountry)group by [Country Code]),'Air-Int')) AS 'ProductType',
				ISNULL(r.LocationCode,R1.LocationCode) AS LocationCode,ISNULL(r.BranchCode,R1.BranchCode) AS BranchCode,(CASE WHEN pmt.payment_mode='passThrough' THEN 'CUSTOMER' WHEN pmt.payment_mode='Credit' THEN 'CORPORATE' ELSE 'CASH' END)AS FormofPayment,
				(CASE WHEN a.UserTypeID=3 AND r.empcodemandate=0 THEN '' ELSE m.UserName END) AS [Employee Dimension Code],
				--(SELECT top 1 (case when 
				--	book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'BOMVEND007913'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then 'VEND000178'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then 'VEND00102'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then 'UVEND00066'       
				--	when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then 'CVEND00041'       
				--	else E.VendorCode end) FROM tblERPDetails E WITH(NOLOCK) WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country) AS VendorNo,
				(Case WHEN book.Country='US' AND book.OfficeID='00FK' THEN 'UVEND01206' 
					when EV.VendorCode is null then					
					  (SELECT top 1 (case when 
					book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'BOMVEND007913'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then 'VEND000178'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then 'VEND00102'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then 'UVEND00066'       
					when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then 'CVEND00041'       
					else E.VendorCode end) FROM tblERPDetails E WITH(NOLOCK) WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country )
					ELSE EV.VendorCode end) as VendorNo,
				(SELECT top 1 (CASE WHEN CustomerCode='AgentCustID' THEN ISNULL(r.Icast,R1.Icast) ELSE CustomerCode END) AS CustomerNumber FROM tblERPDetails E WITH(NOLOCK)
				WHERE E.OwnerID=book.OfficeID AND AgentCountry=book.Country AND ERPCountry= @country) AS CustomerNumber,
				--O.IATA AS [IATA Code]
				(case when book.VendorName='TravelFusion' and LEN(pax.ticketNum) < 10then 'RIYAAPITF'       
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'IN' then '14338855'      
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'AE' then '86215290'      
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'US' then '45828661'      
					   when book.VendorName='TravelFusion' and LEN(pax.ticketNum) > 10and book.Country = 'CA' then '62500082'      
					   else O.IATA end) as [IATA Code]
				,VendorName,A.userTypeID,book.orderId,book.ROE,book.AgentROE,book.RegistrationNumber,book.CompanyName,book.CAddress,book.CState,book.CContactNo,book.CEmailID
				,-(ISNULL(pax.FlatDiscount,0) + ISNULL(pax.DropnetCommission,0)) AS promodiscount,
				-pax.MCOAmount AS [MCO amount],pax.MCOTicketNo AS [MCO number],pax.CancellationPenalty AS Penalty ,pax.CancellationMarkup AS [MarkupOnCancellation]
				,pax.CancellationServiceFee,
				pmt.cardtype,pmt.MaskCardNumber AS cardnumber,CASE WHEN CheckboxVoid=1 THEN 'VOID' ELSE 'RFND' END AS TransactionType,pax.profession AS 'Rankno'
				, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp91.PreviousAirlinePNR,

				---(SELECT sum(SSR_Amount) FROM tblSSRDetails s
				--INNER JOIN tblPassengerBookDetails p ON p.pid=s.fkPassengerid AND p.pid=pax.pid
				--INNER JOIN tblBookMaster b ON b.pkId=p.fkBookMaster
				--WHERE (b.orderId=book.orderId) AND SSR_Type='Baggage' AND s.SSR_Status=1 AND SSR_Amount>0 
				--group by p.pid) AS [Extra Baggage Amount], 
				---(SELECT sum(SSR_Amount) FROM tblSSRDetails s
				--INNER JOIN tblPassengerBookDetails p ON p.pid=s.fkPassengerid AND p.pid=pax.pid
				--INNER JOIN tblBookMaster b ON b.pkId=p.fkBookMaster
				--WHERE (b.orderId=book.orderId) AND SSR_Type='Seat' AND s.SSR_Status=1 AND SSR_Amount>0 
				--group by p.pid) AS [Seat Preference Charge], 
				---(SELECT sum(SSR_Amount) FROM tblSSRDetails s
				--INNER JOIN tblPassengerBookDetails p ON p.pid=s.fkPassengerid AND p.pid=pax.pid
				--INNER JOIN tblBookMaster b ON b.pkId=p.fkBookMaster
				--WHERE (b.orderId=book.orderId) AND SSR_Type='Meals' AND s.SSR_Status=1 AND SSR_Amount>0 
				--group by p.pid) AS [Meal Charges],	

				--Jitendra Nakum 30.12-2022 find Baggage,Seat AND Meal Amount through Function
				-(dbo.Get_SSR_Amount_By_SSR_Type (book.riyaPNR,'Baggage',pax.totalFare,pax.paxType,pax.paxFName,paxLName,TicketNumber)) AS [Extra Baggage Amount],
				-(dbo.Get_SSR_Amount_By_SSR_Type (book.riyaPNR,'Seat',pax.totalFare,pax.paxType,pax.paxFName,paxLName,TicketNumber)) AS [Seat Preference Charge],
				-(dbo.Get_SSR_Amount_By_SSR_Type (book.riyaPNR,'Meals',pax.totalFare,pax.paxType,pax.paxFName,paxLName,TicketNumber)) AS [Meal Charges],
				0 AS [Wheel Chair Charges],	0 AS [SSR Comb Amount],
				pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
				,ISNULL(pax.DropnetCommission,0) AS DropnetCommission
				FROM tblPassengerBookDetails pax WITH(NOLOCK)
				LEFT JOIN tblBookMaster book WITH(NOLOCK) ON pax.fkBookMaster=book.pkId AND AgentID !='B2C' AND book.totalFare>0 AND (pax.paxType='INFANT' OR pax.totalFare>0)
				LEFT JOIN mUser m WITH(NOLOCK) ON m.id=book.mainagentid
				LEFT JOIN Paymentmaster pmt WITH(NOLOCK) ON book.orderId=pmt.order_id
				LEFT JOIN B2BRegistration r WITH(NOLOCK) ON r.FKUserID=book.AgentID
				LEFT JOIN agentLogin A WITH(NOLOCK) ON A.UserID=book.AgentID
				LEFT JOIN B2BRegistration r1 WITH(NOLOCK) ON r1.FKUserID=A.ParentAgentID
				LEFT JOIN PNRRetriveDetails p WITH(NOLOCK) ON p.OrderID=book.orderId
				LEFT JOIN  #temp91 ON pmt.order_id=#temp91.orderId	
				LEFT JOIN tblOwnerCurrency O WITH(NOLOCK) ON O.OfficeID=book.OfficeID
				LEFT JOIN TblErpVendorCode EV WITH (NOLOCK) on book.OfficeID = EV.OfficeID and book.Country in ('AE')
				--LEFT JOIN tblSSRDetails SSR ON ssr.fkPassengerid=pax.pid AND SSR_Type='Baggage' AND SSR_Status=1 AND ssr.SSR_Amount>0
				WHERE book.BookingStatus IN (4,11) AND book.Country IN (SELECT C.CountryCode  FROM mUserCountryMapping UM WITH(NOLOCK)
				INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid  AND IsActive=1) 
				AND (CONVERT(date,pax.CancelledDate) >=CONVERT(date,@frmDate) AND CONVERT(date,pax.CancelledDate) <=CONVERT(date,@toDate)
				OR @frmDate is null AND @toDate is null ) AND A.UserTypeid=@usertype 
				AND (('RiyaapiTF' IN ( SELECT OwnerID FROM tblERPDetails WITH(NOLOCK) WHERE book.VendorName='TravelFusion' AND OwnerID= 'RiyaapiTF' AND ERPCountry=@country AND AgentCountry=book.Country AND OwnerCountry=@country))
				OR (BOOK.OfficeID IN ( SELECT OwnerID FROM tblERPDetails WITH(NOLOCK) WHERE book.VendorName!='TravelFusion' AND OwnerID= book.OfficeID AND ERPCountry=@country AND AgentCountry=book.Country AND OwnerCountry=@country)))
				--AND (BOOK.OfficeID IN ( SELECT OwnerID FROM tblERPDetails WITH(NOLOCK) WHERE OwnerID= book.OfficeID AND ERPCountry=@country AND AgentCountry=book.Country AND OwnerCountry=@country AND book.VendorName!='TravelFusion' ))
				AND AgentID =(CASE @agentid WHEN '' THEN agentid else @agentid END) AND book.totalFare>0 AND ((BOOK.VendorName!='Amadeus' AND (pax.paxType='INFANT' OR pax.totalFare>0))
				OR (BOOK.VendorName='Amadeus' AND PAX.isReturn=0 AND book.BookingSource!='Web') OR book.BookingSource='Web')
			)p 
			LEFT JOIN mAttrributesDetails MA WITH(NOLOCK) ON MA.OrderID=p.OrderID
			--order by p.IssueDate asc
			drop table #temp91
		END

		--status 3 Pre refund
		ELSE IF(@status=3)--Pre refund
		BEGIN
			SELECT * into #temp6 FROM
			(
				SELECT t.orderId, 
				STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
				STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
				STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS AIRPNR,
				STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
				STUFF((SELECT ',' + CONVERT(varchar(11),s.depDate,103)+','+CONVERT(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
				STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis
				, t.PreviousAirlinePNR 
				FROM tblBookItenary AS t WITH(NOLOCK) GROUP BY t.orderId, t.PreviousAirlinePNR
			) X
			
			SELECT 'CREDIT' AS [TYPE] ,CONVERT(varchar(11),p.IssueDate,103) AS IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
			'RFND' TransactionType,'B2B' AS  AgentId ,p.air AS PNR, p.riyaPNR MoBookingNumber,

			CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END AS TicketNumber,

			p.FirstName,p.LastName,(CASE WHEN OfficeID='DFW1S212A' THEN 'USD' WHEN OfficeID='YWGC4211G' THEN 'CAD' ELSE 'INR' END) AS CurrencyType,(0-p.BasicFare) AS BasicFare,(0-p.YQTax) AS YQTax ,p.OCTax AS [OC tax],
			(0-p.TaxTotal) AS TaxTotal,(0-p.QTaxBase) AS QTaxBase,(0-p.TotalFare) AS TotalFare,
			IataCommissionC,''	AdditionalCommissionC,PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
			IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare,'CASH' AS FormofPayment,
			''	MarkupOnFare, (0-ServiceCharge)	MarkupOnTax, 0 AS ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
			''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
			p.sector AS Sector,Flight AS FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

			CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END AS BookingType,

			Penalty ,MarkupOnCancellation,''	AS[Service Fee ON Cancellation],''	[Mgmt Fee ON Cancellation],
			''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
			''	[Employee Dimension Code],''[TR/PO No.],''	[Card Type],''	[IATA Code],''	[Contact No.],''[Cancellation Type],
			'B2C' AS [Booking Source Type],''[BTA Sales],VesselName AS	[Vessel Name],''[Narration 1],''[Narration 2],
			''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
			,(0-p.YrTax) AS YrTax,(0-p.XTTax) AS XTTax,(0-p.JNTax) AS JNTax,(0-p.OCTax) AS OCTax,(0-p.INTax) AS INTax ,p.airCode	,
			--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) AS supplierCode,
			--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) AS VendorNo,
			REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') AS supplierCode,
			--REPLACE((CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) 
			-- WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) THEN 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) THEN 'RABOM0300004' ELSE 'VEND000180' END),'?','') AS VendorNo,
			CASE WHEN Vendor_No IS NOT NULL THEN LEFT(Vendor_No, CHARINDEX('-', Vendor_No)-1) ELSE(CASE WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster WITH(NOLOCK)) THEN 'RABOM0300004' 
			WHEN P.airCode  in (SELECT AirlineCode1 FROM TblSTSAirLineMaster WITH(NOLOCK)) THEN 'RABOM0300004' ELSE '' END) END  as VendorNo,
			PaxType, '' FROMCity,'' ToCity,orderId,isReturn
			,cardtype AS crdtype,cardnumber AS crdno
			, reScheduleCharge AS RescheduleCharges, SupplierPenalty, RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR,

			 [Extra Baggage Amount],	 [Seat Preference Charge], [Meal Charges], [Wheel Chair Charges],	[SSR Comb Amount],p.YMTax,p.WOTax,p.OBTax,p.RFTax
			 ,Traveltype,Changedcostno,Travelduration,TASreqno,Companycodecc,Projectcode,
			 AuthCode AS [Card Approval Code],ExpiryDate AS [Card expiry],MCOMerchantfee AS [MCO Merchant fee],DropnetCommission
			FROM

			(SELECT book.riyaPNR,book.GDSPNR,pax.CancelledDate IssueDate, book.GDSPNR AS PNR, book.airCode,
			MAX(ticketNum) ticket1,min(ticketNum) AS ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
			(pax.basicFare) AS	BasicFare	,(pax.totalTax) TaxTotal,
			0	QTaxBase	,((pax.totalFare)-pax.serviceCharge)  as TotalFare,
			(CONVERT(float,[YQ])) AS YQTax,MAX([CounterCloseTime]) AS bookType,
			MAX(#temp6.Sector)  as sector,MAX(book.airCode) AS code,
			MAX(pmt.payment_mode) AS mode,MAX(flightNo) AS filght,
			MAX(#temp6.AIRPNR) AS air, MAX(#temp6.Class) AS class, 
			MAX(#temp6.flight) AS Flight,MAX(#temp6.farebasis) AS farebasis,
			(ISNULL(pax.[YRTax],0)) AS YrTax,(ISNULL(pax.[INTax],0)) AS INTax,
			(ISNULL(pax.[JNTax],0) )AS JNTax,(ISNULL(pax.[OCTax],0)) AS OCTax,

			(ISNULL(pax.[YMTax],0)) AS YMTax,
			(ISNULL(pax.[WOTax],0)) AS WOTax,
			(ISNULL(pax.[OBTax],0)) AS OBTax,
			(ISNULL(pax.[RFTax],0)) AS RFTax,
			(ISNULL(pax.[ExtraTax],0) )AS XTTax,ISNULL(ROUND((pax.Markup / 118 * 100),2),0) AS ServiceCharge,
			MAX(#temp6.travel) AS travelDate,ch.Panelty AS Penalty,ch.CancellationCharge AS 'MarkupOnCancellation',
			book.orderId,pax.isReturn,(0-(ISNULL(book.FlatDiscount,0) + ISNULL(book.PLBCommission,0) + CAST(ISNULL(book.PromoDiscount/BOOK.ROE,0) AS decimal(16,2)))) AS PlbC, 
			pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	AS IataCommissionV,pax.serviceCharge AS MarkupOnTax
			,book.SupplierCode,book.Vendor_No,book.Country,book.OfficeID AS OfficeID,pmt.cardtype,pmt.MaskCardNumber AS cardnumber
			, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp6.PreviousAirlinePNR,
			ssr.SSR_Amount AS [Extra Baggage Amount],	0 AS [Seat Preference Charge],	0 AS [Meal Charges],	0 AS [Wheel Chair Charges],	0 AS [SSR Comb Amount],
			pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
			,ISNULL(pax.DropnetCommission,0) AS DropnetCommission
			FROM tblPassengerBookDetails pax WITH(NOLOCK)
			LEFT JOIN tblBookMaster book WITH(NOLOCK) ON pax.fkBookMaster=book.pkId
			LEFT JOIN Paymentmaster pmt WITH(NOLOCK) ON book.orderId=pmt.order_id
			LEFT JOIN  #temp6 ON pmt.order_id=#temp6.orderId	
			INNER JOIN CancellationHistory Ch WITH(NOLOCK) ON ch.OrderId=book.orderId AND FlagType=1
			LEFT JOIN tblSSRDetails SSR WITH(NOLOCK) ON ssr.fkPassengerid=pax.pid AND SSR_Type='Baggage' AND SSR_Status=1 AND ssr.SSR_Amount>0
			--WHERE pax.IsRefunded=1 AND book.IsBooked=1
			WHERE pax.IsCancelled=0 AND pax.isProcessRefund=1 AND  book.Country IN (SELECT C.CountryCode  FROM mUserCountryMapping UM WITH(NOLOCK)
						INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid  AND IsActive=1) 
			AND (CONVERT(date,ch.UpdateDate) >=CONVERT(date,@frmDate) AND CONVERT(date,ch.UpdateDate) <=CONVERT(date,@toDate)
			OR @frmDate is null AND @toDate is null )  and A.UserTypeid=@usertype AND book.Country=@country
			AND AgentID =(CASE @agentid WHEN '' THEN agentid else @agentid END)
			group by book.riyaPNR,book.GDSPNR,pax.CancelledDate,pax.paxFName,pax.title,pax.paxLName ,pax.paxType,book.orderid,book.airCode,ch.RefundAmount,ch.CancellationCharge,
			book.orderId,isReturn,book.FlatDiscount,book.PromoDiscount,book.PLBCommission,book.VendorCommissionPercent,pax.IATACommission,pax.serviceCharge, ch.Panelty,pax.Markup
			,book.SupplierCode,book.Vendor_No,pax.basicFare,pax.totalTax,pax.totalFare,pax.YQ,pax.YRTax,pax.INTax,pax.JNTax,pax.OCTax,pax.ExtraTax,book.Country,OfficeID,ROE
			)p order by mobookingnumber, plbc desc

			drop table #temp2
 		END

 		ELSE IF(@status=4)--status-PromoCode
		BEGIN
			SELECT * into #temp7 FROM
			(
			SELECT t.orderId, 
			STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector,
			STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS flight,
			STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS AIRPNR,
			STUFF((SELECT '/' + s.cabin FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Class,
			STUFF((SELECT ',' + CONVERT(varchar(11),s.depDate,103)+','+CONVERT(varchar(11),s.arrivalDate,103) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS travel,
			STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = t.orderId FOR XML PATH('')),1,1,'') AS farebasis
			, t.PreviousAirlinePNR 
			FROM tblBookItenary AS t WITH(NOLOCK) GROUP BY t.orderId, t.PreviousAirlinePNR) X
			SELECT p.pid, 'CREDIT' AS [TYPE] ,CONVERT(varchar(11),p.IssueDate,103) AS IssueDate,'ICUST35086' CustomerNumber,'BOMRC' LocationCode,
			'TKTT' TransactionType,(SELECT VALUE FROM mCommon M WITH(NOLOCK) WHERE M.ID= P.userTypeID ) AS  AgentId,p.air AS PNR, p.riyaPNR MoBookingNumber,

			CASE WHEN p.ticket1=p.ticket2 THEN p.ticket1 ELSE p.ticket1+','+p.ticket2 END AS TicketNumber,

			p.FirstName,p.LastName,(CASE WHEN OfficeID='DFW1S212A' THEN 'USD' WHEN OfficeID='YWGC4211G' THEN 'CAD' ELSE 'INR' END) AS CurrencyType,p.BasicFare,p.YQTax,p.OCTax AS [OC tax],p.TaxTotal,p.QTaxBase,
			p.TotalFare,	IataCommissionC,''	AdditionalCommissionC, PlbC,''	FlownIncentiveC	,''BoardingIncentiveC,
			IataCommissionV	,''AdditionalCommissionV,'' PlbV,''	FlownIncentiveV,'' BoardingIncentiveV,'' NetFare,'CASH' AS FormofPayment,
			''	MarkupOnFare,	MarkupOnTax, ServiceCharge,'' VendorServiceFee,''	ManagementFee,'' IssuedInExchange,
			''	TourCode,''	EqualFareCurrency,'' EqulantFare,'' FC_STRING,
			p.sector AS Sector,Flight AS FlightNumber,p.class,p.travelDate DateofTravel,p.farebasis, 

			CASE WHEN p.bookType=1 THEN 'D' ELSE 'I' END AS BookingType,

			''	Penalty ,''  as	[MarkupOnCancellation],''	AS[Service Fee ON Cancellation],''	[Mgmt Fee ON Cancellation],
			''	[No Show Charge],''	[No Show Airline],'' AdditionalCxlBase,'' AdditionalCxlTax,''[VMPD/Exo No.],
			''	[Employee Dimension Code],''[TR/PO No.],''	[Card Type],''	[IATA Code],''	[Contact No.],''[Cancellation Type],
			'B2C' AS [Booking Source Type],''[BTA Sales],VesselName AS	[Vessel Name],''[Narration 1],''[Narration 2],
			''	[EMD Ticket Type],'' [Tax YM],''[Tax WO],''	[Cust Info1],''	[Cust Info2],''	[Cust Info3],''	[Cust Info4],''	[Cust Info5]
			,p.YrTax,p.XTTax,p.JNTax,p.OCTax,p.INTax ,p.airCode	,
			--(CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END) AS supplierCode,
			--(CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) ELSE 'VEND000180' END) AS VendorNo,
			REPLACE((CASE WHEN p.airCode='SG' THEN 'SGO' WHEN p.airCode='G8' THEN 'G8W' WHEN p.airCode='6E' THEN (CASE WHEN p.SupplierCode IS NOT NULL THEN p.SupplierCode ELSE '6EQ' END) ELSE p.airCode END),'?','') AS supplierCode,
			--REPLACE((CASE WHEN p.airCode='SG' THEN 'VEND004166' WHEN p.airCode='G8' THEN 'VEND004164' WHEN p.airCode='6E' THEN (CASE WHEN p.VendorCode IS NOT NULL THEN p.VendorCode ELSE 'VEND008272' END) 
 			 --WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) THEN 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster) THEN 'RABOM0300004' ELSE 'VEND000180' END),'?','') AS VendorNo,
			CASE WHEN Vendor_No IS NOT NULL THEN LEFT(Vendor_No, CHARINDEX('-', Vendor_No)-1) ELSE(CASE WHEN P.airCode  in (SELECT AirlineCode FROM TblSTSAirLineMaster WITH(NOLOCK)) THEN 'RABOM0300004' WHEN P.airCode  in (SELECT AirlineCode1 FROM TblSTSAirLineMaster WITH(NOLOCK)) THEN 'RAB
			OM0300004' ELSE '' END) END  as VendorNo,
			PaxType, '' FROMCity,'' ToCity,promoCode
			, reScheduleCharge AS RescheduleCharges, SupplierPenalty, RescheduleMarkup, PreviousRiyaPNR, PreviousAirlinePNR ,
			 AuthCode AS [Card Approval Code],ExpiryDate AS [Card expiry],MCOMerchantfee AS [MCO Merchant fee],DropnetCommission
			FROM

			(SELECT pax.pid, book.riyaPNR,book.GDSPNR,book.inserteddate IssueDate, book.GDSPNR AS PNR, book.airCode,
			MAX(ticketNum) ticket1,min(ticketNum) AS ticket2,pax.paxType PaxType,pax.title +' '+ pax.paxFName FirstName,pax.paxLName LastName,
			sum(pax.basicFare) AS	BasicFare	,sum(pax.totalTax) TaxTotal,
			0	QTaxBase	,sum((pax.totalFare)-pax.serviceCharge)  as TotalFare,
			sum(CONVERT(float,[YQ])) AS YQTax,MAX([CounterCloseTime]) AS bookType,
			MAX(#temp7.Sector)  as sector,MAX(book.airCode) AS code,
			MAX(pmt.payment_mode) AS mode,MAX(flightNo) AS filght,
			MAX(#temp7.AIRPNR) AS air, MAX(#temp7.Class) AS class, 
			MAX(#temp7.flight) AS Flight,MAX(#temp7.farebasis) AS farebasis,
			sum(ISNULL(pax.[YRTax],0)) AS YrTax,sum(ISNULL(pax.[INTax],0)) AS INTax,
			sum(ISNULL(pax.[JNTax],0) )AS JNTax,sum(ISNULL(pax.[OCTax],0)) AS OCTax,

			(ISNULL(pax.[YMTax],0)) AS YMTax,
			(ISNULL(pax.[WOTax],0)) AS WOTax,
			(ISNULL(pax.[OBTax],0)) AS OBTax,
			(ISNULL(pax.[RFTax],0)) AS RFTax,
			sum(ISNULL(pax.[ExtraTax],0) )AS XTTax,--sum(ISNULL(pax.serviceCharge,0) )AS ServiceCharge,
			ISNULL(ROUND((pax.Markup / 118 * 100),2),0) AS ServiceCharge,
			MAX(#temp7.travel) AS travelDate, (ISNULL(book.FlatDiscount,0) + ISNULL(book.PLBCommission,0) + CAST(ISNULL(book.PromoDiscount/BOOK.ROE,0) AS decimal(16,2))) AS PlbC, 
			pax.IATACommission AS IataCommissionC, book.VendorCommissionPercent	AS IataCommissionV,pax.serviceCharge AS MarkupOnTax
			,book.SupplierCode,book.Vendor_No,book.promoCode,book.Country,book.OfficeID AS OfficeID
			, pax.SupplierPenalty, pax.reScheduleCharge, pax.RescheduleMarkup, book.PreviousRiyaPNR, #temp7.PreviousAirlinePNR,
			pmt.AuthCode,pmt.ExpiryDate,pax.MCOMerchantfee
			,ISNULL(pax.DropnetCommission,0) AS DropnetCommission
			FROM tblPassengerBookDetails pax WITH(NOLOCK)
			LEFT JOIN tblBookMaster book WITH(NOLOCK) ON pax.fkBookMaster=book.pkId
			LEFT JOIN Paymentmaster pmt WITH(NOLOCK) ON book.orderId=pmt.order_id
			LEFT JOIN  #temp7 ON pmt.order_id=#temp7.orderId	WHERE (book.IsBooked=1 OR book.BookingStatus=1) AND book.Country IN (SELECT C.CountryCode  FROM mUserCountryMapping UM WITH(NOLOCK)
						INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid  AND IsActive=1) 
			AND (CONVERT(date,book.inserteddate) >=CONVERT(date,@frmDate) AND CONVERT(date,book.inserteddate) <=CONVERT(date,@toDate)
			OR @frmDate is null AND @toDate is null ) AND PromoDiscount >0  and A.UserTypeid=@usertype AND book.Country=@country
			AND AgentID =(CASE @agentid WHEN '' THEN agentid else @agentid END)
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
    ON OBJECT::[dbo].[fetchERPData_NEW2] TO [rt_read]
    AS [dbo];

