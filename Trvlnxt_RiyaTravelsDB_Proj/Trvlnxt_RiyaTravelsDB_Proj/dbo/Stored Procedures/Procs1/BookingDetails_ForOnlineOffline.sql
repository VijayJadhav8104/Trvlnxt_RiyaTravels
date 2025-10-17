CREATE PROCEDURE [dbo].[BookingDetails_ForOnlineOffline]
	@AmendmentRef Varchar(50)
	,@RiyaPNR Varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @OrderID Varchar(50), @PaymentMode Varchar(50), @BookingStatus Int, @AgentID Int, @CustomerCode Varchar(50)

	SELECT BookMasterId, ItenaryId, PassengerId, RescheduleDate 
	INTO #mT 
	FROM tbl_AmendmentRequest WHERE AmendmentRef = @AmendmentRef AND RiyaPNR = @RiyaPNR

	SELECT TOP 1 @OrderID = orderId, @BookingStatus = BookingStatus, @AgentID = AgentID FROM tblBookMaster WHERE RiyaPNR = @RiyaPNR
	ORDER BY pkId DESC

	SELECT TOP 1 @PaymentMode = payment_mode FROM Paymentmaster WHERE order_id = @OrderID

	Select TOP 1 @CustomerCode = CustomerCode FROM B2BRegistration WHERE FKUserID = @AgentID

	SELECT fkBookMaster, SUM(SSR_Amount) AS SSRAmount 
	INTO #mTSSR FROM tblSSRDetails 
	WHERE fkItenary IN (SELECT ItenaryId FROM #mT)
	GROUP BY fkBookMaster

	DECLARE @ParentB2BMarkup Numeric(18,2)

	--SELECT @ParentB2BMarkup = SUM(CAST(ParentB2BMarkup AS numeric)) 
	--FROM tblPassengerBookDetails
	--WHERE pid IN (SELECT PassengerId FROM #mT)

	SELECT SUM(CONVERT(numeric(18,2), ParentB2BMarkup)) AS ParentB2BMarkup
	, fkBookMaster
	INTO #mTB2BMarkup FROM tblPassengerBookDetails
	INNER JOIN tblBookMaster ON tblBookMaster.pkId = tblPassengerBookDetails.fkBookMaster
	WHERE pid IN (SELECT PassengerId FROM #mT)
	AND tblBookMaster.BookingStatus IN (1, 7) -- CNF and To Be Reschedule
	GROUP BY fkBookMaster

	SELECT 
		(SELECT (paxFName + ' ' + paxLName) AS PaxName
		, paxType AS PaxType
		, ticketNum AS TicketNo
		, @PaymentMode AS PaymentMode
		, (CASE 
			WHEN @BookingStatus = 0 THEN 'Failed' 
			WHEN @BookingStatus = 1 THEN 'CNF' 
			WHEN @BookingStatus = 2 THEN 'Hold' 
			WHEN @BookingStatus = 3 THEN 'Pending' 
			WHEN @BookingStatus = 4 THEN 'CAN' 
			WHEN @BookingStatus = 5 THEN 'Close' 
			WHEN @BookingStatus = 6 THEN 'To Be Cancelled' 
			WHEN @BookingStatus = 7 THEN 'To Be Reschedule' 
			WHEN @BookingStatus = 8 THEN 'Reschedule' 
			WHEN @BookingStatus = 9 THEN 'Hold Cancel' 
			WHEN @BookingStatus = 10 THEN 'Booking Track' 
			WHEN @BookingStatus = 11 THEN 'Online Cancellation' 
			WHEN @BookingStatus = 12 THEN 'In Process' 
			WHEN @BookingStatus = 13 THEN 'Console Inserted' 
			WHEN @BookingStatus = 14 THEN 'Open Ticket' 
			WHEN @BookingStatus = 15 THEN 'On Hold Canceled' 
			ELSE ''
			END)AS BookingStatus
		, isReturn AS IsReturn
		, paxFName AS FirstName
		, paxLName AS LastName
		, gender AS Gender
		, dateOfBirth AS DOB
		, title AS PaxTitle
		, passportNum AS PassportNo
		, PassIssue AS PassportIssueDate
		, passportIssueCountry AS PassportIssueCountry
		, passexp AS PassportExpiryDate
		, nationality AS Nationality
		, PanNumber AS PANNo
		, NameAsOnPAN AS NamOnPAN
		FROM tblPassengerBookDetails
		WHERE pid IN (SELECT PassengerId FROM #mT)
		FOR JSON PATH
		) AS PaxDetails

		, (SELECT tblBookItenary.frmSector AS FromSector
		, tblBookItenary.toSector AS ToSector
		, RTRIM(LTRIM(tblBookItenary.FlightNo)) AS FlightNo
		, tblBookItenary.deptTime AS DepDate
		, tblBookItenary.arrivalTime AS ArrivalDate
		, tblBookItenary.cabin AS CabinClass
		, tblBookItenary.farebasis AS FareBasis
		, tblBookItenary.fromAirport AS FromAirport
		, tblBookItenary.toAirport AS ToAirport
		, tblBookItenary.isReturnJourney AS IsReturn
		, tblBookItenary.pkId AS ItenaryID
		, (SELECT TOP 1 RescheduleDate 
			FROM tbl_AmendmentRequest 
			WHERE AmendmentRef = @AmendmentRef AND tbl_AmendmentRequest.RiyaPNR = @RiyaPNR
			AND ItenaryId = tblBookItenary.pkId) AS RescheduleDate
		, (SELECT TOP 1 Cabin 
			FROM tbl_AmendmentRequest 
			WHERE AmendmentRef = @AmendmentRef AND tbl_AmendmentRequest.RiyaPNR = @RiyaPNR
			AND ItenaryId = tblBookItenary.pkId) AS RescheduleCabin
		, tblBookItenary.airName AS VendorName
		FROM tblBookItenary
		WHERE tblBookItenary.pkId IN (SELECT ItenaryId FROM #mT)
		ORDER BY pkId
		FOR JSON PATH
		) AS FlightDetails

		, (SELECT frmSector AS FromSector
		, toSector AS ToSector
		, fromAirport AS FromAirport
		, toAirport AS ToAirport
		, depDate AS DepDate
		, arrivalDate AS ArrivalDate
		, riyaPNR AS RiyaPNR
		, TripType AS TripType
		, ((tblBookMaster.TotalFare + ISNULL(#mTSSR.SSRAmount, 0)) * ISNULL(ROE, 1) 
			+ ISNULL(B2BMarkup + #mTB2BMarkup.ParentB2BMarkup,0)) AS TotalFare
		, @CustomerCode AS CustomerCode
		, tblBookMaster.VendorName
		, mobileNo AS ContactNumber
		, emailId AS EmailId
		FROM tblBookMaster
		LEFT OUTER JOIN #mTSSR ON #mTSSR.fkBookMaster = tblBookMaster.pkId
		LEFT OUTER JOIN #mTB2BMarkup ON #mTB2BMarkup.fkBookMaster = tblBookMaster.pkId
		--WHERE orderId = @OrderID
		WHERE tblBookMaster.pkid IN (SELECT BookMasterId FROM #mT)
		ORDER BY isReturnJourney, pkid
		FOR JSON PATH
		) AS FlightSearchDetails

		, (SELECT PaxType,PaxName,
			STUFF((
			SELECT ', ' + innerT.TicketNo
			FROM (
				SELECT paxType AS PaxType,
                (title + '. ' + paxFName + ' ' + paxLName) AS PaxName,
                ticketNum AS TicketNo
		FROM tblPassengerBookDetails
            WHERE pid IN (SELECT PassengerId FROM #mT)
        ) AS innerT
        WHERE innerT.PaxName = outerT.PaxName
          AND innerT.PaxType = outerT.PaxType
          AND innerT.TicketNo IS NOT NULL
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS TicketNumbers
		FROM (SELECT paxType AS PaxType,(title + '. ' + paxFName + ' ' + paxLName) AS PaxName,ticketNum AS TicketNo
		FROM tblPassengerBookDetails
		WHERE pid IN (SELECT PassengerId FROM #mT)) AS outerT
		GROUP BY PaxType, PaxName
		FOR JSON PATH) AS PaxDataDisplay
	FOR JSON PATH

	DROP TABLE #mT, #mTSSR, #mTB2BMarkup
END