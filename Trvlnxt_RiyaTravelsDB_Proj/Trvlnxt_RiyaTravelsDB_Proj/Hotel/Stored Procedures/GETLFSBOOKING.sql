            
--===========================================================================================================================================    
-- Date : 19 Feb 2025     
-- Use : To Get All the booking which is eligible for the LFS.    
-- Author : Akash Singh    
-- Exce HOTEL.GETLFSBOOKING    
--===========================================================================================================================================    
    
CREATE PROC HOTEL.GETLFSBOOKING                   
AS                
BEGIN                
                
  select       
   BM.pkId,BM.inserteddate, BookingReference, riyaPNR as RiyaPNR, CheckInDate, CheckOutDate, CancellationDeadLine,      
   ExpirationDate, SH.FkStatusId, FullRefund, Refundable, isnull(IsRefunded,0) IsRefunded,              
   orderId, searchApiId, B2BPaymentMode, DisplayDiscountRate, expected_prize, TotalCharges,      
   AgentRate, FinalROE, ROEValue, MarkupCurrency, SupplierCurrencyCode, SupplierName,      
   SupplierReferenceNo, SupplierRate, SupplierUsername, providerConfirmationNumber, Meal,      
   ChannelId, AccountId, hotelId, HotelName, CountryName, CityId, cityName,      
   HotelAddress1, TotalAdults, TotalRooms, TotalChildren, SelectedNights, DestinationCountryCode,    
   Cast(isnull(IsPANCardRequired,0) as bit) as IsPANCardRequired ,AgentCommission,MU.FullName,MU.UserName,    
   BR.Icast AS Icust,BR.AgencyName,cast(isnull(BM.inserteddate,'') as varchar) as 'BookingDate',
    Case 
     WHEN BookingPortal='TNH' THEN 'TRVLNXT'
	 WHEN BookingPortal='TNHAPI' THEN 'API-OUT'
	 ELSE 'UNKNOWN' 
	 END as 'BookingPortal'
                   
  from Hotel_BookMaster BM with(nolock)                 
  join Hotel_Status_History SH on BM.pkId=SH.FKHotelBookingId    
  left join mUser MU WITH(NOLOCK) on BM.MainAgentID=MU.ID     
  left join B2BRegistration BR WITH(NOLOCK) on BM.RiyaAgentID=BR.FKUserID                                                                                                               
    
  where           
  --BookingReference not like '%API%' and          
  SH.IsActive=1 and                
  SH.FkStatusId =4 and                
  Refundable=1 and                
  CheckInDate > DATEADD(day, 7, GETDATE()) and               
  ExpirationDate > DATEADD(day, 7,GETDATE())              
  order by BM.pkId   DESC              
            
END



--Select * from Hotel_Status_Master
