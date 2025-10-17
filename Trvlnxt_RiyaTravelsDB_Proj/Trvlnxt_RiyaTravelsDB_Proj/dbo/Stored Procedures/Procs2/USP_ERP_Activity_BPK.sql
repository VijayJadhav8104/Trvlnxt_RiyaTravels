-- =============================================        
-- Author:  Pranay kini        
-- Create date: 4 May 2021        
-- Description: ERP Activity
-- =============================================
--[USP_ERP_Activity] 'Search','','WGZVFE-1',''
CREATE PROCEDURE [dbo].[USP_ERP_Activity_BPK] --'CABookingtickets','','WGZVFE-1',''        
 @Action varchar(50)=null,
 @orderId varchar(100) =null,
 @Ticketnumber varchar(50)=null,
 @flag varchar(10) =null,
 @BMID varchar(50) =null,        
 @PBID varchar(50) =null,        
 @CustomerNumber varchar(50) =null,        
 @Canfees varchar(50) =null,        
 @ServiceFees varchar(50) =null,        
 @MarkupOnBaseFare varchar(50) =null,        
 @MarkupOnTaxFare varchar(50) =null,        
 @MarkuponPenalty varchar(50) =null,        
 @Narration  varchar(50) =null,
 @empcode varchar(50) =null
AS        
BEGIN        
	IF @Action = 'Cancellationtickets'  --Marine Cancellation        
	  BEGIN
	   SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, BM.bookingStatus,
	   --ED.VendorCode,
	      case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
		   BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,
		   BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
		   BM.arrivalTime, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
		   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else CU.IATA end as IATA, 
		   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
		   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
		   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
		   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, 
		   BM.orderId,        
		   PB.pid, PB.title, PB.ticketNum, PB.pid, PB.basicFare, PB.totalTax, PB.paxType,        
		   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
		   PB.managementfees, PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,		         
		   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,        
		   PM.CardType, PM.CardNumber, PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
		   --BI.airlinePNR, BI.cabin, BI.farebasis,        
		   ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,ATT.Traveltype,BM.FareType,  
		   Case	When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast
				When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode
				When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode
		   End As Icast,
		   '' as LocationCode, '' as BranchCode,'' as DivisionCode,   
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
		   AC.type 'AirLineType'        
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
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId
	   Left JOIN tblSSRDetails SSR on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1  
	   --left join tblSSRDetails SSR1 on ssr.fkPassengerid=PB.pid and SSR1.SSR_Type='Meal' and SSR1.SSR_Status=1   
	   WHERE        
	   BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	   and PB.BookingStatus In(4,11) --As confirm with Mansavee         
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)           
	   and BM.inserteddate > '2020-12-31 23:59:59.999' and BM.Country in ('IN','AE','US','CA')        
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country     
	   and AL.userTypeID = 3 --For Marine usertype is 3 ***    
	   and BM.VendorName Not in ('STS')
	   ORDER BY BM.IssueDate DESC
	  END
    
	IF @Action = 'MarineBookingtickets'        
	  BEGIN        
	  SELECT TOP 10000 PB.ticketnumber, ED.AgentCountry,ED.OwnerCountry, ED.ERPCountry, BM.MainAgentId        
	  ,U.EmployeeNo as UserName, BM.bookingStatus,    
	  '0' as 'Canfees',
	  --ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	  case when PM.payment_mode='passThrough' then 'CUSTOMER'         
	  when PM.payment_mode='Credit' then 'CORPORATE'         
	  Else 'CASH' end as UATP,        
	  PB.pid,BM.pkId, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else TOC.IATA end as IATA, 
	  BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,        
	  BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	  BM.arrivalTime, BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
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
	  PM.CardType, PM.CardNumber, PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	  --BI.airlinePNR, BI.cabin, BI.farebasis,        
	  PB.ServiceFee as 'ServiceFees',
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  ((PB.B2BMarkup+PB.HupAmount)/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE PB.HupAmount END),0))as decimal(18,2)) as MarkupOnTaxFare,
	  (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   
	  --ISNULL(PB.B2bMarkup,0) +ISNULL(PB.BFC,0) as 'MarkupOnBaseFare' ,'' as MarkupOnTaxFare ,
	  '' as Narration,        
	  --BM.AgentROE as 'SalesExchangeRate',        
	  --BM.AgentCurrency as 'SalesCurrencyCode',        
	  PB.BaggageFare,        
	  --Added By Rahul Agrahari.
	  ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.ReasonofTravel 'Traveltype',ATT.AType ,PB.Profession 'RankNo',BM.FareType,  
	  Case	When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast
			When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode
			End As Icast,
	  LocationCode='', '' as BranchCode,'' as DivisionCode,        
	  ------ERP.Canfees, ERP.ServiceFees, ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare, ERP.MarkuponPenalty, ERP.Narration,        
	  AM.Ticketcode as airlinecode,        
	  case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	  '' as FormOfPayment,  -- Need to check with manasvee        
	  --1 for domestic        
	  BM.IssueBy as 'TicketinguserID',        
	  BM.BookedBy as 'BookinguserID',        
	  case when BM.VendorName='Amadeus' then '1A'         
	  when BM.VendorName='Galileo' then '1G'         
	  when BM.VendorName='Sabre' then '1S'         
	  Else TOC.OfficeID end as CRSCode,        
	  BM.AgentROE as 'SalesCurrROE',        
	  BM.AgentCurrency as 'SalesCurr',        
	  TOC.Currency as 'PurchaseCurr',        
	  BM.ROE as 'PurchaseCurrROE',        
	  PB.baggage,        
	  SSR.SSR_Amount as 'extrabagAmount',    
	  --SSR1.SSR_Amount as 'Meal Charges',
	 (select isnull(sum(SSRMeal.SSR_Amount),0) from tblSSRDetails SSRMeal where 
		SSRMeal.fkPassengerid=PB.pid and SSRMeal.fkBookMaster=pb.fkbookmaster and SSRMeal.SSR_Type='Meals' and SSRMeal.SSR_Status=1 and SSRMeal.SSR_Amount>0
		group by SSRMeal.fkPassengerid)
		 as [Meal Charges],
	  AC.type 'AirLineType', Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans        
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
	--LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId      	 
	  WHERE        
	  BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'  --and BM.riyaPNR = '1D3S01'        
	  and BM.BookingStatus IN(1,6)   --As confirm with Mansavee        
	 and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)        
	  and BM.inserteddate > (Getdate()-2) -- '2021-08-31 23:59:59.999'        
	  and ED.AgentCountry in ('IN','AE') --('IN','AE','US','CA')        
	  and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country        
	  and AL.userTypeID = 3 --For Marine usertype is 3 *** 
	  and BM.VendorName Not in ('STS')
	  ORDER BY BM.IssueDate DESC
	 END        
    	
	IF @Action = 'B2CCancellationtickets'        
	  BEGIN        
	   SELECT TOP 10000 PB.ticketnumber,        
	   U.UserName, BM.bookingStatus,        
	   --ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	   BM.pkId, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,        
	   BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	   BM.arrivalTime, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.IATA end as IATA, 
	   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	   BM.orderId, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
	   PB.pid, PB.title, PB.ticketNum,PB.basicFare, PB.totalTax, PB.paxType,        
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	     
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,PB.CancellationCharge,PB.CancellationPenalty, 
	   PB.WOTax, PB.YMTax, PB.JNTax as 'K3Tax',    case when PM.payment_mode='passThrough' then 'CUSTOMER'         
	   when PM.payment_mode='Credit' then 'CORPORATE'         
	   Else 'CASH' end as UATP,
	   PM.CardType, PM.CardNumber, PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	   --BI.airlinePNR, BI.cabin, BI.farebasis,
	   ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,
	   Icast='ICUST35086','' as LocationCode, '' as BranchCode,'' as DivisionCode,        
	   ERP.Canfees, ERP.ServiceFees, 
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   
	   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare, 
	   ERP.MarkuponPenalty, ERP.Narration,         
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   AM.Ticketcode as airlinecode,        
	   AC.type 'AirLineType'        
	   FROM tblBookMaster BM        
	   LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id        
	   LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID        
	   LEFT JOIN mUser U on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID        
	   LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID        
	   --LEFT JOIN B2BRegistration BR ON BM.AgentID = BR.FKUserID        
	   LEFT JOIN TBL_ERP_RefundProcess ERP ON ERP.PBID = PB.pid        
	   LEFT JOIN AirlineMaster AM ON AM.Airlinecode = BM.airCode        
	   LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode        
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId
	   WHERE        
	   BM.IsBooked =1 and BM.totalFare > 0         
	   and cast(BM.AgentID as varchar(50))= 'B2C'        
	   and BM.BookingStatus In(4,11) --As confirm with Mansavee        
	   and PB.Iscancelled In(1) --As confirm with Mansavee        
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)        
	   and BM.inserteddate > '2021-08-01 23:59:59.999'         
	   --and BM.Country in ('IN','AE','US','CA') --For B2C BM.Country is not required ***         
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country        
	   and BM.VendorName Not in ('STS')
	   ORDER BY BM.IssueDate DESC 
	  END        
        
	IF @Action = 'B2CBookingtickets'        
	  BEGIN        
	   SELECT TOP 10000 U.UserName,
	   --ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	   BM.VendorName, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	   BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime,        
	   BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,        
	   BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',        
	   BM.VendorCommissionPercent,
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else CU.IATA end as IATA,
	   BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.pid,PB.basicFare,PB.totalTax,PB.paxType,   PB.YMTax,     
	   PB.paxFName,PB.paxLName,PB.managementfees,PB.baggage,        
	   case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax,PB.YQ,PB.INTax,PB.JNTax,PB.OCTax,PB.ExtraTax,PM.CardType,PM.CardNumber,PM.mer_amount,PM.billing_address,        
	   PM.billing_name,PM.order_id,PM.tracking_id,BI.airlinePNR,BI.cabin,BI.farebasis,ATT.VesselName,ATT.TR_POName,ATT.Bookedby,ATT.AType        
	   ,ATT.RankNo,Icast = 'ICUST35086', LocationCode = '', BranchCode = '', PR.EmpCode,AC.type 'AirLineType',
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare	   
	   FROM tblBookMaster BM        
		LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
		LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id        
		LEFT JOIN tblBookItenary BI ON BM.pkId = BI.fkBookMaster        
		LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID               
		LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country         
		--LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID           
		Left Join PNRRetriveDetails PR on BM.orderId = PR.OrderID        
		LEFT JOIN mUser U on BM.MainAgentId = U.ID           
		LEFT JOIN tblOwnerCurrency CU on BM.OfficeID = CU.OfficeID         
		LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode        
		WHERE BM.IsBooked =1 and BM.totalFare > 0         
		and cast(BM.AgentID as varchar(50))= 'B2C'        
		and BM.BookingStatus In (1,6) --As confirm with Mansavee           '0'  Means Trns Failed
		and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)        
		and BM.inserteddate > (Getdate()-2) --'2021-08-31 23:59:59.999'             
		and BM.Country in('IN')        
		and BM.VendorName Not in ('STS')
		and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country        
		--and AL.userTypeID = 3 --For B2C usertype is not required ***         	
		ORDER BY BM.IssueDate DESC
	  END        
    
	IF @Action = 'B2BCancellationTickets'        
	  BEGIN        
	   SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, BM.bookingStatus,
	   --ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	   BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber,BM.IssueDate,        
	   BM.canceledDate,BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime, BM.arrivalTime, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else CU.IATA end as IATA, 
	   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, BM.orderId,        
	   PB.pid, PB.title, PB.ticketNum, PB.pid, PB.basicFare, PB.totalTax, PB.paxType,        
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	        
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,   PB.YMTax,     
	   PM.CardType, PM.CardNumber, PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
	   ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,
	   Case	When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast
			When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode
	   End As Icast,
	   '' as LocationCode, '' as BranchCode,'' as DivisionCode, PR.EmpCode,ATT.OBTCno,       
	   ERP.Canfees, ERP.ServiceFees, 
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   
	   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare
	   ERP.MarkuponPenalty, ERP.Narration,PB.CancellationPenalty  , 
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   AM.Ticketcode as airlinecode,SSR.SSR_Amount as 'extrabagAmount',        
	   AC.type 'AirLineType'        
	   FROM tblBookMaster BM        
	   LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id        
	   LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID        
	   LEFT JOIN mUser U on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID        
	   LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR ON BM.AgentID = BR.FKUserID        
	   Left Join PNRRetriveDetails PR on BM.orderId = PR.OrderID        
	   LEFT JOIN TBL_ERP_RefundProcess ERP ON ERP.PBID = PB.pid        
	   LEFT JOIN AirlineMaster AM ON AM.Airlinecode = BM.airCode        
	   LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode        
	   LEFT JOIN tblOwnerCurrency CU on BM.OfficeID = CU.OfficeID         
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
	   Left JOIN tblSSRDetails SSR on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1        
	   WHERE        
	   BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	   and PB.BookingStatus In(4,11) --As confirm with Mansavee         
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)           
	   and BM.inserteddate > '2020-12-31 23:59:59.999' and BM.Country in ('IN')
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country     
	   and AL.userTypeID = 2
	   and BM.VendorName Not in ('STS')
	   ORDER BY BM.IssueDate DESC
	  END        

	IF @Action = 'B2BBookingTickets'        
	  BEGIN        
	  SELECT TOP 10000 U.EmployeeNo as UserName, ED.AgentCountry, ED.OwnerCountry,PB.pid,
	  --ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	  BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
	  BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,        
	  BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',        
	  BM.VendorCommissionPercent,BM.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else CU.IATA end as IATA,
	  --Cu.Currency,
	   case when PM.payment_mode='passThrough' then 'CUSTOMER'         
	   when PM.payment_mode='Credit' then 'CORPORATE'         
	   Else 'CASH' end as UATP,
	  case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end as 'Currency'
	  ,BM.ROE,        
	  BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.pid,PB.basicFare,PB.totalTax,PB.paxType,PB.paxFName,PB.paxLName,        
	  PB.managementfees,PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax,PB.YQ,PB.INTax,PB.JNTax,PB.OCTax,PB.ExtraTax,PB.WOTax,PB.BaggageFare,PM.CardType,        
	  PM.CardNumber,PM.mer_amount,PM.billing_address,PM.billing_name,PM.order_id,PM.tracking_id,BI.airlinePNR,BI.cabin,BI.farebasis,         PB.YMTax,
	  ATT.VesselName,ATT.TR_POName,ATT.Bookedby,ATT.AType,ATT.RankNo,
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	  Case	When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode
	  End As Icast,
	  LocationCode = '', BranchCode = '', PR.EmpCode,AC.type 'AirLineType',ATT.OBTCno
	    ,BM.AgentROE as 'SalesCurrROE',        
	   BM.AgentCurrency as 'SalesCurr',        
	   case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end as 'PurchaseCurr',        
	   BM.ROE as 'PurchaseCurrROE'
	   ,Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans
	  FROM tblBookMaster BM        
	  LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
	  LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id          
	  LEFT JOIN tblBookItenary BI ON BM.pkId = BI.fkBookMaster        
	  LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID         
	  LEFT JOIN B2BRegistration B2BR ON BM.AgentID = B2BR.FKUserID        
	  LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country        
	  LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID           
	  Left Join PNRRetriveDetails PR on BM.orderId = PR.OrderID        
	  LEFT JOIN mUser U on BM.MainAgentId = U.ID           
	  LEFT JOIN tblOwnerCurrency CU on BM.OfficeID = CU.OfficeID         
	  LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode  
	  WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	  and BM.BookingStatus In(1,6) --As confirm with Mansavee        
	  -- For Booking        
	  and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)        
	  and BM.inserteddate > (Getdate()-2) --'2021-08-31 23:59:59.999'         
	  and BM.Country in('IN')        
	  and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country         
	  and AL.userTypeID IN(2) --For B2B usertype is 2 ***    
	  and BM.VendorName Not in ('STS')
	  ORDER BY BM.inserteddate DESC        
	 END  
	 
	 IF @Action = 'RBTCancellationTickets'        
	  BEGIN        
	   SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, BM.bookingStatus,
	   --ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	   BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,        
	   BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	   BM.arrivalTime, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else CU.IATA end as IATA, BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, 
	   BM.orderId,        
	   PB.pid, PB.title, PB.ticketNum, PB.pid, PB.basicFare, PB.totalTax, PB.paxType,        
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,         PB.YMTax,
	   PM.CardType, PM.CardNumber, PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
	   ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,
	   Case	When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast
			When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode
	   End As Icast,
	   '' as LocationCode, '' as BranchCode,'' as DivisionCode, PR.EmpCode,ATT.OBTCno,       
	   ERP.Canfees, ERP.ServiceFees, 
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	   ERP.MarkuponPenalty, ERP.Narration,         
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   AM.Ticketcode as airlinecode,SSR.SSR_Amount as 'extrabagAmount',        
	   AC.type 'AirLineType'        
	   FROM tblBookMaster BM        
	   LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id        
	   LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID        
	   LEFT JOIN mUser U on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID        
	   LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR ON BM.AgentID = BR.FKUserID        
	   Left Join PNRRetriveDetails PR on BM.orderId = PR.OrderID        
	   LEFT JOIN TBL_ERP_RefundProcess ERP ON ERP.PBID = PB.pid        
	   LEFT JOIN AirlineMaster AM ON AM.Airlinecode = BM.airCode        
	   LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode        
	   LEFT JOIN tblOwnerCurrency CU on BM.OfficeID = CU.OfficeID         
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
	   Left JOIN tblSSRDetails SSR on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1        
	   WHERE        
	   BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	   and PB.BookingStatus In(4,11) --As confirm with Mansavee         
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)           
	   and BM.inserteddate > '2020-12-31 23:59:59.999' and BM.Country in ('IN')
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country     
	   and AL.userTypeID = 5
	   and BM.VendorName Not in ('STS')
	   ORDER BY BM.IssueDate DESC
	  END        

	IF @Action = 'RBTBookingTickets'        
	  BEGIN        
	  SELECT TOP 10000 U.EmployeeNo as UserName,
	  --ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	  BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
	  BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,        
	  BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',        
	  BM.VendorCommissionPercent,BM.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else CU.IATA end as IATA,
	  case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end as 'Currency',BM.ROE,        
	  BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.pid,PB.basicFare,PB.totalTax,PB.paxType,PB.paxFName,PB.paxLName,        
	  PB.managementfees,PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax,PB.YQ,PB.INTax,PB.JNTax, PB.YMTax,
	  PB.WOTax,PB.OCTax,PB.ExtraTax,PB.BaggageFare,PM.CardType,        
	  PM.CardNumber,PM.mer_amount,PM.billing_address,PM.billing_name,PM.order_id,PM.tracking_id,BI.airlinePNR,BI.cabin,BI.farebasis,        
	  ATT.VesselName,ATT.TR_POName,ATT.Bookedby,ATT.AType,ATT.RankNo,        	       
	  Case	When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode
	  End As Icast,
	  LocationCode = '', BranchCode = '', PR.EmpCode,AC.type 'AirLineType',ATT.OBTCno,
	  --Added By Rahul A
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	  ATT.CostCenter,ATT.TravelerType,ATT.Changedcostno,ATT.Travelduration,ATT.TASreqno,ATT.Companycodecc,ATT.Projectcode
	  ,ISNULL(ATT.CostCenter,'') as _str1060, ISNULL(ATT.Traveltype,'')  as _str1061 ,ISNULL(ATT.EmpDimession,'')  as _str1028, ISNULL(ATT.Changedcostno,'')  as _str1025,
	   ISNULL(ATT.Travelduration,'')  as _str1054, ISNULL(ATT.TASreqno,'')  as _str1022, ISNULL(ATT.Companycodecc,'')  as _str1023, ISNULL(ATT.Projectcode,'') as _str1024

	  FROM tblBookMaster BM        
	  LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
	  LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id          
	  LEFT JOIN tblBookItenary BI ON BM.pkId = BI.fkBookMaster        
	  LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID         
	  LEFT JOIN B2BRegistration B2BR ON BM.AgentID = B2BR.FKUserID        
	  LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country        
	  LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID           
	  Left Join PNRRetriveDetails PR on BM.orderId = PR.OrderID        
	  LEFT JOIN mUser U on BM.MainAgentId = U.ID           
	  LEFT JOIN tblOwnerCurrency CU on BM.OfficeID = CU.OfficeID         
	  LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode  
	  WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	  and BM.BookingStatus In(1,6) --As confirm with Mansavee        
	  -- For Booking        
	  and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)        
	  and BM.inserteddate > (Getdate()-2) -- '2021-08-31 23:59:59.999'         
	  and BM.Country in('IN')
	  and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country         
	  and AL.userTypeID IN(5) --For B2B usertype is 2 ***    
	  and BM.VendorName Not in ('STS') 
	  ORDER BY BM.inserteddate DESC        
	 END  
    
	IF @Action = 'HolidayCancellationtTickets'
	  BEGIN        
	   SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, BM.bookingStatus,
	   --ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	   BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
	   BM.RegistrationNumber, BM.IssueDate,BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,BM.arrivalTime,
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else CU.IATA end as IATA,
	   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, 
	   BM.equipment,BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, 
	   BM.orderId,PB.title, PB.ticketNum, PB.pid, PB.basicFare,
	   PB.totalTax, PB.paxType,PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,PB.managementfees, 
	   PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,PM.CardType, PM.CardNumber, PM.mer_amount, PM.billing_address,
	   PM.billing_name, PM.order_id, PM.tracking_id,       PB.YMTax,  
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
		ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,
		Icast= 'BOMCUST002120A',
		LocationCode = 'BOM', BranchCode = 'BR2002000', '' as DivisionCode,  PR.EmpCode,ATT.OBTCno,	         
	   ERP.Canfees, ERP.ServiceFees, 
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	   ERP.MarkuponPenalty, ERP.Narration,         
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   AM.Ticketcode as airlinecode,SSR.SSR_Amount as 'extrabagAmount',        
	   AC.type 'AirLineType'
	   FROM tblBookMaster BM        
	   LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id        
	   LEFT JOIN tblBookItenary BI ON BM.orderId = BI.orderId        
	   LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID         
	   LEFT JOIN B2BRegistration B2BR ON BM.AgentID = B2BR.FKUserID        
	   LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID           
	   LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID           
	   Left Join PNRRetriveDetails PR on BM.orderId = PR.OrderID        
	   LEFT JOIN TBL_ERP_RefundProcess ERP ON ERP.PBID = PB.pid        
	   LEFT JOIN mUser U on BM.MainAgentId = U.ID           
	   LEFT JOIN tblOwnerCurrency CU on BM.OfficeID = CU.OfficeID         
	   LEFT JOIN AirlineMaster AM ON AM.Airlinecode = BM.airCode        
	   LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode  
	   Left JOIN tblSSRDetails SSR on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1   
	   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	   and PB.BookingStatus In (4,11) 
	   -- For Cancellation        
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)           
	   and BM.inserteddate > '2021-08-31 23:59:59.999'         
	   --and BM.Country in('IN','AE','US','CA')  // Commented As Discussed With Pranay & Bhavika        
	   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country
	   and AL.userTypeID IN(4) --For Holiday usertype is 4 ***   
	   and BM.VendorName Not in ('STS')	   
	   --and BM.riyaPNR = 'ZKV336'      
	   --and PB.TicketNumber In ('FJGK9P-1')
	   ORDER BY BM.inserteddate DESC
	  END        
	
	IF @Action = 'HolidayBookingTickets'        
	  BEGIN        
	  SELECT TOP 10000 U.EmployeeNo as UserName,
	  --ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	  BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,   
	  BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,        
	  BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',        
	  BM.VendorCommissionPercent,BM.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else CU.IATA end as IATA,
	  case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end as 'Currency',BM.ROE,        
	  BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.pid,PB.basicFare,PB.totalTax,PB.paxType,PB.paxFName,PB.paxLName,        
	  PB.managementfees,PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax,PB.YQ,PB.INTax,PB.JNTax,PB.OCTax,PB.ExtraTax,PB.BaggageFare,PM.CardType,        
	  PM.CardNumber,PM.mer_amount,PM.billing_address,PM.billing_name,PM.order_id,PM.tracking_id,BI.airlinePNR,BI.cabin,BI.farebasis,        
	  ATT.VesselName,ATT.TR_POName,ATT.Bookedby,ATT.AType,ATT.RankNo,  PB.YMTax,           
	   --Case	When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast
			--When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode
			--When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode
			--End As Icast,	
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	  Icast= 'BOMCUST002120A',
	  LocationCode = 'BOM', BranchCode = 'BR2002000',  PR.EmpCode,AC.type 'AirLineType',ATT.OBTCno
	  FROM tblBookMaster BM        
	   LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id        
	   LEFT JOIN tblBookItenary BI ON BM.orderId = BI.orderId        
	   LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID         
	   LEFT JOIN B2BRegistration B2BR ON BM.AgentID = B2BR.FKUserID        
	   LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID           
	   LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID           
	   Left Join PNRRetriveDetails PR on BM.orderId = PR.OrderID        
	   LEFT JOIN mUser U on BM.MainAgentId = U.ID           
	   LEFT JOIN tblOwnerCurrency CU on BM.OfficeID = CU.OfficeID         
	   LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode        
	   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	   and BM.BookingStatus In (1,6) --= 4 For Cancellation  =1 For Booking  --As confirm with Mansavee        
	   -- For Booking        
	   and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)        
	   and BM.inserteddate > (Getdate()-2) -- '2021-08-31 23:59:59.999'         
	   --and BM.Country in('IN','AE','US','CA')  // Commented As Discussed With Pranay & Bhavika        
	   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country
	   and AL.userTypeID IN(4) --For Holiday usertype is 4 ***   
	  -- and BM.riyaPNR='624U2N'
	   and BM.VendorName Not in ('STS')
	   ORDER BY BM.inserteddate DESC
	 END        
        
	IF @Action = 'UAEBookingTickets'        
	  BEGIN        
	  SELECT TOP 10000 U.EmployeeNo as UserName,--ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	  BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,  
	  BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,        
	  BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',        
	  BM.VendorCommissionPercent,BM.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else CU.IATA end as IATA,
	  case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end  as 'Currency',BM.ROE,        
	  BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.pid,PB.basicFare,PB.totalTax,PB.paxType,PB.paxFName,PB.paxLName,        
	  PB.managementfees,PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax,PB.YQ,
	  PB.WOTax,PB.INTax,PB.JNTax,PB.OCTax,PB.ExtraTax,PB.BaggageFare,PM.CardType,         PB.YMTax,
	  PM.CardNumber,PM.mer_amount,PM.billing_address,PM.billing_name,PM.order_id,PM.tracking_id,BI.airlinePNR,BI.cabin,BI.farebasis,        
	  ATT.VesselName,ATT.TR_POName,ATT.Bookedby,ATT.AType,ATT.RankNo,          
	  Case	When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode
			End As Icast,
	  LocationCode = '', BranchCode = '', PR.EmpCode,AC.type 'AirLineType'    ,
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
		, BM.AgentROE as 'SalesCurrROE',        
	  BM.AgentCurrency as 'SalesCurr',         
	  CU.Currency as 'PurchaseCurr',        
	  BM.ROE as 'PurchaseCurrROE',
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  ((PB.B2BMarkup+PB.HupAmount)/isnull(BM.AgentROE,0)) 
      when BM.BookingSource='ManualTicketing' then PB.Markup ELSE PB.HupAmount END),0))as decimal(18,2)) as MarkupOnTax   
	  , Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans   
	  , case when PM.payment_mode='passThrough' then 'CUSTOMER'         
	   when PM.payment_mode='Credit' then 'CORPORATE'         
	   Else 'CASH' end as UATP        
	  FROM tblBookMaster BM        
	  LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
	  LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id        
	  LEFT JOIN tblBookItenary BI ON BM.orderId = BI.orderId        
	  --LEFT JOIN tblBookItenary BI ON BM.pkId = BI.pkId        
	  LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID         
	  LEFT JOIN B2BRegistration B2BR ON BM.AgentID = B2BR.FKUserID        
	  LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country           
	  LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID           
	  Left Join PNRRetriveDetails PR on BM.orderId = PR.OrderID        
	  LEFT JOIN mUser U on BM.MainAgentId = U.ID           
	  LEFT JOIN tblOwnerCurrency CU on BM.OfficeID = CU.OfficeID         
	  LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode        
	  WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	  and BM.BookingStatus In (1,6) --As confirm with Mansavee        
	  -- For Booking        
	  and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)        
	  and BM.inserteddate > (Getdate()-2) --'2022-03-31 23:59:59.999'         
	  and BM.Country in('AE')        
	  and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country         
	  and AL.userTypeID IN(2) --For UAE usertype is 2 ***    
	  and ISNULL(PB.TicketNumber,'') != ''
	 -- AND PB.TicketNumber='3900017342'  
	 --and BM.riyaPNR ='I1P7S9'
	  and BM.VendorName Not in ('STS')
	  ORDER BY BM.inserteddate DESC
	 END        
    
	If @Action = 'UAECancellationTickets'
	Begin 
	SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, BM.bookingStatus,
	   --ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	   BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber,BM.IssueDate,        
	   BM.canceledDate,BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	   BM.arrivalTime, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else CU.IATA end as IATA,
	   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,BM.orderId,        
	   PB.pid, PB.title, PB.ticketNum, PB.pid, PB.basicFare, PB.totalTax, PB.paxType,        
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	        
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,        
	   PM.CardType, PM.CardNumber, PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
	   ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,
	   Case	When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast
			When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode
	   End As Icast,
	   '' as LocationCode, '' as BranchCode,'' as DivisionCode, PR.EmpCode,ATT.OBTCno,       
	   ERP.Canfees, ERP.ServiceFees, 
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   
	   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare
	   ERP.MarkuponPenalty, ERP.Narration,PB.CancellationPenalty  , 
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   AM.Ticketcode as airlinecode,SSR.SSR_Amount as 'extrabagAmount',        
	   AC.type 'AirLineType'        
	   FROM tblBookMaster BM        
	   LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id        
	   LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID        
	   LEFT JOIN mUser U on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID        
	   LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR ON BM.AgentID = BR.FKUserID        
	   Left Join PNRRetriveDetails PR on BM.orderId = PR.OrderID        
	   LEFT JOIN TBL_ERP_RefundProcess ERP ON ERP.PBID = PB.pid        
	   LEFT JOIN AirlineMaster AM ON AM.Airlinecode = BM.airCode        
	   LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode        
	   LEFT JOIN tblOwnerCurrency CU on BM.OfficeID = CU.OfficeID         
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
	   Left JOIN tblSSRDetails SSR on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1        
	   WHERE        
	   BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	   and PB.BookingStatus In(4,11) --As confirm with Mansavee         
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)           
	   and BM.inserteddate > '2022-03-31 23:59:59.999' 
	   and BM.Country in('AE')
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country     
	   and AL.userTypeID = 2
	   and ISNULL(PB.TicketNumber,'') != ''
	   --and BM.riyaPNR in ('40Z0YT','R11W92')
	   and BM.VendorName Not in ('STS')
	   ORDER BY BM.IssueDate DESC
	End

	IF @Action = 'US-CABookingtickets' 
	  BEGIN        
	   SELECT TOP 10000 PB.ticketnumber, ED.AgentCountry,ED.OwnerCountry, ED.ERPCountry, BM.MainAgentId        
	   ,U.EmployeeNo as UserName, BM.bookingStatus,        
	   --ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,         
	   case when PM.payment_mode='passThrough' then 'CUSTOMER'         
	   when PM.payment_mode='Credit' then 'CORPORATE'         
	   Else 'CASH' end as UATP,        
	   PB.pid,BM.pkId, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else TOC.IATA end as IATA,  ISNULL(BR.Icast, BR1.Icast) as 'Icast', BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime,        
	   BM.RegistrationNumber, BM.IssueDate,BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	   BM.arrivalTime, BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, BM.orderId,        
		PB.title, PB.TicketNumber, PB.basicFare + isnull(BM.AgentMarkup,0) as basicFare, PB.totalTax, PB.paxType, PB.JNTax as 'K3Tax',        
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	BM.AgentMarkup,        
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax, PB.RFTax, PB.WOTax,  PB.YMTax,     
	   PM.CardType, PM.CardNumber, PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
	   PB.ServiceFee as 'ServiceFees',
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	   --ISNULL(PB.B2bMarkup,0) +ISNULL(PB.BFC,0) as 'MarkupOnBaseFare' ,'' as MarkupOnTaxFare ,
	   '' as Narration,        
	   --BM.AgentROE as 'SalesExchangeRate',        
	   --BM.AgentCurrency as 'SalesCurrencyCode',        
	   PB.BaggageFare,        
	   --ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,        
	   '' as LocationCode, '' as BranchCode,'' as DivisionCode,        
	   ------ERP.Canfees, ERP.ServiceFees, ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare, ERP.MarkuponPenalty, ERP.Narration,        
	   AM.Ticketcode as airlinecode,        
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   BM.IssueBy as 'TicketinguserID',        
	   BM.BookedBy as 'BookinguserID',        
	   case when BM.VendorName='Amadeus' then '1A'         
	   when BM.VendorName='Galileo' then '1G'         
	   when BM.VendorName='Sabre' then '1S'         
	   Else BM.VendorName end as CRSCode,       
	   
	    --case when ED.AgentCountry='US' and BM.AgentCurrency = 'USD' then '0' 
	   --when ED.AgentCountry='CA' and BM.AgentCurrency = 'CAD' then '0' 
	   --else BM.AgentROE end as 'SalesCurrROE',
	   Case when ED.AgentCountry = ED.OwnerCountry then '0' else BM.AgentROE end as 'SalesCurrROE',
	   --BM.AgentCurrency as 'SalesCurr',    
	   --case when ED.AgentCountry='US' and BM.AgentCurrency = 'USD' then '' 
	   --when ED.AgentCountry='CA' and BM.AgentCurrency = 'CAD' then '' 
	   --else BM.AgentCurrency end as 'SalesCurr',
	   Case when ED.AgentCountry = ED.OwnerCountry then '' else BM.AgentCurrency end as 'SalesCurr',
	   
	   TOC.Currency as 'PurchaseCurr',        
	   BM.ROE as 'PurchaseCurrROE',        
	   PB.baggage        
	  ,SSR.SSR_Amount as 'extrabagAmount', ISNULL(PM.AuthCode,'') as CVV,--1055 attribute       
	cast((isnull((CASE WHEN BM.B2bFareType=2 or BM.B2bFareType=3 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) as MarkupOnTax_,        
	(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) +PB.BFC) as MarkupOnFare_        
	   ,AC.type 'AirLineType'
	   ,ISNULL(ATT.CostCenter,'') as _str1060, ISNULL(ATT.Traveltype,'')  as _str1061 ,ISNULL(ATT.EmpDimession,'')  as _str1028, ISNULL(ATT.Changedcostno,'')  as _str1025,
	   ISNULL(ATT.Travelduration,'')  as _str1054, ISNULL(ATT.TASreqno,'')  as _str1022, ISNULL(ATT.Companycodecc,'')  as _str1023, ISNULL(ATT.Projectcode,'') as _str1024
	   , Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans   
	   FROM tblBookMaster BM        
	   LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id        
	   LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID       LEFT JOIN mUser U on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID        
	   LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null        
	   LEFT JOIN B2BRegistration BR1 ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null        
	   LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode        
	   LEFT JOIN tblOwnerCurrency TOC ON TOC.OfficeID = BM.OfficeID        
	   LEFT JOIN AirlineMaster AM ON AM.Airlinecode = BM.airCode        
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
	   left join tblSSRDetails SSR on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1        
	   WHERE
	   BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	   and BM.BookingStatus IN(1,6)  --As confirm with Mansavee        
	   and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)           
	   and BM.inserteddate > (Getdate()-2) -- '2021-07-31 23:59:59.999'        
		and ED.AgentCountry in ('US','CA')--('IN','AE','US','CA')        
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country        
	   and AL.userTypeID in (2,5) --For US usertype is 2 and 5(RBT) ***           
	   and BM.VendorName Not in ('STS')
	   --and BM.riyaPNR = '109VGD'
	   ORDER BY BM.IssueDate DESC        
	  END        
         
	IF @Action = 'US-CACancellationtickets'        
	  BEGIN        
	   SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, BM.bookingStatus,
	   --ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	   BM.pkId, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,        
	   BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	   BM.arrivalTime, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else CU.IATA end as IATA, BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,BM.orderId,        
	   PB.pid, PB.title, PB.ticketNum, PB.pid, PB.basicFare, PB.totalTax, PB.paxType,       PB.YMTax,  
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,        
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,  PB.WOTax,      
	   PM.CardType, PM.CardNumber, PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
	   ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,        
	   Icast,'' as LocationCode, '' as BranchCode,'' as DivisionCode,        
	   ERP.Canfees, ERP.ServiceFees,
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	   ERP.MarkuponPenalty, ERP.Narration,         
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   AM.Ticketcode as airlinecode,        
	   AC.type 'AirLineType'        
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
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
	   LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode 
	   LEFT JOIN tblOwnerCurrency CU on BM.OfficeID = CU.OfficeID 
	   WHERE
	   BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	   and PB.BookingStatus IN(4,11) --As confirm with Mansavee        
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)           
	   and BM.inserteddate > '2020-12-31 23:59:59.999' and ED.AgentCountry in ('US','CA')        
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country       
	   and AL.userTypeID = 2 --For US CA usertype is 2 ***  
	   and BM.VendorName Not in ('STS')
	   --and PB.TicketNumber = '6024766875'
	   ORDER BY BM.IssueDate DESC        
	  END     
  
	IF @Action = 'US_CAD_MCO_Bookingtickets' 
	  BEGIN        
	   SELECT TOP 10000 --PB.TicketNumber,PB.ERPResponseID,PB.ERPPuststatus,PB.ERPMcoResponseID,PB.ERPMcoPushstatus,
	   Case When PB.MCOTicketNo like '%-%' 
					Then substring(stuff(PB.MCOTicketNo,1,4,''),1,10)
					Else substring(stuff(PB.MCOTicketNo,1,3,''),1,10)End As MCOTicketNo,
	   PB.MCOAmount,BM.MCOAmount,ED.AgentCountry,ED.OwnerCountry,ED.ERPCountry,BM.MainAgentId,U.UserName,BM.bookingStatus,
	   --ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	   Case	When PM.payment_mode='passThrough' then 'CUSTOMER'         
			When PM.payment_mode='Credit' then 'CORPORATE'         
			Else 'CASH' End As UATP,
	   PB.pid,BM.pkId, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else TOC.IATA end as IATA,ISNULL(BR.Icast,BR1.Icast) As 'Icast',BM.riyaPNR,BM.inserteddate,BM.CounterCloseTime,BM.RegistrationNumber,
	   BM.IssueDate,BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No, BM.IATACommission,BM.deptTime,BM.arrivalTime, BM.frmSector,BM.toSector,
	   BM.flightNo, BM.travClass,BM.AgentID, BM.Country, BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',
	   BM.VendorCommissionPercent, case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	   BM.orderId,PB.title, PB.paxType,PB.paxFName,PB.paxLName,
	   ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') 'PaxName',PB.basicFare + isnull(BM.AgentMarkup,0) 'basicFare',PB.totalTax,
	   BM.totalFare,PB.MCOAmount,
	   cast((Isnull(PB.MCOAmount,0)-Isnull(PB.MCOAmount,0)*3.5/100)as decimal(18,2)) as McoCommissionAmount,PB.managementfees,
	   PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,BM.AgentMarkup,PB.JNTax as 'K3Tax',PB.YRTax, PB.YQ, PB.INTax, PB.JNTax,PB.OCTax,
	   PB.ExtraTax,PB.RFTax,PM.CardType, PM.CardNumber, PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
	   PB.ServiceFee as 'ServiceFees', ISNULL(PB.B2bMarkup,0) +ISNULL(PB.BFC,0) as 'MarkupOnBaseFare' ,'' as MarkupOnTaxFare , '' as Narration,        
	   --BM.AgentROE as 'SalesExchangeRate',BM.AgentCurrency as 'SalesCurrencyCode',        
	   PB.BaggageFare,        
	   --ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,        
	   '' as LocationCode, '' as BranchCode,'' as DivisionCode,        
	   ------ERP.Canfees, ERP.ServiceFees, ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare, ERP.MarkuponPenalty, ERP.Narration,        
	   AM.Ticketcode as airlinecode,        
	   Case When BM.CounterCloseTime = 1 Then 'AIR-DOM' Else 'AIR-INT' End As productType,
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   BM.IssueBy as 'TicketinguserID',        
	   BM.BookedBy as 'BookinguserID',        
	   Case When BM.VendorName='Amadeus' Then '1A'         
			When BM.VendorName='Galileo' Then '1G'         
			When BM.VendorName='Sabre' Then '1S'         
			Else BM.VendorName End as CRSCode,        
	   BM.AgentROE as 'SalesCurrROE',        
	   BM.AgentCurrency as 'SalesCurr',        
	   TOC.Currency as 'PurchaseCurr',        
	   BM.ROE as 'PurchaseCurrROE',        
	   PB.baggage        
	   ,SSR.SSR_Amount as 'extrabagAmount',        
		cast((isnull((CASE WHEN BM.B2bFareType=2 or BM.B2bFareType=3 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) as MarkupOnTax_,        
		(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) +PB.BFC) as MarkupOnFare_        
	   ,AC.type 'AirLineType'         
	   FROM tblBookMaster BM        
		   LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
		   LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id        
		   LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID       LEFT JOIN mUser U on BM.MainAgentId = U.ID        
		   --LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID        
		   LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID        
		   LEFT JOIN B2BRegistration BR ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null        
		   LEFT JOIN B2BRegistration BR1 ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null        
		   LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode        
		   LEFT JOIN tblOwnerCurrency TOC ON TOC.OfficeID = BM.OfficeID        
		   LEFT JOIN AirlineMaster AM ON AM.Airlinecode = BM.airCode        
		   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
		   left join tblSSRDetails SSR on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1        
	   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'
		   and BM.BookingStatus IN(1,6)  --As confirm with Mansavee
		   and PB.ERPMcoResponseID is null and (PB.ERPMcoPushStatus = 0 or PB.ERPMcoPushStatus is null)           
		   and PB.MCOTicketNo is not null and PB.MCOTicketNo !=''
		   and BM.inserteddate > (Getdate()-2) -- '2021-07-31 23:59:59.999'        
		   and ED.AgentCountry in ('US','CA')--('IN','AE','US','CA')        
		   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country        
		   and AL.userTypeID = 2 --For US usertype is 2 ***   
		   and BM.VendorName Not in ('STS')
		   ORDER BY BM.IssueDate DESC
	END

	IF @Action = 'US_CAD_MCO_Cancellationtickets'        
	  BEGIN        
		SELECT TOP 10000 --PB.TicketNumber,PB.ERPResponseID,PB.ERPPuststatus,PB.CannERPMcoResponseID,PB.CannERPMcoPushstatus,
		Case When PB.MCOTicketNo like '%-%' 
					Then substring(stuff(PB.MCOTicketNo,1,4,''),1,10)
					Else substring(stuff(PB.MCOTicketNo,1,3,''),1,10)End As MCOTicketNo
		,U.UserName,BM.bookingStatus,
		--ED.VendorCode,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
		BM.pkId,PB.pid,BM.riyaPNR,BM.inserteddate,BM.CounterCloseTime, PB.IATACommission as CustIATACommAmount ,PB.PLBCommission,
		BM.RegistrationNumber,BM.IssueDate,BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,
		case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else CU.IATA end as IATA,
		BM.frmSector,BM.toSector,BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,        
		BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, 
		BM.orderId,PB.title,PB.basicFare,BM.totalFare,PB.totalTax,
		PB.MCOAmount,
		cast((Isnull(BM.MCOAmount,0)-Isnull(BM.MCOAmount,0)*3.5/100)as decimal(18,2)) as McoCommissionAmount,
		PB.paxType,PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,PB.managementfees,PB.baggage,
		case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,PM.CardType, PM.CardNumber,PM.mer_amount, PM.billing_address,
		PM.billing_name,PM.order_id, PM.tracking_id,        
		--BI.airlinePNR, BI.cabin, BI.farebasis,
		ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,Icast,'' as LocationCode, '' as BranchCode,'' as DivisionCode,
		ERP.Canfees, ERP.ServiceFees, 
		cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) when BM.BookingSource='ManualTicketing' then PB.Markup ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
		--ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
		ERP.MarkuponPenalty, ERP.Narration,
		Case When BM.CounterCloseTime = 1 Then 'AIR-DOM' Else 'AIR-INT' End As productType,
		'' as FormOfPayment,  -- Need to check with manasvee        
		--1 for domestic        
		AM.Ticketcode as airlinecode,        
		AC.type 'AirLineType'        
		From tblBookMaster BM        
			LEFT JOIN tblPassengerBookDetails PB ON BM.pkId = PB.fkBookMaster        
			LEFT JOIN Paymentmaster PM ON BM.orderId = PM.order_id        
			LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID        
			LEFT JOIN mUser U on BM.MainAgentId = U.ID        
			LEFT JOIN mAttrributesDetails ATT ON BM.orderId = ATT.OrderID        
			LEFT JOIN tblERPDetails ED ON BM.OfficeID = ED.OwnerID        
			LEFT JOIN B2BRegistration BR ON BM.AgentID = BR.FKUserID        
			LEFT JOIN TBL_ERP_RefundProcess ERP ON ERP.PBID = PB.pid        
			LEFT JOIN AirlineMaster AM ON AM.Airlinecode = BM.airCode        
			--LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
			LEFT JOIN AirlineCode_Console AC ON AC.Airlinecode = BM.airCode 
			LEFT JOIN tblOwnerCurrency CU on BM.OfficeID = CU.OfficeID 
		Where BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'
			And PB.BookingStatus IN(4,11) --As confirm with Mansavee
			And PB.CannERPMcoResponseID is null and (PB.CannERPMcoPushStatus = 0 or PB.CannERPMcoPushStatus is null)
			and PB.MCOTicketNo is not null and PB.MCOTicketNo !=''
			And BM.inserteddate > '2020-12-31 23:59:59.999' and ED.AgentCountry in ('US','CA')
			And ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country
			And AL.userTypeID = 2 --For US CA usertype is 2 ***  
			and BM.VendorName Not in ('STS')
			And PB.MCOTicketNo is not null
			ORDER BY BM.IssueDate DESC
	  END 

	IF @Action = 'GetItenary'        
	  BEGIN        
	   Select IT.*,(IT.deptTime),substring(CONVERT(VARCHAR, IT.deptTime, 108),0,6) as Dtime,IT.airlinePNR, AM.Ticketcode as AirlineCode, '' as class         
	   from tblBookItenary IT        
	   LEFT JOIN AirlineMaster AM ON AM.Airlinecode = IT.airCode        
	   where IT.orderId = @orderId        
	  END        

	IF @Action = 'Search'        
	  BEGIN        
	   --Declare @BMID bigint;        
	   SET @BMID = ( Select fkBookMaster  from tblPassengerBookDetails where TicketNumber = @Ticketnumber)        
        
	   Select (Isnull(paxFName,'') +' '+ Isnull(paxLName,'')) as passengerName, paxType as PassengerType  from tblPassengerBookDetails where fkBookMaster = @BMID        
        
	   Select BR.Icast as 'CustomerNumber'  from B2BRegistration BR LEFT JOIN tblBookMaster BM ON BM.AgentID = BR.FKUserID where BM.AgentID != 'B2C' and BM.pkId =@BMID        
        
	   Select PB.pid, PB.TicketNumber, BM.airCode as airlineCode, BM.IssueDate, BM.IATA as IATA_Number, BM.GDSPNR, BM.TourCode, '' as FormOfPayment, BM.pkId as Id ,        
	   '' as CommissionRate,         
	   PB.pid as 'PBid', BM.pkId as 'BMid', ISNULL(PB.IsCreditNoteGen, 0) as IsCreditNoteGen, ISNULL( PB.CancERPPuststatus, 0) as CancERPPuststatus        
	   from tblPassengerBookDetails PB         
	   LEFT JOIN tblBookMaster BM ON BM.pkId = PB.fkBookMaster          
	   where PB.fkBookMaster = @BMID        
	   Select BI.*, AM.TicketCode as Airlinenumber, BM.IssueDate, BM.basicFare, BM.totalTax, BM.totalFare, PB.CancellationPenalty, 'FIRST'+PB.DiscriptionTax as Taxdesc,        
	   ERP.Canfees, ERP.ServiceFees, ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare, ERP.MarkuponPenalty, ERP.Narration         
	   from tblBookItenary BI        
	   LEFT JOIN AirlineMaster AM ON BI.airCode = AM.Airlinecode        
	   LEFT JOIN tblBookMaster BM ON BM.orderId = BI.orderId        
	   LEFT JOIN tblPassengerBookDetails PB ON PB.fkBookMaster = BM.pkId        
	   LEFT JOIN TBL_ERP_RefundProcess ERP ON ERP.PBID = PB.pid        
	   where BI.orderId = (Select top 1 orderId from tblBookMaster where pkId =  @BMID)           
	  END        
        
	IF @Action = 'InsertmarkupRefundProcess'        
	  BEGIN        
	   IF NOT EXISTS(Select 1 from TBL_ERP_RefundProcess where PBID = @PBID)        
		BEGIN        
		 Declare @result varchar(50);        
		 INSERT INTO TBL_ERP_RefundProcess         
		 (BMID, PBID, CustomerNumber, TicketNumber, Canfees, ServiceFees, MarkupOnBaseFare, MarkupOnTaxFare, MarkuponPenalty,Narration, [User], CreatedDate, Flag)        
		 Values        
		 (@BMID, @PBID, @CustomerNumber, @Ticketnumber, @Canfees, @ServiceFees, @MarkupOnBaseFare, @MarkupOnTaxFare, @MarkuponPenalty, @Narration, @empcode, getdate(), 'Pending')        
		 SET @result = (Select @@IDENTITY)        
        
		 Update tblPassengerBookDetails SET IsCreditNoteGen = 1 where pid = @PBID        
		 Select @result;        
		END        
	  END         
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_ERP_Activity_BPK] TO [rt_read]
    AS [dbo];

