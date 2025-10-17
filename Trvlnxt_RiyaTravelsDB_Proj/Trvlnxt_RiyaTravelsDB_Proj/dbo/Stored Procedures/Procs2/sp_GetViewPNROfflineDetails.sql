-- =============================================
-- Author:		Bansi
-- Create date: <14.05.2025>
-- Description:	For View PNR
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetViewPNROfflineDetails]
	 @AmendmentRef Varchar(20) = NULL
	, @RiyaPNR Varchar(10)
	, @Currency Varchar(10)
AS
BEGIN
   SET NOCOUNT ON;

	DECLARE @OrderID Varchar(50), @PaymentMode Varchar(50), @BookingStatus Int

	SELECT BookMasterId, ItenaryId, PassengerId 
	INTO #mT1 
	FROM tbl_AmendmentRequest WHERE AmendmentRef = @AmendmentRef AND RiyaPNR = @RiyaPNR

	SELECT TOP 1 @OrderID = orderId, @BookingStatus = BookingStatus FROM tblBookMaster WHERE RiyaPNR = @RiyaPNR

	SELECT TOP 1 @PaymentMode = payment_mode FROM Paymentmaster WHERE order_id = @OrderID
	DECLARE @BasicB2BMARKUP DECIMAL(18, 2)= 0, @TaxB2BMARKUP DECIMAL(18, 2)= 0

	IF EXISTS(SELECT TOP 1 pkId FROM tblBookMaster WHERE (orderId= @OrderID or ParentOrderId =@OrderID) AND B2bFareType= 1)
	BEGIN
		SET @BasicB2BMARKUP = (SELECT TOP 1 B2BMarkup FROM tblBookMaster WHERE orderId= @orderId or ParentOrderId =@OrderID)
	END
	ELSE IF EXISTS(SELECT TOP 1 pkId FROM tblBookMaster WHERE (orderId= @OrderID or ParentOrderId =@OrderID) AND (B2bFareType= 2 or B2bFareType= 3))
	BEGIN
		SET @TaxB2BMARKUP = (SELECT TOP 1 B2BMarkup FROM tblBookMaster WHERE orderId= @orderId or ParentOrderId =@OrderID)
	END

	DECLARE @BasicFaremarkup DECIMAL(18, 2)= 0, @TotalTaxmarkup DECIMAL(18, 2)= 0

	IF EXISTS(SELECT TOP 1 pkId FROM tblPassengerBookDetails 
	INNER JOIN tblBookMaster ON tblBookMaster.pkId=tblPassengerBookDetails.fkBookMaster WHERE (tblBookMaster.orderId= @OrderID or ParentOrderId =@OrderID) AND (tblPassengerBookDetails.MarkOn= 'Markup on Base' or tblPassengerBookDetails.MarkOn = '' ))
	BEGIN
		SET @BasicFaremarkup = (SELECT TOP 1 BFC FROM tblBookMaster WHERE orderId= @orderId or ParentOrderId =@OrderID)
	END
	ELSE IF EXISTS(SELECT TOP 1 pkId FROM tblPassengerBookDetails INNER JOIN tblBookMaster ON tblBookMaster.pkId=tblPassengerBookDetails.fkBookMaster WHERE (tblBookMaster.orderId= @OrderID or ParentOrderId =@OrderID) AND (tblPassengerBookDetails.MarkOn = 'Markup on Tax'))
	BEGIN
		SET @TotalTaxmarkup = (SELECT TOP 1 BFC FROM tblBookMaster WHERE orderId= @orderId or ParentOrderId =@OrderID)
	END


    SELECT  (BookMasterItenary.airName + '-' + BookMasterItenary.aircode) AS VendorName
	        ,BookMasterItenary.aircode AS Aircode
			,tblBookItenary.flightNo AS FlightNo
			,tblBookItenary.frmSector AS FromSector
			,tblBookItenary.toSector AS ToSector
		    ,tblBookItenary.fromAirport AS FromAirport
		    ,tblBookItenary.toAirport AS ToAirport
		    ,tblBookItenary.fromTerminal AS FromTerminal
			,tblBookItenary.toTerminal AS ToTerminal
			,BookMasterItenary.journey AS Journey
			,tblBookItenary.pkid AS ItenaryID	
			,BookMasterItenary.pkid AS BookMasterID
			,BookMasterItenary.returnFlag AS ReturnFlag		
			  ,ISNULL(BookMasterItenary.ParentOrderId, BookMasterItenary.orderid) AS OrderId
	         ,ISNULL(tblBookItenary.cabin, '') AS CabinClass
             ,ISNULL(tblBookItenary.farebasis, '') AS FareBasis	
			
			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(BookMasterItenary.basicFare,0) * BookMasterItenary.AgentROE * BookMasterItenary.ROE) + CASE WHEN ISNULL(BookMasterItenary.basicFare, 0) != 0 THEN @BasicB2BMARKUP + @BasicFaremarkup ELSE 0 END AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(BookMasterItenary.basicFare,0) * BookMasterItenary.ROE) + CASE WHEN ISNULL(BookMasterItenary.basicFare, 0) != 0 THEN @BasicB2BMARKUP + @BasicFaremarkup ELSE 0 END AS DECIMAL(10, 2))
				END) AS BasicFare

			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(BookMasterItenary.TotalTax,0) * BookMasterItenary.AgentROE * BookMasterItenary.ROE) +@TaxB2BMARKUP 
					+CASE WHEN ISNULL(BookMasterItenary.TotalTax, 0) != 0 THEN @TotalTaxmarkup +ISNULL(BookMasterItenary.TotalVendorServiceFee, 0) + ISNULL(B2BMakepaymentCommissionI.TotalCommission,0) ELSE 0 END  AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(BookMasterItenary.TotalTax,0) * BookMasterItenary.ROE)
					+ CASE WHEN ISNULL(BookMasterItenary.TotalTax, 0) != 0 THEN @TaxB2BMARKUP + @TotalTaxmarkup +ISNULL(BookMasterItenary.TotalVendorServiceFee, 0) + ISNULL(B2BMakepaymentCommissionI.TotalCommission,0) ELSE 0 END AS DECIMAL(10, 2))
				END) AS TotalTax

			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((((ISNULL(BookMasterItenary.totalFare,0) * BookMasterItenary.AgentROE * BookMasterItenary.ROE)  
					+ CASE WHEN ISNULL(BookMasterItenary.totalFare, 0) != 0 THEN 0 END)) AS DECIMAL(10, 2))
					ELSE CAST((((ISNULL(BookMasterItenary.totalFare,0) * BookMasterItenary.ROE) 
					+ CASE WHEN ISNULL(BookMasterItenary.totalFare, 0) != 0 THEN  0 END))  AS DECIMAL(10, 2))
				END) AS totalFare

			,CAST(ISNULL(BookMasterItenary.totalFare, 0)  AS DECIMAL(10, 2)) AS totalFareWithOutROE

			,ISNULL(BookMasterItenary.ServiceFee,0) AS ServiceFee
			,ISNULL(BookMasterItenary.GST,0) AS GST	
			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(BookMasterItenary.ExtraTax,0) * BookMasterItenary.AgentROE * BookMasterItenary.ROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(BookMasterItenary.ExtraTax,0) * BookMasterItenary.ROE) AS DECIMAL(10, 2))
				END) AS ExtraTax
			,ISNULL(BookMasterItenary.TotalEarning,0) AS Discount
			,tblBookItenary.Via AS Via
			,FORMAT(tblBookItenary.deptTime, 'dd-MMM-yyyy', 'en-US') AS DepDate
            ,FORMAT(tblBookItenary.arrivalTime, 'dd-MMM-yyyy', 'en-US')  AS ArrivalDate
		     ,ISNULL(CONVERT(char(5), tblBookItenary.deptTime, 108),'') AS DeptTime
		     , ISNULL(CONVERT(char(5), tblBookItenary.arrivalTime, 108),'') AS ArrivalTime
            ,FORMAT(tblBookItenary.ReissueDate, 'dd-MMM-yyyy', 'en-US')  AS ReissueDate
		    ,ISNULL(tblBookItenary.BookingClass,'') AS BookingClass
	          ,ISNULL(BookMasterItenary.VendorName,'') AS WebServiceFlag
	         ,ISNULL(BookMasterItenary.OfficeID,'') AS OfficeID
	         ,ISNULL(BookMasterItenary.airCode,'') AS AirCode
		     ,ISNULL(BookMasterItenary.riyaPNR,'') AS Riyapnr
			 , (SELECT (CASE 
                   WHEN tblPassengerBookDetails.title IS NOT NULL AND tblPassengerBookDetails.title <> '' 
                   THEN tblPassengerBookDetails.title + '. ' 
                   ELSE '' 
                   END
                   + tblPassengerBookDetails.paxFName + ' ' 
                   + ISNULL(tblPassengerBookDetails.paxLName, '') + ' ') AS PaxName
		--	, (SELECT (ISNULL(tblPassengerBookDetails.title,'') + '. ' + tblPassengerBookDetails.paxFName + ' ' + ISNULL(tblPassengerBookDetails.paxLName,'') + ' ') AS PaxName
		     ,ISNULL(tblPassengerBookDetails.paxType,'') AS PaxType
		     ,ISNULL(tblBookMaster.GDSPNR, 'NA') AS GDSPNR
		     ,ISNULL(tblPassengerBookDetails.ticketNum,'') AS TicketNumber
		     ,ISNULL(tblPassengerBookDetails.baggage,'') AS Baggage
		     ,tblBookMaster.returnFlag AS ReturnFlag
			 ,ISNULL(tblBookItenary.airlinePNR,'') AS AirlinePNR
	         ,ISNULL(tblBookItenary.cabin, '') AS CabinClass
             ,ISNULL(tblBookItenary.farebasis, '') AS FareBasis	
			  ,(CASE WHEN tblBookMaster.BookingStatus = 6 
                    THEN ISNULL(tblPassengerBookDetails.BookingStatus, 1) ELSE tblBookMaster.BookingStatus
                 END) AS BookingStatus 
            ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.basicFare,0) * tblBookMaster.AgentROE * tblBookMaster.ROE)  AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.basicFare,0) * tblBookMaster.ROE) 
                    AS DECIMAL(10, 2))
				END) AS BasicFare

			,CAST(ISNULL(tblPassengerBookDetails.BasicFare, 0)  AS DECIMAL(10, 2)) AS BasicFareWithOutROE

			 ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.totalFare,0) * tblBookMaster.AgentROE * tblBookMaster.ROE)  AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.totalFare,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS TotalFare
			,CAST(ISNULL(tblPassengerBookDetails.totalFare, 0)  AS DECIMAL(10, 2)) AS TotalFareWithOutROE
		
		   ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((((ISNULL(tblPassengerBookDetails.totalFare,0) * tblBookMaster.AgentROE * tblBookMaster.ROE)
					 +tblPassengerBookDetails.B2BMarkup +tblPassengerBookDetails.BFC + tblPassengerBookDetails.ServiceFee
					 +tblPassengerBookDetails.GST+ ISNULL(tblPassengerBookDetails.VendorServiceFee,0)
					 + ISNULL(tblPassengerBookDetails.AirlineFee,0)+ ISNULL(tblPassengerBookDetails.AirlineGST,0))-(ISNULL(tblPassengerBookDetails.PLBCommission, 0)+ISNULL(tblPassengerBookDetails.IATACommission, 0)+ISNULL(tblPassengerBookDetails.DropnetCommission, 0))) AS DECIMAL(10, 2))
					ELSE CAST((((ISNULL(tblPassengerBookDetails.totalFare,0) * tblBookMaster.ROE)
					+tblPassengerBookDetails.B2BMarkup +tblPassengerBookDetails.BFC + tblPassengerBookDetails.ServiceFee
					+tblPassengerBookDetails.GST+ ISNULL(tblPassengerBookDetails.VendorServiceFee,0)
					+ ISNULL(tblPassengerBookDetails.AirlineFee,0)+ ISNULL(tblPassengerBookDetails.AirlineGST,0))-(ISNULL(tblPassengerBookDetails.PLBCommission, 0)+ISNULL(tblPassengerBookDetails.IATACommission, 0)+ISNULL(tblPassengerBookDetails.DropnetCommission, 0))) AS DECIMAL(10, 2))
				END) AS NetFare
				
				,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST(((ISNULL(tblPassengerBookDetails.totalFare,0) * tblBookMaster.AgentROE * tblBookMaster.ROE)
					 +tblPassengerBookDetails.B2BMarkup +tblPassengerBookDetails.BFC + tblPassengerBookDetails.ServiceFee
					 +tblPassengerBookDetails.GST+ISNULL(tblPassengerBookDetails.VendorServiceFee,0)
					 + ISNULL(tblPassengerBookDetails.AirlineFee,0)+ ISNULL(tblPassengerBookDetails.AirlineGST,0)) AS DECIMAL(10, 2))
					ELSE CAST(((ISNULL(tblPassengerBookDetails.totalFare,0) * tblBookMaster.ROE)
					+tblPassengerBookDetails.B2BMarkup +tblPassengerBookDetails.BFC + tblPassengerBookDetails.ServiceFee
					+tblPassengerBookDetails.GST+ISNULL(tblPassengerBookDetails.VendorServiceFee,0)
					+ ISNULL(tblPassengerBookDetails.AirlineFee,0)+ ISNULL(tblPassengerBookDetails.AirlineGST,0)) AS DECIMAL(10, 2))
				END) AS GrossFare

              ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.totalTax,0) * tblBookMaster.AgentROE * tblBookMaster.ROE)
				  AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.totalTax,0) * tblBookMaster.ROE)  AS DECIMAL(10, 2))
				END) AS TotalTax

			 ,CAST(ISNULL(tblPassengerBookDetails.totalTax, 0)  AS DECIMAL(10, 2)) AS TotalTaxWithOutROE

		     ,ISNULL(tblPassengerBookDetails.ServiceFee,0) AS ServiceFee
		     ,ISNULL(tblPassengerBookDetails.GST,0) AS GST
			  ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.YQ,0) * tblBookMaster.AgentROE * tblBookMaster.ROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.YQ,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS YQTax
            ,CAST(ISNULL(tblPassengerBookDetails.YQ, 0)  AS DECIMAL(10, 2)) AS YQTaxWithOutROE

			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.YRTax,0) * tblBookMaster.AgentROE * tblBookMaster.ROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.YRTax,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS YRTax
				,CAST(ISNULL(tblPassengerBookDetails.YRTax, 0)  AS DECIMAL(10, 2)) AS YRTaxWithOutROE

			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.JNTax,0) * tblBookMaster.AgentROE * tblBookMaster.ROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.JNTax,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS JNTax
				,CAST(ISNULL(tblPassengerBookDetails.JNTax, 0)  AS DECIMAL(10, 2)) AS JNTaxWithOutROE

			 ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.K7Tax,0) * tblBookMaster.AgentROE * tblBookMaster.ROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.K7Tax,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS K7Tax
				,CAST(ISNULL(tblPassengerBookDetails.K7Tax, 0)  AS DECIMAL(10, 2)) AS K7TaxWithOutROE

				 ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.INTax,0) * tblBookMaster.AgentROE * tblBookMaster.ROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.INTax,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS INTax
				,CAST(ISNULL(tblPassengerBookDetails.INTax, 0)  AS DECIMAL(10, 2)) AS INTaxWithOutROE

				,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.OCTax,0) * tblBookMaster.AgentROE * tblBookMaster.ROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.OCTax,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS OCTax
				,CAST(ISNULL(tblPassengerBookDetails.OCTax, 0)  AS DECIMAL(10, 2)) AS OCTaxWithOutROE

				,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.YMTax,0) * tblBookMaster.AgentROE * tblBookMaster.ROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.YMTax,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS YMTax
				,CAST(ISNULL(tblPassengerBookDetails.YMTax, 0)  AS DECIMAL(10, 2)) AS YMTaxWithOutROE

				,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.WOTax,0) * tblBookMaster.AgentROE * tblBookMaster.ROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.WOTax,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS WOTax
				,CAST(ISNULL(tblPassengerBookDetails.WOTax, 0)  AS DECIMAL(10, 2)) AS WOTaxWithOutROE

				,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.OBTax,0) * tblBookMaster.AgentROE * tblBookMaster.ROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.OBTax,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS OBTax
				,CAST(ISNULL(tblPassengerBookDetails.OBTax, 0)  AS DECIMAL(10, 2)) AS OBTaxWithOutROE

				,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.RFTax,0) * tblBookMaster.AgentROE * tblBookMaster.ROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.RFTax,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS RFTax
				,CAST(ISNULL(tblPassengerBookDetails.RFTax, 0)  AS DECIMAL(10, 2)) AS RFTaxWithOutROE

		     ,ISNULL(tblPassengerBookDetails.PLBCommission, 0)+ISNULL(tblPassengerBookDetails.IATACommission, 0)+ISNULL(tblPassengerBookDetails.DropnetCommission, 0) AS Discount
		     ,ISNULL(tblPassengerBookDetails.DiscountGST,0) AS DiscountGST
		     ,ISNULL(tblPassengerBookDetails.DiscountTDS,0) AS DiscountTDS
		     ,ISNULL(tblPassengerBookDetails.B2BMarkup,0) AS Markup
			 ,ISNULL(tblPassengerBookDetails.MarkOn,'') AS MarkOn
			 ,ISNULL(tblPassengerBookDetails.BFC,0) AS BFC
			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.MCOAmount,0) * tblBookMaster.AgentROE * tblBookMaster.ROE)  AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.MCOAmount,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS MCOAmount
		     ,ISNULL(tblPassengerBookDetails.MCOAmount,0) AS MCOAmountWithOutROE
		    ,ISNULL(tblPassengerBookDetails.VendorServiceFee,0) AS VendorServiceFee

				,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency
		 			THEN CAST((ISNULL(tblPassengerBookDetails.ExtraTax, 0)
					 * tblBookMaster.ROE * tblBookMaster.AgentROE) AS Numeric(18, 2))
									
		 		ELSE CAST((ISNULL(tblPassengerBookDetails.ExtraTax, 0)
					 *tblBookMaster.ROE) AS Numeric(18, 2))
		 	         END) AS XTTax

			 ,CAST((ISNULL(tblPassengerBookDetails.ExtraTax, 0)) AS Numeric(18, 2)) AS XTTaxWithOutROE
		
		     ,ISNULL(tblBookMaster.ROE,0) AS ROE
		     ,ISNULL(B2BMakepaymentCommission.TotalCommission,0) AS PGCharges
		     ,Paymentmaster.payment_mode AS PaymentMode
		     ,tblBookMaster.VendorName AS Supplier
		     ,tblBookMaster.OfficeID AS PCC
		     ,tblBookMaster.PricingCode AS PricingCode
		     ,tblBookMaster.TourCode AS TourCode
		     ,tblPassengerBookDetails.pid AS PassengerBookID 
		     ,tblBookMaster.pkid AS BookMasterID
		     ,BookItenaryPassenger.pkid AS BookItenaryID
		     ,ISNULL(tblPassengerBookDetails.FrequentFlyNo,'') AS FFNNumber
			 ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.AirlineFee,0) * tblBookMaster.AgentROE * tblBookMaster.ROE)  AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.AirlineFee,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS  AirlineFee
		     ,ISNULL(tblPassengerBookDetails.AirlineFee,0) AS AirlineFeeWithOutROE
			 ,ISNULL(tblPassengerBookDetails.EMDNumber,'') AS EMDNo

		     FROM tblPassengerBookDetails 
		     LEFT JOIN tblBookMaster  ON tblBookMaster.pkId = tblPassengerBookDetails.fkBookMaster
		     LEFT JOIN B2BMakepaymentCommission  ON B2BMakepaymentCommission.FkBookId = tblBookMaster.pkId
		     LEFT JOIN Paymentmaster  ON Paymentmaster.order_id = tblBookMaster.orderId
		     LEFT JOIN tblBookItenary BookItenaryPassenger ON  BookItenaryPassenger.fkBookMaster = tblBookMaster.pkId
		     WHERE tblPassengerBookDetails.pid IN (SELECT PassengerID FROM #mT1) 
			 and tblPassengerBookDetails.fkBookMaster =BookMasterItenary.pkId
			 and  tblBookItenary.pkId = BookItenaryPassenger.pkId 
		     FOR JSON PATH) AS OfflinePaxDetails

			FROM tblBookItenary 		
			INNER JOIN tblBookMaster BookMasterItenary ON BookMasterItenary.pkId = tblBookItenary.fkBookMaster
			INNER JOIN mCountryCurrency  ON mCountryCurrency.CountryCode= BookMasterItenary.Country     
			LEFT JOIN B2BMakepaymentCommission B2BMakepaymentCommissionI  ON B2BMakepaymentCommissionI.FkBookId = BookMasterItenary.pkId
			WHERE  tblBookItenary.pkId IN (SELECT ItenaryId FROM #mT1) 
	     FOR JSON PATH ,ROOT('OfflineFlightDetails')

		DROP TABLE #mT1
END