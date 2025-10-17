--sp_helptext Insert_Tickets_ERP_Data                    
--Select riyapnr,* from TRVLNXT_Tickets_ERPStatus where id > 26155                  
--delete from TRVLNXT_Tickets_ERPStatus                    
                    
CREATE PROC [dbo].[Insert_Tickets_ERP_Data]                        
@RiyaPNR varchar(30) = null                        
AS                        
BEGIN                        
                        
 insert into TRVLNXT_Tickets_ERPStatus (                    
 UserTypeID,Country,TransactionType,CancellationPenalty,CancellationCharges                    
 ,AgentID,RiyaPNR,TicketNumber                      
,AirLineCode,AirLineNumber,OldTicketNumber,OfficeID,PostingDate,BookingDate,TravelStartDate,TravelEndDate                      
,ProductType,CustomerNumber,PayToVendor,BTASales,GDSPNR,AirlinePNR,PaxType,Salutation,PaxName,EmployeeCode                      
,SalesCurrencyCode,SalesCurrencyFactor,SalesExchangeRate,BaseAmount,TaxAmount,TotalAmount,PromoDiscountAmount                      
,ServiceFee,ManagementFee,SurchargeAmount,VendCommAmount,DateChangePenalty,CustIATACommAmount,CustPLBAmount                      
,VendIATACommAmount,QTax,MCO,UATP_MCOSales,MarkupOnBaseFare,MarkupOnTaxFare,MarkupOnCancellation,UATP,CardType                      
,CardNumber,OBTaxAmount,OCTaxAmount,YQTaxAmount,YRTaxAmount,K3TaxAmount,XTTaxAmount,INTaxAmount,YMTaxAmount,WOTaxAmount                      
,PHFTaxAmount,TTFTaxAmount,TRFTaxAmount,CMFTaxAmount,COMMTaxAmount,COMMBFTaxAmount,RCSTaxAmount,RCFTaxAmount,RFTaxAmount                      
,ExtraBaggageAmount,PaymentMode,TicketingUserID,Narration,PromotionCode,IATACode,BookingUserID,OrderID,ProductCode                      
,DealCode,CrsCode,CreatedDate              
,BMPkId              
,EDVendorCode              
,CounterCloseTime              
,TravelStartTime              
,TravelEndTime              
,FromCity              
,ToCity              
,FlightNo              
,BMtravClass              
,BMfromTerminal              
,BMtoTerminal              
,BMEquipment              
,PurchCurr              
,PurchCurrROE              
,PBPId              
,AirLineType              
,BMTotalDiscount              
,PREmpCode              
,BIfarebasis              
,BookingStatus              
,IsBooked              
,BMRegistrationNumber              
,BMVendor_No              
,PBB2bMarkup              
,PBBFC              
,PBBaggage              
,PM_Mer_Amount              
,PM_Billing_Address              
,PM_Billing_Name              
,PM_Tracking_id              
,BICabin              
,ATT_VesselName              
,ATT_TR_POName              
,ATT_Bookedby              
,ATT_AType              
,ATT_RankNo              
,BMAgentMarkup              
,PBRFTax              
,airCode              
,BMVendorName              
,B2bFareType              
,BMB2bFareType              
,PBMarkup              
,MainAgentId             
            
,PBBaggageFare            
,MCOAmount            
,MCOTicketNo            
,McoCommissionAmount          
,LocationCode          
,BranchCode          
,DivisionCode

,ATTOBTCno
,Traveltype
,FareType
,Meal_Charges
,AMStatus
)                      
                      
Select          
(Select top 1 userTypeID from AgentLogin where UserID = BM.AgentID) as UserTypeId                     
,BM.Country,            
PM.[Type],            
isnull(PB.CancellationPenalty,0) as 'CancellationPenalty',        
isnull(PB.CancellationCharge,0) as 'CancellationCharge'                    
,BM.AgentID            
,BM.riyaPNR            
,PB.TicketNumber            
,AM.Ticketcode as 'AirLineCode'            
,BM.flightNo as 'AirLineNumber'                      
,'' as OldTicketNumber--,(Select TicketNumber from tblPassengerBookDetails where fkBookMaster = (Select top 1 pkId From tblBookMaster where riyapnr = BM.PreviousRiyaPNR)) as OldTicketNumber                      
,BM.OfficeID as 'OfficeID'                
,ISNULL(BM.IssueDate,BM.inserteddate) as 'PostingDate'          
,BM.inserteddate as 'BookingDate'          
,BM.depDate as 'TravelStartDate'          
,BM.arrivalDate as 'TravelEndDate'           
--,(case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end) as 'productType'    
,(case when AL.userTypeID IN(1,2,4) then    
Case when BM.BookingStatus in (1) then --confirmed    
 Case when BM.Country = 'IN' then  --in    
  case when BM.CounterCloseTime = 1 then -- domestic    
   case when BM.airCode = '6E' OR BM.airCode = 'G8' OR BM.airCode = 'SG' then    
      (select CategoryValue from tblERPMaster where Category = 'ProductCode' and Sector = 'LCCD'and CategoryCondition = BM.Country)    
     when BM.airCode = 'AI'then    
       (select CategoryValue from tblERPMaster where Category = 'ProductCode' and Sector = 'FSCD'and CategoryCondition = BM.Country)    
   else    
     Case when (select Count(*) from TblSTSAirLineMaster as t where t.AirlineCode = BM.airCode OR t.AirlineCode1 = BM.airCode) > 0 then    
      (select CategoryValue from tblERPMaster where Category = 'ProductCode' and Sector = 'LCCD'and CategoryCondition = BM.Country)    
     else    
      (select CategoryValue from tblERPMaster where Category = 'ProductCode' and Sector = 'FSCD'and CategoryCondition = BM.Country)    
     end    
     end    
  else -- international    
     case when BM.airCode = '6E' OR BM.airCode = 'G8' OR BM.airCode = 'SG' then    
      (select CategoryValue from tblERPMaster where Category = 'ProductCode' and Sector = 'LCCI'and CategoryCondition = BM.Country)    
          when BM.airCode = 'AI' then    
      (select CategoryValue from tblERPMaster where Category = 'ProductCode' and Sector = 'FSCI'and CategoryCondition = BM.Country)    
     else    
    Case when (select Count(*) from TblSTSAirLineMaster as t where t.AirlineCode = BM.airCode OR t.AirlineCode1 = BM.airCode) > 0 then    
     (select CategoryValue from tblERPMaster where Category = 'ProductCode' and Sector = 'LCCI'and CategoryCondition = BM.Country)    
    else    
     (select CategoryValue from tblERPMaster where Category = 'ProductCode' and Sector = 'FSCI'and CategoryCondition = BM.Country)    
    end    
   end    
  end    
  else -- other country    
   ISNULL((select CategoryValue from tblERPMaster where Category = 'ProductCode' and CategoryCondition = BM.Country),'')    
 end    
 else --cancellation    
  (case when BM.CounterCloseTime is null OR CounterCloseTime = '' then     
   'AIR-DOM'      
  else (case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end) end)      
 end    
else    
 case when AL.userTypeID IN(3) AND BM.AgentID != 'B2C' then      
  (case when BM.CounterCloseTime is null OR CounterCloseTime = '' then 'AIR-DOM'      
  else (case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end) end)    
 else    
 case when AL.userTypeID IN(5) AND BM.AgentID != 'B2C' then    
  Case when BM.BookingStatus in (1) then --confirmed    
   (case when BM.CounterCloseTime is null OR CounterCloseTime = '' then 'AIR-DOM'      
   else (case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end) end)    
  else --cancellation    
   (case when BM.CounterCloseTime is null OR CounterCloseTime = '' then 'AIR-DOM'      
   else (case when BM.CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end) end)    
  end    
 end    
   end    
end) as 'productType'    
    
--,(case when AL.userTypeID IN(2,3) AND BM.AgentID != 'B2C' then            
-- (Case When ED.CustomerCode='AgentCustID' AND BR.Icast !='AgentCustID' then BR.Icast            
--  When ED.CustomerCode !='AgentCustID' AND BR.Icast ='AgentCustID' then ED.CustomerCode            
--  When ED.CustomerCode !='AgentCustID' AND BR.Icast !='AgentCustID' then ED.CustomerCode End)            
--  when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID NOT IN (1) then 'ICUST35086'            
--  when  AL.userTypeID IN(4) OR BM.AgentID != 'B2C' then 'BOMCUST002120A'             
--  end ) As 'CustomerNumber'    
,(case when AL.userTypeID IN(2,4) AND BM.AgentID != 'B2C' then            
    
 case when (case when AL.userTypeID IN(2,3) AND BM.AgentID != 'B2C' then            
   (Case When ED.CustomerCode='AgentCustID' AND BR.Icast !='AgentCustID' then BR.Icast            
    When ED.CustomerCode !='AgentCustID' AND BR.Icast ='AgentCustID' then ED.CustomerCode            
    When ED.CustomerCode !='AgentCustID' AND BR.Icast !='AgentCustID' then ED.CustomerCode End)            
    when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID NOT IN (1) then 'ICUST35086'            
    when  AL.userTypeID IN(4) OR BM.AgentID != 'B2C' then 'BOMCUST002120A'             
    end) = ''    
   OR    
   (case when AL.userTypeID IN(2,3) AND BM.AgentID != 'B2C' then            
   (Case When ED.CustomerCode='AgentCustID' AND BR.Icast !='AgentCustID' then BR.Icast            
    When ED.CustomerCode !='AgentCustID' AND BR.Icast ='AgentCustID' then ED.CustomerCode            
    When ED.CustomerCode !='AgentCustID' AND BR.Icast !='AgentCustID' then ED.CustomerCode End)            
    when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID NOT IN (1) then 'ICUST35086'            
    when  AL.userTypeID IN(4) OR BM.AgentID != 'B2C' then 'BOMCUST002120A'             
    end) is null    
    
    then    
    
   (select CategoryValue from tblERPMaster where Category = 'ICAST'    
    and CategoryCondition = BM.Country)     
  else    
   (case when AL.userTypeID IN(2,3) AND BM.AgentID != 'B2C' then            
   (Case When ED.CustomerCode='AgentCustID' AND BR.Icast !='AgentCustID' then BR.Icast            
   When ED.CustomerCode !='AgentCustID' AND BR.Icast ='AgentCustID' then ED.CustomerCode            
   When ED.CustomerCode !='AgentCustID' AND BR.Icast !='AgentCustID' then ED.CustomerCode End)            
   when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID NOT IN (1) then 'ICUST35086'            
   when  AL.userTypeID IN(4) OR BM.AgentID != 'B2C' then 'BOMCUST002120A'             
   end)    
  end    
else    
 case when AL.userTypeID IN(1) then    
  'ICUST35086'    
 else    
  (case when AL.userTypeID IN(2,3) AND BM.AgentID != 'B2C' then            
   (Case When ED.CustomerCode='AgentCustID' AND BR.Icast !='AgentCustID' then BR.Icast            
    When ED.CustomerCode !='AgentCustID' AND BR.Icast ='AgentCustID' then ED.CustomerCode            
    When ED.CustomerCode !='AgentCustID' AND BR.Icast !='AgentCustID' then ED.CustomerCode End)            
    when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID NOT IN (1) then 'ICUST35086'            
    when  AL.userTypeID IN(4) OR BM.AgentID != 'B2C' then 'BOMCUST002120A'             
    end)    
 end    
end) as 'CustomerNumber'    
      
,(case when AL.userTypeID IN(2,3,4) AND BM.AgentID != 'B2C' then    
 case when BM.VendorName='' OR BM.VendorName is null then 'TESVEND0000000' Else BM.VendorName end    
else    
   isnull(BM.VendorName,'')    
end)as 'PayToVendor'     
             
,'' as 'BTASales'            
,BM.GDSPNR as 'GDSPNR'                 
,(Select top 1 airlinePNR From tblBookItenary where orderId = BM.orderId) as 'AirlinePNR'                      
,PB.paxType as 'PaxType'            
,PB.title as 'Salutation'                  
,ISNULL(PB.paxFName,'') +' '+ ISNULL(PB.paxLName,'') as 'PaxName'     
    
--,(Select top 1 UserName From mUser where ID = BM.MainAgentId) as 'Employeecode'    
,(case when AL.userTypeID IN(1,2,4) then            
    Case when BM.Country = 'IN' then    
      case when (Select top 1 UserName From mUser where ID = BM.MainAgentId) = ''      
          or (Select top 1 UserName From mUser where ID = BM.MainAgentId) is null    
      then '011145'    
   else       
    isnull((Select top 1 UserName From mUser where ID = BM.MainAgentId),'')    
   end    
    else    
        case when (Select top 1 UserName From mUser where ID = BM.MainAgentId) = ''      
    or (Select top 1 UserName From mUser where ID = BM.MainAgentId) is null    
     then '191093'    
     else       
    isnull((Select top 1 UserName From mUser where ID = BM.MainAgentId),'')    
     end      
    end    
  else    
   isnull((Select top 1 UserName From mUser where ID = BM.MainAgentId),'')    
end) as 'EmployeeCode'    
    
,ISNULL((Select top 1 Currency From tbl_commonmaster where CategoryValue = BM.officeid and Country = BM.Country),'') as 'SalesCurrencyCode'            
,ISNULL(BM.AgentROE,0) as 'SalesCurrencyFactor'           
,ISNULL(Cast(BM.AgentROE as varchar),'0') as 'SalesExchangeRate'     
,(case when PB.basicFare != null and PB.basicFare > 0 then REPLACE(PB.basicFare, '-', '') else ISNULL(PB.basicFare,0) end) as 'BaseAmount'    
,(case when PB.totalTax != null and PB.totalTax > 0 then REPLACE(PB.totalTax, '-', '') else ISNULL(PB.totalTax,0) end) as 'TaxAmount'    
,(case when PB.totalFare != null and PB.totalFare > 0 then REPLACE(PB.totalFare, '-', '') else ISNULL(PB.totalFare,0) end) as 'TotalAmount'           
,ISNULL(BM.PromoDiscountTotalAMT,0) as 'PromoDiscountAmount'                    
,ISNULL(PB.ServiceFee,0) as 'ServiceFee'            
,ISNULL(PB.managementfees,0) as 'ManagementFee'            
,'0' as  'SurchargeAmount'            
--,ISNULL(convert(decimal,BM.VendorCommissionPercent),'0') as 'VendCommAmount'
,ISNULL(TRY_CONVERT(decimal, BM.VendorCommissionPercent), '0') AS 'VendCommAmount'            
,'0' as 'DateChangePenalty'            
,ISNULL(PB.IATACommission,0) as 'CustIATACommAmount'            
,ISNULL(PB.PLBCommission,0) as 'CustPLBAmount'             
,BM.VendorCommissionPercent as 'VendIATACommAmount'          
,'0' as 'QTax'          
,'0' as 'MCO'          
,(case when AL.userTypeID IN(1,2,3,4) then     
  case when PM.payment_mode='' OR PM.payment_mode is null OR PM.payment_mode = 'Cash' then '0' Else '1' end     
else     
  case when AL.userTypeID IN(5) AND BM.AgentID != 'B2C' then    
   Case when BM.BookingStatus in (1) then --confirmed    
    case when PM.payment_mode='' OR PM.payment_mode is null OR PM.payment_mode = 'Cash' then '0' Else '1' end    
   else --cancelled    
    case when PM.payment_mode='' OR PM.payment_mode is null OR PM.payment_mode = 'Cash' then '0' Else '1' end    
   end    
  else    
   case when PM.payment_mode='' OR PM.payment_mode is null OR PM.payment_mode = 'Cash' then '0' Else '1' end     
 end     
end)as 'UATP_MCOSales'        
--,(case when AL.userTypeID IN(3,2,4) AND BM.AgentID != 'B2C' AND BM.Country NOT IN ('US','CA')             
--  then (ISNULL(PB.B2bMarkup,0) +ISNULL(PB.BFC,0)) --ERP ASK Logic            
--  when  AL.userTypeID IN(2) AND BM.AgentID != 'B2C' AND BM.Country IN ('US','CA')             
--  then (cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (PB.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END)* BM.ROE,0))as decimal(18,2)) +PB.BFC)                   
--      when cast(BM.AgentID as varchar(50))= 'B2C' OR AL.userTypeID NOT IN (1)            
--  then (ISNULL(PB.B2bMarkup,0) +ISNULL(PB.BFC,0))            
--  else ''-- --ERP ASK Logic            
-- end ) As 'MarkupOnBaseFare'            
,isnull((cast((isnull((CASE WHEN BM.B2bFareType=1 THEN  (BM.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2)) +BM.BFC),0) as 'MarkupOnBaseFare'            
,isnull((cast((isnull((CASE WHEN BM.B2bFareType=2 or BM.B2bFareType=3 THEN  (BM.B2BMarkup/isnull(BM.AgentROE,0)) ELSE 0 END),0))as decimal(18,2))),0) as 'MarkupOnTax'            
,isnull(PB.CancellationMarkup,0) as 'MarkupOnCancellation'    
    
 ,(case when BM.Country = 'US' OR BM.Country = 'CA' then     
  case when PM.payment_mode='passThrough' then 'CUSTOMER'     
  when PM.payment_mode='Credit' then 'CORPORATE'    
  when PM.payment_mode='Check' then 'CUSTOMER'    
  Else '' end    
else    
case when PM.payment_mode='passThrough' then 'CUSTOMER'     
  when PM.payment_mode='Credit' then 'CORPORATE'    
  when PM.payment_mode='Check' then 'CASH'    
  Else '' end    
end)as 'UATP'    
    
,(case when AL.userTypeID IN(2,4) AND BM.AgentID != 'B2C' then     
 case when  PM.CardType != 'null' then    
  case when UPPER(PM.CardType) = 'VI' then 'Visa'    
   when UPPER(PM.CardType) = 'DC' then 'Diner'    
   when UPPER(PM.CardType) = 'TP' then 'TP'    
   when UPPER(PM.CardType) = 'AX' then 'Amex'    
   when UPPER(PM.CardType) = 'DS' then 'Discover'    
  else isnull(PM.CardType,'') end    
 else '' end    
else    
 case when AL.userTypeID IN(3) AND BM.AgentID != 'B2C' then    
 Case when BM.BookingStatus in (1) then --confirmed    
  case when UPPER(PM.CardType) = 'VI' then 'Visa'    
   when UPPER(PM.CardType) = 'DC' then 'Diner'    
   when UPPER(PM.CardType) = 'TP' then 'TP'    
   when UPPER(PM.CardType) = 'AX' then 'Amex'    
   when UPPER(PM.CardType) = 'DS' then 'Discover'    
  else isnull(PM.CardType,'') end       
 else    
  case when PM.CardType != 'null' then    
  case when UPPER(PM.CardType) = 'VI' then 'Visa'    
   when UPPER(PM.CardType) = 'DC' then 'Diner'    
   when UPPER(PM.CardType) = 'TP' then 'TP'    
   when UPPER(PM.CardType) = 'AX' then 'Amex'    
   when UPPER(PM.CardType) = 'DS' then 'Discover'    
  else isnull(PM.CardType,'') end    else '' end    
  end    
 else    
  case when AL.userTypeID IN(1) then    
   ISNULL(PM.CardType,'')    
  else    
   ISNULL(PM.CardType,'')    
  end    
 end    
end) as 'CardType'    
    
    
,(case when PM.CardNumber is null then '' else PM.CardNumber end) as 'CardNumber'    
,(case when PB.OBTax != null and PB.OBTax > 0 then REPLACE(PB.OBTax, '-', '') else ISNULL(PB.OBTax,0) end) as 'OBTaxAmount'    
,(case when PB.OCTax != null and PB.OCTax > 0 then REPLACE(PB.OCTax, '-', '') else ISNULL(PB.OCTax,0) end) as 'OCTaxAmount'    
,(case when PB.YQ != null and PB.YQ != '' and PB.YQ > 0 then REPLACE(PB.YQ, '-', '') else ISNULL(PB.YQ,0) end) as 'YQTaxAmount'    
,(case when PB.YRTax != null and PB.YRTax > 0 then REPLACE(PB.YRTax, '-', '') else ISNULL(PB.YRTax,0) end) as 'YRTaxAmount'    
,(case when PB.JNTax != null and PB.JNTax > 0 then REPLACE(PB.JNTax, '-', '') else ISNULL(PB.JNTax,0) end) as 'K3TaxAmount'    
,(case when PB.ExtraTax != null and PB.ExtraTax > 0 then REPLACE(PB.ExtraTax, '-', '') else ISNULL(PB.ExtraTax,0) end) as 'XTTaxAmount'    
,(case when PB.INTax != null and PB.INTax > 0 then REPLACE(PB.INTax, '-', '') else ISNULL(PB.INTax,0) end) as 'INTaxAmount'    
,(case when PB.YMTax != null and PB.YMTax > 0 then REPLACE(PB.YMTax, '-', '') else ISNULL(PB.YMTax,0) end) as 'YMTaxAmount'    
,(case when PB.WOTax != null and PB.WOTax > 0 then REPLACE(PB.WOTax, '-', '') else ISNULL(PB.WOTax,0) end) as 'WOTaxAmount'           
,'0' as 'PHFTaxAmount'            
,'0' as 'TTFTaxAmount'            
,'0' as 'TRFTaxAmount'            
,'0' as 'CMFTaxAmount'            
,'0' as 'COMMTaxAmount'            
,'0' as 'COMMBFTaxAmount'            
,'0' as 'RCSTaxAmount'            
,'0' as 'RCFTaxAmount'            
,ISNULL(PB.RFTax,0) as 'RFTaxAmount'            
,ISNULL(ssr.SSR_Amount,0) as 'ExtraBaggageAmount'     
    
,(case when BM.Country = 'US' OR BM.Country = 'CA' then     
  case when PM.payment_mode='passThrough' then 'CUSTOMER'     
  when PM.payment_mode='Credit' then 'CORPORATE'    
  when PM.payment_mode='Check' then 'CUSTOMER'    
  Else '' end    
else    
case when PM.payment_mode='passThrough' then 'CUSTOMER'     
  when PM.payment_mode='Credit' then 'CORPORATE'    
  when PM.payment_mode='Check' then 'CASH'    
  Else '' end    
end)as 'PaymentMode'    
    
,BM.IssueBy as 'TicketingUserID'          
,'' as 'Narration'          
,(case when BM.promoCode = '' OR BM.promoCode is NULL then '' Else BM.promoCode end) as 'PromotionCode'    
,(case when AL.userTypeID IN(1) then '14360102' else (Select top 1 IATA From tblOwnerCurrency where officeid = BM.OfficeID) end) as 'IATACode'    
                                   
,Cast(BM.BookedBy as varchar(10)) as 'BookingUserID'          
,BM.orderId as 'OrderID'          
,'0' as 'ProductCode'          
,(case when BM.TourCode = '' OR BM.TourCode is null then '' Else BM.TourCode end) as 'DealCode'                    
--,(case when BM.VendorName='Amadeus' then '1A' when BM.VendorName='Galileo' then '1G'     
--when BM.VendorName='Sabre' then '1S'     
--Else (Select top 1 Currency From tblOwnerCurrency as TOC where TOC.officeid = BM.officeid) end) as 'Crscode'    
,(case when AL.userTypeID IN(2,4) AND BM.AgentID != 'B2C' then     
 case when (case when BM.VendorName='Amadeus' then '1A' when BM.VendorName='Galileo' then '1G' when BM.VendorName='Sabre' then '1S'     
 Else (Select top 1 Currency From tblOwnerCurrency as TOC where TOC.officeid = BM.officeid) end) = ''     
 OR    
 (case when BM.VendorName='Amadeus' then '1A' when BM.VendorName='Galileo' then '1G' when BM.VendorName='Sabre' then '1S'     
 Else (Select top 1 Currency From tblOwnerCurrency as TOC where TOC.officeid = BM.officeid) end) is null    
    
 then    
    
  (Case When (select CategoryValue from tblERPMaster where Category = 'CRS'and CategoryCondition = BM.airCode) = '' OR  (select CategoryValue from tblERPMaster where Category = 'CRS'and CategoryCondition = BM.airCode) is null then     
   '1A'     
   else     
   isnull((select CategoryValue from tblERPMaster where Category = 'CRS'and CategoryCondition = BM.airCode),'')    
  end)    
 else    
  (case when BM.VendorName='Amadeus' then '1A' when BM.VendorName='Galileo' then '1G'     
  when BM.VendorName='Sabre' then '1S'     
  Else (Select top 1 Currency From tblOwnerCurrency as TOC where TOC.officeid = BM.officeid) end)    
    end    
else    
 case when AL.userTypeID IN(1) then    
  (Case When (select CategoryValue from tblERPMaster where Category = 'CRS'and CategoryCondition = BM.airCode) = '' OR  (select CategoryValue from tblERPMaster where Category = 'CRS'and CategoryCondition = BM.airCode) is null then     
   '1A'     
   else     
   isnull((select CategoryValue from tblERPMaster where Category = 'CRS'and CategoryCondition = BM.airCode),'')    
  end)    
 else    
  (case when BM.VendorName='Amadeus' then '1A' when BM.VendorName='Galileo' then '1G'     
  when BM.VendorName='Sabre' then '1S'     
  Else (Select top 1 Currency From tblOwnerCurrency as TOC where TOC.officeid = BM.officeid) end)    
end    
end) as 'CrsCode'     
    
,BM.inserteddate_old  as 'CreatedDate'            
,BM.pkId as 'BMPkId'              
,(case when ED.VendorCode = '' or ED.VendorCode is null then '' Else ED.VendorCode end) as 'EDVendorcode'              
,ISNULL(BM.CounterCloseTime,0) as 'CounterCloseTime'               
,BM.deptTime as 'TravelStartTime'              
,BM.arrivalTime as 'TravelEndTime'              
,BM.frmSector as 'FromCity'              
,BM.toSector as 'ToCity '             
,BM.flightNo as 'FlightNo'      
    
,ISNULL(BM.travClass,'') as 'BMtravClass'             
,(case when BM.fromTerminal is null OR BM.fromTerminal = 'Yet to be decided' then '' Else BM.fromTerminal end) as 'BMfromTerminal'    
,(case when BM.toTerminal is null OR BM.toTerminal = 'Yet to be decided' then '' Else BM.toTerminal end) as 'BMtoTerminal'    
,(case when BM.equipment = '' OR BM.equipment is null then '' Else BM.equipment end) as 'BMEquipment'    
,(Select top 1 Currency From tblOwnerCurrency as TOC where TOC.officeid = BM.officeid) as 'PurchCurr'                    
,ISNULL(BM.ROE,0) as 'PurchCurrROE'           
,PB.pid as 'PBPId'             
,isnull((Select top 1 _CATEGORY From Airlinename as an where an._CODE = BM.airCode),'') as 'AirLineType'                
,ISNULL(BM.TotalDiscount,0) as 'BMTotalDiscount'                
,ISNULL((Select top 1 EmpCode From PNRRetriveDetails where orderId = BM.orderId),'') as 'PREmpCode'                
,isnull((Select top 1 farebasis From tblBookItenary where orderId = BM.orderId),'') as 'BIfarebasis'              
,BM.BookingStatus as 'BookingStatus'              
,BM.IsBooked as 'IsBooked'              
,(case when BM.RegistrationNumber = '' OR BM.RegistrationNumber is null then '' Else BM.RegistrationNumber end) as 'BMRegistrationNumber'    
,(case when BM.Vendor_No = '' OR BM.Vendor_No is null then '' Else BM.Vendor_No end) as 'BMVendor_No'            
,ISNULL(PB.B2BMarkup,0) as 'PBB2bMarkup'                
,ISNULL(PB.BFC,0) as 'PBBFC'    
,ISNULL(PB.baggage,'') as 'PBBaggage'    
,ISNULL(PM.mer_amount,'') as 'PM_Mer_Amount'    
,ISNULL(PM.billing_address,'') as 'PM_Billing_Address'    
,ISNULL(PM.billing_name,'') as 'PM_Billing_Name'    
,ISNULL(PM.tracking_id,'') as 'PM_Tracking_id'    
,ISNULL((Select top 1 cabin From tblBookItenary where orderId = BM.orderId),'') as 'BICabin'                 
,ISNULL(mAtt.VesselName,'') as 'ATT_VesselName'        
,(case when mAtt.TR_POName = null OR mAtt.TR_POName = 'NULL' OR mAtt.TR_POName = '' OR mAtt.TR_POName = '-1' OR mAtt.TR_POName = 'NA'
then '' else mAtt.TR_POName end) as 'ATT_TR_POName'               
,ISNULL(mAtt.BookedBy,'') as 'ATT_Bookedby'
,(case when mAtt.AType = null OR mAtt.AType = 'NULL' OR mAtt.AType = '' OR mAtt.AType = '-1'
then '' else mAtt.AType end) as 'ATT_AType'
,ISNULL(mAtt.RankNo,'') as 'ATT_RankNo'                
,ISNULL(BM.AgentMarkup,0) as 'BMAgentMarkup'                
,ISNULL(PB.RFTax,0) as 'PBRFTax'               
,BM.airCode as 'airCode'              
,(case when AL.userTypeID IN(2,3,4) AND BM.AgentID != 'B2C' then    
 case when BM.VendorName='' OR BM.VendorName is null then 'TESVEND0000000' Else BM.VendorName end    
else    
   isnull(BM.VendorName,'')    
end)as 'BMVendorName'     
    
,ISNULL(BM.B2bFareType,0) as 'B2bFareType'                
,ISNULL(BM.B2bFareType,0) as 'BMB2bFareType'                
,ISNULL(PB.Markup,2) as 'PBMarkup'                
,BM.MainAgentId as 'MainAgentId'              
,isnull(isnull(PB.BaggageFare,0) + isnull(ssr.SSR_Amount,0),0) as 'PBBaggageFare'              
,ISNULL(PB.MCOAmount,0) as 'MCOAmount'              
,ISNULL(PB.MCOTicketNo,'') as 'MCOTicketNo'              
,cast((Isnull(PB.MCOAmount,0)-Isnull(PB.MCOAmount,0)*3.5/100)as decimal(18,2)) as 'McoCommissionAmount'           
          
--,(case when AL.userTypeID IN(3,2) AND BM.AgentID != 'B2C' then ''                
-- when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID NOT IN (1) then ''            
-- when  AL.userTypeID IN(4) AND BM.AgentID != 'B2C'            
-- then 'BOM' else '' end ) As 'LocationCode'    
,(case when AL.userTypeID IN(2,4,3) AND BM.AgentID != 'B2C' then    
 case when (case when AL.userTypeID IN(3,2) AND BM.AgentID != 'B2C' then ''                
  when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID NOT IN (1) then ''            
  when  AL.userTypeID IN(4) AND BM.AgentID != 'B2C'            
  then 'BOM' else '' end) = ''    
    
    then    
    
  isnull((select CategoryValue from tblERPMaster where Category = 'LocationCode1'    
   and CategoryCondition = BM.Country),'') 

   else
	   (case when AL.userTypeID IN(3,2) AND BM.AgentID != 'B2C' then ''                
	  when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID NOT IN (1) then ''            
	  when  AL.userTypeID IN(4) AND BM.AgentID != 'B2C'            
	  then 'BOM' else '' end)
 end    
else    
 case when AL.userTypeID IN(1) then     
  'BOMRC'    
 else    
  (case when AL.userTypeID IN(3,2) AND BM.AgentID != 'B2C' then ''                
   when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID NOT IN (1) then ''            
   when  AL.userTypeID IN(4) AND BM.AgentID != 'B2C'            
   then 'BOM' else '' end)    
 end    
end) as 'LocationCode'        
          
--,(case when AL.userTypeID IN(3,2) AND BM.AgentID != 'B2C' then ''                
-- when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID NOT IN (1)then ''            
-- when  AL.userTypeID IN(4) AND BM.AgentID != 'B2C'             
-- then 'BR2002000' else '' end ) As 'BranchCode'    
,(case when AL.userTypeID IN(1,2,3,4) then     
 case when (case when AL.userTypeID IN(3,2) AND BM.AgentID != 'B2C' then ''                
  when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID NOT IN (1)then ''            
  when  AL.userTypeID IN(4) AND BM.AgentID != 'B2C'             
  then 'BR2002000' else '' end ) = ''    
    
    then    
	  isnull((select CategoryValue from tblERPMaster where Category = 'BranchCode1'    
	   and CategoryCondition = BM.Country),'') 
	else
		(case when AL.userTypeID IN(3,2) AND BM.AgentID != 'B2C' then ''                
	  when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID NOT IN (1)then ''            
	  when  AL.userTypeID IN(4) AND BM.AgentID != 'B2C'             
	  then 'BR2002000' else '' end )
 end
end) as 'BranchCode'        
          
--,(case when AL.userTypeID IN(3,2) AND BM.AgentID != 'B2C' then ''                
-- when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID NOT IN (1) then ''             
-- when  AL.userTypeID IN(4) AND BM.AgentID != 'B2C' then ''             
-- else '' end ) As 'DivisionCode'    
,(Case when BM.Country = 'IN' then  --in   
     
  case when AL.userTypeID IN(3,2) AND BM.AgentID != 'B2C' then 'CC1001000'                
  when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID IN (1) then 'CC1001000'             
  when  AL.userTypeID IN(4) AND BM.AgentID != 'B2C' then 'CC1001000'             
  else 'CC1001000' end    
 else --other country    
  case when AL.userTypeID IN(3,2) AND BM.AgentID != 'B2C' then ''                
  when cast(BM.AgentID as varchar(50))= 'B2C' AND AL.userTypeID IN (1) then ''             
  when  AL.userTypeID IN(4) AND BM.AgentID != 'B2C' then ''             
  else '' end    
 end) As 'Divisioncode'

 --newly added
,ISNULL(mAtt.OBTCno,'') as 'ATTOBTCno'
,(case when mAtt.Traveltype = null OR mAtt.Traveltype = 'NULL' OR mAtt.Traveltype = '' OR mAtt.Traveltype = '-1'
then '' else mAtt.Traveltype end) as 'Traveltype'
,ISNULL(BM.FareType,'') as 'FareType'
,ISNULL((select ssrMeal.SSR_Amount from tblSSRDetails as ssrMeal where ssrMeal.fkPassengerid = PB.pid and ssrMeal.pkid = ssr.pkid
and ssrMeal.SSR_Type = ssr.SSR_Type and ssrMeal.SSR_Type = 'Meals'),0) as 'Meal_Charges'
,AM.[Status] as 'AMStatus'
              
from tblBookMaster as BM                 
left join tblPassengerBookDetails as PB on BM.pkId = PB.fkBookMaster                 
left join Paymentmaster as PM on PM.order_id = BM.orderId                    
left join B2BRegistration BR on BR.FKUserID=BM.AgentID      
left join AgentLogin as AL on AL.UserID = BM.AgentID       
left join B2BRegistration r1 on r1.FKUserID=AL.ParentAgentID      
left join AirlineMaster as AM on AM.Airlinecode = BM.airCode and AM.[Status] = 'A'            
left join tblERPDetails ED on (BM.OfficeID = ED.OwnerID and ED.AgentCountry = BM.Country AND ED.ERPCountry = BM.Country)          
left join tblSSRDetails as ssr on ssr.fkPassengerid = PB.pid and ssr.SSR_Amount > 0 and ssr.SSR_Type = 'Baggage' 
left join tblSSRDetails as ssr1 on ssr.fkPassengerid = PB.pid and ssr.SSR_Amount > 0 and ssr.SSR_Type = 'Meals' 
left join mAttrributesDetails as mAtt on mAtt.OrderID = BM.orderId          
WHERE                     
BM.RiyaPNR = @RiyaPNR          
AND BM.totalFare > 0 AND BM.IsBooked = 1 --AND BM.VendorName <> 'STS'          
AND BM.pkId = PB.fkBookMaster          
               
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Insert_Tickets_ERP_Data] TO [rt_read]
    AS [dbo];

