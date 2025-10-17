-- =============================================        
-- Author:  Jishaan Sayyed        
-- Create date: 28 Sept 2022        
-- Description: ERP Status Check Activity
-- =============================================
--[[USP_ERPStatusCheck_Activity]] 'Search','','WGZVFE-1',''
CREATE PROCEDURE [dbo].[USP_ERPStatusCheck_Activity] --'CABookingtickets','','WGZVFE-1',''
@Action varchar(50),
@riyaPNR varchar(50)=null,
@GDSPNR varchar(50)=null,
@fkbookmaster int =null
AS        
BEGIN        
	IF @Action = 'Cancellationtickets'  --Marine Cancellation        
	  BEGIN
	    SELECT TOP 1000 PB.ticketnumber,U.EmployeeNo as UserName, PB.BookingStatus,PB.CancERPResponseID,PB.CancERPPuststatus,
		PB.ERPResponseID,PB.ERPPuststatus,
	   --ED.VendorCode,
	   (select sum(SSR_Amount)  from tblSSRDetails s
		where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'') 
		in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Baggage' and s.SSR_Status=1)  as ExtraBaggage,    
		(select sum(SSR_Amount)  from tblSSRDetails s
		where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'') 
		in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Seat' and s.SSR_Status=1)
		as SeatPreferenceCharge,    
		(select sum(SSR_Amount)  from tblSSRDetails s
		where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'') 
		in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Meals' and s.SSR_Status=1)
		as MealCharges,
		isnull(BM.IssueDate, BM.inserteddate) as PostingDate,
	  case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, 
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
	   when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
	   when BM.BookingSource ='GDS' THEN PB.FMCommission
	   ELSE PB.Markup END AS VendIATACommAmount,
	   ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,
	   case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	   case when AC.type = 'FSC' then BM.GDSPNR else BI.airlinePNR end as PNRNo,
	      case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
		   BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,BBM.TotalCommission as Surcharge,
		   BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
		   BM.arrivalTime, PB.FMCommission,
		   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else CU.IATA end as IATA, 
		   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
		   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
		   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
		   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, 
		   BM.orderId, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
		   PB.pid, PB.title, PB.ticketNum, PB.pid, PB.basicFare, PB.totalTax, PB.paxType,        
		   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
		   PB.managementfees, PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,		         
		   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,  PB.JNTax as 'K3Tax',PB.YMTax,
		   PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
		   --BI.airlinePNR, BI.cabin, BI.farebasis,        
		   ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,ATT.Traveltype,ATT.Department,ATT.EmpDimession,ATT.Location,BM.FareType,  
		   Case	When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast
				When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode
				When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode
		   End As Icast,
		   BR.LocationCode, '' as BranchCode,'' as DivisionCode,   
			cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  ((PB.B2BMarkup+PB.HupAmount)/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE PB.HupAmount END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
		   --ERP.Canfees,
		   PB.CancellationPenalty as 'Canfees',
		   ERP.ServiceFees,
		   ERP.MarkuponPenalty, ERP.Narration,
		   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,
		   '' as FormOfPayment,  -- Need to check with manasvee
		   --1 for domestic
		   AM.Ticketcode as airlinecode,
		   SSR.SSR_Amount as 'extrabagAmount',
			(select isnull(sum(SSRMeal.SSR_Amount),0) from tblSSRDetails SSRMeal where 
	SSRMeal.fkPassengerid=PB.pid and SSRMeal.fkBookMaster=pb.fkbookmaster and SSRMeal.SSR_Type='Meals' and SSRMeal.SSR_Status=1 and SSRMeal.SSR_Amount>0
	group by SSRMeal.fkPassengerid)
	 as [Meal Charges],
		   --AC.type 'AirLineType'
		   case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'
	   FROM tblBookMaster BM
	   LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id        
	   LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID        
	   LEFT JOIN mUser U on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID        
	   LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR ON BM.AgentID = BR.FKUserID        
	   LEFT JOIN TBL_ERP_RefundProcess ERP ON ERP.PBID = PB.pid        
	   LEFT JOIN AirlineMaster AM ON AM.Airlinecode = BM.airCode        
	   LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode        
	   LEFT JOIN tblOwnerCurrency CU on BM.OfficeID = CU.OfficeID         
	   LEFT JOIN tblBookItenary BI ON BM.pkId = BI.fkBookMaster
	   Left JOIN tblSSRDetails SSR on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1  
	   --left join tblSSRDetails SSR1 on ssr.fkPassengerid=PB.pid and SSR1.SSR_Type='Meal' and SSR1.SSR_Status=1   
	   LEFT Join mCardDetails CD ON CD.CardNumber = PM.EnCardNumber
	   LEFT Join B2BMakepaymentCommission BBM on BBM.orderId = BM.OrderId
	   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'
	   and PB.BookingStatus In(4,11) --As confirm with Mansavee
	   --and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)
	   and BM.inserteddate > (Getdate()-60) -- '2021-08-31 23:59:59.999'        
	   and BM.Country in ('IN','AE')
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country     
	   and AL.userTypeID = 3 --For Marine usertype is 3 ***  
	   and BM.VendorName Not in ('STS')
	   AND (BM.riyaPNR = @riyaPNR OR BM.riyaPNR IS NULL OR @riyaPNR IS NULL or @riyaPNR = '')
	   AND (BM.GDSPNR = @GDSPNR OR BM.GDSPNR IS NULL OR @GDSPNR IS NULL or @GDSPNR = '')
	   ORDER BY BM.IssueDate DESC
	  END
    
	IF @Action = 'MarineBookingtickets'        
	  BEGIN
	   SELECT TOP 1000 PB.ticketnumber, ED.AgentCountry,ED.OwnerCountry, ED.ERPCountry, BM.MainAgentId        
	  ,U.EmployeeNo as UserName, BM.bookingStatus, PB.ERPResponseID,PB.ERPPuststatus,PB.BookingStatus as CanStatus,
	  case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	  '0' as 'Canfees',
	  isnull(BM.IssueDate, BM.inserteddate) as PostingDate,
	  case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
	   when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
	   when BM.BookingSource ='GDS' THEN PB.FMCommission
	   ELSE PB.Markup END AS VendIATACommAmount,
	  ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
	  case when AC.type = 'FSC' then BM.GDSPNR else BI.airlinePNR end as PNRNo,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	  --case when PM.payment_mode='passThrough' then 'CUSTOMER'         
	  --when PM.payment_mode='Credit' then 'CORPORATE'         
	  --Else 'CASH' end as UATP,        
	  PB.pid,BM.pkId, BBM.TotalCommission as Surcharge,
	  (select sum(SSR_Amount)  from tblSSRDetails s
		where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'') 
		in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Baggage' and s.SSR_Status=1)  as ExtraBaggage,    
		(select sum(SSR_Amount)  from tblSSRDetails s
		where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'') 
		in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Seat' and s.SSR_Status=1)
		as SeatPreferenceCharge,    
		(select sum(SSR_Amount)  from tblSSRDetails s
		where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'') 
		in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Meals' and s.SSR_Status=1)
		as MealCharges,
	  case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, 
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else TOC.IATA end as IATA, 
	  BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,        
	  BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	  BM.arrivalTime, BM.frmSector, BM.toSector, BM.flightNo, BM.travClass, PB.FMCommission,
	  BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,
	  BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	  BM.orderId,
	  PB.title, PB.ticketNum, PB.pid, PB.basicFare, PB.totalTax, PB.paxType,
	  PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,
	  PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	
	  PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax, PB.RFTax, PB.JNTax as 'K3Tax',
	  --Added By Rahul as per ranjit discussion        
	  PB.WOTax,PB.YMTax,PB.OBTax,        
	  --End        
	  PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	  --BI.airlinePNR, BI.cabin, BI.farebasis,        
	  PB.ServiceFee as 'ServiceFees',
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  ((PB.B2BMarkup+PB.HupAmount)/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE PB.HupAmount END),0))as decimal(18,2)) as MarkupOnTaxFare,
	  (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
	  '' as Narration,        
	  --BM.AgentROE as 'SalesExchangeRate',        
	  --BM.AgentCurrency as 'SalesCurrencyCode',        
	  PB.BaggageFare,        
	  --Added By Rahul Agrahari.
	  ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.ReasonofTravel 'Traveltype',ATT.AType ,PB.Profession 'RankNo', 
	  ATT.Department, ATT.EmpDimession, ATT.Location, ATT.Traveltype ,BM.FareType,  
	  Case	When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast
			When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode
			End As Icast,
	 BR.LocationCode, '' as BranchCode,'' as DivisionCode,        
	  -- ERP.ServiceFees, ERP.MarkuponPenalty, ERP.Narration,        
	  AM.Ticketcode as airlinecode,        
	  case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	  '' as FormOfPayment,  -- Need to check with manasvee        
	  --1 for domestic        
	  BM.IssueBy as 'TicketinguserID', BM.BookedBy as 'BookinguserID',        
	  Case when BM.VendorName='Amadeus' then '1A' when BM.VendorName='Galileo' then '1G' when BM.VendorName='Sabre' then '1S' Else '' 
	  End as CRSCode,        
	  BM.AgentROE as 'SalesCurrROE', BM.AgentCurrency as 'SalesCurr', TOC.Currency as 'PurchaseCurr', BM.ROE as 'PurchaseCurrROE', PB.baggage,
	  SSR.SSR_Amount as 'extrabagAmount',
	  --SSR1.SSR_Amount as 'Meal Charges',
	 (select isnull(sum(SSRMeal.SSR_Amount),0) from tblSSRDetails SSRMeal where 
		SSRMeal.fkPassengerid=PB.pid and SSRMeal.fkBookMaster=pb.fkbookmaster and SSRMeal.SSR_Type='Meals' and SSRMeal.SSR_Status=1 and SSRMeal.SSR_Amount>0
		group by SSRMeal.fkPassengerid)
		 as [Meal Charges],
	  case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType', Case when ED.AgentCountry = ED.OwnerCountry and bm.AgentROE = 1  then '0' else '1' end as Intcompanytrans
	  FROM tblBookMaster BM        
		LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
		LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id        
		LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID        
		LEFT JOIN mUser U on BM.MainAgentId = U.ID        
		LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID        
		LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID        
		LEFT JOIN B2BRegistration BR ON BM.AgentID = BR.FKUserID        
		LEFT JOIN tblOwnerCurrency TOC ON TOC.OfficeID = BM.OfficeId  --and Toc.Currency in (Select top 1 Currencycode from mCountryCurrency as mc  where mc.CountryCode= BM.country)--=BM.AgentCurrency --and TOC.UserType=AL.userTypeID
		LEFT JOIN AirlineMaster AM ON AM.Airlinecode = BM.airCode and AM.Status='A'    
		LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode
		left join tblSSRDetails SSR on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1 and SSR.SSR_Amount > 0
	--left join tblSSRDetails SSR1 on ssr.fkPassengerid=PB.pid and SSR1.SSR_Type='Meal' and SSR1.SSR_Status=1   
	    LEFT JOIN tblBookItenary BI ON BM.pkId = BI.fkBookMaster
		LEFT Join mCardDetails CD ON CD.CardNumber = PM.EnCardNumber
		LEFT Join B2BMakepaymentCommission BBM on BBM.orderId = BM.OrderId
	  WHERE  
	  BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'  --and BM.riyaPNR = '1D3S01'        
		and BM.BookingStatus IN(1,6)   --As confirm with Mansavee        
		--and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)        
		and BM.inserteddate > (Getdate()-60) -- '2021-08-31 23:59:59.999'        
		and ED.AgentCountry in ('IN','AE') --('US','CA') --
		and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country
		and AL.userTypeID = 3 --For Marine usertype is 3 ***
		AND (BM.riyaPNR = @riyaPNR OR BM.riyaPNR IS NULL OR @riyaPNR IS NULL)
	    AND (BM.GDSPNR = @GDSPNR OR BM.GDSPNR IS NULL OR @GDSPNR IS NULL)
		and BM.VendorName Not in ('STS')
		ORDER BY BM.IssueDate DESC
	  END          
	IF @Action = 'ErrorLogs'
		BEGIN
		Select top 1 * from NewERPData_Log where (FK_tblbookmasterID = @fkbookmaster 
		or FK_tblbookmasterID is null 
		or @fkbookmaster is null) order by 1 desc
		END
END