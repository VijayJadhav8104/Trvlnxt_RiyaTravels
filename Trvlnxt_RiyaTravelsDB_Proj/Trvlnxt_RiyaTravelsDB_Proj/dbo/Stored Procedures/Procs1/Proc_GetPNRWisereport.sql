--Proc_GetPNRWisereport 46999,0,'2025-06-05','2025-06-06'                              
CREATE procedure Proc_GetPNRWisereport                             
@AgentId int = 0 ,                                      
@MainAgentId int = 0,                                  
@FromDate varchar(100)='',                                  
@ToDate varchar(100)=''                                  
As                            
Begin                            
                          
if @ToDate in ('',NULL)                                                                                          
  set @ToDate = DATEADD(DAY,1,@FromDate)                                                                                          
 else                             
  set @ToDate = DATEADD(DAY,1,@ToDate)                              
-------------- Voucher condition                         
Select                                 
 HH.CreateDate as BookingDate,                                        
 HM.Status as BookingStatus,                                        
 case When HB.BookingCountry='IN' then 'Domestic' else 'International' End as TravelType,                                
 HB.BookingReference as BookingId,                                
 HB.SupplierName as SupplierID,                                        
 (HB.LeaderFirstName +''+HB.LeaderLastName) as PaxName,                                        
 HB.TotalRoomAmount as  BaseAmount,                          
 0 as Penalty,                        
 HB.HotelTaxes as TaxesAmt,     
 --(isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) as Commission,   
 Case when (HB.SupplierUsername='rt-agoda-sell' or HB.SupplierUsername='rt-agoda-domestic')then 0 else (isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) end as Commission,                                          
 HB.HotelTDS as TDS,
 isnull(HB.ServiceCharges,0) as ServiceFee,
 isnull(HB.GstAmountOnServiceChagres,0) as GSTOnServiceFee,
 HB.DisplayDiscountRate as Total,                                        
 isnull(tbla.CloseBalance,0) as RemainingBalance,                                        
 --isnull(tbs.CloseBalance,0) as ClosingSelfBalance,                                   
 isnull(tbla.TransactionType,'') as CreditLimitTransactionType,                                        
 isnull(tbs.TransactionType,'') as SelfBalanceTransactionType,                                 
 HB.CurrencyCode as Currency,                                        
 case when HU.FullName +'-'+HU.UserName is null then bb.AgencyName+'-'+bb.CustomerCOde end as AgentID,                                        
 HB.HotelName as HotelName,                                        
 HB.cityName as  HotelCity,                                        
 HB.HotelAddress1 as HotelAddress,                                        
 HB.CheckInDate as CheckInDate,                                        
 HB.CheckOutDate as CheckOutDate,                                        
 HB.TotalRooms as  NoofRooms,                                        
 HB.SelectedNights as RoomNights,                                        
 HB.TotalAdults as Adults,                                        
 HB.TotalChildren as Children,                                        
 isnull(HPM.Pancard,'') as  PANNumber,                                        
 isnull(HPM.PassportNum,'') as  PassportNo,                                        
 isnull(HPM.Expirydate,'') as  PassportExpiryDate,                                        
 isnull(HBG.GstNumber,'') as   GSTNUMBER,                                        
 isnull(HBG.State,'') as  GSTSTATE,              
 isnull(HB.agentCancellationCharges,0) as agentCancellationCharges,                
 isnull(HB.ModeOfCancellation,'') As ModeOfCancellation,      
 '' as Remark      
 from Hotel_BookMaster HB WITH (NOLOCK)                                                                                                       
    join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId  and HH.FkStatusId=4                    
    join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                                                                                        
    join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                                        
    left join AgentLogin BR1 on HB.RiyaAgentID = BR1.UserId                              
    left join muser HU on HU.ID=HB.MainAgentID                                  
 left join B2BRegistration bb on bb.FKUserID=HB.RiyaAgentID                                  
    left join Hotel_ROE_Booking_History RoEB on RoEB.FkBookId=HB.pkId                                        
    left join B2BHotel_Commission BC on BC.Fk_BookId=hb.pkId                                        
    --left join mUserCountryMapping MUS on MUS.UserId=hb.MainAgentID                                        
    left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1                                        
    left join Hotel_BookingGSTDetails HBG on HBG.PKID=HB.pkId                                  
 left join tblSelfBalance tbs on tbs.BookingRef=HB.orderId and  tbs.UserID=HB.MainAgentID                                   
left join tblAgentBalance tbla on tbla.BookingRef=HB.orderId and  tbla.AgentNo=HB.RiyaAgentID                                   
 where (HB.RiyaAgentID=@AgentId or (HB.MainAgentID=@MainAgentId and HB.MainAgentID >0))                                        
    and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                          
 and HB.RiyaAgentID is not null                                                                                                                                           
    --and HH.IsActive=1                                   
 and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')                        
 and (tbs.TransactionType='Debit' or tbla.TransactionType='Debit')                        
                         
 UNION         
 -------------- Voucher condition Pay At Hotel        
 Select                                 
 HH.CreateDate as BookingDate,                                        
 HM.Status as BookingStatus,                                        
 case When HB.BookingCountry='IN' then 'Domestic' else 'International' End as TravelType,                                
 HB.BookingReference as BookingId,                                
 HB.SupplierName as SupplierID,                                        
 (HB.LeaderFirstName +''+HB.LeaderLastName) as PaxName,                                        
 HB.TotalRoomAmount as  BaseAmount,                          
 0 as Penalty,                        
 HB.HotelTaxes as TaxesAmt,                                        
 --(isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) as Commission,     
  Case when (HB.SupplierUsername='rt-agoda-sell' or HB.SupplierUsername='rt-agoda-domestic')then 0 else (isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) end as Commission,     
 HB.HotelTDS as TDS,
 isnull(HB.ServiceCharges,0) as ServiceFee,
 isnull(HB.GstAmountOnServiceChagres,0) as GSTOnServiceFee,
 HB.DisplayDiscountRate as Total,                                        
 isnull(tbla.CloseBalance,0) as RemainingBalance,                                        
 --isnull(tbs.CloseBalance,0) as ClosingSelfBalance,                                   
 isnull(tbla.TransactionType,'') as CreditLimitTransactionType,                                        
 isnull(tbs.TransactionType,'') as SelfBalanceTransactionType,                                 
 HB.CurrencyCode as Currency,                                        
 case when HU.FullName +'-'+HU.UserName is null then bb.AgencyName+'-'+bb.CustomerCOde end as AgentID,                                        
 HB.HotelName as HotelName,                                        
 HB.cityName as  HotelCity,                                        
 HB.HotelAddress1 as HotelAddress,                                        
 HB.CheckInDate as CheckInDate,                                        
 HB.CheckOutDate as CheckOutDate,                                        
 HB.TotalRooms as  NoofRooms,                                        
 HB.SelectedNights as RoomNights,                                        
 HB.TotalAdults as Adults,                                        
 HB.TotalChildren as Children,                                        
 isnull(HPM.Pancard,'') as  PANNumber,            
 isnull(HPM.PassportNum,'') as  PassportNo,                                        
 isnull(HPM.Expirydate,'') as  PassportExpiryDate,                                        
 isnull(HBG.GstNumber,'') as   GSTNUMBER,                                        
 isnull(HBG.State,'') as  GSTSTATE,              
 isnull(HB.agentCancellationCharges,0) as agentCancellationCharges,                
 isnull(HB.ModeOfCancellation,'') As ModeOfCancellation,      
 '' as Remark      
 from Hotel_BookMaster HB  WITH (NOLOCK)                                                                                                     
    join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId  and HH.FkStatusId=4                                                                             
    join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                                                                                        
    join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                                                       
    left join AgentLogin BR1 on HB.RiyaAgentID = BR1.UserId                                                      
    left join muser HU on HU.ID=HB.MainAgentID                                  
 left join B2BRegistration bb on bb.FKUserID=HB.RiyaAgentID                                  
    left join Hotel_ROE_Booking_History RoEB on RoEB.FkBookId=HB.pkId                                        
    left join B2BHotel_Commission BC on BC.Fk_BookId=hb.pkId                                        
    --left join mUserCountryMapping MUS on MUS.UserId=hb.MainAgentID                                        
    left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1                                        
    left join Hotel_BookingGSTDetails HBG on HBG.PKID=HB.pkId                                  
 left join tblSelfBalance tbs on tbs.BookingRef=HB.orderId and  tbs.UserID=HB.MainAgentID                                   
left join tblAgentBalance tbla on tbla.BookingRef=HB.orderId and  tbla.AgentNo=HB.RiyaAgentID                                   
 where (HB.RiyaAgentID=@AgentId or (HB.MainAgentID=@MainAgentId and HB.MainAgentID >0))                                        
    and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                          
 and HB.RiyaAgentID is not null                                                                                                                                           
    --and HH.IsActive=1                                   
 and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')           
 and HB.B2BPaymentMode=5        
 --and (tbs.TransactionType='Debit' or tbla.TransactionType='Debit')                        
                         
 UNION           
 ------------ Cancelled condition                        
 Select                          
 HH.CreateDate as BookingDate,                                        
 'Cancelled' as BookingStatus,                                        
 case When HB.BookingCountry='IN' then 'Domestic' else 'International' End as TravelType,                                
 HB.BookingReference as BookingId,                                
 HB.SupplierName as SupplierID,                                        
 (HB.LeaderFirstName +''+HB.LeaderLastName) as PaxName,                                        
 ('- '+HB.TotalRoomAmount) as  BaseAmount,                          
 0 as Penalty,                
 HB.HotelTaxes as TaxesAmt,                                        
 --(isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) as Commission,    
  Case when (HB.SupplierUsername='rt-agoda-sell' or HB.SupplierUsername='rt-agoda-domestic')then 0 else (isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) end as Commission,     
 HB.HotelTDS as TDS,
 isnull(HB.ServiceCharges,0) as ServiceFee,
 isnull(HB.GstAmountOnServiceChagres,0) as GSTOnServiceFee,
 HB.DisplayDiscountRate as Total,                                        
 isnull(tbla.CloseBalance,0) as RemainingBalance,                                      
 --isnull(tbs.CloseBalance,0) as ClosingSelfBalance,                                   
 isnull(tbla.TransactionType,'') as CreditLimitTransactionType,                                        
 isnull(tbs.TransactionType,'') as SelfBalanceTransactionType,                                 
 HB.CurrencyCode as Currency,                                        
 case when HU.FullName +'-'+HU.UserName is null then bb.AgencyName+'-'+bb.CustomerCOde end as AgentID,                                        
 HB.HotelName as HotelName,                                        
 HB.cityName as  HotelCity,                                        
 HB.HotelAddress1 as HotelAddress,                                        
 HB.CheckInDate as CheckInDate,                                        
 HB.CheckOutDate as CheckOutDate,                                        
 HB.TotalRooms as  NoofRooms,                                        
 HB.SelectedNights as RoomNights,                                        
 HB.TotalAdults as Adults,                                        
 HB.TotalChildren as Children,                                        
 isnull(HPM.Pancard,'') as  PANNumber,                                        
 isnull(HPM.PassportNum,'') as  PassportNo,                                        
 isnull(HPM.Expirydate,'') as  PassportExpiryDate,                                        
 isnull(HBG.GstNumber,'') as   GSTNUMBER,                                        
 isnull(HBG.State,'') as  GSTSTATE,              
 isnull(HB.agentCancellationCharges,0) as agentCancellationCharges,                
 isnull(HB.ModeOfCancellation,'API') As ModeOfCancellation,      
 '' as Remark      
 from Hotel_BookMaster HB   WITH (NOLOCK)                                                                                                      
    join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId and HH.FkStatusId=7                                                             
    join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                       
    join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                                                       
    left join AgentLogin BR1 on HB.RiyaAgentID = BR1.UserId                                                      
    left join muser HU on HU.ID=HB.MainAgentID                                  
 left join B2BRegistration bb on bb.FKUserID=HB.RiyaAgentID                                  
    left join Hotel_ROE_Booking_History RoEB on RoEB.FkBookId=HB.pkId                                        
    left join B2BHotel_Commission BC on BC.Fk_BookId=hb.pkId                                        
    --left join mUserCountryMapping MUS on MUS.UserId=hb.MainAgentID                                        
    left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1                                        
    left join Hotel_BookingGSTDetails HBG on HBG.PKID=HB.pkId                                  
 left join tblSelfBalance tbs on tbs.BookingRef=HB.orderId and  tbs.UserID=HB.MainAgentID                                   
left join tblAgentBalance tbla on (tbla.BookingRef=HB.orderId or tbla.BookingRef=HB.BookingReference) and  tbla.AgentNo=HB.RiyaAgentID                                   
 where (HB.RiyaAgentID=@AgentId or (HB.MainAgentID=@MainAgentId and HB.MainAgentID >0))                                        
    and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                        
    and HB.RiyaAgentID is not null                                                                                                                                           
  --and HH.IsActive=1                                   
 and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')                          
 and (tbs.TransactionType='Credit' or tbla.TransactionType='Credit')                        
                         
 UNION           
 ------------ Cancelled condition     Pay At hotel Condition          
 Select                          
 HH.CreateDate as BookingDate,                                        
 'Cancelled' as BookingStatus,                                    
 case When HB.BookingCountry='IN' then 'Domestic' else 'International' End as TravelType,                                
 HB.BookingReference as BookingId,                                
 HB.SupplierName as SupplierID,                                        
 (HB.LeaderFirstName +''+HB.LeaderLastName) as PaxName,                                        
 ('- '+HB.TotalRoomAmount) as  BaseAmount,                          
 0 as Penalty,                        
 HB.HotelTaxes as TaxesAmt,                                        
 --(isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) as Commission,    
  Case when (HB.SupplierUsername='rt-agoda-sell' or HB.SupplierUsername='rt-agoda-domestic')then 0 else (isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) end as Commission,     
 HB.HotelTDS as TDS,
 isnull(HB.ServiceCharges,0) as ServiceFee,
 isnull(HB.GstAmountOnServiceChagres,0) as GSTOnServiceFee,
 HB.DisplayDiscountRate as Total,                                        
 isnull(tbla.CloseBalance,0) as RemainingBalance,              
 --isnull(tbs.CloseBalance,0) as ClosingSelfBalance,                                   
 isnull(tbla.TransactionType,'') as CreditLimitTransactionType,                                        
 isnull(tbs.TransactionType,'') as SelfBalanceTransactionType,                                 
 HB.CurrencyCode as Currency,                                        
 case when HU.FullName +'-'+HU.UserName is null then bb.AgencyName+'-'+bb.CustomerCOde end as AgentID,                                        
 HB.HotelName as HotelName,                                        
 HB.cityName as  HotelCity,                                        
 HB.HotelAddress1 as HotelAddress,                                        
 HB.CheckInDate as CheckInDate,                                        
 HB.CheckOutDate as CheckOutDate,                                        
 HB.TotalRooms as  NoofRooms,                                        
 HB.SelectedNights as RoomNights,                                        
 HB.TotalAdults as Adults,                                        
 HB.TotalChildren as Children,                                        
 isnull(HPM.Pancard,'') as  PANNumber,                                        
 isnull(HPM.PassportNum,'') as  PassportNo,                                        
 isnull(HPM.Expirydate,'') as  PassportExpiryDate,                                        
 isnull(HBG.GstNumber,'') as   GSTNUMBER,                                        
 isnull(HBG.State,'') as  GSTSTATE,              
 isnull(HB.agentCancellationCharges,0) as agentCancellationCharges,                
 isnull(HB.ModeOfCancellation,'API') As ModeOfCancellation,      
 '' as Remark      
 from Hotel_BookMaster HB  WITH (NOLOCK)                                                                                                       
    join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId and HH.FkStatusId=7                                                             
    join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                       
    join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                                                       
    left join AgentLogin BR1 on HB.RiyaAgentID = BR1.UserId                                                      
    left join muser HU on HU.ID=HB.MainAgentID                                  
 left join B2BRegistration bb on bb.FKUserID=HB.RiyaAgentID                                  
    left join Hotel_ROE_Booking_History RoEB on RoEB.FkBookId=HB.pkId                                        
    left join B2BHotel_Commission BC on BC.Fk_BookId=hb.pkId                                        
    --left join mUserCountryMapping MUS on MUS.UserId=hb.MainAgentID                                        
    left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1                                        
    left join Hotel_BookingGSTDetails HBG on HBG.PKID=HB.pkId                                  
 left join tblSelfBalance tbs on tbs.BookingRef=HB.orderId and  tbs.UserID=HB.MainAgentID                                   
left join tblAgentBalance tbla on (tbla.BookingRef=HB.orderId or tbla.BookingRef=HB.BookingReference) and  tbla.AgentNo=HB.RiyaAgentID                                   
 where (HB.RiyaAgentID=@AgentId or (HB.MainAgentID=@MainAgentId and HB.MainAgentID >0))                                        
    and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                        
    and HB.RiyaAgentID is not null                                                                                                                                           
  --and HH.IsActive=1                                   
 and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')                          
 --and (tbs.TransactionType='Credit' or tbla.TransactionType='Credit')            
 And B2BPaymentMode=5        
 UNION                        
 --------- Reject Condition                        
 Select                          
 HH.CreateDate as BookingDate,                                        
 'Reject' as BookingStatus,                                        
 case When HB.BookingCountry='IN' then 'Domestic' else 'International' End as TravelType,                                
 HB.BookingReference as BookingId,                                
 HB.SupplierName as SupplierID,                                        
 (HB.LeaderFirstName +''+HB.LeaderLastName) as PaxName,                                        
 ('- '+HB.TotalRoomAmount) as  BaseAmount,                          
 0 as Penalty,                        
 HB.HotelTaxes as TaxesAmt,                                        
 --(isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) as Commission,      
  Case when (HB.SupplierUsername='rt-agoda-sell' or HB.SupplierUsername='rt-agoda-domestic')then 0 else (isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) end as Commission,     
 HB.HotelTDS as TDS,
  isnull(HB.ServiceCharges,0) as ServiceFee,
 isnull(HB.GstAmountOnServiceChagres,0) as GSTOnServiceFee,
 HB.DisplayDiscountRate as Total,                                        
 isnull(tbla.CloseBalance,0) as RemainingBalance,                                      
 --isnull(tbs.CloseBalance,0) as ClosingSelfBalance,                                   
 isnull(tbla.TransactionType,'') as CreditLimitTransactionType,                                        
 isnull(tbs.TransactionType,'') as SelfBalanceTransactionType,                                 
 HB.CurrencyCode as Currency,                                        
 case when HU.FullName +'-'+HU.UserName is null then bb.AgencyName+'-'+bb.CustomerCOde end as AgentID,                                        
 HB.HotelName as HotelName,                                        
 HB.cityName as  HotelCity,                                        
 HB.HotelAddress1 as HotelAddress,                                        
 HB.CheckInDate as CheckInDate,                                        
 HB.CheckOutDate as CheckOutDate,                                        
 HB.TotalRooms as  NoofRooms,                                        
 HB.SelectedNights as RoomNights,                          
 HB.TotalAdults as Adults,                                        
 HB.TotalChildren as Children,                                        
 isnull(HPM.Pancard,'') as  PANNumber,                                        
 isnull(HPM.PassportNum,'') as  PassportNo,                                        
 isnull(HPM.Expirydate,'') as  PassportExpiryDate,                                        
 isnull(HBG.GstNumber,'') as   GSTNUMBER,                                        
 isnull(HBG.State,'') as  GSTSTATE,              
 isnull(HB.agentCancellationCharges,0) as agentCancellationCharges,                
 isnull(HB.ModeOfCancellation,'') As ModeOfCancellation,      
 '' as Remark      
 from Hotel_BookMaster HB   WITH (NOLOCK)                                                                                                      
    join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId and HH.FkStatusId=5                                
    join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                                                                                        
    join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                                                       
    left join AgentLogin BR1 on HB.RiyaAgentID = BR1.UserId                                                      
    left join muser HU on HU.ID=HB.MainAgentID                                  
 left join B2BRegistration bb on bb.FKUserID=HB.RiyaAgentID                                  
    left join Hotel_ROE_Booking_History RoEB on RoEB.FkBookId=HB.pkId                                        
    left join B2BHotel_Commission BC on BC.Fk_BookId=hb.pkId                                        
    --left join mUserCountryMapping MUS on MUS.UserId=hb.MainAgentID                                        
    left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1                                        
    left join Hotel_BookingGSTDetails HBG on HBG.PKID=HB.pkId                                  
 left join tblSelfBalance tbs on tbs.BookingRef=HB.orderId and  tbs.UserID=HB.MainAgentID                                   
left join tblAgentBalance tbla on tbla.BookingRef=HB.orderId and  tbla.AgentNo=HB.RiyaAgentID                                   
 where (HB.RiyaAgentID=@AgentId or (HB.MainAgentID=@MainAgentId and HB.MainAgentID >0))                                        
    and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                        
    and HB.RiyaAgentID is not null                                                                                                                                           
    and HH.IsActive=1                                   
 and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')                          
 --and (tbs.TransactionType='Credit' or tbla.TransactionType='Credit')                        
                        
 UNION                        
 ----------- Failed Condition                        
 Select                          
 HH.CreateDate as BookingDate,                                        
 'Failed' as BookingStatus,                                        
 case When HB.BookingCountry='IN' then 'Domestic' else 'International' End as TravelType,                                
 HB.BookingReference as BookingId,                                
 HB.SupplierName as SupplierID,                                        
 (HB.LeaderFirstName +''+HB.LeaderLastName) as PaxName,                                        
 ('- '+HB.TotalRoomAmount) as  BaseAmount,                          
 0 as Penalty,                        
 HB.HotelTaxes as TaxesAmt,                                        
 --(isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) as Commission,         
  Case when (HB.SupplierUsername='rt-agoda-sell' or HB.SupplierUsername='rt-agoda-domestic')then 0 else (isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) end as Commission,     
 HB.HotelTDS as TDS,
  isnull(HB.ServiceCharges,0) as ServiceFee,
 isnull(HB.GstAmountOnServiceChagres,0) as GSTOnServiceFee,
 HB.DisplayDiscountRate as Total,                                        
 isnull(tbla.CloseBalance,0) as RemainingBalance,                                      
 --isnull(tbs.CloseBalance,0) as ClosingSelfBalance,                                   
 isnull(tbla.TransactionType,'') as CreditLimitTransactionType,                                        
 isnull(tbs.TransactionType,'') as SelfBalanceTransactionType,                                 
 HB.CurrencyCode as Currency,                                        
 case when HU.FullName +'-'+HU.UserName is null then bb.AgencyName+'-'+bb.CustomerCOde end as AgentID,                                        
 HB.HotelName as HotelName,                                        
 HB.cityName as  HotelCity,                                        
 HB.HotelAddress1 as HotelAddress,                                        
 HB.CheckInDate as CheckInDate,                                        
 HB.CheckOutDate as CheckOutDate,                                        
 HB.TotalRooms as  NoofRooms,                       
 HB.SelectedNights as RoomNights,                                        
 HB.TotalAdults as Adults,                                        
 HB.TotalChildren as Children,                                        
 isnull(HPM.Pancard,'') as  PANNumber,                                        
 isnull(HPM.PassportNum,'') as  PassportNo,                                        
 isnull(HPM.Expirydate,'') as  PassportExpiryDate,                                        
 isnull(HBG.GstNumber,'') as   GSTNUMBER,                                        
 isnull(HBG.State,'') as  GSTSTATE,              
 isnull(HB.agentCancellationCharges,0) as agentCancellationCharges,                
 isnull(HB.ModeOfCancellation,'') As ModeOfCancellation,      
 '' as Remark      
 from Hotel_BookMaster HB   WITH (NOLOCK)                                                                                                      
    join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId and HH.FkStatusId=11                                                                         
    join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                                                                                        
    join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                                                       
    left join AgentLogin BR1 on HB.RiyaAgentID = BR1.UserId                                                      
    left join muser HU on HU.ID=HB.MainAgentID                                  
 left join B2BRegistration bb on bb.FKUserID=HB.RiyaAgentID                                  
    left join Hotel_ROE_Booking_History RoEB on RoEB.FkBookId=HB.pkId                                        
    left join B2BHotel_Commission BC on BC.Fk_BookId=hb.pkId                                        
    --left join mUserCountryMapping MUS on MUS.UserId=hb.MainAgentID                                        
    left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1                                        
    left join Hotel_BookingGSTDetails HBG on HBG.PKID=HB.pkId                                  
 left join tblSelfBalance tbs on tbs.BookingRef=HB.orderId and  tbs.UserID=HB.MainAgentID                                   
left join tblAgentBalance tbla on tbla.BookingRef=HB.orderId and  tbla.AgentNo=HB.RiyaAgentID                                   
 where (HB.RiyaAgentID=@AgentId or (HB.MainAgentID=@MainAgentId and HB.MainAgentID >0))                                        
    and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                        
    and HB.RiyaAgentID is not null                                                                                                                                           
    and HH.IsActive=1                                   
 and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')                          
 --and (tbs.TransactionType='Credit' or tbla.TransactionType='Credit')                        
                        
 UNION                        
 --------------Pending Condition                        
 Select                          
 HH.CreateDate as BookingDate,                                        
 'Pending' as BookingStatus,                                        
 case When HB.BookingCountry='IN' then 'Domestic' else 'International' End as TravelType,                                
 HB.BookingReference as BookingId,                                
 HB.SupplierName as SupplierID,                                        
 (HB.LeaderFirstName +''+HB.LeaderLastName) as PaxName,                                        
 ('- '+HB.TotalRoomAmount) as  BaseAmount,                          
 0 as Penalty,                        
 HB.HotelTaxes as TaxesAmt,                                        
 --(isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) as Commission,     
  Case when (HB.SupplierUsername='rt-agoda-sell' or HB.SupplierUsername='rt-agoda-domestic')then 0 else (isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) end as Commission,     
 HB.HotelTDS as TDS,
 isnull(HB.ServiceCharges,0) as ServiceFee,
 isnull(HB.GstAmountOnServiceChagres,0) as GSTOnServiceFee,
 HB.DisplayDiscountRate as Total,                                        
 isnull(tbla.CloseBalance,0) as RemainingBalance,                                      
 --isnull(tbs.CloseBalance,0) as ClosingSelfBalance,                                   
 isnull(tbla.TransactionType,'') as CreditLimitTransactionType,                                        
 isnull(tbs.TransactionType,'') as SelfBalanceTransactionType,                        HB.CurrencyCode as Currency,                                        
 case when HU.FullName +'-'+HU.UserName is null then bb.AgencyName+'-'+bb.CustomerCOde end as AgentID,                                        
 HB.HotelName as HotelName,                                        
 HB.cityName as  HotelCity,                                        
 HB.HotelAddress1 as HotelAddress,                                        
 HB.CheckInDate as CheckInDate,                                        
 HB.CheckOutDate as CheckOutDate,                                        
 HB.TotalRooms as  NoofRooms,                                        
 HB.SelectedNights as RoomNights,                                        
 HB.TotalAdults as Adults,                                        
 HB.TotalChildren as Children,                                        
 isnull(HPM.Pancard,'') as  PANNumber,                                        
 isnull(HPM.PassportNum,'') as  PassportNo,                                        
 isnull(HPM.Expirydate,'') as  PassportExpiryDate,                                        
 isnull(HBG.GstNumber,'') as   GSTNUMBER,                                        
 isnull(HBG.State,'') as  GSTSTATE,              
 isnull(HB.agentCancellationCharges,0) as agentCancellationCharges,                
 isnull(HB.ModeOfCancellation,'') As ModeOfCancellation,      
 '' as Remark      
 from Hotel_BookMaster HB   WITH (NOLOCK)                                                                                                    
    join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId and HH.FkStatusId=10         
    join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                                                                                        
    join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                                                       
    left join AgentLogin BR1 on HB.RiyaAgentID = BR1.UserId                                                      
    left join muser HU on HU.ID=HB.MainAgentID                                  
 left join B2BRegistration bb on bb.FKUserID=HB.RiyaAgentID              
    left join Hotel_ROE_Booking_History RoEB on RoEB.FkBookId=HB.pkId                                        
    left join B2BHotel_Commission BC on BC.Fk_BookId=hb.pkId                                        
    --left join mUserCountryMapping MUS on MUS.UserId=hb.MainAgentID                                        
    left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1                                        
    left join Hotel_BookingGSTDetails HBG on HBG.PKID=HB.pkId                                  
 left join tblSelfBalance tbs on tbs.BookingRef=HB.orderId and  tbs.UserID=HB.MainAgentID                                   
left join tblAgentBalance tbla on tbla.BookingRef=HB.orderId and  tbla.AgentNo=HB.RiyaAgentID                                   
 where (HB.RiyaAgentID=@AgentId or (HB.MainAgentID=@MainAgentId and HB.MainAgentID >0))                                        
    and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                        
    and HB.RiyaAgentID is not null                                                                                                           
    and HH.IsActive=1                                   
 and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')                          
 --and (tbs.TransactionType='Credit' or tbla.TransactionType='Credit')                        
                        
 UNION                        
 -------------- InProcess Condition                        
 Select                          
 HH.CreateDate as BookingDate,                      
 'InProcess' as BookingStatus,                                        
 case When HB.BookingCountry='IN' then 'Domestic' else 'International' End as TravelType,                                
 HB.BookingReference as BookingId,                                
 HB.SupplierName as SupplierID,                                        
 (HB.LeaderFirstName +''+HB.LeaderLastName) as PaxName,                                        
 ('- '+HB.TotalRoomAmount) as  BaseAmount,                          
 0 as Penalty,                        
 HB.HotelTaxes as TaxesAmt,                                        
 --(isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) as Commission,            
  Case when (HB.SupplierUsername='rt-agoda-sell' or HB.SupplierUsername='rt-agoda-domestic')then 0 else (isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) end as Commission,     
 HB.HotelTDS as TDS, 
  isnull(HB.ServiceCharges,0) as ServiceFee,
 isnull(HB.GstAmountOnServiceChagres,0) as GSTOnServiceFee,
 HB.DisplayDiscountRate as Total,                                        
 isnull(tbla.CloseBalance,0) as RemainingBalance,                                      
 --isnull(tbs.CloseBalance,0) as ClosingSelfBalance,                                   
 isnull(tbla.TransactionType,'') as CreditLimitTransactionType,                                        
 isnull(tbs.TransactionType,'') as SelfBalanceTransactionType,                                 
 HB.CurrencyCode as Currency,                                        
 case when HU.FullName +'-'+HU.UserName is null then bb.AgencyName+'-'+bb.CustomerCOde end as AgentID,                                        
 HB.HotelName as HotelName,                    
 HB.cityName as  HotelCity,                                        
 HB.HotelAddress1 as HotelAddress,                                        
 HB.CheckInDate as CheckInDate,                                        
 HB.CheckOutDate as CheckOutDate,                                        
 HB.TotalRooms as  NoofRooms,                                        
 HB.SelectedNights as RoomNights,                                        
 HB.TotalAdults as Adults,                                        
 HB.TotalChildren as Children,                                        
 isnull(HPM.Pancard,'') as  PANNumber,                      
 isnull(HPM.PassportNum,'') as  PassportNo,                                        
 isnull(HPM.Expirydate,'') as  PassportExpiryDate,                                        
 isnull(HBG.GstNumber,'') as   GSTNUMBER,                                        
 isnull(HBG.State,'') as  GSTSTATE,              
 isnull(HB.agentCancellationCharges,0) as agentCancellationCharges,                
 isnull(HB.ModeOfCancellation,'') As ModeOfCancellation,      
 '' as Remark      
 from Hotel_BookMaster HB  WITH (NOLOCK)                                                                                                     
    join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId and HH.FkStatusId=9                                                                    
    join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                                         
    join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                                                       
    left join AgentLogin BR1 on HB.RiyaAgentID = BR1.UserId                                                      
    left join muser HU on HU.ID=HB.MainAgentID                                  
 left join B2BRegistration bb on bb.FKUserID=HB.RiyaAgentID                                  
    left join Hotel_ROE_Booking_History RoEB on RoEB.FkBookId=HB.pkId                                        
    left join B2BHotel_Commission BC on BC.Fk_BookId=hb.pkId                                        
    --left join mUserCountryMapping MUS on MUS.UserId=hb.MainAgentID                                        
    left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1                                        
    left join Hotel_BookingGSTDetails HBG on HBG.PKID=HB.pkId                                  
 left join tblSelfBalance tbs on tbs.BookingRef=HB.orderId and  tbs.UserID=HB.MainAgentID                                   
left join tblAgentBalance tbla on tbla.BookingRef=HB.orderId and  tbla.AgentNo=HB.RiyaAgentID                                   
 where (HB.RiyaAgentID=@AgentId or (HB.MainAgentID=@MainAgentId and HB.MainAgentID >0))                                        
    and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                        
    and HB.RiyaAgentID is not null                                                           
    and HH.IsActive=1                                   
 and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')                          
 --and (tbs.TransactionType='Credit' or tbla.TransactionType='Credit')                        
UNION      
------Agent credit debit Antry      
Select                          
 tbla.CreatedOn as BookingDate,                      
 '' as BookingStatus,                                        
 ''  as TravelType,                                
 '' as BookingId,                                
 '' as SupplierID,                                        
 '' as PaxName,                                        
 isnull(HB.TotalRoomAmount,0) as  BaseAmount,                          
 0 as Penalty,                        
 HB.HotelTaxes as TaxesAmt,                                        
 --(isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) as Commission,       
  Case when (HB.SupplierUsername='rt-agoda-sell' or HB.SupplierUsername='rt-agoda-domestic')then 0 else (isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) end as Commission,     
 isnull(HB.HotelTDS,0) as TDS,
  isnull(HB.ServiceCharges,0) as ServiceFee,
 isnull(HB.GstAmountOnServiceChagres,0) as GSTOnServiceFee,
 isnull(HB.DisplayDiscountRate,0) as Total,                                          
 isnull(tbla.CloseBalance,0) as RemainingBalance,                                      
 --isnull(tbs.CloseBalance,0) as ClosingSelfBalance,                                   
 isnull(tbla.TransactionType,'') as CreditLimitTransactionType,                                        
 '' as SelfBalanceTransactionType,                                 
 '' as Currency,                                        
 case when HU.FullName +'-'+HU.UserName is null then bb.AgencyName+'-'+bb.CustomerCOde end as AgentID,                                        
 '' as HotelName,                    
 '' as  HotelCity,                                        
 '' as HotelAddress,                                        
 '' as CheckInDate,                                        
'' as CheckOutDate,                                        
 '' as  NoofRooms,                                        
 '' as RoomNights,                                        
 '' as Adults,                                        
 '' as Children,                                        
 '' as  PANNumber,                      
 '' as  PassportNo,                                        
 '' as  PassportExpiryDate,                                        
 '' as   GSTNUMBER,                                        
 '' as  GSTSTATE,              
 isnull(HB.agentCancellationCharges,0) as agentCancellationCharges,                
'' As ModeOfCancellation,         
tbla.Remark as Remark      
 from tblAgentBalance tbla    
 left join Hotel_BookMaster HB on HB.orderId=tbla.BookingRef      
 join B2BRegistration BR on tbla.AgentNo=BR.FKUserID                                                       
 left join AgentLogin BR1 on tbla.AgentNo = BR1.UserId                                                      
 left join muser HU on HU.ID=tbla.AgentNo                                  
 left join B2BRegistration bb on bb.FKUserID=tbla.AgentNo                                                                           
 where tbla.AgentNo=@AgentId and                                 
 tbla.BookingRef='Credit'      
 and  ((Convert(date,tbla.CreatedOn) >= Convert(date,@FromDate) and Convert(date,tbla.CreatedOn) < @ToDate))         
UNION                        
 ----- Not Found Condition                        
 Select                          
 HH.CreateDate as BookingDate,                                        
 'Not Found' as BookingStatus,                                        
 case When HB.BookingCountry='IN' then 'Domestic' else 'International' End as TravelType,                  
 HB.BookingReference as BookingId,                                
 HB.SupplierName as SupplierID,                                        
 (HB.LeaderFirstName +''+HB.LeaderLastName) as PaxName,                                        
 ('- '+HB.TotalRoomAmount) as  BaseAmount,                          
 0 as Penalty,                        
 HB.HotelTaxes as TaxesAmt,                                        
--(isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) as Commission,             
 Case when (HB.SupplierUsername='rt-agoda-sell' or HB.SupplierUsername='rt-agoda-domestic')then 0 else (isnull(HB.AgentCommission,0)+isnull(HB.HotelTDS,0)) end as Commission,     
 HB.HotelTDS as TDS,
 isnull(HB.ServiceCharges,0) as ServiceFee,
 isnull(HB.GstAmountOnServiceChagres,0) as GSTOnServiceFee,
 HB.DisplayDiscountRate as Total,                                        
 isnull(tbla.CloseBalance,0) as RemainingBalance,                                      
 --isnull(tbs.CloseBalance,0) as ClosingSelfBalance,                                   
 isnull(tbla.TransactionType,'') as CreditLimitTransactionType,                                        
 isnull(tbs.TransactionType,'') as SelfBalanceTransactionType,                                 
 HB.CurrencyCode as Currency,                                        
 case when HU.FullName +'-'+HU.UserName is null then bb.AgencyName+'-'+bb.CustomerCOde end as AgentID,                                        
 HB.HotelName as HotelName,                                        
 HB.cityName as  HotelCity,                                        
 HB.HotelAddress1 as HotelAddress,                                        
 HB.CheckInDate as CheckInDate,                      
 HB.CheckOutDate as CheckOutDate,                                        
 HB.TotalRooms as  NoofRooms,                                        
 HB.SelectedNights as RoomNights,                                        
 HB.TotalAdults as Adults,                             
 HB.TotalChildren as Children,                                        
 isnull(HPM.Pancard,'') as  PANNumber,                                        
 isnull(HPM.PassportNum,'') as  PassportNo,                                        
 isnull(HPM.Expirydate,'') as  PassportExpiryDate,                                        
 isnull(HBG.GstNumber,'') as   GSTNUMBER,                                        
 isnull(HBG.State,'') as  GSTSTATE,              
 isnull(HB.agentCancellationCharges,0) as agentCancellationCharges,                
 isnull(HB.ModeOfCancellation,'') As ModeOfCancellation,      
 '' as Remark      
 from Hotel_BookMaster HB  WITH (NOLOCK)                                                                                                       
    join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId and HH.FkStatusId=13                                                                    
    join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                                                                                        
    join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                                                       
    left join AgentLogin BR1 on HB.RiyaAgentID = BR1.UserId                                                      
    left join muser HU on HU.ID=HB.MainAgentID                                  
 left join B2BRegistration bb on bb.FKUserID=HB.RiyaAgentID                                  
    left join Hotel_ROE_Booking_History RoEB on RoEB.FkBookId=HB.pkId                                        
    left join B2BHotel_Commission BC on BC.Fk_BookId=hb.pkId                                        
    --left join mUserCountryMapping MUS on MUS.UserId=hb.MainAgentID                                        
    left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1            
    left join Hotel_BookingGSTDetails HBG on HBG.PKID=HB.pkId                                  
 left join tblSelfBalance tbs on tbs.BookingRef=HB.orderId and  tbs.UserID=HB.MainAgentID                                   
left join tblAgentBalance tbla on tbla.BookingRef=HB.orderId and  tbla.AgentNo=HB.RiyaAgentID                                   
 where (HB.RiyaAgentID=@AgentId or (HB.MainAgentID=@MainAgentId and HB.MainAgentID >0))                                        
    and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                        
    and HB.RiyaAgentID is not null                                     
    and HH.IsActive=1                                   
 and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')                          
 --and (tbs.TransactionType='Credit' or tbla.TransactionType='Credit')                        
                        
 order by HH.CreateDate ASC                        
                        
End