-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<JD>
-- Create date: <18.09.2023>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- PrintCopy_GetPassengerDetailForPrintPopUp '9HF6D9', '446692,446690,446691,446693,446694', 'AED', ''
CREATE PROCEDURE [dbo].[PrintCopy_GetPassengerDetailForPrintPopUp]
	@RiyaPNR varchar(20) = null
	, @Pid1 varchar(500) = null 
	, @Currency varchar(8) = null 
	, @SectorID Varchar(20) = null
AS
BEGIN
	DECLARE @NewOrderID varchar(50) = null, @TotalBookMasterCount Int

	SELECT TOP 1 @NewOrderID = orderId
	FROM tblBookMaster WHERE riyaPNR = @RiyaPNR and BookingStatus !=18
	ORDER BY pkId DESC

	SELECT @TotalBookMasterCount = COUNT(pkId)
	FROM tblBookMaster WHERE riyaPNR = @RiyaPNR AND ISNULL(TripType, '') != 'M'

	SELECT TOP 1 
    @Currency = CASE 
                WHEN t.AgentROE <> 1 THEN ISNULL(MC.Value ,'')
                ELSE @Currency 
                END FROM tblBookMaster t
            LEFT JOIN agentLogin al ON CAST(al.UserID AS nvarchar(30)) = CAST(t.AgentID AS nvarchar(30))
            LEFT JOIN mcommon MC WITH(NOLOCK)  ON al.NewCurrency = MC.ID
             WHERE t.riyaPNR = @RiyaPNR;

	--FLIGHT DETAILS
	SELECT DISTINCT t.airName AS AirName
		, t.pkId AS BookItenaryIDP
		, t.isReturnJourney AS IsReturn
		, tb.pkId AS BookingID
		, t.operatingCarrier AS OperatingCarrier
		, t.flightNo AS FlightNo
		, t.airCode AS AirCode
		, (CASE WHEN (tb.BookingSource = 'Manual Ticketing') 
					THEN ISNULL(t.TotalTime, '')
			ELSE ISNULL(t.TotalTimeStopOver, '') END) AS TotalTime
		--, (CASE WHEN (tb.BookingSource = 'Manual Ticketing') 
		--			THEN ISNULL(t.TotalTime, '')
		--	ELSE ISNULL(CONVERT(varchar(5), DATEADD(minute, DATEDIFF(minute, t.deptTime , t.arrivalTime), 0), 114), '') END) AS TotalTime
		, (CAST(DATENAME(WEEKDAY, t.depDate) AS Varchar(3)) + ', ' + convert(Varchar,UPPER(FORMAT(t.depDate, 'dd-MMM-yyyy')))) AS DepartDateDisplay	
		, t.cabin AS Cabin
		, t.farebasis AS FareBasis
		, t.frmSector AS FromSector
		, t.toSector AS ToSector
		, CONVERT(char(5), t.deptTime, 108) AS DepartTime
		, CONVERT(char(5), t.arrivalTime, 108) AS ArrivTime
		, (CAST(DATENAME(WEEKDAY, t.arrivalDate) AS Varchar(3)) + ', ' + convert(Varchar, UPPER(FORMAT(t.arrivalDate, 'dd-MMM-yyyy')))) AS ArrivalDateDisplay
		, ISNULL(t.fromAirport, '') AS FromAirport
		, ISNULL(t.toAirport, '') AS ToAirport
		, ISNULL(t.fromTerminal, '') AS FromTerminal
		, ISNULL(t.toTerminal, '') AS ToTerminal
		, ISNULL(t.depDate, '') AS DepDate
		, ISNULL(t.arrivalDate, '') AS ArrivalDate
		, ISNULL(t.deptTime, '') AS DeptTime
		, ISNULL(t.arrivalTime, '') AS ArrivalTime
		, ISNULL(tb.TripType, '') AS TripType
		, ISNULL('VIA : '+t.Via,'') AS Via
		, @TotalBookMasterCount AS  TotalBookMasterCount
		,tb.journey AS Journey
	FROM tblBookItenary t
	INNER JOIN tblBookMaster tb ON tb.pkId = t.fkBookMaster
	WHERE tb.orderId = @NewOrderID 
	AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)
	ORDER BY DeptTime ASC

	--Passenger all Details(Seat baggege, excess baggege, meals)
	SELECT ROW_NUMBER() OVER (ORDER BY t1.pid ASC) AS SrNo
			, t1.pid AS PassengerBookIDP
			, t2.pkId AS BookingID
			, (t1.paxFName + ' ' +ISNULL(t1.paxLName,'') + ' ') AS FullName
			, CASE 
              WHEN t1.paxType = 'LBR'  OR t1.paxType = 'IIT' THEN 'ADULT'
              ELSE ISNULL(t1.paxType, '')
              END AS PaxType
			, ISNULL(t1.BarCode , '') AS BarCode
			, CASE WHEN t2.BookingStatus = 6 THEN ISNULL(t1.BookingStatus, 1)
                   WHEN t2.BookingStatus = 4 THEN ISNULL(t1.BookingStatus, 1)
                   WHEN t2.BookingStatus = 11 THEN 4
                   ELSE ISNULL(t2.BookingStatus, 0)
                 END AS BookingStatus
			--,ISNULL( (CASE t2.BookingStatus WHEN 4 THEN ISNULL(t1.BookingStatus, 1)
              --          ELSE ISNULL((CASE t2.BookingStatus WHEN 11 THEN 4 ELSE t2.BookingStatus END), 0)END) , 0) AS BookingStatus
			--, (CASE t2.BookingStatus WHEN 11 THEN 4 ELSE t2.BookingStatus END) AS BookingStatus
			, (CASE WHEN CHARINDEX('/',ticketNum) > 0
						THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum) + 1, LEN(ticketNum)), 0, CHARINDEX('/', SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)))) 
					ELSE ticketNum END) AS TicketNumber
			, ISNULL(t1.FrequentFlyNo, '') AS FrequentFlyNo
			, '' AS Seat
			, '' AS Meals
			, ISNULL(t1.baggage, '') AS Baggage
			, '' AS ExcessBaggage			
	FROM tblPassengerBookDetails t1 
	left join tblBookMaster t2 on t2.pkId = t1.fkBookMaster 
	where t2.riyaPNR = @RiyaPNR AND (@SectorID IS NULL OR @SectorID = '' OR t2.pkId = @SectorID)
	AND t1.pid IN(SELECT DATA FROM sample_split(@Pid1,',')) 
	and t2.BookingStatus != 18
	--AND t2.returnFlag = 0 
	ORDER BY pid ASC 

	--SSR Detail
	SELECT SSR.fkPassengerid AS PassengerBookIDF
			, SSR.fkItenary AS BookItenaryIDF
			, (tp.paxFName + ' '  + ISNULL(tp.paxLName,'') + ' ') AS FullName
			, tb.pkId AS BookingID
			, SSR.SSR_Type AS SSRType
			, ISNULL(SSR.SSR_Name, '') AS Seat
			, (CASE WHEN SSR.SSR_Type = 'Meals'
						THEN 'Meals'
					ELSE ''
				END) AS Meals
			--, ISNULL(SSR.SSR_Code, '') AS Meals
			, ISNULL(SSR.SSR_Name, '') AS Baggage
			,(CASE 
                 WHEN ISNULL(SSR.ROE,0) = 0 
                  THEN 
                 CASE WHEN c.CurrencyCode != @Currency
                 THEN CAST(ISNULL(SSR.SSR_Amount, 0) * tb.AgentROE * tb.ROE AS Numeric(18, 2))
                 ELSE CAST(ISNULL(SSR.SSR_Amount, 0) * tb.ROE AS Numeric(18, 2))
                END
              ELSE 
              ISNULL(SSR.SSR_Amount, 0) * SSR.ROE
              END) AS SSR_Amount
			, ISNULL(SSR_Name, '') AS SSRName
			, ISNULL(SSR_Code, '') AS SSRCode
			--, SSR.SSR_Name AS SSRName
			--, SSR.SSR_Code AS SSRCode
			--, (CASE WHEN c.CurrencyCode != @Currency 
			--			THEN CAST(jISNULL(SSR.SSR_Amount, 0) * tb.AgentROE * tb.ROE AS Numeric(18, 2))
			--		ELSE CAST(ISNULL(SSR.SSR_Amount, 0) * tb.ROE AS Numeric(18, 2))
			--	END) AS SSR_Amount
	FROM tblSSRDetails AS SSR
	INNER JOIN tblBookMaster AS tb ON SSR.fkBookMaster = tb.pkId
	INNER JOIN mCountryCurrency c ON c.CountryCode= tb.Country
	INNER JOIN tblPassengerBookDetails as tp on tp.pid = ssr.fkPassengerid
	WHERE tb.riyaPNR = @RiyaPNR AND SSR.SSR_Status =1 and tb.BookingStatus != 18

	--Payment Detail
	declare @BasicB2BMARKUP decimal(18,2)=0
	declare @TaxB2BMARKUP decimal(18,2)=0
	if exists(select top 1 pkId from tblBookMaster where riyaPNR=@RiyaPNR and B2bFareType=1)
	begin
	set @BasicB2BMARKUP=(select top 1 tp.B2BMarkup from tblPassengerBookDetails tp inner join tblBookMaster tbm on tp.fkBookMaster=tbm.pkId where riyaPNR=@RiyaPNR and tbm.BookingStatus != 18)
	END
	ELSE if exists(select top 1 pkId from tblBookMaster where riyaPNR=@RiyaPNR and (B2bFareType=2 or B2bFareType=3))
	begin
	set @TaxB2BMARKUP=(select top 1 tp.B2BMarkup from tblPassengerBookDetails tp inner join tblBookMaster tbm on tp.fkBookMaster=tbm.pkId where riyaPNR=@RiyaPNR and tbm.BookingStatus != 18)
	END

	--select tp.pid AS PassengerID
	--		, (CASE WHEN c.CurrencyCode != @Currency 
	--					THEN SUM(CAST((tP.basicFare * tb.AgentROE * tb.ROE) AS Numeric(10,2)) + @BasicB2BMARKUP + ISNULL(tp.Markup,0))
	--				ELSE SUM(CAST((tp.basicFare * tb.ROE+ ISNULL(tp.Markup,0)) AS Numeric(10,2)) + @BasicB2BMARKUP)
	--			END) AS BasicFare
	--		, (CASE WHEN c.CurrencyCode != @Currency
	--					THEN SUM(CAST((tp.totalTax * tb.AgentROE * tb.ROE) 
	--									+ (@TaxB2BMARKUP 
	--									+ ISNULL(tp.HupAmount,0)
	--									+ ISNULL(tp.BFC, 0)) * tb.AgentROE AS Numeric(10,2)))
	--					ELSE SUM(CAST(tp.totalTax * tb.ROE 
	--									+ (@TaxB2BMARKUP 
	--									+ ISNULL(tp.HupAmount,0)
	--									+ ISNULL(tp.BFC,0)) AS Numeric(10,2))) END) AS TotalTax
	--		, (CASE WHEN c.CurrencyCode != @Currency
	--					THEN SUM(CAST((tp.totalFare) * tb.AgentROE * tb.ROE AS Numeric(10,2))) 
	--							+ ISNULL(tp.MCOAmount, 0)
	--							+ ISNULL(tp.Markup, 0)
	--							+ ISNULL(tp.BFC, 0)
	--							+ ISNULL(tp.B2BMarkup, 0)
	--							+ ISNULL(tp.HupAmount, 0)
	--							+ ISNULL(tp.ServiceFee, 0)
	--							+ ISNULL(tp.GST, 0)
	--							--- (SUM(ISNULL(tp.IATACommission, 0)) + SUM(ISNULL(tp.PLBCommission, 0)) + SUM(ISNULL(tp.DropnetCommission, 0)))
	--					ELSE SUM(CAST((tp.totalFare) * tb.ROE AS Numeric(10,2)))
	--							+ ISNULL(tp.MCOAmount, 0)
	--							+ ISNULL(tp.Markup, 0)
	--							+ ISNULL(tp.BFC, 0)
	--							+ ISNULL(tp.B2BMarkup, 0)
	--							+ ISNULL(tp.HupAmount, 0)
	--							+ ISNULL(tp.ServiceFee, 0)
	--							+ ISNULL(tp.GST, 0)
	--					--- (SUM(ISNULL(tp.IATACommission, 0)) + SUM(ISNULL(tp.PLBCommission, 0)) + SUM(ISNULL(tp.DropnetCommission, 0)))
	--			END) AS TotalFare
	--			, (CASE WHEN c.CurrencyCode != @Currency
	--					THEN SUM(CAST((tp.totalFare) * tb.AgentROE * tb.ROE AS Numeric(10,2))) 
	--							+ ISNULL(tp.MCOAmount, 0)
	--							+ ISNULL(tp.Markup, 0)
	--							+ ISNULL(tp.BFC, 0)
	--							+ ISNULL(tp.B2BMarkup, 0)
	--							+ ISNULL(tp.HupAmount, 0)
	--							+ ISNULL(tp.ServiceFee, 0)
	--							+ ISNULL(tp.GST, 0)
	--							- (SUM(ISNULL(tp.IATACommission, 0)) + SUM(ISNULL(tp.PLBCommission, 0)) + SUM(ISNULL(tp.DropnetCommission, 0)))
	--					ELSE SUM(CAST((tp.totalFare) * tb.ROE AS Numeric(10,2)))
	--							+ ISNULL(tp.MCOAmount, 0)
	--							+ ISNULL(tp.Markup, 0)
	--							+ ISNULL(tp.BFC, 0)
	--							+ ISNULL(tp.B2BMarkup, 0)
	--							+ ISNULL(tp.HupAmount, 0)
	--							+ ISNULL(tp.ServiceFee, 0)
	--							+ ISNULL(tp.GST, 0)
	--					- (SUM(ISNULL(tp.IATACommission, 0)) + SUM(ISNULL(tp.PLBCommission, 0)) + SUM(ISNULL(tp.DropnetCommission, 0)))
	--			END) AS NetAmount
	--		 , (CASE WHEN c.CurrencyCode != @currency
	--					THEN SUM(CAST((tp.YQ * tb.AgentROE * tb.ROE) AS Numeric(10,2)))
	--				ELSE SUM(CAST((tp.YQ * tb.ROE) AS Numeric(10,2))) END) AS YQTax
	--		, (CASE WHEN c.CurrencyCode != @currency
	--					THEN ISNULL(SUM(CAST((tp.ServiceCharge * tb.AgentROE * tb.ROE) AS Numeric(10,2))), 0)
	--				ELSE ISNULL(SUM(CAST((tp.ServiceCharge * tb.ROE) AS Numeric(10,2))), 0) END) ServiceCharge
	--		, (CASE WHEN c.CurrencyCode != @currency
	--					THEN SUM(CAST((tp.YRTax * tb.AgentROE * tb.ROE) AS Numeric(10,2)))
	--				ELSE SUM(CAST((tp.YRTax * tb.ROE) AS Numeric(10,2))) END) AS YRTax
	--		, (CASE WHEN c.CurrencyCode != @Currency
	--					THEN SUM(CAST(((ISNULL(tp.ExtraTax ,0)
	--								+ ISNULL(tp.INTax, 0)
	--								+ ISNULL(tp.JNTax, 0)
	--								+ ISNULL(tp.OCTax, 0)
	--								+ ISNULL(tp.WOTax, 0)) * tb.AgentROE * tb.ROE) AS Numeric(10,2)))
	--				ELSE SUM(CAST(((ISNULL(tp.ExtraTax ,0)
	--								+ ISNULL(tp.INTax, 0)
	--								+ ISNULL(tp.JNTax, 0)
	--								+ ISNULL(tp.OCTax, 0)
	--								+ ISNULL(tp.WOTax, 0)) * tb.ROE ) AS Numeric(10,2))) END) AS ExtraTax
	--		,(CASE WHEN c.CurrencyCode != @currency
	--					THEN SUM(CAST((ISNULL(tp.B2BMarkup, 0) * tb.AgentROE) AS Numeric(10,2)))
	--				ELSE SUM(CAST((ISNULL(tp.B2BMarkup, 0)) AS Numeric(10,2))) END) AS SC
	--		, ISNULL(tp.RFTax, 0) AS RFTax
	--		, ISNULL(TP.ServiceFee, 0) AS ServiceFee
	--		, ISNULL(TP.GST, 0) AS GST
	--FROM tblPassengerBookDetails AS TP
	--inner join tblBookMaster AS TB on TP.fkBookMaster = TB.pkId
	--INNER JOIN mCountryCurrency c ON c.CountryCode= tb.Country
	--where tb.riyaPNR = @RiyaPNR
	--GROUP BY TP.paxFName,TP.paxLName,TP.paxType
	--,C.CurrencyCode,TP.MCOAmount,TP.Markup
	--,TB.BFC,TP.B2BMarkup,tp.IATACommission
	--,tp.PLBCommission,tp.DropnetCommission
	--,tP.ServiceFee,TP.GST, tp.BFC,HupAmount
	--,tp.TCSTaxAmount, pid, tp.RFTax
	DECLARE @ServiceFeeMap DECIMAL(18, 2)= 0, @ServiceFeeAdditional DECIMAL(18, 2)= 0

	IF EXISTS(SELECT TOP 1 pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)
	BEGIN
		SET @ServiceFeeMap = (SELECT TOP 1 ServiceFeeMap FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)
	END
	IF EXISTS(SELECT TOP 1 pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)
	BEGIN
		SET @ServiceFeeAdditional = (SELECT TOP 1 ServiceFeeAdditional FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)
	END
	select tp.pid AS PassengerID
			, (CASE WHEN c.CurrencyCode != @Currency 
						THEN CAST((SUM(tp.basicFare) * tb.AgentROE * tb.ROE) AS Numeric(10,2)) + (CASE WHEN tp.B2BMarkup > 0 THEN @BasicB2BMARKUP ELSE 0 END) +( ISNULL(tp.LonServiceFee,0)* tb.ROE)
					ELSE CAST((SUM(tp.basicFare) * tb.ROE) AS Numeric(10,2)) + (CASE WHEN tp.B2BMarkup > 0 THEN @BasicB2BMARKUP ELSE 0 END) + (ISNULL(tp.LonServiceFee,0)* tb.ROE)
				END) AS BasicFare
			, (CASE WHEN c.CurrencyCode != @Currency
						THEN CAST((SUM(tp.totalTax) * tb.AgentROE * tb.ROE) 
										+ (CASE WHEN tp.B2BMarkup > 0 THEN @TaxB2BMARKUP ELSE 0 END) 
										+ ISNULL(tp.HupAmount,0)
										+ ISNULL(tp.BFC, 0)
										+ ISNULL(tp.ServiceFee, 0) 
										+ ISNULL(tp.GST, 0) AS Numeric(10,2))
										+((ISNULL(tp.VendorServiceFee, 0)+ISNULL(tp.AirlineFee,0)) * tb.ROE)
						ELSE CAST(SUM(tp.totalTax) * tb.ROE 
										+ (CASE WHEN tp.B2BMarkup > 0 THEN @TaxB2BMARKUP ELSE 0 END) 
										+ ISNULL(tp.HupAmount,0)
										+ ISNULL(tp.BFC,0)
										+ ISNULL(tp.ServiceFee, 0) 
										+ ISNULL(tp.GST, 0) AS Numeric(10,2))
										+((ISNULL(tp.VendorServiceFee, 0)+ISNULL(tp.AirlineFee,0)) * tb.ROE)
				END) AS TotalTax
			, (CASE WHEN c.CurrencyCode != @Currency
						THEN SUM(CAST((tp.totalFare) * tb.AgentROE * tb.ROE AS Numeric(10,2))) 
								+ ISNULL(tp.MCOAmount, 0)
								+ ISNULL(tp.BFC, 0)
								+ ISNULL(tp.B2BMarkup, 0)
								+ ISNULL(tp.HupAmount, 0)
								+ ISNULL(tp.ServiceFee, 0)
								+ ISNULL(tp.GST, 0)
								+ (ISNULL(tp.LonServiceFee, 0)* tb.ROE)
								+((ISNULL(tp.VendorServiceFee, 0)+ISNULL(tp.AirlineFee,0)) * tb.ROE)

						ELSE SUM(CAST((tp.totalFare) * tb.ROE AS Numeric(10,2)))
								+ ISNULL(tp.MCOAmount, 0)
								+ ISNULL(tp.BFC, 0)
								+ ISNULL(tp.B2BMarkup, 0)
								+ ISNULL(tp.HupAmount, 0)
								+ ISNULL(tp.ServiceFee, 0)
								+ ISNULL(tp.GST, 0)
								+( ISNULL(tp.LonServiceFee, 0)* tb.ROE)
								+((ISNULL(tp.VendorServiceFee, 0)+ISNULL(tp.AirlineFee,0)) * tb.ROE)

				END) AS TotalFare
				, (CASE WHEN c.CurrencyCode != @Currency
						THEN SUM(CAST((tp.totalFare ) * tb.AgentROE * tb.ROE AS Numeric(10,2))) 
								+ ISNULL(tp.MCOAmount, 0)
								+ ISNULL(tp.BFC, 0)
								+ ISNULL(tp.B2BMarkup, 0)
								+ ISNULL(tp.HupAmount, 0)
								+ ISNULL(tp.ServiceFee, 0)
								+ ISNULL(tp.GST, 0)
								+ (ISNULL(tp.LonServiceFee, 0)* tb.ROE)
							   +((ISNULL(tp.VendorServiceFee, 0)+ISNULL(tp.AirlineFee,0)) * tb.ROE)
								- (SUM(ISNULL(tp.IATACommission, 0)) + SUM(ISNULL(tp.PLBCommission, 0)) + SUM(ISNULL(tp.DropnetCommission, 0)))
						ELSE SUM(CAST((tp.totalFare) * tb.ROE AS Numeric(10,2)))
								+ ISNULL(tp.MCOAmount, 0)
								+ ISNULL(tp.BFC, 0)
								+ ISNULL(tp.B2BMarkup, 0)
								+ ISNULL(tp.HupAmount, 0)
								+ ISNULL(tp.ServiceFee, 0)
								+ ISNULL(tp.GST, 0)
								+ (ISNULL(tp.LonServiceFee, 0)* tb.ROE)
		                       +((ISNULL(tp.VendorServiceFee, 0)+ISNULL(tp.AirlineFee,0)) * tb.ROE)
						- (SUM(ISNULL(tp.IATACommission, 0)) + SUM(ISNULL(tp.PLBCommission, 0)) + SUM(ISNULL(tp.DropnetCommission, 0)))
				END) AS NetAmount
			 , (CASE WHEN c.CurrencyCode != @currency
						THEN SUM(CAST((tp.YQ * tb.AgentROE * tb.ROE) AS Numeric(10,2)))
					ELSE SUM(CAST((tp.YQ * tb.ROE) AS Numeric(10,2))) END) AS YQTax
			, (CASE WHEN c.CurrencyCode != @currency
						THEN SUM(CAST((ISNULL(tp.K7Tax ,0) * tb.AgentROE * tb.ROE) AS Numeric(10,2)))
					ELSE SUM(CAST((ISNULL(tp.K7Tax ,0) * tb.ROE) AS Numeric(10,2))) END) AS K7Tax
			, (CASE WHEN c.CurrencyCode != @currency
						THEN ISNULL(SUM(CAST((tp.ServiceCharge * tb.AgentROE * tb.ROE) AS Numeric(10,2))), 0)
					ELSE ISNULL(SUM(CAST((tp.ServiceCharge * tb.ROE) AS Numeric(10,2))), 0) END) ServiceCharge
			, (CASE WHEN c.CurrencyCode != @currency
						THEN SUM(CAST((tp.YRTax * tb.AgentROE * tb.ROE) AS Numeric(10,2)))
					ELSE SUM(CAST((tp.YRTax * tb.ROE) AS Numeric(10,2))) END) AS YRTax
			, (CASE WHEN c.CurrencyCode != @Currency
						THEN SUM(CAST(((ISNULL(tp.ExtraTax ,0)
									+ ISNULL(tp.INTax, 0)
									+ ISNULL(tp.JNTax, 0)
									+ ISNULL(tp.OCTax, 0)
									+ ISNULL(tp.WOTax, 0)
										+ ISNULL(tb.ServiceFeeMap, 0)
									+ ISNULL(tb.ServiceFeeAdditional, 0)
									+ ISNULL(tp.YMTax, 0)+ISNULL(tp.AirlineFee,0)) * tb.AgentROE * tb.ROE) AS Numeric(10,2)))
					ELSE SUM(CAST(((ISNULL(tp.ExtraTax ,0)
									+ ISNULL(tp.INTax, 0)
									+ ISNULL(tp.JNTax, 0)
									+ ISNULL(tp.OCTax, 0)
									+ ISNULL(tp.WOTax, 0)
										+ ISNULL(tb.ServiceFeeMap, 0)
									+ ISNULL(tb.ServiceFeeAdditional, 0)
									+ ISNULL(tp.YMTax, 0)+ISNULL(tp.AirlineFee,0)) * tb.ROE ) AS Numeric(10,2))) END) AS ExtraTax
			,(CASE WHEN c.CurrencyCode != @currency
						THEN SUM(CAST((ISNULL(tp.B2BMarkup, 0) * tb.AgentROE) AS Numeric(10,2)))
					ELSE SUM(CAST((ISNULL(tp.B2BMarkup, 0)) AS Numeric(10,2))) END) AS SC
			, ISNULL(tp.RFTax, 0) AS RFTax
			, ISNULL(tp.ServiceFee, 0) AS ServiceFee
			, ISNULL(tp.GST, 0) AS GST
			, ISNULL(tp.BFC, 0) AS BFC
			, ISNULL(bm.TotalCommission, 0) AS TotalCommission
			, (CAST(ISNULL(tb.ROE, 0)AS DECIMAL(10,2)) )AS ROE
			, ISNULL(tp.VendorServiceFee, 0) AS VendorServiceFee
			,ISNULL(@ServiceFeeMap, 0) AS ServiceFeeMap
			,ISNULL(@ServiceFeeAdditional, 0) AS ServiceFeeAdditional
			,ISNULL(TP.MarkOn,'') AS MarkOn
	FROM tblPassengerBookDetails AS TP
	inner join tblBookMaster AS TB on TP.fkBookMaster = TB.pkId
	INNER JOIN mCountryCurrency c ON c.CountryCode= tb.Country
	LEFT JOIN B2BMakepaymentCommission bm ON bm.OrderId= tb.orderId 
	where tb.riyaPNR = @RiyaPNR and tb.BookingStatus != 18
	GROUP BY tp.pid, tb.AgentROE, tb.ROE, c.CurrencyCode
	, tp.MCOAmount, tp.BFC, tp.B2BMarkup, tp.HupAmount, tp.ServiceFee, TP.GST, tp.RFTax,tp.VendorServiceFee,TP.MarkOn,TP.LonServiceFee,bm.TotalCommission,tp.AirlineFee

	--Cancellation ticket Detail
	SELECT DISTINCT ISNULL(t1.paxFName + ' ' + ISNULL(t1.paxLName,''), '') AS FullName
	   , CASE 
              WHEN t1.paxType = 'LBR'  OR t1.paxType = 'IIT' THEN 'ADULT'
              ELSE ISNULL(t1.paxType, '')
              END AS PassengerType
			
		, t2.frmSector AS FromSector
		, t2.toSector AS ToSector
		, ISNULL(t1.CancellationPenalty,0.0) AS CancellationPenalty
		, (ISNULL(t1.CancellationMarkup, 0) + ISNULL(t1.MarkupOnTaxFare, 0) + ISNULL(t1.MarkuponPenalty, 0)) AS CancellationMarkup
		, t1.RemarkCancellation2 AS CancellationRemark
		, UPPER(FORMAT(CAST(t1.CancelledDate AS DateTime),'dd/MMM/yyyy HH:mm:ss tt','en-us')) AS CancellationDate
		, ISNULL(u.UserName, br.AgencyName) AS UserName
		, t1.pid AS PassengerBookDetailIDP
	FROM tblPassengerBookDetails t1
	LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
	LEFT JOIN [mUser] u ON u.id=t1.CancelByBackendUser1
	LEFT JOIN B2BRegistration br ON br.FKUserID=t1.CancelByAgency1
	WHERE t2.riyaPNR = @RiyaPNR and t2.BookingStatus != 18
	AND t1.pid IN(SELECT DATA FROM sample_split(@Pid1,','))
	AND t1.RemarkCancellation2 IS NOT NULL 
	ORDER BY pid ASC
END
