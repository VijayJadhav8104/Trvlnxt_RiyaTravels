CREATE procedure [dbo].[sp_GetRescheduleReportData] 
	@FromDate Datetime
	, @Todate Datetime
	, @AgentID varchar(50)
	, @RiyaPNR varchar(50) = ''
AS
BEGIN
	 SELECT 
		(SELECT TOP 1 FORMAT(AmendmentRequest.inserteddate, 'dd-MMM-yyyy HH:mm:ss') FROM tbl_AmendmentRequest  AmendmentRequest WITH(NOLOCK) WHERE  AmendmentRequest.RiyaPNR=tblBookMaster.riyapnr AND AmendmentRequest.IsBooked = 1) AS RequestDateTime
		,FORMAT(tblBookMaster.inserteddate_old, 'dd-MMM-yyyy HH:mm:ss') AS ReissueDateTime
		,agentLogin.BookingCountry AS Country
		,mCommon.Value AS UserType 
        , ISNULL(B2BRegistration.AgencyName,B2BRegistration1.AgencyName) AS AgencyName 
		, ISNULL(B2BRegistration.Icast,B2BRegistration1.Icast) AS CustID 
		,tblBookMaster.riyaPNR AS TrvlnxtPNR 
	    ,(SELECT TOP 1 airlinePNR FROM tblBookItenary tblBookItenary WITH(NOLOCK) WHERE tblBookItenary.fkBookMaster=tblBookMaster.pkId) AS AirlinePNR  
		,tblBookMaster.GDSPNR AS CRSPNR
		,tblPassengerBookDetails.ticketNum AS TicketNo
		--,(SELECT  ticketNum FROM tblPassengerBookDetails tp WITH(NOLOCK) WHERE tp.pid=tblPassengerBookDetails.OPID) AS OldTicketNo 
		,(SELECT 
				CASE 
					WHEN CHARINDEX('/', tp.ticketNum) > 0 
						 AND PATINDEX('%[0-9][0-9][0-9]-%', tp.ticketNum) > 0
						THEN SUBSTRING(
							tp.ticketNum,
							PATINDEX('%[0-9][0-9][0-9]-%', tp.ticketNum),
							CHARINDEX('/', tp.ticketNum) - PATINDEX('%[0-9][0-9][0-9]-%', tp.ticketNum)
						)
					ELSE tp.ticketNum
				END
			FROM tblPassengerBookDetails tp WITH(NOLOCK)
			WHERE tp.pid = tblPassengerBookDetails.OPID) AS OldTicketNo
	    ,(SELECT TOP 1 FlightType FROM tbl_FlightTypeFilter FlightTypeFilter WITH(NOLOCK) WHERE FlightTypeFilter.VendorName=tblBookMaster.VendorName) AS AirlineCategory
		,ISNULL(tblBookMaster.airname,'') AS AirlienName
		,ISNULL(tblBookMaster.BookingFrom +' Reissue','') AS ReissueType
		,ISNULL(tblPassengerBookDetails.paxType,'') AS PaxType
		,ISNULL(tblPassengerBookDetails.paxFName,'') AS FirstName
		,ISNULL(tblPassengerBookDetails.paxLName,'') AS LastName
		,STUFF((SELECT '/' + tb.frmSector + '-' + tb.toSector   
														FROM tblBookMaster tb WITH(NOLOCK)
														WHERE tb.orderId = tblBookMaster.orderId 
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS Sector
		,(SELECT STUFF((SELECT '/' + FORMAT(tb1.deptTime, 'dd-MMM-yyyy') 
												FROM tblBookMaster tb1 WITH(NOLOCK)
												WHERE tb1.riyaPNR = tblBookMaster.riyaPNR and tb1.orderId = tblBookMaster.orderId
												FOR XML PATH ('')) , 1, 1, '')) AS deptdate
		,(SELECT STUFF((SELECT '/' + FORMAT(tb2.arrivalTime, 'dd-MMM-yyyy') 
												FROM tblBookMaster tb2 WITH(NOLOCK)
												WHERE tb2.riyaPNR = tblBookMaster.riyaPNR and tb2.orderId = tblBookMaster.orderId
												FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
		,STUFF((SELECT '/' + tb3.flightNo FROM tblBookMaster tb3 WITH(NOLOCK)
										WHERE tb3.orderId = tblBookMaster.orderId 
										ORDER BY tb3.pkId ASC
										FOR XML PATH('')), 1, 1, '') AS FlightNo
		,CASE 
            WHEN tblBookMaster.journey = 'O' THEN 'Oneway'
            WHEN tblBookMaster.journey = 'R' THEN 'RoundTrip'
            WHEN tblBookMaster.journey = 'M' THEN 'MultiCity'
        END AS JourneyType
		,(SELECT Paymentmaster.payment_mode FROM Paymentmaster Paymentmaster WITH(NOLOCK) WHERE Paymentmaster.order_id=tblBookMaster.orderId) AS PaymentMode 
		,ISNULL(tblPassengerBookDetails.basicfare,0) AS BasicFare
		,ISNULL(tblPassengerBookDetails.YQ,0) AS TaxYQ
		,CAST(
			ISNULL(tblPassengerBookDetails.YRTax, 0) +
			ISNULL(tblPassengerBookDetails.INTax, 0) +
			ISNULL(tblPassengerBookDetails.JNTax, 0) +
			ISNULL(tblPassengerBookDetails.OCTax, 0) +
			ISNULL(tblPassengerBookDetails.ExtraTax, 0) +
			ISNULL(tblPassengerBookDetails.YMTax, 0) +
			ISNULL(tblPassengerBookDetails.WOTax, 0) +
			ISNULL(tblPassengerBookDetails.OBTax, 0) +
			ISNULL(tblPassengerBookDetails.RFTax, 0) +
			ISNULL(tblPassengerBookDetails.K7Tax, 0)
		 AS DECIMAL(18, 2)) AS ExtraTax
		,ISNULL(tblPassengerBookDetails.totaltax,0) AS TotalTax
		,ISNULL(tblPassengerBookDetails.PLBCommission, 0)+ISNULL(tblPassengerBookDetails.IATACommission, 0)+ISNULL(tblPassengerBookDetails.DropnetCommission, 0) AS Commission
		,CAST(ISNULL(tblPassengerBookDetails.AirlineFee, 0) AS DECIMAL(18,2)) AS Penalty
		,ISNULL(tblPassengerBookDetails.totalfare,0) +CAST(ISNULL(tblPassengerBookDetails.AirlineFee, 0) AS DECIMAL(18,2))
		  +ISNULL(tblPassengerBookDetails.PLBCommission, 0)+ISNULL(tblPassengerBookDetails.IATACommission, 0)+ISNULL(tblPassengerBookDetails.DropnetCommission, 0)
		  +ISNULL(tblPassengerBookDetails.servicefee,0) + ISNULL(tblBookMaster.GST,0)+ISNULL(tblPassengerBookDetails.Markup,0) AS TotalFare
		,ISNULL(tblPassengerBookDetails.servicefee,0) AS ServiceFee
		,ISNULL(tblBookMaster.GST,0) AS GSTAmount
		,0 AS Incentive
		,ISNULL(tblPassengerBookDetails.Markup,0) AS ReissueMarkup
		,ISNULL(tblBookMaster.Remark,'')  AS Remarks
		,CASE 
			 WHEN ISNULL(tblBookMaster.counterclosetime, '') = '' THEN ''
			 WHEN tblBookMaster.counterclosetime = 1 THEN 'Domestic'
			 WHEN tblBookMaster.counterclosetime = 2 THEN 'International'
			 ELSE ''
		 END AS AirportType
		,dbo.GetUserNameID_Amendment(
        CASE 
			 WHEN tblBookMaster.MainAgentID IS NULL OR tblBookMaster.MainAgentID = 0 
             THEN tblBookMaster.AgentID 
             ELSE tblBookMaster.MainAgentID 
             END
          ) AS ActionedBy
		,tblBookMaster.VendorName AS SupplierName
		,CASE 
            WHEN tblBookMaster.BookingStatus = '1' OR tblBookMaster.BookingStatus = '18'  THEN 'Reissued Succesful'
			ELSE 'Reissued Failed' END AS Status
	 FROM tblBookMaster tblBookMaster WITH(NOLOCK)
	--	LEFT JOIN tbl_AmendmentRequest AmendmentRequest WITH(NOLOCK) ON AmendmentRequest.RiyaPNR=tblBookMaster.riyapnr	
		LEFT JOIN agentLogin agentLogin WITH(NOLOCK) ON CAST(agentLogin.UserID AS VARCHAR(50))=tblBookMaster.AgentID 
		LEFT JOIN mCommon mCommon WITH(NOLOCK) ON mCommon.ID=agentLogin.UserTypeID
		LEFT JOIN B2BRegistration B2BRegistration WITH(NOLOCK) ON CAST(B2BRegistration.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID from agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= tblBookMaster.AgentID)  
		LEFT JOIN B2BRegistration B2BRegistration1 WITH(NOLOCK) ON CAST(B2BRegistration1.FKUserID AS VARCHAR(50))=tblBookMaster.AgentID 
		LEFT JOIN tblPassengerBookDetails tblPassengerBookDetails WITH(NOLOCK) ON tblPassengerBookDetails.fkBookMaster=tblBookMaster.pkId  
  	 WHERE
		(@RiyaPNR <> ''
			AND tblBookMaster.riyapnr = @RiyaPNR
			AND tblBookMaster.ParentOrderId IS NOT NULL
		AND tblBookMaster.returnflag = 0)
		OR
		(@RiyaPNR = ''
			AND CONVERT(DATE, tblBookMaster.[inserteddate_old]) BETWEEN @FromDate AND @ToDate
			AND (@AgentID = '' OR tblBookMaster.AgentID = CAST(@AgentID AS VARCHAR(50)))
			AND tblBookMaster.ParentOrderId IS NOT NULL
		   AND tblBookMaster.returnflag = 0)
		
	-- WHERE CONVERT(DATE,tblBookMaster.[inserteddate_old]) BETWEEN @FromDate AND @Todate                                            
		--AND ((@AgentId = '') OR (tblBookMaster.AgentID = CAST(@AgentId AS VARCHAR(50))))  
		--AND tblBookMaster.ParentOrderId IS NOT NULL
		--AND tblBookMaster.returnflag=0
	ORDER BY 
		tblBookMaster.inserteddate_old DESC                                   
end 