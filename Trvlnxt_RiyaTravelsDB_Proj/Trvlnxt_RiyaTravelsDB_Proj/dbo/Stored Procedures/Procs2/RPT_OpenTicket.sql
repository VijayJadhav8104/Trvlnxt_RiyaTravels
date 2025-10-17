CREATE Procedure [dbo].[RPT_OpenTicket]
	@p_dtFromDate Date = null
	, @p_dtToDate Date = null
	, @p_sTASRequestNumber Varchar(100) = ''
	, @p_sEmployeeCode Varchar(25) = ''
	, @p_sRiyaPNR Varchar(10) = ''
	, @p_sAirlinePNR Varchar(10) = ''
	, @p_sCRSPNR Varchar(10) = ''
	, @p_sTicketNo Varchar(100) = ''
	, @p_sFirstName Varchar(100) = ''
	, @p_sLastName Varchar(100) = ''
	, @p_sAirlineInQuery Varchar(MAX) = ''
AS
BEGIN
	SELECT tpb.pid AS pid
			, UPPER(FORMAT(tpb.OpenTicketDate, 'dd-MMM-yyyy HH:mm:ss')) AS [OpenTicket Date Time]
			, atr.TASreqno AS [TAS Request Number]
			, atr.EmpDimession AS [Employee Code]
			, brs.AgencyName AS [Agency Name]
			, brs.Icast [CUST ID]
			, (CASE WHEN tbm.CounterCloseTime = 1 THEN 'Domestic' ELSE  'International' END) AS [Journey Type]
			, tbm.airName AS [Airline Name]
			, arc.type AS [Airline Category]
			, tbm.riyaPNR AS [Riay PNR]
			, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=tbm.pkId)  AS  [Airline PNR]
			, tbm.GDSPNR  AS [CRS PNR]
			, tpb.TicketNumber AS [Ticket No]
			, tbm.TicketingPCC AS PCC
			, tpb.paxType AS [Pax Type]
			, tpb.paxFName AS [First Name]
			, tpb.paxLName AS [Last Name]
			, tbm.frmSector + '-' + tbm.toSector AS Sector
			, tbm.flightNo AS [Flight Number]
			, (CASE WHEN tbm.isReturnJourney = 0 THEN 'OneWay' ELSE 'RoundTrip' END) AS [Trip Type]
			, pm.payment_mode  AS [Payment Mode]
			, tpb.basicFare AS [Basic Fare]
			, tpb.YQ AS YQ
			, tpb.totalTax AS [Tax Amount]
			, tpb.totalFare AS [Total Amount]
			, tpb.CancellationPenalty AS Penalty
			, tpb.CancellationMarkup AS [Markup On BaseFare]
			, tpb.MarkupOnTaxFare AS [Markup On TaxFare]
			, tpb.MarkuponPenalty AS [Markup On Penalty]
			, tbm.Cancelledby AS [Cancelled By]
			, (SELECT TOP 1 farebasis FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster = tbm.pkId) AS [Fare Basis]
			, '1A' AS [Supplier Name]
			, 'Open Ticket' AS [Status]
			, tpb.RemarkCancellation AS [Operation Remark]
			, tpb.RemarkCancellation2 AS [Refund Remark]
	FROM tblPassengerBookDetails tpb WITH(NOLOCK)
	INNER JOIN tblBookMaster tbm  ON tpb.fkBookMaster=tbm.pkId
	INNER JOIN B2BRegistration brs ON tbm.AgentID=brs.FKUserID
	LEFT JOIN  Paymentmaster pm ON tbm.orderId=pm.order_id
	LEFT JOIN mAttrributesDetails atr ON tbm.orderId=atr.OrderID
	LEFT JOIN tblBookItenary tbi ON tbm.pkId=tbi.fkBookMaster
	INNER JOIN AirlineCode_Console arc ON tbm.airCode=arc.AirlineCode
	WHERE tbm.BookingStatus =14 
	AND (@p_sRiyaPNR != '' OR @p_sAirlinePNR != '' OR @p_sCRSPNR != '' OR 
		(((@p_dtFromDate = '') OR (@p_dtFromDate = NULL) OR CONVERT(DATE, @p_dtFromDate) <= CONVERT(DATE, tpb.OpenTicketDate))
		AND ((@p_dtToDate  = '') OR (@p_dtToDate = NULL) OR CONVERT(DATE,@p_dtToDate) >= CONVERT(DATE, tpb.OpenTicketDate))))
	AND ((@p_sTASRequestNumber = '') OR (@p_sTASRequestNumber=atr.TASreqno))
	AND ((@p_sEmployeeCode = '')  OR (@p_sEmployeeCode=atr.EmpDimession))
	AND ((@p_sRiyaPNR = '') OR (@p_sRiyaPNR=tbm.riyaPNR))
	AND ((@p_sCRSPNR = '') OR (@p_sCRSPNR=tbm.GDSPNR))
	AND ((@p_sTicketNo = '') OR (@p_sTicketNo=tpb.TicketNumber))
	AND ((@p_sFirstName = '') OR (@p_sFirstName=tpb.paxFName))
	AND ((@p_sLastName = '') OR (@p_sLastName=tpb.paxLName))
	AND ((@p_sAirlineInQuery = '') OR (tbm.airName in(SELECT Data FROM sample_split(@p_sAirlineInQuery,','))))
	AND ((@p_sAirlinePNR = '') OR (@p_sAirlinePNR=tbi.airlinePNR))
	order by tpb.OpenTicketDate

End




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[RPT_OpenTicket] TO [rt_read]
    AS [dbo];

