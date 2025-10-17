-- =============================================        
-- Author:  Pranay kini        
-- Create date: 4 May 2021        
-- Description: ERP Activity
-- =============================================
--[USP_ERP_Activity] 'Search','','WGZVFE-1',''
Create PROCEDURE [dbo].[USP_ERP_Activity_29-10-2024] --'CABookingtickets','','WGZVFE-1',''
@Action varchar(50)=null,
 @orderId varchar(100) =null,
 @tblPassengerid varchar(100) = null,
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
	 --    (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
		PB.CancelledDate as PostingDate,
	  case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, 
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else CU.Currency end as 'PurchaseCurr',
	   case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	   case when AC.type = 'FSC' then BM.GDSPNR else BI.airlinePNR end as PNRNo,
	    case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
		when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10 and BM.Country = 'IN' then 'VEND000178'
		when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10 and BM.Country = 'AE' then 'VEND00102'
		when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10 and BM.Country = 'US' then 'UVEND00066'
		when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10 and BM.Country = 'CA' then 'CVEND00041'
		else ED.VendorCode end as VendorCode,
		   BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,BBM.TotalCommission as Surcharge,
		   BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
		   BM.arrivalTime, PB.FMCommission,BM.ROE as 'PurchaseCurrROE',
		   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
		   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
		   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
		   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
		   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, 
		   BM.orderId, PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
		   PB.pid, PB.title, PB.ticketNum, PB.pid, PB.basicFare + isnull(PB.LonServiceFee,0) as basicFare, PB.totalTax, PB.paxType,        
		   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
		   PB.managementfees, PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,		         
		   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,  PB.JNTax as 'K3Tax',PB.YMTax,
		   PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
		   --BI.airlinePNR, BI.cabin, BI.farebasis,        
		   Replace(ATT.VesselName,'&','and') as 'VesselName', ATT.TR_POName,REPLACE( ATT.Bookedby,'<','') as Bookedby, ATT.AType, ATT.RankNo,ATT.Traveltype,ATT.Department,ATT.EmpDimession,ATT.Location,BM.FareType,  
		   Case	When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast
				When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode
				When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode
		   End As Icast,
		   BR.LocationCode, '' as BranchCode,'' as DivisionCode,   
			cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
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
	   FROM tblBookMaster BM WITH (NOLOCK)
	   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
	   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID        
	   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid        
	   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID        
	   LEFT JOIN TBL_ERP_RefundProcess ERP WITH (NOLOCK) ON ERP.PBID = PB.pid        
	   LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
	   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID         
	   LEFT JOIN tblBookItenary BI WITH (NOLOCK) ON BM.pkId = BI.fkBookMaster
	   Left JOIN tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1  
	   --left join tblSSRDetails SSR1 on ssr.fkPassengerid=PB.pid and SSR1.SSR_Type='Meal' and SSR1.SSR_Status=1   
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber and CD.UserType = 'Marine'
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and PB.BookingStatus In(4,11) --As confirm with Mansavee
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)
	   and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'        
	   and BM.Country in ('IN','AE')
	   and BM.totalFare > 0
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country     
	   and AL.userTypeID = 3 --For Marine usertype is 3 ***  
	   and BM.VendorName Not in ('STS')
	   --and BM.riyaPNR='244SH3'
	   ORDER BY BM.IssueDate DESC
	  END
    
	IF @Action = 'MarineBookingtickets'        
	  BEGIN
	   SELECT TOP 10000 PB.ticketnumber, ED.AgentCountry,ED.OwnerCountry, ED.ERPCountry, BM.MainAgentId        
	  ,U.EmployeeNo as UserName, BM.bookingStatus, 
	  case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	  '0' as 'Canfees',
	  isnull(BM.IssueDate, BM.inserteddate) as PostingDate,
	  case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	  ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	  case when AC.type = 'FSC' then BM.GDSPNR else BI.airlinePNR end as PNRNo,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,
	  --case when PM.payment_mode='passThrough' then 'CUSTOMER'         
	  --when PM.payment_mode='Credit' then 'CORPORATE'         
	  --Else 'CASH' end as UATP,        
	  PB.pid,BM.pkId, BBM.TotalCommission as Surcharge,
	 --   (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	  case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, 
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else TOC.IATA end as IATA,
	  BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,        
	  BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	  BM.arrivalTime, BM.frmSector, BM.toSector, BM.flightNo, BM.travClass, PB.FMCommission,
	  BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,
	  BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	  BM.orderId,
	  PB.title, PB.ticketNum, PB.pid, PB.basicFare + isnull(PB.[LonServiceFee],0) as basicFare, PB.totalTax, PB.paxType,
	  PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,
	  PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	
	  PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax, PB.RFTax, PB.JNTax as 'K3Tax',
	  --Added By Rahul as per ranjit discussion        
	  PB.WOTax,PB.YMTax,PB.OBTax,        
	  --End        
	  PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	  --BI.airlinePNR, BI.cabin, BI.farebasis,        
	  PB.ServiceFee as 'ServiceFees',
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
	  (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
	  '' as Narration,        
	  --BM.AgentROE as 'SalesExchangeRate',        
	  --BM.AgentCurrency as 'SalesCurrencyCode',        
	  PB.BaggageFare,        
	  --Added By Rahul Agrahari.
	  Replace(ATT.VesselName,'&','and') as 'VesselName', ATT.TR_POName, Replace(ATT.Bookedby,'<','') as Bookedby, ATT.ReasonofTravel 'Traveltype',ATT.AType ,PB.Profession 'RankNo', 
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
	  case when BM.VendorName='Amadeus' then '1A'         
	   when BM.VendorName='Galileo' then '1G'         
	   when BM.VendorName='Sabre' then '1S'
	   when BM.VendorName='TravelFusion' then 'TF'
	   when BM.VendorName='TravelFusionNDC' then 'TFNDC'
	   Else '' end as CRSCode,         
	  BM.AgentROE as 'SalesCurrROE', BM.AgentCurrency as 'SalesCurr', case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else TOC.Currency end as 'PurchaseCurr', BM.ROE as 'PurchaseCurrROE', PB.baggage,
	  SSR.SSR_Amount as 'extrabagAmount',
	  --SSR1.SSR_Amount as 'Meal Charges',
	 (select isnull(sum(SSRMeal.SSR_Amount),0) from tblSSRDetails SSRMeal where 
		SSRMeal.fkPassengerid=PB.pid and SSRMeal.fkBookMaster=pb.fkbookmaster and SSRMeal.SSR_Type='Meals' and SSRMeal.SSR_Status=1 and SSRMeal.SSR_Amount>0
		group by SSRMeal.fkPassengerid)
		 as [Meal Charges],
	  case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType', Case when ED.AgentCountry = ED.OwnerCountry and bm.AgentROE = 1  then '0' else '1' end as Intcompanytrans
	  FROM tblBookMaster BM WITH (NOLOCK)
		LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
		LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
		LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID        
		LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID        
		LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
		LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
		LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID        
		LEFT JOIN tblOwnerCurrency TOC WITH (NOLOCK) ON TOC.OfficeID = BM.OfficeId  --and Toc.Currency in (Select top 1 Currencycode from mCountryCurrency as mc  where mc.CountryCode= BM.country)--=BM.AgentCurrency --and TOC.UserType=AL.userTypeID
		LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode and AM.Status='A'    
		LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode
		left join tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1 and SSR.SSR_Amount > 0
	--left join tblSSRDetails SSR1 on ssr.fkPassengerid=PB.pid and SSR1.SSR_Type='Meal' and SSR1.SSR_Status=1   
	    LEFT JOIN tblBookItenary BI WITH (NOLOCK) ON BM.pkId = BI.fkBookMaster
		LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber and CD.UserType = 'Marine'
		LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	  WHERE  
	  BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'  --and BM.riyaPNR = '1D3S01'        
		--and BM.BookingStatus IN(1,6)   --As confirm with Mansavee     
		and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
		and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)        
		and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'        
		and ED.AgentCountry in ('IN') --('US','CA') --
		and BM.totalFare > 0
		and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country
		and AL.userTypeID = 3 --For Marine usertype is 3 ***
		and BM.VendorName Not in ('STS')
		ORDER BY BM.IssueDate DESC
	  END        
    	
	IF @Action = 'B2CCancellationtickets'        
	  BEGIN        
	   SELECT TOP 10000 PB.ticketnumber, U.UserName, BM.bookingStatus,        
	   --ED.VendorCode,
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	   BBM.TotalCommission as Surcharge,
	   case when AC.type = 'FSC' then BM.GDSPNR else BI.airlinePNR end as PNRNo,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,
	   BM.pkId, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,        
	   BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	   BM.arrivalTime, ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,
	   PB.CancelledDate as PostingDate,
	   case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	 --   (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,  
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else BM.IATA end as IATA,
	   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	   BM.orderId,      PB.FMCommission,  
	   PB.pid, PB.title, PB.ticketNum,PB.basicFare + isnull(PB.LonServiceFee,0) as basicFare, PB.totalTax, PB.paxType,        
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	     
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,PB.CancellationCharge,PB.CancellationPenalty, 
	   PB.WOTax, PB.YMTax, PB.JNTax as 'K3Tax',    
	   --case when PM.payment_mode='passThrough' then 'CUSTOMER'         
	   --when PM.payment_mode='Credit' then 'CORPORATE'         
	   --Else 'CASH' end as UATP,
	   PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	   --BI.airlinePNR, BI.cabin, BI.farebasis,
	   ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,
	   Icast='ICUST35086',BR.LocationCode, '' as BranchCode,'' as DivisionCode,        
	   ERP.Canfees, ERP.ServiceFees, 
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
	   ERP.MarkuponPenalty, ERP.Narration,         
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   AM.Ticketcode as airlinecode,        
	   --AC.type 'AirLineType' 
	   case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'
	   FROM tblBookMaster BM WITH (NOLOCK)        
	   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
	   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID        
	   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = cast(BR.FKUserID AS varchar)       
	   LEFT JOIN TBL_ERP_RefundProcess ERP WITH (NOLOCK) ON ERP.PBID = PB.pid        
	   LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
	   LEFT JOIN tblBookItenary BI WITH (NOLOCK) ON BM.pkId = BI.fkBookMaster     
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   WHERE        
	   BM.IsBooked =1 and BM.totalFare > 0
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and cast(BM.AgentID as varchar(50))= 'B2C'
	   --and BM.BookingStatus In(4,11) --As confirm with Mansavee        
	   and PB.Iscancelled In(1) --As confirm with Mansavee        
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)        
	   and BM.inserteddate > (Getdate()-360) 
	   and BM.Country in('IN')    
	   and BM.totalFare > 0
		--and BM.VendorName Not in ('STS')
		and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country        
		--and AL.userTypeID = 1 --For B2C usertype is not required ***  By Defa	   
		--and BM.riyaPNR ='T2UM22'
	   ORDER BY BM.IssueDate DESC 
	  END

	IF @Action = 'B2CBookingtickets'        
	  BEGIN        
	   SELECT TOP 10000 U.UserName,PB.pid,BM.pkId,
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   case when AC.type = 'FSC' then BM.GDSPNR else BI.airlinePNR end as PNRNo,
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,PD.Commission,Isnull(PD.PLBAmount,0) + Isnull(PD.Discount,0) as 'PLBAmount',PD.Incentive,
	   BM.VendorName,ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, isnull(PB.IATACommission,0) as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	   BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime,
	   case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	   PB.FMCommission, isnull(BM.IssueDate, BM.inserteddate) as PostingDate,
	   BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,        
	   BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',        
	   BM.VendorCommissionPercent,PB.FMCommission,BBM.TotalCommission as Surcharge,
	 --    (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, 
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
	   BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.basicFare + isnull(PB.LonServiceFee,0) as basicFare,PB.totalTax,PB.paxType,   PB.YMTax,     
	   PB.paxFName,PB.paxLName,PB.managementfees,PB.baggage,        
	   case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax,PB.YQ,PB.INTax,PB.JNTax,PB.OCTax,PB.ExtraTax,PM.CardType,PM.MaskCardNumber as 'CardNumber',PM.mer_amount,PM.billing_address,        
	   PM.billing_name,PM.order_id,BM.orderid,PM.bank_ref_no as 'tracking_id',BI.airlinePNR,BI.cabin,BI.farebasis,ATT.VesselName,ATT.TR_POName,ATT.Bookedby,ATT.AType        
	   ,ATT.RankNo,Icast = 'VIKCUST017015A', BR.LocationCode, BranchCode = '', PR.EmpCode,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare 
	   FROM tblBookMaster BM WITH (NOLOCK)        
		LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster 
		LEFT JOIN tblPassengerFareDetails PD with (NOLOCK) ON PB.pid = PD.paxid
		LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
		LEFT JOIN tblBookItenary BI WITH (NOLOCK) ON BM.pkId = BI.fkBookMaster        
		LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
		LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country         
		--LEFT JOIN agentLogin AL ON  AL.UserID = BM.AgentID  
		LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = cast(BR.FKUserID AS varchar)  
		Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID        
		LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID           
		LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID         
		LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
		LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
		LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
		WHERE BM.IsBooked =1 and BM.totalFare > 0         
		and cast(BM.AgentID as varchar(50))= 'B2C'
		and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
		--and BM.BookingStatus In (1,6) --As confirm with Mansavee           '0'  Means Trns Failed
		and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)        
		and BM.inserteddate > (Getdate()-31)
		and BM.Country in('IN')        
		and BM.totalFare > 0
		--and BM.VendorName Not in ('STS')
		and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country        
		--and AL.userTypeID = 3 --For B2C usertype is not required ***  By Default 1    
		--and bm.riyaPNR='F2H005'
		--and BM.GDSPNR  in ('1DA11V')
		ORDER BY BM.IssueDate DESC
	  END        
    
	IF @Action = 'B2BCancellationTickets'        
	  BEGIN        
	   SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, BM.bookingStatus,
	   --ED.VendorCode,
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   case when BM.VendorName='TravelFusion' then 'IN' else ED.OwnerCountry END AS OwnerCountry,
	   PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission, PB.CancelledDate as PostingDate,
	   case when AC.type = 'FSC' then BM.GDSPNR else BI.airlinePNR end as PNRNo,
	   case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP, PB.FMCommission, 
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,
	   BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber,BM.IssueDate,        
	   BM.canceledDate,BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime, BM.arrivalTime, 
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
	   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.FMCommission,
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, BM.orderId,        
	   PB.pid, PB.title, PB.ticketNum, PB.pid, PB.basicFare + isnull(PB.LonServiceFee,0) as basicFare , PB.totalTax, PB.paxType, BBM.TotalCommission as Surcharge, 
	 --    (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,  
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	        
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,   PB.YMTax,     
	   PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
	   ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,
	   case when Attsp.FKUserID is not null then 
	case when ED.OwnerCountry = 'US' then 'UCUST00505' 
	when ED.OwnerCountry = 'CA' then 'CCUST00004' when ED.OwnerCountry = 'AE' then 'CUST000324' 
	else 
	Case	When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast
			When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode	  
	 end
	end
	when Attsp.FKUserID is null then 
	Case	When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast
			When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode	  
	 end
	else BR.Icast end as 'Icast',Attsp.FKUserID as AttFKUserID,
	   BR.LocationCode, '' as BranchCode,'' as DivisionCode, PR.EmpCode,ATT.OBTCno,       
	   ERP.Canfees, ERP.ServiceFees, 
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   
	   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare
	   ERP.MarkuponPenalty,Replace(ERP.Narration,'&','and') as Narration,PB.CancellationPenalty  , 
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   AM.Ticketcode as airlinecode,SSR.SSR_Amount as 'extrabagAmount',        
	   --AC.type 'AirLineType'   
	   case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'
	   FROM tblBookMaster BM WITH (NOLOCK)
	   LEFT JOIN tblPassengerBookDetails PB  WITH (NOLOCK)ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM  WITH (NOLOCK)ON BM.orderId = PM.order_id        
	   LEFT JOIN agentLogin AL  WITH (NOLOCK)ON  AL.UserID = BM.AgentID    
	   LEFT JOIN AttributeSpValidation Attsp WITH (NOLOCK) ON BM.AgentID = Attsp.FKUserID and Attsp.isActive = 1
	   LEFT JOIN mUser U  WITH (NOLOCK)on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT  WITH (NOLOCK)ON PB.pid = ATT.fkPassengerid
	   LEFT JOIN tblERPDetails ED  WITH (NOLOCK)ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID        
	   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID        
	   LEFT JOIN TBL_ERP_RefundProcess ERP WITH (NOLOCK) ON ERP.PBID = PB.pid        
	   LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
	   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID         
	   LEFT JOIN tblBookItenary BI WITH (NOLOCK) ON BM.pkId = BI.fkBookMaster       
	   Left JOIN tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1    
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   WHERE        
	   BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'     
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and PB.BookingStatus In(4,11) --As confirm with Mansavee         
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)           
	   and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'
	   and BM.Country in ('IN')
	   and BM.AgentID not in (48210)
	   and BM.totalFare > 0
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country     
	   and AL.userTypeID = 2
	   and BM.VendorName Not in ('STS')
	   ORDER BY BM.canceledDate DESC
	  END        

	IF @Action = 'B2BBookingTickets'        
	  BEGIN        
		SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, ED.AgentCountry, 
		case when BM.VendorName='TravelFusion' then 'IN' else ED.OwnerCountry END AS OwnerCountry,PB.pid,
	  --ED.VendorCode,
	  case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,BM.GDSPNR,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	  ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission, BBM.TotalCommission as Surcharge,
	  --case when AC.type = 'FSC' then BM.GDSPNR else BI.airlinePNR end as PNRNo,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,PM.payment_mode,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,ED.OwnerID,
	  BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime, isnull(BM.IssueDate, BM.inserteddate) as PostingDate,
	  case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP, PB.FMCommission, 
	  BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,        
	  BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',        
	  BM.VendorCommissionPercent,PB.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
	 --   (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	    case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, 
	  --Cu.Currency,
	   --case when PM.payment_mode='passThrough' then 'CUSTOMER'         
	   --when PM.payment_mode='Credit' then 'CORPORATE'         
	   --Else 'CASH' end as UATP,
	  case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end as 'Currency'
	  ,BM.ROE,        
	  BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.pid,PB.basicFare + isnull(PB.LonServiceFee,0) as basicFare,PB.totalTax,PB.paxType,PB.paxFName,PB.paxLName,        
	  PB.managementfees,left(PB.baggage,29) as baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax,PB.YQ,PB.INTax,PB.JNTax,PB.OCTax,PB.ExtraTax,PB.WOTax,PB.BaggageFare,PM.CardType,        
	  PM.MaskCardNumber as 'CardNumber',PM.mer_amount,PM.billing_address,PM.billing_name,BM.orderId order_id,PM.tracking_id,--BI.airlinePNR,BI.cabin,BI.farebasis,	  
	  PB.YMTax,ATT.VesselName, REPLACE(ATT.TR_POName, '&', 'and') as TR_POName,ATT.Bookedby,ATT.AType,ATT.RankNo,
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	  case when Attsp.FKUserID is not null then 
	case when ED.OwnerCountry = 'US' then 'UCUST00505' 
	when ED.OwnerCountry = 'CA' then 'CCUST00004' when ED.OwnerCountry = 'AE' then 'CUST000324' 
	else 
	Case	When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode	  
	 end
	end
	when Attsp.FKUserID is null then 
	Case	When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode	  
	 end
	else B2BR.Icast end as 'Icast',Attsp.FKUserID as AttFKUserID,
	  B2BR.LocationCode, BranchCode = '', PR.EmpCode,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',ATT.OBTCno
	    ,BM.AgentROE as 'SalesCurrROE',        
	   BM.AgentCurrency as 'SalesCurr',        
	   case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else CU.Currency end as 'PurchaseCurr',        
	   BM.ROE as 'PurchaseCurrROE'
	   ,Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans
	  FROM tblBookMaster BM WITH (NOLOCK)        
	  LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	  LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id          
	  --LEFT JOIN tblBookItenary BI ON BM.pkId = BI.fkBookMaster  
	  LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	  LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID
	  LEFT JOIN AttributeSpValidation Attsp WITH (NOLOCK) ON BM.AgentID = Attsp.FKUserID and isActive = 1
	  LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country        
	  LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID           
	  Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID        
	  LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID           
	  LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID         
	  LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode  
	  LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	  LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	  WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'    
	  and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	  and BM.BookingStatus In(1,6) --As confirm with Mansavee        
	  -- For Booking        
	  and ISNULL(BM.ERPPush,0) = 0
	  and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)        
	  and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'        
	  and BM.Country in('IN') 
	  and ISNULL(PB.ticketnumber,'') != ''
	  and BM.AgentID not in (48210)
	  and BM.totalFare > 0
	  and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country         
	  and AL.userTypeID IN(2) --For B2B usertype is 2 ***
	  --and BM.riyaPNR = '4V36I1'
	  and BM.VendorName Not in ('STS')
	  ORDER BY BM.inserteddate DESC        
	  END  

	IF @Action = 'RBTBookingTickets'        
	  BEGIN        
	  SELECT TOP 10000 U.EmployeeNo as UserName,
	  --ED.VendorCode,
	  case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,BM.AgentCurrency as 'SalesCurr',PM.BankAccountNo,PM.bank_ref_no as TransactionNo,PM.MerchantId 'PaymentGateway',
	  ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,BBM.TotalCommission as Surcharge, isnull(BM.IssueDate, BM.inserteddate) as PostingDate,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,'' as DivisionCode,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	 --   (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	  case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, 
	  BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime, PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	  BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,        
	  BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',        
	  BM.VendorCommissionPercent,PB.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,PB.FMCommission,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,PM.payment_mode,
	  case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end as 'Currency',BM.ROE,        
	  BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.pid,PB.basicFare + isnull(pb.LonServiceFee,0) as basicFare ,PB.totalTax,PB.paxType,PB.paxFName,PB.paxLName,        
	  PB.managementfees,substring(replace(PB.baggage,'&','and'),0,30) as baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax,PB.YQ,PB.INTax,PB.JNTax, PB.YMTax,
	  PB.WOTax,PB.OCTax,PB.ExtraTax,PB.BaggageFare,PM.CardType,
	  case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	  PB.FMCommission,  
	  PM.MaskCardNumber as 'CardNumber',PM.mer_amount,PM.billing_address,PM.billing_name,PM.order_id,PM.tracking_id,--BI.airlinePNR,BI.cabin,BI.farebasis,        
	  ATT.VesselName,ATT.TR_POName,ATT.Bookedby,ATT.AType,ATT.RankNo,        	       
	  Case	When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode
	  End As Icast,
	  B2BR.LocationCode, BranchCode = '', PR.EmpCode,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',ATT.OBTCno,
	  --Added By Rahul A
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	  ATT.CostCenter,ATT.TravelerType,ATT.Changedcostno,ATT.Travelduration,ATT.TASreqno,ATT.Companycodecc,ATT.Projectcode
	  ,case when AL.UserID = 47129 then ISNULL(ATT.UID,'') else ISNULL(ATT.CostCenter,'') end as _str1060, 
	  case when AL.UserID = 47129 then ISNULL(ATT.PID,'') else  ISNULL(ATT.EmpDimession,'') end  as _str1028, 
	  case when AL.UserID = 47129 then ISNULL(replace(ATT.Account,'&','and'),'') else ISNULL(replace(ATT.Travelduration,'&','and'),'') end as _str1054,
	  case when AL.UserID = 47129 then ISNULL(ATT.UID,'') else ISNULL(ATT.Traveltype,'') end as _str1061 ,
	  case when AL.UserID = 47129 then ISNULL(ATT.TravelerType,'') else ISNULL(ATT.Changedcostno,'') end as _str1025,
	   ISNULL(ATT.TASreqno,'')  as _str1022, ISNULL(ATT.Companycodecc,'')  as _str1023, ISNULL(ATT.Projectcode,'') as _str1024,
	   Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans
	  FROM tblBookMaster BM WITH (NOLOCK)        
	  LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	  LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id          
	  --LEFT JOIN tblBookItenary BI ON BM.pkId = BI.fkBookMaster        
	  LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	  LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID        
	  LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country        
	  LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID           
	  Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID        
	  LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID           
	  LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID         
	  LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode  
	  LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	  LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	  WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	  and BM.BookingStatus In(1,6) --As confirm with Mansavee      
	  and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	  -- For Booking        
	  and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)        
	  and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'        
	  and BM.Country in('IN')
	  and BM.totalFare > 0
	  and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country         
	  and AL.userTypeID IN(5) --For B2B usertype is 2 ***    
	  and BM.VendorName Not in ('STS') 
	  --and BM.riyaPNR = '8SKV18'
	  ORDER BY BM.inserteddate DESC        
	END  
	 
	IF @Action = 'RBTCancellationTickets'        
	  BEGIN        
	   SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, BM.bookingStatus,
	   --ED.VendorCode,
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission, '0' as Surcharge,
	  case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,
	   BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,        
	   BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	   BM.arrivalTime, case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	   PB.FMCommission,  PB.FMCommission, PB.CancelledDate as PostingDate,
	 --    (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,  
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
	   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, 
	   BM.orderId,        
	   PB.pid, PB.title, PB.ticketNum, PB.pid, PB.basicFare + isnull(PB.LonServiceFee,0) as basicFare, PB.totalTax, PB.paxType,        
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,         PB.YMTax,
	   PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
	   ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,
	   Case	When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast
			When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode
	   End As Icast,
	   BR.LocationCode, '' as BranchCode,'' as DivisionCode, PR.EmpCode,ATT.OBTCno,       
	   ERP.Canfees, ERP.ServiceFees, 
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	   ERP.MarkuponPenalty, ERP.Narration,         
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   AM.Ticketcode as airlinecode,SSR.SSR_Amount as 'extrabagAmount',        
	   --AC.type 'AirLineType'      
	   case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'
	   FROM tblBookMaster BM WITH (NOLOCK)        
	   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
	   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID        
	   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID        
	   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID        
	   LEFT JOIN TBL_ERP_RefundProcess ERP WITH (NOLOCK) ON ERP.PBID = PB.pid        
	   LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
	   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID         
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
	   Left JOIN tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1    
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   WHERE        
	   BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and PB.BookingStatus In(4,11) --As confirm with Mansavee         
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)           
	   and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'        
	   and BM.Country in ('IN')
	   and BM.totalFare > 0
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country     
	   and AL.userTypeID = 5
	   and BM.VendorName Not in ('STS')
	   ORDER BY BM.IssueDate DESC
	END        

	IF @Action = 'RBT-US-CABookingTickets'        
	  BEGIN        
		SELECT TOP 10000 PB.TicketNumber, BM.riyaPNR, ED.AgentCountry,ED.OwnerCountry, ED.ERPCountry, 
		BM.AgentID, BM.MainAgentId, PB.pid,BM.pkId, '' as UserName, BM.bookingStatus,
		ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, 
		Case When BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10 and ED.AgentCountry = 'US' Then 'UVEND00082'
		when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'GB' Then 'VEND00008' 
		when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'CA' Then 'BOMVEND007913'
		when BM.OfficeID = '00FK' and ED.AgentCountry = 'US' Then 'UVEND01206'
		Else ED.VendorCode End as VendorCode,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
		isnull(BM.IssueDate, BM.inserteddate) as PostingDate,
		PM.payment_mode,PM.MerchantId 'PaymentGateway',PM.BankAccountNo,--Rahul A.
		PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission, 
		PB.FMCommission,BBM.TotalCommission as Surcharge,BM.IATACommission, BM.VendorCommissionPercent,
		case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,
		Case When CD.Configuration = 'RiyaCard' THEN 'CORPORATE' 
			When CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' 
			When PM.payment_mode = 'passThrough' THEN 'CUSTOMER'
			Else '' 
		END as UATP,
		--  (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
		case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else TOC.IATA end as IATA,
		ISNULL(BR.Icast, BR1.Icast) as 'Icast', BM.CounterCloseTime, BM.RegistrationNumber,
		BM.inserteddate, BM.IssueDate,BM.depDate, BM.arrivalDate, BM.deptTime, BM.arrivalTime, BM.frmSector, BM.toSector, BM.fromTerminal, BM.toTerminal, BM.flightNo, BM.travClass,
		BM.airCode, BM.Country, BM.equipment,  BM.Vendor_No, BM.orderId,
		Case When AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',--chec
		Case When BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, BM.TotalDiscount, BM.totalFare,
		PB.basicFare + isnull(PB.Markup,0) + isnull(PB.LonServiceFee,0) as basicFare, PB.totalTax, PB.JNTax as 'K3Tax', PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax, PB.RFTax, PB.WOTax,  PB.YMTax,
		PB.paxType, PB.title, PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName, 
		Case When BM.BookingSource!='ManualTicketing' Then PB.Markup Else 0 End as Markup, BM.AgentMarkup,
		PM.MaskCardNumber as 'CardNumber', PM.CardType, PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,
		--BI.airlinePNR, BI.cabin, BI.farebasis,
		PB.ServiceFee as 'ServiceFees', 
		substring(replace(PB.baggage,'&','and'),0,29) as baggage, PB.BaggageFare,
		--cast(((SSR.SSR_Amount ) /BM.ROE)as decimal(18,2)) as 'extrabagAmount',
		SSR.SSR_Amount as extrabagAmount,
		SSR1.SSR_Amount as MealCharges, SSR2.SSR_Amount as SeatPreferenceCharge, Case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,
		cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
		(Cast((IsNull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		'' as Narration,
		--ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,
		BR.LocationCode, '' as BranchCode,'' as DivisionCode,        
		AM.Ticketcode as airlinecode,        
		Case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
		'' as FormOfPayment,  -- Need to check with manasvee        
		--1 for domestic
		BM.IssueBy as 'TicketinguserID',        
		BM.BookedBy as 'BookinguserID',        
		case when BM.VendorName='Amadeus' then '1A'         
	    when BM.VendorName='Galileo' then '1G'         
	    when BM.VendorName='Sabre' then '1S'
	    when BM.VendorName='TravelFusion' then 'TF'
	    when BM.VendorName='TravelFusionNDC' then 'TFNDC'
	    Else BM.VendorName end as CRSCode, 
		Case when ED.AgentCountry = ED.OwnerCountry then '0' else BM.AgentROE end as 'SalesCurrROE',
		Case when ED.AgentCountry != ED.OwnerCountry and ED.OwnerCountry != ED.ERPCountry and ED.AgentCountry != ED.ERPCountry then BM.AgentCurrency else '' end as 'SalesCurr',
		case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else TOC.Currency end as 'PurchaseCurr',        
		BM.ROE as 'PurchaseCurrROE',        
		cast((isnull((CASE WHEN BM.B2bFareType=2 or BM.B2bFareType=3 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) as MarkupOnTax_,        
		(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) +PB.BFC) as MarkupOnFare_        
		,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType', ISNULL(PM.AuthCode,'') as CVV,--1055 attribute
		case when AL.GroupId = '4' then PB.ServiceFee else '0' end as 'ManagementFees',AL.GroupId,
		case when AL.GroupId = '4' 
		then Cast((select top 1 OUName from mAgentAttributeMappingOU where ID = ATT.OUNameIDF) as varchar(50))
		when AL.GroupId = '10' then Cast(ISNULL(ATT.TravelRequestNumber,'0') as varchar(50))
		when (BR.Icast in ('UCUST00654','BCUST00028','UCUST00618','UCUST00615','UCUST00615A','UCUST00615B','BCUST00026A','BCUST00026','CUST001580','CUST001581','CUST001582','CUST001605','CUST001606') or 
		BR1.Icast in ('UCUST00654','BCUST00028','UCUST00618','UCUST00615','BCUST00026','UCUST00615A','UCUST00615B','BCUST00026A','CUST001580','CUST001581','CUST001582','CUST001605','CUST001606')) 
		then Cast(ISNULL(ATT.TravelRequestNumber,'0') as varchar(50))
		when AL.GroupId='18' then isnull(ATT.ConcurID,'')
		else Cast(ISNULL(ATT.CostCenter,'') as varchar(50)) end as _str1060, 
		 case when AL.GroupId = '4' then ISNULL(ATT.BTANO,'')
		 when AL.GroupId = '10' then Cast(ISNULL(ATT.EmpDimession,'0') as varchar(50))
		 when AL.GroupId='18' then ISNULL(replace(ATT.EmpDimession,'&','and'),'')
		 when (BR.Icast in ('UCUST00654','UCUST00615','BCUST00026','UCUST00615A','UCUST00615B','BCUST00026A','CUST001580','CUST001581','CUST001582','CUST001605','CUST001606') or 
		 BR1.Icast in ('UCUST00654','UCUST00615','BCUST00026','UCUST00615A','UCUST00615B','BCUST00026A','CUST001580','CUST001581','CUST001582','CUST001605','CUST001606')) 
		 then ISNULL(replace(ATT.EmpDimession,'&','and'),'')
		 when (BR.Icast in ('BCUST00028','UCUST00618')) or (BR.Icast in ('BCUST00028','UCUST00618')) then ISNULL(ATT.CostCentre,'')
		 else ISNULL(ATT.Traveltype,'') end as _str1061,
		 case when AL.GroupId = '3' then ISNULL(ATT.FareRule,'') else '' end as _str2031,
		case when AL.GroupId = '3' then ISNULL(ATT.FareType,'') else '' end as _str2030,
		case when AL.GroupId = '10' then Cast(ISNULL(replace(ATT.Projectcode,'&','and'),'0') as varchar(50))
		when (BR.Icast in ('UCUST00654','UCUST00615','BCUST00026','UCUST00615A','UCUST00615B','BCUST00026A','CUST001580','CUST001581','CUST001582','CUST001605','CUST001606') or 
		 BR1.Icast in ('UCUST00654','UCUST00615','BCUST00026','UCUST00615A','UCUST00615B','BCUST00026A','CUST001580','CUST001581','CUST001582','CUST001605','CUST001606')) 
		 then ISNULL(REPLACE(ATT.CostCentre,'&','and'),'') 
		 when AL.GroupId = '18' then isnull(replace(ATT.EMPLOYEESPOSITION,'&','and'),'')
		else ISNULL(replace(ATT.EmpDimession,'&','and'),'') end as _str1028, 
		case 
		when AL.GroupId = '18' then isnull(ATT.DEVIATIONAPPROVER,'') else ISNULL(ATT.Changedcostno,'') 
		 end  as _str1025,
		case when AL.GroupId = '18' then isnull(replace(ATT.TRAVELCOSTREIMBURSABLE,'&','and'),'')
		else
		ISNULL(ATT.Travelduration,'') end as _str1054,
		ISNULL(ATT.TASreqno,'')  as _str1022, ISNULL(ATT.Companycodecc,'')  as _str1023, case when AL.GroupId = '10' then '' else ISNULL(Replace(ATT.Projectcode,'&','&amp;'),'') end as _str1024,
		ATT.LOWEST_LOGICAL_FARE_1 as _str1008, ATT.LOWEST_LOGICAL_FARE_2 as _str1010, ATT.LOWEST_LOGICAL_FARE_3 as _str1018, ATT.EmpDimession as _str1005,
		Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans,
		--Payment Receipt Entries
		PM.bank_ref_no as TransactionNo,BBM.ModeOfPayment as PaymentType, BBM.TotalCommission as CCCharges,(isnull(PM.mer_amount,0) + isnull(BBM.TotalCommission,0)) as Amount
		--isnull(BBM.TotalCommission,0),isnull(PM.mer_amount,0)
		FROM tblBookMaster BM WITH (NOLOCK)
		LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
		LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
		LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID       LEFT JOIN mUser U on BM.MainAgentId = U.ID        
		LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
		LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
		LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null        
		LEFT JOIN B2BRegistration BR1 WITH (NOLOCK) ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null        
		LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
		LEFT JOIN tblOwnerCurrency TOC WITH (NOLOCK) ON TOC.OfficeID = BM.OfficeID        
		LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
		LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
		--LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
		LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId and BBM.FkBookId= BM.pkId
		left join tblSSRDetails SSR WITH (NOLOCK) on SSR.fkPassengerid=PB.pid and SSR.fkBookMaster=BM.pkId  and SSR.SSR_Type='Baggage' and SSR.SSR_Status=1 and SSR.SSR_Amount>0 
		left join tblSSRDetails SSR1 WITH (NOLOCK) on SSR1.fkPassengerid=PB.pid and SSR1.fkBookMaster=BM.pkId  and SSR1.SSR_Type='Meals' and SSR1.SSR_Status=1 and SSR1.SSR_Amount>0 
		left join tblSSRDetails SSR2 WITH (NOLOCK) on SSR2.fkPassengerid=PB.pid and SSR2.fkBookMaster=BM.pkId  and SSR2.SSR_Type='Seat' and SSR2.SSR_Status=1 and SSR2.SSR_Amount>0 	   
		WHERE
		BM.IsBooked = 1 
		and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
		and BM.totalFare > 0 and BM.AgentID != 'B2C'
		and BM.BookingStatus IN(1,6)  --As confirm with Mansavee        
		and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)           
		and BM.inserteddate > (Getdate()-31) -- '2021-07-31 23:59:59.999'        
		and ED.AgentCountry in ('US','CA','GB')
		and ED.AgentCountry = BM.Country  
		and ED.ERPCountry = BM.Country
		and BM.totalFare > 0
		and AL.userTypeID in (5) --For RBT usertype is 5 ***           
		and BM.VendorName Not in ('STS')
		--and BM.riyaPNR in('C99DZ0')
		ORDER BY BM.IssueDate DESC
	 END  

	IF @Action = 'RBT-US-CACancellationTickets'        
	  BEGIN        
	   SELECT TOP 1000 PB.ticketnumber,'' as UserName, BM.bookingStatus,ED.OwnerCountry,
	   --ED.VendorCode,
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission, PB.CancelledDate as PostingDate,
	  Case When BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'US' Then 'UVEND00082'
		when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'GB' Then 'VEND00008' 
		when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'CA' Then 'BOMVEND007913' 
		when BM.OfficeID = '00FK' and ED.AgentCountry = 'US' Then 'UVEND01206'
		Else ED.VendorCode End as VendorCode,
	   BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,        
	   BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	   BM.arrivalTime, PB.FMCommission, '0' as Surcharge,
	   	   Case when ED.AgentCountry = ED.OwnerCountry then '0' else BM.AgentROE end as 'SalesCurrROE',
		Case when ED.AgentCountry != ED.OwnerCountry and ED.OwnerCountry != ED.ERPCountry and ED.AgentCountry != ED.ERPCountry then BM.AgentCurrency else '' end as 'SalesCurr',
	   case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else CU.Currency end as 'PurchaseCurr'   ,        
		BM.ROE as 'PurchaseCurrROE',
	   case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP, PB.FMCommission,
	 --    (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, 
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
	   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, 
	   BM.orderId,        
	   PB.pid, PB.title, PB.ticketNum, PB.pid, PB.basicFare + isnull(PB.Markup,0) + isnull(PB.LonServiceFee,0) as basicFare, PB.totalTax, PB.paxType,        
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax, PB.WOTax , PB.YMTax,
	   PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
	   ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,
	   Case	When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast
			When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode
	   End As Icast,
	   BR.LocationCode, '' as BranchCode,'' as DivisionCode, PR.EmpCode,ATT.OBTCno,       
	   PB.CancellationPenalty as 'Canfees', ERP.ServiceFees, 
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	   ERP.MarkuponPenalty, ERP.Narration,         
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   AM.Ticketcode as airlinecode,SSR.SSR_Amount as 'extrabagAmount',        
	   --AC.type 'AirLineType'      
	   case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',
	   --New
		ISNULL(PM.AuthCode,'') as CVV,--1055 attribute
		case when AL.GroupId = '4' then PB.ServiceFee else '0' end as 'ManagementFees',AL.GroupId,
		case when AL.GroupId = '4' 
		then Cast((select top 1 OUName from mAgentAttributeMappingOU where ID = ATT.OUNameIDF) as varchar(50))
		when AL.GroupId = '10' then Cast(ISNULL(ATT.TRVELKEYNO,'0') as varchar(50))
		else Cast(ISNULL(ATT.CostCenter,'0') as varchar(50)) end as _str1060,
		 case when AL.GroupId = '4' then ISNULL(ATT.BTANO,'')
		 when AL.GroupId = '10' then Cast(ISNULL(ATT.EmpDimession,'0') as varchar(50))
		 else ISNULL(ATT.Traveltype,'') end as _str1061,
		case when AL.GroupId = '10' then Cast(ISNULL(ATT.Projectcode,'0') as varchar(50))
		else ISNULL(ATT.EmpDimession,'') end as _str1028, ISNULL(ATT.Changedcostno,'')  as _str1025,
		case when AL.GroupId = '3' then ISNULL(ATT.FareRule,'') else '' end as _str2031,
		case when AL.GroupId = '3' then ISNULL(ATT.FareType,'') else '' end as _str2030,
		ISNULL(ATT.Travelduration,'')  as _str1054, ISNULL(ATT.TASreqno,'')  as _str1022, ISNULL(ATT.Companycodecc,'')  as _str1023, ISNULL(ATT.Projectcode,'') as _str1024,
		ATT.LOWEST_LOGICAL_FARE_1 as _str1008, ATT.LOWEST_LOGICAL_FARE_2 as _str1010, ATT.LOWEST_LOGICAL_FARE_3 as _str1018, ATT.EmpDimession as _str1005,
		Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans
	   FROM tblBookMaster BM WITH (NOLOCK)
	   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
	   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID        
	   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID        
	   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID        
	   LEFT JOIN TBL_ERP_RefundProcess ERP WITH (NOLOCK) ON ERP.PBID = PB.pid        
	   LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
	   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID         
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
	   Left JOIN tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1    
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   WHERE        
	   BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'   
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and PB.BookingStatus In(4,11) --As confirm with Mansavee         
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)           
	   and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'        
	   and BM.Country in ('US','CA','GB')
	   and ED.AgentCountry = BM.Country
	   and ED.ERPCountry = BM.Country
	   and AL.userTypeID = 5
	   and BM.totalFare > 0
	   --and BM.GDSPNR in ('1I425U')
	   and BM.VendorName Not in ('STS')
	   ORDER BY BM.IssueDate DESC
	  END        

	IF @Action = 'RBT_MCO_Bookingtickets' 
	  BEGIN        
	   SELECT TOP 10000 --PB.TicketNumber,PB.ERPResponseID,PB.ERPPuststatus,PB.ERPMcoResponseID,PB.ERPMcoPushstatus,
	   Case When PB.MCOTicketNo like '%-%' 
					Then substring(stuff(PB.MCOTicketNo,1,4,''),1,10)
					when LEN(PB.MCOTicketNo) = 10 then PB.MCOTicketNo
					Else substring(stuff(PB.MCOTicketNo,1,3,''),1,10)End As MCOTicketNo,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	   PB.MCOAmount,BM.MCOAmount,ED.AgentCountry,ED.OwnerCountry,ED.ERPCountry,BM.MainAgentId,U.UserName,BM.bookingStatus,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,PB.IATACommission as CustIATACommAmount ,
	   --ED.VendorCode,
	 --   (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, 
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,
	  Case When BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'US' Then 'UVEND00082'
		when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'GB' Then 'VEND00008' 
		when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'CA' Then 'BOMVEND007913' 
		Else ED.VendorCode End as VendorCode,
	  -- Case	When PM.payment_mode='passThrough' then 'CUSTOMER'         
			--When PM.payment_mode='Credit' then 'CORPORATE'         
			--Else 'CASH' End As UATP,
	   PB.pid,BM.pkId,ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,PB.FMCommission,BBM.TotalCommission as Surcharge, isnull(BM.IssueDate, BM.inserteddate) as PostingDate,
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else TOC.IATA end as IATA,
	   ISNULL(BR.Icast,BR1.Icast) As 'Icast',BM.riyaPNR,BM.inserteddate,BM.CounterCloseTime,BM.RegistrationNumber,
	   BM.IssueDate,BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No, BM.IATACommission,BM.deptTime,BM.arrivalTime, BM.frmSector,BM.toSector,
	   BM.flightNo, BM.travClass,BM.AgentID, BM.Country, BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',
	   BM.VendorCommissionPercent, case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	   BM.orderId,PB.title, PB.paxType,PB.paxFName,PB.paxLName,
	   ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') 'PaxName',PB.basicFare + isnull(PB.Markup,0) + isnull(PB.LonServiceFee,0) 'basicFare',PB.totalTax,
	   BM.totalFare,PB.MCOAmount,
	   cast((Isnull(PB.MCOAmount,0)-Isnull(PB.MCOAmount,0)*3.5/100)as decimal(18,2)) as McoCommissionAmount,PB.managementfees,
	   PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,BM.AgentMarkup,PB.JNTax as 'K3Tax',PB.YRTax, PB.YQ, PB.INTax, PB.JNTax,PB.OCTax,
	   PB.ExtraTax,PB.RFTax,PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
	   PB.ServiceFee as 'ServiceFees', ISNULL(PB.B2bMarkup,0) +ISNULL(PB.BFC,0) as 'MarkupOnBaseFare' ,'' as MarkupOnTaxFare , '' as Narration,        
	   --BM.AgentROE as 'SalesExchangeRate',BM.AgentCurrency as 'SalesCurrencyCode',        
	   PB.BaggageFare,        
	   --ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,        
	   BR.LocationCode, '' as BranchCode,'' as DivisionCode,        
	   ------ERP.Canfees, ERP.ServiceFees, ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare, ERP.MarkuponPenalty, ERP.Narration,        
	   AM.Ticketcode as airlinecode,        
	   Case When BM.CounterCloseTime = 1 Then 'AIR-DOM' Else 'AIR-INT' End As productType,
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   BM.IssueBy as 'TicketinguserID',        
	   BM.BookedBy as 'BookinguserID',        
	   case when BM.VendorName='Amadeus' then '1A'         
	   when BM.VendorName='Galileo' then '1G'         
	   when BM.VendorName='Sabre' then '1S'
	   when BM.VendorName='TravelFusion' then 'TF'
	   when BM.VendorName='TravelFusionNDC' then 'TFNDC'
	   Else '' end as CRSCode,       
	   BM.AgentROE as 'SalesCurrROE',        
	   BM.AgentCurrency as 'SalesCurr',        
	   case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else TOC.Currency end as 'PurchaseCurr',        
	   BM.ROE as 'PurchaseCurrROE',        
	   PB.baggage        
	   ,SSR.SSR_Amount as 'extrabagAmount',        
		cast((isnull((CASE WHEN BM.B2bFareType=2 or BM.B2bFareType=3 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) as MarkupOnTax_,        
		(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) +PB.BFC) as MarkupOnFare_        
	   ,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'        
	   FROM tblBookMaster BM WITH (NOLOCK)
		   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
		   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
		   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID       LEFT JOIN mUser U on BM.MainAgentId = U.ID        
		   --LEFT JOIN mAttrributesDetails ATT ON PB.pid = ATT.fkPassengerid
		   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
		   LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null        
		   LEFT JOIN B2BRegistration BR1 WITH (NOLOCK) ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null        
		   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
		   LEFT JOIN tblOwnerCurrency TOC WITH (NOLOCK) ON TOC.OfficeID = BM.OfficeID        
		   LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
		   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
		   left join tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1        
		   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
		   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'
	       and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
		   and BM.BookingStatus IN(1,6)  --As confirm with Mansavee
		   and PB.ERPMcoResponseID is null and (PB.ERPMcoPushStatus = 0 or PB.ERPMcoPushStatus is null)           
		   and PB.MCOTicketNo is not null and PB.MCOTicketNo !=''
		   and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'        
		   and ED.AgentCountry in ('US','CA','GB')--('IN','AE','US','CA')  
		   and BM.totalFare > 0
		   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country        
		   and AL.userTypeID = 5 --For US RBT usertype is 5 ***   
		   and BM.VendorName Not in ('STS')
		   ORDER BY BM.IssueDate DESC
	END

	IF @Action = 'RBT_MCO_Cancellationtickets'        
	  BEGIN        
		SELECT TOP 10000 --PB.TicketNumber,PB.ERPResponseID,PB.ERPPuststatus,PB.CannERPMcoResponseID,PB.CannERPMcoPushstatus,
		Case When PB.MCOTicketNo like '%-%' 
					Then substring(stuff(PB.MCOTicketNo,1,4,''),1,10)
					when LEN(PB.MCOTicketNo) = 10 then PB.MCOTicketNo
					Else substring(stuff(PB.MCOTicketNo,1,3,''),1,10)End As MCOTicketNo
		,U.UserName,BM.bookingStatus,BBM.TotalCommission as Surcharge,PB.IATACommission as CustIATACommAmount ,
		--ED.VendorCode,
		--  (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	    case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,  
	    Case When BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'US' Then 'UVEND00082'
		when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'GB' Then 'VEND00008' 
		when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'CA' Then 'BOMVEND007913' 
		Else ED.VendorCode End as VendorCode,
		BM.pkId,PB.pid,BM.riyaPNR,BM.inserteddate,BM.CounterCloseTime, 
		case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
		BM.RegistrationNumber,BM.IssueDate,BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,
		case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
		BM.frmSector,BM.toSector,BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
		BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, 
		BM.orderId,PB.title,PB.basicFare + isnull(PB.Markup,0) + isnull(PB.LonServiceFee,0) as basicFare,BM.totalFare,PB.totalTax,PB.FMCommission,
		PB.MCOAmount,ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,PB.PLBCommission,
		cast((Isnull(BM.MCOAmount,0)-Isnull(BM.MCOAmount,0)*3.5/100)as decimal(18,2)) as McoCommissionAmount,
		PB.paxType,PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,PB.managementfees,PB.baggage,
		case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,PM.CardType, PM.MaskCardNumber as 'CardNumber',PM.mer_amount, PM.billing_address,
		PM.billing_name,PM.order_id, PM.tracking_id, isnull(BM.IssueDate, BM.inserteddate) as PostingDate,   
		--BI.airlinePNR, BI.cabin, BI.farebasis,
		ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,Icast,BR.LocationCode, '' as BranchCode,'' as DivisionCode,
		ERP.Canfees, ERP.ServiceFees, 
		cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
		--ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
		ERP.MarkuponPenalty, ERP.Narration,
		Case When BM.CounterCloseTime = 1 Then 'AIR-DOM' Else 'AIR-INT' End As productType,
		'' as FormOfPayment,  -- Need to check with manasvee        
		--1 for domestic        
		AM.Ticketcode as airlinecode,        
		--AC.type 'AirLineType'
		case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'
		From tblBookMaster BM WITH (NOLOCK)
			LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
			LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
			LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID        
			LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID        
			LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
			LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
			LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID        
			LEFT JOIN TBL_ERP_RefundProcess ERP WITH (NOLOCK) ON ERP.PBID = PB.pid        
			LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
			--LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
			LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode 
			LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID 
			LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
			LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
		Where BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'
		    and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
			And PB.BookingStatus IN(4,11) --As confirm with Mansavee
			And PB.CannERPMcoResponseID is null and (PB.CannERPMcoPushStatus = 0 or PB.CannERPMcoPushStatus is null)
			and PB.MCOTicketNo is not null and PB.MCOTicketNo !=''
			and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'        
			and ED.AgentCountry in ('US','CA','GB')
			and BM.totalFare > 0
			And ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country
			and AL.userTypeID = 5 --For RBT usertype is 5 ***   
			and BM.VendorName Not in ('STS')
			And PB.MCOTicketNo is not null
			ORDER BY BM.IssueDate DESC
	  END 

	IF @Action = 'HolidayCancellationtTickets'
	  BEGIN        
	   SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, BM.bookingStatus,
	   --ED.VendorCode,
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,CD.Configuration, '0' as Surcharge, PB.CancelledDate as PostingDate,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,
	  case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	   BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	   BM.RegistrationNumber, BM.IssueDate,BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,BM.arrivalTime,
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
	   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, 
	   BM.equipment,BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, 
	   BM.orderId,PB.title, PB.ticketNum, PB.pid, PB.basicFare + isnull(PB.LonServiceFee,0) as basicFare,PB.FMCommission,
	   PB.totalTax, PB.paxType,PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,PB.managementfees, 
	   PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address,
	   PM.billing_name, PM.order_id, PM.tracking_id,       PB.YMTax,  
	   --BI.airlinePNR, BI.cabin, BI.farebasis,     
	 --    (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	    case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,  
		ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,
		Icast= 'BOMCUST002120A',
		LocationCode = 'BOM', BranchCode = 'BR2002000', '' as DivisionCode,  PR.EmpCode,ATT.OBTCno,	         
	   ERP.Canfees, ERP.ServiceFees, 
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	   ERP.MarkuponPenalty, ERP.Narration,         
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   AM.Ticketcode as airlinecode,SSR.SSR_Amount as 'extrabagAmount',        
	   --AC.type 'AirLineType'
	   case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'
	   FROM tblBookMaster BM WITH (NOLOCK)
	   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
	   LEFT JOIN tblBookItenary BI WITH (NOLOCK) ON BM.orderId = BI.orderId        
	   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	   LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID        
	   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID           
	   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID           
	   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID
	   LEFT JOIN tblInterBranchWinyatra IBM WITH (NOLOCK) ON B2BR.StateID = IBM.fkStateId and IBM.Country = 'IN'
	   LEFT JOIN TBL_ERP_RefundProcess ERP WITH (NOLOCK) ON ERP.PBID = PB.pid        
	   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID           
	   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID         
	   LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode  
	   Left JOIN tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1   
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'  
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and PB.BookingStatus In (4,11) 
	   -- For Cancellation        
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)           
	   and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'               
	   --and BM.Country in('IN','AE','US','CA')  // Commented As Discussed With Pranay & Bhavika        
	   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country
	   and AL.userTypeID IN(4) --For Holiday usertype is 4 ***   
	   and BM.VendorName Not in ('STS')	 
	   and BM.totalFare > 0
	   --and BM.riyaPNR = 'ZKV336'      
	   --and PB.TicketNumber In ('FJGK9P-1')
	   ORDER BY BM.inserteddate DESC
	  END        
	
	IF @Action = 'HolidayBookingTickets'        
	  BEGIN        
	  SELECT TOP 10000 U.EmployeeNo as UserName,Case when BM.Country = 'US' and ED.OwnerCountry = 'IN' Then 'BOMCUST002120A'
		when BM.Country = 'US' and ED.OwnerCountry = 'US' then 'UCUST00505'
		when BM.Country = 'US' and ED.OwnerCountry = 'CA' then 'CCUST00004'
		when BM.Country = 'US' and ED.OwnerCountry = 'AE' then 'CUST000324'
		else B2BR.Icast end as cust,B2BR.BranchCode as branchCode,
	  --ED.VendorCode,
	  case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,BM.totalFare,BM.orderId,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   case when BM.CounterCloseTime = 1 then 'D' else 'I' end as productType,PB.ServiceFee as 'ServiceFees',
	  PB.FMCommission, '0' as Surcharge, isnull(BM.IssueDate, BM.inserteddate) as PostingDate,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	  BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime,ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	  BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,        
	  BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',        
	  BM.VendorCommissionPercent,PB.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
	  CD.Configuration,
	  case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end as 'Currency',BM.ROE,        
	  BM.RegistrationNumber,PB.title,LEFT(PB.TicketNumber,10) as TicketNumber,PB.pid,PB.basicFare + isnull(PB.LonServiceFee,0) as basicFare,PB.totalTax,PB.paxType,PB.paxFName,PB.paxLName,        
	  PB.managementfees,PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax,PB.YQ,PB.INTax,PB.JNTax,PB.OCTax,PB.ExtraTax,PB.BaggageFare,PM.CardType,        
	  PM.MaskCardNumber as 'CardNumber',PM.mer_amount,PM.billing_address,PM.billing_name,PM.order_id,PM.tracking_id,--BI.airlinePNR,BI.cabin,BI.farebasis,        
	  ATT.VesselName,ATT.TR_POName,ATT.Bookedby,ATT.AType,ATT.RankNo,  PB.YMTax,           
	 -- (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	    case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,  
	   --Case	When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast
			--When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode
			--When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode
			--End As Icast,	
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	  case when BM.OfficeID = 'DFW1S212A' then 'UCUST00505' 
	        when BM.OfficeID = 'YWGC4211G' then 'CCUST00004' 
	        when BM.OfficeID = 'DXBAD3359' then 'CUST000324' 
	        else IBM.Icust end as Icast,
	  LocationCode = 'BOM', 
	  Code = 'BR2002000',  PR.EmpCode,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',ATT.OBTCno
	  FROM tblBookMaster BM WITH (NOLOCK)
	   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
	   --LEFT JOIN tblBookItenary BI WITH (NOLOCK) ON BM.orderId = BI.orderId        
	   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	   LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID        
	   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID           
	   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID           
	   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID
	   LEFT JOIN tblInterBranchWinyatra IBM WITH (NOLOCK) ON B2BR.StateID = IBM.fkStateId and IBM.Country = 'IN'
	   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID           
	   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID         
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and BM.BookingStatus In (1,6) --= 4 For Cancellation  =1 For Booking  --As confirm with Mansavee        
	   -- For Booking        
	   and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)        
	   and BM.inserteddate > (Getdate()-62) -- '2021-08-31 23:59:59.999'        
	   --and BM.Country in('IN','AE','US','CA')  // Commented As Discussed With Pranay & Bhavika        
	   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country
	   and BM.totalFare > 0
		and AL.userTypeID IN(4) --For Holiday usertype is 4 ***   
	   --and BM.riyaPNR='PVGAQ6'
	   and BM.VendorName Not in ('STS')
	   ORDER BY BM.inserteddate DESC
	 END     
	 
	 IF @Action = 'WinYatra-HolidayBookingTickets'        
	  BEGIN        
	  SELECT TOP 10000 U.EmployeeNo as UserName,B2BR.Icast as obcust,
	  case when B2BR.Icast = BW.Icust then BW.[RH Ledgers] else 'RTTICU' end as cust,
	  isNull(BW.SubLed,'ADH') as SubLed,isNUll(BW.BranchId,'BOM') as BranchId,B2BR.BranchCode as branchCode,
	  PB.WinYatraInvoice,BM.GDSPNR as 'FnGDSPnr',
	  --ED.VendorCode,
	  case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,BM.totalFare,Replace(U.FullName,'''','') as FullName,BM.depDate,BM.deptTime,
	   case when BM.CounterCloseTime = 1 then 'D' else 'I' end as productType,PB.ServiceFee as 'ServiceFees',
	  PB.FMCommission, BBM.TotalCommission as Surcharge, Format(CONVERT(datetime,isnull(BM.IssueDate, BM.inserteddate),103),'dd/MM/yyyy') as PostingDate,PB.TDSamount,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,BM.airCode,
	  BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime,ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	  BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,B2BR.CustomerCOde,B2BR.AgencyName,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',        
	  BM.VendorCommissionPercent,PB.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
	  CD.Configuration,
	  case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end as 'Currency',BM.ROE,BM.arrivalTime,       
	  BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.pid,PB.basicFare + isnull(PB.LonServiceFee,0) as basicFare,PB.totalTax,PB.paxType,PB.paxFName,PB.paxLName,        
	  PB.managementfees,PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax,PB.YQ,PB.INTax,PB.JNTax,PB.OCTax,PB.ExtraTax,PB.BaggageFare,PM.CardType,        
	  PM.MaskCardNumber as 'CardNumber',PM.mer_amount,PM.billing_address,PM.billing_name,PM.order_id,PM.tracking_id,--BI.airlinePNR,BI.cabin,BI.farebasis,        
	  ATT.VesselName,ATT.TR_POName,''as Bookedby,ATT.AType,ATT.RankNo,  PB.YMTax,           
	  (select sum(SSR_Amount)  from tblSSRDetails s
		where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		as ExtraBaggage,    
		(select sum(SSR_Amount)  from tblSSRDetails s
		where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		as SeatPreferenceCharge,    
		(select sum(SSR_Amount)  from tblSSRDetails s
		where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		as MealCharges,
	    case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,  
	   --Case	When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast
			--When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode
			--When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode
			--End As Icast,	
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	  Icast= 'BOMCUST002120A',
	  LocationCode = 'BOM', 
	  Code = 'BR2002000',  PR.EmpCode,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',ATT.OBTCno,
	  (Select SUBSTRING((
            SELECT ',' + IT.airlinePNR from tblBookItenary IT where  BM.pkId = IT.fkBookMaster and IT.orderId = BM.orderid group by IT.fkBookMaster,IT.orderId,IT.airlinePNR FOR XML PATH('')), 2, 1000000 )) as AirlinePNR
	  FROM tblBookMaster BM WITH (NOLOCK)
	   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BI.orderId        
	   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	   LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID  
	   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID
	   left join tblInterBranchWinyatra BW WITH (NOLOCK) on B2BR.Icast = BW.Icust and ED.OwnerCountry = BW.Country and BW.IsActive = 1
	   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID           
	   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID        
	   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID           
	   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID         
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'     
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and BM.BookingStatus In (1,6) --= 4 For Cancellation  =1 For Booking  --As confirm with Mansavee        
	   -- For Booking        
	   --and isnull(BM.ERPPush,0) != 0
	   and PB.ERPResponseID is not null and (PB.ERPPuststatus != 0 or PB.ERPPuststatus is not null)        
	   and (PB.WinYatraInvoice is null or PB.WinYatraInvoice = '')
	   and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'           
	   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country
	   and BM.totalFare > 0
	  -- and BM.riyaPNR in ('927PEL')
	  -- and (ATT.OBTCno != '' or ATT.OBTCno != null)
	   and ((AL.userTypeID = 2 and B2BR.Icast in (select Icust from tblInterBranchWinyatra))
	   or AL.userTypeID IN(4))--For Holiday usertype is 4 ***
	   and BM.VendorName Not in ('STS')
	  union All
	  SELECT TOP 10000 U.EmployeeNo as UserName,B2BR.Icast as obcust,
	  case when B2BR.Icast = BW.Icust then BW.[RH Ledgers] else 'RTTICU' end as cust,
	  isNull(BW.SubLed,'ADH') as SubLed,isNUll(BW.BranchId,'BOM') as BranchId,B2BR.BranchCode as branchCode,
	  PB.WinYatraInvoice,
	  Case when BM.GDSPNR = 'N/A' then
	  '' else
	  BM.GDSPNR
	  end
	  as 'FnGDSPnr',
	  --ED.VendorCode,
	  case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,BM.totalFare,Replace(U.FullName,'''','') as FullName,BM.depDate,BM.deptTime,
	   case when BM.CounterCloseTime = 1 then 'D' else 'I' end as productType,PB.ServiceFee as 'ServiceFees',
	  PB.FMCommission, BBM.TotalCommission as Surcharge,  Format(CONVERT(datetime,isnull(BM.IssueDate, BM.inserteddate),103),'dd/MM/yyyy') as PostingDate,PB.TDSamount,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,BM.airCode,
	  BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime,ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	  BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,B2BR.CustomerCOde,B2BR.AgencyName,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',        
	  BM.VendorCommissionPercent,PB.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
	  CD.Configuration,
	  case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end as 'Currency',BM.ROE,BM.arrivalTime,       
	  BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.pid,PB.basicFare + isnull(PB.LonServiceFee,0) as basicFare,PB.totalTax,PB.paxType,PB.paxFName,PB.paxLName,        
	  PB.managementfees,PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax,PB.YQ,PB.INTax,PB.JNTax,PB.OCTax,PB.ExtraTax,PB.BaggageFare,PM.CardType,        
	  PM.MaskCardNumber as 'CardNumber',PM.mer_amount,PM.billing_address,PM.billing_name,PM.order_id,PM.tracking_id,--BI.airlinePNR,BI.cabin,BI.farebasis,        
	  ATT.VesselName,ATT.TR_POName,''as Bookedby,ATT.AType,ATT.RankNo,  PB.YMTax,           
	  (select sum(SSR_Amount)  from tblSSRDetails s
		where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		as ExtraBaggage,    
		(select sum(SSR_Amount)  from tblSSRDetails s
		where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		as SeatPreferenceCharge,    
		(select sum(SSR_Amount)  from tblSSRDetails s
		where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		and s.fkBookMaster in (select pkid from tblBookMaster where orderId=BM.orderId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		as MealCharges,
	    case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,  
	   --Case	When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast
			--When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode
			--When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode
			--End As Icast,	
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	  Icast= 'BOMCUST002120A',
	  LocationCode = 'BOM', 
	  Code = 'BR2002000', 
	  PR.EmpCode,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',ATT.OBTCno,
	  (Select SUBSTRING((
            SELECT ',' + IT.airlinePNR from tblBookItenary IT where  BM.pkId = IT.fkBookMaster and IT.orderId = BM.orderid group by IT.fkBookMaster,IT.orderId,IT.airlinePNR FOR XML PATH('')), 2, 1000000 )) as AirlinePNR
	  FROM tblBookMaster BM WITH (NOLOCK)
	   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BI.orderId        
	   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	   LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID  
	   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID
	   left join tblInterBranchWinyatra BW WITH (NOLOCK) on B2BR.Icast = BW.Icust and ED.OwnerCountry = BW.Country and BW.IsActive = 1
	   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID           
	   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID        
	   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID           
	   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID         
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'     
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and BM.BookingStatus In (1,6) --= 4 For Cancellation  =1 For Booking  --As confirm with Mansavee        
	   -- For Booking        
	   --and isnull(BM.ERPPush,0) != 0
	  -- and PB.ERPResponseID is not null and (PB.ERPPuststatus != 0 or PB.ERPPuststatus is not null)        
	   and (PB.WinYatraInvoice is null or PB.WinYatraInvoice = '')
	   and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'           
	   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country
	   and BM.totalFare > 0
	  --and BM.riyaPNR in ('927PEL)
	  -- and (ATT.OBTCno != '' or ATT.OBTCno != null)
	   and ((AL.userTypeID = 2 and B2BR.Icast in (select Icust from tblInterBranchWinyatra))
	   or AL.userTypeID IN(4))--For Holiday usertype is 4 ***   
	   and BM.VendorName = ('STS')
	   ORDER BY BM.inserteddate DESC
	 END   


        
	IF @Action = 'UAEBookingTickets'        
	  BEGIN
	  SELECT TOP 10000 U.EmployeeNo as UserName,--ED.VendorCode,
	  case when BM.BookingSource = 'Retrive PNR Accounting' THEN isnull(PB.FMCommission,0)
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN isnull(PB.FMCommission,0)
       when BM.BookingSource ='GDS' THEN isnull(PB.FMCommission,0)
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN isnull(PB.FMCommission,0)
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN isnull(PB.Markup,0)
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN isnull(PB.FMCommission,0)
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN isnull(PB.Markup,0)
       ELSE isnull(PB.Markup,0) END AS VendIATACommAmount,BM.MainAgentId as TicketingUserID,
	  case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, isnull(BM.IssueDate, BM.inserteddate) as PostingDate,
	  Case when EV.VendorCode is null then
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end ELSE EV.VendorCode end as VendorCode,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	  case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, 
	  case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	  BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime,ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount ,
	  (Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	  BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,        
	  BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR when BM.VendorName ='Amadeus' then BM.GDSPNR else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',        
	  BM.VendorCommissionPercent,PB.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,PB.FMCommission,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'       
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
	  case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end  as 'Currency',BM.ROE,        
	  BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.pid,PB.basicFare + isnull(PB.LonServiceFee,0) as basicFare,PB.totalTax,PB.paxType,PB.paxFName,PB.paxLName,        
	  PB.managementfees,PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,PB.YRTax,PB.YQ,
	  PB.WOTax,PB.INTax,PB.JNTax,PB.OCTax,PB.ExtraTax,PB.BaggageFare,PM.CardType, PB.YMTax,
	  PM.MaskCardNumber as 'CardNumber',PM.mer_amount,PM.billing_address,PM.billing_name,PM.order_id,PM.tracking_id,--BI.airlinePNR,BI.cabin,BI.farebasis,        
	  Replace(ATT.VesselName, '&','and') as 'VesselName',Replace(ATT.TR_POName, '&','and') as 'TR_POName',ATT.Bookedby,ATT.AType,ATT.RankNo,  
	  Replace(ATT.CarbonFootprint, '&','and') as 'CarbonFootprint', isnull(ATT.Remarks,'') as 'Remarks',isnull(ATT.CurrencyConversionRate,'') as 'CurrencyConversionRate',isnull(ATT.NameofApprover,'') as 'NameofApprover',
	  BBM.TotalCommission as Surcharge,ISNULL(SSR.SSR_Amount,0) AS 'SSR_Amount',ISNULL(SSR.fkPassengerid,0) AS 'fkPassengerid',
	 --   (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	  Case	When ED.CustomerCode='AgentCustID' and (B2BR.Icast !='AgentCustID' or B2BR.Icast is null) then Isnull(B2BR.Icast,B2BR1.Icast)
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode
			End As Icast,
	  B2BR.LocationCode, BranchCode = '', PR.EmpCode,--AC.type 'AirLineType'    ,
	  case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
		, BM.AgentROE as 'SalesCurrROE',        
	  
	   Case when ED.AgentCountry != ED.OwnerCountry and ED.OwnerCountry != ED.ERPCountry and ED.AgentCountry != ED.ERPCountry then BM.AgentCurrency else '' end as 'SalesCurr',        
	  case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else CU.Currency end as 'PurchaseCurr'  ,        
	  BM.ROE as 'PurchaseCurrROE',
	  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3) AND BM.BookingSource!='ManualTicketing') THEN  ((PB.B2BMarkup+PB.HupAmount)/isnull(BM.AgentROE,0)) 
      when BM.BookingSource='ManualTicketing' then PB.Markup ELSE PB.HupAmount END),0))as decimal(18,2)) as MarkupOnTax   
	  ,Case when EV.VendorCode is null 
	  then 
		Case when ED.AgentCountry = ED.OwnerCountry 
		then '0' else '1' end 
	  else '0' end as Intcompanytrans
	  --, case when PM.payment_mode='passThrough' then 'CUSTOMER'         
	  -- when PM.payment_mode='Credit' then 'CORPORATE'         
	  -- Else 'CASH' end as UATP        
	  FROM tblBookMaster BM WITH (NOLOCK)
	  LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	  LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
	 -- LEFT JOIN tblBookItenary BI ON BM.orderId = BI.orderId        
	  --LEFT JOIN tblBookItenary BI ON BM.pkId = BI.pkId        
	  LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	  LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID        
	  LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country           
	  LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID           
	  Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID        
	  LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID    
	  LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	  LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID    
	  LEFT JOIN B2BRegistration B2BR1 WITH (NOLOCK) ON AL.ParentAgentID = B2BR1.FKUserID
	  LEFT JOIN TblErpVendorCode EV WITH (NOLOCK) on BM.OfficeID = EV.OfficeID and ED.AgentCountry in ('AE')
	  LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode    
	  LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	  left join tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1
	  WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'
	  and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	  and BM.BookingStatus In (1,6) --As confirm with Mansavee        
	  -- For Booking
	  and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)        
	  and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'        
	  and BM.Country in('AE','SA')        
	  and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country         
	  and AL.userTypeID IN(2,3,5) --For UAE usertype is 2 ***    --- 3 is for marine uae and 5 is for RBT
	  and ISNULL(PB.TicketNumber,'') != ''
	  and (B2BR.FKUserID not in (49932) or B2BR1.FKUserID not in (49932))
	  and BM.totalFare > 0
	  --and BM.riyaPNR IN('52I8Z3')
	  and BM.VendorName Not in ('STS')
	  ORDER BY BM.inserteddate DESC
	 END
    
	If @Action = 'UAECancellationTickets'
	Begin 
		SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, BM.bookingStatus,
	   --ED.VendorCode,
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,BM.MainAgentId as TicketingUserID,
	   CD.Configuration, BBM.TotalCommission, BBM.TotalCommission as Surcharge,
	   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, PB.CancelledDate as PostingDate,
	   case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	   Case when EV.VendorCode is null then
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end ELSE EV.VendorCode end as VendorCode,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber,isnull(BM.IssueDate, BM.inserteddate) as IssueDate,          
	   BM.canceledDate,BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	   BM.arrivalTime, ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount ,
	   (Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
	   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass, PB.FMCommission,
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,BM.orderId,        
	   PB.pid, PB.title, PB.ticketNum, PB.pid, PB.basicFare + isnull(PB.LonServiceFee,0) as basicFare, PB.totalTax, PB.paxType,        
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	        
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,        
	   PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
	   ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,
	   Case	When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast
			When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode
			When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode
	   End As Icast,
	   BR.LocationCode, '' as BranchCode,'' as DivisionCode, PR.EmpCode,ATT.OBTCno,       
	   ERP.Canfees, ERP.ServiceFees, 
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   
	   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare
	   ERP.MarkuponPenalty, replace(ERP.Narration, '&','and') as Narration,PB.CancellationPenalty  , 
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   AM.Ticketcode as airlinecode,SSR.SSR_Amount as 'extrabagAmount',        
	   --AC.type 'AirLineType'   
	   case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'
	   FROM tblBookMaster BM WITH (NOLOCK)
	   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
	   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID        
	   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID        
	   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID        
	   LEFT JOIN TBL_ERP_RefundProcess ERP WITH (NOLOCK) ON ERP.PBID = PB.pid        
	   LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode   
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID 
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BM.orderId = BBM.OrderId
	   LEFT JOIN TblErpVendorCode EV WITH (NOLOCK) on BM.OfficeID = EV.OfficeID and ED.AgentCountry in ('AE')
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
	   Left JOIN tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1        
	   WHERE        
	   BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'      
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and PB.BookingStatus In(4,11) --As confirm with Mansavee         
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)           
	   and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'        
	   and BM.Country in('AE','SA')
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country     
	   and AL.userTypeID IN(2,3,5) --For UAE usertype is 2 ***    --- 3 is for marine uae and 5 is for RBT
	   and BM.totalFare > 0
	   and ISNULL(PB.TicketNumber,'') != ''
	  -- and BM.riyaPNR in ('1I425U')
	   and BM.VendorName Not in ('STS')
	   ORDER BY BM.IssueDate DESC
	End

	IF @Action = 'US-CABookingtickets' 
	  BEGIN        
	   SELECT TOP 10000 PB.ticketnumber, ED.AgentCountry,ED.OwnerCountry, ED.ERPCountry, BM.MainAgentId        
	   ,U.EmployeeNo as UserName, BM.bookingStatus, ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,BM.airCode,PB.FMCommission, 
	   --ED.VendorCode,
	   case when BM.BookingSource = 'GDS' then 'TJQ' else 'TrvlNxt' end as BookingType,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  when BM.OfficeID = '00FK' and ED.AgentCountry = 'US' Then 'UVEND01206'
	  else ED.VendorCode end as VendorCode,      
	   --case when PM.payment_mode='passThrough' then 'CUSTOMER'         
	   --when PM.payment_mode='Credit' then 'CORPORATE'         
	   --Else 'CASH' end as UATP,        
	   BBM.TotalCommission as Surcharge,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   PB.pid,BM.pkId, PB.IATACommission as CustIATACommAmount ,
	   case when PM1.ParentOrderId is not null then PM1.MerchantId else PM.MerchantId end as 'PaymentGateway',
	   (Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	   isnull(BM.IssueDate, BM.inserteddate) as PostingDate,
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,
	   case when PM1.ParentOrderId is not null then PM1.BankAccountNo else PM.BankAccountNo end as BankAccountNo,
	   case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	   PM.MaskCardNumber as 'CardNumber',
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'  
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else TOC.IATA end as IATA,
	   ISNULL(BR.Icast, BR1.Icast) as 'Icast', BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime,        
	   BM.RegistrationNumber, BM.IssueDate,BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	   BM.arrivalTime, BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,
	   (case when PM1.ParentOrderId is not null then isnull(PM1.mer_amount,0) else isnull(PM.mer_amount,0) end + isnull(BBM.TotalCommission,0)) as Amount,
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, ED.OwnerID,ED.ERPCountry, BM.orderId,        
		PB.title, PB.TicketNumber, PB.basicFare + isnull(PB.Markup,0) + isnull(PB.LonServiceFee,0) as basicFare, PB.totalTax, PB.paxType, PB.JNTax as 'K3Tax',        
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	BM.AgentMarkup,        
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax, PB.RFTax, PB.WOTax,  PB.YMTax,     
	   PM.CardType,case when PM1.ParentOrderId is not null then PM1.mer_amount else PM.mer_amount end as 'mer_amount', PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,
	   --BI.airlinePNR, BI.cabin, BI.farebasis,
	   PB.ServiceFee as 'ServiceFees',
	 --    (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,
	   case when PM1.ParentOrderId is not null then PM1.payment_mode else PM.payment_mode end as payment_mode,
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	   --ISNULL(PB.B2bMarkup,0) +ISNULL(PB.BFC,0) as 'MarkupOnBaseFare' ,'' as MarkupOnTaxFare ,
	   '' as Narration,        
	   --BM.AgentROE as 'SalesExchangeRate',        
	   --BM.AgentCurrency as 'SalesCurrencyCode',        
	   PB.BaggageFare,        
	   --ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,        
	   BR.LocationCode, '' as BranchCode,'' as DivisionCode,        
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
	   when BM.VendorName='TravelFusion' then 'TF'
	   when BM.VendorName='TravelFusionNDC' then 'TFNDC'
	   Else BM.VendorName end as CRSCode,       
	   
	    --case when ED.AgentCountry='US' and BM.AgentCurrency = 'USD' then '0' 
	   --when ED.AgentCountry='CA' and BM.AgentCurrency = 'CAD' then '0' 
	   --else BM.AgentROE end as 'SalesCurrROE',
	   Case when ED.AgentCountry = ED.OwnerCountry then '0' else BM.AgentROE end as 'SalesCurrROE',
	   --BM.AgentCurrency as 'SalesCurr',    
	   --case when ED.AgentCountry='US' and BM.AgentCurrency = 'USD' then '' 
	   --when ED.AgentCountry='CA' and BM.AgentCurrency = 'CAD' then '' 
	   --else BM.AgentCurrency end as 'SalesCurr',
	   Case when ED.AgentCountry != ED.OwnerCountry and ED.OwnerCountry != ED.ERPCountry and ED.AgentCountry != ED.ERPCountry then BM.AgentCurrency else '' end as 'SalesCurr',
	   
	  case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else TOC.Currency end as 'PurchaseCurr',        
	   BM.ROE as 'PurchaseCurrROE',        
	   PB.baggage        
	  ,cast(((SSR.SSR_Amount ) /BM.ROE)as decimal(18,2)) as 'extrabagAmount', ISNULL(PM.AuthCode,'') as CVV,--1055 attribute       
	cast((isnull((CASE WHEN BM.B2bFareType=2 or BM.B2bFareType=3 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) as MarkupOnTax_,        
	(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) +PB.BFC) as MarkupOnFare_        
	   ,--AC.type 'AirLineType'
	   case when BM.VendorName = 'Amadeus' then 'FSC' when BM.VendorName = 'Sabre' then 'FSC' else AC.type end as 'AirLineType',
	   case when PM1.ParentOrderId is not null  then PM1.bank_ref_no else PM.bank_ref_no end as TransactionNo
	   ,ISNULL(ATT.CostCenter,'') as _str1060, ISNULL(ATT.Traveltype,'')  as _str1061 ,ISNULL(ATT.EmpDimession,'')  as _str1028, ISNULL(ATT.Changedcostno,'')  as _str1025,
	   ISNULL(ATT.Travelduration,'')  as _str1054, ISNULL(ATT.TASreqno,'')  as _str1022, ISNULL(ATT.Companycodecc,'')  as _str1023, ISNULL(ATT.Projectcode,'') as _str1024
	   , Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans   
	   FROM tblBookMaster BM WITH (NOLOCK)
	   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id   
	   LEFT JOIN Paymentmaster PM1 WITH (NOLOCK) ON BM.orderId = PM1.ParentOrderId
	   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID       LEFT JOIN mUser U on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null        
	   LEFT JOIN B2BRegistration BR1 WITH (NOLOCK) ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null        
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
	   LEFT JOIN tblOwnerCurrency TOC WITH (NOLOCK) ON TOC.OfficeID = BM.OfficeID        
	   LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode and AM.Status = 'A'       
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   left join tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1        
	   WHERE
	   BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'      
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and BM.BookingStatus IN(1,6)  --As confirm with Mansavee        
	   and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)           
	   and BM.inserteddate > (Getdate()-31) -- '2021-07-31 23:59:59.999'        
	   and ED.AgentCountry in ('US','CA')--('IN','AE','US','CA')   
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country        
	   and AL.userTypeID in (2) --For US usertype is 2 ***           
	   and BM.VendorName Not in ('STS')
	   and BM.totalFare > 0
	   --and PB.ticketnumber != null
	   --and BM.riyaPNR in ('X3K5Z5')
	  --and BM.GDSPNR = '36BGXH'
	   ORDER BY BM.IssueDate DESC    
	  END        
         
	IF @Action = 'US-CACancellationtickets'        
	  BEGIN        
	   SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, BM.bookingStatus,
	   --ED.VendorCode,
	   case when BM.BookingSource = 'GDS' then 'TJQ' else 'TrvlNxt' end as BookingType,
	  case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount 
	   ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	   BBM.TotalCommission as Surcharge,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  when BM.OfficeID = '00FK' and ED.AgentCountry = 'US' Then 'UVEND01206'
	  else ED.VendorCode end as VendorCode,
	   BM.pkId, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,        
	   BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,   
	 --    (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,
	   BM.arrivalTime, case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP, PB.FMCommission,
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'  
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
	   BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment, PB.CancelledDate as PostingDate, 
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,BM.orderId,        
	   PB.pid, PB.title, PB.ticketNum, PB.pid, PB.basicFare + isnull(PB.Markup,0) + isnull(PB.LonServiceFee,0) as basicFare, PB.totalTax, PB.paxType,       PB.YMTax,  
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,        
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,  PB.WOTax,      
	   PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,        
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
	   ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,        
	   Icast,BR.LocationCode, '' as BranchCode,'' as DivisionCode,        
	   ERP.Canfees, ERP.ServiceFees,
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	   ERP.MarkuponPenalty, ERP.Narration,         
	   case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   AM.Ticketcode as airlinecode,        
	   --AC.type 'AirLineType'    
	   case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'
	   FROM tblBookMaster BM WITH (NOLOCK)
	   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
	   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID        
	   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID        
	   LEFT JOIN TBL_ERP_RefundProcess ERP WITH (NOLOCK) ON ERP.PBID = PB.pid        
	   LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode 
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID 
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   WHERE
	   BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'     
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and PB.BookingStatus IN(4,11) --As confirm with Mansavee        
	   and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)           
	   and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'        
	   and ED.AgentCountry in ('US','CA')        
	   and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country       
	   and AL.userTypeID in (2) --For US CA usertype is 2 ***  
	   and BM.VendorName Not in ('STS')
	   and BM.totalFare > 0
	   --and PB.TicketNumber = '6024766875'
	    --and bm.riyaPNR  In ('8CU3A1')
	   ORDER BY BM.IssueDate DESC        
	  END     
  
	IF @Action = 'US_CAD_MCO_Bookingtickets' 
	  BEGIN        
	   SELECT TOP 10000 --PB.TicketNumber,PB.ERPResponseID,PB.ERPPuststatus,PB.ERPMcoResponseID,PB.ERPMcoPushstatus,
	   Case When PB.MCOTicketNo like '%-%' 
					Then substring(stuff(PB.MCOTicketNo,1,4,''),1,10)
					when LEN(PB.MCOTicketNo) = 10 then PB.MCOTicketNo
					Else substring(stuff(PB.MCOTicketNo,1,3,''),1,10)End As MCOTicketNo,
	   case when BM.BookingSource = 'GDS' then 'TJQ' else 'TrvlNxt' end as BookingType,
	   (Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	   case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	   PB.MCOAmount,BM.MCOAmount,ED.AgentCountry,ED.OwnerCountry,ED.ERPCountry,BM.MainAgentId,U.UserName,BM.bookingStatus, isnull(BM.IssueDate, BM.inserteddate) as PostingDate,
	   --ED.VendorCode,
	 --    (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, 
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,
	  -- Case	When PM.payment_mode='passThrough' then 'CUSTOMER'         
			--When PM.payment_mode='Credit' then 'CORPORATE'         
			--Else 'CASH' End As UATP,
	   PB.pid,BM.pkId,ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,PB.FMCommission,BBM.TotalCommission as Surcharge,
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'  
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else TOC.IATA end as IATA,
	   ISNULL(BR.Icast,BR1.Icast) As 'Icast',BM.riyaPNR,BM.inserteddate,BM.CounterCloseTime,BM.RegistrationNumber,
	   BM.IssueDate,BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No, BM.IATACommission,BM.deptTime,BM.arrivalTime, BM.frmSector,BM.toSector,
	   BM.flightNo, BM.travClass,BM.AgentID, BM.Country, BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',
	   BM.VendorCommissionPercent, case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,
	   BM.orderId,PB.title, PB.paxType,PB.paxFName,PB.paxLName,
	   ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') 'PaxName',PB.basicFare + isnull(PB.Markup,0) + isnull(PB.LonServiceFee,0) 'basicFare',PB.totalTax,
	   BM.totalFare,PB.MCOAmount,
	   cast((Isnull(PB.MCOAmount,0)-Isnull(PB.MCOAmount,0)*3.5/100)as decimal(18,2)) as McoCommissionAmount,PB.managementfees,
	   PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,BM.AgentMarkup,PB.JNTax as 'K3Tax',PB.YRTax, PB.YQ, PB.INTax, PB.JNTax,PB.OCTax,
	   PB.ExtraTax,PB.RFTax,PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,
	   --BI.airlinePNR, BI.cabin, BI.farebasis,        
	   PB.ServiceFee as 'ServiceFees', ISNULL(PB.B2bMarkup,0) +ISNULL(PB.BFC,0) as 'MarkupOnBaseFare' ,'' as MarkupOnTaxFare , '' as Narration,        
	   --BM.AgentROE as 'SalesExchangeRate',BM.AgentCurrency as 'SalesCurrencyCode',        
	   PB.BaggageFare,        
	   --ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,        
	   BR.LocationCode, '' as BranchCode,'' as DivisionCode,        
	   ------ERP.Canfees, ERP.ServiceFees, ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare, ERP.MarkuponPenalty, ERP.Narration,        
	   AM.Ticketcode as airlinecode,        
	   Case When BM.CounterCloseTime = 1 Then 'AIR-DOM' Else 'AIR-INT' End As productType,
	   '' as FormOfPayment,  -- Need to check with manasvee        
	   --1 for domestic        
	   BM.IssueBy as 'TicketinguserID',        
	   BM.BookedBy as 'BookinguserID',        
	   case when BM.VendorName='Amadeus' then '1A'         
	   when BM.VendorName='Galileo' then '1G'         
	   when BM.VendorName='Sabre' then '1S'
	   when BM.VendorName='TravelFusion' then 'TF'
	   when BM.VendorName='TravelFusionNDC' then 'TFNDC'
	   Else BM.VendorName end as CRSCode,         
	   BM.AgentROE as 'SalesCurrROE',        
	   BM.AgentCurrency as 'SalesCurr',        
	   case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else TOC.Currency end as 'PurchaseCurr',        
	   BM.ROE as 'PurchaseCurrROE',        
	   PB.baggage        
	   ,SSR.SSR_Amount as 'extrabagAmount',        
		cast((isnull((CASE WHEN BM.B2bFareType=2 or BM.B2bFareType=3 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) as MarkupOnTax_,        
		(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) +PB.BFC) as MarkupOnFare_   ,     
	   --,AC.type 'AirLineType'
	   case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'
	   FROM tblBookMaster BM WITH (NOLOCK)
		   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
		   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
		   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID       LEFT JOIN mUser U on BM.MainAgentId = U.ID        
		   --LEFT JOIN mAttrributesDetails ATT ON PB.pid = ATT.fkPassengerid
		   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
		   LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null        
		   LEFT JOIN B2BRegistration BR1 WITH (NOLOCK) ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null        
		   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
		   LEFT JOIN tblOwnerCurrency TOC WITH (NOLOCK) ON TOC.OfficeID = BM.OfficeID        
		   LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
		   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
		   left join tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1        
		   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
		   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'
	       and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
		   and BM.BookingStatus IN(1,6)  --As confirm with Mansavee
		   and PB.ERPMcoResponseID is null and (PB.ERPMcoPushStatus = 0 or PB.ERPMcoPushStatus is null)           
		   and PB.MCOTicketNo is not null and PB.MCOTicketNo !=''
		   and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'        
		   and ED.AgentCountry in ('US','CA')--('IN','AE','US','CA')     
		   and BM.totalFare > 0
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
					when LEN(PB.MCOTicketNo) = 10 then PB.MCOTicketNo
					Else substring(stuff(PB.MCOTicketNo,1,3,''),1,10)End As MCOTicketNo
		,U.UserName,BM.bookingStatus,PB.FMCommission, BBM.TotalCommission as Surcharge,
		(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
		--ED.VendorCode,
		case when BM.BookingSource = 'GDS' then 'TJQ' else 'TrvlNxt' end as BookingType,
		--  (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, 
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
		BM.pkId,PB.pid,BM.riyaPNR,BM.inserteddate,BM.CounterCloseTime, 
		case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
		BM.RegistrationNumber,BM.IssueDate,BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,
		case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'  
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else CU.IATA end as IATA,
		BM.frmSector,BM.toSector,BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,        
		BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, 
		BM.orderId,PB.title,PB.basicFare + isnull(PB.Markup,0) + isnull(PB.LonServiceFee,0) as basicFare,BM.totalFare,PB.totalTax,
		PB.MCOAmount,ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.CancelledDate as PostingDate,
		cast((Isnull(BM.MCOAmount,0)-Isnull(BM.MCOAmount,0)*3.5/100)as decimal(18,2)) as McoCommissionAmount,
		PB.paxType,PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,PB.managementfees,PB.baggage,
		case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax,PM.CardType, PM.MaskCardNumber as 'CardNumber',PM.mer_amount, PM.billing_address,
		PM.billing_name,PM.order_id, PM.tracking_id,        
		--BI.airlinePNR, BI.cabin, BI.farebasis,
		ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,Icast,BR.LocationCode, '' as BranchCode,'' as DivisionCode,
		ERP.Canfees, ERP.ServiceFees, 
		cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
		--ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
		ERP.MarkuponPenalty, ERP.Narration,
		Case When BM.CounterCloseTime = 1 Then 'AIR-DOM' Else 'AIR-INT' End As productType,
		'' as FormOfPayment,  -- Need to check with manasvee        
		--1 for domestic        
		AM.Ticketcode as airlinecode,        
		--AC.type 'AirLineType'
		case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'
		From tblBookMaster BM WITH (NOLOCK)
			LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
			LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id        
			LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID        
			LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID        
			LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
			LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
			LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID        
			LEFT JOIN TBL_ERP_RefundProcess ERP WITH (NOLOCK) ON ERP.PBID = PB.pid        
			LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
			--LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
			LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode 
			LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID 
			LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
			LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
		Where BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'
		    and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
			And PB.BookingStatus IN(4,11) --As confirm with Mansavee
			And PB.CannERPMcoResponseID is null and (PB.CannERPMcoPushStatus = 0 or PB.CannERPMcoPushStatus is null)
			and PB.MCOTicketNo is not null and PB.MCOTicketNo !=''
			and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'        
			and ED.AgentCountry in ('US','CA')
			and BM.totalFare > 0
			And ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country
			And AL.userTypeID = 2 --For US CA usertype is 2 ***  
			and BM.VendorName Not in ('STS')
			And PB.MCOTicketNo is not null
			ORDER BY BM.IssueDate DESC
	  END 
	  IF @Action = 'SSRERPPush'
	  BEGIN        
	     SELECT TOP 10000 SSR.ERPTicketNum, ED.AgentCountry,ED.OwnerCountry, ED.ERPCountry, BM.MainAgentId,SSR.ParentOrderId,SSR.ERPPushStatus    
	   ,case when al.userTypeID = 5 then '' else  U.EmployeeNo end as UserName, 
	   BM.bookingStatus, ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.FMCommission, 
	   --ED.VendorCode,
	   case when BM.BookingSource = 'GDS' then 'TJQ' else 'TrvlNxt' end as BookingType,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,        
	   --case when PM.payment_mode='passThrough' then 'CUSTOMER'         
	   --when PM.payment_mode='Credit' then 'CORPORATE'         
	   --Else 'CASH' end as UATP,        
	   BBM.TotalCommission as Surcharge,
	   PB.pid,BM.pkId, PB.IATACommission as CustIATACommAmount 
	   ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,
	   isnull(BM.IssueDate, BM.inserteddate) as PostingDate,
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	   PM.MaskCardNumber as 'CardNumber',
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'  
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else TOC.IATA end as IATA,
	   ISNULL(BR.Icast, BR1.Icast) as 'Icast', BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime,        
	   BM.RegistrationNumber, BM.IssueDate,BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	   BM.arrivalTime, BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, ED.OwnerID,ED.ERPCountry, BM.orderId,        
		PB.title, PB.TicketNumber, PB.basicFare + isnull(PB.Markup,0) + isnull(PB.LonServiceFee,0) as basicFare, PB.totalTax, PB.paxType, PB.JNTax as 'K3Tax',        
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	BM.AgentMarkup,        
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax, PB.RFTax, PB.WOTax,  PB.YMTax,     
	   PM.CardType, PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,
	   --BI.airlinePNR, BI.cabin, BI.farebasis,
	   PB.ServiceFee as 'ServiceFees',
	 --    (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, 
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	   --ISNULL(PB.B2bMarkup,0) +ISNULL(PB.BFC,0) as 'MarkupOnBaseFare' ,'' as MarkupOnTaxFare ,
	   '' as Narration,        
	   --BM.AgentROE as 'SalesExchangeRate',        
	   --BM.AgentCurrency as 'SalesCurrencyCode',        
	   PB.BaggageFare,        
	   --ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,        
	   BR.LocationCode, '' as BranchCode,'' as DivisionCode,        
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
	   when BM.VendorName='TravelFusion' then 'TF'
	   when BM.VendorName='TravelFusionNDC' then 'TFNDC'
	   Else BM.VendorName end as CRSCode, 	   
	    --case when ED.AgentCountry='US' and BM.AgentCurrency = 'USD' then '0' 
	   --when ED.AgentCountry='CA' and BM.AgentCurrency = 'CAD' then '0' 
	   --else BM.AgentROE end as 'SalesCurrROE',
	   Case when ED.AgentCountry = ED.OwnerCountry then '0' else BM.AgentROE end as 'SalesCurrROE',
	   --BM.AgentCurrency as 'SalesCurr',    
	   --case when ED.AgentCountry='US' and BM.AgentCurrency = 'USD' then '' 
	   --when ED.AgentCountry='CA' and BM.AgentCurrency = 'CAD' then '' 
	   --else BM.AgentCurrency end as 'SalesCurr',
	   Case when ED.AgentCountry != ED.OwnerCountry and ED.OwnerCountry != ED.ERPCountry and ED.AgentCountry != ED.ERPCountry then BM.AgentCurrency else '' end as 'SalesCurr',
	   
	   case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else TOC.Currency end as 'PurchaseCurr',        
	   BM.ROE as 'PurchaseCurrROE',        
	   PB.baggage        
	  ,cast(((SSR.SSR_Amount ) /BM.ROE)as decimal(18,2)) as 'extrabagAmount', ISNULL(PM.AuthCode,'') as CVV,--1055 attribute       
	cast((isnull((CASE WHEN BM.B2bFareType=2 or BM.B2bFareType=3 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) as MarkupOnTax_,        
	(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) +PB.BFC) as MarkupOnFare_        
	   ,--AC.type 'AirLineType'
	   case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'
	   ,ISNULL(ATT.CostCenter,'') as _str1060, ISNULL(ATT.Traveltype,'')  as _str1061 ,ISNULL(ATT.EmpDimession,'')  as _str1028, ISNULL(ATT.Changedcostno,'')  as _str1025,
	   ISNULL(ATT.Travelduration,'')  as _str1054, ISNULL(ATT.TASreqno,'')  as _str1022, ISNULL(ATT.Companycodecc,'')  as _str1023, ISNULL(ATT.Projectcode,'') as _str1024
	   , Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans   
	   FROM tblBookMaster BM WITH (NOLOCK)
	   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id
	   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID       LEFT JOIN mUser U on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null        
	   LEFT JOIN B2BRegistration BR1 WITH (NOLOCK) ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null        
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
	   LEFT JOIN tblOwnerCurrency TOC WITH (NOLOCK) ON TOC.OfficeID = BM.OfficeID        
	   LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   left join tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Status=1        
	   WHERE
	   BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'    
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and BM.BookingStatus IN(1,6)  --As confirm with Mansavee        
	   and PB.ERPResponseID is not null and (PB.ERPPuststatus != 0 or PB.ERPPuststatus is not null)           
	   and (SSR.ERPResponseID is null or SSR.ERPResponseID = '') and (SSR.ERPPushStatus is null or SSR.ERPPushStatus = '')
	   and SSR.ERPTicketNum is not null
	   and BM.inserteddate > (Getdate()-31) -- '2021-07-31 23:59:59.999'
	   and BM.totalFare > 0	   
	   --and BM.riyaPNR = '95QT5L'
	   ORDER BY BM.IssueDate DESC    
	  END

	  IF @Action = 'SSRCanERPPush'
	  BEGIN        
	     SELECT TOP 10000 SSR.ERPTicketNum, ED.AgentCountry,ED.OwnerCountry, ED.ERPCountry, BM.MainAgentId,SSR.ParentOrderId,SSR.ERPPushStatus    
	   ,U.EmployeeNo as UserName, BM.bookingStatus, ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.FMCommission, 
	   --ED.VendorCode,
	   case when BM.BookingSource = 'GDS' then 'TJQ' else 'TrvlNxt' end as BookingType,
	  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913' 
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'
	  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'
	  else ED.VendorCode end as VendorCode,       
	   --case when PM.payment_mode='passThrough' then 'CUSTOMER'         
	   --when PM.payment_mode='Credit' then 'CORPORATE'         
	   --Else 'CASH' end as UATP,        
	   BBM.TotalCommission as Surcharge,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,
	   PB.pid,BM.pkId, PB.IATACommission as CustIATACommAmount ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission,  PB.CancelledDate as PostingDate,
	   case when BM.BookingSource = 'Retrive PNR Accounting' THEN PB.FMCommission 
       when BM.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN PB.FMCommission 
       when BM.BookingSource ='GDS' THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Retrive PNR' and PB.Markup >0)
       THEN PB.Markup
       when (BM.BookingSource ='Web' and PB.FMCommission >0)
       THEN PB.FMCommission
       when (BM.BookingSource ='Web' and PB.Markup >0)
       THEN PB.Markup
       ELSE PB.Markup END AS VendIATACommAmount,
	   case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,
	   PM.MaskCardNumber as 'CardNumber',
	   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'  
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'      
		   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'      
		   else TOC.IATA end as IATA,
	   ISNULL(BR.Icast, BR1.Icast) as 'Icast', BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime,        
	   BM.RegistrationNumber, BM.IssueDate,BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,        
	   BM.arrivalTime, BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,        
	   BM.totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,        
	   BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent, 
	   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, ED.OwnerID,ED.ERPCountry, BM.orderId,        
		PB.title, PB.TicketNumber, PB.basicFare + isnull(PB.Markup,0) + isnull(PB.LonServiceFee,0) as basicFare, PB.totalTax, PB.paxType, PB.JNTax as 'K3Tax',        
	   PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,         
	   PB.managementfees, PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,	BM.AgentMarkup,        
	   PB.YRTax, PB.YQ, PB.INTax, PB.JNTax, PB.OCTax, PB.ExtraTax, PB.RFTax, PB.WOTax,  PB.YMTax,     
	   PM.CardType, PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,
	   --BI.airlinePNR, BI.cabin, BI.farebasis,
	   PB.ServiceFee as 'ServiceFees',
	 --    (select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Baggage' and s.SSR_Status=1 and SSR_Amount>0)  
		--as ExtraBaggage,   
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Seat' and s.SSR_Status=1 and SSR_Amount>0)
		--as SeatPreferenceCharge,    
		--(select sum(SSR_Amount)  from tblSSRDetails s
		--where fkPassengerid in (select pid from tblPassengerBookDetails where  paxFName+isnull(paxLName,'')
		--in (select paxFName+isnull(paxLName,'') from tblPassengerBookDetails where pid=PB.pid))
		--and s.fkBookMaster in (select pkid from tblBookMaster where fkBookMaster=BM.pkId) and SSR_Type='Meals' and s.SSR_Status=1 and SSR_Amount>0)
		--as MealCharges,
	   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales, 
	   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,
			(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,
		   --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,
	   --ISNULL(PB.B2bMarkup,0) +ISNULL(PB.BFC,0) as 'MarkupOnBaseFare' ,'' as MarkupOnTaxFare ,
	   '' as Narration,        
	   --BM.AgentROE as 'SalesExchangeRate',        
	   --BM.AgentCurrency as 'SalesCurrencyCode',        
	   PB.BaggageFare,        
	   --ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,        
	   BR.LocationCode, '' as BranchCode,'' as DivisionCode,        
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
	   when BM.VendorName='TravelFusion' then 'TF'
	   when BM.VendorName='TravelFusionNDC' then 'TFNDC'
	   Else BM.VendorName end as CRSCode, 	   
	    --case when ED.AgentCountry='US' and BM.AgentCurrency = 'USD' then '0' 
	   --when ED.AgentCountry='CA' and BM.AgentCurrency = 'CAD' then '0' 
	   --else BM.AgentROE end as 'SalesCurrROE',
	   Case when ED.AgentCountry = ED.OwnerCountry then '0' else BM.AgentROE end as 'SalesCurrROE',
	   --BM.AgentCurrency as 'SalesCurr',    
	   --case when ED.AgentCountry='US' and BM.AgentCurrency = 'USD' then '' 
	   --when ED.AgentCountry='CA' and BM.AgentCurrency = 'CAD' then '' 
	   --else BM.AgentCurrency end as 'SalesCurr',
	   Case when ED.AgentCountry != ED.OwnerCountry and ED.OwnerCountry != ED.ERPCountry and ED.AgentCountry != ED.ERPCountry then BM.AgentCurrency else '' end as 'SalesCurr',
	   
	   case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else TOC.Currency end as 'PurchaseCurr',        
	   BM.ROE as 'PurchaseCurrROE',        
	   PB.baggage        
	  ,cast(((SSR.SSR_Amount ) /BM.ROE)as decimal(18,2)) as 'extrabagAmount', ISNULL(PM.AuthCode,'') as CVV,--1055 attribute       
	cast((isnull((CASE WHEN BM.B2bFareType=2 or BM.B2bFareType=3 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) as MarkupOnTax_,        
	(cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) +PB.BFC) as MarkupOnFare_        
	   ,--AC.type 'AirLineType'
	   case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'
	   ,ISNULL(ATT.CostCenter,'') as _str1060, ISNULL(ATT.Traveltype,'')  as _str1061 ,ISNULL(ATT.EmpDimession,'')  as _str1028, ISNULL(ATT.Changedcostno,'')  as _str1025,
	   ISNULL(ATT.Travelduration,'')  as _str1054, ISNULL(ATT.TASreqno,'')  as _str1022, ISNULL(ATT.Companycodecc,'')  as _str1023, ISNULL(ATT.Projectcode,'') as _str1024
	   , Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans   
	   FROM tblBookMaster BM WITH (NOLOCK)
	   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster        
	   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id
	   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID       LEFT JOIN mUser U on BM.MainAgentId = U.ID        
	   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid
	   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID        
	   LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null        
	   LEFT JOIN B2BRegistration BR1 WITH (NOLOCK) ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null        
	   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
	   LEFT JOIN tblOwnerCurrency TOC WITH (NOLOCK) ON TOC.OfficeID = BM.OfficeID        
	   LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode        
	   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber
	   --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId        
	   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId
	   left join tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Status=1        
	   WHERE
	   BM.IsBooked =1 and BM.totalFare > 0 --and BM.AgentID != 'B2C'  
	   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)
	   and PB.BookingStatus IN(4,11) --As confirm with Mansavee        
	   and PB.CancERPResponseID is not null and (PB.CancERPPuststatus != 0 or PB.CancERPPuststatus is not null)           
	   and (SSR.CancERPResponseID is null or SSR.CancERPResponseID = '') and SSR.CancERPPuststatus is null
	   and SSR.ERPTicketNum is not null
	   and BM.inserteddate > (Getdate()-360) -- '2021-07-31 23:59:59.999'
	   and BM.totalFare > 0
	   --and BM.riyaPNR = '244SH3'
	   ORDER BY BM.IssueDate DESC    
	  END

	  IF @Action = 'SSRData'
	  BEGIN     
	  if(@flag = 'Book')
	  BEGIN
		SELECT * from tblSSRDetails where ParentOrderId = @orderId 
		and fkPassengerid = @tblPassengerid and (ERPResponseID = '' or ERPResponseID is null) and (ERPPushStatus = '' or ERPPushStatus is null)
	  END
	  if(@flag = 'Cancel')
	  BEGIN
		SELECT * from tblSSRDetails where ParentOrderId = @orderId 
		and fkPassengerid = @tblPassengerid --and (CancERPResponseID = '' or CancERPResponseID is null) and (CancERPPuststatus = '' or CancERPPuststatus is null)
	  END
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
	   Select BI.*, AM.TicketCode as Airlinenumber, BM.IssueDate, BM.basicFare + isnull(PB.LonServiceFee,0) as basicFare, BM.totalTax, BM.totalFare, PB.CancellationPenalty, 'FIRST'+PB.DiscriptionTax as Taxdesc,        
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