--[dbo].[Proc_GetHCLReport] 33435,1272,'2024-08-11','2024-08-12'        
CREATE Procedure Proc_GetHCLReport        
@AgentId int = 0 ,                                                        
@MainAgentId int = 0,                                                    
@FromDate varchar(100)='',                                                    
@ToDate varchar(100)=''           
As        
Begin        
  IF @ToDate IN ('',NULL)                               
  SET @ToDate = DATEADD(DAY,1,@FromDate)                                                                                                            
  ELSE                                               
  SET @ToDate = DATEADD(DAY,1,@ToDate);        
        
 ---- Voucher Condition--                        
 WITH SourceData AS (            
    SELECT     
 isnull(MU.FullName,'') as RBTConsultant,  
  HH.CreateDate AS BookingDate,       
  HM.Status as BookingStatus,      
  '' as GEO,      
  DATENAME (mm, CONCAT('1900', FORMAT(CAST(MONTH(HH.CreateDate) AS INT), '00'), '01')) AS  MISMonth,      
  '' as TMCName,      
  --'' as HCLEntityCode,      
  Case When HB.SCurrency='INR' then 'DOM' else 'INT' end as TravelScope,      
  HB.HotelBookStateName as HotelBookedRegion,      
  HB.HotelBookCountryName as HotelBookedCountry,      
  HB.HotelBookCountryCode as CountryCode,      
  HB.cityName as HotelBookedCity,      
  HB.CheckInDate as Checkindate,      
  HB.CheckOutDate as Checkoutdate,      
  HB.SelectedNights as RoomNight,      
  HB.HotelName as HotelName,      
  HB.ChainName as HotelBrandName,      
  HB.HotelAddress1 as HotelAddress,      
  HB.HotelPostalCode as ZIPCODE,      
  '' as L1Option,      
  HB.HotelTotalGross as RoomRate,      
  --HB.Meal as Breakfast,      
  --HB.HotelIncludes as Internet,      
  HB.HotelConfNumber as HotelConfirmationNumber,  
  HB.SupplierReferenceNo as GDSPNR,  
  --isnull(HB.BookingRateType,'') as RateType,      
  HB.CurrencyCode as BookedCurrency,   -- not possible   
  cast(HB.SBaseRate as float) / cast(HB.SelectedNights as float) as BookedRatepernightExclofTaxes,      
  cast(HB.STotalRate as float) / cast(HB.SelectedNights as float) as BookedRatepernightInclofTaxes,      
  HB.HotelTotalGross as FullTransactionAmountinHotellocalcurrencyInclusiveofTaxes,      
  HB.ROEValue AS ROE,      
  HB.STotalRate as FullTransactionAmountinUSD,      
  '' as LodgingLimitBookedCurrency,      
  'TrvlNxt' as BookingOnlineOffline,      
  '' as Deviation,      
  Case         
  WHEN HB.B2BPaymentMode=5 then 'PayAtHotel'        
  WHEN HB.B2BPaymentMode=1 then 'Hold'        
  WHEN HB.B2BPaymentMode=2 then 'CreditLimit'        
  WHEN HB.B2BPaymentMode=3 then 'MakePayment'        
  WHEN HB.B2BPaymentMode=4 then 'SelfBalance'        
  else '' END as Modeofpayment,      
  HB.BookingReference as BookingId,      
        HA.Attributes,             
        HA.AttributesValue            
    FROM             
 Hotel_BookMaster HB WITH (NOLOCK)                         
 join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and  HH.FkStatusId=4                       
 join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                                                                                                   
 left join B2BHotel_Commission BC on BC.Fk_BookId = hb.pkId         
 left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1        
 left join tblSelfBalance tbs on tbs.BookingRef = HB.orderId and tbs.UserID = HB.MainAgentID                                                   
 left join tblAgentBalance tbla on tbla.BookingRef = HB.orderId  and  tbla.AgentNo = HB.RiyaAgentID                          
 left join B2BMakepaymentCommission B2BMC on B2BMC.FkBookId=HB.pkId                        
 left join B2BRegistration B2B on B2B.FKUserID=HB.RiyaAgentID                        
 left join agentLogin AL on AL.UserID=B2B.FKUserID    
 left join mUser MU on MU.ID=HB.MainAgentID    
 left join mAgentGroup MAG on MAG.Id=AL.GroupId                        
 left join Hotel_BookingGSTDetails gst on gst.PKID=HB.pkId or gst.OrderId=HB.orderId                        
 left join Hotel_AttributesData HA on HA.FKBookId=HB.pkId                  
where (HB.RiyaAgentID = @AgentId or (HB.MainAgentID = @MainAgentId and HB.MainAgentID > 0))                                                        
  and HB.BookingPortal in('TNH','TNHAPI')                                 
  and HB.RiyaAgentID is not null                                             
  and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')             
            
            
  UNION            
  --- Cancelled Booking            
   SELECT       
   isnull(MU.FullName,'') as RBTConsultant,  
       HH.CreateDate AS BookingDate,         
  HM.Status as BookingStatus,      
  '' as GEO,      
   DATENAME (mm, CONCAT('1900', FORMAT(CAST(MONTH(HH.CreateDate) AS INT), '00'), '01')) AS  MISMonth,     
  '' as TMCName,      
  --'' as HCLEntityCode,      
  Case When HB.SCurrency='INR' then 'DOM' else 'INT' end as TravelScope,      
  HB.HotelBookStateName as HotelBookedRegion,      
  HB.HotelBookCountryName as HotelBookedCountry,      
  HB.HotelBookCountryCode as CountryCode,      
  HB.cityName as HotelBookedCity,      
  HB.CheckInDate as Checkindate,      
  HB.CheckOutDate as Checkoutdate,      
  HB.SelectedNights as RoomNight,      
  HB.HotelName as HotelName,      
  HB.ChainName as HotelBrandName,      
  HB.HotelAddress1 as HotelAddress,      
  HB.HotelPostalCode as ZIPCODE,      
  '' as L1Option,      
  HB.HotelTotalGross as RoomRate,      
  --HB.Meal as Breakfast,      
  --HB.HotelIncludes as Internet,      
  HB.HotelConfNumber as HotelConfirmationNumber,  
   HB.SupplierReferenceNo as GDSPNR,  
  --isnull(HB.BookingRateType,'') as RateType,      
  HB.CurrencyCode as BookedCurrency,      
  cast(HB.SBaseRate as float) / cast(HB.SelectedNights as float) as BookedRatepernightExclofTaxes,      
  cast(HB.STotalRate as float) / cast(HB.SelectedNights as float) as BookedRatepernightInclofTaxes,      
  HB.HotelTotalGross as FullTransactionAmountinHotellocalcurrencyInclusiveofTaxes,      
  HB.ROEValue AS ROE,      
  HB.STotalRate as FullTransactionAmountinUSD,      
  '' as LodgingLimitBookedCurrency,      
  'TrvlNxt' as BookingOnlineOffline,      
  '' as Deviation,      
  Case         
  WHEN HB.B2BPaymentMode=5 then 'PayAtHotel'        
  WHEN HB.B2BPaymentMode=1 then 'Hold'        
  WHEN HB.B2BPaymentMode=2 then 'CreditLimit'        
  WHEN HB.B2BPaymentMode=3 then 'MakePayment'        
  WHEN HB.B2BPaymentMode=4 then 'SelfBalance'        
  else '' END as Modeofpayment,      
  HB.BookingReference as BookingId,      
        HA.Attributes,             
        HA.AttributesValue            
    FROM             
 Hotel_BookMaster HB WITH (NOLOCK)                         
 join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and  HH.FkStatusId=7                        
 join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                                                                                                   
 left join B2BHotel_Commission BC on BC.Fk_BookId = hb.pkId          
 left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1        
 left join tblSelfBalance tbs on tbs.BookingRef = HB.orderId and tbs.UserID = HB.MainAgentID                                                   
 left join tblAgentBalance tbla on tbla.BookingRef = HB.orderId  and  tbla.AgentNo = HB.RiyaAgentID                         
 left join B2BMakepaymentCommission B2BMC on B2BMC.FkBookId=HB.pkId                        
  left join B2BRegistration B2B on B2B.FKUserID=HB.RiyaAgentID                        
 left join agentLogin AL on AL.UserID=B2B.FKUserID     
  left join mUser MU on MU.ID=HB.MainAgentID    
 left join mAgentGroup MAG on MAG.Id=AL.GroupId                        
 left join Hotel_BookingGSTDetails gst on gst.PKID=HB.pkId or gst.OrderId=HB.orderId                        
 left join Hotel_AttributesData HA on HA.FKBookId=HB.pkId                        
where (HB.RiyaAgentID = @AgentId or (HB.MainAgentID = @MainAgentId and HB.MainAgentID > 0))                               
  and HB.BookingPortal in('TNH','TNHAPI')                                 
  and HB.RiyaAgentID is not null                                                                                                                         
  and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')               
    --order by HH.CreateDate desc               
)            
SELECT            
            
  --[RBT Consultant] as [RBT Consultant],    
  RBTConsultant,  
 BookingDate,      
 BookingStatus,      
 GEO,      
 MISMonth,      
 TMCName,      
 [TAS Number] as [TAS Number],      
 [HCL Entity Code] as [HCL Entity Code],      
 TravelScope,      
 [Employee ID] as [Employee ID],      
 [Employee Name] as [Employee Name],      
 [Travel Plan] as [Travel Plan],      
 [Employee Band] as [Employee Band],      
 HotelBookedRegion,      
 HotelBookedCountry,      
 CountryCode,      
 HotelBookedCity,      
 Checkindate,      
 Checkoutdate,      
 RoomNight,      
 HotelName,      
 HotelBrandName,      
 HotelAddress,      
 ZIPCODE,      
 L1Option,      
 RoomRate,      
 [Breakfast Entity] as [Breakfast Entity],      
 [Internet Entity] as [Internet Entity],      
 HotelConfirmationNumber,   
 GDSPNR,  
 --RateType,      
 [RateType Attributes] as [RateType Attributes],  
 BookedCurrency,      
 BookedRatepernightExclofTaxes,      
 BookedRatepernightInclofTaxes,      
 FullTransactionAmountinHotellocalcurrencyInclusiveofTaxes,      
 ROE,      
 FullTransactionAmountinUSD,      
 LodgingLimitBookedCurrency,      
 BookingOnlineOffline,      
 Deviation,      
 Modeofpayment,      
 BookingId      
FROM             
    SourceData            
PIVOT (            
    MAX(AttributesValue)            
    FOR Attributes IN (  
 --[RBT Consultant],  
 [TAS Number],[HCL Entity Code],[Employee ID],[Employee Name],[Travel Plan],[Employee Band],  
 [Breakfast Entity],  
 [Internet Entity],  
 [RateType Attributes])    ) AS PivotTable;            
                                     
            
END