CREATE PROCEDURE [dbo].[RTTBilling_GetDataByPNR]
	@PNRType Varchar(10)
	,@PNR Varchar(20)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @SectorCount Int, @SectorName VARCHAR(200), @FlightNo VARCHAR(200), @BookingClass VARCHAR(200)

    IF (@PNRType = 'LCC')
	BEGIN
		SELECT [Sector Name] INTO #mT FROM LCC WHERE PNRNo = @PNR
		GROUP BY [Sector Name]

		SELECT @SectorCount = COUNT(*) FROM #mT

		DROP TABLE #mT

		SELECT  @SectorName = STUFF((SELECT ',' + [Sector Name] FROM LCC WHERE PNRNo = @PNR GROUP BY [Sector Name], [Travel Start Date] ORDER BY [Travel Start Date] FOR XML PATH ('')), 1, 1, '')
		
		SELECT @FlightNo = STUFF((SELECT ',' + [Flight No] FROM LCC WHERE PNRNo = @PNR GROUP BY [Flight No], [Travel Start Date] ORDER BY [Travel Start Date] FOR XML PATH ('')), 1, 1, '')
		
		SELECT @BookingClass = STUFF((SELECT ',' + [Booking Class] FROM LCC WHERE PNRNo = @PNR GROUP BY [Booking Class], [Travel Start Date] ORDER BY [Travel Start Date] FOR XML PATH ('')), 1, 1, '')

		SELECT [CUST ID] AS CustID
		, Staff AS StaffNo
		, FORMAT([Posting Date], 'dd/MMM/yyyy') AS IssueDate
		, [Product Type] AS CounterCloseTime
		, FORMAT([Travel Start Date], 'dd/MMM/yyyy') AS DepartureDate
		, FORMAT((CASE WHEN [Travel End Date] IS NULL THEN [Travel Start Date] ELSE [Travel End Date] END), 'dd/MMM/yyyy') AS ArrivalDate
		, PNRNo
		, [Supplier Code] AS SupplierCode
		, [Ticket No] AS TicketNo
		, [Pax Name] AS PaxName
		, [Base Amount] AS BaseFare
		, [Tax Amount] AS TotalTax
		, [YQ Amount] AS YQTax
		, [YR Amount] AS YRTax
		, [IN Amount] AS INTax
		, [JN / K3 Amount] AS JNTax
		, [XT Amount] AS ExtraTax
		, [Service Fee] AS ServiceFee
		, [Discount Amount] AS DiscountAmount
		, [TDS Amount] AS TDSAmount
		, [GST Amount] AS GSTAmount
		, [Invoice Amount] AS InvoiceAmount
		, [Net Amount] AS NetAmount
		, [Sales Currency] AS Currency
		
		, (CASE WHEN @SectorCount = 1 THEN [Sector Name] ELSE @SectorName END) AS SectorName
		, (CASE WHEN @SectorCount = 1 THEN [Booking Class] ELSE @BookingClass END) AS BookingClass
		, (CASE WHEN @SectorCount = 1 THEN [Flight No] ELSE @FlightNo END) AS FlightNo
		
		--, [Narration/OBTC No#] AS OBTCNo
		, [OBTC No#] AS OBTCNo
		, FKUserID AS AgentID --FKUserID AS AgentID
		--, PKID AS MainAgentID --PKID AS MainAgentID
		, mUser.ID AS MainAgentID --PKID AS MainAgentID
		, mUser.EmailID AS LoginEmailID
		, 'IN' AS AgentCountry
		, 'INR' AS AgentCurrency
		, 2 AS UserType --B2B
		, 'INR' AS BaseCurrency
		, AgencyName
		, Icast AS ICust
		, AddrEmail AS AgencyEmail
		, AddrMobileNo AS AgencyContactNo
		, OID AS OfficeID
		, @SectorCount AS SectorCount
		, REPLACE([Sector Name],'/','-') AS FilterSector
		, FORMAT([Dep Time], 'HH:mm:ss') AS DepartureTime1
		, FORMAT([Dep Time1], 'HH:mm:ss') AS DepartureTime2
		, FORMAT([Arr Time], 'HH:mm:ss') AS ArrivalTime1
		, FORMAT([Arr Time1], 'HH:mm:ss') AS ArrivalTime2
		FROM LCC
		LEFT OUTER JOIN B2BRegistration ON B2BRegistration.Icast = [CUST ID]
		LEFT OUTER JOIN mUser ON mUser.EmployeeNo = CONVERT(Varchar(10), Staff)
		WHERE PNRNo = @PNR
	END
	ELSE IF (@PNRType = 'FSC')
	BEGIN
		SELECT [Sector Name] INTO #mT1 FROM FSC WHERE PNRNo = @PNR
		GROUP BY [Sector Name]

		SELECT @SectorCount = COUNT(*) FROM #mT1

		DROP TABLE #mT1

		SELECT  @SectorName = STUFF((SELECT ',' + [Sector Name] FROM FSC WHERE PNRNo = @PNR GROUP BY [Sector Name], [Travel Start Date] ORDER BY [Travel Start Date] FOR XML PATH ('')), 1, 1, '')
		
		SELECT @FlightNo = STUFF((SELECT ',' + [Flight No] FROM FSC WHERE PNRNo = @PNR GROUP BY [Flight No], [Travel Start Date] ORDER BY [Travel Start Date] FOR XML PATH ('')), 1, 1, '')
		
		SELECT @BookingClass = STUFF((SELECT ',' + [Booking Class] FROM FSC WHERE PNRNo = @PNR GROUP BY [Booking Class], [Travel Start Date] ORDER BY [Travel Start Date] FOR XML PATH ('')), 1, 1, '')

		SELECT [CUST ID] AS CustID
		, Staff AS StaffNo
		, FORMAT([Posting Date], 'dd/MMM/yyyy') AS IssueDate
		, [Product Type] AS CounterCloseTime
		, FORMAT([Travel Start Date], 'dd/MMM/yyyy') AS DepartureDate
		, FORMAT((CASE WHEN [Travel End Date] IS NULL THEN [Travel Start Date] ELSE [Travel End Date] END), 'dd/MMM/yyyy') AS ArrivalDate
		, PNRNo
		, [Supplier Code] AS SupplierCode
		, [Ticket No] AS TicketNo
		, [Pax Name] AS PaxName
		, [Base Amount] AS BaseFare
		, [Tax Amount] AS TotalTax
		, [YQ Amount] AS YQTax
		, [YR Amount] AS YRTax
		, [IN Amount] AS INTax
		, [JN / K3 Amount] AS JNTax
		, [XT Amount] AS ExtraTax
		, [Service Fee] AS ServiceFee
		, [Discount Amount] AS DiscountAmount
		, [TDS Amount] AS TDSAmount
		, [GST Amount] AS GSTAmount
		, [Invoice Amount] AS InvoiceAmount
		, [Net Amount] AS NetAmount
		, [Sales Currency] AS Currency
		
		, (CASE WHEN @SectorCount = 1 THEN [Sector Name] ELSE @SectorName END) AS SectorName
		, (CASE WHEN @SectorCount = 1 THEN [Booking Class] ELSE @BookingClass END) AS BookingClass
		, (CASE WHEN @SectorCount = 1 THEN [Flight No] ELSE @FlightNo END) AS FlightNo

		--, [Narration/OBTC No#] AS OBTCNo
		, [OBTC No#] AS OBTCNo
		, FKUserID AS AgentID --FKUserID AS AgentID
		--, PKID AS MainAgentID --PKID AS MainAgentID
		, mUser.ID AS MainAgentID --PKID AS MainAgentID
		, mUser.EmailID AS LoginEmailID
		, 'IN' AS AgentCountry
		, 'INR' AS AgentCurrency
		, 2 AS UserType --B2B
		, 'INR' AS BaseCurrency
		, AgencyName
		, Icast AS ICust
		, AddrEmail AS AgencyEmail
		, AddrMobileNo AS AgencyContactNo
		, OID AS OfficeID
		, @SectorCount AS SectorCount
		, REPLACE([Sector Name],'/','-') AS FilterSector
		, '09:00:00' AS DepartureTime1
		, '09:00:00' AS DepartureTime2
		, '11:00:00'AS ArrivalTime1
		, '11:00:00' AS ArrivalTime2
		FROM FSC 
		LEFT OUTER JOIN B2BRegistration ON B2BRegistration.Icast = [CUST ID]
		LEFT OUTER JOIN mUser ON mUser.EmployeeNo = CONVERT(Varchar(10), Staff)
		WHERE PNRNo = @PNR
	END
END