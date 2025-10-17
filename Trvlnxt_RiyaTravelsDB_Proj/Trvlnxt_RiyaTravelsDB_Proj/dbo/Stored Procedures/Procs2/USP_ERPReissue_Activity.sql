CREATE PROCEDURE [dbo].[USP_ERPReissue_Activity] --'CABookingtickets','','WGZVFE-1',''    
@Action varchar(50)=null,    
 @orderId varchar(100) =null,    
 @tblPassengerid varchar(100) = null,   
 @erpTicketNum varchar(100) = null,  
 @Ticketnumber varchar(50)=null  
  
AS            
BEGIN            
               
 IF @Action = 'B2BReissueBookingTickets'            
  BEGIN            
  SELECT TOP 10000 PB.ticketnumber,pb.pid,
PB1.TicketNumber AS OLDTicketNo,PB.EMDNumber,Bm.bookingstatus,
U.EmployeeNo as UserName, ED.AgentCountry,     
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
   ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,  
   Cast(isnull(PB.IATACommission,0) as decimal(18,2)) as CustIATACommAmount ,  
      (Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + 
   Cast(isnull(PB.DropnetCommission,0) as decimal(18,2))) as PLBCommission,
    Cast(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,
   BBM.TotalCommission as Surcharge,    
   --case when AC.type = 'FSC' then BM.GDSPNR else BI.airlinePNR end as PNRNo,    
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913'     
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'    
   else ED.VendorCode end as VendorCode,PM.payment_mode,    
   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,ED.OwnerID,    
   BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,  
   BM.CounterCloseTime, isnull(BM.IssueDate, BM.inserteddate)   
   as PostingDate,    
   case when PM.CardConfigurationType = 'Riya'  
   THEN 'CORPORATE' when PM.CardConfigurationType = 'Customer'  
   THEN 'CUSTOMER'   
   else '' END as UATP, PB.FMCommission,     
   BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,            
   BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',            
   BM.VendorCommissionPercent,PB.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,    
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'           
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'          
     else CU.IATA end as IATA,    
     case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,     
   case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end as 'Currency'    
   ,BM.ROE,            
   BM.RegistrationNumber,PB.title,PB.TicketNumber,
      PB.paxType,PB.paxFName,PB.paxLName,            
   PB.managementfees,left(PB.baggage,29) as baggage,  
   case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0
   end as Markup,  

 -- Basic Fare
CASE 
    WHEN (ISNULL(PB.basicFare, 0) + ISNULL(PB.LonServiceFee, 0)) - 
         (ISNULL(PB1.basicFare, 0) + ISNULL(PB1.LonServiceFee, 0)) < 0 
    THEN 0
    ELSE (ISNULL(PB.basicFare, 0) + ISNULL(PB.LonServiceFee, 0)) - 
         (ISNULL(PB1.basicFare, 0) + ISNULL(PB1.LonServiceFee, 0))
END AS basicFare,

-- Total Tax
CASE 
    WHEN ISNULL(PB.totalTax, 0) - ISNULL(PB1.totalTax, 0) < 0 
    THEN 0
    ELSE ISNULL(PB.totalTax, 0) - ISNULL(PB1.totalTax, 0)
END AS totalTax,

-- YR Tax
CASE 
    WHEN ISNULL(PB.YRTax, 0) - ISNULL(PB1.YRTax, 0) < 0 
    THEN 0
    ELSE ISNULL(PB.YRTax, 0) - ISNULL(PB1.YRTax, 0)
END AS YRTax,

-- YQ Tax
CASE 
    WHEN ISNULL(TRY_CAST(PB.YQ AS decimal(18,2)), 0) - ISNULL(TRY_CAST(PB1.YQ AS decimal(18,2)), 0) < 0 
    THEN 0 
    ELSE ISNULL(TRY_CAST(PB.YQ AS decimal(18,2)), 0) - ISNULL(TRY_CAST(PB1.YQ AS decimal(18,2)), 0)
END AS YQ,

-- INTax
CASE 
    WHEN ISNULL(PB.INTax, 0) - ISNULL(PB1.INTax, 0) < 0 
    THEN 0 
    ELSE CAST(ISNULL(PB.INTax, 0) - ISNULL(PB1.INTax, 0) AS decimal(18,2)) 
END AS INTax,

-- JNTax
CASE 
    WHEN (ISNULL(PB.JNTax, 0) + ISNULL(PB.k7tax, 0)) - (ISNULL(PB1.JNTax, 0) + ISNULL(PB1.k7tax, 0)) < 0 
    THEN 0 
    ELSE (ISNULL(PB.JNTax, 0) + ISNULL(PB.k7tax, 0)) - (ISNULL(PB1.JNTax, 0) + ISNULL(PB1.k7tax, 0)) 
END AS JNTax,

-- OCTax
CASE 
    WHEN ISNULL(PB.OCTax, 0) - ISNULL(PB1.OCTax, 0) < 0 
    THEN 0 
    ELSE CAST(ISNULL(PB.OCTax, 0) - ISNULL(PB1.OCTax, 0) AS decimal(18,2)) 
END AS OCTax,

-- ExtraTax
CASE 
    WHEN ISNULL(PB.ExtraTax, 0) - ISNULL(PB1.ExtraTax, 0) < 0 
    THEN 0 
    ELSE CAST(ISNULL(PB.ExtraTax, 0) - ISNULL(PB1.ExtraTax, 0) AS decimal(18,2)) 
END AS ExtraTax,

-- WOTax
CASE 
    WHEN ISNULL(PB.WOTax, 0) - ISNULL(PB1.WOTax, 0) < 0 
    THEN 0 
    ELSE CAST(ISNULL(PB.WOTax, 0) - ISNULL(PB1.WOTax, 0) AS decimal(18,2)) 
END AS WOTax,

-- YMTax
CASE 
    WHEN ISNULL(PB.YMTax, 0) - ISNULL(PB1.YMTax, 0) < 0 
    THEN 0 
    ELSE CAST(ISNULL(PB.YMTax, 0) - ISNULL(PB1.YMTax, 0) AS decimal(18,2)) 
END AS YMTax,
PB.BaggageFare,PM.CardType,            
   PM.MaskCardNumber as 'CardNumber',PM.mer_amount,PM.billing_address,  
   PM.billing_name,BM.orderId order_id,PM.tracking_id,
  ATT.VesselName, REPLACE(ATT.TR_POName, '&', 'and') as TR_POName,
  ATT.Bookedby,ATT.AType,ATT.RankNo,    
   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,    
   (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,     
   case when Attsp.FKUserID is not null then     
 case when ED.OwnerCountry = 'US' then 'UCUST00505'     
 when ED.OwnerCountry = 'CA' then 'CCUST00004' when ED.OwnerCountry = 'AE' then 'CUST000324'     
 else     
 Case When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode       
  end    
 end    
 when Attsp.FKUserID is null then     
 Case When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode       
  end    
 else B2BR.Icast end as 'Icast',Attsp.FKUserID as AttFKUserID,    
   B2BR.LocationCode, BranchCode = '', PR.EmpCode,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',ATT.OBTCno    
     ,BM.AgentROE as 'SalesCurrROE',            
    BM.AgentCurrency as 'SalesCurr',            
    case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else CU.Currency end as 'PurchaseCurr',            
    BM.ROE as 'PurchaseCurrROE'    
    ,Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans,  
	PB.EMDNumber,case when PB.EMDNumber is null then
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) 
  else
   '0.00' end
  as AirlineFee ,'' as 'TicketType','Date Change' as EntryType,PB.EMDStatus,
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) as AirlineFee1 
   FROM tblBookMaster BM WITH (NOLOCK)   
   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster            
   LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid   
   INNER JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id              
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
   LEFT Join mCardDetails CD WITH (NOLOCK) ON RIGHT(CD.MaskCardNumber,4)=RIGHT(PM.MaskCardNumber,4)    
   AND CD.MarketPoint=BM.Country AND CD.STATUS=1 and CD.UserType = (Select value from mcommon where category='Usertype' and Id=2)    
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
   and PM.payment_mode is not null  
   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country             
   and AL.userTypeID IN(2) --For B2B usertype is 2 ***    
  -- and BM.riyaPNR = @Riyapnr   
   and BM.VendorName Not in ('STS')   
   AND  EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM1  
    WHERE BM.PARENTORDERID = BM1.ORDERID AND BM1.bookingstatus=18  
)  
   ORDER BY BM.inserteddate DESC            
  END 

 IF @Action = 'B2BReissueCancellationTickets'          
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
    Cast(isnull(PB.IATACommission,0) as decimal(18,2)) as CustIATACommAmount ,
	(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)) + CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) + CAST(isnull(PB.tdsonplb ,0) as decimal(18,2))) as PLBCommission, PB.CancelledDate as PostingDate,  
    case when AC.type = 'FSC' then BM.GDSPNR else BI.airlinePNR end as PNRNo,  
    case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP, PB.FMCommission,   
    case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10 then 'BOMVEND007913'   
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'  
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'  
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'  
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'  
   else ED.VendorCode end as VendorCode,  
    BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber,BM.IssueDate,          
    BM.inserteddate_old as canceledDate,BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime, BM.arrivalTime,   
    case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10 then 'RIYAAPITF'         
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'        
     else CU.IATA end as IATA,  
    BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.FMCommission,  
    PB.RefundAmount as totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,          
    BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent,   
    case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID, BM.orderId,          
    PB.pid, PB.title, PB.ticketNum, PB.pid,
	PB.RefundAmount as basicFare, '0.00' as totalTax, PB.paxType, BBM.TotalCommission as Surcharge,   
    case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,    
    PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,           
    '0.00' as managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,           
   '0.00' as YRTax, '0.00' as YQ, '0.00' as INTax, '0.00' as JNTax, 
   '0.00' as OCTax, '0.00' as ExtraTax,  '0.00' as YMTax,       
    PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount,
	PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,          
    --BI.airlinePNR, BI.cabin, BI.farebasis,          
    ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,  
    case when Attsp.FKUserID is not null then   
 case when ED.OwnerCountry = 'US' then 'UCUST00505'   
 when ED.OwnerCountry = 'CA' then 'CCUST00004' when ED.OwnerCountry = 'AE' then 'CUST000324'   
 else   
 Case When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast  
   When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode  
   When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode     
  end  
 end  
 when Attsp.FKUserID is null then   
 Case When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast  
   When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode  
   When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode     
  end  
 else BR.Icast end as 'Icast',Attsp.FKUserID as AttFKUserID,  
    BR.LocationCode, '' as BranchCode,'' as DivisionCode, PR.EmpCode,
	ATT.OBTCno,         
    '0.00' as Canfees, '0.00' as ServiceFees,   
    cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,  
   (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,  
       
    --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare  
    ERP.MarkuponPenalty,Replace(ERP.Narration,'&','and') as Narration,isnull(PB.CancellationPenalty,0) as CancellationPenalty ,   
    case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,          
    '' as FormOfPayment,  -- Need to check with manasvee          
    --1 for domestic          
    AM.Ticketcode as airlinecode,SSR.SSR_Amount as 'extrabagAmount',          
    --AC.type 'AirLineType'     
    case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType'  
    FROM tblBookMaster BM WITH (NOLOCK)  
    LEFT JOIN tblPassengerBookDetails PB  WITH (NOLOCK)ON BM.pkId = PB.fkBookMaster 
	 LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid 
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
    and BM.BookingStatus In(1) --As confirm with Mansavee           
    and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)             
    and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'  
    and BM.Country in ('IN')  
    and BM.AgentID not in (48210)  
    and BM.totalFare > 0  
    and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country       
    and AL.userTypeID = 2  
    and BM.VendorName Not in ('STS')
	AND PB.RefundAmount > 0
  -- and BM.riyaPNR = 'TRNYCL25X6'   
    ORDER BY BM.canceledDate DESC 	
   END
   
if @Action = 'EMDPendingTickets'
  BEGIN            
  SELECT TOP 10000 pb.EMDNumber as TicketNumber,pb.pid,
PB1.TicketNumber AS OLDTicketNo,PB.EMDNumber,1 as EMDStatus,
Bm.bookingstatus,U.EmployeeNo as UserName, ED.AgentCountry,     
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
   ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,  
   Cast(isnull(PB.IATACommission,0) as decimal(18,2)) as CustIATACommAmount ,  
   (Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) +   
   Cast(isnull(PB.DropnetCommission,0) as decimal(18,2))) as PLBCommission,  
    Cast(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,
   BBM.TotalCommission as Surcharge,    
   --case when AC.type = 'FSC' then BM.GDSPNR else BI.airlinePNR end as PNRNo,    
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913'     
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'    
   else ED.VendorCode end as VendorCode,PM.payment_mode,    
   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,ED.OwnerID,    
   BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,  
   BM.CounterCloseTime, isnull(BM.IssueDate, BM.inserteddate)   
   as PostingDate,    
   case when PM.CardConfigurationType = 'Riya'  
   THEN 'CORPORATE' when PM.CardConfigurationType = 'Customer'  
   THEN 'CUSTOMER'   
   else '' END as UATP, PB.FMCommission,     
   BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,            
   BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,
   Case when AC.type ='FSC' then BM.GDSPNR  
   else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',            
   BM.VendorCommissionPercent,
   0 as ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,    
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'           
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'          
     else CU.IATA end as IATA,    
     case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,     
   case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end as 'Currency'    
   ,BM.ROE,            
   BM.RegistrationNumber,PB.title,PB.TicketNumber,
      PB.paxType,PB.paxFName,PB.paxLName,            
 0 as managementfees,left(PB.baggage,29) as baggage,  
   case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0
   end as Markup, 
   0 AS basicFare,
0 AS totalTax,0 AS YRTax,0 AS YQ,0 AS INTax,0 AS JNTax,
0 AS OCTax,0 AS ExtraTax,0 AS WOTax,0 AS YMTax,

--BI.airlinePNR,BI.cabin,BI.farebasis,
PB.BaggageFare,PM.CardType,            
   PM.MaskCardNumber as 'CardNumber',0 as mer_amount,PM.billing_address,  
   PM.billing_name,BM.orderId order_id,PM.tracking_id,
  ATT.VesselName, REPLACE(ATT.TR_POName, '&', 'and') as TR_POName,
  ATT.Bookedby,ATT.AType,ATT.RankNo,    
   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,    
   (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,     
   case when Attsp.FKUserID is not null then     
 case when ED.OwnerCountry = 'US' then 'UCUST00505'     
 when ED.OwnerCountry = 'CA' then 'CCUST00004' when ED.OwnerCountry = 'AE' then 'CUST000324'     
 else     
 Case When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode       
  end    
 end    
 when Attsp.FKUserID is null then     
 Case When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode       
  end    
 else B2BR.Icast end as 'Icast',Attsp.FKUserID as AttFKUserID,    
   B2BR.LocationCode, BranchCode = '', PR.EmpCode,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',ATT.OBTCno    
     ,BM.AgentROE as 'SalesCurrROE',            
    BM.AgentCurrency as 'SalesCurr',            
    case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else CU.Currency end as 'PurchaseCurr',            
    BM.ROE as 'PurchaseCurrROE'    
    ,Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans,  
	PB.EMDNumber,
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) as AirlineFee ,
  '' as 'TicketType','Date Change' as EntryType
   FROM tblBookMaster BM WITH (NOLOCK)   
   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster            
   LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid   
   INNER JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id              
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
   LEFT Join mCardDetails CD WITH (NOLOCK) ON RIGHT(CD.MaskCardNumber,4)=RIGHT(PM.MaskCardNumber,4)    
   AND CD.MarketPoint=BM.Country AND CD.STATUS=1 and CD.UserType = (Select value from mcommon where category='Usertype' and Id=2)    
   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId    
   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)    
   and BM.BookingStatus In(1,6) --As confirm with Mansavee            
   -- For Booking            
  -- and ISNULL(BM.ERPPush,0) = 0    
  -- and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)            
   and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'            
   and BM.Country in('IN')     
   and ISNULL(PB.EMDNumber,'') != ''
   and PB.EMDStatus=0
   and BM.AgentID not in (48210)    
   and BM.totalFare > 0   
   and PM.payment_mode is not null  
   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country             
   and AL.userTypeID IN(2) --For B2B usertype is 2 ***    
 --  and BM.riyaPNR = @Riyapnr   
   and BM.VendorName Not in ('STS')  
   and PB.EMDNumber is not null
   AND  EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM1  
    WHERE BM.PARENTORDERID = BM1.ORDERID AND BM1.bookingstatus=18  
)  
   ORDER BY BM.inserteddate DESC            
   END 
      
 IF @Action = 'RBTReissueBookingTickets'            
  BEGIN            
   SELECT TOP 10000 U.EmployeeNo as UserName,PB1.TicketNumber AS OLDTicketNo,    
  PB.EMDNumber,  
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
   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,     
   BM.pkId,  
   BM.riyaPNR,  
   BM.inserteddate,BM.IssueDate,BM.CounterCloseTime,   
    Cast(isnull(PB.IATACommission,0) as decimal(18,2)) as CustIATACommAmount,  
   (Cast(isnull(PB.PLBCommission,0) as decimal(18,2))  
   + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)))   
   as PLBCommission,Cast(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,  
   BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,            
   BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',            
    Case when BM.VendorCommissionPercent ='' then  
  '0.00'  
  else  
 BM.VendorCommissionPercent end as VendorCommissionPercent,PB.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,PB.FMCommission,    
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'           
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'          
     else CU.IATA end as IATA,PM.payment_mode,    
   case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end as 'Currency',BM.ROE,            
   BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.paxType,PB.pid,  
   PB.paxFName,PB.paxLName,substring(replace(PB.baggage,'&','and'),0,30) as baggage,
   case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,

-- Basic Fare
CASE 
    WHEN (ISNULL(PB.basicFare, 0) + ISNULL(PB.LonServiceFee, 0)) - 
         (ISNULL(PB1.basicFare, 0) + ISNULL(PB1.LonServiceFee, 0)) < 0 
    THEN 0
    ELSE (ISNULL(PB.basicFare, 0) + ISNULL(PB.LonServiceFee, 0)) - 
         (ISNULL(PB1.basicFare, 0) + ISNULL(PB1.LonServiceFee, 0))
END AS basicFare,

-- Total Tax
CASE 
    WHEN ISNULL(PB.totalTax, 0) - ISNULL(PB1.totalTax, 0) < 0 
    THEN 0
    ELSE ISNULL(PB.totalTax, 0) - ISNULL(PB1.totalTax, 0)
END AS totalTax,

-- Management Fees
CASE 
    WHEN ISNULL(PB.managementfees, 0) - ISNULL(PB1.managementfees, 0) < 0 
    THEN 0
    ELSE ISNULL(PB.managementfees, 0) - ISNULL(PB1.managementfees, 0)
END AS managementfees,

-- YR Tax
CASE 
    WHEN ISNULL(PB.YRTax, 0) - ISNULL(PB1.YRTax, 0) < 0 
    THEN 0
    ELSE ISNULL(PB.YRTax, 0) - ISNULL(PB1.YRTax, 0)
END AS YRTax,

-- YQ Tax
CASE 
    WHEN ISNULL(CAST(PB.YQ AS DECIMAL(18,2)), 0) - ISNULL(CAST(PB1.YQ AS DECIMAL(18,2)), 0) < 0 
    THEN 0
    ELSE ISNULL(CAST(PB.YQ AS DECIMAL(18,2)), 0) - ISNULL(CAST(PB1.YQ AS DECIMAL(18,2)), 0)
END AS YQ,

-- INTax
CASE 
    WHEN ISNULL(PB.INTax, 0) - ISNULL(PB1.INTax, 0) < 0 
    THEN 0
    ELSE ISNULL(PB.INTax, 0) - ISNULL(PB1.INTax, 0)
END AS INTax,

-- JNTax (including k7tax)
CASE 
    WHEN (ISNULL(PB.JNTax, 0) + ISNULL(PB.k7tax, 0)) - 
         (ISNULL(PB1.JNTax, 0) + ISNULL(PB1.k7tax, 0)) < 0 
    THEN 0
    ELSE (ISNULL(PB.JNTax, 0) + ISNULL(PB.k7tax, 0)) - 
         (ISNULL(PB1.JNTax, 0) + ISNULL(PB1.k7tax, 0))
END AS JNTax,

-- YMTax
CASE 
    WHEN ISNULL(PB.YMTax, 0) - ISNULL(PB1.YMTax, 0) < 0 
    THEN 0
    ELSE ISNULL(PB.YMTax, 0) - ISNULL(PB1.YMTax, 0)
END AS YMTax,

-- WOTax
CASE 
    WHEN ISNULL(PB.WOTax, 0) - ISNULL(PB1.WOTax, 0) < 0 
    THEN 0
    ELSE ISNULL(PB.WOTax, 0) - ISNULL(PB1.WOTax, 0)
END AS WOTax,

-- OCTax
CASE 
    WHEN ISNULL(PB.OCTax, 0) - ISNULL(PB1.OCTax, 0) < 0 
    THEN 0
    ELSE ISNULL(PB.OCTax, 0) - ISNULL(PB1.OCTax, 0)
END AS OCTax,

-- ExtraTax
CASE 
    WHEN ISNULL(PB.ExtraTax, 0) - ISNULL(PB1.ExtraTax, 0) < 0 
    THEN 0
    ELSE ISNULL(PB.ExtraTax, 0) - ISNULL(PB1.ExtraTax, 0)
END AS ExtraTax,
   PB.BaggageFare,PM.CardType,    
   case when PM.CardConfigurationType = 'Riya'  
   THEN 'CORPORATE' when PM.CardConfigurationType = 'Customer'  
   THEN 'CUSTOMER'   
   else '' END as UATP,    
   PB.FMCommission,      
   PM.MaskCardNumber as 'CardNumber',PM.mer_amount,
   PM.billing_address,PM.billing_name,PM.order_id,PM.tracking_id,
   --BI.airlinePNR,BI.cabin,BI.farebasis,            
   ATT.VesselName,ATT.TR_POName,ATT.Bookedby,ATT.AType,ATT.RankNo,                    
   Case When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode    
   End As Icast,    
   B2BR.LocationCode, BranchCode = '', PR.EmpCode,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',ATT.OBTCno,    
   --Added By Rahul A    
   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0)+(isnull(pb.VendorServiceFee,0)*isnull(bm.ROE,0)))as decimal(18,2)) as MarkupOnTaxFare,    
   (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,    
     --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,    
   ATT.CostCenter,ATT.TravelerType,ATT.Changedcostno,ATT.Travelduration,ATT.TASreqno,ATT.Companycodecc,ATT.Projectcode    
   ,case when AL.UserID = 47129 then ISNULL(ATT.UID,'')   
     when AL.GroupId='23' then isnull(ATT.ConcurID,'')     
   else ISNULL(ATT.CostCenter,'') end as _str1060,     
   case when AL.UserID = 47129 then ISNULL(ATT.PID,'')   
   when al.GroupId='23' then ISNULL(ATT.CostCenter,'')  
   else  ISNULL(ATT.EmpDimession,'')   
   end  as _str1028,     
   case when AL.UserID = 47129 then ISNULL(replace(ATT.Account,'&','and'),'')   
   else ISNULL(replace(ATT.Travelduration,'&','and'),'') end as _str1054,    
   case when AL.UserID = 47129 then ISNULL(ATT.UID,'')  
   when al.GroupId='23' then ISNULL(replace(ATT.EmpDimession,'&','and'),'')   
   else ISNULL(ATT.Traveltype,'') end as _str1061 ,    
   case when AL.UserID = 47129 then ISNULL(ATT.TravelerType,'') else ISNULL(ATT.Changedcostno,'') end as _str1025,    
    ISNULL(ATT.TASreqno,'')  as _str1022, ISNULL(ATT.Companycodecc,'')  as _str1023, ISNULL(ATT.Projectcode,'') as _str1024,    
    Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans,
	case when PB.EMDNumber is null then
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) 
  else
   '0.00' end
  as AirlineFee ,'' as 'TicketType','' as EntryType,PB.EMDStatus,
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) as AirlineFee1 
   FROM tblBookMaster BM WITH (NOLOCK)      
   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster   
   LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid
   INNER JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id              
   --LEFT JOIN tblBookItenary BI ON BM.pkId = BI.fkBookMaster            
   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid    
   LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID            
   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country            
   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID               
   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID            
   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID               
   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID             
   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode      
   LEFT Join mCardDetails CD WITH (NOLOCK) ON RIGHT(CD.MaskCardNumber,4)=RIGHT(PM.MaskCardNumber,4)   
   AND CD.MarketPoint=BM.Country AND CD.STATUS=1 AND CD.UserType = (Select value from mcommon where category='Usertype' and Id=5)    
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
   and AL.userTypeID IN(5) --For RBT usertype is 5 ***        
   and BM.VendorName Not in ('STS')  
   and PM.payment_mode is not null  
 --  and BM.riyaPNR = '81PD2P'
 AND  EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM1  
    WHERE BM.PARENTORDERID = BM1.ORDERID AND BM1.bookingstatus=18  
)  
   ORDER BY BM.inserteddate DESC             
 END  
 
  IF @Action = 'EMDRBTPendingTickets'            
BEGIN            
   SELECT TOP 10000 U.EmployeeNo as UserName,PB.EMDNumber as TicketNumber, PB1.TicketNumber AS OLDTicketNo,
	PB.EMDNumber,1 as EMDStatus,
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
   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,     
   BM.pkId,  
   BM.riyaPNR,  
   BM.inserteddate,BM.IssueDate,BM.CounterCloseTime,   
     Cast(isnull(PB.IATACommission,0) as decimal(18,2)) as CustIATACommAmount,  
   (Cast(isnull(PB.PLBCommission,0) as decimal(18,2))  
   + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)))   
   as PLBCommission,Cast(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,   
   BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,            
   BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',            
    Case when BM.VendorCommissionPercent ='' then  
  '0.00'  
  else  
 BM.VendorCommissionPercent end as VendorCommissionPercent,PB.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,PB.FMCommission,    
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'           
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'          
     else CU.IATA end as IATA,PM.payment_mode,    
   case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end as 'Currency',BM.ROE,            
   BM.RegistrationNumber,PB.title,PB.paxType,PB.pid,  
   PB.paxFName,PB.paxLName,substring(replace(PB.baggage,'&','and'),0,30) as baggage,
   case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,
0 AS basicFare, 0 AS totalTax, 0 AS managementfees, 0 AS YRTax,
0 AS YQ,        0 AS INTax,     0 AS JNTax,          0 AS YMTax,
0 AS WOTax,     0 AS OCTax,     0 AS ExtraTax,
   PB.BaggageFare,PM.CardType,    
   case when PM.CardConfigurationType = 'Riya'  
   THEN 'CORPORATE' when PM.CardConfigurationType = 'Customer'  
   THEN 'CUSTOMER'   
   else '' END as UATP,    
   PB.FMCommission,      
   PM.MaskCardNumber as 'CardNumber',PM.mer_amount,
   PM.billing_address,PM.billing_name,PM.order_id,PM.tracking_id,
   --BI.airlinePNR,BI.cabin,BI.farebasis,            
   ATT.VesselName,ATT.TR_POName,ATT.Bookedby,ATT.AType,ATT.RankNo,                    
   Case When ED.CustomerCode='AgentCustID' and B2BR.Icast !='AgentCustID' then B2BR.Icast    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode    
   End As Icast,    
   B2BR.LocationCode, BranchCode = '', PR.EmpCode,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',ATT.OBTCno,    
   --Added By Rahul A    
   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0)+(isnull(pb.VendorServiceFee,0)*isnull(bm.ROE,0)))as decimal(18,2)) as MarkupOnTaxFare,    
   (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,    
     --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,    
   ATT.CostCenter,ATT.TravelerType,ATT.Changedcostno,ATT.Travelduration,ATT.TASreqno,ATT.Companycodecc,ATT.Projectcode    
   ,case when AL.UserID = 47129 then ISNULL(ATT.UID,'')   
     when AL.GroupId='23' then isnull(ATT.ConcurID,'')     
   else ISNULL(ATT.CostCenter,'') end as _str1060,     
   case when AL.UserID = 47129 then ISNULL(ATT.PID,'')   
   when al.GroupId='23' then ISNULL(ATT.CostCenter,'')  
   else  ISNULL(ATT.EmpDimession,'')   
   end  as _str1028,     
   case when AL.UserID = 47129 then ISNULL(replace(ATT.Account,'&','and'),'')   
   else ISNULL(replace(ATT.Travelduration,'&','and'),'') end as _str1054,    
   case when AL.UserID = 47129 then ISNULL(ATT.UID,'')  
   when al.GroupId='23' then ISNULL(replace(ATT.EmpDimession,'&','and'),'')   
   else ISNULL(ATT.Traveltype,'') end as _str1061 ,    
   case when AL.UserID = 47129 then ISNULL(ATT.TravelerType,'') else ISNULL(ATT.Changedcostno,'') end as _str1025,    
    ISNULL(ATT.TASreqno,'')  as _str1022, ISNULL(ATT.Companycodecc,'')  as _str1023, ISNULL(ATT.Projectcode,'') as _str1024,    
    Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans,
	case when PB.EMDNumber is null then
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) 
  else
   '0.00' end
  as AirlineFee ,'' as 'TicketType','' as EntryType,
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) as AirlineFee1 
   FROM tblBookMaster BM WITH (NOLOCK)      
   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster   
   LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid
   INNER JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id              
   --LEFT JOIN tblBookItenary BI ON BM.pkId = BI.fkBookMaster            
   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid    
   LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID            
   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country            
   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID               
   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID            
   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID               
   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID             
   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode      
   LEFT Join mCardDetails CD WITH (NOLOCK) ON RIGHT(CD.MaskCardNumber,4)=RIGHT(PM.MaskCardNumber,4)   
   AND CD.MarketPoint=BM.Country AND CD.STATUS=1 AND CD.UserType = (Select value from mcommon where category='Usertype' and Id=5)    
   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId    
   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'            
   and BM.BookingStatus In(1,6) --As confirm with Mansavee          
   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)    
   -- For Booking            
  -- and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)            
   and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'            
   and BM.Country in('IN')    
   and BM.totalFare > 0  
   and PB.EMDStatus=0
   and ISNULL(PB.EMDNumber,'') != ''
   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country             
   and AL.userTypeID IN(5) --For RBT usertype is 5 ***        
   and BM.VendorName Not in ('STS')  
   and PM.payment_mode is not null  
  -- and BM.riyaPNR = @RiyaPnr
 AND  EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM1  
    WHERE BM.PARENTORDERID = BM1.ORDERID AND BM1.bookingstatus=18  
)  
   ORDER BY BM.inserteddate DESC             
 END 

 IF @Action = 'RBTReissueIndiaCancellationTickets'
 BEGIN          
    SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, 
	BM.bookingStatus,  
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
    ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount ,
	(Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + 
	Cast(isnull(PB.DropnetCommission,0) as decimal(18,2))) as PLBCommission, 
	Cast(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB ,
	'0' as Surcharge,  
   case when BM.VendorName='TravelFusion' then 'BOMVEND007913' else ED.VendorCode end as VendorCode,  
    BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,          
    BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,          
    BM.arrivalTime, case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' THEN 'CUSTOMER' else '' END as UATP,  
    PB.FMCommission,  PB.FMCommission, PB.CancelledDate as PostingDate,   
    case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,    
    case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10 then 'RIYAAPITF'         
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'        
     else CU.IATA end as IATA,  
    BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,          
    PB.RefundAmount as totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,          
    BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent,   
    case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,   
    BM.orderId,          
    PB.pid, PB.title, PB.ticketNum, PB.pid, 
	PB.RefundAmount as basicFare, 
	'0.00' as totalTax, PB.paxType,          
    PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,           
    '0.00' as managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,  
    '0.00' as YRTax, '0.00' as YQ, '0.00' as INTax, '0.00' as 'JNTax', '0.00' as OCTax, '0.00' as ExtraTax, '0.00' as YMTax,  
    PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,          
    --BI.airlinePNR, BI.cabin, BI.farebasis,          
    ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,  
    Case When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast  
   When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode  
   When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode  
    End As Icast,  
    BR.LocationCode, '' as BranchCode,'' as DivisionCode, PR.EmpCode,ATT.OBTCno,         
    '0.00' as Canfees, '0.00' as ServiceFees,   
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
	LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid
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
    and BM.BookingStatus In(1) --As confirm with Mansavee           
    and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)             
    and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'          
    and BM.Country in ('IN')  
    and BM.totalFare > 0  
    and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country       
    and AL.userTypeID = 5  
	AND PB.RefundAmount > 0
    and BM.VendorName Not in ('STS')  
    ORDER BY BM.IssueDate DESC  
 END  
               
 IF @Action = 'RBT-US-CAReissueBookingTickets'            
  --RBT-US_VA
  BEGIN                      
   SELECT TOP 10000 PB.TicketNumber, PB1.TicketNumber AS OLDTicketNo,
	PB.EMDNumber,
   BM.riyaPNR, ED.AgentCountry,ED.OwnerCountry, ED.ERPCountry,     
  BM.AgentID, BM.MainAgentId, PB.pid,BM.pkId, '' as UserName, BM.bookingStatus,    
  ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,     
  Case When BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10 and ED.AgentCountry = 'US' Then 'UVEND00082'    
  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'GB' Then 'VEND00008'     
  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'CA' Then 'BOMVEND007913'    
  when BM.OfficeID = '00FK' and ED.AgentCountry = 'US' Then 'UVEND01206'    
  Else ED.VendorCode End as VendorCode,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,    
  isnull(BM.IssueDate, BM.inserteddate) as PostingDate,    
  PM.payment_mode,PM.MerchantId 'PaymentGateway',PM.BankAccountNo,--Rahul A.   
  Cast(isnull(PB.IATACommission,0) as decimal(18,2)) as CustIATACommAmount ,  
  (Cast(isnull(PB.PLBCommission,0) as decimal(18,2))   
  + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2))) as PLBCommission, 
    CAST(isnull(PB.tdsonplb ,0) as decimal(18,2)) as GSTonPLB,
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
   case when PM.CardConfigurationType = 'Riya'  
   THEN 'CORPORATE' when PM.CardConfigurationType = 'Customer'  
   THEN 'CUSTOMER'   
   else '' END as UATP,    
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
  BM.inserteddate, BM.IssueDate,BM.depDate, BM.arrivalDate,
  BM.deptTime, BM.arrivalTime, BM.frmSector, BM.toSector, 
  BM.fromTerminal, BM.toTerminal, BM.flightNo, BM.travClass,    
  BM.airCode, BM.Country, BM.equipment,  BM.Vendor_No, BM.orderId,    
  Case When AC.type ='FSC' then BM.GDSPNR  else 
  LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',--chec    
  Case When BM.VendorName='TravelFusion' then 'RIYAAPITF' 
  else BM.OfficeID end as OfficeID, BM.TotalDiscount, BM.totalFare,
-- basicFare
CASE 
    WHEN (ISNULL(PB.basicFare, 0) + ISNULL(PB.Markup, 0) + ISNULL(PB.LonServiceFee, 0)) - 
         (ISNULL(PB1.basicFare, 0) + ISNULL(PB1.Markup, 0) + ISNULL(PB1.LonServiceFee, 0)) < 0 
    THEN 0
    ELSE (ISNULL(PB.basicFare, 0) + ISNULL(PB.Markup, 0) + ISNULL(PB.LonServiceFee, 0)) - 
         (ISNULL(PB1.basicFare, 0) + ISNULL(PB1.Markup, 0) + ISNULL(PB1.LonServiceFee, 0))
END AS basicFare,

-- totalTax
CASE 
    WHEN ISNULL(PB.totalTax, 0) - ISNULL(PB1.totalTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.totalTax, 0) - ISNULL(PB1.totalTax, 0)
END AS totalTax,

-- K3Tax (JNTax)
CASE 
    WHEN ISNULL(PB.JNTax, 0) - ISNULL(PB1.JNTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.JNTax, 0) - ISNULL(PB1.JNTax, 0)
END AS K3Tax,

-- YRTax
CASE 
    WHEN ISNULL(PB.YRTax, 0) - ISNULL(PB1.YRTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.YRTax, 0) - ISNULL(PB1.YRTax, 0)
END AS YRTax,

-- YQ
CASE 
    WHEN ISNULL(CAST(PB.YQ AS decimal(18,2)), 0) - ISNULL(CAST(PB1.YQ AS decimal(18,2)), 0) < 0 THEN 0
    ELSE ISNULL(CAST(PB.YQ AS decimal(18,2)), 0) - ISNULL(CAST(PB1.YQ AS decimal(18,2)), 0)
END AS YQ,

-- INTax
CASE 
    WHEN ISNULL(PB.INTax, 0) - ISNULL(PB1.INTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.INTax, 0) - ISNULL(PB1.INTax, 0)
END AS INTax,

-- JNTax (JNTax + K7Tax)
CASE 
    WHEN (ISNULL(PB.JNTax, 0) + ISNULL(PB.k7tax, 0)) - (ISNULL(PB1.JNTax, 0) + ISNULL(PB1.k7tax, 0)) < 0 THEN 0
    ELSE (ISNULL(PB.JNTax, 0) + ISNULL(PB.k7tax, 0)) - (ISNULL(PB1.JNTax, 0) + ISNULL(PB1.k7tax, 0))
END AS JNTax,

-- OCTax
CASE 
    WHEN ISNULL(PB.OCTax, 0) - ISNULL(PB1.OCTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.OCTax, 0) - ISNULL(PB1.OCTax, 0)
END AS OCTax,

-- ExtraTax
CASE 
    WHEN ISNULL(PB.ExtraTax, 0) - ISNULL(PB1.ExtraTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.ExtraTax, 0) - ISNULL(PB1.ExtraTax, 0)
END AS ExtraTax,

-- RFTax
CASE 
    WHEN ISNULL(PB.RFTax, 0) - ISNULL(PB1.RFTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.RFTax, 0) - ISNULL(PB1.RFTax, 0)
END AS RFTax,

-- WOTax
CASE 
    WHEN ISNULL(PB.WOTax, 0) - ISNULL(PB1.WOTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.WOTax, 0) - ISNULL(PB1.WOTax, 0)
END AS WOTax,

-- YMTax
CASE 
    WHEN ISNULL(PB.YMTax, 0) - ISNULL(PB1.YMTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.YMTax, 0) - ISNULL(PB1.YMTax, 0)
END AS YMTax,
  PB.paxType, PB.title, PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,     
  Case When BM.BookingSource!='ManualTicketing' Then PB.Markup Else 0 End as Markup, BM.AgentMarkup,    
  PM.MaskCardNumber as 'CardNumber', PM.CardType, PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,    
  --BI.airlinePNR, BI.cabin, BI.farebasis,    
  PB.ServiceFee as 'ServiceFees',     
  substring(replace(PB.baggage,'&','and'),0,29) as baggage, PB.BaggageFare,    
  --cast(((SSR.SSR_Amount ) /BM.ROE)as decimal(18,2)) as 'extrabagAmount',    
  SSR.SSR_Amount as extrabagAmount,    
  SSR1.SSR_Amount as MealCharges, SSR2.SSR_Amount as SeatPreferenceCharge, Case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,    
  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0)+(isnull(pb.VendorServiceFee,0)*isnull(bm.ROE,0)))as decimal(18,2)) as MarkupOnTaxFare,    
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
  ,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',   
  ISNULL(PM.AuthCode,'') as CVV,--1055 attribute    
  case when AL.GroupId = '4' then PB.ServiceFee else '0' end as 'ManagementFees',AL.GroupId,    
  case when AL.GroupId = '4'     
  then Cast((select top 1 OUName from mAgentAttributeMappingOU where ID = ATT.OUNameIDF) as varchar(50))    
  when AL.GroupId = '10' then Cast(ISNULL(ATT.TravelRequestNumber,'0') as varchar(50))    
  when (BR.Icast in ('UCUST00654','BCUST00028','UCUST00618','UCUST00615','UCUST00615A','UCUST00615B','BCUST00026A','BCUST00026','CUST001580','CUST001581','CUST001582','CUST001605','CUST001606') or     
  BR1.Icast in ('UCUST00654','BCUST00028','UCUST00618','UCUST00615','BCUST00026','UCUST00615A','UCUST00615B','BCUST00026A','CUST001580','CUST001581','CUST001582','CUST001605','CUST001606'))     
  then Cast(ISNULL(ATT.TravelRequestNumber,'0') as varchar(50))    
  when AL.GroupId in ('18','24') then isnull(ATT.ConcurID,'')    
  when AL.GroupId = '21' then isnull(replace(ATT.Projectcode,'&','and'),'')    
  when AL.GroupId = '20' then isnull(replace(ATT.TripPurpose,'&','and'),'')    
  else Cast(ISNULL(ATT.CostCenter,'') as varchar(50)) end as _str1060,     
   case when AL.GroupId = '4' then ISNULL(ATT.BTANO,'')    
   when AL.GroupId = '10' then Cast(ISNULL(ATT.EmpDimession,'0') as varchar(50))    
   when AL.GroupId in ('18','24') then ISNULL(replace(ATT.EmpDimession,'&','and'),'')    
   when AL.GroupId='21' then ISNULL(replace(ATT.NameofApprover,'&','and'),'')   
   when Al.GroupId='20' then ISNULL(REPLACE(ATT.CostCentre,'&','and'),'')    
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
   when AL.GroupId = '18' then isnull(replace(ATT.Department,'&','and'),'')    
   when AL.GroupId = '21' then isnull(replace(ATT.Traveltype,'&','and'),'')    
   when Al.GroupId = '20' then isnull(replace(ATT.ProjectNo,'&','and'),'')   
   when Al.GroupId = '24' then isnull(replace(ATT.Projectcode,'&','and'),'')   
  else ISNULL(replace(ATT.EmpDimession,'&','and'),'') end as _str1028,     
  case     
  when AL.GroupId = '18' then isnull(ATT.ApproverName,'')    
  when AL.GroupId = '21' then ISNULL(replace(ATT.EmpDimession,'&','and'),'')    
  else ISNULL(ATT.Changedcostno,'')     
   end  as _str1025,    
  case when AL.GroupId = '18'    
  then  isnull(replace(ATT.TravelReason,'&','and'),'')   
  when AL.GroupId = '21'   
  then isnull(replace(ATT.Issuancedate,'&','and'),'')    
  else    
  ISNULL(ATT.Travelduration,'') end as _str1054,    
  case when AL.GroupId = '21' then isnull(replace(ATT.BillingEntityName,'&','and'),'')   
  when AL.GroupId = '18' then isnull(replace(ATT.TRAVELCOSTREIMBURSABLE,'&','and'),'')    
   WHEN AL.GroupId = '3' THEN   
        CASE   
            WHEN ATT.RequestID = '' OR ATT.RequestID IS NULL THEN ISNULL(ATT.TasReqNo, '')  
            ELSE ATT.RequestID  
        END  
  else    
  ISNULL(ATT.TASreqno,'') end as _str1022,  
  ISNULL(ATT.Companycodecc,'')  as _str1023,   
  case when AL.GroupId = '10' then ''   
  when AL.GroupId = '18' then isnull(replace(ATT.TRAVELCOSTREIMBURSABLE,'&','and'),'')  
  else ISNULL(Replace(ATT.Projectcode,'&','&amp;'),'')   
  end as _str1024,    
  ATT.LOWEST_LOGICAL_FARE_1 as _str1008, ATT.LOWEST_LOGICAL_FARE_2 as _str1010, ATT.LOWEST_LOGICAL_FARE_3 as _str1018, ATT.EmpDimession as _str1005,    
  Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans,    
  --Payment Receipt Entries    
  PM.bank_ref_no as TransactionNo,BBM.ModeOfPayment as PaymentType,
  BBM.TotalCommission as CCCharges,
  (isnull(PM.mer_amount,0) + isnull(BBM.TotalCommission,0)) as Amount,
  case when PB.EMDNumber is null then
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) 
  else
   '0.00' end
  as AirlineFee ,'' as 'TicketType','Date Change' as EntryType,PB.EMDStatus,
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) as AirlineFee1 
  --isnull(BBM.TotalCommission,0),isnull(PM.mer_amount,0)    
  FROM tblBookMaster BM WITH (NOLOCK)   
  LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster            
  LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid 
  INNER JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id            
  LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID      
  LEFT JOIN mUser U on BM.MainAgentId = U.ID            
  LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid    
  LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID            
  LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null            
  LEFT JOIN B2BRegistration BR1 WITH (NOLOCK) ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null            
  LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode            
  LEFT JOIN tblOwnerCurrency TOC WITH (NOLOCK) ON TOC.OfficeID = BM.OfficeID            
  LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode            
  LEFT Join mCardDetails CD WITH (NOLOCK) ON RIGHT(CD.MaskCardNumber,4)=RIGHT(PM.MaskCardNumber,4)   
   AND CD.MarketPoint=BM.Country AND CD.STATUS=1 and CD.UserType = (Select value from mcommon where category='Usertype' and Id=5)    
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
  And PM.payment_mode is not null  
  and BM.totalFare > 0    
  and AL.userTypeID in (5) --For RBT usertype is 5 ***               
  and BM.VendorName Not in ('STS')   
  AND EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM1  
    WHERE BM.PARENTORDERID = BM1.ORDERID AND BM1.bookingstatus=18  
)  
--  and BM.riyaPNR in ('6BN753')--,'2MB189','E39I59','V134RR','ID1W22','6M0EO2')    
  ORDER BY BM.IssueDate DESC    
  END 

 IF @Action = 'RBT-US-CAReissueCancellationTickets'          
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
    ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,
	 Cast(isnull(PB.IATACommission,0) as decimal(18,2)) as CustIATACommAmount ,
	 (Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) 
	 + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2))) 
	 as PLBCommission, 
	 CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,
	 PB.CancelledDate as PostingDate,  
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
    case when CD.Configuration = 'RiyaCard' THEN 'CORPORATE' when CD.Configuration = 'CustomerCard' THEN 'CUSTOMER' when PM.payment_mode = 'passThrough'
	THEN 'CUSTOMER' else '' END as UATP, PB.FMCommission,  
    case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,   
    case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10 then 'RIYAAPITF'         
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'        
     else CU.IATA end as IATA,  
    BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,          
    PB.RefundAmount as totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,          
    BM.TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent,   
    case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,   
    BM.orderId,          
    PB.pid, PB.title, PB.ticketNum, PB.pid,
	PB.RefundAmount as basicFare, '0.00' as totalTax, PB.paxType,          
    PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+
	ISNULL(PB.paxLName,'') as PaxName,           
    '0.00' as managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,  
    '0.00' as YRTax, '0.00' as YQ, '0.00' as INTax, 
	'0.00' as 'JNTax', '0.00' as OCTax, '0.00' as ExtraTax, '0.00' as WOTax , '0.00' as YMTax,  
    PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,          
    --BI.airlinePNR, BI.cabin, BI.farebasis,          
    ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,  
    Case When ED.CustomerCode='AgentCustID' and BR.Icast !='AgentCustID' then BR.Icast  
   When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode  
   When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode  
    End As Icast,  
    BR.LocationCode, '' as BranchCode,'' as DivisionCode, PR.EmpCode,ATT.OBTCno,         
    '0.00' as 'Canfees', '0.00' as ServiceFees,   
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
	LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid 
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
    and BM.BookingStatus In(1) --As confirm with Mansavee           
  --  and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)             
    and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'          
    and BM.Country in ('US','CA','GB')  
    and ED.AgentCountry = BM.Country  
    and ED.ERPCountry = BM.Country  
    and AL.userTypeID = 5  
    and PB.RefundAmount > 0
    --and BM.GDSPNR in ('1I425U')  
    and BM.VendorName Not in ('STS')  
    ORDER BY BM.IssueDate DESC  
 END 
  
 IF @Action = 'EMD-RBT-US-CAPendingTickets'            
  --EMDRBT-US_VA
  BEGIN                      
   SELECT TOP 10000 PB.TicketNumber, PB1.TicketNumber AS OLDTicketNo,
	PB.EMDNumber,1 as EMDStatus,
   BM.riyaPNR, ED.AgentCountry,ED.OwnerCountry, ED.ERPCountry,     
  BM.AgentID, BM.MainAgentId, PB.pid,BM.pkId, '' as UserName, BM.bookingStatus,    
  ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,     
  Case When BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10 and ED.AgentCountry = 'US' Then 'UVEND00082'    
  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'GB' Then 'VEND00008'     
  when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10and ED.AgentCountry = 'CA' Then 'BOMVEND007913'    
  when BM.OfficeID = '00FK' and ED.AgentCountry = 'US' Then 'UVEND01206'    
  Else ED.VendorCode End as VendorCode,isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,    
  isnull(BM.IssueDate, BM.inserteddate) as PostingDate,    
  PM.payment_mode,PM.MerchantId 'PaymentGateway',PM.BankAccountNo,--Rahul A.   
  Cast(isnull(PB.IATACommission,0) as decimal(18,2)) as CustIATACommAmount ,  
  (Cast(isnull(PB.PLBCommission,0) as decimal(18,2))   
  + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2))) as PLBCommission,   
   Cast(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,
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
   case when PM.CardConfigurationType = 'Riya'  
   THEN 'CORPORATE' when PM.CardConfigurationType = 'Customer'  
   THEN 'CUSTOMER'   
   else '' END as UATP,       
  case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'           
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'          
     else TOC.IATA end as IATA,    
  ISNULL(BR.Icast, BR1.Icast) as 'Icast', BM.CounterCloseTime, BM.RegistrationNumber,    
  BM.inserteddate, BM.IssueDate,BM.depDate, BM.arrivalDate,
  BM.deptTime, BM.arrivalTime, BM.frmSector, BM.toSector, 
  BM.fromTerminal, BM.toTerminal, BM.flightNo, BM.travClass,    
  BM.airCode, BM.Country, BM.equipment,  BM.Vendor_No, BM.orderId,    
  Case When AC.type ='FSC' then BM.GDSPNR  else 
  LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',--chec    
  Case When BM.VendorName='TravelFusion' then 'RIYAAPITF' 
  else BM.OfficeID end as OfficeID, BM.TotalDiscount, BM.totalFare,
 0 as basicFare,0 as totalTax,0 AS K3Tax,
0 as YRTax,0 AS YQ,0 AS INTax,0 AS JNTax,
0 AS OCTax,0 AS ExtraTax,0 AS RFTax,0 AS WOTax,
0 AS YMTax,PB.paxType, PB.title, PB.paxFName,
PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'')
as PaxName,     
  Case When BM.BookingSource!='ManualTicketing' Then PB.Markup
  Else 0 End as Markup, BM.AgentMarkup,    
  PM.MaskCardNumber as 'CardNumber', PM.CardType, PM.mer_amount,
  PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,    
  --BI.airlinePNR, BI.cabin, BI.farebasis,    
  0 as 'ServiceFees',     
  substring(replace(PB.baggage,'&','and'),0,29) as baggage, PB.BaggageFare,    
  --cast(((SSR.SSR_Amount ) /BM.ROE)as decimal(18,2)) as 'extrabagAmount',    
  SSR.SSR_Amount as extrabagAmount,    
  SSR1.SSR_Amount as MealCharges, SSR2.SSR_Amount as SeatPreferenceCharge, Case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,    
  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0)+(isnull(pb.VendorServiceFee,0)*isnull(bm.ROE,0)))as decimal(18,2)) as MarkupOnTaxFare,    
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
  ,case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',   
  ISNULL(PM.AuthCode,'') as CVV,--1055 attribute    
  case when AL.GroupId = '4' then PB.ServiceFee else '0' end as 'ManagementFees',AL.GroupId,    
  case when AL.GroupId = '4'     
  then Cast((select top 1 OUName from mAgentAttributeMappingOU where ID = ATT.OUNameIDF) as varchar(50))    
  when AL.GroupId = '10' then Cast(ISNULL(ATT.TravelRequestNumber,'0') as varchar(50))    
  when (BR.Icast in ('UCUST00654','BCUST00028','UCUST00618','UCUST00615','UCUST00615A','UCUST00615B','BCUST00026A','BCUST00026','CUST001580','CUST001581','CUST001582','CUST001605','CUST001606') or     
  BR1.Icast in ('UCUST00654','BCUST00028','UCUST00618','UCUST00615','BCUST00026','UCUST00615A','UCUST00615B','BCUST00026A','CUST001580','CUST001581','CUST001582','CUST001605','CUST001606'))     
  then Cast(ISNULL(ATT.TravelRequestNumber,'0') as varchar(50))    
  when AL.GroupId in ('18','24') then isnull(ATT.ConcurID,'')    
  when AL.GroupId = '21' then isnull(replace(ATT.Projectcode,'&','and'),'')    
  when AL.GroupId = '20' then isnull(replace(ATT.TripPurpose,'&','and'),'')    
  else Cast(ISNULL(ATT.CostCenter,'') as varchar(50)) end as _str1060,     
   case when AL.GroupId = '4' then ISNULL(ATT.BTANO,'')    
   when AL.GroupId = '10' then Cast(ISNULL(ATT.EmpDimession,'0') as varchar(50))    
   when AL.GroupId in ('18','24') then ISNULL(replace(ATT.EmpDimession,'&','and'),'')    
   when AL.GroupId='21' then ISNULL(replace(ATT.NameofApprover,'&','and'),'')   
   when Al.GroupId='20' then ISNULL(REPLACE(ATT.CostCentre,'&','and'),'')    
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
   when AL.GroupId = '18' then isnull(replace(ATT.Department,'&','and'),'')    
   when AL.GroupId = '21' then isnull(replace(ATT.Traveltype,'&','and'),'')    
   when Al.GroupId = '20' then isnull(replace(ATT.ProjectNo,'&','and'),'')   
   when Al.GroupId = '24' then isnull(replace(ATT.Projectcode,'&','and'),'')   
  else ISNULL(replace(ATT.EmpDimession,'&','and'),'') end as _str1028,     
  case     
  when AL.GroupId = '18' then isnull(ATT.ApproverName,'')    
  when AL.GroupId = '21' then ISNULL(replace(ATT.EmpDimession,'&','and'),'')    
  else ISNULL(ATT.Changedcostno,'')     
   end  as _str1025,    
  case when AL.GroupId = '18'    
  then  isnull(replace(ATT.TravelReason,'&','and'),'')   
  when AL.GroupId = '21'   
  then isnull(replace(ATT.Issuancedate,'&','and'),'')    
  else    
  ISNULL(ATT.Travelduration,'') end as _str1054,    
  case when AL.GroupId = '21' then isnull(replace(ATT.BillingEntityName,'&','and'),'')   
  when AL.GroupId = '18' then isnull(replace(ATT.TRAVELCOSTREIMBURSABLE,'&','and'),'')    
   WHEN AL.GroupId = '3' THEN   
        CASE   
            WHEN ATT.RequestID = '' OR ATT.RequestID IS NULL THEN ISNULL(ATT.TasReqNo, '')  
            ELSE ATT.RequestID  
        END  
  else    
  ISNULL(ATT.TASreqno,'') end as _str1022,  
  ISNULL(ATT.Companycodecc,'')  as _str1023,   
  case when AL.GroupId = '10' then ''   
  when AL.GroupId = '18' then isnull(replace(ATT.TRAVELCOSTREIMBURSABLE,'&','and'),'')  
  else ISNULL(Replace(ATT.Projectcode,'&','&amp;'),'')   
  end as _str1024,    
  ATT.LOWEST_LOGICAL_FARE_1 as _str1008, ATT.LOWEST_LOGICAL_FARE_2 as _str1010, ATT.LOWEST_LOGICAL_FARE_3 as _str1018, ATT.EmpDimession as _str1005,    
  Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans,    
  --Payment Receipt Entries    
  PM.bank_ref_no as TransactionNo,BBM.ModeOfPayment as PaymentType, BBM.TotalCommission as CCCharges,
  (isnull(PM.mer_amount,0) + isnull(BBM.TotalCommission,0)) as Amount,    
  --isnull(BBM.TotalCommission,0),isnull(PM.mer_amount,0) 
  case when PB.EMDNumber is null then
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) 
  else
   '0.00' end
  as AirlineFee ,'' as 'TicketType','Date Change' as EntryType,
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) as AirlineFee1 
  FROM tblBookMaster BM WITH (NOLOCK) 
  LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster            
  LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid 
  INNER JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id            
  LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID      
  LEFT JOIN mUser U on BM.MainAgentId = U.ID            
  LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid    
  LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID            
  LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null            
  LEFT JOIN B2BRegistration BR1 WITH (NOLOCK) ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null            
  LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode            
  LEFT JOIN tblOwnerCurrency TOC WITH (NOLOCK) ON TOC.OfficeID = BM.OfficeID            
  LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode            
  LEFT Join mCardDetails CD WITH (NOLOCK) ON RIGHT(CD.MaskCardNumber,4)=RIGHT(PM.MaskCardNumber,4)   
   AND CD.MarketPoint=BM.Country AND CD.STATUS=1 and CD.UserType = (Select value from mcommon where category='Usertype' and Id=5)    
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
 -- and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)               
  and BM.inserteddate > (Getdate()-31) -- '2021-07-31 23:59:59.999'            
  and ED.AgentCountry in ('US','CA','GB')    
  and ED.AgentCountry = BM.Country      
  and ED.ERPCountry = BM.Country   
  And PM.payment_mode is not null  
  and BM.totalFare > 0  
  and PB.EMDStatus=0
  and ISNULL(PB.EMDNumber,'') != ''
  and AL.userTypeID in (5) --For RBT usertype is 5 ***               
  and BM.VendorName Not in ('STS')   
  AND EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM1  
    WHERE BM.PARENTORDERID = BM1.ORDERID AND BM1.bookingstatus=18  
)  
  ORDER BY BM.IssueDate DESC    
  END  
                       
 IF @Action = 'HolidayReissueBookingTickets'            
  BEGIN            
   SELECT TOP 10000 U.EmployeeNo as UserName, 
   PB1.TicketNumber AS OLDTicketNo,PB.EMDNumber,  
   Case when BM.Country = 'US' and ED.OwnerCountry = 'IN' Then 'BOMCUST002120A'    
  when BM.Country = 'US' and ED.OwnerCountry = 'US' then 'UCUST00505'    
  when BM.Country = 'US' and ED.OwnerCountry = 'CA' then 'CCUST00004'    
  when BM.Country = 'US' and ED.OwnerCountry = 'AE' then 'CUST000324'        
 --else B2BR.Icast end as cust,B2BR.BranchCode as branchCode,   
 else  
 case when isnull(B2BR.Icast ,'')= '' then   
b2b1.Icast  
else  
B2BR.Icast  
end end AS cust,  
case when isnull(B2BR.BranchCode,'')='' then  
b2b1.BranchCode   
else  
B2BR.BranchCode  
end as branchCode,   
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
   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' 
   else BM.OfficeID end as OfficeID,    
   BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,
   BM.CounterCloseTime,ISNULL(BM.ValidatingCarrier,BM.airCode) 
   as ValidatingCarrier, 
   Cast(isnull(PB.IATACommission,0) as decimal(18,2)) 
   as CustIATACommAmount  
   ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2))   
   + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)))   
   as PLBCommission, Cast(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,    
   BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,
   BM.deptTime,
   BM.arrivalTime,BM.frmSector,BM.toSector,            
   BM.flightNo,BM.travClass,BM.AgentID,BM.Country,
   BM.fromTerminal,BM.toTerminal,BM.equipment,
   BM.TotalDiscount,
   Case when AC.type ='FSC' then BM.GDSPNR 
   else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',            
   BM.VendorCommissionPercent,
   PB.ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,    
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'           
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'          
     else CU.IATA end as IATA,    
   CD.Configuration,    
   case when BM.VendorName='TravelFusion' then 'INR'
   else Cu.Currency end as 'Currency',BM.ROE,            
   BM.RegistrationNumber,PB.title,LEFT(PB.TicketNumber,10) as TicketNumber,
   PB.pid,PB.paxType,PB.paxFName,PB.paxLName,            
   PB.managementfees,PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,  
-- YRTax
CASE 
    WHEN ISNULL(PB.YRTax, 0) - ISNULL(PB1.YRTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.YRTax, 0) - ISNULL(PB1.YRTax, 0)
END AS YRTax,

-- YQ
CASE 
    WHEN ISNULL(CAST(PB.YQ AS DECIMAL(18,2)), 0) - ISNULL(CAST(PB1.YQ AS DECIMAL(18,2)), 0) < 0 THEN 0
    ELSE ISNULL(CAST(PB.YQ AS DECIMAL(18,2)), 0) - ISNULL(CAST(PB1.YQ AS DECIMAL(18,2)), 0)
END AS YQ,

-- INTax
CASE 
    WHEN ISNULL(PB.INTax, 0) - ISNULL(PB1.INTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.INTax, 0) - ISNULL(PB1.INTax, 0)
END AS INTax,

-- JNTax (PB.JNTax + PB.k7tax)
CASE 
    WHEN (ISNULL(PB.JNTax, 0) + ISNULL(PB.k7tax, 0)) - 
         (ISNULL(PB1.JNTax, 0) + ISNULL(PB1.k7tax, 0)) < 0 THEN 0
    ELSE (ISNULL(PB.JNTax, 0) + ISNULL(PB.k7tax, 0)) - 
         (ISNULL(PB1.JNTax, 0) + ISNULL(PB1.k7tax, 0))
END AS JNTax,

-- OCTax
CASE 
    WHEN ISNULL(PB.OCTax, 0) - ISNULL(PB1.OCTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.OCTax, 0) - ISNULL(PB1.OCTax, 0)
END AS OCTax,

-- ExtraTax
CASE 
    WHEN ISNULL(PB.ExtraTax, 0) - ISNULL(PB1.ExtraTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.ExtraTax, 0) - ISNULL(PB1.ExtraTax, 0)
END AS ExtraTax,

   PB.BaggageFare,PM.CardType,            
   PM.MaskCardNumber as 'CardNumber',PM.mer_amount,
   PM.billing_address,PM.billing_name,PM.order_id,
   PM.tracking_id,--BI.airlinePNR,BI.cabin,BI.farebasis,            
   ATT.VesselName,ATT.TR_POName,ATT.Bookedby,ATT.AType,ATT.RankNo,
-- YMTax
CASE 
    WHEN ISNULL(PB.YMTax, 0) - ISNULL(PB1.YMTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.YMTax, 0) - ISNULL(PB1.YMTax, 0)
END AS YMTax,

-- basicFare (basicFare + LonServiceFee)
CASE 
    WHEN (ISNULL(PB.basicFare, 0) + ISNULL(PB.LonServiceFee, 0)) - 
         (ISNULL(PB1.basicFare, 0) + ISNULL(PB1.LonServiceFee, 0)) < 0 THEN 0
    ELSE (ISNULL(PB.basicFare, 0) + ISNULL(PB.LonServiceFee, 0)) - 
         (ISNULL(PB1.basicFare, 0) + ISNULL(PB1.LonServiceFee, 0))
END AS basicFare,

-- totalTax
CASE 
    WHEN ISNULL(PB.totalTax, 0) - ISNULL(PB1.totalTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.totalTax, 0) - ISNULL(PB1.totalTax, 0)
END AS totalTax,        
     case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,        
   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) 
   THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0)+(isnull(pb.VendorServiceFee,0)*isnull(bm.ROE,0)))as decimal(18,2)) 
   as MarkupOnTaxFare,    
   (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  
   (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2))
   +PB.BFC) as MarkupOnBaseFare,    
     --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,    
   case when BM.OfficeID = 'DFW1S212A' then 'UCUST00505'     
         when BM.OfficeID = 'YWGC4211G' then 'CCUST00004'     
         when BM.OfficeID = 'DXBAD3359' then 'CUST000324'     
         else IBM.Icust end as Icast,    
   LocationCode = 'BOM',     
   Code = 'BR2002000',   
   PR.EmpCode,  
   case when BM.VendorName = 'Amadeus' then 'FSC'
   else AC.type 
   end as 'AirLineType',  
   ATT.OBTCno ,
   case when PB.EMDNumber is null then
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) 
  else
   '0.00' end
  as AirlineFee ,'' as 'TicketType',
  'Date Change' as EntryType,PB.EMDStatus,
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) as AirlineFee1 
   FROM tblBookMaster BM WITH (NOLOCK)     
    LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster            
	LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid   
    INNER JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id            
    --LEFT JOIN tblBookItenary BI WITH (NOLOCK) ON BM.orderId = BI.orderId            
    LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid    
    LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID            
    LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID               
    LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID   
 left join agentlogin al1 on al1.userid=al.ParentAgentID  
 left join b2bregistration b2b1 on al.ParentAgentID = b2b1.FKUserID  
    Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID    
    LEFT JOIN tblInterBranchWinyatra IBM WITH (NOLOCK)  
ON (      (B2BR.StateID = IBM.fkStateId AND IBM.Country = 'IN')      
OR      (B2BR.StateID IS NULL AND B2B1.StateID = IBM.fkStateId 
AND IBM.Country = 'IN') )    
    LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID               
    LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID             
    LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode            
    LEFT Join mCardDetails CD WITH (NOLOCK) ON RIGHT(CD.MaskCardNumber,4)=RIGHT(PM.MaskCardNumber,4)   
   AND CD.MarketPoint=BM.Country AND CD.Status=1 AND CD.UserType = (Select value from mcommon where category='Usertype' and Id=4)    
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
 and PM.payment_mode is not null  
 and AL.userTypeID IN(4) --For Holiday usertype is 4 ***       
   -- and BM.riyaPNR='3YNJ39'    
    and BM.VendorName Not in ('STS')   
 AND EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM1  
    WHERE BM.PARENTORDERID = BM1.ORDERID AND BM1.bookingstatus=18  
)  
    ORDER BY BM.inserteddate DESC    
  END 
  
 IF @Action = 'EMDHolidayPendingTickets'            
  BEGIN            
   SELECT TOP 10000 U.EmployeeNo as UserName, 
   PB1.TicketNumber AS OLDTicketNo,PB.EMDNumber,  
   Case when BM.Country = 'US' and ED.OwnerCountry = 'IN' Then 'BOMCUST002120A'    
  when BM.Country = 'US' and ED.OwnerCountry = 'US' then 'UCUST00505'    
  when BM.Country = 'US' and ED.OwnerCountry = 'CA' then 'CCUST00004'    
  when BM.Country = 'US' and ED.OwnerCountry = 'AE' then 'CUST000324'        
 --else B2BR.Icast end as cust,B2BR.BranchCode as branchCode,   
 else  
 case when isnull(B2BR.Icast ,'')= '' then   
b2b1.Icast  
else  
B2BR.Icast  
end end AS cust,  
case when isnull(B2BR.BranchCode,'')='' then  
b2b1.BranchCode   
else  
B2BR.BranchCode  
end as branchCode,   
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
       ELSE PB.Markup END AS VendIATACommAmount,
	   BM.totalFare,BM.orderId,
	   isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,    
    case when BM.CounterCloseTime = 1 then 'D' else 'I' end as productType,PB.ServiceFee as 'ServiceFees',    
   PB.FMCommission, '0' as Surcharge, isnull(BM.IssueDate, BM.inserteddate) as PostingDate,    
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913'     
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'    
   else ED.VendorCode end as VendorCode,    
   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' 
   else BM.OfficeID end as OfficeID,    
   BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,
   BM.CounterCloseTime,ISNULL(BM.ValidatingCarrier,BM.airCode) 
   as ValidatingCarrier, 
   Cast(isnull(PB.IATACommission,0) as decimal(18,2)) 
   as CustIATACommAmount  
   ,(Cast(isnull(PB.PLBCommission,0) as decimal(18,2))   
   + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2)))   
   as PLBCommission,  Cast(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,   
   BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,
   BM.IATACommission,BM.deptTime,
   BM.arrivalTime,BM.frmSector,BM.toSector,            
   BM.flightNo,BM.travClass,BM.AgentID,BM.Country,
   BM.fromTerminal,BM.toTerminal,BM.equipment,
   0 as TotalDiscount,
   Case when AC.type ='FSC' then BM.GDSPNR 
   else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',            
   BM.VendorCommissionPercent,
   0 as ServiceFee,BM.AgentROE,BM.AgentCurrency,PB.B2bMarkup,PB.BFC,    
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'           
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'          
     else CU.IATA end as IATA,    
   CD.Configuration,    
   case when BM.VendorName='TravelFusion' then 'INR'
   else Cu.Currency end as 'Currency',BM.ROE,            
   BM.RegistrationNumber,PB.title,LEFT(PB.TicketNumber,10) as TicketNumber,
   PB.pid,PB.paxType,PB.paxFName,PB.paxLName,            
   0 as managementfees,PB.baggage,case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,
   0 as YRTax,0 as YQ,0 as INTax,
   0 as 'JNTax',
   0 as OCTax,0 as ExtraTax,PB.BaggageFare,PM.CardType,            
   PM.MaskCardNumber as 'CardNumber',PM.mer_amount,
   PM.billing_address,PM.billing_name,PM.order_id,PM.tracking_id,          
   ATT.VesselName,ATT.TR_POName,ATT.Bookedby,ATT.AType,ATT.RankNo,
0 as YMTax,0 AS basicFare,0 AS totalTax,             
     case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,        
   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) 
   THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0)+(isnull(pb.VendorServiceFee,0)*isnull(bm.ROE,0)))as decimal(18,2)) 
   as MarkupOnTaxFare,    
   (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  
   (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2))
   +PB.BFC) as MarkupOnBaseFare,    
     --ERP.MarkupOnBaseFare, ERP.MarkupOnTaxFare,    
   case when BM.OfficeID = 'DFW1S212A' then 'UCUST00505'     
         when BM.OfficeID = 'YWGC4211G' then 'CCUST00004'     
         when BM.OfficeID = 'DXBAD3359' then 'CUST000324'     
         else IBM.Icust end as Icast,    
   LocationCode = 'BOM',     
   Code = 'BR2002000',   
   PR.EmpCode,  
   case when BM.VendorName = 'Amadeus' then 'FSC'
   else AC.type 
   end as 'AirLineType',  
   ATT.OBTCno ,
   case when PB.EMDNumber is null then
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) 
  else
   '0.00' end
  as AirlineFee ,'' as 'TicketType',
  'Date Change' as EntryType,PB.EMDStatus,
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) as AirlineFee1 
   FROM tblBookMaster BM WITH (NOLOCK)   
    LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster            
	LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid   
    INNER JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id            
    --LEFT JOIN tblBookItenary BI WITH (NOLOCK) ON BM.orderId = BI.orderId            
    LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid    
    LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID            
    LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID               
    LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID   
 left join agentlogin al1 on al1.userid=al.ParentAgentID  
 left join b2bregistration b2b1 on al.ParentAgentID = b2b1.FKUserID  
    Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID    
    LEFT JOIN tblInterBranchWinyatra IBM WITH (NOLOCK)  
ON (      (B2BR.StateID = IBM.fkStateId AND IBM.Country = 'IN')      
OR      (B2BR.StateID IS NULL AND B2B1.StateID = IBM.fkStateId 
AND IBM.Country = 'IN') )    
    LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID               
    LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID             
    LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode            
    LEFT Join mCardDetails CD WITH (NOLOCK) ON RIGHT(CD.MaskCardNumber,4)=RIGHT(PM.MaskCardNumber,4)   
   AND CD.MarketPoint=BM.Country AND CD.Status=1 AND CD.UserType = (Select value from mcommon where category='Usertype' and Id=4)    
    LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId    
    WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'            
    and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)    
    and BM.BookingStatus In (1,6) --= 4 For Cancellation  =1 For Booking  --As confirm with Mansavee            
    -- For Booking            
   
    and BM.inserteddate > (Getdate()-62) -- '2021-08-31 23:59:59.999'            
    --and BM.Country in('IN','AE','US','CA')  // Commented As Discussed With Pranay & Bhavika            
    and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country    
    and BM.totalFare > 0  
	and ISNULL(PB.EMDNumber,'') != ''
    and PB.EMDStatus=0
	 and PM.payment_mode is not null  
	 and AL.userTypeID IN(4) --For Holiday usertype is 4 ***       
   -- and BM.riyaPNR='3YNJ39'    
    and BM.VendorName Not in ('STS')   
 AND EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM1  
    WHERE BM.PARENTORDERID = BM1.ORDERID AND BM1.bookingstatus=18  
)  
    ORDER BY BM.inserteddate DESC    
  END  

 IF @Action = 'HolidayReissueCancellationtTickets'  
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
    BM.pkId,PB.pid, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, Cast(isnull(PB.IATACommission,0) as decimal(18,2))  as CustIATACommAmount ,
	(Cast(isnull(PB.PLBCommission,0) as decimal(18,2))
	+ Cast(isnull(PB.DropnetCommission,0) as decimal(18,2))) as PLBCommission,  
    CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,
    BM.RegistrationNumber, BM.IssueDate,BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,BM.arrivalTime,  
    case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'         
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'        
     else CU.IATA end as IATA,  
    BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,PB.RefundAmount as totalFare,
	BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal,   
    BM.equipment,BM.TotalDiscount, 
	Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',
	BM.VendorCommissionPercent,   
    case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,   
    BM.orderId,PB.title, PB.ticketNum, PB.pid, 
	PB.RefundAmount as basicFare,PB.FMCommission,  
    PB.totalTax, PB.paxType,PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,'0.00' AS managementfees,   
    PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,'0.00' as YRTax, '0.00' as YQ, '0.00' as INTax,
	'0.00' as 'JNTax', '0.00' as OCTax, '0.00' as ExtraTax,PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address,  
    PM.billing_name, PM.order_id, PM.tracking_id,'0.00' as YMTax,    
     case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,    
  ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,  
  Icast= 'BOMCUST002120A',  
  LocationCode = 'BOM', BranchCode = 'BR2002000', '' as DivisionCode,  PR.EmpCode,ATT.OBTCno,            
   '0.00' as Canfees, '0.00' as ServiceFees,   
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
	LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid 
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
    and BM.BookingStatus In (1)   
    -- For Cancellation          
   -- and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)             
    and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'                 
    --and BM.Country in('IN','AE','US','CA')  // Commented As Discussed With Pranay & Bhavika          
    and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country  
    and AL.userTypeID IN(4) --For Holiday usertype is 4 ***     
    and BM.VendorName Not in ('STS')    
    and PB.RefundAmount > 0  
    --and BM.riyaPNR = 'ZKV336'         
    ORDER BY BM.inserteddate DESC  
   END    
         
 IF @Action = 'UAEReissueBookingTickets'            
  ---UAE Booking Tickets
  BEGIN    
   SELECT TOP 10000   
    case when al.userTypeID=2 and bm.Country='SA' and  
 B2BR.icast not in ('SACUST000004','SACUST000011','SACUST000017','SACUST000013' ) then  
 '' else U.EmployeeNo end as UserName,PB1.TicketNumber AS OLDTicketNo,PB.EMDNumber,  
  -- U.EmployeeNo as UserName,--ED.VendorCode,    
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
       ELSE isnull(PB.Markup,0) END AS VendIATACommAmount,
	   BM.MainAgentId as TicketingUserID,    
   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,
   isnull(BM.IssueDate, BM.inserteddate) as PostingDate,    
   Case when EV.VendorCode is null then    
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913'     
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'    
   else ED.VendorCode end ELSE EV.VendorCode end as VendorCode,Pm.payment_mode, isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,    
   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' 
   else BM.OfficeID end as OfficeID,     
   case when PM.CardConfigurationType = 'Riya'  
   THEN 'CORPORATE' when PM.CardConfigurationType = 'Customer'  
   THEN 'CUSTOMER'   
   else '' END as UATP,   
   BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime,ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount ,    
   (Cast(isnull(PB.PLBCommission,0) as decimal(18,2))  
   + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2))) as PLBCommission, Cast(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,    
   BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,            
   BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,BM.toTerminal,BM.equipment,BM.TotalDiscount,
   Case when AC.type ='FSC' then BM.GDSPNR when BM.VendorName ='Amadeus'
   then BM.GDSPNR else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',            
   BM.VendorCommissionPercent,PB.ServiceFee,BM.AgentROE,BM.AgentCurrency,
   PB.B2bMarkup,PB.BFC,PB.FMCommission,    
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'           
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'          
     else CU.IATA end as IATA,    
   case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end  as 'Currency',BM.ROE,            
   BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.pid,

  case when PB.paxType='LBR' then 'ADULT'  
   else  
   PB.paxType end as paxType,PB.paxFName,PB.paxLName,            
   PB.managementfees,PB.baggage,
   case when BM.BookingSource!='ManualTicketing' 
   then PB.Markup else 0 end as Markup,  
 -- Basic Fare
CASE 
    WHEN (ISNULL(PB.basicFare, 0) + ISNULL(PB.LonServiceFee, 0)) - 
         (ISNULL(PB1.basicFare, 0) + ISNULL(PB1.LonServiceFee, 0)) < 0 THEN 0
    ELSE (ISNULL(PB.basicFare, 0) + ISNULL(PB.LonServiceFee, 0)) - 
         (ISNULL(PB1.basicFare, 0) + ISNULL(PB1.LonServiceFee, 0))
END AS basicFare,

-- Total Tax
CASE 
    WHEN ISNULL(PB.totalTax, 0) - ISNULL(PB1.totalTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.totalTax, 0) - ISNULL(PB1.totalTax, 0)
END AS totalTax,

-- YRTax
CASE 
    WHEN ISNULL(PB.YRTax, 0) - ISNULL(PB1.YRTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.YRTax, 0) - ISNULL(PB1.YRTax, 0)
END AS YRTax,

-- YQ
CASE 
    WHEN ISNULL(CAST(PB.YQ AS DECIMAL(18,2)), 0) - ISNULL(CAST(PB1.YQ AS DECIMAL(18,2)), 0) < 0 THEN 0
    ELSE ISNULL(CAST(PB.YQ AS DECIMAL(18,2)), 0) - ISNULL(CAST(PB1.YQ AS DECIMAL(18,2)), 0)
END AS YQ,

-- WOTax
CASE 
    WHEN ISNULL(PB.WOTax, 0) - ISNULL(PB1.WOTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.WOTax, 0) - ISNULL(PB1.WOTax, 0)
END AS WOTax,

-- INTax
CASE 
    WHEN ISNULL(PB.INTax, 0) - ISNULL(PB1.INTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.INTax, 0) - ISNULL(PB1.INTax, 0)
END AS INTax,

-- JNTax
CASE 
    WHEN ISNULL(PB.JNTax, 0) - ISNULL(PB1.JNTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.JNTax, 0) - ISNULL(PB1.JNTax, 0)
END AS JNTax,

-- K7Tax
CASE 
    WHEN ISNULL(PB.k7tax, 0) - ISNULL(PB1.k7tax, 0) < 0 THEN 0
    ELSE ISNULL(PB.k7tax, 0) - ISNULL(PB1.k7tax, 0)
END AS K7Tax,

-- OCTax
CASE 
    WHEN ISNULL(PB.OCTax, 0) - ISNULL(PB1.OCTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.OCTax, 0) - ISNULL(PB1.OCTax, 0)
END AS OCTax,

-- ExtraTax
CASE 
    WHEN ISNULL(PB.ExtraTax, 0) - ISNULL(PB1.ExtraTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.ExtraTax, 0) - ISNULL(PB1.ExtraTax, 0)
END AS ExtraTax,

-- YMTax
CASE 
    WHEN ISNULL(PB.YMTax, 0) - ISNULL(PB1.YMTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.YMTax, 0) - ISNULL(PB1.YMTax, 0)
END AS YMTax,
   PB.BaggageFare,PM.CardType,   
   PM.MaskCardNumber as 'CardNumber',PM.mer_amount,PM.billing_address,
   PM.billing_name,PM.order_id,PM.tracking_id,
   --BI.airlinePNR,BI.cabin,BI.farebasis,            
  case when AL.GroupId='16' then Cast(ISNULL(ATT.TravelRequestNumber,'0') as varchar(50))    
  else    
  Replace(ATT.VesselName, '&','and') end as 'VesselName',    
  case when Al.GroupId='16' then  ISNULL(REPLACE(ATT.CostCentre,'&','and'),'')    
  else    
  Replace(ATT.TR_POName, '&','and') end as 'TR_POName',ATT.Bookedby,ATT.AType,    
  case when AL.GroupId='16' then  ISNULL(replace(ATT.EmpDimession,'&','and'),'')    
  else    
  ATT.RankNo end as 'RankNo',      
   Replace(ATT.CarbonFootprint, '&','and') as 'CarbonFootprint', isnull(ATT.Remarks,'') as 'Remarks',isnull(ATT.CurrencyConversionRate,'') as 'CurrencyConversionRate',isnull(ATT.NameofApprover,'') as 'NameofApprover',    
   BBM.TotalCommission as Surcharge,ISNULL(SSR.SSR_Amount,0) AS 'SSR_Amount',ISNULL(SSR.fkPassengerid,0) AS 'fkPassengerid',    
   
   Case When ED.CustomerCode='AgentCustID' and (B2BR.Icast !='AgentCustID' or B2BR.Icast is null) then Isnull(B2BR.Icast,B2BR1.Icast)    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode    
   End As Icast,    
   B2BR.LocationCode, BranchCode = '', PR.EmpCode,--AC.type 'AirLineType'    ,    
   case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',    
   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0)+(isnull(pb.VendorServiceFee,0)*isnull(bm.ROE,0)))as decimal(18,2)) as MarkupOnTaxFare,    
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
   else '0' end as Intcompanytrans,PB.EMDNumber, 
   case when PB.EMDNumber is null then
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) 
  else
   '0.00' end
  as AirlineFee ,'' as 'TicketType','Date Change' as EntryType,PB.EMDStatus,
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) as AirlineFee1 
   FROM tblBookMaster BM WITH (NOLOCK)      
   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster            
   LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid   
   INNER JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id                     
   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid    
   LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID            
   LEFT JOIN tblERPDetails ED WITH (NOLOCK)     
     ON ( BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country )     
    OR (BM.TicketingPCC IS not NULL AND BM.TicketingPCC = ED.OwnerID and ED.AgentCountry=BM.Country)               
   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID               
   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID            
   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID        
    LEFT Join mCardDetails CD WITH (NOLOCK) ON RIGHT(CD.MaskCardNumber,4)=RIGHT(PM.MaskCardNumber,4)   
   AND CD.MarketPoint=BM.Country AND CD.Status=1  
   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK)   
   on (BM.OfficeID = CU.OfficeID)   
        OR (BM.TicketingPCC IS not NULL AND BM.TicketingPCC = CU.OfficeID)  
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
   AND PM.payment_mode is not null  
   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country             
   and AL.userTypeID IN(2,3,5) --For UAE usertype is 2 ***    --- 3 is for marine uae and 5 is for RBT    
   and ISNULL(PB.TicketNumber,'') != ''    
   and (B2BR.FKUserID not in (49932,51685,51647) or B2BR1.FKUserID not in (49932,51685,51647))    
   and BM.totalFare > 0    
 --  and BM.riyaPNR IN('2HRK56')    
   and BM.VendorName Not in ('STS')  
    AND  EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM1  
    WHERE BM.PARENTORDERID = BM1.ORDERID AND BM1.bookingstatus=18  
)  
   ORDER BY BM.inserteddate DESC    
  END 
  
 If @Action = 'UAEReissueCancellationTickets'  
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
    (Cast(isnull(PB.PLBCommission,0) as decimal(18,2)) + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2))) as PLBCommission,  
	CAST(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,
    case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'  
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'        
     else CU.IATA end as IATA,  
    BM.frmSector, BM.toSector, BM.flightNo, BM.travClass, PB.FMCommission,  
    PB.RefundAmount as totalFare, BM.AgentID, BM.Country, BM.fromTerminal, BM.toTerminal, BM.equipment,          
    '0.00' as TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR', BM.VendorCommissionPercent,   
    case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,BM.orderId,          
    PB.pid, PB.title, PB.ticketNum, PB.pid,PB.RefundAmount as basicFare,'0.00' as totalTax, PB.paxType,          
    PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,           
    '0.00' as managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,           
    '0.00' as YRTax, '0.00' as YQ, '0.00' as INTax,'0.00'  as 'JNTax', '0.00' as OCTax, '0.00' as ExtraTax,          
    PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,          
    --BI.airlinePNR, BI.cabin, BI.farebasis,          
    ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,  
   Case When ED.CustomerCode='AgentCustID' and (BR.Icast !='AgentCustID' or BR.Icast is null) then Isnull(BR.Icast,B2BR1.Icast)  
   When ED.CustomerCode !='AgentCustID' and BR.Icast ='AgentCustID' then ED.CustomerCode  
   When ED.CustomerCode !='AgentCustID' and BR.Icast !='AgentCustID' then ED.CustomerCode  
   End As Icast,
    BR.LocationCode, '' as BranchCode,'' as DivisionCode, PR.EmpCode,ATT.OBTCno,         
    '0.00' as Canfees, '0.00' as ServiceFees,   
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
	LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid
    LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id          
    LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID          
    LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID          
    LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid  
    LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID          
    LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID          
	LEFT JOIN B2BRegistration B2BR1 WITH (NOLOCK) ON AL.ParentAgentID = B2BR1.FKUserID  
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
    and BM.BookingStatus In(1) --As confirm with Mansavee           
   -- and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)             
    and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'          
    and BM.Country in('AE','SA')  
    and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country       
    and AL.userTypeID IN(2,3,5) --For UAE usertype is 2 ***    --- 3 is for marine uae and 5 is for RBT  
    and PB.RefundAmount > 0  
    and ISNULL(PB.TicketNumber,'') != ''  
   -- and BM.riyaPNR in ('R10VS8')  
    and BM.VendorName Not in ('STS')  
    ORDER BY BM.IssueDate DESC  
 End  

 IF @Action = 'EMDUAEPendingTickets'            
  BEGIN    
   SELECT TOP 10000   
    case when al.userTypeID=2 and bm.Country='SA' and  
 B2BR.icast not in ('SACUST000004','SACUST000011','SACUST000017','SACUST000013' ) then  
 '' else U.EmployeeNo end as UserName,PB1.TicketNumber AS OLDTicketNo,
 PB.EMDNumber,1 as EMDStatus, 
  -- U.EmployeeNo as UserName,--ED.VendorCode,    
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
       ELSE isnull(PB.Markup,0) END AS VendIATACommAmount,
	   BM.MainAgentId as TicketingUserID,    
   case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,
   isnull(BM.IssueDate, BM.inserteddate) as PostingDate,    
   Case when EV.VendorCode is null then    
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913'     
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'    
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'    
   else ED.VendorCode end ELSE EV.VendorCode end as VendorCode,Pm.payment_mode, isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,    
   case when BM.VendorName='TravelFusion' then 'RIYAAPITF' 
   else BM.OfficeID end as OfficeID,     
   case when PM.CardConfigurationType = 'Riya'  
   THEN 'CORPORATE' when PM.CardConfigurationType = 'Customer'  
   THEN 'CUSTOMER'   
   else '' END as UATP,   
   BM.pkId,BM.riyaPNR,BM.inserteddate,BM.IssueDate,BM.CounterCloseTime,ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, PB.IATACommission as CustIATACommAmount ,    
   (Cast(isnull(PB.PLBCommission,0) as decimal(18,2))  
   + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2))) as PLBCommission,  
    Cast(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,
   BM.depDate,BM.arrivalDate,BM.airCode,BM.Vendor_No,BM.IATACommission,
   BM.deptTime,BM.arrivalTime,BM.frmSector,BM.toSector,            
   BM.flightNo,BM.travClass,BM.AgentID,BM.Country,BM.fromTerminal,
   BM.toTerminal,BM.equipment,BM.TotalDiscount,
   Case when AC.type ='FSC' then BM.GDSPNR when BM.VendorName ='Amadeus'
   then BM.GDSPNR else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',            
   BM.VendorCommissionPercent,PB.ServiceFee,BM.AgentROE,BM.AgentCurrency,
   PB.B2bMarkup,PB.BFC,PB.FMCommission,    
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'           
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'          
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'          
     else CU.IATA end as IATA,    
   case when BM.VendorName='TravelFusion' then 'INR' else Cu.Currency end  as 'Currency',BM.ROE,            
   BM.RegistrationNumber,PB.title,PB.TicketNumber,PB.pid,

  case when PB.paxType='LBR' then 'ADULT'  
   else  
   PB.paxType end as paxType,PB.paxFName,PB.paxLName,            
  0 as managementfees,PB.baggage,
   case when BM.BookingSource!='ManualTicketing' 
   then PB.Markup else 0 end as Markup,  
0 as basicFare,0 AS totalTax,0 AS YRTax,0 AS YQ,0 AS WOTax,
0 AS INTax,0 AS JNTax,0 AS K7Tax,0 AS OCTax,
0 AS ExtraTax,0 AS YMTax,

   PB.BaggageFare,PM.CardType,   
   PM.MaskCardNumber as 'CardNumber',PM.mer_amount,PM.billing_address,
   PM.billing_name,PM.order_id,PM.tracking_id,
   --BI.airlinePNR,BI.cabin,BI.farebasis,            
  case when AL.GroupId='16' then Cast(ISNULL(ATT.TravelRequestNumber,'0') as varchar(50))    
  else    
  Replace(ATT.VesselName, '&','and') end as 'VesselName',    
  case when Al.GroupId='16' then  ISNULL(REPLACE(ATT.CostCentre,'&','and'),'')    
  else    
  Replace(ATT.TR_POName, '&','and') end as 'TR_POName',ATT.Bookedby,ATT.AType,    
  case when AL.GroupId='16' then  ISNULL(replace(ATT.EmpDimession,'&','and'),'')    
  else    
  ATT.RankNo end as 'RankNo',      
   Replace(ATT.CarbonFootprint, '&','and') as 'CarbonFootprint', isnull(ATT.Remarks,'') as 'Remarks',isnull(ATT.CurrencyConversionRate,'') as 'CurrencyConversionRate',isnull(ATT.NameofApprover,'') as 'NameofApprover',    
   BBM.TotalCommission as Surcharge,ISNULL(SSR.SSR_Amount,0) AS 'SSR_Amount',ISNULL(SSR.fkPassengerid,0) AS 'fkPassengerid',    
   
   Case When ED.CustomerCode='AgentCustID' and (B2BR.Icast !='AgentCustID' or B2BR.Icast is null) then Isnull(B2BR.Icast,B2BR1.Icast)    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast ='AgentCustID' then ED.CustomerCode    
   When ED.CustomerCode !='AgentCustID' and B2BR.Icast !='AgentCustID' then ED.CustomerCode    
   End As Icast,    
   B2BR.LocationCode, BranchCode = '', PR.EmpCode,--AC.type 'AirLineType'    ,    
   case when BM.VendorName = 'Amadeus' then 'FSC' else AC.type end as 'AirLineType',    
   cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0)+(isnull(pb.VendorServiceFee,0)*isnull(bm.ROE,0)))as decimal(18,2)) as MarkupOnTaxFare,    
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
   else '0' end as Intcompanytrans,PB.EMDNumber, 
   case when PB.EMDNumber is null then
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) 
  else
   '0.00' end
  as AirlineFee ,'' as 'TicketType','Date Change' as EntryType,
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) as AirlineFee1 
   FROM tblBookMaster BM WITH (NOLOCK)     
   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster            
   LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid   
   INNER JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id                     
   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid    
   LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID            
   LEFT JOIN tblERPDetails ED WITH (NOLOCK)     
     ON ( BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country )     
    OR (BM.TicketingPCC IS not NULL AND BM.TicketingPCC = ED.OwnerID and ED.AgentCountry=BM.Country)               
   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID               
   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID            
   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID        
    LEFT Join mCardDetails CD WITH (NOLOCK) ON RIGHT(CD.MaskCardNumber,4)=RIGHT(PM.MaskCardNumber,4)   
   AND CD.MarketPoint=BM.Country AND CD.Status=1  
   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK)   
   on (BM.OfficeID = CU.OfficeID)   
        OR (BM.TicketingPCC IS not NULL AND BM.TicketingPCC = CU.OfficeID)  
   LEFT JOIN B2BRegistration B2BR1 WITH (NOLOCK) ON AL.ParentAgentID = B2BR1.FKUserID    
   LEFT JOIN TblErpVendorCode EV WITH (NOLOCK) on BM.OfficeID = EV.OfficeID and ED.AgentCountry in ('AE')    
   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode        
   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId    
   left join tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1    
   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'    
   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)    
   and BM.BookingStatus In (1,6) --As confirm with Mansavee            
   -- For Booking    
   --and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)            
   and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'            
   and BM.Country in('AE','SA')   
   AND PM.payment_mode is not null  
   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country             
   and AL.userTypeID IN(2,3,5) --For UAE usertype is 2 ***    --- 3 is for marine uae and 5 is for RBT    
   and ISNULL(PB.TicketNumber,'') != ''    
   and (B2BR.FKUserID not in (49932,51685,51647) or B2BR1.FKUserID not in (49932,51685,51647))    
   and BM.totalFare > 0
   and PB.EMDStatus=0
   and ISNULL(PB.EMDNumber,'') != ''
 --  and BM.riyaPNR IN('2HRK56')    
   and BM.VendorName Not in ('STS')  
    AND  EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM1  
    WHERE BM.PARENTORDERID = BM1.ORDERID AND BM1.bookingstatus=18  
)  
   ORDER BY BM.inserteddate DESC    
  END  
             
 IF @Action = 'US-CAReissueBookingtickets'     
 BEGIN            
    SELECT TOP 10000 PB.ticketnumber, PB1.TicketNumber AS OLDTicketNo,
	PB.EMDNumber,
	ED.AgentCountry,ED.OwnerCountry, ED.ERPCountry, BM.MainAgentId,            
    case when al.GroupId in (27,28) then   
    U.EmployeeNo else '' end as UserName,  
  --  '180409' as UserName,  
 BM.bookingStatus, ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,BM.airCode,PB.FMCommission,     
    --ED.VendorCode,    
 'TrvlNxt' as BookingType,    
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
    BBM.TotalCommission as Surcharge,
	isnull(PB.VendorServiceFee,'0.00') as VendorServiceFee,    
    PB.pid,BM.pkId, Cast(isnull(PB.IATACommission,0) as decimal(18,2)) as CustIATACommAmount ,    
    case when PM1.ParentOrderId is not null then PM1.MerchantId else PM.MerchantId end as 'PaymentGateway',    
    (Cast(isnull(PB.PLBCommission,0) as decimal(18,2))  
 + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2))) as PLBCommission,    
  Cast(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,
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
   case when PM.CardConfigurationType = 'Riya'  
   THEN 'CORPORATE' when PM.CardConfigurationType = 'Customer'  
   THEN 'CUSTOMER'   
   else '' END as UATP,   
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
  PB.title, 
      PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,             
    PB.managementfees, PB.baggage,case when BM.BookingSource!='ManualTicketing' 
	then PB.Markup else 0 end as Markup, BM.AgentMarkup,  PB.paxType, 
 -- Basic Fare
CASE 
    WHEN (ISNULL(PB.basicFare, 0) + ISNULL(PB.Markup, 0) + ISNULL(PB.LonServiceFee, 0)) -
         (ISNULL(PB1.basicFare, 0) + ISNULL(PB1.Markup, 0) + ISNULL(PB1.LonServiceFee, 0)) < 0 
    THEN 0
    ELSE (ISNULL(PB.basicFare, 0) + ISNULL(PB.Markup, 0) + ISNULL(PB.LonServiceFee, 0)) -
         (ISNULL(PB1.basicFare, 0) + ISNULL(PB1.Markup, 0) + ISNULL(PB1.LonServiceFee, 0))
END AS basicFare,

-- Total Tax
CASE 
    WHEN ISNULL(PB.totalTax, 0) - ISNULL(PB1.totalTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.totalTax, 0) - ISNULL(PB1.totalTax, 0)
END AS totalTax,

-- K3Tax
CASE 
    WHEN ISNULL(PB.JNTax, 0) - ISNULL(PB1.JNTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.JNTax, 0) - ISNULL(PB1.JNTax, 0)
END AS K3Tax,

-- YRTax
CASE 
    WHEN ISNULL(PB.YRTax, 0) - ISNULL(PB1.YRTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.YRTax, 0) - ISNULL(PB1.YRTax, 0)
END AS YRTax,

-- YQ
CASE 
    WHEN ISNULL(TRY_CAST(PB.YQ AS decimal(18,2)), 0) - ISNULL(TRY_CAST(PB1.YQ AS decimal(18,2)), 0) < 0 THEN 0
    ELSE ISNULL(TRY_CAST(PB.YQ AS decimal(18,2)), 0) - ISNULL(TRY_CAST(PB1.YQ AS decimal(18,2)), 0)
END AS YQ,

-- INTax
CASE 
    WHEN ISNULL(PB.INTax, 0) - ISNULL(PB1.INTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.INTax, 0) - ISNULL(PB1.INTax, 0)
END AS INTax,

-- JNTax (JNTax + K7Tax)
CASE 
    WHEN (ISNULL(PB.JNTax, 0) + ISNULL(PB.k7tax, 0)) - (ISNULL(PB1.JNTax, 0) + ISNULL(PB1.k7tax, 0)) < 0 THEN 0
    ELSE (ISNULL(PB.JNTax, 0) + ISNULL(PB.k7tax, 0)) - (ISNULL(PB1.JNTax, 0) + ISNULL(PB1.k7tax, 0))
END AS JNTax,

-- OCTax
CASE 
    WHEN ISNULL(PB.OCTax, 0) - ISNULL(PB1.OCTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.OCTax, 0) - ISNULL(PB1.OCTax, 0)
END AS OCTax,

-- ExtraTax
CASE 
    WHEN ISNULL(PB.ExtraTax, 0) - ISNULL(PB1.ExtraTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.ExtraTax, 0) - ISNULL(PB1.ExtraTax, 0)
END AS ExtraTax,

-- RFTax
CASE 
    WHEN ISNULL(PB.RFTax, 0) - ISNULL(PB1.RFTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.RFTax, 0) - ISNULL(PB1.RFTax, 0)
END AS RFTax,

-- WOTax
CASE 
    WHEN ISNULL(PB.WOTax, 0) - ISNULL(PB1.WOTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.WOTax, 0) - ISNULL(PB1.WOTax, 0)
END AS WOTax,

-- YMTax
CASE 
    WHEN ISNULL(PB.YMTax, 0) - ISNULL(PB1.YMTax, 0) < 0 THEN 0
    ELSE ISNULL(PB.YMTax, 0) - ISNULL(PB1.YMTax, 0)
END AS YMTax,	      
    PM.CardType,case when PM1.ParentOrderId is not null then PM1.mer_amount else PM.mer_amount end as 'mer_amount', PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,    
    --BI.airlinePNR, BI.cabin, BI.farebasis,    
    PB.ServiceFee as 'ServiceFees',     
    case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,    
    case when PM1.ParentOrderId is not null then PM1.payment_mode else PM.payment_mode end as payment_mode,    
    cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,    
   (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,    
    '' as Narration,                     
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
 when BM.VendorName='OneAPIAirArabia' then 'OneAPIAir'   
    Else BM.VendorName end as CRSCode,                  
     --case when ED.AgentCountry='US' and BM.AgentCurrency = 'USD' then '0'     
    --when ED.AgentCountry='CA' and BM.AgentCurrency = 'CAD' then '0'     
    --else BM.AgentROE end as 'SalesCurrROE',    
    Case when ED.AgentCountry = ED.OwnerCountry then '0' else BM.AgentROE end as 'SalesCurrROE',    
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
    , Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans,
	PB.EMDNumber,case when PB.EMDNumber is null then
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) 
  else
   '0.00' end
  as AirlineFee ,'' as 'TicketType','' as EntryType,PB.EMDStatus,
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) as AirlineFee1 
    FROM tblBookMaster BM WITH (NOLOCK)     
    LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster            
	LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid   
    INNER JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id       
    LEFT JOIN Paymentmaster PM1 WITH (NOLOCK) ON BM.orderId = PM1.ParentOrderId  and pm1.AmendmentRefNo is null   
    LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID       
	LEFT JOIN mUser U on BM.MainAgentId = U.ID            
    LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid    
    LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID            
    LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null            
    LEFT JOIN B2BRegistration BR1 WITH (NOLOCK) ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null            
    LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode            
    LEFT JOIN tblOwnerCurrency TOC WITH (NOLOCK) ON TOC.OfficeID = BM.OfficeID            
    LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode and AM.Status = 'A'   
   LEFT Join mCardDetails CD WITH (NOLOCK) ON RIGHT(CD.MaskCardNumber,4)=RIGHT(PM.MaskCardNumber,4)   
   AND CD.MarketPoint=BM.Country AND CD.Status=1 and CD.UserType = (Select value from mcommon where category='Usertype' and Id=2)    
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
--	and bm.riyapnr='TRNZAV117R'
 and PM.payment_mode is not null  
 AND  EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM1  
    WHERE BM.PARENTORDERID = BM1.ORDERID AND BM1.bookingstatus=18  
)  
  
    ORDER BY BM.IssueDate DESC        
 END   
     
IF @Action = 'EMDUS-CAPendingtickets'     
 BEGIN            
    SELECT TOP 10000 PB.EMDNumber as TicketNumber, PB1.TicketNumber AS OLDTicketNo,
	PB.EMDNumber,1 as EMDStatus,
	ED.AgentCountry,ED.OwnerCountry, ED.ERPCountry, BM.MainAgentId,            
    case when al.GroupId in (27,28) then   
 U.EmployeeNo else '' end as UserName,  
   -- U.EmployeeNo as UserName,  
 BM.bookingStatus, ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier,BM.airCode,PB.FMCommission,     
    --ED.VendorCode,    
 'TrvlNxt' as BookingType,    
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
    PB.pid,BM.pkId, Cast(isnull(PB.IATACommission,0) as decimal(18,2)) as CustIATACommAmount ,    
    case when PM1.ParentOrderId is not null then PM1.MerchantId else PM.MerchantId end as 'PaymentGateway',    
    (Cast(isnull(PB.PLBCommission,0) as decimal(18,2))  
 + Cast(isnull(PB.DropnetCommission,0) as decimal(18,2))) as PLBCommission, Cast(isnull(PB.GSTonPLB,0) as decimal(18,2)) as GSTonPLB,    
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
   case when PM.CardConfigurationType = 'Riya'  
   THEN 'CORPORATE' when PM.CardConfigurationType = 'Customer'  
   THEN 'CUSTOMER'   
   else '' END as UATP,   
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
  PB.title, PB.paxType,
      PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,             
    PB.managementfees, PB.baggage,case when BM.BookingSource!='ManualTicketing' 
	then PB.Markup else 0 end as Markup, BM.AgentMarkup,  
0 as basicFare,0 AS totalTax,0 AS K3Tax,0 AS YRTax,0 AS YQ,
0 AS INTax,0 AS JNTax,
0 AS OCTax,0 AS ExtraTax,
0 AS RFTax,0 AS WOTax,0 AS YMTax,	      
    PM.CardType,case when PM1.ParentOrderId is not null then PM1.mer_amount else PM.mer_amount end as 'mer_amount', PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,    
    --BI.airlinePNR, BI.cabin, BI.farebasis,    
    0 as 'ServiceFees',     
    case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,    
    case when PM1.ParentOrderId is not null then PM1.payment_mode else PM.payment_mode end as payment_mode, 0 as MarkupOnTaxFare, 0 as MarkupOnBaseFare,  
  --  cast((isnull((CASE WHEN ((BM.B2bFareType=2 or BM.B2bFareType=3)) THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) as MarkupOnTaxFare,    
  -- (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +PB.BFC) as MarkupOnBaseFare,    
    '' as Narration,                     
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
 when BM.VendorName='OneAPIAirArabia' then 'OneAPIAir'   
    Else BM.VendorName end as CRSCode,           
   
    Case when ED.AgentCountry = ED.OwnerCountry then '0' else BM.AgentROE end as 'SalesCurrROE',    
    Case when ED.AgentCountry != ED.OwnerCountry and ED.OwnerCountry != ED.ERPCountry and ED.AgentCountry != ED.ERPCountry then BM.AgentCurrency else '' end as 'SalesCurr',    
        
   case when BM.VendorName = 'TravelFusion' and BM.OfficeID = 'riyaapi' then 'INR' else TOC.Currency end as 'PurchaseCurr',            
    BM.ROE as 'PurchaseCurrROE',            
    PB.baggage            
   ,cast(((SSR.SSR_Amount ) /BM.ROE)as decimal(18,2)) as 'extrabagAmount', ISNULL(PM.AuthCode,'') as CVV,--1055 attribute           
-- cast((isnull((CASE WHEN BM.B2bFareType=2 or BM.B2bFareType=3 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) as MarkupOnTax_,            
-- (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) +PB.BFC) as MarkupOnFare_            
    0 as MarkupOnTax_ , 0 as MarkupOnFare_,  
    case when BM.VendorName = 'Amadeus' then 'FSC' when BM.VendorName = 'Sabre' then 'FSC' else AC.type end as 'AirLineType',    
    case when PM1.ParentOrderId is not null  then PM1.bank_ref_no else PM.bank_ref_no end as TransactionNo    
    ,ISNULL(ATT.CostCenter,'') as _str1060, ISNULL(ATT.Traveltype,'')  as _str1061 ,ISNULL(ATT.EmpDimession,'')  as _str1028, ISNULL(ATT.Changedcostno,'')  as _str1025,    
    ISNULL(ATT.Travelduration,'')  as _str1054, ISNULL(ATT.TASreqno,'')  as _str1022, ISNULL(ATT.Companycodecc,'')  as _str1023, ISNULL(ATT.Projectcode,'') as _str1024    
    , Case when ED.AgentCountry = ED.OwnerCountry then '0' else '1' end as Intcompanytrans,
	PB.EMDNumber,case when PB.EMDNumber is null then
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) 
  else
   '0.00' end
  as AirlineFee ,'' as 'TicketType','' as EntryType,
  Cast(isnull(PB.AirlineFee,0) as decimal(18,2)) as AirlineFee1 
    FROM tblBookMaster BM WITH (NOLOCK)    
    LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster            
	LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid   
    INNER JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id       
    LEFT JOIN Paymentmaster PM1 WITH (NOLOCK) ON BM.orderId = PM1.ParentOrderId    
    LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID       LEFT JOIN mUser U on BM.MainAgentId = U.ID            
    LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid    
    LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID            
    LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null            
    LEFT JOIN B2BRegistration BR1 WITH (NOLOCK) ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null            
    LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode            
    LEFT JOIN tblOwnerCurrency TOC WITH (NOLOCK) ON TOC.OfficeID = BM.OfficeID            
    LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode and AM.Status = 'A'   
   LEFT Join mCardDetails CD WITH (NOLOCK) ON RIGHT(CD.MaskCardNumber,4)=RIGHT(PM.MaskCardNumber,4)   
   AND CD.MarketPoint=BM.Country AND CD.Status=1 and CD.UserType = (Select value from mcommon where category='Usertype' and Id=2)    
    --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId            
    LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId    
    left join tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1            
    WHERE    
    BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'          
    and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)    
    and BM.BookingStatus IN(1,6)  --As confirm with Mansavee            
   -- and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)               
    and BM.inserteddate > (Getdate()-31) -- '2021-07-31 23:59:59.999'            
    and ED.AgentCountry in ('US','CA')--('IN','AE','US','CA')       
    and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country            
    and AL.userTypeID in (2) --For US usertype is 2 *** 
	and PB.EMDStatus=0
	and ISNULL(PB.EMDNumber,'') != ''
    and BM.VendorName Not in ('STS')    
    and BM.totalFare > 0   
 and PM.payment_mode is not null  
 AND  EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM1  
    WHERE BM.PARENTORDERID = BM1.ORDERID AND BM1.bookingstatus=18  
)  
  
    ORDER BY BM.IssueDate DESC        
   END 

IF @Action = 'US-CAReissueCancellationtickets'          
    BEGIN          
    SELECT TOP 10000 PB.ticketnumber,U.EmployeeNo as UserName, BM.bookingStatus,  
    --ED.VendorCode,  
    case when BM.BookingSource = 'GDS' then 'TJQ' else 'TrvlNxt' end as BookingType,  
   case when BM.BookingSource = 'Retrive PNR Accounting'
   THEN PB.FMCommission   
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
	   '0.00' as VendorServiceFee,  
    ISNULL(BM.ValidatingCarrier,BM.airCode) as ValidatingCarrier, '0.00' as CustIATACommAmount   
    ,'0.00' as PLBCommission, '0.00' as GSTonPLB,  
    '0.00' as Surcharge,  
   case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'BOMVEND007913'   
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then 'VEND000178'  
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then 'VEND00102'  
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then 'UVEND00066'  
   when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then 'CVEND00041'  
   when BM.OfficeID = '00FK' and ED.AgentCountry = 'US' Then 'UVEND01206'  
   else ED.VendorCode end as VendorCode,  
    BM.pkId, BM.riyaPNR, BM.inserteddate, BM.CounterCloseTime, BM.RegistrationNumber, BM.IssueDate,          
    BM.depDate, BM.arrivalDate, BM.airCode, BM.Vendor_No, BM.IATACommission, BM.deptTime,      
    case When PM.CardType = 'Amex' THEN '1' ELSE '0' END AS BTAsales,  
    BM.arrivalTime, case when CD.Configuration = 'RiyaCard' 
	THEN 'CORPORATE' when CD.Configuration = 'CustomerCard'
	THEN 'CUSTOMER' when PM.payment_mode = 'passThrough' 
	THEN 'CUSTOMER' else '' END as UATP,
	'0.00' as FMCommission,  
    case when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) < 10then 'RIYAAPITF'    
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'IN' then '14338855'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'AE' then '86215290'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'US' then '45828661'        
     when BM.VendorName='TravelFusion' and LEN(PB.ticketNum) > 10and BM.Country = 'CA' then '62500082'        
     else CU.IATA end as IATA,  
    BM.frmSector, BM.toSector, BM.flightNo, BM.travClass,          
    PB.RefundAmount as totalFare, BM.AgentID, BM.Country,
	BM.fromTerminal, BM.toTerminal, BM.equipment, 
	PB.CancelledDate as PostingDate,   
    '0.00' as TotalDiscount, Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR',
	'0.00' as VendorCommissionPercent,   
    case when BM.VendorName='TravelFusion' then 'RIYAAPITF' else BM.OfficeID end as OfficeID,BM.orderId,          
    PB.pid, PB.title, PB.ticketNum, PB.pid, PB.RefundAmount as basicFare,
	'0.00' as totalTax, PB.paxType,
	'0.00' as YMTax,    
    PB.paxFName, PB.paxLName, ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as PaxName,           
    PB.managementfees, PB.baggage, case when BM.BookingSource!='ManualTicketing' then PB.Markup else 0 end as Markup,          
    '0.00' as YRTax, '0.00' as YQ, '0.00' as INTax,
	'0.00' as 'JNTax',
	'0.00' as OCTax,'0.00' as ExtraTax, '0.00' as WOTax,        
    PM.CardType, PM.MaskCardNumber as 'CardNumber', PM.mer_amount, PM.billing_address, PM.billing_name, PM.order_id, PM.tracking_id,          
    --BI.airlinePNR, BI.cabin, BI.farebasis,          
    ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,          
    Icast,BR.LocationCode, '' as BranchCode,'' as DivisionCode,          
    '0.00' as Canfees, '0.00' as ServiceFees,  
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
	LEFT JOIN tblPassengerBookDetails PB1 WITH (NOLOCK) ON pb1.pid=pb.opid    
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
    BM.IsBooked =1 
	and BM.AgentID != 'B2C'       
    and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)  
    and BM.BookingStatus IN(4,11) --As confirm with Mansavee          
    and PB.CancERPResponseID is null and (PB.CancERPPuststatus = 0 or PB.CancERPPuststatus is null)             
    and BM.inserteddate > (Getdate()-360) -- '2021-08-31 23:59:59.999'          
    and ED.AgentCountry in ('US','CA')          
    and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country         
    and AL.userTypeID in (2) --For US CA usertype is 2 ***    
    and BM.VendorName Not in ('STS')  
    and BM.totalFare > 0  
	AND PB.RefundAmount > 0
    --and PB.TicketNumber = '6024766875'  
     --and bm.riyaPNR  In ('8CU3A1')  
    ORDER BY BM.IssueDate DESC          
   END 
   

END